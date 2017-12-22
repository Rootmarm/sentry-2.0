unit uHistoryListView;

interface

uses
  Classes;

type
  TSite = class
  private
    strSite,
    strProxy,
    strStatus,
    strFailKeys,
    strSuccessKeys,
    strFormAction,
    strPOSTData,
    strReqMethod,
    strWordlist: string;
    iPosition,
    iImageIndex: integer;

  public
    procedure ReadSavedData(S: string);
    function WriteSavedData: string;

    property Site: string read strSite write strSite;
    property Proxy: string read strProxy write strProxy;
    property Status: string read strStatus write strStatus;
    property FailKeys: string read strFailKeys write strFailKeys;
    property SuccessKeys: string read strSuccessKeys write strSuccessKeys;
    property FormAction: string read strFormAction write strFormAction;
    property POSTData: string read strPOSTData write strPOSTData;
    property ReqMethod: string read strReqMethod write strReqMethod;
    property Wordlist: string read strWordlist write strWordlist;
    property Position: integer read iPosition write iPosition;
    property ImageIndex: integer read iImageIndex write iImageIndex;
  end;

  THistory = class(TList)
  private
    FOwnsObjects: Boolean;
    FDefaultReqMethod: string;
    FGood: integer;
    FBad: integer;
    FRedirect: integer;
    FTimeout: integer;
  protected
    procedure Notify(Ptr: Pointer; Action: TListNotification); override;
    function GetItem(Index: Integer): TSite;
    procedure SetItem(Index: Integer; aItem: TSite);
    procedure ReIndex;
    function FindDuplicates: Integer;
    procedure SortPositions;
    procedure Initialize;
  public
    constructor Create; overload;
    constructor Create(AOwnsObjects: Boolean); overload;
    constructor Create(const FileName: string); overload;

    function Add(aItem: TSite): Integer;
    function Remove(aItem: TSite): Integer;
    function IndexOf(aItem: TSite): Integer;
    function FindInstanceOf(AClass: TClass; AExact: Boolean = True; AStartAt: Integer =
      0): Integer;
    procedure LoadFromStrings(lstList: TStringList);
    procedure LoadFromFile(const FileName: string; blnSavedData, blnAppend: boolean);
    procedure SaveToFile(const FileName: string);
    procedure SortSiteAlpha (blnDecending: boolean);
    procedure SortSiteNameAlpha (blnDecending: boolean);
    procedure SortProxyAlpha (blnDecending: boolean);
    procedure SortStatusAlpha (blnDecending: boolean);
    procedure SortFailKeysAlpha (blnDecending: boolean);
    procedure SortSuccessKeysAlpha (blnDecending: boolean);
    procedure SortReqMethodAlpha (blnDecending: boolean);
    procedure SortFormActionAlpha (blnDecending: boolean);
    procedure SortPOSTDataAlpha (blnDecending: boolean);
    procedure SortWordlistAlpha (blnDecending: boolean);
    procedure SortUsernameAlpha (blnDecending: boolean);
    procedure SortPasswordAlpha (blnDecending: boolean);
    procedure SortImageIndexAlpha (blnDecending: boolean);
    procedure DeleteImageIndex(Index: integer);
    function RemoveDuplicates: integer;
    function Find(const S: string): integer;
    procedure SetGood(Index: integer);
    procedure SetBad(Index: integer);
    procedure SetRedirect(Index: integer);
    procedure SetTimeout(Index: integer);
    procedure UnsetSite(Site: TSite);

    property Bad: integer read FBad;
    property Redirect: integer read FRedirect;
    property Good: integer read FGood;
    property Timeout: integer read FTimeout;

    property DefaultReqMethod: string read FDefaultReqMethod write FDefaultReqMethod;
    property OwnsObjects: Boolean read FOwnsObjects write FOwnsObjects;
    property Items[Index: Integer]: TSite read GetItem write SetItem; default;
  end;

implementation

{ TSite }

uses
  SysUtils, FastStrings, FastStringFuncs, Dialogs, uFunctions;

var
  blnReverse: boolean;

function InverseSign (const iNumber: integer) : integer;
begin
  Result := iNumber * -1;
end;

function ComparePosition (Item1, Item2: Pointer): Integer;
begin
  if TSite(Item1).Position < TSite(Item2).Position then
    Result := -1
  else if TSite(Item1).Position > TSite(Item2).Position then
    Result := 1
  else
    Result := 0;
end;

