unit uInternalJudge;

interface

uses
  SysUtils, Classes, HttpSrv, WSocket;

type
  TInternalJudge = class(THttpServer)
  private
    procedure InteralJudgeGetDocument(Sender, Client: TObject; var Flags : THttpGetFlag);
    procedure CreateVirtualProxyJudge(Sender: TObject; Client: TObject; var Flags : THttpGetFlag);
    procedure CreateVirtualBasicAuthentication(Sender: TObject; Client: TObject; var Flags : THttpGetFlag);
  public
    constructor Create(Aowner: TComponent); override;
    destructor  Destroy; override;
  published
    { Published declarations }
  end;

implementation

uses
  Dialogs, FastStrings, FastStringFuncs;

constructor TInternalJudge.Create(Aowner: TComponent);
begin
  inherited;

  FLingerOnOff := wsLingerOn;
  FLingerTimeout := 1;

  OnGetDocument := InteralJudgeGetDocument;

  Start;
end;

procedure TInternalJudge.CreateVirtualProxyJudge(Sender: TObject; Client: TObject; var Flags : THttpGetFlag);
var strBody, strHeader, S: string;
    MyStream: TMemoryStream;
    I: integer;

begin
  { Let HTTP server component know we will send data to client }
  Flags  := hgWillSendMySelf;
  { Create a stream to hold data sent to client that is the answer }
  { made of a HTTP header and a body made of HTML code.            }
  MyStream := TMemoryStream.Create;

  // We need to remove the "Host:" line, because that contains the host
  // of the Client connection which will be our IP, because we are connecting
  // to ourself.
  with THttpConnection (Client) do
   begin
    for I := 0 to RequestHeader.Count - 1 do
     begin
      S := RequestHeader.Strings[I];
      if FastPosNoCase (S, 'Host:', Length (S), 5, 1) <> 0 then
       begin
        RequestHeader.Delete (I);
        Break;
       end;
     end;

    strBody := // Gateway
               'REMOTE_ADDR=' + GetPeerAddr + #13#10 +
               // Header of the client request, where we look for our IP
               RequestHeader.Text;

    // Build header to send back to client that requested it
    strHeader := 'HTTP/1.1 200 OK' + #13#10 +
                 'Content-Type: text/html' + #13#10 +
                 'Content-Length: ' + IntToStr (Length (strBody)) + #13#10#13#10;

    MyStream.Write (strHeader[1], Length (strHeader));
    MyStream.Write (strBody[1], Length (strBody));

    { We need to seek to start of stream ! }
    MyStream.Seek (0, soFromBeginning);

    { We ask server component to send the stream for us. }
    DocStream := MyStream;
    SendStream;
   end;
end;

procedure TInternalJudge.CreateVirtualBasicAuthentication(Sender: TObject; Client: TObject; var Flags : THttpGetFlag);
var strHeader: string;
    MyStream: TMemoryStream;

begin
  { Let HTTP server component know we will send data to client }
  Flags  := hgWillSendMySelf;
  { Create a stream to hold data sent to client that is the answer }
  { made of a HTTP header and a body made of HTML code.            }
  MyStream := TMemoryStream.Create;

  // To display a Basic Authentication, all we need is the
  // "WWW-Authenticate:" line, but we might as well follow
  // RFC 2616 format.
  strHeader := 'HTTP/1.1 401 Authorization Required' + #13#10 +
               'WWW-Authenticate: Basic realm=Authetication' + #13#10 +
               'Connection: close' + #13#10#13#10;

  MyStream.Write (strHeader[1], Length (strHeader));

  { We need to seek to start of stream ! }
  MyStream.Seek (0, soFromBeginning);

  { We ask server component to send the stream for us. }
  with THttpConnection (Client) do
   begin
    DocStream := MyStream;
    SendStream;
   end;
end;

procedure TInternalJudge.InteralJudgeGetDocument(Sender, Client: TObject; var Flags : THttpGetFlag);
var strPath: string;

begin
  strPath := THttpConnection (Client).Path;

  // Check for index.html and if found, create it dynamically
  if FastPosNoCase (strPath, '/index.html', Length (strPath), 11, 1) <> 0 then
   CreateVirtualProxyJudge (Sender, Client, Flags)
  else if FastPosNoCase (strPath, '/secure/', Length (strPath), 8, 1) <> 0 then
   CreateVirtualBasicAuthentication (Sender, Client, Flags);
end;

destructor TInternalJudge.Destroy;
begin
  Stop;
end;

end.
