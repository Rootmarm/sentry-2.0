// Class that implements keyword checking into TVTHttpCli
// This class is meant to be subclassed, and never created
// directly.
//
// This class also serves as the last common unit between
// TBasicBot and TFormBot

unit uKeywordBot;

interface

uses
  Classes, uVTHttpWrapper;

type
  TJudgement = (judGood, judBad, judRedirect, judTimeout, judRetry);

  TBanEvent = procedure(Sender: TObject; BanIndex: integer; strReason: string) of object;
  TFakeEvent = procedure(Sender: TObject; const strCombo: string; const iPIndex: integer) of object;

  TKeywordBot = class(TVTHttpCli)
  protected
    FLockHeader                    : boolean; // If true, the header will not be changed
    FJudgement                     : TJudgement;

    FHeaderFailureKeys             : string;
    FHeaderSuccessKeys             : string;
    FSourceFailureKeys             : string;
    FSourceSuccessKeys             : string;

    // Used in Bruteforcer engine for debug purposes
    FSentHeader                    : string;

    // This stores the amount of retries a combo has been banned.
    // Prevents infinite loop of banning proxies if the combo was
    // the reason for the banning.
    FBannedRetry                   : integer;

    // Both TStrings must be created and destroyed by the Engine.
    // These are just pointers to the Engine's Lists
    FHeaderRetryCodes              : TStrings;
    FBanKeywords                   : TStrings;

    FOnBanProxy                    : TBanEvent;
    FOnDisableProxy                : TBanEvent;
    FOnSetProxy                    : TNotifyEvent;
    FOnUpdateListview              : TNotifyEvent;

    procedure TriggerUpdateListview(const strStatus: string); virtual;
    procedure TriggerBanProxy(const iIndex: integer; strReason: string = ''); virtual;
    procedure TriggerDisableProxy(const iIndex: integer; strReason: string = ''); virtual;
    procedure TriggerSetProxy; virtual;
    procedure CheckBanKeyword(const strKeyword: string);
    function  ParseKeywords(blnSuccess: boolean; blnHeader: boolean = False): boolean;
    function  CheckKeywords(blnHeader: boolean = False): boolean;
    function  CheckHeaderRetry: boolean;
    procedure InternalClear; override;
  public
    procedure ClearVariables; virtual;

    property BanKeywords      : TStrings          read  FBanKeywords
                                                  write FBanKeywords;
    property HeaderFailureKeys: string            read  FHeaderFailureKeys
                                                  write FHeaderFailureKeys;
    property HeaderRetryCodes : TStrings          read  FHeaderRetryCodes
                                                  write FHeaderRetryCodes;
    property HeaderSuccessKeys: string            read  FHeaderSuccessKeys
                                                  write FHeaderSuccessKeys;
    property Judgement        : TJudgement        read  FJudgement;
    property LockHeader       : boolean           read  FLockHeader
                                                  write FLockHeader;
    property SentHeader       : string            read  FSentHeader
                                                  write FSentHeader;
    property SourceFailureKeys: string            read  FSourceFailureKeys
                                                  write FSourceFailureKeys;
    property SourceSuccessKeys: string            read  FSourceSuccessKeys
                                                  write FSourceSuccessKeys;

    property OnBanProxy       : TBanEvent         read  FOnBanProxy
                                                  write FOnBanProxy;
    property OnDisableProxy   : TBanEvent         read  FOnDisableProxy
                                                  write FOnDisableProxy;
    property OnSetProxy       : TNotifyEvent      read  FOnSetProxy
                                                  write FOnSetProxy;
    property OnUpdateListview : TNotifyEvent      read  FOnUpdateListview
                                                  write FOnUpdateListview;
  end;

implementation

uses SysUtils, FastStrings, FastStringFuncs;

{ TKeywordBot }

