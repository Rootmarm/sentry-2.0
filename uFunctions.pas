unit uFunctions;

interface

uses Windows, Classes, StdCtrls, Messages;

// System Helper Functions
function  IniFileReadInteger(const strFilename, strSection, strKey: string; iDefault: integer = 0): integer;
procedure IniFileWriteInteger(const strFilename, strSection, strKey: string; const iValue: integer);
function  IniFileReadString(const strFilename, strSection, strKey: string; strDefault: string = ''): string;
procedure IniFileWriteString(const strFilename, strSection, strKey, strValue: string);
function  IniFileReadBool(const strFilename, strSection, strKey: string; blnDefault: boolean = False): boolean;
procedure IniFileWriteBool(const strFilename, strSection, strKey: string; const blnValue: boolean);
function  GetFileSize(const strFile: string): cardinal;
function  IsInteger(const S: string): boolean;
function  DeleteNonIntegers(const S: string): string;
procedure AppendOrRewriteFile(var F: TextFile; const strFileName: string);
function  RemoveExtension(const strFileName: string): string;

// URL Parsing Functions
function GetProtocol(const strURL: string): string;
function GetUsername(const strURL: string): string;
function GetPassword(const strURL: string): string;
function GetMembersURL(const strURL: string): string;
function GetPath(const strURL: string): string;
function GetBaseURL(const strURL: string): string;
function GetRelativeURL(const strURL: string): string;
function GetDomain(const strURL: string): string;
function AttachBaseURL(const strPath, strURL: string): string;

// Sentry Helper Functions
procedure ListBoxHorScrollBar(var ListBox: TListBox; blnFullCheck: boolean = False);
function RandomStr(const iLength: integer): string;
function CreateHeader(const S: string): string;
function GetProxy(const iIndex: integer): string;
function SetProxy(const strProxy: string; const iIndex: integer): boolean;
function LaunchSite(const strSite: string; const iImageIndex: integer): boolean;
procedure SetPOSTData(var MySendStream: TMemoryStream; const strPOSTData: string);

implementation

uses FastStrings, FastStringFuncs, SysUtils, IniFiles, ShellAPI,
     uInternetExplorerUtils;

////////////////////////////////////////////////////////////////////////////////
//                      System Helper Functions                               //
////////////////////////////////////////////////////////////////////////////////

function IniFileReadInteger(const strFilename, strSection, strKey: string; iDefault: integer = 0): integer;
var IniFile: TIniFile;

begin
  Result := iDefault;

  if FileExists (strFilename) then
   begin
    IniFile := TIniFile.Create (strFilename);

    try
     Result := IniFile.ReadInteger (strSection, strKey, iDefault);
    finally
     IniFile.Free;
    end;
   end;
end;

procedure IniFileWriteInteger(const strFilename, strSection, strKey: string; const iValue: integer);
var IniFile: TIniFile;

begin
  IniFile := TIniFile.Create (strFilename);

  try
   IniFile.WriteInteger (strSection, strKey, iValue);
  finally
   IniFile.Free;
  end;
end;

function IniFileReadString(const strFilename, strSection, strKey: string; strDefault: string = ''): string;
var IniFile: TIniFile;

begin
  Result := strDefault;

  if FileExists (strFilename) then
   begin
    IniFile := TIniFile.Create (strFilename);

    try
     Result := IniFile.ReadString (strSection, strKey, strDefault);
    finally
     IniFile.Free;
    end;
   end;
end;

procedure IniFileWriteString(const strFilename, strSection, strKey, strValue: string);
var IniFile: TIniFile;

begin
  IniFile := TIniFile.Create (strFilename);

  try
   IniFile.WriteString (strSection, strKey, strValue);
  finally
   IniFile.Free;
  end;
end;

function IniFileReadBool(const strFilename, strSection, strKey: string; blnDefault: boolean = False): boolean;
var IniFile: TIniFile;

