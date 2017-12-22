// This class is based off of ICS's ICMP unit.
//
// To use, create the object, assign an Address and use the
// ResolveAddr procedure.

unit uResolveHost;

interface

uses
  SysUtils, Classes;

type
  TErrorEvent = procedure(Sender: TObject; const strMsg: string) of object;

  TResolveHost = class(TObject)
  private
    FAddress: string;
    FIP: string;
    FHostname: string;
    FOnError: TErrorEvent;

    procedure TriggerError(const strMsg: string);
  public
    constructor Create;
    procedure ResolveAddr;
    destructor Destroy; override;

    property Address: string read FAddress write FAddress;
    property Hostname: string read FHostname;
    property IP: string read FIP;

    property OnError: TErrorEvent read FOnError write FOnError;
  end;

implementation

uses WinSock;

constructor TResolveHost.Create;
var WSAData: TWSAData;

begin
  inherited;

  if WSAStartup($101, WSAData) <> 0 then
   TriggerError ('Error starting WinSock');
end;

procedure TResolveHost.ResolveAddr;
var Phe: PHostEnt; // HostEntry buffer for name lookup
    FIPAddress: integer;

begin
  // Convert host address to IP address
  FIPAddress := inet_addr(PChar (FAddress));
  if FIPAddress <> LongInt (INADDR_NONE) then
   // Was a numeric dotted address let it in this format
   FHostname := FAddress
  else
   begin
    // Not a numeric dotted address, try to resolve by name
    Phe := GetHostByName (PChar (FAddress));
    if Phe = nil then
     begin
      TriggerError ('Unable to resolve Address: ' + FAddress);
      Exit;
     end;

    FIPAddress := Longint (PLongint (Phe^.h_addr_list^)^);
    FHostName  := Phe^.h_name;
   end;

  FIP := StrPas (inet_ntoa (TInAddr (FIPAddress)));
end;

procedure TResolveHost.TriggerError(const strMsg: string);
begin
  if Assigned (FOnError) then
   FOnError (Self, strMsg);
end;

destructor TResolveHost.Destroy;
begin
  WSACleanup;

  inherited;
end;

end.
 