{------------------------------------------------------------------------------}
 procedure TKeywordBot.ClearVariables;
  begin
   FLockHeader := False;
   FBannedRetry := 0;
   FJudgement := judBad;
  end;
{------------------------------------------------------------------------------}
 procedure TKeywordBot.TriggerUpdateListview(const strStatus: string);
  begin
   FStatus := strStatus;
   if Assigned (FOnUpdateListview) then
    FOnUpdateListview (Self);
  end;
{------------------------------------------------------------------------------}
 procedure TKeywordBot.TriggerBanProxy(const iIndex: integer; strReason: string = '');
  begin
   if strReason <> '' then
    FStatus := strReason;

   if Assigned (FOnBanProxy) then
    FOnBanProxy (Self, iIndex, FStatus);
  end;
{------------------------------------------------------------------------------}
 procedure TKeywordBot.TriggerDisableProxy(const iIndex: integer; strReason: string = '');
  begin
   if strReason <> '' then
    FStatus := strReason;

   if Assigned (FOnDisableProxy) then
    FOnDisableProxy (Self, iIndex, FStatus);
  end;
{------------------------------------------------------------------------------}
 procedure TKeywordBot.TriggerSetProxy;
  begin
   if Assigned (FOnSetProxy) then
    FOnSetProxy (Self);
  end;
{------------------------------------------------------------------------------}
// Checks the keyword against a list of banned keywords
 procedure TKeywordBot.CheckBanKeyword(const strKeyword: string);
  const BANNED_RETRIES = 5;

  begin
   if Assigned (FBanKeywords) then
    begin
     if FBanKeywords.IndexOf (strKeyword) <> -1 then
      begin
       TriggerBanProxy (Tag, 'Found Ban Keyword [ ' + strKeyword + ' ]');
       TriggerSetProxy;
       Inc (FBannedRetry);

       if FBannedRetry < BANNED_RETRIES then
        FJudgement := judRetry
       else
        FJudgement := judBad;
      end;
    end;
  end;
{------------------------------------------------------------------------------}
// Returns True when a Hit is found
 function TKeywordBot.ParseKeywords(blnSuccess: boolean; blnHeader: boolean = False): boolean;
  var strKeys, strCurrent, strPrefix, strSource: string;
      I, iSourceLength: integer;

  begin
   Result := False;

   // Assign the strSource as Header
   if blnHeader then
    begin
     if blnSuccess then
      begin
       strKeys := FHeaderSuccessKeys;
       strPrefix := 'Success';
      end
     else
      begin
       strKeys := FHeaderFailureKeys;
       strPrefix := 'Failure';
      end;

     strPrefix := strPrefix + ' Header';
     strSource := FRcvdHeader.Text;
    end
   // Assign strSource as FSource
   else
    begin
     if blnSuccess then
      begin
       strKeys := FSourceSuccessKeys;
       strPrefix := 'Success';
      end
     else
      begin
       strKeys := FSourceFailureKeys;
       strPrefix := 'Failure';
      end;

     strPrefix := strPrefix + ' Source';
     strSource := FSource;
    end;

   iSourceLength := Length (strSource);
   if iSourceLength = 0 then
    Exit;

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
       Result := (FastPos (strSource, strKeys, iSourceLength, Length (strKeys), 1) <> 0);
       if Result then
        begin
         Result := blnSuccess;
         FStatus := 'Found ' + strPrefix + ' Keyword [ ' + strKeys + ' ]';

         // If it is a Failure Keyword Found, check to see
         // if it is on the ban list
         if blnSuccess = False then
          CheckBanKeyword (strKeys);

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
       Result := (FastPos (strSource, strCurrent, iSourceLength, Length (strCurrent), 1) <> 0);

       if Result then
        begin
         // Found a keyword, if success keywords, then we found a hit
         // if failure keywords, we found a failure
         Result := blnSuccess;
         FStatus := 'Found ' + strPrefix + ' Keyword [ ' + strCurrent + ' ]';

         // If it is a Failure Keyword Found, check to see
         // if it is on the ban list
         if blnSuccess = False then
          CheckBanKeyword (strCurrent);

         Break;
        end;

       strKeys := CopyStr (strKeys, I + 1, Length (strKeys));
      end;
    end;
  end;
{------------------------------------------------------------------------------}
// Returns True if a keyword check has been made
 function TKeywordBot.CheckKeywords(blnHeader: boolean = False): boolean;
  var strSuccessKeys, strFailureKeys: string;

  begin
   Result := False;

   if blnHeader then
    begin
     strSuccessKeys := FHeaderSuccessKeys;
     strFailureKeys := FHeaderFailureKeys;
    end
   else
    begin
     strSuccessKeys := FSourceSuccessKeys;
     strFailureKeys := FSourceFailureKeys;
    end;

   if strSuccessKeys <> '' then
    begin
     Result := True;

     if ParseKeywords (True, blnHeader) then
      begin
       FJudgement := judGood;
       // Success Keyword check passed, no need to check Failure Keywords
       Exit;
      end;
    end;

   if strFailureKeys <> '' then
    begin
     Result := True;

     if ParseKeywords (False, blnHeader) then
      FJudgement := judGood;
    end;
  end;
{------------------------------------------------------------------------------}
// Returns True if StatusCode is one that needs to be Retried.
 function TKeywordBot.CheckHeaderRetry: boolean;
  begin
   if Assigned (FHeaderRetryCodes) then
    Result := (FHeaderRetryCodes.IndexOf (IntToStr (FStatusCode)) <> -1)
   else
    Result := False;
  end;
{------------------------------------------------------------------------------}
// This is called before every launch of the HTTP Bot
 procedure TKeywordBot.InternalClear;
  begin
   FJudgement := judBad;

   inherited;
  end;
{------------------------------------------------------------------------------}
end.