function CompareSiteAlpha(Item1, Item2: Pointer): Integer;
begin
  if TSite(Item1).Site < TSite(Item2).Site then
    Result := -1
  else if TSite(Item1).Site > TSite(Item2).Site then
    Result := 1
  else
    Result := 0;
  if blnReverse then
   Result := InverseSign (Result);
end;

function CompareSiteNameAlpha(Item1, Item2: Pointer): Integer;
var strSite1, strSite2: string;

begin
  strSite1 := GetMembersURL (TSite(Item1).Site);
  strSite2 := GetMembersURL (TSite(Item2).Site);

  if strSite1 < strSite2 then
    Result := -1
  else if strSite1 > strSite2 then
    Result := 1
  else
    Result := 0;
  if blnReverse then
   Result := InverseSign (Result);
end;

function CompareUsernameAlpha(Item1, Item2: Pointer): Integer;
var strUser1, strUser2: string;

begin
  strUser1 := GetUsername (TSite(Item1).Site);

  strUser2 := GetUsername (TSite(Item2).Site);

  if strUser1 < strUser2 then
    Result := -1
  else if strUser1 > strUser2 then
    Result := 1
  else
    Result := 0;
  if blnReverse then
   Result := InverseSign (Result);
end;

function ComparePasswordAlpha(Item1, Item2: Pointer): Integer;
var strPass1, strPass2: string;

begin
  strPass1 := GetPassword (TSite(Item1).Site);
  strPass2 := GetPassword (TSite(Item2).Site);

  if strPass1 < strPass2 then
    Result := -1
  else if strPass1 > strPass2 then
    Result := 1
  else
    Result := 0;
  if blnReverse then
   Result := InverseSign (Result);
end;

function CompareImageIndexAlpha(Item1, Item2: Pointer): Integer;
begin
  if TSite(Item1).ImageIndex < TSite(Item2).ImageIndex then
    Result := -1
  else if TSite(Item2).ImageIndex > TSite(Item2).ImageIndex then
    Result := 1
  else
    Result := 0;
  if blnReverse then
   Result := InverseSign (Result);
end;

function CompareProxyAlpha(Item1, Item2: Pointer): Integer;
begin
  if TSite(Item1).Proxy < TSite(Item2).Proxy then
    Result := -1
  else if TSite(Item1).Proxy > TSite(Item2).Proxy then
    Result := 1
  else
    Result := 0;
  if blnReverse then
   Result := InverseSign (Result);
end;

function CompareStatusAlpha(Item1, Item2: Pointer): Integer;
begin
  if TSite(Item1).Status < TSite(Item2).Status then
    Result := -1
  else if TSite(Item1).Status > TSite(Item2).Status then
    Result := 1
  else
    Result := 0;
  if blnReverse then
   Result := InverseSign (Result);
end;

function CompareFailKeysAlpha(Item1, Item2: Pointer): Integer;
begin
  if TSite(Item1).FailKeys < TSite(Item2).FailKeys then
    Result := -1
  else if TSite(Item1).FailKeys > TSite(Item2).FailKeys then
    Result := 1
  else
    Result := 0;
  if blnReverse then
   Result := InverseSign (Result);
end;

function CompareSuccessKeysAlpha(Item1, Item2: Pointer): Integer;
begin
  if TSite(Item1).SuccessKeys < TSite(Item2).SuccessKeys then
    Result := -1
  else if TSite(Item1).SuccessKeys > TSite(Item2).SuccessKeys then
    Result := 1
  else
    Result := 0;
  if blnReverse then
   Result := InverseSign (Result);
end;

function CompareReqMethodAlpha(Item1, Item2: Pointer): Integer;
begin
  if TSite(Item1).ReqMethod < TSite(Item2).ReqMethod then
    Result := -1
  else if TSite(Item1).ReqMethod > TSite(Item2).ReqMethod then
    Result := 1
  else
    Result := 0;
  if blnReverse then
   Result := InverseSign (Result);
end;

function CompareFormActionAlpha(Item1, Item2: Pointer): Integer;
begin
  if TSite(Item1).FormAction < TSite(Item2).FormAction then
    Result := -1
  else if TSite(Item1).FormAction > TSite(Item2).FormAction then
    Result := 1
  else
    Result := 0;
  if blnReverse then
   Result := InverseSign (Result);
end;

function ComparePOSTDataAlpha(Item1, Item2: Pointer): Integer;
begin
  if TSite(Item1).POSTData < TSite(Item2).POSTData then
    Result := -1
  else if TSite(Item1).POSTData > TSite(Item2).POSTData then
    Result := 1
  else
    Result := 0;
  if blnReverse then
   Result := InverseSign (Result);
