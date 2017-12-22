unit uAnalyzerBot;

interface

uses
  Classes, uVTHttpWrapper, HttpProt;

type
  PResult = ^TResult;
  TResult = record
    IP,
    Gateway,
    Level,
    Anonymous,
    HTTP,
    HTTPS: string;
  end;

  // TJudgement will make it easy to increase our statistics and ImageIndex
  TJudgement = (judGood, judBad, judUnknown, judTimeout);
  TEngineType = (engAnalyzer, engInternal, engHTTPS, engKeyword, engSpecific);
  TEngines = set of TEngineType;

  TAnalyzerBot = class(TVTHttpCli)
  protected
    FIP                            : string;   // IP of Person using the prog.
    FKeyword                       : string;   // Keyword for Specific Site Engine
    FCustomResponse                : integer;
    FHTTPSSite                     : string;
    FSpecificSite                  : string;
    FNoLevels                      : boolean;
    FStep                          : integer;
    FResult                        : PResult;
    FEngine                        : TEngines;
    FRequestMethod                 : THttpRequest;
    FJudgement                     : TJudgement;

    procedure TriggerRequestDone; override;
    procedure TriggerRequestDone2;
    function  CheckAnon: boolean;
    procedure GetLevel;
    procedure GetGateway;
    function  InSource(blnCaseSensitive: boolean = True): boolean;
    procedure CheckSSL;
    procedure CtrlSocketSessionConnected(Sender: TObject; Error: Word);
    procedure CtrlSocketDataAvailable(Sender: TObject; Error: Word);
    procedure CtrlSocketSessionClosed(Sender: TObject; Error: Word);
    procedure LaunchSocket;

  public
    constructor Create(Aowner: TComponent); override;
    destructor  Destroy; override;
    procedure   ClearVariables;

    property IP              : string            read  FIP
                                                 write FIP;
    property Keyword         : string            read  FKeyword
                                                 write FKeyword;
    property CustomResponse  : integer           read  FCustomResponse
                                                 write FCustomResponse;
    property HTTPSSite       : string            read  FHTTPSSite
                                                 write FHTTPSSite;
    property NoLevels        : boolean           read  FNoLevels
                                                 write FNoLevels;
    property RequestMethod   : THttpRequest      read  FRequestMethod
                                                 write FRequestMethod;
    property SpecificSite    : string            read  FSpecificSite
                                                 write FSpecificSite;
    property Engine          : TEngines          read  FEngine
                                                 write FEngine;
    property Judgement       : TJudgement        read  FJudgement;
    property Result          : PResult           read  FResult;
  end;

implementation

uses Windows, SysUtils, FastStrings, FastStringFuncs, Dialogs;

{ TAnalyzerBot }