begin
  Result := blnDefault;

  if FileExists (strFilename) then
   begin
    IniFile := TIniFile.Create (strFilename);

    try
     Result := IniFile.ReadBool (strSection, strKey, blnDefault);
    finally
     IniFile.Free;
    end;
   end;
end;

procedure IniFileWriteBool(const strFilename, strSection, strKey: string; const blnValue: boolean);
var IniFile: TIniFile;

begin
  IniFile := TIniFile.Create (strFilename);

  try
   IniFile.WriteBool (strSection, strKey, blnValue);
  finally
   IniFile.Free;
  end;
end;

function GetFileSize(const strFile: string): cardinal;
var SearchRec: TSearchRec;

begin
  Result := 0;

  if FindFirst (strFile, faAnyFile, SearchRec) = 0 then
   Result := SearchRec.Size;
  FindClose (SearchRec);
end;

function IsInteger(const S: string): boolean;
var I: integer;

begin
  Result := False;
  for I := 1 to Length (S) do
   begin
    if S[I] in ['0'..'9'] then
     begin
      Result := True;
      Break;
     end;
   end;
end;

// Deletes all characters from a string which are not integers
function DeleteNonIntegers(const S: string): string;
var I: integer;

begin
  Result := '';

  for I := 1 to Length (S) do
   begin
    if S[I] in ['0'..'9'] then
     Result := Result + S[I];
   end;
end;

procedure AppendOrRewriteFile(var F: TextFile; const strFileName: string);
begin
  AssignFile (F, strFileName);
  if FileExists (strFileName) then
   Append (F)
  else
   Rewrite (F);
end;

// Removes Extension from FileName
function RemoveExtension(const strFileName: string): string;
var I: integer;

begin
  Result := strFileName;

  for I := Length (strFileName) downto 1 do
   begin
    if strFileName[I] = '.' then
     begin
      Result := CopyStr (strFileName, 1, I - 1);
      Break;
     end;
   end;
end;

////////////////////////////////////////////////////////////////////////////////
//                      URL Parsing Functions                                 //
////////////////////////////////////////////////////////////////////////////////

function GetProtocol(const strURL: string): string;
var I: integer;

begin
  I := FastCharPos (strURL, ':', 3) + 2;
  if I <> 2 then
   Result := CopyStr (strURL, 1, I)
  else
   Result := '';
end;

function GetUsername(const strURL: string): string;
var I, J: integer;

begin
  I := FastCharPos (strURL, ':', 3) + 3;
  J := FastCharPos (strURL, ':', I);
  if J = 0 then
   // Site does not have a Username and Password
   Result := ''
  else
   Result := CopyStr (strURL, I, J - I);
end;

function GetPassword(const strURL: string): string;
var I, J: integer;

begin
  Result := '';

  I := FastCharPos (strURL, ':', 3) + 3;
  if I = 3 then
   Exit;

  I := FastCharPos (strURL, ':', I) + 1;
  if I <> 1 then
   begin
    J := FastCharPos (strURL, '@', I);
    if J <> 0 then
     Result := CopyStr (strURL, I, J - I);
   end;
end;

function GetMembersURL(const strURL: string): string;
var I, J: integer;

begin
  J := 0;
  I := FastCharPos (strURL, '@', 6) + 1;
  if I = 1 then
   // Site does not have a Username and Password
   I := FastCharPos (strURL, ':', 3) + 3
  else
   // Check for @ again, if it appears, there is an email in the username
   J := FastCharPos (strURL, '@', I);

  if J <> 0 then
   I := J + 1;

  Result := CopyStr (strURL, I, Length (strURL));
end;

// strURL = http://www.somesite.com/members
// Returns /members
function GetPath(const strURL: string): string;
var I: integer;

begin
  Result := '';

  I := FastCharPos (strURL, ':', 3) + 3;
  I := FastCharPos (strURL, '/', I);
  if I <> 0 then
   Result := CopyStr (strURL, I, Length (strURL));
