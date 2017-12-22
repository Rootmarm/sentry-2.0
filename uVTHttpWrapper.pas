{ Written By Sentinel

  Virtual Timeout for HttpCli

  Component which adds Ping Time (MS), and Speed (MS) to ICS's HTTPCli Component.

  This component supports a "Virtual Timeout Method" meaning you need to hardcode
  the timeout using 1 TTimer in the Engine.

  This is the most efficient way add Timeouts to your Engine using ICS.

  New Properties (Public):
        Bot: Stores bot number (Basically just another "Tag" field, so it is easy
             to store the current Bot Number assigned to each component.
        Ping: Stores time it took to connect to the server in MS.
        Position: Stores position number (Another "Tag" field).
        Source: Stores Source of the webpage returned in a string. Only if RcvdStream
                is not assigned.
        Speed: Stores time it took to complete the HTTP Request in MS.
        Time: Contains GetTickCount to compare with the global TTimer GetTickCount.

        *No Cache changed to True, because we never want a cached version of a
         webpage.

  New Properties (Published):
        Timeout: Timeout in (S).
        Virtual: Enable Virtual Timeout Support.

  New Procedures (Public):
        BotTimeout: Declares a Component has Timed-out.
        MyAbort: Needed because we need to change the ReasonPhrase to "Timeout"
                 instead of "Connection Aborted on Request".
                 Also adds Virtual to ICS's Abort procedure.

  New Functions (Public):
        IsTimeout: boolean = Compares current time with its FTime and will
                             return True if a Timeout should occur according to
                             the set Timeout Value.

  New Events (Published):
        OnBotLaunched: When a Bot is launched.
                                                                               }


unit uVTHttpWrapper;

interface

// Use GExpert's Debug Window to output debug information
{.$DEFINE OUTPUTDEBUG}

uses
  Classes, HttpProt, WSocket, ExtCtrls;

type
  TVTHttpCli = class(THttpCli)
  protected
    FBot                  : integer;
    FPosition             : integer;
    FTimer                : TTimer;
    FTimeout              : integer;
    FSource               : string;
    FStatus               : string;
    FSpeed                : Cardinal;
    FTime                 : Cardinal;
    FPing                 : Cardinal;
    FVirtual              : boolean;
    FFollowRedirects      : boolean;
    FOnBotLaunched        : TNotifyEvent;
    FOnBotTimeout         : TNotifyEvent;

    procedure   SocketTimeout(Sender : TObject); virtual;
    procedure   TriggerSessionConnected; override;
    procedure   TriggerDocData(Data : Pointer; Len : Integer); override;
    procedure   TriggerRequestDone; override;
    procedure   SendRequest(const method, Version: String); override;
    procedure   DoRequestAsync(Rq : THttpRequest); override;
    procedure   LocationSessionClosed(Sender: TObject; ErrCode: Word); override;
    procedure   GetHeaderLineNext; override;
    procedure   InternalClear; override;
    procedure   StateChange(NewState : THttpState); override;
    procedure   TriggerBotLaunched; virtual;
    procedure   TriggerBotTimeout; virtual;
    procedure   TriggerCookie(const Data : String; var bAccept : Boolean); override;
  public
    constructor Create(Aowner:TComponent); override;
    destructor  Destroy; override;
    procedure   BotTimeout; virtual;
    function    IsTimeout: boolean; virtual;
    procedure   ResetTimeout;

    property Bot             : integer           read  FBot
                                                 write FBot;
    property FollowRedirects : boolean           read  FFollowRedirects
                                                 write FFollowRedirects;
    property Ping            : Cardinal          read  FPing;
    property Position        : integer           read  FPosition
                                                 write FPosition;
    property Source          : string            read  FSource;
    property Speed           : Cardinal          read  FSpeed;
    property Status          : string            read  FStatus;

  published
    property Timeout         : integer           read  FTimeout
                                                 write FTimeout;
    property Virtual         : boolean           read  FVirtual
                                                 write FVirtual;
    property OnBotLaunched   : TNotifyEvent      read  FOnBotLaunched
                                                 write FOnBotLaunched;
    property OnBotTimeout    : TNotifyEvent      read  FOnBotTimeout
                                                 write FOnBotTimeout;
  end;

implementation

uses Windows, SysUtils, IcsUrl
     {$IFDEF OUTPUTDEBUG}
      , DbugIntf
     {$ENDIF};

{ TVTHttpCli }

procedure OutputDebugString(const Msg : String);
begin
{$IFDEF OUTPUTDEBUG}
  SendDebug (Msg);
{$ENDIF}

{$IFDEF DEBUG_OUTPUT}
    if IsConsole then
        WriteLn(Msg);
{$ENDIF}
end;

{ Needed for GetHeaderNextLine fix }
function GetBaseUrl(const Url : String) : String;
var
    I : Integer;
begin
    I := 1;
    while (I <= Length(Url)) and (Url[I] <> '?') do
        Inc(I);
    Dec(I);
    while (I > 0) and (not (Url[I] in ['/', ':'])) do
        Dec(I);
    Result := Copy(Url, 1, I);
end;

constructor TVTHttpCli.Create(Aowner: TComponent);
begin
  inherited;

  FNoCache                         := True;
  FTimeout                         := 15;
  FVirtual                         := False;
  // FFollowRelocation is what ICS uses and it defaults to true.
  // The Component thinks it is following a redirects until the variable
  // FFollowRedirects determines at the last instant if the redirect is
  // followed or not.  This way FLocation is stored if chosen not to follow
  // redirects.
  FFollowRedirects                 := False;
  FAgent                           := 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)';
  FAccept                          := '*/*';
  FOptions                         := [httpoNoNTLMAuth];