end;

function CompareWordlistAlpha(Item1, Item2: Pointer): Integer;
begin
  if TSite(Item1).Wordlist < TSite(Item2).Wordlist then
    Result := -1
  else if TSite(Item1).Wordlist > TSite(Item2).Wordlist then
    Result := 1
  else
    Result := 0;
  if blnReverse then
   Result := InverseSign (Result);
end;

procedure TSite.ReadSavedData (S: string);
var lstList: TStrings;

begin
  lstList := TStringList.Create;
  try
   Split (S, '|', lstList);
   strSite := lstList.Strings[0];
   strProxy := lstList.Strings[1];
   strStatus := lstList.Strings[2];
   strFailKeys := lstList.Strings[3];
   strSuccessKeys := lstList.Strings[4];
   strFormAction := lstList.Strings[5];
   strPOSTData := lstList.Strings[6];
   strReqMethod := lstList.Strings[7];
   strWordlist := lstList.Strings[8];
   iImageIndex := StrToInt (lstList.Strings[9]);
  finally
   lstList.Free;
  end;
end;

function TSite.WriteSavedData: string;
begin
  Result := strSite + '|' +  strProxy + '|' + strStatus + '|' +
            strFailKeys + '|' + strSuccessKeys + '|' + strFormAction + '|' +
            strPOSTData + '|' + strReqMethod + '|' + strWordlist + '|' +
            IntToStr (iImageIndex);
end;

{ THistory }

function THistory.Add(aItem: TSite): Integer;
begin
  Result := inherited Add(aItem);
end;

constructor THistory.Create;
begin
  Create(True);
end;

constructor THistory.Create(AOwnsObjects: Boolean);
begin
  inherited Create;
  FOwnsObjects := AOwnsObjects;
end;

constructor THistory.Create(const FileName: string);
begin
  Create(True);
  LoadFromFile(FileName, False, False);
end;