end;

function GetBaseURL(const strURL: string): string;
var I, J: integer;
    strTmp: string;
    blnWWW: boolean;

begin
  I := FastCharPos (strURL, '@', 6) + 1;
  if I = 1 then
   // Site does not have a Username and Password
   I := FastCharPos (strURL, ':', 3) + 3;

  J := FastCharPos (strURL, '/', I);
  if J = 0 then
   J := Length (strURL) + 1;
  strTmp := CopyStr (strURL, I, J - I);

  // Remove www. if present
  if LeftStr (strTmp, 4) = 'www.' then
   begin
    strTmp := CopyStr (strTmp, 5, Length (strTmp));
    blnWWW := True;
   end
  else
   blnWWW := False;

  // If subdomain, strTmp = subdomain.base.com
  // else          strTmp = base.com
  I := FastCharPos (strTmp, '.', 1) + 1;
  J := FastCharPos (strTmp, '.', I);
  if J = 0 then
   Result := strTmp
  else
   Result := CopyStr (strTmp, I, Length (strTmp));

  if blnWWW then
   Result := 'www.' + Result;
end;

// Result always has a '/' as its last character
function GetRelativeURL(const strURL: string): string;
var I, J, K: integer;

begin
  // Strip Protocol
  I := FastCharPos (strURL, ':', 4) + 3;

  // Look for '?'
  J := FastCharPos (strURL, '?', 1) - 1;
  if J = -1 then
   J := Length (strURL);

  for K := J downto I do
   begin
    if strURL[K] = '/' then
     begin
      Result := CopyStr (strURL, I, K - I + 1);
      Exit;
     end;
   end;

  // '/' never found, strURL is our Base URL
  Result := CopyStr (strURL, I, Length (strURL)) + '/';
end;

// Gets the Domain from a given URL
function GetDomain(const strURL: string): string;
var I, J: integer;

begin
  I := FastCharPos (strURL, ':', 4) + 1;
  if I <> 1 then
   Inc (I, 2);
  J := FastCharPos (strURL, '/', I);
  if J = 0 then
   J := Length (strURL) + 1;
  Result := CopyStr (strURL, I, J - I);
end;

// Attach Base URL if not present
function AttachBaseURL(const strPath, strURL: string): string;
begin
  // Form Action is empty, use form URL
  if strPath = '' then
   Result := strURL
  // Attach Base URL to the path given       Ex: /login.php
  else if strPath[1] = '/' then
   Result := GetProtocol (strURL) + GetDomain (strURL) + strPath
  // No protocol, append relative location   Ex: login.php
  else if FastPos (strPath, '://', Length (strPath), 3, 1) = 0 then
   Result := GetProtocol (strURL) + GetRelativeURL (strURL) + strPath
  // Already formatted correctly
  else
   Result := strPath;
end;

////////////////////////////////////////////////////////////////////////////////
//                      Sentry Helper Functions                               //
////////////////////////////////////////////////////////////////////////////////

// Creates a Horizontal Scroll Bar on a TListBox. Use blnFullCheck to loop through
// all the items of the list.  If false, then only check the last item.
procedure ListBoxHorScrollBar(var ListBox: TListBox; blnFullCheck: boolean = False);
var I, J, K: integer;

begin
  if blnFullCheck then
   K := 0
  else
   K := ListBox.Count - 1;

  for I := K to ListBox.Count - 1 do
   begin
    J := ListBox.Canvas.TextWidth (ListBox.Items[I]);
    if J > ListBox.Tag then
     begin
      SendMessage (ListBox.Handle, LB_SETHORIZONTALEXTENT,
                   J + GetSystemMetrics (SM_CXFRAME), 0);
      ListBox.Tag := J;
     end;
   end;
end;

function RandomStr(const iLength: integer): string;
const CharSet: string = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
var I: integer;

begin
  Result := '';

  for I := 1 to iLength do
   Result := Result + CharSet[Random (63)];
