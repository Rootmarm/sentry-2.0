unit uHistoryEngine;

interface

uses
  Classes, SysUtils, ExtCtrls, HttpProt, uHistoryBot, ComCtrls,
  uHistoryListView, uMyListListView, uHistoryFormParserBot, uVTHttpWrapper;

type
  PStatistics = ^TStatistics;
  TStatistics = record  // Record to group statistics data
    Good,
    Bad,
    Redirect,
    Retry,
    Timeout: integer;
  end;

  TEngineProcEvent = procedure(Sender : TObject;
                               AHttpCli: THistoryBot) of object;

  THistoryEngine = class(TObject)
  private
    FAbort                : boolean; // Variable which tells our Engine we need to abort
    FCount                : integer; // Counts the amount of tries we have done so far
    FBotCount             : integer; // The number of bots currently running
    FMaxBots              : integer; // Contains max amount of bots of engine
    FTimeout              : integer; // Stores how longs bots should go until a timeout (S)
    FCurrentProxy         : integer; // Current Index of MyList
    FTimer                : TTimer;  // Main Timer for our Engine
    FItems                : array of integer;  // Array which contains the selected items' indexes
    FBots                 : array of THistoryBot; // Array which contains our Bots (used with ManageTimeouts)
    FParserBots           : array of THistoryFormParserBot;
    FEnableAfterFP        : boolean;
    FEnableCheckHit       : boolean;
    FEnableSameProxy      : boolean;
    FMyList               : TMyList;
    FHistory              : THistory;
    FStatistics           : PStatistics;
    FOnUpdateListview     : TEngineProcEvent;
    FOnBotLaunched        : TEngineProcEvent;
    FOnBotComplete        : TEngineProcEvent;
    FOnEngineComplete     : TNotifyEvent;

    procedure CreateBot;
    procedure InitializeBot(var AHttpCli: THistoryBot);
    procedure AssignAndLaunchBot(var AHttpCli: THistoryBot; blnDoNotCount: boolean = False);
    procedure TriggerUpdateListview(AHttpCli: THistoryBot; strStatus: string);
    procedure TriggerBotLaunched(AHttpCli: THistoryBot);
    procedure TriggerBotComplete (AHttpCli: THistoryBot);
    procedure TriggerEngineComplete;
    function  Abort (AHttpCli: THistoryBot): boolean;
    procedure AHttpCliBanProxy(Sender: TObject; BanIndex: integer; strReason: string);
    procedure AHttpCliDisableProxy(Sender: TObject; BanIndex: integer; strReason: string);
    procedure AHttpCliBeforeFPComplete(Sender: TObject);
    procedure AHttpCliUpdateListview(Sender: TObject);
    procedure AHttpCliBotLaunched(Sender: TObject);
    procedure AHttpCliSetProxy(Sender: TObject);
    procedure AHttpCliRequestDone(Sender: TObject; RqType: THttpRequest; Error: Word);
    procedure PHttpCliRequestDone(Sender: TObject; RqType: THttpRequest; Error: Word);
    procedure ManageTimeouts(Sender: TObject);
    function SetProxy(var AHttpCli: TVTHttpCli): boolean;
    procedure RetryBot(AHttpCli: THistoryBot);
  public
    procedure CreateAllBots;
    procedure InitializeEngine;
    function  BuildSelectedItemList(HList: TListView): integer;
    procedure AbortEngine;

    property Bots             : integer          read  FMaxBots
                                                 write FMaxBots;
    property EnableAfterFP    : boolean          read  FEnableAfterFP
                                                 write FEnableAfterFP;
    property EnableCheckHits  : boolean          read  FEnableCheckHit
                                                 write FEnableCheckHit;
    property EnableSameProxy  : boolean          read  FEnableSameProxy
                                                 write FEnableSameProxy;
    property History          : THistory         read  FHistory
                                                 write FHistory;
    property MyList           : TMyList          read  FMyList
                                                 write FMyList;
    property Statistics       : PStatistics      read  FStatistics
                                                 write FStatistics;
    property Timeout          : integer          read  FTimeout
                                                 write FTimeout;
    property OnBotLaunched    : TEngineProcEvent read  FOnBotLaunched
                                                 write FOnBotLaunched;
    property OnUpdateListview : TEngineProcEvent read  FOnUpdateListview
                                                 write FOnUpdateListview;
    property OnBotComplete    : TEngineProcEvent read  FOnBotComplete
                                                 write FOnBotComplete;
    property OnEngineComplete : TNotifyEvent     read  FOnEngineComplete
                                                 write FOnEngineComplete;
  end;

