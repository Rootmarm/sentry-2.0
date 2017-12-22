unit uMyListListView;

interface

uses
  Classes;

// Image Indexes for respective states
const
  bmpACTIVE = 0;
  bmpDISABLED = 1;
  bmpBANNED = 7;

type
  TProxy = class
  private
    strProxy,
    strPort,
    strStatus: string;
    iPosition,
    iImageIndex: integer;

  public
    procedure ReadFromString(S: string);
    procedure ReadBlacklist(S: string);
    procedure ReadSavedData(S: string);
    function WriteToString: string;
    function WriteSavedData: string;

    property Proxy: string read strProxy write strProxy;
    property Port: string read strPort write strPort;
    property Status: string read strStatus write strStatus;
    property Position: integer read iPosition write iPosition;
    property ImageIndex: integer read iImageIndex write iImageIndex;
  end;

  { see TObjectList from unit Contnrs.pas  }

  TMyList = class(TList)
  private
    FOwnsObjects: Boolean;
    FDisabled: integer;
    FBanned: integer;
  protected
    procedure Notify(Ptr: Pointer; Action: TListNotification); override;
    function GetItem(Index: Integer): TProxy;
    procedure SetItem(Index: Integer; aItem: TProxy);
    function GetActive: integer;
    procedure ReIndex;
    procedure Initialize;
    function FindDuplicates: Integer;
    procedure FindBlacklistDuplicates;
    procedure SortPositions;
    procedure CompareAgainstBlacklist;
  public
    constructor Create; overload;
    constructor Create(AOwnsObjects: Boolean); overload;
    constructor Create(const FileName: string); overload;

    function Add(aItem: TProxy): Integer;
    function Remove(aItem: TProxy): Integer;
    function IndexOf(aItem: TProxy): Integer;
    function FindInstanceOf(AClass: TClass; AExact: Boolean = True; AStartAt: Integer =
      0): Integer;
    procedure LoadFromStrings(lstList: TStrings);
    procedure LoadFromFile(const FileName: string; blnSavedData, blnAppend: boolean);
    procedure SaveToFile(const FileName: string; blnSavedData: boolean);
    procedure SortProxyAlpha (blnDecending: boolean);
    procedure SortPortAlpha (blnDecending: boolean);
    procedure SortStatusAlpha (blnDecending: boolean);
    procedure ReactivateProxy(const Index: integer);
    procedure DisableProxy(const Index: integer; const strReason: string);
    procedure BanProxy(const Index: integer; const strReason: string);
    function  RemoveDuplicates: integer;
    procedure ReactivateAllProxies;
    function  SetProxyInList(const strProxyAndPort: string; const iAction: integer): boolean;

    property OwnsObjects: Boolean read FOwnsObjects write FOwnsObjects;
    property Active: integer read GetActive;
    property Banned: integer read FBanned;
    property Disabled: integer read FDisabled;
    property Items[Index: Integer]: TProxy read GetItem write SetItem; default;
  end;

implementation

{ TProxy }

uses
  SysUtils, FastStrings, FastStringFuncs;

var
  blnReverse: boolean;

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

function ComparePosition (Item1, Item2: Pointer): Integer;
begin
  if TProxy(Item1).Position < TProxy(Item2).Position then
    Result := -1
  else if TProxy(Item1).Position > TProxy(Item2).Position then
    Result := 1
  else
    Result := 0;
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

procedure TProxy.ReadFromString(S: string);
var iPos : integer;

begin
  // 8 = min length of a valid proxy
  iPos := FastCharPos (S, ':', 8);
  if iPos <> 0 then
   begin
    strProxy := CopyStr (S, 1, iPos - 1);
    strPort := CopyStr (S, iPos + 1, 5);
    strPort := DeleteNonPort (strPort);
   end;
end;

procedure TProxy.ReadBlacklist(S: string);
begin
  strProxy := S;
  strStatus := 'B';
end;

procedure TProxy.ReadSavedData (S: string);
var lstList: TStrings;

begin
  lstList := TStringList.Create;
  try
   Split (S, ';', lstList);
   strProxy := lstList.Strings[0];
   strPort := lstList.Strings[1];
   strStatus := lstList.Strings[2];
   iImageIndex := StrToInt (lstList.Strings[3]);
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
  Result := strProxy + ';' + strPort + ';' + strStatus + ';' + IntToStr (iImageIndex);
end;

{ TMyList }

function TMyList.Add(aItem: TProxy): Integer;
begin
  Result := inherited Add(aItem);
end;

constructor TMyList.Create;
begin
  Create(True);
end;

constructor TMyList.Create(AOwnsObjects: Boolean);
begin
  inherited Create;
  FOwnsObjects := AOwnsObjects;
end;

constructor TMyList.Create(const FileName: string);
begin
  Create(True);
  LoadFromFile(FileName, True, False);
end;

