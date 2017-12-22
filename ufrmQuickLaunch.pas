unit ufrmQuickLaunch;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Buttons, ImgList, ExtCtrls, Menus,
  uQuickLaunchMenu;

type
  TfrmQuickLaunch = class(TForm)
    Label1: TLabel;
    txtName: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    txtPath: TEdit;
    cmdOpen: TSpeedButton;
    cmdAddItem: TButton;
    lstItems: TListView;
    mnulstItems: TPopupMenu;
    ilmnulstItems: TImageList;
    MoveUp1: TMenuItem;
    MoveDown1: TMenuItem;
    Delete1: TMenuItem;
    N1: TMenuItem;
    cmdEdit: TButton;
    Label4: TLabel;
    procedure cmdOpenClick(Sender: TObject);
    procedure cmdAddItemClick(Sender: TObject);
    procedure MoveUp1Click(Sender: TObject);
    procedure MoveDown1Click(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cmdEditClick(Sender: TObject);
    procedure lstItemsData(Sender: TObject; Item: TListItem);
    procedure lstItemsSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
  private
    FQuickLaunchMenu: TQuickLaunchMenu;

    procedure UpdateList;
  public
    property QuickLaunchMenu: TQuickLaunchMenu read FQuickLaunchMenu write FQuickLaunchMenu;
  end;

var
  frmQuickLaunch: TfrmQuickLaunch;

implementation

uses ufrmMain, FastStrings, FastStringFuncs, ShellAPI;

{$R *.dfm}

procedure TfrmQuickLaunch.UpdateList;
begin
  lstItems.Items.BeginUpdate;
  try
   lstItems.Items.Count := FQuickLaunchMenu.QuickLaunchList.Count;
  finally
   lstItems.Items.EndUpdate;
  end;
end;

procedure TfrmQuickLaunch.cmdOpenClick(Sender: TObject);
var strName: string;

begin
  frmSentry.OpenDialog.Filter := 'Applications (*.exe)|*.exe';
  frmSentry.OpenDialog.DefaultExt := '.exe';

  if frmSentry.OpenDialog.Execute then
   begin
    txtPath.Text := frmSentry.OpenDialog.FileName;

    strName := ExtractFileName (frmSentry.OpenDialog.FileName);
    txtName.Text := CopyStr (strName, 1, Length (strName) - 4);
   end;

  frmSentry.OpenDialog.Filter := 'Text Files (*.txt)|*.txt|Any File (*.*)|*.*';
  frmSentry.OpenDialog.DefaultExt := '.txt';
end;

procedure TfrmQuickLaunch.cmdAddItemClick(Sender: TObject);
 begin
  if (txtPath.Text = '') or (txtName.Text = '') or
     (FileExists (txtPath.Text) = False) then
   Exit;

  FQuickLaunchMenu.AddQuickLaunchItem (txtName.Text, txtPath.Text);
  UpdateList;
end;

procedure TfrmQuickLaunch.MoveUp1Click(Sender: TObject);
begin
  if lstItems.ItemIndex < 1 then
   Exit;

  FQuickLaunchMenu.QuickLaunchList.Move (lstItems.ItemIndex, lstItems.ItemIndex - 1);
  UpdateList;
  lstItems.ItemIndex := lstItems.ItemIndex - 1;
end;

procedure TfrmQuickLaunch.MoveDown1Click(Sender: TObject);
begin
  if lstItems.ItemIndex >= lstItems.Items.Count - 1 then
   Exit;

  FQuickLaunchMenu.QuickLaunchList.Move (lstItems.ItemIndex, lstItems.ItemIndex + 1);
  UpdateList;
  lstItems.ItemIndex := lstItems.ItemIndex + 1;
end;

procedure TfrmQuickLaunch.Delete1Click(Sender: TObject);
begin
  if lstItems.ItemIndex = -1 then
   Exit;

  FQuickLaunchMenu.QuickLaunchList.Delete (lstItems.ItemIndex);
  UpdateList;
end;

procedure TfrmQuickLaunch.FormShow(Sender: TObject);
begin
  lstItems.SmallImages := FQuickLaunchMenu.ImageList;
  UpdateList;
end;

procedure TfrmQuickLaunch.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FQuickLaunchMenu.Save;
end;

procedure TfrmQuickLaunch.cmdEditClick(Sender: TObject);
begin
  if lstItems.ItemIndex = -1 then
   Exit;

  with FQuickLaunchMenu.QuickLaunchList.Items[lstItems.ItemIndex] do
   begin
    Name := txtName.Text;
    Path := txtPath.Text;
   end;

  UpdateList;
end;

procedure TfrmQuickLaunch.lstItemsData(Sender: TObject; Item: TListItem);
begin
  if Item.Index >= FQuickLaunchMenu.QuickLaunchList.Count then
   Exit;

  with FQuickLaunchMenu.QuickLaunchList[Item.Index] do
   begin
    Item.Caption := '';
    Item.SubItems.Add (Name);
    Item.SubItems.Add (Path);
    Item.ImageIndex := ImageIndex;
   end;
end;

procedure TfrmQuickLaunch.lstItemsSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
  if lstItems.ItemIndex = -1 then
   Exit;

  txtName.Text := Item.SubItems.Strings[0];
  txtPath.Text := Item.SubItems.Strings[1];
end;

end.

