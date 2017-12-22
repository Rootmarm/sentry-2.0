unit uHistoryBot;

interface

uses
  Classes, uVTHttpWrapper, HttpProt;

const
  rgHEAD = 0;
  rgGET  = 1;
  rgPOST = 2;

type
  TBanEvent = procedure(Sender : TObject; BanIndex: integer; strReason: string) of object;
  TJudgement = (judGood, judBad, judRedirect, judTimeout, judRetry);

  THistoryBot = class(TVTHttpCli)
  protected
    FJudgement                     : TJudgement;
    FAfterFP                       : boolean;
    FBeforeFP                      : boolean;
    FEnableAfterFP                 : boolean;
    FCheckHit                      : boolean;
    FEnableCheckHit                : boolean;
    FBeforeFPComplete              : boolean;
    FRequestMethod                 : integer;
    FSourceLength                  : integer;
    FOriginalUsername              : string;
    FOriginalPassword              : string;
    FFailureKeys                   : string;
    FSuccessKeys                   : string;
    FPOSTData                      : string;
    FOnUpdateListview              : TNotifyEvent;
    FOnBeforeFPComplete            : TNotifyEvent;
    FOnBanProxy                    : TBanEvent;
    FOnDisableProxy                : TBanEvent;
    FOnSetProxy                    : TNotifyEvent;

    procedure TriggerRequestDone; override;
    procedure GetAfterFingerprint;
    procedure CheckHit;
    procedure TriggerUpdateListview(strStatus: string);
    procedure TriggerBanProxy(const iIndex: integer; strReason: string = '');
    procedure TriggerDisableProxy(const iIndex: integer; strReason: string = '');
    procedure TriggerSetProxy;
    procedure TriggerBeforeFPComplete;
    function  ParseKeywords(blnSuccess: boolean): boolean;
    function  CheckKeywords: boolean;
  public
    constructor Create(Aowner: TComponent); override;
    procedure   ClearVariables;
    procedure   GetBeforeFingerprint;

    property BeforeFPComplete : boolean           read  FBeforeFPComplete;
    property EnableAfterFP    : boolean           read  FEnableAfterFP
                                                  write FEnableAfterFP;
    property EnableCheckHit   : boolean           read  FEnableCheckHit
                                                  write FEnableCheckHit;
    property FailureKeys      : string            read  FFailureKeys
                                                  write FFailureKeys;
    property Judgement        : TJudgement        read  FJudgement
                                                  write FJudgement;
    property POSTData         : string            read  FPOSTData
                                                  write FPOSTData;
    property RequestMethod    : integer           read  FRequestMethod
                                                  write FRequestMethod;
    property SuccessKeys      : string            read  FSuccessKeys
                                                  write FSuccessKeys;
    property OnUpdateListview : TNotifyEvent      read  FOnUpdateListview
                                                  write FOnUpdateListview;
    property OnBeforeFPComplete : TNotifyEvent    read  FOnBeforeFPComplete
                                                  write FOnBeforeFPComplete;
    property OnBanProxy       : TBanEvent         read  FOnBanProxy
                                                  write FOnBanProxy;
    property OnDisableProxy   : TBanEvent         read  FOnDisableProxy
                                                  write FOnDisableProxy;
    property OnSetProxy       : TNotifyEvent      read  FOnSetProxy
                                                  write FOnSetProxy;
  end;

implementation

uses SysUtils, uFunctions, FastStrings, FastStringFuncs;

{ THistoryBot }

