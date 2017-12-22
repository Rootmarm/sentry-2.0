unit uAnalyzerListView;

interface

uses
  Classes;

type
  TFileStatus = (sdNone, sdSaved, sdCharon);
  TProxy = class
  private
    strProxy,
    strPort,
    strStatus,
    strGateway,
    strAnonymous,
    strLevel,
    strHTTP,
    strHTTPS,
    strSpeed,
    strPing: string;
    iPosition,
    iImageIndex: integer;

  public
    procedure ReadFromString(S: string);
    procedure ReadSavedData(S: string);
    procedure ReadCharonData(S: string);
    function WriteToString: string;
    function WriteSavedData: string;
    function WriteToMyList: string;
    function WriteCharonData: string;

    property Proxy: string read strProxy write strProxy;
    property Port: string read strPort write strPort;
    property Status: string read strStatus write strStatus;
    property Gateway: string read strGateway write strGateway;
    property Anonymous: string read strAnonymous write strAnonymous;
    property Level: string read strLevel write strLevel;
    property HTTP: string read strHTTP write strHTTP;
    property HTTPS: string read strHTTPS write strHTTPS;
    property Speed: string read strSpeed write strSpeed;
    property Ping: string read strPing write strPing;
    property Position: integer read iPosition write iPosition;
    property ImageIndex: integer read iImageIndex write iImageIndex;
  end;

  { see TObjectList from unit Contnrs.pas  }

  TAnalyzerList = class(TList)
  private
    FOwnsObjects: Boolean;
    FGood: integer;
    FBad: integer;
    FGateway: integer;
    FTimeout: integer;
    FUnknown: integer;
  protected
    procedure Notify(Ptr: Pointer; Action: TListNotification); override;
    function GetItem(Index: Integer): TProxy;
    procedure SetItem(Index: Integer; aItem: TProxy);
    procedure ReIndex;
    function FindDuplicates: Integer;
    procedure SortPositions;
    procedure Initialize;
  public
    constructor Create; overload;
    constructor Create(AOwnsObjects: Boolean); overload;
    constructor Create(const FileName: string); overload;

    function Add(aItem: TProxy): Integer;
    function Remove(aItem: TProxy): Integer;
    function IndexOf(aItem: TProxy): Integer;
    function FindInstanceOf(AClass: TClass; AExact: Boolean = True; AStartAt: Integer =
      0): Integer;
    procedure LoadFromFile(const FileName: string; FileStatus: TFileStatus; blnAppend: boolean);
    procedure LoadFromStrings(lstList: TStrings);
    procedure SaveToFile(const FileName: string; FileStatus: TFileStatus);
    procedure SortProxyAlpha (blnDecending: boolean);
    procedure SortPortAlpha (blnDecending: boolean);
    procedure SortStatusAlpha (blnDecending: boolean);
    procedure SortGatewayAlpha (blnDecending: boolean);
    procedure SortAnonymousAlpha (blnDecending: boolean);
    procedure SortLevelAlpha (blnDecending: boolean);
    procedure SortSpeedAlpha (blnDecending: boolean);
    procedure SortPingAlpha (blnDecending: boolean);
    procedure SortHTTPAlpha (blnDecending: boolean);
    procedure SortHTTPSAlpha (blnDecending: boolean);
    function RemoveDuplicates: integer;
    function DeleteGateways: integer;
    function DeleteBasedOnImage (const iImageIndex: integer): integer;
    procedure SetGood(Index: integer);
    procedure SetBad(Index: integer);
    procedure SetGateway(Index: integer);
    procedure SetUnknown(Index: integer);
    procedure SetTimeout(Index: integer);
    procedure Randomize;
    procedure UnsetProxy(Proxy: TProxy);

    property Bad: integer read FBad;
    property Gateway: integer read FGateway;
    property Good: integer read FGood;
    property Timeout: integer read FTimeout;
    property Unknown: integer read FUnknown;

    property OwnsObjects: Boolean read FOwnsObjects write FOwnsObjects;
    property Items[Index: Integer]: TProxy read GetItem write SetItem; default;
  end;

implementation

{ TProxy }

uses
  SysUtils, FastStrings, FastStringFuncs, uFunctions;

var
  blnReverse: boolean;

function ComparePosition (Item1, Item2: Pointer): Integer;
begin
  if TProxy(Item1).Position < TProxy(Item2).Position then
    Result := -1
  else if TProxy(Item1).Position > TProxy(Item2).Position then
    Result := 1
  else
    Result := 0;