end;

procedure TVTHttpCli.BotTimeout;
begin
  CloseAsync;
  TriggerBotTimeout;
end;

procedure TVTHttpCli.SocketTimeout(Sender : TObject);
begin
  BotTimeout;
end;

// Called externally by an engine
function TVTHttpCli.IsTimeout: boolean;
begin
  Result := False;

  if FTime = 0 then
   Exit;

  if (GetTickCount - FTime) > Longword (FTimeout * 1000) then
   Result := True;
end;

procedure TVTHttpCli.ResetTimeout;
begin
  FTime := GetTickCount;
end;

procedure TVTHttpCli.TriggerDocData(Data: Pointer; Len: Integer);
begin
  if Assigned (FRcvdStream) = False then
   FSource := FSource + StrPas (Data);

  if FVirtual then
   FTime := GetTickCount
  else
   begin
    FTimer.Enabled := False;
    FTimer.Enabled := True;
   end;

  inherited;
end;

procedure TVTHttpCli.TriggerSessionConnected;
begin
  FPing := GetTickCount - FSpeed;

  inherited;
end;

procedure TVTHttpCli.TriggerRequestDone;
begin
  FSpeed := GetTickCount - FSpeed;

  if FVirtual = False then
   FTimer.Enabled := True;

  if FStatusCode = 302 then
   FStatus := IntToStr (FStatusCode) + ' -> ' + FLocation
  else if FStatus = '' then
   FStatus := IntToStr (FStatusCode) + ' - ' + FReasonPhrase;

  // This should not be needed but when the component is in DnsComplete stage,
  // The abort procedure doesn't take it out of this stage, even though it is
  // safe to abort.
//  FState := httpReady;

  inherited;
end;

procedure TVTHttpCli.SendRequest(const method, Version: String);
var
    Headers : TStrings;
    N       : Integer;
begin
    Headers := TStringList.Create;
    try
        FReqStream.Clear;
        TriggerRequestHeaderBegin;
        {* OutputDebugString(method + ' ' + FPath + ' HTTP/' + Version); *}
        Headers.Add(method + ' ' + FPath + ' HTTP/' + Version);
        if FSender <> '' then
            Headers.Add('From: ' + FSender);
        if FAccept <> '' then
            Headers.Add('Accept: ' + FAccept);
        if FReference <> '' then
            Headers.Add('Referer: ' + FReference);
        if FConnection <> '' then
            Headers.Add('Connection: ' + FConnection);
        if FProxyConnection <> '' then
            Headers.Add('Proxy-Connection: ' + FProxyConnection);
        if FAcceptLanguage <> '' then
            Headers.Add('Accept-Language: ' + FAcceptLanguage);
        if ((FRequestType = httpPOST) or (FRequestType = httpPUT)) and
           (FContentPost <> '') then
            Headers.Add('Content-Type: ' + FContentPost);
        {if ((method = 'PUT') or (method = 'POST')) and (FContentPost <> '') then
            Headers.Add('Content-Type: ' + FContentPost);}
        if FAgent <> '' then
            Headers.Add('User-Agent: ' + FAgent);
        Headers.Add('Host: ' + FTargetHost);
        if FNoCache then
            Headers.Add('Pragma: no-cache');