{------------------------------------------------------------------------------}
// Formats a Server for an SSL Client Request
 function FormatForSSL(const strServer: string): string;
  begin
   Result := 'CONNECT ' + strServer + ' HTTP/1.0' + #13#10 +
             'User-Agent: Mozilla/4.0' + #13#10#13#10;
  end;
{------------------------------------------------------------------------------}
// Returns true if S shows support for the certain SSL connection
 function ScanForSSL(const S: string): string;
  begin
   // S is always a 15 character string
   if FastPos (S, '200', 15, 3, 1) <> 0 then
    Result := 'Yes'
   else
    Result := 'No';
  end;
{------------------------------------------------------------------------------}
 constructor TAnalyzerBot.Create(Aowner: TComponent);
  begin
   inherited;

   FVirtual := True;
   New (FResult);
  end;
{------------------------------------------------------------------------------}
// FJudgement defaults to judBad so we don't need to assign judBad
// (See InternalClear Procedure)
//
// Top Level Engines finish calling this procedure (Analyzer, Keyword)
 procedure TAnalyzerBot.TriggerRequestDone;
  begin
   FResult^.IP := FCtrlSocket.Addr;

   if FStep >= 0 then
    begin
     TriggerRequestDone2;
     Exit;
    end;

   if FReasonPhrase = 'Timeout' then
    FJudgement := judTimeout
   else
    begin
     if (engAnalyzer in FEngine) or (engInternal in FEngine) then
      begin
       if (FStatusCode = 200) and (FResult^.Anonymous = '') and (CheckAnon) then
        begin
         if FNoLevels = False then
          GetLevel;
         GetGateway;
        end;
      end
     else if engKeyword in FEngine then // Keyword Engine
      begin
       if (FStatusCode = 200) and (InSource) then
        begin
         FJudgement := judGood;
         FReasonPhrase := 'Found Key Phrase - [ ' + FKeyword + ' ]';
        end
       else
        FReasonPhrase := 'Key Phrase not found';
      end;
    end;

   // Launch Specific Engine
   if (engSpecific in FEngine) and (FJudgement <> judTimeout) then
    begin
     // Called if engSpecific was Top Level Engine
     if (engAnalyzer in FEngine = False) and (engInternal in FEngine = False) and (engKeyword in FEngine = False) then
      begin
       Inc (FStep);
       TriggerRequestDone2;
       Exit;
      end;

     // Specific as a 2nd Level Engine
     if FJudgement <> judBad then
      begin
       FURL := FSpecificSite;
       // FStep now = 0
       Inc (FStep);

       case FRequestMethod of
        httpHEAD: HeadAsync;
        httpGET:  GetAsync;
       end;
       Exit;
      end;
    end;

   if (engHTTPS in FEngine) and (FJudgement = judGood) then
    begin
     FStep := 1;
     TriggerRequestDone2;
     Exit;
    end;

   inherited;
  end;
{------------------------------------------------------------------------------}
 procedure TAnalyzerBot.TriggerRequestDone2;
  begin
   if FStep = 0 then
    begin
     if engSpecific in FEngine then
      begin
       if FStatusCode = FCustomResponse then
        begin
         FJudgement := judGood;
         FResult^.HTTP := 'Yes';
        end
       else if FReasonPhrase = 'Timeout' then
        FJudgement := judTimeout
       else
        begin
         FJudgement := judBad;
         FResult^.HTTP := 'No';
        end;
      end;

     if engHTTPS in FEngine then
      Inc (FStep);
    end;

   if (FStep = 1) and (FJudgement = judGood) then
    begin
     // FStep = 2 so inherited property will be fired
     Inc (FStep);

     CheckSSL;
     Exit;
    end;

   inherited TriggerRequestDone;
  end;
{------------------------------------------------------------------------------}
 procedure TAnalyzerBot.ClearVariables;
  begin
   with FResult^ do
    begin
     Gateway    := '';
     Anonymous  := '';
     Level      := '';
     IP         := '';
     HTTP       := '';
     HTTPS      := '';
    end;
   FJudgement   := judBad;
   FStep        := -1;
  end;
{------------------------------------------------------------------------------}
 function TAnalyzerBot.CheckAnon: boolean;
  begin
   if (Length (FSource) = 0) or (FastPos (FSource, FIP, Length (FSource), Length (FIP), 1) <> 0) then
    begin
     FResult^.Anonymous := 'No';
     Result := False;
    end
   else
    begin
     FResult^.Anonymous := 'Yes';
     FJudgement := judGood;
     Result := True;
    end;
  end;
{------------------------------------------------------------------------------}
 procedure TAnalyzerBot.GetLevel;
  var   iPos : integer;
      strTmp : string;

  begin
   // Look for AnonyLevel in Source
   iPos := FastPos (FSource, 'AnonyLevel', Length (FSource), 10, 1);
   if iPos <> 0 then
    begin
     // Once AnonyLevel is found, grab a 60 char buffer
     strTmp := CopyStr (FSource, iPos, 60);
     // Find the Level in the Buffer
     FResult^.Level := CopyStr (strTmp, FastCharPos (strTmp, '>', 1) + 1, 1);
    end
   else
    begin
     FResult^.Level := 'Unknown';
     FJudgement := judUnknown;
    end;
  end;
{------------------------------------------------------------------------------}
 procedure TAnalyzerBot.GetGateway;
  var I, J: integer;

  begin
   I := FastPos (FSource, 'REMOTE_ADDR', Length (FSource), 11, 1) + 11;
   if I <> 11 then
    begin
     I := FastCharPos (FSource, '=', I) + 1;
     J := FastCharPos (FSource, #10, I);
     if J <> 0 then
      begin
       FResult^.Gateway := Trim (CopyStr (FSource, I, J - I));
       if FResult^.Gateway = FCtrlSocket.Addr then
        FResult^.Gateway := 'No';
      end
     else
      begin
       FResult^.Gateway := '?';
       FJudgement := judUnknown;
      end;
    end
   else                    
    begin
     FResult^.Gateway := '?';
     FJudgement := judUnknown;
    end;
  end;
{------------------------------------------------------------------------------}
 function TAnalyzerBot.InSource(blnCaseSensitive: boolean = True): boolean;
  begin
   if blnCaseSensitive then
    Result := (FastPos (FSource, FKeyword, Length (FSource), Length (FKeyword), 1) <> 0)
   else
    Result := (FastPosNoCase (FSource, FKeyword, Length (FSource), Length (FKeyword), 1) <> 0);
  end;
{------------------------------------------------------------------------------}
 procedure TAnalyzerBot.CheckSSL;
  begin
   FCtrlSocket.Addr := FProxy;
   FCtrlSocket.Port := FProxyPort;

   LaunchSocket;
  end;
{------------------------------------------------------------------------------}
 procedure TAnalyzerBot.CtrlSocketSessionConnected(Sender: TObject; Error: Word);
  begin
   FCtrlSocket.SendStr (FormatForSSL (FHTTPSSite));
  end;
{------------------------------------------------------------------------------}
 procedure TAnalyzerBot.CtrlSocketDataAvailable(Sender: TObject; Error: Word);
  var strData : string;

  begin
   strData := CtrlSocket.ReceiveStr;

   // Keep the first 15 characters
   SetLength (strData, 15);

   FResult^.HTTPS := ScanForSSL (strData);

   FCtrlSocket.Close;
  end;
{------------------------------------------------------------------------------}
 procedure TAnalyzerBot.CtrlSocketSessionClosed(Sender: TObject; Error: Word);
  begin
   FCtrlSocket.OnSessionClosed    := SocketSessionClosed;
   FCtrlSocket.OnDataAvailable    := SocketDataAvailable;
   FCtrlSocket.OnSessionConnected := SocketSessionConnected;

   if FResult^.HTTPS = '' then
    FResult^.HTTPS := 'No';

   TriggerRequestDone2;
  end;
{------------------------------------------------------------------------------}
 procedure TAnalyzerBot.LaunchSocket;
  begin
   FCtrlSocket.OnSessionConnected := CtrlSocketSessionConnected;
   FCtrlSocket.OnDataAvailable    := CtrlSocketDataAvailable;
   FCtrlSocket.OnSessionClosed    := CtrlSocketSessionClosed;

   // Reset Timeout
   FTime := GetTickCount;
   FCtrlSocket.Connect;
  end;
{------------------------------------------------------------------------------}
 destructor TAnalyzerBot.Destroy;
  begin
   Dispose (FResult);

   inherited;
  end;
{------------------------------------------------------------------------------}
end.

