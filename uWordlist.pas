unit uWordlist;

interface

uses
  Classes;

type
  TCombo = class
  private
    strUser,
    strPass: string;
  public
    procedure ReadFromString(S: string);
    function WriteToString: string;

    property User: string read strUser write strUser;
    property Pass: string read strPass write strPass;
  end;

  { see TObjectList from unit Contnrs.pas  }

  TWordlist = class(TList)
  private
    FOwnsObjects: Boolean;
    FWordlist: string;
  protected
    procedure Notify(Ptr: Pointer; Action: TListNotification); override;
    function GetItem(Index: Integer): TCombo;
    procedure SetItem(Index: Integer; aItem: TCombo);
  public
    constructor Create; overload;
    constructor Create(AOwnsObjects: Boolean); overload;
    constructor Create(const FileName: string); overload;
    procedure LoadFromFile(const FileName: string);
    procedure SaveToFile(const FileName: string);
    procedure Clear; override;

    property Wordlist: string read FWordlist;
    property OwnsObjects: Boolean read FOwnsObjects write FOwnsObjects;
    property Items[Index: Integer]: TCombo read GetItem write SetItem; default;
  end;

implementation

{ TCombo }

uses
  SysUtils, FastStrings, FastStringFuncs;


procedure TCombo.ReadFromString(S: string);
 var iPos : integer;

begin
  iPos := FastCharPos (S, ':', 1);
  if iPos = 0 then
   Exit
  else
   begin
    strUser := CopyStr (S, 1, iPos - 1);
    strPass := TrimRight (CopyStr (S, iPos + 1, Length (S)));
   end;
end;

function TCombo.WriteToString: string;
begin
  Result := strUser + ':' + strPass;
end;

{ TWordlist }

constructor TWordlist.Create;
begin
  Create(True);
end;

constructor TWordlist.Create(AOwnsObjects: Boolean);
begin
  inherited Create;
  FOwnsObjects := AOwnsObjects;
end;

constructor TWordlist.Create(const FileName: string);
begin
  Create(True);
  LoadFromFile(FileName);
end;

function TWordlist.GetItem(Index: Integer): TCombo;
begin
  Result := inherited Items[Index];
end;

procedure TWordlist.LoadFromFile(const FileName: string);
var
  tf: TextFile;
  S: string;
  aCombo: TCombo;

begin
  Clear;
  AssignFile(tf, FileName);
  Reset(tf);
  try
   while not EoF(tf) do
   begin
     Readln(tf, s);
     s := Trim (s);
     if s <> '' then
     begin
       aCombo := TCombo.Create;
       aCombo.ReadFromString(s);
       if aCombo.User <> '' then
        Add(aCombo)
       else
        aCombo.Free;
     end;
   end; // while
  finally
   CloseFile(tf);
   FWordlist := FileName;
  end;
end;

procedure TWordlist.Notify(Ptr: Pointer; Action: TListNotification);
begin
  if OwnsObjects then
    if Action = lnDeleted then
      TCombo(Ptr).Free;
  inherited Notify(Ptr, Action);
end;

procedure TWordlist.SaveToFile(const FileName: string);
var
  tf: TextFile;
  i: Integer;

begin
  if FileName = '' then Exit;

  AssignFile(tf, FileName);
  Rewrite(tf);
  try
   for i := 0 to Count - 1 do
     Writeln(tf, Items[i].WriteToString);
  finally
   CloseFile(tf);
  end;
end;

procedure TWordlist.SetItem(Index: Integer; aItem: TCombo);
begin
  inherited Items[Index] := aItem;
end;

procedure TWordlist.Clear;
begin
  inherited;
  FWordlist := '';
end;

end.