end;

// Creates a Header in the format of
// "-" x 20 + "Header" + "-" until length reaches 60
function CreateHeader(const S: string): string;
const H = '----------------------------------------';

begin
  Result := '--------------------' + S + CopyStr (H, 1, 40 - Length (S));
end;

// Reads current proxy from IE, Firefox, and Opera
function GetProxy(const iIndex: integer): string;
const bmpIE = 4;
      bmpFIREFOX = 12;
      bmpOPERA = 13;

var lstList: TStringList;
    IniFile: TIniFile;
    strTmp, strFile, strProxy, strPort: string;
    I, iLength: integer;

begin
  Result := '';

  case iIndex of
   bmpIE: Result := GetCurrentProxy (nil);
   bmpFIREFOX:
    begin
     strFile := IniFileReadString (ExtractFilePath (ParamStr (0)) + 'Settings.ini', 'Integration', 'FirefoxPref', '');

     if FileExists (strFile) then
      begin
       lstList := TStringList.Create;

       try
        lstList.LoadFromFile (strFile);

        for I := lstList.Count - 1 downto 0 do
         begin
          strTmp := lstList.Strings[I];
          iLength := Length (strTmp);

          // Remove lines we want to modify
          if FastPosNoCase (strTmp, '"network.proxy.http"', iLength, 20, 10) <> 0 then
           // Parse Proxy
           strProxy := CopyStr (strTmp, 34, FastCharPos (strTmp, '"', 40) - 34)
          else if FastPosNoCase (strTmp, '"network.proxy.http_port"', iLength, 25, 10) <> 0 then
           // Parse Port
           strPort := CopyStr (strTmp, 38, FastCharPos (strTmp, ')', 38) - 38);
         end;
       finally
        lstList.Free;
       end;
      end;

      if (strProxy <> '') and (strPort <> '') then
       Result := strProxy + ':' + strPort;
    end;

   bmpOPERA:
    begin
     strFile := IniFileReadString (ExtractFilePath (ParamStr (0)) + 'Settings.ini', 'Integration', 'OperaPath');
     strFile := ExtractFilePath (strFile) + 'profile\opera6.ini';

     if FileExists (strFile) then
      begin
       IniFile := TIniFile.Create (strFile);
       try
        Result := IniFile.ReadString ('Proxy', 'HTTP Server', '');
       finally
        IniFile.Free;
       end;
      end;
    end;
  end;
end;

// Sets Proxy in IE, Firefox, and Opera
function SetProxy(const strProxy: string; const iIndex: integer): boolean;
const bmpIE = 4;
      bmpFIREFOX = 12;
      bmpOPERA = 13;

var lstList: TStringList;
    IniFile: TIniFile;
    strTmp, strTmp2, strFile: string;
    I, iLength: integer;
    F: TextFile;