{$IFDEF UseNTLMAuthentication}
        if (FRequestType = httpPOST) or (FRequestType = httpPUT) then begin
            if ((FNTLMAuthType = ntlmAuthNormal) and (FAuthNTLMState = ntlmMsg1)) or
               ((FNTLMAuthType = ntlmAuthProxy) and (FProxyAuthNTLMState = ntlmMsg1)) then
                Headers.Add('Content-Length: 0')
            else
                Headers.Add('Content-Length: ' + IntToStr(SendStream.Size - SendStream.Position));
        end;
{$ELSE}
        if (FRequestType = httpPOST) or (FRequestType = httpPUT) then
            Headers.Add('Content-Length: ' + IntToStr(SendStream.Size - SendStream.Position));
{$ENDIF}
        { if (method = 'PUT') or (method = 'POST') then
            Headers.Add('Content-Length: ' + IntToStr(SendStream.Size));}
        if FModifiedSince <> 0 then
            Headers.Add('If-Modified-Since: ' +
                        RFC1123_Date(FModifiedSince) + ' GMT');

{$IFDEF UseNTLMAuthentication}
        if (FNTLMAuthType = ntlmAuthNormal) and (FAuthNTLMState = ntlmMsg1) then
            Headers.Add('Authorization: NTLM ' + GetNTLMMessage1)
        else if (FNTLMAuthType = ntlmAuthNormal) and
                (FAuthNTLMState = ntlmMsg3) then
            Headers.Add('Authorization: NTLM ' + GetNTLMMessage3)
        else if (FNTLMAuthType = ntlmAuthProxy) and
                (FProxyAuthNTLMState = ntlmMsg1) then
            Headers.Add('Proxy-Authorization: NTLM ' + GetNTLMMessage1)
        else if (FNTLMAuthType = ntlmAuthProxy) and
                (FProxyAuthNTLMState = ntlmMsg3) then
            Headers.Add('Proxy-Authorization: NTLM ' + GetNTLMMessage3)
        else
{$ENDIF}
//        if (FBasicAuthType = basicAuthNormal) and (FAuthBasicState = basicMsg1) then
        if (FUsername <> '') or (FPassword <> '') then
            Headers.Add('Authorization: Basic ' +
                        EncodeStr(encBase64, FUsername + ':' + FPassword))
        else if (FBasicAuthType = basicAuthProxy) and
                (FProxyAuthBasicState = basicMsg1) then
            Headers.Add('Proxy-Authorization: Basic ' +
                        EncodeStr(encBase64, FProxyUsername + ':' + FProxyPassword));
(***
        if (FUsername <> '') and (not (httpoNoBasicAuth in FOptions))
{$IFDEF UseNTLMAuthentication}
          and (FAuthNTLMState in [ntlmNone, ntlmDone])
{$ENDIF}
        then
            Headers.Add('Authorization: Basic ' +
                        EncodeStr(encBase64, FUsername + ':' + FPassword));

        if (FProxy <> '') and (FProxyUsername <> '')
{$IFDEF UseNTLMAuthentication}
          and (FProxyAuthNTLMState = ntlmNone)
{$ENDIF}
        then
            Headers.Add('Proxy-Authorization: Basic ' +
                        EncodeStr(encBase64, FProxyUsername + ':' + FProxyPassword));
***)

        if FCookie <> '' then
            Headers.Add('Cookie: ' + FCookie);

        if (FContentRangeBegin <> '') or (FContentRangeEnd <> '') then begin            {JMR!! Added this line!!!}
            Headers.Add('Range: bytes=' + FContentRangeBegin + '-' + FContentRangeEnd); {JMR!! Added this line!!!}

          FContentRangeBegin := '';                                                     {JMR!! Added this line!!!}
          FContentRangeEnd   := '';                                                     {JMR!! Added this line!!!}

        end;                                                                            {JMR!! Added this line!!!}
        FAcceptRanges := '';