end;

function InverseSign (const iNumber: integer) : integer;
begin
  Result := iNumber * -1;
end;

function DeleteNonPort (const strPort: string) : string;
var I: integer;

begin
  Result := '';
  for I := 1 to Length (strPort) do
   begin
    if strPort[I] in ['0'..'9'] then
     Result := Result + strPort[I]
    else
     Break;
   end;
end;

function CompareProxyAlpha(Item1, Item2: Pointer): Integer;
begin
  if TProxy(Item1).Proxy < TProxy(Item2).Proxy then
    Result := -1
  else if TProxy(Item1).Proxy > TProxy(Item2).Proxy then
    Result := 1
  else
    Result := 0;
  if blnReverse then
   Result := InverseSign (Result);
end;

function ComparePortAlpha(Item1, Item2: Pointer): Integer;
begin
  if StrToInt (TProxy(Item1).Port) < StrToInt (TProxy(Item2).Port) then
    Result := -1
  else if StrToInt (TProxy(Item1).Port) > StrToInt (TProxy(Item2).Port) then
    Result := 1
  else
    Result := 0;
  if blnReverse then
   Result := InverseSign (Result);
end;

function CompareStatusAlpha(Item1, Item2: Pointer): Integer;
begin
  if TProxy(Item1).Status < TProxy(Item2).Status then
    Result := -1
  else if TProxy(Item1).Status > TProxy(Item2).Status then
    Result := 1
  else
    Result := 0;
  if blnReverse then
   Result := InverseSign (Result);
end;

function CompareGatewayAlpha(Item1, Item2: Pointer): Integer;
begin
  if TProxy(Item1).Gateway < TProxy(Item2).Gateway then
    Result := -1
  else if TProxy(Item1).Gateway > TProxy(Item2).Gateway then
    Result := 1
  else
    Result := 0;
  if blnReverse then
   Result := InverseSign (Result);
end;

function CompareAnonymousAlpha(Item1, Item2: Pointer): Integer;
begin
  if TProxy(Item1).Anonymous < TProxy(Item2).Anonymous then
    Result := -1
  else if TProxy(Item1).Anonymous > TProxy(Item2).Anonymous then
    Result := 1
  else
    Result := 0;
  if blnReverse then
   Result := InverseSign (Result);
end;

function CompareLevelAlpha(Item1, Item2: Pointer): Integer;
begin
  if TProxy(Item1).Level < TProxy(Item2).Level then
    Result := -1
  else if TProxy(Item1).Level > TProxy(Item2).Level then
    Result := 1
  else
    Result := 0;
  if blnReverse then
   Result := InverseSign (Result);
end;

function CompareHTTPAlpha(Item1, Item2: Pointer): Integer;
begin
  if TProxy(Item1).HTTP < TProxy(Item2).HTTP then
    Result := -1
  else if TProxy(Item1).HTTP > TProxy(Item2).HTTP then
    Result := 1
  else
    Result := 0;
  if blnReverse then
   Result := InverseSign (Result);
end;

function CompareHTTPSAlpha(Item1, Item2: Pointer): Integer;
begin
  if TProxy(Item1).HTTPS < TProxy(Item2).HTTPS then
    Result := -1
  else if TProxy(Item1).HTTPS > TProxy(Item2).HTTPS then
    Result := 1
  else
    Result := 0;
  if blnReverse then
   Result := InverseSign (Result);
end;

function CompareSpeedAlpha(Item1, Item2: Pointer): Integer;
begin
  if (TProxy(Item1).Speed = '') and (TProxy(Item2).Speed = '') then
   begin
    Result := 0;
    Exit;
   end
  else if TProxy(Item1).Speed = '' then
   begin
    Result := 1;
    Exit;
   end
  else if TProxy(Item2).Speed = '' then
   begin
    Result := -1;
    Exit;
   end;
  if StrToInt (TProxy(Item1).Speed) < StrToInt (TProxy(Item2).Speed) then
    Result := -1
  else if StrToInt (TProxy(Item1).Speed) > StrToInt (TProxy(Item2).Speed) then
    Result := 1
  else
    Result := 0;
  if blnReverse then
   Result := InverseSign (Result);
end;