begin
  Result := True;

  case iIndex of
   bmpIE: SetAndEnableProxy (nil, PChar (strProxy));
   bmpFIREFOX:
    begin
     strFile := IniFileReadString (ExtractFilePath (ParamStr (0)) + 'Settings.ini', 'Integration', 'FirefoxPref', '');

     if FileExists (strFile) then
      begin
       lstList := TStringList.Create;

       try
        lstList.LoadFromFile (strFile);

        for I := lstList.Count - 1 downto 0 do
         begin
          strTmp := lstList.Strings[I];
          iLength := Length (strTmp);

          // Remove lines we want to modify
          if FastPosNoCase (strTmp, '"network.proxy.http"', iLength, 20, 10) <> 0 then
           lstList.Delete (I)
          else if FastPosNoCase (strTmp, '"network.proxy.http_port"', iLength, 25, 10) <> 0 then
           lstList.Delete (I)
          else if FastPosNoCase (strTmp, '"network.proxy.ssl"', iLength, 19, 10) <> 0 then
           lstList.Delete (I)
          else if FastPosNoCase (strTmp, '"network.proxy.ssl_port"', iLength, 24, 10) <> 0 then
           lstList.Delete (I)
          else if FastPosNoCase (strTmp, '"network.proxy.type"', iLength, 20, 10) <> 0 then
           lstList.Delete (I);
         end;

        iLength := FastCharPos (strProxy, ':', 7);
        // Proxy
        strTmp := CopyStr (strProxy, 1, iLength - 1);
        // Port
        strTmp2 := CopyStr (strProxy, iLength + 1, Length (strProxy));

        // Add lines to file
        lstList.Add ('user_pref("network.proxy.http", "' + strTmp + '");');
        lstList.Add ('user_pref("network.proxy.ssl", "' + strTmp + '");');
        lstList.Add ('user_pref("network.proxy.ssl_port", ' + strTmp2 + ');');
        lstList.Add ('user_pref("network.proxy.http_port", ' + strTmp2 + ');');
        lstList.Add ('user_pref("network.proxy.type", 1);');
        lstList.SaveToFile (strFile);
       finally
        lstList.Free;
       end;
      end
     else
      Result := False;
    end;

   bmpOPERA:
    begin
     Result := False;

     strFile := IniFileReadString (ExtractFilePath (ParamStr (0)) + 'Settings.ini', 'Integration', 'OperaPath');
     strFile := ExtractFilePath (strFile) + 'OperaDef6.ini';

     if FileExists (strFile) then
      begin
       // Manually read the file to check for profiles set to false
       AssignFile (F, strFile);
       Reset (F);

       try
        while not Eof (F) do
         begin
          Readln (F, strTmp);
          if FastPosNoCase (strTmp, 'Multi User=0', Length (strTmp), 12, 1) <> 0 then
           begin
            Result := True;
            Break;
           end;
         end;
       finally
        CloseFile (F);
       end;

       if Result then
        begin
         strFile := ExtractFilePath (strFile) + 'profile\opera6.ini';
         IniFile := TIniFile.Create (strFile);
         try
          with IniFile do
           begin
            WriteString ('Proxy', 'HTTP Server', strProxy);
            WriteString ('Proxy', 'HTTPS Server', strProxy);
            WriteInteger ('Proxy', 'Use HTTP', 1);
            WriteInteger ('Proxy', 'Use HTTPS', 1);
           end;
         finally
          IniFile.Free;
         end;
        end;
      end;
    end;
  end;
end;

function LaunchSite(const strSite: string; const iImageIndex: integer): boolean;
const bmpIE = 4;
      bmpFIREFOX = 12;
      bmpOPERA = 13;

var strPath: string;

begin
  Result := False;

  case iImageIndex of
   bmpIE: Result := (ShellExecute (0, 'open', PChar (strSite), nil, 'c:/', 1) > 32);

   bmpFIREFOX:
    begin
     strPath := IniFileReadString (ExtractFilePath (ParamStr (0)) + 'Settings.ini', 'Integration', 'FirefoxPath');
     Result := (ShellExecute (0, 'open', PChar (strPath), PChar ('"' + strSite + '"'), 'C:\', 1) > 32);
    end;

   bmpOPERA:
    begin
     strPath := IniFileReadString (ExtractFilePath (ParamStr (0)) + 'Settings.ini', 'Integration', 'OperaPath');
     Result := (ShellExecute (0, 'open', PChar (strPath), PChar ('"' + strSite + '"'), 'C:\', 1) > 32);
    end;
  end;
end;

// Creates a stream and assigns POST Data to it
// If a stream already is created, clear it.
procedure SetPOSTData(var MySendStream: TMemoryStream; const strPOSTData: string);
begin
  if Assigned (MySendStream) then
   MySendStream.Clear
  else
   MySendStream := TMemoryStream.Create;
  MySendStream.Write (strPOSTData[1], Length (strPOSTData));
  MySendStream.Seek (0, soFromBeginning);
end;

end.