{SendCommand('UA-pixels: 1024x768'); }
{SendCommand('UA-color: color8'); }
{SendCommand('UA-OS: Windows 95'); }
{SendCommand('UA-CPU: x86'); }
{SendCommand('Proxy-Connection: Keep-Alive'); }

{$IFDEF DEBUG_OUTPUT}
        OutputDebugString(IntToStr(Headers.Count) + ' header lines to send');
{$ENDIF}
        TriggerBeforeHeaderSend(Method, Headers);
        for N := 0 to Headers.Count - 1 do
            SendCommand(Headers[N]);
{$IFDEF DEBUG_OUTPUT}
        OutputDebugString(Headers.Text);
{$ENDIF}
        TriggerRequestHeaderEnd;
        SendCommand('');
        FCtrlSocket.PutDataInSendBuffer(FReqStream.Memory, FReqStream.Size);
        FReqStream.Clear;
        FCtrlSocket.Send(nil, 0);
    finally
        Headers.Free;
{$IFDEF DEBUG_OUTPUT}
        OutputDebugString('SendRequest Done');
{$ENDIF}
    end;
end;          

procedure TVTHttpCli.DoRequestAsync(Rq : THttpRequest);
var
    Proto, User, Pass, Host, Port, Path: String;
begin
    if (Rq <> httpCLOSE) and (FState <> httpReady) then
        begin
         Rq := httpClose;
//         Assert (Rq <> httpClose, 'http component busy');
        end;

    if ((Rq = httpPOST) or (Rq = httpPUT)) and
       (not Assigned(FSendStream) or
        (FSendStream.Position = FSendStream.Size)) then
        raise EHttpException.Create('HTTP component has nothing to post or put',
                                    httpErrNoData);

    // We use CloseAsync for our Timeout procedure
    if Rq = httpCLOSE then begin
        if (FStatusCode <> 200) and (FStatusCode <> 401) then begin
           FStatusCode   := 404;
           FReasonPhrase := 'Timeout';
        end;

        StateChange(httpClosing);
        if FCtrlSocket.State = wsClosed then
            SetReady
        else
          FCtrlSocket.CloseDelayed;
        Exit;
    end;

    { Clear all internal state variables }
    FRequestType := Rq;
    InternalClear;

    { Parse url and proxy to FHostName, FPath and FPort }
    if FProxy <> '' then begin
        ParseURL(FURL, Proto, User, Pass, Host, Port, Path);
        FTargetHost := Host;
        FTargetPort := Port;
        if FTargetPort = '' then begin
            if Proto = 'https' then
                FTargetPort := '443'
            else
                FTargetPort := '80';
        end;
        FPath       := FURL;
        FDocName    := Path;
        if User <> '' then
            FUserName := User;
        if Pass <> '' then
            FPassword := Pass;
        { We need to remove usercode/Password from the URL given to the proxy }
        { but preserve the port                                               }
        if Port <> '' then
            Port := ':' + Port;
        if Proto = '' then
            FPath := 'http://'+ Host + Port + Path
        else
            FPath := Proto + '://' + Host + Port + Path;
        FProtocol := Proto;
        ParseURL(FProxy, Proto, User, Pass, Host, Port, Path);
        if Port = '' then
            Port := ProxyPort;
    end
    else begin
        ParseURL(FURL, Proto, User, Pass, Host, Port, FPath);
        FTargetHost := Host;
        FDocName    := FPath;
        FProtocol   := Proto;
        if User <> '' then
            FUserName := User;
        if Pass <> '' then
            FPassword := Pass;
        if Port = '' then begin
{$IFDEF USE_SSL}
            if Proto = 'https' then
                Port := '443'
            else
{$ENDIF}
                Port := '80';
        end;
    end;
    if Proto = '' then
        Proto := 'http';
    if FPath = '' then
        FPath := '/';

    AdjustDocName;

    FHostName   := Host;
    FPort       := Port;

    if FCtrlSocket.State = wsConnected then begin
        if (FHostName = FCurrentHost)     and
           (FPort     = FCurrentPort)     and
           (FProtocol = FCurrentProtocol) then begin
            { We are already connected to the right host ! }
            SocketSessionConnected(Self, 0);
            Exit;
        end;
        { Connected to another website. Abort the connection }
        FCtrlSocket.Abort;
    end;

    FProxyConnected := FALSE;
    { Ask to connect. When connected, we go at SocketSeesionConnected. }
    StateChange(httpNotConnected);
    Login;

  // ------- Start Wrapper Code  ------- //

  if FVirtual = False then
   begin
    FTimer                         := TTimer.Create (Self);
    FTimer.Enabled                 := False;
    FTimer.Interval                := FTimeout * 1000;
    FTimer.OnTimer                 := SocketTimeout;
   end;

  FSpeed := GetTickCount;

  if FVirtual then
   FTime := GetTickCount
  else
   FTimer.Enabled := True;

   TriggerBotLaunched;