function ComparePingAlpha(Item1, Item2: Pointer): Integer;
begin
  if (TProxy(Item1).Ping = '') and (TProxy(Item2).Ping = '') then
   begin
    Result := 0;
    Exit;
   end
  else if TProxy(Item1).Ping = '' then
   begin
    Result := 1;
    Exit;
   end
  else if TProxy(Item2).Ping = '' then
   begin
    Result := -1;
    Exit;
   end;
  if StrToInt (TProxy(Item1).Ping) < StrToInt (TProxy(Item2).Ping) then
    Result := -1
  else if StrToInt (TProxy(Item1).Ping) > StrToInt (TProxy(Item2).Ping) then
    Result := 1
  else
    Result := 0;
  if blnReverse then
   Result := InverseSign (Result);
end;

procedure TProxy.ReadFromString(S: string);
 var iPos : integer;

begin
  // We start at 8 because if a proxy was x.x.x.x:80 then
  // this is the shortest possible proxy length which would
  // have the colon at 8th position, so there is no need to
  // start the search before the 8th position.
  if Length (S) < 9 then
   Exit;
  iPos := FastCharPos (S, ':', 8);
  if iPos <> 0 then
   begin
    strProxy := CopyStr (S, 1, iPos - 1);
    // A ';' in a proxy will cause an error when SavedData needs to be loaded.
    strProxy := FastReplace (strProxy, ';', '');

    // Max port number is 65636 so we only need 5 digits
    // from port
    strPort := CopyStr (S, iPos + 1, 5);
    strPort := DeleteNonPort (strPort);
   end;
end;

procedure TProxy.ReadSavedData (S: string);
var lstList: TStrings;

begin
  Split (S, ';', lstList);
  try
   strProxy := lstList.Strings[0];
   strPort := lstList.Strings[1];
   strStatus := lstList.Strings[2];
   strPing := lstList.Strings[3];
   strGateway := lstList.Strings[4];
   strAnonymous := lstList.Strings[5];
   strLevel := lstList.Strings[6];
   strHTTP := lstList.Strings[7];
   strHTTPS := lstList.Strings[8];
   strSpeed := lstList.Strings[9];
   iImageIndex := StrToInt (lstList.Strings[10]);
  finally
   lstList.Free;
  end;
end;

procedure TProxy.ReadCharonData(S: string);
var lstList: TStrings;

begin
  // Charon Format:
  // IP¦HOSTNAME¦PORT¦ANON¦PFH¦SPEED¦VIA¦GATEWAY¦SITERESPONSE¦CONNECT¦SOCKS¦SCORE¦COUNTRY¦STATUS¦DATE
  Split (S, '¦', lstList);
  try
   strProxy := lstList.Strings[0];
   strPort := lstList.Strings[2];
   strStatus := lstList.Strings[13];
   strPing := lstList.Strings[4];
   strGateway := lstList.Strings[7];
   strAnonymous := lstList.Strings[3];
   strLevel := lstList.Strings[11];
   // Charon can return a ping number in this column which
   // Sentry's sort wouldn't be able to handle
   if IsInteger (lstList.Strings[8]) then
    lstList.Strings[8] := 'Good'
   else
    strHTTP := lstList.Strings[8];
   strHTTPS := lstList.Strings[9];
   strSpeed := lstList.Strings[5];

   if strStatus = '' then
    iImageIndex := 0
   else if (strStatus = 'Good') or (strAnonymous = 'Yes') then
    iImageIndex := 2
   else if strStatus = 'Timeout' then
    iImageIndex := 4
   else
    iImageIndex := 3;
  finally
   lstList.Free;
  end;
end;

function TProxy.WriteToString: string;
begin
  Result := strProxy + ':' + strPort;
end;

function TProxy.WriteSavedData: string;
begin
  Result := strProxy + ';' + strPort + ';' + strStatus + ';' + strPing + ';' +
            strGateway + ';' + strAnonymous + ';' + strLevel + ';' + strHTTP +
            ';' + strHTTPS + ';' +  strSpeed + ';' + IntToStr (iImageIndex);
end;

function TProxy.WriteToMyList: string;
begin
  Result := strProxy + ';' + strPort + ';;0';
end;

function TProxy.WriteCharonData: string;
begin
  // Charon Format:
  // IP¦HOSTNAME¦PORT¦ANON¦PFH¦SPEED¦VIA¦GATEWAY¦SITERESPONSE¦CONNECT¦SOCKS¦SCORE¦COUNTRY¦STATUS¦DATE
  Result := strProxy + '¦¦' + strPort + '¦' + strAnonymous + '¦' + strPing + '¦' + strSpeed + '¦¦'
            + strGateway + '¦¦' + strHTTPS + '¦¦¦¦' + strStatus + '¦¦';
