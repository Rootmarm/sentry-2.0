unit uAnalyzerEngine;

interface

uses
  Classes, SysUtils, ExtCtrls, HttpProt, uAnalyzerBot, ComCtrls,
  uAnalyzerListView, uInternalJudge;

type
  TEngineProcEvent = procedure(Sender : TObject;
                               AHttpCli: TAnalyzerBot) of object;

  TAnalyzerEngine = class(TObject)
  private
    FAbort                : boolean; // Variable which tells our Engine we need to abort
    FCount                : integer; // Counts the amount of tries we have done so far
    FBotCount             : integer; // The number of bots currently running
    FMaxBots              : integer; // Contains max amount of bots of engine
    FTimeout              : integer; // Stores how longs bots should go until a timeout (S)
    FIP                   : string;
    FKeyword              : string;
    FURL                  : string;
    FSpecificSite         : string;
    FHTTPSSite            : string;
    FNoLevels             : boolean;
    FInternalAuth         : boolean;
    FCustomResponse       : integer;
    FTimer                : TTimer;  // Main Timer for our Engine
    FItems                : array of integer;  // Array which contains the selected items' indexes
    FBots                 : array of TAnalyzerBot; // Array which contains our Bots (used with ManageTimeouts)
    FProxylist            : TAnalyzerList;
    FInternalJudge        : TInternalJudge;
    FRequestMethod        : THttpRequest;
    FEngine               : TEngines;
    FOnBotLaunched        : TEngineProcEvent;
    FOnBotComplete        : TEngineProcEvent;
    FOnEngineComplete     : TNotifyEvent;

    procedure CreateBot;
    procedure InitializeBot(var AHttpCli: TAnalyzerBot);
    procedure AssignAndLaunchBot(AHttpCli: TAnalyzerBot);
    procedure TriggerBotLaunched(AHttpCli: TAnalyzerBot);
    procedure TriggerBotComplete (AHttpCli: TAnalyzerBot);
    procedure TriggerEngineComplete;
    function  Abort (AHttpCli: TAnalyzerBot): boolean;
    procedure AHttpCliRequestDone(Sender: TObject; RqType: THttpRequest; Error: Word);
    procedure ManageTimeouts(Sender: TObject);  
  public
    procedure CreateAllBots;
    procedure InitializeEngine;
    function  BuildSelectedItemList(HList: TListView): integer;
    function  BuildImageItemList(HList: TListView; iImageIndex: integer): integer;
    procedure AbortEngine;

    property Bots             : integer          read  FMaxBots
                                                 write FMaxBots;
    property CustomResponse   : integer          read  FCustomResponse
                                                 write FCustomResponse;
    property Engine           : TEngines         read  FEngine
                                                 write FEngine;
    property HTTPSSite        : string           read  FHTTPSSite
                                                 write FHTTPSSite;
    property InternalAuth     : boolean          read  FInternalAuth
                                                 write FInternalAuth;
    property IP               : string           read  FIP
                                                 write FIP;
    property Keyword          : string           read  FKeyword
                                                 write FKeyword;
    property NoLevels         : boolean          read  FNoLevels
                                                 write FNoLevels;
    property Proxylist        : TAnalyzerList    read  FProxylist
                                                 write FProxylist;
    property RequestMethod    : THttpRequest     read  FRequestMethod
                                                 write FRequestMethod;
    property SpecificSite     : string           read  FSpecificSite
                                                 write FSpecificSite;
    property Timeout          : integer          read  FTimeout
                                                 write FTimeout;
    property URL              : string           read  FURL
                                                 write FURL;
    property OnBotLaunched    : TEngineProcEvent read  FOnBotLaunched
                                                 write FOnBotLaunched;
    property OnBotComplete    : TEngineProcEvent read  FOnBotComplete
                                                 write FOnBotComplete;
    property OnEngineComplete : TNotifyEvent     read  FOnEngineComplete
                                                 write FOnEngineComplete;
  end;

implementation