function TMyList.FindInstanceOf(AClass: TClass; AExact: Boolean;
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

function TMyList.GetItem(Index: Integer): TProxy;
begin
  Result := inherited Items[Index];
end;

function TMyList.IndexOf(aItem: TProxy): Integer;
begin
  Result := inherited IndexOf(aItem);
end;

procedure TMyList.LoadFromStrings(lstList: TStrings);
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
      if aProxy.Port <> '' then
       Add(aProxy);
     end;
   end;

  CompareAgainstBlacklist;
end;

procedure TMyList.LoadFromFile(const FileName: string; blnSavedData, blnAppend: boolean);
var
  tf: TextFile;
  S: string;
  aProxy: TProxy;

begin
  if FileExists (FileName) = False then
   Exit;

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
       if blnSavedData then
        aProxy.ReadSavedData (s)
       else
        aProxy.ReadFromString(s);

       if aProxy.Port <> '' then
        Add(aProxy);
     end;
   end;
  finally
   CloseFile(tf);
   CompareAgainstBlacklist;
   Initialize;
  end;
end;

procedure TMyList.Notify(Ptr: Pointer; Action: TListNotification);
begin
  if OwnsObjects then
    if Action = lnDeleted then
      begin
       if TProxy(Ptr).ImageIndex = bmpDISABLED then
        Dec (FDisabled)
       else if TProxy (Ptr).ImageIndex = bmpBANNED then
        Dec (FBanned);
       TProxy (Ptr).Free;
      end;
  inherited Notify (Ptr, Action);
end;

function TMyList.Remove(aItem: TProxy): Integer;
begin
  Result := inherited Remove (aItem);
end;

procedure TMyList.SaveToFile(const FileName: string; blnSavedData: boolean);
var
  tf: TextFile;
  i: Integer;

begin
  AssignFile(tf, FileName);
  Rewrite(tf);
  try

   for i := 0 to Count - 1 do
     begin
      if blnSavedData then
       Writeln(tf, Items[i].WriteSavedData)
      else
       Writeln(tf, Items[i].WriteToString);
     end;
  finally
   CloseFile(tf);
  end;
end;

procedure TMyList.SetItem(Index: Integer; aItem: TProxy);
begin
  inherited Items[Index] := aItem;
end;

procedure TMyList.SortProxyAlpha (blnDecending: boolean);
begin
  blnReverse := blnDecending;
  inherited Sort(CompareProxyAlpha);
end;

procedure TMyList.SortPortAlpha (blnDecending: boolean);
begin
  blnReverse := blnDecending;
  inherited Sort(ComparePortAlpha);
end;

procedure TMyList.SortStatusAlpha (blnDecending: boolean);
begin
  blnReverse := blnDecending;
  inherited Sort(CompareStatusAlpha);
end;

procedure TMyList.SortPositions;
begin
  inherited Sort(ComparePosition);
end;

function TMyList.GetActive: integer;
begin
  Result := Count - FDisabled - FBanned;
end;

procedure TMyList.ReactivateProxy(const Index: integer);
begin
  with Items[Index] do
   begin
    if ImageIndex = bmpDISABLED then
     begin
      ImageIndex := bmpACTIVE;
      Dec (FDisabled);
      Status := 'Reactivated';
     end;
   end;
end;

procedure TMyList.BanProxy(const Index: integer; const strReason: string);
begin
  with Items[Index] do
   begin
    if ImageIndex = bmpACTIVE then
     begin
      ImageIndex := bmpBANNED;
      Inc (FBanned);
      Status := strReason;
     end;
   end;
end;

procedure TMyList.DisableProxy(const Index: integer; const strReason: string);
begin
  with Items[Index] do
   begin
    if ImageIndex = bmpACTIVE then
     begin
      ImageIndex := bmpDISABLED;
      Inc (FDisabled);
      Status := strReason;
     end;
   end;
end;

procedure TMyList.Initialize;
var I: integer;

begin
  FBanned := 0;
  FDisabled := 0;

  for I := 0 to Count - 1 do
   begin
    case Items[I].ImageIndex of
     bmpDISABLED: Inc (FDisabled);
     bmpBANNED: Inc (FBanned);
    end;
   end;
end;

procedure TMyList.ReIndex;
var I: integer;

begin
  for I := 0 to Count - 1 do
   Items[I].Position := I;
end;

function TMyList.FindDuplicates: Integer;
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

procedure TMyList.FindBlacklistDuplicates;
var
  i: Integer;

begin
  for i := Count - 1 downto 1 do
    if Items[i].Proxy = Items[i - 1].Proxy then
    begin
      Items[i].Status := 'D';
      Items[i - 1].Status := 'D';
    end;
end;

function TMyList.RemoveDuplicates: integer;
begin
  ReIndex;
  SortProxyAlpha (False);
  Result := FindDuplicates;
  SortPositions;
end;

procedure TMyList.ReactivateAllProxies;
var I: integer;

begin
  for I := 0 to Count - 1 do
   ReactivateProxy (I);
end;

// Proxy is in the format of proxy:port
function TMyList.SetProxyInList(const strProxyAndPort: string; const iAction: integer): boolean;
var I: integer;

begin
  Result := False;

  for I := 0 to Count - 1 do
   begin
    if (Items[I].WriteToString = strProxyAndPort) then
     begin
      case iAction of
       bmpDISABLED: DisableProxy (I, 'Disabled by User');
       bmpBANNED: BanProxy (I, 'Banned by User');
      end;
      Result := True;
      Break;
     end;
   end;
end;

procedure TMyList.CompareAgainstBlacklist;
var strFile, strLine: string;
    aProxy: TProxy;
    F: TextFile;
    I: integer;

begin
  strFile := ExtractFilePath (ParamStr (0)) + 'Blacklist.ini';
  if FileExists (strFile) then
   begin
    AssignFile (F, strFile);
    Reset (F);
    try
     while not Eof (F) do
      begin
       Readln (F, strLine);
       strLine := Trim (strLine);

       if strLine <> '' then
        begin
         aProxy := TProxy.Create;
         aProxy.ReadBlacklist (strLine);

         Add (aProxy);
        end;
      end;
    finally
     CloseFile (F);
    end;

    ReIndex;
    SortProxyAlpha (False);
    FindBlacklistDuplicates;

    for I := Count - 1 downto 0 do
     begin
      if (Items[I].Status = 'B') or (Items[I].Status = 'D') then
       Delete (I);
     end;

    SortPositions;
  end;
end;

end.