end;

{ TAnalyzerList }

function TAnalyzerList.Add(aItem: TProxy): Integer;
begin
  Result := inherited Add(aItem);
end;

constructor TAnalyzerList.Create;
begin
  Create(True);
end;

constructor TAnalyzerList.Create(AOwnsObjects: Boolean);
begin
  inherited Create;
  FOwnsObjects := AOwnsObjects;
end;

constructor TAnalyzerList.Create(const FileName: string);
begin
  Create(True);
  LoadFromFile(FileName, sdNone, False);
end;

function TAnalyzerList.FindInstanceOf(AClass: TClass; AExact: Boolean;
  AStartAt: Integer): Integer;

var
  I: Integer;

begin
  Result := -1;
  for I := AStartAt to Count - 1 do
    if (AExact and
      (Items[I].ClassType = AClass)) or
      (not AExact and
      Items[I].InheritsFrom(AClass)) then
    begin
      Result := I;
      Break;
    end;
end;

function TAnalyzerList.GetItem(Index: Integer): TProxy;
begin
  Result := inherited Items[Index];
end;

function TAnalyzerList.IndexOf(aItem: TProxy): Integer;
begin
  Result := inherited IndexOf(aItem);
end;

procedure TAnalyzerList.LoadFromFile(const FileName: string; FileStatus: TFileStatus; blnAppend: boolean);
var
  tf: TextFile;
  S: string;
  aProxy: TProxy;

begin
  if not FileExists(FileName) then Exit;

  if blnAppend = False then
   Clear;
  AssignFile(tf, FileName);
  Reset(tf);
  try
   while not EoF(tf) do
   begin
     ReadLn(tf, s);
     s := Trim (s);
     if s <> '' then
     begin
       aProxy := TProxy.Create;
       case FileStatus of
        sdNone: aProxy.ReadFromString (s);
        sdSaved: aProxy.ReadSavedData (s);
        sdCharon: aProxy.ReadCharonData (s);
       end;

       if (aProxy.Proxy = '') or (aProxy.Port = '') then
        aProxy.Free
       else
        Add(aProxy);
     end;
   end; // while
  finally
   CloseFile(tf);
   Initialize;
  end;
end;

procedure TAnalyzerList.LoadFromStrings(lstList: TStrings);
var I: integer;
    S: string;
    aProxy: TProxy;

begin
  for I := 0 to lstList.Count - 1 do
   begin
    S := Trim (lstList.Strings[I]);
    if S <> '' then
     begin
      aProxy := TProxy.Create;
      aProxy.ReadFromString (S);
      if (aProxy.Proxy = '') or (aProxy.Port = '') then
       aProxy.Free
      else
       Add (aProxy);
     end;
   end;
end;

procedure TAnalyzerList.Notify(Ptr: Pointer; Action: TListNotification);
begin
  if OwnsObjects then
    if Action = lnDeleted then
     begin
      UnsetProxy (TProxy (Ptr));

      TProxy (Ptr).Free;
     end;

  inherited Notify(Ptr, Action);
end;

function TAnalyzerList.Remove(aItem: TProxy): Integer;
begin
  Result := inherited Remove(aItem);
end;

procedure TAnalyzerList.SaveToFile(const FileName: string; FileStatus: TFileStatus);
var
  tf: TextFile;
  i: Integer;

begin
  if FileName = '' then Exit;

  AssignFile(tf, FileName);
  Rewrite(tf);
  try

   for i := 0 to Count - 1 do
     begin
      case FileStatus of
       sdNone: Writeln(tf, Items[i].WriteToString);
       sdSaved: Writeln(tf, Items[i].WriteSavedData);
       sdCharon: Writeln(tf, Items[i].WriteCharonData);
      end;
     end;
  finally
   CloseFile(tf);
  end;
end;

procedure TAnalyzerList.SetItem(Index: Integer; aItem: TProxy);
begin
  inherited Items[Index] := aItem;
end;

procedure TAnalyzerList.SortProxyAlpha (blnDecending: boolean);
begin
  blnReverse := blnDecending;
  inherited Sort(CompareProxyAlpha);
end;

procedure TAnalyzerList.SortPortAlpha (blnDecending: boolean);
begin
  blnReverse := blnDecending;
  inherited Sort(ComparePortAlpha);
end;

procedure TAnalyzerList.SortStatusAlpha (blnDecending: boolean);
begin
  blnReverse := blnDecending;
  inherited Sort(CompareStatusAlpha);
