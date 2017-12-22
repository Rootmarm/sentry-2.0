unit uQuickLaunchMenu;

interface

uses
  SysUtils, Classes, Menus, Controls;

type
  TQuickLaunchItem = class
  private
    FName: string;
    FPath: string;
    FImageIndex: integer;
  public
    procedure ReadFromString(const S: string);
    function WriteToString: string;

    property Name: string read FName write FName;
    property Path: string read FPath write FPath;
    property ImageIndex: integer read FImageIndex write FImageIndex;
  end;

  TQuickLaunchList = class(TList)
  private
    procedure DeleteInvalidPaths;
  protected
    function GetItem(Index: Integer): TQuickLaunchItem;
    procedure SetItem(Index: Integer; aItem: TQuickLaunchItem);
    procedure Notify(Ptr: Pointer; Action: TListNotification); override;
  public
    function Add(aItem: TQuickLaunchItem): Integer;
    procedure LoadFromFile(const strFileName: string);
    procedure SaveToFile(const strFileName: string);

    property Items[Index: Integer]: TQuickLaunchItem read GetItem write SetItem; default;
  end;

  TQuickLaunchMenu = class(TComponent)
  private
    FMenu: TPopupMenu;
    FQuickLaunchList: TQuickLaunchList;
    FImageList: TImageList;

    procedure MenuItemClick(Sender: TObject);
    procedure EditQuickLaunchMenu(Sender: TObject);
    function AddImage(const strFileName: string): integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure PopulateMenu;
    procedure AddQuickLaunchItem(const strName, strPath: string);
    procedure Load;
    procedure Save;

    property ImageList: TImageList read FImageList;
    property Menu: TPopupMenu read FMenu write FMenu;
    property QuickLaunchList: TQuickLaunchList read FQuickLaunchList;
  end;

implementation

uses Windows, FastStrings, FastStringFuncs, ShellAPI, ExtCtrls, Graphics, Forms,
     ufrmQuickLaunch;

{ TQuickLaunchItem }

procedure TQuickLaunchItem.ReadFromString(const S: string);
var lstList: TStrings;

begin
  lstList := TStringList.Create;

  try
   Split (S, ';', lstList);

   FName := lstList.Strings[0];
   FPath := lstList.Strings[1];
   FImageIndex := StrToInt (lstList.Strings[2]);
  finally
   lstList.Free;
  end;
end;

function TQuickLaunchItem.WriteToString: string;
begin
  Result := FName + ';' + FPath + ';' + IntToStr (FImageIndex);
end;

{ TQuickLaunchList }

function TQuickLaunchList.Add(aItem: TQuickLaunchItem): Integer;
begin
  Result := inherited Add (aItem);
end;

procedure TQuickLaunchList.Notify(Ptr: Pointer; Action: TListNotification);
begin
  if Action = lnDeleted then
   TQuickLaunchItem (Ptr).Free;

  inherited Notify (Ptr, Action);
end;

function TQuickLaunchList.GetItem(Index: Integer): TQuickLaunchItem;
begin
  Result := inherited Items[Index];
end;

procedure TQuickLaunchList.SetItem(Index: Integer; aItem: TQuickLaunchItem);
begin
  inherited Items[Index] := aItem;
end;

procedure TQuickLaunchList.LoadFromFile(const strFileName: string);
var F: TextFile;
    S: string;
    aItem: TQuickLaunchItem;

begin
  Clear;

  AssignFile (F, strFileName);
  Reset (F);
  try
   while not Eof (F) do
    begin
     Readln (F, S);
     S := Trim (S);
     if S <> '' then
      begin
       aItem := TQuickLaunchItem.Create;

       aItem.ReadFromString (S);
       Add (aItem);
      end;
    end;
  finally
   CloseFile (F);
  end;

  DeleteInvalidPaths;
end;

procedure TQuickLaunchList.SaveToFile(const strFileName: string);
var F: TextFile;
    I: integer;

begin
  AssignFile (F, strFileName);
  Rewrite (F);

  try
   for I := 0 to Count - 1 do
    Writeln (F, Items[I].WriteToString);
  finally
   CloseFile (F);
  end;
end;

procedure TQuickLaunchList.DeleteInvalidPaths;
var I: integer;

begin
  for I := Count - 1 downto 0 do
   begin
    if FileExists (Items[I].Path) = False then
     Delete (I);
   end;
end;

{ TQuickLaunchMenu }

