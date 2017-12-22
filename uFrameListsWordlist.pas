unit uFrameListsWordlist;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, Buttons, ExtCtrls, StdCtrls, ComCtrls, uWordlist;

type
  TfrmListsWordlist = class(TFrame)
    GroupBox3: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label5: TLabel;
    chkLengthFilter: TCheckBox;
    txtUsernameStart: TEdit;
    txtUsernameEnd: TEdit;
    txtPasswordEnd: TEdit;
    txtPasswordStart: TEdit;
    cmdLoadWordlist: TSpeedButton;
    cmdWordlistClear: TSpeedButton;
    GroupBox1: TGroupBox;
    lstCCombos: TListView;
    procedure lstCCombosData(Sender: TObject; Item: TListItem);
    procedure cmdLoadWordlistClick(Sender: TObject);
    procedure cmdWordlistClearClick(Sender: TObject);
  private
    lstWordlist: TWordlist;

    procedure UpdateWordlist;
  public
    procedure LoadVariables;
    procedure SaveVariables;
  end;

implementation

uses ufrmMain, IniFiles, uFunctions;

{$R *.dfm}

procedure TfrmListsWordlist.UpdateWordlist;
begin
  lstCCombos.Items.BeginUpdate;
  try
   lstCCombos.Items.Count := lstWordlist.Count;
  finally
   lstCCombos.Items.EndUpdate;
  end;

  frmSentry.StatusBar.Panels[1].Text := 'Wordlist: ' + ExtractFileName (lstWordlist.Wordlist);
end;

procedure TfrmListsWordlist.lstCCombosData(Sender: TObject; Item: TListItem);
begin
  if Item.Index >= lstWordlist.Count then
   Exit;

  Item.Caption := lstWordlist.Items[Item.Index].WriteToString;
end;

procedure TfrmListsWordlist.cmdLoadWordlistClick(Sender: TObject);
begin
  if frmSentry.OpenDialog.Execute then
   begin
    if Assigned (lstWordlist) then
     lstWordlist.LoadFromFile (frmSentry.OpenDialog.FileName)
    else
     lstWordlist := TWordlist.Create (frmSentry.OpenDialog.FileName);

    // Reset Wordlist Position
    IniFileWriteInteger (strLocPath + 'Settings.ini', 'Lists', 'StartSearch', 1);

    UpdateWordlist;
   end;
end;

procedure TfrmListsWordlist.cmdWordlistClearClick(Sender: TObject);
begin
  if Assigned (lstWordlist) then
   begin
    lstWordlist.Clear;
    UpdateWordlist;
    FreeAndNil (lstWordlist);
   end;
end;

procedure TfrmListsWordlist.LoadVariables;
var IniFile: TIniFile;
    strWordlist: string;

begin
  IniFile := TIniFile.Create (strLocPath + 'Settings.ini');
  try
   with IniFile do
    begin
     txtUsernameStart.Text := ReadString ('Lists', 'UsernameStart', '6');
     txtUsernameEnd.Text := ReadString ('Lists', 'UsernameEnd', '8');
     txtPasswordStart.Text := ReadString ('Lists', 'PasswordStart', '6');
     txtPasswordEnd.Text := ReadString ('Lists', 'PasswordEnd', '8');
     chkLengthFilter.Checked := ReadBool ('Lists', 'LengthFilter', False);
     strWordlist := ReadString ('Lists', 'Wordlist', '');
     if (strWordlist <> '') and (FileExists (strWordlist)) then
      begin
       lstWordlist := TWordlist.Create (strWordlist);
       UpdateWordlist;
      end;
    end;
  finally
   IniFile.Free;
  end;
end;

procedure TfrmListsWordlist.SaveVariables;
var IniFile: TIniFile;

begin
  lstCCombos.OnData := nil;

  IniFile := TIniFile.Create (strLocPath + 'Settings.ini');
  try
   with IniFile do
    begin
     WriteString ('Lists', 'UsernameStart', txtUsernameStart.Text);
     WriteString ('Lists', 'UsernameEnd', txtUsernameEnd.Text);
     WriteString ('Lists', 'PasswordStart', txtPasswordStart.Text);
     WriteString ('Lists', 'PasswordEnd', txtPasswordEnd.Text);
     WriteBool ('Lists', 'LengthFilter', chkLengthFilter.Checked);
     if Assigned (lstWordlist) then
      begin
       WriteString ('Lists', 'Wordlist', lstWordlist.Wordlist);
       WriteInteger ('Lists', 'WordlistLen', lstWordlist.Count);
       FreeAndNil (lstWordlist);
      end
     else
      begin
       WriteString ('Lists', 'Wordlist', '');
       WriteInteger ('Lists', 'WordlistLen', 1);
      end;
    end;
  finally
   IniFile.Free;
  end;
end;

end.
