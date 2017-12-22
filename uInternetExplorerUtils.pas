{-----------------------------------------------------------------------------
 Unit Name: GoldenEye2 - uInternetExplorerUtils
 Author:    madmax
 Purpose:   Provides functions set or get information from Microsoft Internet Explorer®

            for more information consult the Microsoft Developer Network (MSDN)
            especially interesting are:
              * Microsoft Knowledgebase article Q226773
              * Platform SDK documentation of
                  - RasEnumConnections
                  - InternetSetOption
                  - InternetQueryOption
                  - INTERNET_PER_CONN_OPTION_LIST Structure
                  - INTERNET_PER_CONN_OPTION Structure

 Platform:  Windows (minimum: Windows 95, Windows NT 4, Internet Explorer 5)
 History:   29.08.2002 - created
            05-Sep-2002 - updated

 Copyright © by madmax
-----------------------------------------------------------------------------}

unit uInternetExplorerUtils;

interface

uses
  Classes;

const
{ Masks for setting the respective Internet Explorer proxies }

  cProxyCommon = '%s';
  cProxyFtp = 'ftp:%s';
  cProxyGopher = 'gopher=%s';
  cProxyHttp = 'http=%s';
  cProxySecure = 'https=%s';
  cProxyAll = 'ftp=%0:s;gopher=%0:s;http=%0:s;https=%0:s';

  {             <Proxy-Server>:<Proxy-Port>

             or

             ftp=<Proxy>;gopher=<Proxy>;http=<Proxy>;https=<Proxy>
             where <Proxy> is <Proxy-Server>:<Proxy-Port>

             or

             ftp=<Proxy-Server>:<Proxy-Port>
             gopher=<Proxy-Server>:<Proxy-Port>
             http=<Proxy-Server>:<Proxy-Port>
             https=<Proxy-Server>:<Proxy-Port>}

procedure GetRasConnections(var Connections: TStringList);

{
  Note for all Proxy functions:
    if Connection parameter is set to nil, the applied changes affect the default
    or LAN connection
    see Microsoft Knowledgebase article Q226473 for more information
}

procedure DisableProxy(Connection: PChar);
procedure EnableProxy(Connection: PChar);
function IsProxyEnabled(Connection: PChar): Boolean;
function GetCurrentProxy(Connection: PChar): string;
procedure SetAndEnableProxy(Connection, Proxy: PChar);
function GetIEVersion: string;
function GetIEMajorVersion: Integer;

implementation