function THistory.FindInstanceOf(AClass: TClass; AExact: Boolean;
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

function THistory.GetItem(Index: Integer): TSite;
begin
  Result := inherited Items[Index];
end;

function THistory.IndexOf(aItem: TSite): Integer;
begin
  Result := inherited IndexOf(aItem);
end;

procedure THistory.LoadFromStrings(lstList: TStringList);
var S: string;
    aSite: TSite;
    I: integer;

begin
  for I := 0 to lstList.Count - 1 do
   begin
    S := Trim (lstList.Strings[I]);
    if S <> '' then
     begin
      aSite := TSite.Create;
      aSite.Site := S;
      aSite.ReqMethod := FDefaultReqMethod;
      Add (aSite);
     end;
   end;
end;

procedure THistory.LoadFromFile(const FileName: string; blnSavedData, blnAppend: boolean);
var
  tf: TextFile;
  S: string;
  aSite: TSite;

begin
  if blnAppend = False then
   Clear;
  AssignFile(tf, FileName);
  Reset(tf);
  try
   while not Eof(tf) do
   begin
     Readln(tf, s);
     s := Trim (s);
     if s <> '' then
     begin
       aSite := TSite.Create;
       if blnSavedData then
        begin
         try
          aSite.ReadSavedData (s);
         except
          FreeAndNil (aSite);
         end;
        end
       else
        begin
         aSite.Site := s;
         aSite.ReqMethod := FDefaultReqMethod;
        end;
       if Assigned (aSite) then
        Add(aSite);
     end;
   end;
  finally
   CloseFile(tf);
   Initialize;
  end;
end;

procedure THistory.Notify(Ptr: Pointer; Action: TListNotification);
begin
  if OwnsObjects then
    if Action = lnDeleted then
      begin
       UnsetSite (TSite (Ptr));
       TSite (Ptr).Free;
      end;

  inherited Notify(Ptr, Action);
end;

function THistory.Remove(aItem: TSite): Integer;
begin
  Result := inherited Remove(aItem);
end;

procedure THistory.SaveToFile(const FileName: string);
var
  tf: TextFile;
  i: Integer;

begin
  AssignFile(tf, FileName);
  Rewrite(tf);

  try
   for i := 0 to Count - 1 do
    Writeln(tf, Items[i].WriteSavedData)
  finally
   CloseFile(tf);
  end;
end;

procedure THistory.SetItem(Index: Integer; aItem: TSite);
begin
  inherited Items[Index] := aItem;
end;

procedure THistory.SortSiteAlpha (blnDecending: boolean);
begin
  blnReverse := blnDecending;
  inherited Sort(CompareSiteAlpha);
end;

procedure THistory.SortSiteNameAlpha (blnDecending: boolean);
begin
  blnReverse := blnDecending;
  inherited Sort(CompareSiteNameAlpha);
end;

procedure THistory.SortProxyAlpha (blnDecending: boolean);
begin
  blnReverse := blnDecending;
  inherited Sort(CompareProxyAlpha);
end;

procedure THistory.SortStatusAlpha (blnDecending: boolean);
begin
  blnReverse := blnDecending;
  inherited Sort(CompareStatusAlpha);
end;

procedure THistory.SortFailKeysAlpha (blnDecending: boolean);
begin
  blnReverse := blnDecending;
  inherited Sort(CompareFailKeysAlpha);
end;

procedure THistory.SortSuccessKeysAlpha (blnDecending: boolean);
begin
  blnReverse := blnDecending;
  inherited Sort(CompareSuccessKeysAlpha);
end;

procedure THistory.SortReqMethodAlpha (blnDecending: boolean);
begin
  blnReverse := blnDecending;
  inherited Sort(CompareReqMethodAlpha);
end;

procedure THistory.SortFormActionAlpha (blnDecending: boolean);
begin
  blnReverse := blnDecending;
  inherited Sort(CompareFormActionAlpha);
end;

procedure THistory.SortPOSTDataAlpha (blnDecending: boolean);
begin
  blnReverse := blnDecending;
  inherited Sort(ComparePOSTDataAlpha);
end;

procedure THistory.SortWordlistAlpha (blnDecending: boolean);
begin
  blnReverse := blnDecending;
  inherited Sort(CompareWordlistAlpha);
end;

procedure THistory.SortUsernameAlpha (blnDecending: boolean);
begin
  blnReverse := blnDecending;
  inherited Sort(CompareUsernameAlpha);
end;

procedure THistory.SortPasswordAlpha (blnDecending: boolean);
begin
  blnReverse := blnDecending;
  inherited Sort(ComparePasswordAlpha);
end;

procedure THistory.SortImageIndexAlpha (blnDecending: boolean);
begin
  blnReverse := blnDecending;
  inherited Sort(CompareImageIndexAlpha);
end;

procedure THistory.SortPositions;
begin
  inherited Sort(ComparePosition);
end;

procedure THistory.ReIndex;
var I: integer;

begin
  for I := 0 to Count - 1 do
   Items[I].Position := I;
end;

function THistory.FindDuplicates: Integer;
var i: Integer;

begin
  Result := 0;
  for i := Count - 1 downto 1 do
    if Items[i].Site = Items[i - 1].Site then
    begin
      Delete (i - 1);
      Inc(Result);
    end;
end;

procedure THistory.DeleteImageIndex(Index: integer);
var I: integer;

begin
  for I := Count - 1 downto 0 do
   begin
    if Items[I].ImageIndex = Index then
     Delete (I);
   end;
end;

function THistory.RemoveDuplicates: integer;
begin
  ReIndex;
  SortSiteAlpha (False);
  Result := FindDuplicates;
  SortPositions;
end;

function THistory.Find(const S: string): integer;
var I: integer;

begin
  Result := 0;

  for I := 0 to Count - 1 do
   begin
    if FastPos (Items[I].Site, S, Length (Items[I].Site), Length (S), 1) <> 0 then
     begin
      Move (I, 0);
      Inc (Result);
     end;
   end;
end;

procedure THistory.Initialize;
var I: integer;

begin
  for I := 0 to Count - 1 do
   begin
    case Items[I].ImageIndex of
     2: Inc (FGood);
     3: Inc (FBad);
     4: Inc (FTimeout);
     5: Inc (FRedirect);
    end;
   end;
end;

procedure THistory.SetGood(Index: integer);
begin
  Inc (FGood);
  Items[Index].ImageIndex := 2;
end;

procedure THistory.SetBad(Index: integer);
begin
  Inc (FBad);
  Items[Index].ImageIndex := 3;
end;

procedure THistory.SetRedirect(Index: integer);
begin
  Inc (FRedirect);
  Items[Index].ImageIndex := 5;
end;

procedure THistory.SetTimeout(Index: integer);
begin
  Inc (FTimeout);
  Items[Index].ImageIndex := 4;
end;

procedure THistory.UnsetSite(Site: TSite);
begin
  case Site.ImageIndex of
   2: Dec (FGood);
   3: Dec (FBad);
   4: Dec (FTimeout);
   5: Dec (FRedirect);
  end;
end;

end.