end;

// We need to manually code not following redirects through this procedure because
// the way implemented in ICS does not store the redirect in FLocation
procedure TVTHttpCli.LocationSessionClosed(Sender: TObject; ErrCode: Word);
var
    Proto, User, Pass, Host, Port, Path: String;
//    RealLocation : String;
//    I            : Integer;
begin
//    { Remove any bookmark from the URL }
//    I := Pos('#', FLocation);
//    if I > 0 then
//        RealLocation := Copy(FLocation, 1, I - 1)
//    else
//        RealLocation := FLocation;

    { Parse the URL }
    ParseURL(FLocation, Proto, User, Pass, Host, Port, Path);
    FDocName := Path;
    AdjustDocName;
    FConnected      := FALSE;
    FProxyConnected := FALSE;
    FLocationFlag   := FALSE;
    { When relocation occurs doing a POST, new relocated page has to be GET }
    if FRequestType = httpPOST then
        FRequestType  := httpGET;
    { Restore normal session closed event }
    FCtrlSocket.OnSessionClosed := SocketSessionClosed;
    { Trigger the location changed event }
    if Assigned(FOnLocationChange) then
         FOnLocationChange(Self);

    if FFollowRedirects then
    begin
     { Clear header from previous operation }
     FRcvdHeader.Clear;
     { Clear status variables from previous operation }
     FHeaderLineCount  := 0;
     FBodyLineCount    := 0;
     FContentLength    := -1;
     FContentType      := '';
     FStatusCode       := 0;
     FTransferEncoding := ''; { 28/12/2003 }
     { Adjust for proxy use  (Fixed: Nov 10, 2001) }
     if FProxy <> '' then
         FPort := ProxyPort;
     { Must clear what we already received }
     CleanupRcvdStream; {11/11/04}
     CleanupSendStream;
     { Restart at login procedure }
     PostMessage(FWindowHandle, WM_HTTP_LOGIN, 0, 0);
    end
    else
     StateChange (httpReady);
end;

procedure TVTHttpCli.GetHeaderLineNext;
var
    proto   : String;
    user    : String;
    pass    : String;
    port    : String;
    Host    : String;
    Path    : String;
    Field   : String;
    Data    : String;
    nSep    : Integer;
    tmpInt  : LongInt;
    bAccept : Boolean;
    DocExt  : String;