{
  units Ras and JediWinInet can be obtained from the Delphi JEDI project
  homepage (http://www.delphi-jedi.org)

  JediWinInet is originally named WinInet, but was renamed by the author
  to avoid naming conflicts.
}

uses
  Ras, JediWinInet, Windows, SysUtils, Registry;

{-----------------------------------------------------------------------------
  Procedure: GetRasConnections
  Author:    madmax
  Date:      05-Sep-2002
  Arguments: var Connections: TStringList
  Result:    None
  Purpose:   Retrieves all available RAS (dial-up) connections
-----------------------------------------------------------------------------}

procedure GetRasConnections(var Connections: TStringList);

var
  lpRasConn: PRasConn;
  lpcb, lpcConnections, nRet: Cardinal;
  i: Integer;

begin
  lpRasConn := PRasConn(GlobalAlloc(GPTR, SizeOf(TRasConn)));
  lpRasConn.dwSize := SizeOf(TRasConn);
  lpcb := SizeOf(TRasConn);

  nRet := RasEnumConnections(lpRasConn, lpcb, lpcConnections);
  if nRet <> 0 then
    raise Exception.CreateFmt('RasEnumConnections failed! Error = %d', [nRet]);

  Connections.Clear;
  for i := 0 to lpcConnections - 1 do
  begin
    Connections.Add(lpRasConn^.szEntryName);
    Inc(lpRasConn, lpcb);
  end;
  GlobalFree(Cardinal(lpRasConn));
end;

{-----------------------------------------------------------------------------
  Procedure: DisableProxy
  Author:    madmax
  Date:      05-Sep-2002
  Arguments: Connection: PChar
  Result:    None
  Purpose:   Disables the proxy for the given connection.
             If Connection is nil, the LAN proxy is disabled.

             Retrieve a value for Connection using GetRasConnection
-----------------------------------------------------------------------------}

procedure DisableProxy(Connection: PChar);

var
  List: TInternetPerConnOptionList;
  Option: TInternetPerConnOption;
  nSize: Cardinal;

begin
  nSize := SizeOf(TInternetPerConnOptionList);

  Option.dwOption := INTERNET_PER_CONN_FLAGS;
  Option.Value.dwValue := PROXY_TYPE_DIRECT;

  List.dwSize := nSize;
  List.pszConnection := Connection;
  List.dwOptionCount := 1;
  List.dwOptionError := 0;
  List.pOptions := @Option;

  if not InternetSetOption(nil, INTERNET_OPTION_PER_CONNECTION_OPTION, @List, nSize) then
    raise Exception.CreateFmt('InternetSetOption failed! (%d)', [GetLastError]);
end;

{-----------------------------------------------------------------------------
  Procedure: EnableProxy
  Author:    madmax
  Date:      05-Sep-2002
  Arguments: Connection: PChar
  Result:    None
  Purpose:   Enables the proxy for the given connection.
             If Connection is nil, the LAN proxy is enabled.

             Retrieve a value for Connection using GetRasConnection
-----------------------------------------------------------------------------}

procedure EnableProxy(Connection: PChar);

var
  List: TInternetPerConnOptionList;
  Option: TInternetPerConnOption;
  nSize: Cardinal;

begin
  nSize := SizeOf(TInternetPerConnOptionList);

  Option.dwOption := INTERNET_PER_CONN_FLAGS;
  Option.Value.dwValue := PROXY_TYPE_PROXY;

  List.dwSize := nSize;
  List.pszConnection := Connection;
  List.dwOptionCount := 1;
  List.dwOptionError := 0;
  List.pOptions := @Option;

  if not InternetSetOption(nil, INTERNET_OPTION_PER_CONNECTION_OPTION, @List, nSize) then
    raise Exception.CreateFmt('InternetSetOption failed! (%d)', [GetLastError]);
end;

{-----------------------------------------------------------------------------
  Procedure: IsProxyEnabled
  Author:    madmax
  Date:      05-Sep-2002
  Arguments: Connection: PChar
  Result:    Boolean
  Purpose:   Checks whether proxy usage is enabled or disabled for
             the given Connection.
             If Connection is set to nil, it checks the LAN proxy usage state.

             Retrieve a value for Connection using GetRasConnection
-----------------------------------------------------------------------------}

function IsProxyEnabled(Connection: PChar): Boolean;

var
  List: TInternetPerConnOptionList;
  Option: TInternetPerConnOption;
  nSize: Cardinal;

begin
  nSize := SizeOf(TInternetPerConnOptionList);

  Option.dwOption := INTERNET_PER_CONN_FLAGS;

  List.dwSize := nSize;
  List.pszConnection := Connection;
  List.dwOptionCount := 1;
  List.dwOptionError := 0;
  List.pOptions := @Option;

  if not InternetQueryOption(nil, INTERNET_OPTION_PER_CONNECTION_OPTION, @List, nSize) then
    raise Exception.CreateFmt('InternetQueryOption failed! (%d)', [GetLastError]);

  Result := Option.Value.dwValue and PROXY_TYPE_PROXY = PROXY_TYPE_PROXY;
end;

{-----------------------------------------------------------------------------
  Procedure: GetCurrentProxy
  Author:    madmax
  Date:      05-Sep-2002
  Arguments: Connection: PChar
  Result:    string
  Purpose:   Retrieves the proxy server string for the given connection.
             If Connection is set to nil, it retrieves the LAN proxy server string

             Retrieve a value for Connection using GetRasConnection
-----------------------------------------------------------------------------}

function GetCurrentProxy(Connection: PChar): string;

var
  List: TInternetPerConnOptionList;
  Option: TInternetPerConnOption;
  nSize: Cardinal;

begin
  nSize := SizeOf(TinternetPerConnOptionList);
  Option.dwOption := INTERNET_PER_CONN_PROXY_SERVER;

  List.dwSize := nSize;
  List.pszConnection := Connection;
  List.dwOptionCount := 1;
  List.dwOptionError := 0;
  List.pOptions := @Option;

  if not InternetQueryOption(nil, INTERNET_OPTION_PER_CONNECTION_OPTION, @List, nSize) then
    raise Exception.CreateFmt('InternetQueryOption failed! (%d)', [GetLastError]);

  if Option.Value.pszValue <> nil then
  begin
    Result := Option.Value.pszValue;

    GlobalFree(Cardinal(Option.Value.pszValue));
  end
  else
    Result := '';
end;

{-----------------------------------------------------------------------------
  Procedure: SetAndEnableProxy
  Author:    madmax
  Date:      05-Sep-2002
  Arguments: Connection, Proxy: PChar
  Result:    None
  Purpose:   Sets and enables the given proxy server string for the given
             connection.
             If Connection is set to nil, it sets and enables the LAN proxy.
             Retrieve a value for Connection using GetRasConnection

             Values for Proxy should follow the following schemes

             <Proxy-Server>:<Proxy-Port>

             or

             ftp=<Proxy>;gopher=<Proxy>;http=<Proxy>;https=<Proxy>
             where <Proxy> is <Proxy-Server>:<Proxy-Port>

             or

             ftp=<Proxy-Server>:<Proxy-Port>
             gopher=<Proxy-Server>:<Proxy-Port>
             http=<Proxy-Server>:<Proxy-Port>
             https=<Proxy-Server>:<Proxy-Port>
-----------------------------------------------------------------------------}

procedure SetAndEnableProxy(Connection, Proxy: PChar);

var
  List: TInternetPerConnOptionList;
  Option: array[0..1] of TInternetPerConnOption;
  nSize: Cardinal;

begin
  nSize := SizeOf(TInternetPerConnOptionList);

  Option[0].dwOption := INTERNET_PER_CONN_PROXY_SERVER;
  Option[0].Value.pszValue := Proxy;
  Option[1].dwOption := INTERNET_PER_CONN_FLAGS;
  Option[1].Value.dwValue := PROXY_TYPE_PROXY;

  List.dwSize := nSize;
  List.pszConnection := Connection;
  List.dwOptionCount := 2;
  List.dwOptionError := 0;
  List.pOptions := @Option;

  if not InternetSetOption(nil, INTERNET_OPTION_PER_CONNECTION_OPTION, @List, nSize) then
    raise Exception.CreateFmt('InternetSetOption failed! (%d)', [GetLastError]);
end;

{-----------------------------------------------------------------------------
  Procedure: GetIEVersion
  Author:    madmax
  Date:      05-Sep-2002
  Arguments: None
  Result:    string
  Purpose:   Retrieves the version string of the installed Internet Explorer
-----------------------------------------------------------------------------}

function GetIEVersion: string;

const
  IERegKey = 'Software\Microsoft\Internet Explorer';

var
  Reg: TRegistry;

begin
  Reg := TRegistry.Create;

  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey(IERegKey, False) then
      Result := Reg.ReadString('Version')
    else
      Result := '';

    Reg.CloseKey;
  finally // wrap up
    Reg.Free;
  end; // try/finally
end;

function GetIEMajorVersion: Integer;

var
  s, MajorVers: string;
  i: Integer;

begin
  s := GetIEVersion;

  // find major version
  i := Pos('.', s);
  MajorVers := Copy(s, 1, i - 1);
  if s <> '' then
    Result := StrToInt(MajorVers)
  else
    Result := -1;
end;

end.
