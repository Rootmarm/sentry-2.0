unit uFrameListsBlacklist;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, ComCtrls, Buttons, uBlacklist, Menus;

type
  TfrmListsBlacklist = class(TFrame)
    lstCBlacklist: TListView;
    Label1: TLabel;
    cmdClear: TSpeedButton;
    cmdLoad: TSpeedButton;
    cmdSave: TSpeedButton;
    mnuBlacklist: TPopupMenu;
    DeleteSelectedProxies1: TMenuItem;
    ClearList1: TMenuItem;
    N1: TMenuItem;
    LoadProxiesFromFile1: TMenuItem;
    SaveProxiesToFile1: TMenuItem;
    procedure lstCBlacklistData(Sender: TObject; Item: TListItem);
    procedure cmdLoadClick(Sender: TObject);
    procedure cmdClearClick(Sender: TObject);
    procedure cmdSaveClick(Sender: TObject);
    procedure DeleteSelectedProxies1Click(Sender: TObject);
    procedure ClearList1Click(Sender: TObject);
    procedure LoadProxiesFromFile1Click(Sender: TObject);
    procedure SaveProxiesToFile1Click(Sender: TObject);
    procedure lstCBlacklistKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    lstBlacklist: TBlacklist;

    procedure UpdateBlacklist;
  public
    procedure LoadVariables;
    procedure SaveVariables;
  end;

implementation

uses ufrmMain;

{$R *.dfm}

procedure TfrmListsBlacklist.UpdateBlacklist;
begin
  lstCBlacklist.Items.BeginUpdate;
  try
   lstCBlacklist.Items.Count := lstBlacklist.Count;
  finally
   lstCBlacklist.Items.EndUpdate;
  end;

  frmSentry.StatusBar.Panels[0].Text := 'Displaying ' + IntToStr (lstBlacklist.Count) + ' Proxies in Blacklist';
end;

procedure TfrmListsBlacklist.lstCBlacklistData(Sender: TObject; Item: TListItem);
begin
  if Item.Index >= lstBlacklist.Count then
   Exit;

  Item.Caption := lstBlacklist.Strings[Item.Index];
end;

procedure TfrmListsBlacklist.cmdLoadClick(Sender: TObject);
var I: integer;

begin
  frmSentry.OpenDialog.Options := frmSentry.OpenDialog.Options + [ofAllowMultiSelect];

  if frmSentry.OpenDialog.Execute then
   begin
    for I := 0 to frmSentry.OpenDialog.Files.Count - 1 do
     lstBlacklist.AppendFromFile (frmSentry.OpenDialog.Files.Strings[I]);
    UpdateBlacklist;
   end;

  frmSentry.OpenDialog.Options := frmSentry.OpenDialog.Options - [ofAllowMultiSelect];
end;

procedure TfrmListsBlacklist.cmdClearClick(Sender: TObject);
begin
  lstBlacklist.Clear;
  UpdateBlacklist;
end;

procedure TfrmListsBlacklist.LoadVariables;
var strFile: string;

begin
  lstBlacklist := TBlacklist.Create;
  lstBlacklist.Sorted := True;
  lstBlacklist.Duplicates := dupIgnore;

  strFile := strLocPath + 'Blacklist.ini';
  if FileExists (strFile) then
   begin
    lstBlacklist.LoadFromFile (strFile);
    UpdateBlacklist;
   end;
end;

procedure TfrmListsBlacklist.SaveVariables;
begin
  lstCBlacklist.OnData := nil;

  lstBlacklist.SaveToFile (strLocPath + 'Blacklist.ini');
  lstBlacklist.Free;
end;

procedure TfrmListsBlacklist.cmdSaveClick(Sender: TObject);
begin
  if frmSentry.SaveDialog.Execute then
   lstBlacklist.SaveToFile (frmSentry.SaveDialog.FileName);
end;

procedure TfrmListsBlacklist.DeleteSelectedProxies1Click(Sender: TObject);
var I: integer;

begin
  for I := lstBlacklist.Count - 1 downto 0 do
   begin
    if lstCBlacklist.Items[I].Selected then
     lstBlacklist.Delete (I);
   end;
  UpdateBlacklist;
  lstCBlacklist.ClearSelection;
end;

procedure TfrmListsBlacklist.ClearList1Click(Sender: TObject);
begin
  cmdClearClick (nil);
end;

procedure TfrmListsBlacklist.LoadProxiesFromFile1Click(Sender: TObject);
begin
  cmdLoadClick (nil);
end;

procedure TfrmListsBlacklist.SaveProxiesToFile1Click(Sender: TObject);
begin
  cmdSaveClick (nil);
end;

procedure TfrmListsBlacklist.lstCBlacklistKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
   46: DeleteSelectedProxies1Click (nil);
   65: lstCBlacklist.SelectAll;
  end;
end;

end.