begin
    if FHeaderLineCount = 0 then
        TriggerHeaderBegin
    else if FHeaderLineCount = -1 then   { HTTP/1.1 second header }
        FHeaderLineCount := 0;
    Inc(FHeaderLineCount);

    { Some server send HTML document without header ! I don't know if it is  }
    { legal, but it exists (AltaVista Discovery does that).                  }
    if (FHeaderLineCount = 1) and
       (UpperCase(Copy(FLastResponse, 1, 6)) = '<HTML>') then begin { 15/09/98 }
        if FContentType = '' then
            FContentType := 'text/html';
        StateChange(httpWaitingBody);
        FNext := GetBodyLineNext;
        TriggerHeaderEnd;
        FBodyData    := @FLastResponse[1];
        FBodyDataLen := Length(FLastResponse);
        GetBodyLineNext;
        Exit;
    end;

    if FLastResponse = '' then begin
{$IFDEF DEBUG_OUTPUT}
        OutputDebugString('end of header');
{$ENDIF}
        if (FResponseVer = '1.1') and (FStatusCode = 100) then begin
            { HTTP/1.1 continue message. A second header follow. }
            { I should create an event to give access to this.   }
            FRcvdHeader.Clear;        { Cancel this first header }
            FHeaderLineCount := -1;   { -1 is to remember we went here }
            Exit;
        end;

        TriggerHeaderEnd;  { 28/12/2003 }

        { FContentLength = -1 when server doesn't send a value }
        if// ((FContentLength = -1) and          { Added 12/03/2004 }
            ((FStatusCode < 200) or            { Added 12/03/2004 }
             (FStatusCode = 204) or            { Added 12/03/2004 }
             // Added By Sentinel to include all redirect responses
             ((FStatusCode >= 300) and (FStatusCode <= 307)))//)
           or
            (FContentLength = 0)
           or
            (FRequestType = httpHEAD) then begin
            { TriggerHeaderEnd;  }{ Removed 10/01/2004 }
            if (FResponseVer = '1.0') or (FRequestVer = '1.0') or
                (FCloseReq = False) then begin
                if FLocationFlag then          { Added 16/02/2004 }
                    StartRelocation            { Added 16/02/2004 }
                else begin                     { Added 16/02/2004 }
                    if FRequestType = httpHEAD then begin { Added 23/07/04 }
                        { With HEAD command, we don't expect a document }
                        { but some server send one !                    }
                        FReceiveLen := 0;      { Cancel received data   }
                        StateChange(httpWaitingBody);
                        FNext := nil;
                    end;
                    FCtrlSocket.CloseDelayed;  { Added 10/01/2004 }
                end;
            end
            else
                SetReady;
            Exit;
        end;
        DocExt := LowerCase(ExtractFileExt(FDocName));
        if (DocExt = '.exe') or (DocExt = '') then begin
            if FContentType = 'text/html' then
                ReplaceExt(FDocName, 'htm');
        end;

        StateChange(httpWaitingBody);
        FNext := GetBodyLineNext;
        {TriggerHeaderEnd;  Removed 11/11/04 because it is already trigger above }
        if FReceiveLen > 0 then begin
            FBodyData    := FReceiveBuffer;
            if (FContentLength < 0) or
               ((FRcvdCount + FReceiveLen) <= FContentLength) then
                FBodyDataLen := FReceiveLen
            else
                FBodyDataLen := FContentLength - FRcvdCount;  {****}
            GetBodyLineNext;
            FReceiveLen := FReceiveLen - FBodyDataLen;
            { Move remaining data to start of buffer. 17/01/2004 }
            if FReceiveLen > 0 then
                Move(FReceiveBuffer[FBodyDataLen], FReceiveBuffer[0], FReceiveLen + 1);
        end;
{ Sentinel: Commented this if statement because if a proxy is being used, it would not
  allow the Relocation to be followed. }
//        if not Assigned(FNext) then begin
            { End of document }
            if FLocationFlag then begin
                // Added To Clear Source
                FSource := '';
                StartRelocation;
//            end;
{ Commented, end if, see above }
        end;
        { if FStatusCode >= 400 then }   { 01/11/01 }
        {    FCtrlSocket.Close;      }
        Exit;
    end;

    FRcvdHeader.Add(FLastResponse);

    nSep := Pos(':', FLastResponse);
    if (FHeaderLineCount = 1) then begin
        if (Copy(FLastResponse, 1, 8) = 'HTTP/1.0') or
           (Copy(FLastResponse, 1, 8) = 'HTTP/1.1') then begin
            FResponseVer  := Copy(FLastResponse, 6, 3);
            FStatusCode   := StrToInt(Copy(FLastResponse, 10, 3));
            FReasonPhrase := Copy(FLastResponse, 14, Length(FLastResponse));
        end
        else begin
            { Received data but not part of a header }
            if Assigned(FOnDataPush2) then
                FOnDataPush2(Self);
        end;
    end
    else if nSep > 0 then begin
        Field := LowerCase(Copy(FLastResponse, 1, nSep - 1));
        { Skip spaces }
        Inc(nSep);
        while (nSep < Length(FLastResponse)) and
              (FLastResponse[nSep] = ' ') do
              Inc(nSep);
        Data  := Copy(FLastResponse, nSep, Length(FLastResponse));
        if Field = 'location' then begin { Change the URL ! }
            if FRequestType = httpPUT then begin
                 { Location just tell us where the document has been stored }
                 FLocation := Data;
            end
            else if FollowRelocation then begin    {TED}
                { OK, we have a real relocation !       }
                { URL with relocations:                 }
                { http://www.webcom.com/~wol2wol/       }
                { http://www.purescience.com/delphi/    }
                { http://www.maintron.com/              }
                { http://www.infoseek.com/AddURL/addurl }
                { http://www.micronpc.com/              }
                { http://www.amazon.com/                }
                { http://count.paycounter.com/?fn=0&si=44860&bt=msie&bv=5&    }
                { co=32&js=1.4&sr=1024x768&re=http://www.thesite.com/you.html }
                FLocationFlag := TRUE;
                if Proxy <> '' then begin
                    { We are using a proxy }
                    if Data[1] = '/' then begin
                        { Absolute location }
                        ParseURL(FPath, proto, user, pass, Host, port, Path);
                        if Proto = '' then
                            Proto := 'http';
                        FLocation := Proto + '://' + Host + Data;
                        FPath     := FLocation;

                        if (user <> '') and (pass <> '') then begin
                            { save user and password given in location @@@}
                            FUsername   := user;
                            FPassword   := pass;
                        end;
                    end
                    else if (CompareText(Copy(Data, 1, 7), 'http://') <> 0)
{$IFDEF USE_SSL}
                            and (CompareText(Copy(Data, 1, 8), 'https://') <> 0)
{$ENDIF}
                        then begin
                        { Relative location }
                        FPath     := GetBaseUrl(FPath) + Data;
                        { if Proto = '' then
                            Proto := 'http';
                          FLocation := Proto + '://' + FHostName + '/' + FPath;
                        }
                        FLocation := FPath;
                    end
                    else begin
                        ParseURL(Data, proto, user, pass, Host, port, Path);
                        if port <> '' then
                            FPort := port
                        else begin
{$IFDEF USE_SSL}
                            if proto = 'https' then
                                FPort := '443'
                            else
{$ENDIF}
                                FPort := '80';
                        end;

                        if (user <> '') and (pass <> '') then begin
                            { save user and password given in location @@@}
                            FUsername   := user;
                            FPassword   := pass;
                        end;

                        if (Proto <> '') and (Host <> '') then begin
                            { We have a full relocation URL }
                            FTargetHost := Host;
                            FLocation   := Proto + '://' + Host + Path;
                            FPath       := FLocation;
                        end
                        else begin
                            if Proto = '' then
                                Proto := 'http';
                            if FPath = '' then
                                FLocation := Proto + '://' + FTargetHost + '/' + Host
                            else if Host = '' then
                                FLocation := Proto + '://' + FTargetHost + FPath
                            else
                                FTargetHost := Host;
                        end;
                    end;
                end
                { We are not using a proxy }
                else begin
                    if Data[1] = '/' then begin
                        { Absolute location }
                        FPath     := Data;
                        if Proto = '' then
                            Proto := 'http';
                        FLocation := Proto + '://' + FHostName + FPath;
                    end
                    else if (CompareText(Copy(Data, 1, 7), 'http://') <> 0)
{$IFDEF USE_SSL}
                            and (CompareText(Copy(Data, 1, 8), 'https://') <> 0)
{$ENDIF}
                         then begin
                        { Relative location }
                        FPath     := GetBaseUrl(FPath) + Data;
                        if Proto = '' then
                            Proto := 'http';
                        FLocation := Proto + '://' + FHostName + {'/' +} FPath;
                    end
                    else begin
                        ParseURL(Data, proto, user, pass, FHostName, port, FPath);
                        if port <> '' then
                            FPort := port
                        else begin
{$IFDEF USE_SSL}
                            if proto = 'https' then
                                FPort := '443'
                            else
{$ENDIF}
                                FPort := '80';
                        end;

                        FProtocol := Proto;

                        if (user <> '') and (pass <> '') then begin
                            { save user and password given in location @@@}
                            FUsername   := user;
                            FPassword   := pass;
                        end;

                        if (Proto <> '') and (FHostName <> '') then begin
                            { We have a full relocation URL }
                            FTargetHost := FHostName;
                            if FPath = '' then begin
                                FPath := '/';
                                FLocation := Proto + '://' + FHostName;
                            end
                            else
                                FLocation := Proto + '://' + FHostName + FPath;
                        end
                        else begin
                            if Proto = '' then
                                Proto := 'http';
                            if FPath = '' then begin
                                FLocation := Proto + '://' + FTargetHost + '/' + FHostName;
                                FHostName := FTargetHost;
                                FPath     := FLocation;          { 26/11/99 }
                            end
                            else if FHostName = '' then begin
                                FLocation := Proto + '://' + FTargetHost + FPath;
                                FHostName := FTargetHost;
                            end
                            else
                                FTargetHost := FHostName;
                        end;
                    end;
                end;
            end;
        end
        else if Field = 'content-length' then
            FContentLength := StrToIntDef(Trim(Data), -1)
        else if Field = 'transfer-encoding' then
            FTransferEncoding := Data
        else if Field = 'content-range' then begin                             {JMR!! Added this line!!!}
            tmpInt := Pos('-', Data) + 1;                                      {JMR!! Added this line!!!}
            FContentRangeBegin := Copy(Data, 7, tmpInt-8);                     {JMR!! Added this line!!!}
            FContentRangeEnd   := Copy(Data, tmpInt, Pos('/', Data) - tmpInt); {JMR!! Added this line!!!}
        end                                                                    {JMR!! Added this line!!!}
        else if Field = 'accept-ranges' then
            FAcceptRanges := Data
        else if Field = 'content-type' then
            FContentType := LowerCase(Data)
        else if Field = 'www-authenticate' then
            FDoAuthor.add(Data)
        else if Field = 'proxy-authenticate' then              { BLD required for proxy NTLM authentication }
            FDoAuthor.add(Data)
        else if Field = 'set-cookie' then begin
            bAccept := TRUE;
            TriggerCookie(Data, bAccept);
        end
        { rawbite 31.08.2004 Connection controll }
        else if (Field = 'connection') or
                (Field = 'proxy-connection') then begin
            if (LowerCase(Trim(Data)) = 'close') then
                FCloseReq := TRUE
            else if (LowerCase(Trim(Data)) = 'keep-alive') then
                FCloseReq := FALSE;
        end
    {   else if Field = 'date' then }
    {   else if Field = 'mime-version' then }
    {   else if Field = 'pragma' then }
    {   else if Field = 'allow' then }
    {   else if Field = 'server' then }
    {   else if Field = 'content-encoding' then }
    {   else if Field = 'expires' then }
    {   else if Field = 'last-modified' then }
   end
   else { Ignore  all other responses }
       ;

    if Assigned(FOnHeaderData) then
        FOnHeaderData(Self);

{    if FStatusCode >= 400 then    Moved above 01/11/01 }
{        FCtrlSocket.Close;                             }
end;

procedure TVTHttpCli.InternalClear;
begin
  inherited;

  FSource := '';
  FSpeed := 0;
  FPing := 0;
  FTime := 0;
  FStatus := '';
end;

procedure TVTHttpCli.StateChange(NewState: THttpState);
begin
    if FState <> NewState then begin
        FState := NewState;
        TriggerStateChange;
// Sentinel: Remove PrepareBasicAuth because we do not
//           want to launch 2 requests per Auth.        
        if (NewState = httpReady) then // and
{$IFDEF UseNTLMAuthentication}
           not PrepareNTLMAuth and
{$ENDIF}
//           not PrepareBasicAuth then
            TriggerRequestDone;
    end;
end;

procedure TVTHttpCli.TriggerBotLaunched;
begin
  if Assigned (FOnBotLaunched) then
   FOnBotLaunched (Self);
end;

procedure TVTHttpCli.TriggerBotTimeout;
begin
  if Assigned (FOnBotTimeout) then
   FOnBotTimeout (Self);
end;

procedure TVTHttpCli.TriggerCookie(const Data : String; var bAccept : Boolean);
begin
  // Trigger Cookie Event (Gives user a chance to accept or decline the cookie)
  inherited;

  if bAccept then
   FCookie := Data;
end;

destructor TVTHttpCli.Destroy;
begin
  if FVirtual = False then
   FTimer.Free;

  if Assigned (FRcvdStream) then
   FreeAndNil (FRcvdStream);

  if Assigned (FSendStream) then
   FreeAndNil (FSendStream);

  inherited;
end;

end.