{------------------------------------------------------------------------------}
 constructor THistoryBot.Create(Aowner: TComponent);
  begin
   inherited;

   FVirtual := True;
   FRequestVer                      := '1.1';
   FConnection                      := 'keep-alive';
  end;
{------------------------------------------------------------------------------}
// If both Fake protections are enabled, After FP is called first.
// If After FP succeeds, then CheckHits is called next.
 procedure THistoryBot.TriggerRequestDone;
  var iDeltaLength: integer;

  begin
   case FStatusCode of
    200:
     begin
      if (FRequestMethod <> rgHEAD) and (CheckKeywords) then
       begin
        inherited;
        Exit;
       end;

      if FRequestMethod <> rgPOST then
       begin
        // Called on 200 after an After Fingerprint
        if FAfterFP then
         TriggerBanProxy (Tag, '200 - Fake (After Fingerprint Failed)')
        // Called on 200 after Check Hit
        else if FCheckHit then
         FJudgement := judGood
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
          else
           FJudgement := judGood;
         end;
       end
      else // POST 200 reply
       begin
        FreeAndNil (FSendStream);
        if FBeforeFP then
         begin
          FSourceLength := Length (FSource);

          FBeforeFP := False;
          FBeforeFPComplete := True;
          TriggerBeforeFPComplete;
          Exit;
         end
        // Check Keywords, if they don't exist, we need to compare source lengths
        else if CheckKeywords = False then
         begin
          iDeltaLength := Abs (FSourceLength - Length (FSource));

          if iDeltaLength > 5000 then
           begin
            FJudgement := judGood;
            FStatus := 'Documents differ by ' + IntToStr (iDeltaLength) + ' bytes (Greater than 5000)';
           end
          // Check to see if a <form tag is in source
          else if (iDeltaLength > 1000) and (FastPosNoCase (FSource, '<FORM', Length (FSource), 5, 1) = 0) then
           begin
            FJudgement := judGood;
            FStatus := 'Delta = ' + IntToStr (iDeltaLength) + ' which is < 5000 but no Form Tags';
           end
          else
           FStatus := 'Documents differ by ' + IntToStr (iDeltaLength) + ' bytes (Less than 5000) or Form Tags found';
         end;
       end;
     end;

    302:
     begin
      FJudgement := judRedirect;
      TriggerDisableProxy (Tag);
     end;

    401:
     begin
      // After FP succeeded, start Check Hit if necessary
      if FAfterFP then
       begin
        // Restore Original Username and Password
        if FEnableCheckHit then
         begin
          FUsername := FOriginalUsername;
          FPassword := FOriginalPassword;
          CheckHit;
          Exit;
         end;

        FJudgement := judGood;
        FStatus := '401 - After Fingerprint Succeeded';
       end
      else
       FJudgement := judBad;
     end;
    else
     begin
      // Timeouts are not retried, but the proxy is still banned
      if FReasonPhrase = 'Timeout' then
       begin
        TriggerDisableProxy (Tag, IntToStr (FStatusCode) + ' - ' + FReasonPhrase);
        FJudgement := judTimeout;
       end;

      if FAfterFP then
       FJudgement := judRetry
      else if (FCheckHit) or (FBeforeFP) then
       begin
        TriggerDisableProxy (Tag, IntToStr (FStatusCode) + ' - ' + FReasonPhrase);
        TriggerSetProxy;
        FJudgement := judRetry;
       end;
     end;
   end;

   inherited;
  end;
{------------------------------------------------------------------------------}
 procedure THistoryBot.ClearVariables;
  begin
   FJudgement := judBad;
   FAfterFP := False;
   FCheckHit := False;
   FOriginalUsername := '';
   FOriginalPassword := '';
   FSourceLength := 0;
   FBeforeFPComplete := False;
  end;
{------------------------------------------------------------------------------}
 procedure THistoryBot.GetAfterFingerprint;
  begin
   TriggerUpdateListview ('Getting After Fingerprint');

   FAfterFP := True;

   // Store the original combo
   FOriginalUsername := FUsername;
   FOriginalPassword := FPassword;

   FUsername := RandomStr (8);
   FPassword := RandomStr (8);

   case FRequestMethod of
    rgHEAD: HeadAsync;
    rgGET:  GetAsync;
   end;
  end;
{------------------------------------------------------------------------------}
 procedure THistoryBot.CheckHit;
  begin
   TriggerUpdateListview ('Checking with another proxy');

   FCheckHit := True;
   FAfterFP := False;
   TriggerSetProxy;

   case FRequestMethod of
    rgHEAD: HeadAsync;
    rgGET:  GetAsync;
   end;
  end;
{------------------------------------------------------------------------------}
 procedure THistoryBot.TriggerUpdateListview(strStatus: string);
  begin
   FStatus := strStatus;
   if Assigned (FOnUpdateListview) then
    FOnUpdateListview (Self);
  end;
{------------------------------------------------------------------------------}
 procedure THistoryBot.TriggerBanProxy(const iIndex: integer; strReason: string = '');
  begin
   if strReason <> '' then
    FStatus := strReason;

   if Assigned (FOnBanProxy) then
    FOnBanProxy (Self, Tag, FStatus);
  end;
{------------------------------------------------------------------------------}
 procedure THistoryBot.TriggerDisableProxy(const iIndex: integer; strReason: string = '');
  begin
   if strReason <> '' then
    FStatus := strReason;

   if Assigned (FOnDisableProxy) then
    FOnDisableProxy (Self, Tag, FStatus);
  end;
{------------------------------------------------------------------------------}
 procedure THistoryBot.TriggerSetProxy;
  begin
   if Assigned (FOnSetProxy) then
    FOnSetProxy (Self);
  end;
{------------------------------------------------------------------------------}
 procedure THistoryBot.TriggerBeforeFPComplete;
  begin
   if Assigned (FOnBeforeFPComplete) then
    FOnBeforeFPComplete (Self);
  end;
{------------------------------------------------------------------------------}
// Returns True when a Hit is found
 function THistoryBot.ParseKeywords(blnSuccess: boolean): boolean;
  var strKeys, strCurrent, strPrefix: string;
      I, iSourceLength: integer;

  begin
   Result := False;
   
   iSourceLength := Length (FSource);
   if iSourceLength = 0 then
    Exit;

   if blnSuccess then
    begin
     strKeys := FSuccessKeys;
     strPrefix := 'Success';
    end
   else
    begin
     strKeys := FFailureKeys;
     strPrefix := 'Failure';
    end;

   // Loop ends naturally only when no keywords are found
   while Length (strKeys) <> 0 do
    begin
     // ";" cannot be the last character of the string
     // A check is made former so the user can't do this
     I := FastCharPos (strKeys, ';', 1);

     if I = 0 then
      // Last Keyword
      begin
       // Found a keyword, if success keywords, then we found a hit
       // if failure keywords, we found a failure
       Result := (FastPos (FSource, strKeys, iSourceLength, Length (strKeys), 1) <> 0);
       if Result then
        begin
         Result := blnSuccess;
         FStatus := 'Found ' + strPrefix + ' Keyword [ ' + strKeys + ' ]';
         Break;
        end
       else
        FStatus := strPrefix + ' Keyword Not Found';

       // Breaks the Loop because we didn't find a keyword
       // and no more words left to try
       strKeys := '';
       Result := not blnSuccess;
      end
     else
      begin
       strCurrent := CopyStr (strKeys, 1, I - 1);
       Result := (FastPos (FSource, strCurrent, iSourceLength, Length (strCurrent), 1) <> 0);

       if Result then
        begin
         // Found a keyword, if success keywords, then we found a hit
         // if failure keywords, we found a failure
         Result := blnSuccess;
         FStatus := 'Found ' + strPrefix + ' Keyword [ ' + strCurrent + ' ]';
         Break;
        end;

       strKeys := CopyStr (strKeys, I + 1, Length (strKeys));
      end;
    end;
  end;
{------------------------------------------------------------------------------}
// Returns True if a keyword check has been made
 function THistoryBot.CheckKeywords: boolean;
  begin
   Result := False;

   if FSuccessKeys <> '' then
    begin
     Result := True;

     if ParseKeywords (True) then
      begin
       FJudgement := judGood;
       // Success Keyword check passed, no need to check Failure Keywords
       Exit;
      end;
    end;

   if FFailureKeys <> '' then
    begin
     Result := True;

     if ParseKeywords (False) then
      FJudgement := judGood;
    end;
  end;
{------------------------------------------------------------------------------}
// Only used when no keywords are assigned for POST
 procedure THistoryBot.GetBeforeFingerprint;
  var strUsername, strPassword, strPOSTData: string;

  begin
   TriggerUpdateListview ('Getting Before Fingerprint');

   FBeforeFP := True;

   strUsername := RandomStr (8);
   strPassword := RandomStr (8);

   strPOSTData := FastReplace (FPOSTData, '<USER>', strUsername);
   strPOSTData := FastReplace (strPOSTData, '<PASS>', strPassword);

   SetPOSTData (TMemoryStream (FSendStream), strPOSTData);

   PostAsync;
  end;
{------------------------------------------------------------------------------}
end.