{------------------------------------------------------------------------------}
 procedure TAnalyzerEngine.CreateBot;
  var AHttpCli: TAnalyzerBot;

  begin
   // Create our ProxyBot
   AHttpCli := TAnalyzerBot.Create (nil);

   InitializeBot (AHttpCli);

   FBots[FBotCount] := AHttpCli;
   Inc (FBotCount);

   AssignAndLaunchBot (AHttpCli);
  end;
{------------------------------------------------------------------------------}
// Creates the max amount of bots we need for our Engine
 procedure TAnalyzerEngine.CreateAllBots;
  begin
   while (FBotCount < FMaxBots) and (FCount < Length (FItems)) do
    CreateBot;
  end;
{------------------------------------------------------------------------------}
// Assigns bot and launches it
 procedure TAnalyzerEngine.InitializeBot(var AHttpCli: TAnalyzerBot);
  begin
   // General Bot Initializing
   AHttpCli.Bot := FBotCount;
   AHttpCli.Engine := FEngine;
   AHttpCli.RequestMethod := FRequestMethod;
   if FInternalAuth then
    AHttpCli.SpecificSite := 'http://' + FIP + '/boobs/fuck/sex/secure/'
   else
    AHttpCli.SpecificSite := FSpecificSite;
   AHttpCli.HTTPSSite := FHTTPSSite;
   AHttpCli.Timeout := FTimeout;
   AHttpCli.Virtual := True;
   AHttpCli.IP := FIP;
   AHttpCli.NoLevels := FNoLevels;
   AHttpCli.Keyword := FKeyword;
   AHttpCli.CustomResponse := FCustomResponse;
   AHttpCli.OnRequestDone := AHttpCliRequestDone;
  end;
{------------------------------------------------------------------------------}
 procedure TAnalyzerEngine.AssignAndLaunchBot(AHttpCli: TAnalyzerBot);
  begin
   AHttpCli.Position := FItems[FCount];

   with FProxyList.Items[AHttpCli.Position] do
    begin
     AHttpCli.Proxy := Proxy;
     AHttpCli.ProxyPort := Port;
    end;

   if engAnalyzer in FEngine then
    AHttpCli.URL := FURL
   else if engInternal in FEngine then
    AHttpCli.URL := 'http://' + FIP + '/index.html'
   else
    AHttpCli.URL := FSpecificSite;

   AHttpCli.ClearVariables;
   Inc (FCount);

   if (engAnalyzer in FEngine = False) and (engKeyword in FEngine = False) then
    begin
     case FRequestMethod of
      httpHEAD: AHttpCli.HeadAsync;
      httpGET:  AHttpCli.GetAsync;
     end;
    end
   else
    AHttpCli.GetASync;

   TriggerBotLaunched (AHttpCli);
  end;
{------------------------------------------------------------------------------}
// Builds a list which contains the index numbers of the items the user
// selected.
 function TAnalyzerEngine.BuildSelectedItemList(HList: TListView): integer;
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
// Returns the number of items the engine will test
// Builds a list which contains the index numbers of the items based on their
// ImageIndex
 function TAnalyzerEngine.BuildImageItemList(HList: TListView; iImageIndex: integer): integer;
  var I, J: integer;

  begin
   J := 0;

   for I := 0 to HList.Items.Count - 1 do
    begin
     if HList.Items[I].ImageIndex = iImageIndex then
      begin
       Inc (J);
       SetLength (FItems, J);
       FItems[J - 1] := I;
      end;
    end;

   Result := J;
  end;
{------------------------------------------------------------------------------}
// Blank all important variables and create the FTimer and lstBots
 procedure TAnalyzerEngine.InitializeEngine;
  begin
   FAbort := False;
   FCount := 0;
   FBotCount := 0;

   if engInternal in FEngine then
    begin
     // Initialize HTTP Server
     FInternalJudge := TInternalJudge.Create (nil);
    end;

   FTimer := TTimer.Create (nil);

   // By Default, the timer is enabled and set to 1000 interval which
   // is what we want

   FTimer.OnTimer := ManageTimeouts;

   // Set our bot array to the capacity of the engine
   SetLength (FBots, FMaxBots);
  end;
{------------------------------------------------------------------------------}
 procedure TAnalyzerEngine.AHttpCliRequestDone(Sender: TObject; RqType: THttpRequest; Error: Word);
  var AHttpCli : TAnalyzerBot;

  begin
   AHttpCli := Sender as TAnalyzerBot;

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
// Procedure to trigger OnBotComplete
 procedure TAnalyzerEngine.TriggerBotComplete (AHttpCli: TAnalyzerBot);
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
 function TAnalyzerEngine.Abort (AHttpCli: TAnalyzerBot): boolean;
  begin
   if FAbort then
    begin
     // Careful: We do not want to delete a bot from the list because it will change
     // the Index of the existing bots. Therefore, we just set it to nil
     try
      FreeAndNil (FBots[AHttpCli.Bot]);
      Dec (FBotCount);
     except
      { TODO : Fix this }
     end;

     if FBotCount = 0 then
      begin
       SetLength (FItems, 0);
       SetLength (FBots, 0);
       FTimer.Free;

       if engInternal in FEngine then
        FreeAndNil (FInternalJudge);

       TriggerEngineComplete;
      end;

     Result := True;
    end
   else
    Result := False;
  end;
{------------------------------------------------------------------------------}
// Trigger OnBotAssignment Event
 procedure TAnalyzerEngine.TriggerBotLaunched(AHttpCli: TAnalyzerBot);
  begin
   if Assigned (FOnBotLaunched) then
    FOnBotLaunched (Self, AHttpCli);
  end;
{------------------------------------------------------------------------------}
// Trigger OnEngineComplete Event
 procedure TAnalyzerEngine.TriggerEngineComplete;
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
 procedure TAnalyzerEngine.ManageTimeouts(Sender: TObject);
  var I: integer;
      AHttpCli: TAnalyzerBot;

  begin
   for I := 0 to Length (FBots) - 1 do
    begin
     if Assigned (FBots[I]) then
      begin
       AHttpCli := FBots[I];
       if AHttpCli.IsTimeout then
        AHttpCli.BotTimeout;
      end;
    end;
  end;
{------------------------------------------------------------------------------}
// Triggers an Engine Abort
 procedure TAnalyzerEngine.AbortEngine;
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
end.