implementation

uses FastStrings, FastStringFuncs, uFunctions, Dialogs;

{------------------------------------------------------------------------------}
 procedure THistoryEngine.CreateBot;
  var AHttpCli: THistoryBot;

  begin
   AHttpCli := THistoryBot.Create (nil);

   InitializeBot (AHttpCli);

   FBots[FBotCount] := AHttpCli;
   Inc (FBotCount);

   AssignAndLaunchBot (AHttpCli);
  end;
{------------------------------------------------------------------------------}
// Creates the max amount of bots we need for our Engine
 procedure THistoryEngine.CreateAllBots;
  begin
   while (FBotCount < FMaxBots) and (FCount < Length (FItems)) do
    CreateBot;
  end;
{------------------------------------------------------------------------------}
 procedure THistoryEngine.InitializeBot(var AHttpCli: THistoryBot);
  begin
   // General Bot Initializing
   AHttpCli.Bot := FBotCount;
   AHttpCli.EnableCheckHit := FEnableCheckHit;
   AHttpCli.EnableAfterFP := FEnableAfterFP;
   AHttpCli.Timeout := FTimeout;
   if Assigned (FMyList) then
    begin
     AHttpCli.OnBanProxy := AHttpCliBanProxy;
     AHttpCli.OnDisableProxy := AHttpCliDisableProxy;
    end;
   AHttpCli.OnUpdateListview := AHttpCliUpdateListview;
   AHttpCli.OnBeforeFPComplete := AHttpCliBeforeFPComplete;
   AHttpCli.OnBotLaunched := AHttpCliBotLaunched;
   AHttpCli.OnRequestDone := AHttpCliRequestDone;
   AHttpCli.OnSetProxy := AHttpCliSetProxy;
  end;
{------------------------------------------------------------------------------}
 procedure THistoryEngine.AssignAndLaunchBot(var AHttpCli: THistoryBot; blnDoNotCount: boolean = False);
  var blnHasKeywords: boolean;
      strPOSTData: string;
      MyStream: TMemoryStream;

  begin
   // Do Not Increase FCount, because we needed to find POSTData
   // That data is found now, so continue on
   if blnDoNotCount = False then
    begin
     AHttpCli.Position := FItems[FCount];
     TriggerUpdateListview (AHttpCli, 'Analyzing');

     AHttpCli.ClearVariables;
     Inc (FCount);

     if SetProxy (TVTHttpCli (AHttpCli)) then
      begin
       AbortEngine;
       Exit;
      end;
    end;

   with FHistory.Items[AHttpCli.Position] do
    begin
     AHttpCli.FailureKeys := FailKeys;
     AHttpCli.SuccessKeys := SuccessKeys;

     if ReqMethod <> 'POST' then
      begin
       AHttpCli.URL := GetProtocol (Site) + GetMembersURL (Site);

       // A GET/HEAD Request, assign Username and Password
       AHttpCli.Username := GetUsername (Site);
       AHttpCli.Password := GetPassword (Site);
      end
     else
      begin
       AHttpCli.RequestMethod := rgPOST;
       // Set POST Referer to where the form is
       AHttpCli.Reference := GetProtocol (Site) + GetMembersURL (Site);
       AHttpCli.POSTData := POSTData;

       if (FormAction = '') or (POSTData = '') then
        begin
         // We need to send out a bot to get our POST Data
         FParserBots[AHttpCli.Bot] := THistoryFormParserBot.Create (nil);
         with FParserBots[AHttpCli.Bot] do
          begin
           Bot := AHttpCli.Bot;
           Position := AHttpCli.Position;
           Tag := AHttpCli.Tag;
           Proxy := AHttpCli.Proxy;
           ProxyPort := AHttpCli.ProxyPort;
           Timeout := AHttpCli.Timeout;
           FormURL := AHttpCli.Reference;
           // Rotates proxies upon bad response
           if Assigned (FMyList) then
            OnBanProxy := AHttpCliBanProxy;
           OnSetProxy := AHttpCliSetProxy;
           OnRequestDone := PHttpCliRequestDone;

           GetAsync;
          end;
         Exit;
        end;

       // Set POST URL to Form Action
       AHttpCli.URL := FormAction;

       blnHasKeywords := ((FailKeys <> '') or (SuccessKeys <> ''));
       // Follow Redirects when GET with Keywords or POST
       AHttpCli.FollowRedirects := ((ReqMethod <> 'HEAD') and (blnHasKeywords)) or (ReqMethod = 'POST');

       if (AHttpCli.BeforeFPComplete = False) and (FailKeys = '') and (SuccessKeys = '') then
        begin
         AHttpCli.GetBeforeFingerprint;
         Exit;
        end;

       // POST Request, we need to substitute the POST Data's Username and Password
       strPOSTData := FastReplace (POSTData, '<USER>', GetUsername (Site));
       strPOSTData := FastReplace (strPOSTData, '<PASS>', GetPassword (Site));
      end;

     // Since history item's request method is independent, get it from the
     // history list and set the bot.
     if ReqMethod = 'HEAD' then
      begin
       AHttpCli.RequestMethod := rgHEAD;
       AHttpCli.HeadAsync;
      end
     else if ReqMethod = 'GET' then
      begin
       AHttpCli.RequestMethod := rgGET;
       AHttpCli.GetAsync;
      end
     else
      begin
       SetPOSTData (MyStream, strPOSTData);
       AHttpCli.SendStream := MyStream;
       AHttpCli.PostAsync;
      end;
    end;
  end;
{------------------------------------------------------------------------------}
// Returns the number of items the engine will test
// Builds a list which contains the index numbers of the items the user
// selected.
 function THistoryEngine.BuildSelectedItemList(HList: TListView): integer;
  var I, J: integer;

  begin
   J := 0;
   SetLength (FItems, HList.SelCount);

   for I := 0 to HList.Items.Count - 1 do
    begin
     if HList.Items[I].Selected then
      begin
       FItems[J] := I;
       Inc (J);
      end;
    end;

   Result := J;
  end;
{------------------------------------------------------------------------------}
// Blank all important variables and create the FTimer and lstBots
 procedure THistoryEngine.InitializeEngine;
  begin
   FAbort := False;
   FCount := 0;
   FBotCount := 0;
   // Used in After FingerPrint
   Randomize;

   FStatistics := New (PStatistics);

   with FStatistics^ do
    begin
     Good := 0;
     Bad := 0;
     Timeout := 0;
     Redirect := 0;
     Retry := 0;
    end;

   if (Assigned (FMyList)) and (FMyList.Active = 0) then
    FMyList.ReactivateAllProxies;

   FTimer := TTimer.Create (nil);

   // By Default, the timer is enabled and set to 1000 interval which
   // is what we want

   FTimer.OnTimer := ManageTimeouts;

   // Set our bot array to the capacity of the engine
   SetLength (FBots, FMaxBots);
   SetLength (FParserBots, FMaxBots);
  end;
{------------------------------------------------------------------------------}
 procedure THistoryEngine.AHttpCliRequestDone(Sender: TObject; RqType: THttpRequest; Error: Word);
  var AHttpCli : THistoryBot;

  begin
   AHttpCli := Sender as THistoryBot;

   case AHttpCli.Judgement of
    judGood:     Inc (FStatistics^.Good);
    judBad:      Inc (FStatistics^.Bad);
    judRedirect: Inc (FStatistics^.Redirect);
    judTimeout:  Inc (FStatistics^.Timeout);
    judRetry:
     begin
      RetryBot (AHttpCli);
      Exit;
     end;
   end;

   TriggerBotComplete (AHttpCli);

   if Abort (AHttpCli) then
    Exit;

   if FCount >= Length (FItems) then
    begin
     FAbort := True;
     Abort (AHttpCli);
    end
   else
    AssignAndLaunchBot (AHttpCli);
  end;
{------------------------------------------------------------------------------}
 procedure THistoryEngine.PHttpCliRequestDone(Sender: TObject; RqType: THttpRequest; Error: Word);
  var PHttpCli: THistoryFormParserBot;
      AHttpCli: THistoryBot;
      iBot: integer;

  begin
   PHttpCli := Sender as THistoryFormParserBot;

   iBot := PHttpCli.Bot;
   AHttpCli := FBots[iBot];

   if PHttpCli.StatusCode <> 200 then
    begin
     // We couldn't get a 200 in 3 tries, so try next item in list
     TriggerUpdateListview (AHttpCli, 'Unable to retrieve POST Data');
     FreeAndNil (PHttpCli);
     AHttpCliRequestDone (AHttpCli, httpPOST, 0);
     Exit;
    end;

   with FHistory.Items[PHttpCli.Position] do
    begin
     FormAction := PHttpCli.FormData^.Action;
     POSTData := PHttpCli.POSTData;

     TriggerUpdateListview (AHttpCli, 'Retrieved POST Data');
    end;

   // Give back the proxy information and assign a cookie
   with AHttpCli do
    begin
     Proxy := PHttpCli.Proxy;
     ProxyPort := PHttpCli.ProxyPort;
     Tag := PHttpCli.Tag;

     Cookie := PHttpCli.FormData^.Cookie;
    end;

   FreeAndNil (FParserBots[iBot]);

   // We have the necessary info, now assign and launch the bot
   AssignAndLaunchBot (AHttpCli, True);
  end;
{------------------------------------------------------------------------------}
// Procedure to trigger OnBotComplete
 procedure THistoryEngine.TriggerBotComplete (AHttpCli: THistoryBot);
  begin
   if Assigned (FOnBotComplete) then
    FOnBotComplete (Self, AHttpCli);
  end;
{------------------------------------------------------------------------------}
// It is a function because we need to Exit immediately after we have freed the Bot
// True if we Aborted which will free a ProxyBot Component and decrease iBotCount
//
// If not true, then we don't need to abort yet. This is checked after each bot is
// completed, just incase the user hit the Abort Button.
//
// When all Bots are freed, we can other Components and trigger OnEngineComplete
 function THistoryEngine.Abort (AHttpCli: THistoryBot): boolean;
  begin
   if FAbort then
    begin
     FreeAndNil (FBots[AHttpCli.Bot]);
     Dec (FBotCount);

     if FBotCount = 0 then
      begin
       SetLength (FItems, 0);
       SetLength (FBots, 0);
       SetLength (FParserBots, 0);
       FTimer.Free;
       Dispose (FStatistics);

       if Assigned (FMyList) then
        begin
         FMyList.SaveToFile (ExtractFilePath (ParamStr (0)) + 'MyList.ini', True);
         FreeAndNil (FMyList);
        end;

       TriggerEngineComplete;
      end;

     Result := True;
    end
   else
    Result := False;
  end;
{------------------------------------------------------------------------------}
 procedure THistoryEngine.AHttpCliBanProxy(Sender: TObject; BanIndex: integer; strReason: string);
  begin
   FMyList.BanProxy (BanIndex, strReason);
  end;
{------------------------------------------------------------------------------}
 procedure THistoryEngine.AHttpCliDisableProxy(Sender: TObject; BanIndex: integer; strReason: string);
  begin
   FMyList.DisableProxy (BanIndex, strReason);
  end;
{------------------------------------------------------------------------------}
 procedure THistoryEngine.AHttpCliBeforeFPComplete(Sender: TObject);
  var AHttpCli: THistoryBot;

  begin
   AHttpCli := Sender as THistoryBot;
   TriggerUpdateListview (AHttpCli, 'Getting Actual Fingerprint');
   AssignAndLaunchBot (AHttpCli, True);
  end;
{------------------------------------------------------------------------------}
 procedure THistoryEngine.AHttpCliUpdateListview(Sender: TObject);
  begin
   TriggerUpdateListview (Sender as THistoryBot, (Sender as THistoryBot).Status);
  end;
{------------------------------------------------------------------------------}
 procedure THistoryEngine.AHttpCliBotLaunched(Sender: TObject);
  begin
   TriggerBotLaunched (Sender as THistoryBot);
  end;
{------------------------------------------------------------------------------}
 procedure THistoryEngine.AHttpCliSetProxy(Sender: TObject);
  begin
   if SetProxy (TVTHttpCli (Sender)) then
    begin
     AbortEngine;
     Exit;
    end;
  end;
{------------------------------------------------------------------------------}
 procedure THistoryEngine.TriggerUpdateListview(AHttpCli: THistoryBot; strStatus: string);
  begin
   FHistory[AHttpCli.Position].Status := strStatus;

   if Assigned (FOnUpdateListview) then
    FOnUpdateListview (Self, AHttpCli);
  end;
{------------------------------------------------------------------------------}
// Trigger OnBotAssignment Event
 procedure THistoryEngine.TriggerBotLaunched(AHttpCli: THistoryBot);
  begin
   if Assigned (FOnBotLaunched) then
    FOnBotLaunched (Self, AHttpCli);
  end;
{------------------------------------------------------------------------------}
// Trigger OnEngineComplete Event
 procedure THistoryEngine.TriggerEngineComplete;
  begin
   if Assigned (FOnEngineComplete) then
    FOnEngineComplete (Self);
  end;
{------------------------------------------------------------------------------}
// This is the heart of the timeout system for this engine.
// This procedure is Set as the OnTimer Event for FTimer which is fired ever second.
//
// What this procedure does is it runs through our entire list of Bots and checks which
// ones are still active (not nil, see "Careful:" above for reason why)
//
// If a Bot is still active, we check it with its timestamp which is all done with our
// Component
//
// If it is a timeout, we abort and declare it a timeout (done in wrapper component)
// If it is not a timeout, we don't do anything.
 procedure THistoryEngine.ManageTimeouts(Sender: TObject);
  var I: integer;
      AHttpCli: TVTHttpCli;

  begin
   for I := 0 to Length (FBots) - 1 do
    begin
     AHttpCli := TVTHttpCli (FBots[I]);

     if Assigned (AHttpCli) then
      begin
       // Check to see if a Parser Bot is assigned
       // If it is assigned, use it instead of the history bot
       if Assigned (FParserBots[AHttpCli.Bot]) then
        AHttpCli := TVTHttpCli (FParserBots[AHttpCli.Bot]);

       if AHttpCli.IsTimeout then
        AHttpCli.BotTimeout;
      end;
    end;
  end;
{------------------------------------------------------------------------------}
// Triggers an Engine Abort
 procedure THistoryEngine.AbortEngine;
  var I: integer;

  begin
   FAbort := True;

   for I := 0 to Length (FBots) - 1 do
    begin
     if Assigned (FBots[I]) then
      FBots[I].BotTimeout;
    end;
  end;
{------------------------------------------------------------------------------}
// Returns True when no proxies are left.
 function THistoryEngine.SetProxy(var AHttpCli: TVTHttpCli): boolean;
  var I: integer;

  begin
   Result := False;

   if Assigned (FMyList) = False then
    Exit;

   with FHistory.Items[AHttpCli.Position] do
    begin
     if (FEnableSameProxy) and (Proxy <> '') then
      begin
       I := FastCharPos (Proxy, ':', 7);
       AHttpCli.Proxy := CopyStr (Proxy, 1, I - 1);
       AHttpCli.ProxyPort := CopyStr (Proxy, I + 1, Length (Proxy));
       Exit;
      end;
    end;

   // Reactivate all proxies when none are left
   if FMyList.Active = 0 then
    begin
     FMyList.ReactivateAllProxies;

     if FMyList.Active = 0 then
      begin
       Result := True;
       Exit;
      end;
    end;

   AHttpCli.Proxy := '';

   repeat
    if FMyList.Items[FCurrentProxy].ImageIndex = 0 then
     begin
      AHttpCli.Proxy := FMyList.Items[FCurrentProxy].Proxy;
      AHttpCli.ProxyPort := FMyList.Items[FCurrentProxy].Port;
      FHistory.Items[AHttpCli.Position].Proxy := AHttpCli.Proxy + ':' + AHttpCli.ProxyPort;
      // Current MyList Index of the proxy in use
      AHttpCli.Tag := FCurrentProxy;
     end;
    Inc (FCurrentProxy);
    if FCurrentProxy > FMyList.Count - 1 then
     FCurrentProxy := 0;
   until AHttpCli.Proxy <> '';
  end;
{------------------------------------------------------------------------------}
 procedure THistoryEngine.RetryBot(AHttpCli: THistoryBot);
  begin
   TriggerUpdateListview (AHttpCli, IntToStr (AHttpCli.StatusCode) + ' - ' + 'Retrying');

   AHttpCli.Judgement := judBad;
   Inc (FStatistics^.Retry);

   // Simple Retry, don't clear variables or rotate proxies
   // This needs to be done before entering this procedure
   with  FHistory.Items[AHttpCli.Position] do
    begin
     if ReqMethod = 'HEAD' then
      AHttpCli.HeadAsync
     else if ReqMethod = 'GET' then
      AHttpCli.GetAsync
     else
      begin
       // Rewind the stream
       AHttpCli.SendStream.Seek (0, soFromBeginning);
       AHttpCli.PostAsync;
      end;
    end;
  end;
{------------------------------------------------------------------------------}
end.