end;

procedure TAnalyzerList.SortGatewayAlpha (blnDecending: boolean);
begin
  blnReverse := blnDecending;
  inherited Sort(CompareGatewayAlpha);
end;

procedure TAnalyzerList.SortAnonymousAlpha (blnDecending: boolean);
begin
  blnReverse := blnDecending;
  inherited Sort(CompareAnonymousAlpha);
end;

procedure TAnalyzerList.SortLevelAlpha (blnDecending: boolean);
begin
  blnReverse := blnDecending;
  inherited Sort(CompareLevelAlpha);
end;

procedure TAnalyzerList.SortHTTPAlpha (blnDecending: boolean);
begin
  blnReverse := blnDecending;
  inherited Sort(CompareHTTPAlpha);
end;

procedure TAnalyzerList.SortHTTPSAlpha (blnDecending: boolean);
begin
  blnReverse := blnDecending;
  inherited Sort(CompareHTTPSAlpha);
end;

procedure TAnalyzerList.SortSpeedAlpha (blnDecending: boolean);
begin
  blnReverse := blnDecending;
  inherited Sort(CompareSpeedAlpha);
end;

procedure TAnalyzerList.SortPingAlpha (blnDecending: boolean);
begin
  blnReverse := blnDecending;
  inherited Sort(ComparePingAlpha);
end;

procedure TAnalyzerList.SortPositions;
begin
  inherited Sort(ComparePosition);
end;

procedure TAnalyzerList.ReIndex;
var I: integer;

begin
  for I := 0 to Count - 1 do
   Items[I].Position := I;
end;

function TAnalyzerList.FindDuplicates: Integer;
var
  i: Integer;

begin
  Result := 0;
  for i := Count - 1 downto 1 do
    if Items[i].Proxy = Items[i - 1].Proxy then
    begin
      Delete (i - 1);
      Inc(Result);
    end;
end;

function TAnalyzerList.RemoveDuplicates: integer;
begin
  ReIndex;
  SortProxyAlpha (False);
  Result := FindDuplicates;
  SortPositions;
end;

function TAnalyzerList.DeleteGateways: integer;
var I: integer;
begin
  Result := 0;
  for I := Count - 1 downto 0 do
   begin
    if (Items[I].Gateway <> 'No') and (Items[I].Proxy <> Items[I].Gateway) and (Items[I].Gateway <> '') then
     begin
      Delete (I);
      Inc (Result);
     end;
   end;
end;

function TAnalyzerList.DeleteBasedOnImage (const iImageIndex: integer): integer;
var I: integer;

begin
  Result := 0;

  for I := Count - 1 downto 0 do
   begin
    if Items[I].ImageIndex = iImageIndex then
     begin
      Delete (I);
      Inc (Result);
     end;
   end;
end;

procedure TAnalyzerList.SetGood(Index: integer);
begin
  Inc (FGood);
  Items[Index].ImageIndex := 2;
end;

procedure TAnalyzerList.SetBad(Index: integer);
begin
  Inc (FBad);
  Items[Index].ImageIndex := 3;
end;

procedure TAnalyzerList.SetGateway(Index: integer);
begin
  Inc (FGateway);
end;

procedure TAnalyzerList.SetUnknown(Index: integer);
begin
  Inc (FUnknown);
  Items[Index].ImageIndex := 5;
end;

procedure TAnalyzerList.SetTimeout(Index: integer);
begin
  Inc (FTimeout);
  Items[Index].ImageIndex := 4;
end;

procedure TAnalyzerList.Randomize;
var I: integer;

begin
  for I := 0 to Count - 1 do
   Items[I].Position := Random (Count);

  SortPositions;
end;

procedure TAnalyzerList.Initialize;
var I: integer;

begin
  for I := 0 to Count - 1 do
   begin
    case Items[I].ImageIndex of
     2: Inc (FGood);
     3: Inc (FBad);
     4: Inc (FTimeout);
     5: Inc (FUnknown);
    end;

    if Length (Items[I].Gateway) > 2 then
     Inc (FGateway);
   end;
end;

procedure TAnalyzerList.UnsetProxy(Proxy: TProxy);
begin
  case Proxy.ImageIndex of
   2: Dec (FGood);
   3: Dec (FBad);
   4: Dec (FTimeout);
   5: Dec (FUnknown);
  end;

  if Length (Proxy.Gateway) > 2 then
   Dec (FGateway);
end;

end.