constructor TQuickLaunchMenu.Create(AOwner: TComponent);
begin
  inherited;

  FQuickLaunchList := TQuickLaunchList.Create;

  // Freed on Component Destroy
  FImageList := TImageList.Create (Self);
  FMenu := TPopupMenu.Create (Self);
  FMenu.Images := ImageList;
end;

destructor TQuickLaunchMenu.Destroy;
begin
  FQuickLaunchList.Free;

  inherited;
end;

procedure TQuickLaunchMenu.PopulateMenu;
var MyMenuItem: TMenuItem;
    I: integer;

begin
  FMenu.Items.Clear;

  for I := 0  to FQuickLaunchList.Count - 1 do
   begin
    // These Menus are freed either by FMenu.Clear
    // or automatically on program shutdown
    MyMenuItem := TMenuItem.Create (FMenu);

    with FQuickLaunchList.Items[I] do
     begin
      MyMenuItem.Caption := Name;
      // Tag contains position in list
      MyMenuItem.Tag := I;
      MyMenuItem.ImageIndex := ImageIndex;
     end;

    // Assign OnClick Event
    MyMenuItem.OnClick := MenuItemClick;

    FMenu.Items.Add (MyMenuItem);
   end;

  if FQuickLaunchList.Count > 0 then
   begin
    // Create Menu Seperator
    MyMenuItem := TMenuItem.Create (FMenu);
    MyMenuItem.Caption := '-';
    FMenu.Items.Add (MyMenuItem);
   end;

  // Add Edit Quick Launch Menu Item
  MyMenuItem := TMenuItem.Create (FMenu);
  MyMenuItem.Caption := 'Edit Quick Launch Menu';
  MyMenuItem.OnClick := EditQuickLaunchMenu;
  FMenu.Items.Add (MyMenuItem);
end;

procedure TQuickLaunchMenu.MenuItemClick(Sender: TObject);
begin
  // Tag contains position in list
  ShellExecute (0, 'open', PChar (FQuickLaunchList.Items[(Sender as TMenuItem).Tag].Path), nil, 'C:\', SW_SHOW);
end;

procedure TQuickLaunchMenu.EditQuickLaunchMenu(Sender: TObject);
var frmQuickLaunch: TfrmQuickLaunch;

begin
  frmQuickLaunch := TfrmQuickLaunch.Create (nil);

  try
   frmQuickLaunch.QuickLaunchMenu := Self;
   frmQuickLaunch.ShowModal;
  finally
   frmQuickLaunch.Free;
  end;

  Load;
  PopulateMenu;
end;

// Returns True if Image was added to the ImageList
function TQuickLaunchMenu.AddImage(const strFileName: string): integer;
var hCon: HIcon;
    MyImage: TImage;
    Ico: TIcon;

begin
  Result := -1;

  hCon := ExtractIcon ((Self.Owner as TForm).Handle, PChar (strFileName), 0);
  if hCon <> 0 then
   begin
    MyImage := TImage.Create (nil);
    try
     DrawIcon (MyImage.Canvas.Handle, 0, 0, hCon);

     Ico := TIcon.Create;
     try
      Ico.Handle := hCon;
      Result := FImageList.AddIcon (Ico);
     finally
      Ico.Free;
     end;

     DestroyIcon (hCon);
    finally
     MyImage.Free;
    end;
   end;
end;

procedure TQuickLaunchMenu.AddQuickLaunchItem(const strName, strPath: string);
var aItem: TQuickLaunchItem;

begin
  aItem := TQuickLaunchItem.Create;

  aItem.Name := strName;
  aItem.Path := strPath;
  aItem.ImageIndex := AddImage (strPath);

  FQuickLaunchList.Add (aItem);
end;

procedure TQuickLaunchMenu.Load;
var strFileName: string;
    I: integer;

begin
  strFileName := ExtractFilePath (ParamStr (0)) + 'QuickLaunch.ini';

  if FileExists (strFileName) then
   FQuickLaunchList.LoadFromFile (strFileName);

  // Build ImageList after Loading from File
  for I := 0 to FQuickLaunchList.Count - 1 do
   begin
    with FQuickLaunchList.Items[I] do
     ImageIndex := AddImage (Path);
   end;
end;

procedure TQuickLaunchMenu.Save;
begin
  FQuickLaunchList.SaveToFile (ExtractFilePath (ParamStr (0)) + 'QuickLaunch.ini');
end;

end.
