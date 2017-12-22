unit uFrameSettingsKeywords;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, ExtCtrls, Menus;

type
  TfrmSettingsKeywords = class(TFrame)
    Label2: TLabel;
    Bevel1: TBevel;
    chkHeaderFailure: TCheckBox;
    lstHeaderFailure: TListBox;
    chkHeaderSuccess: TCheckBox;
    lstHeaderSuccess: TListBox;
    Label1: TLabel;
    Bevel2: TBevel;
    chkSourceFailure: TCheckBox;
    lstSourceFailure: TListBox;
    lstSourceSuccess: TListBox;
    chkSourceSuccess: TCheckBox;
    Label3: TLabel;
    chkGlobalFailure: TCheckBox;
    lstGlobalFailure: TListBox;
    Bevel3: TBevel;
    Label4: TLabel;
    lstHeaderRetry: TListBox;
    chkHeaderRetry: TCheckBox;
    lstSourceBan: TListBox;
    chkSourceBan: TCheckBox;
    mnuKeywords: TPopupMenu;
    Add1: TMenuItem;
    Edit1: TMenuItem;
    DeleteSelected1: TMenuItem;
    N1: TMenuItem;
    OpenListofKeyPhrases1: TMenuItem;
    SaveListofKeyPhrases1: TMenuItem;
    procedure Add1Click(Sender: TObject);
    procedure Edit1Click(Sender: TObject);
    procedure DeleteSelected1Click(Sender: TObject);
    procedure OpenListofKeyPhrases1Click(Sender: TObject);
    procedure SaveListofKeyPhrases1Click(Sender: TObject);
    procedure lstHeaderFailureKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    procedure LoadKeywordsFromFile(const strFileName: string; var ListBox: TListBox);
  public
    procedure LoadVariables;
    procedure SaveVariables;
  end;

implementation

{$R *.dfm}

uses IniFiles, ufrmMain, uFunctions;

procedure TfrmSettingsKeywords.LoadKeywordsFromFile(const strFileName: string; var ListBox: TListBox);
begin
  if FileExists (strFileName) then
   begin
    ListBox.Items.LoadFromFile (strFileName);
    ListBoxHorScrollBar (ListBox, True);
   end;
end;

procedure TfrmSettingsKeywords.LoadVariables;
var IniFile: TIniFile;

begin
  LoadKeywordsFromFile (strLocPath + 'HeaderFail.ini', lstHeaderFailure);
  LoadKeywordsFromFile (strLocPath + 'HeaderSuccess.ini', lstHeaderSuccess);
  LoadKeywordsFromFile (strLocPath + 'HeaderRetry.ini', lstHeaderRetry);
  LoadKeywordsFromFile (strLocPath + 'SourceFail.ini', lstSourceFailure);
  LoadKeywordsFromFile (strLocPath + 'SourceSuccess.ini', lstSourceSuccess);
  LoadKeywordsFromFile (strLocPath + 'SourceBan.ini', lstSourceBan);
  LoadKeywordsFromFile (strLocPath + 'GlobalFail.ini', lstGlobalFailure);

  IniFile := TIniFile.Create (strLocPath + 'Settings.ini');
  try
   with IniFile do
    begin
     chkHeaderFailure.Checked := ReadBool ('Keywords', 'EnableHeaderFail', False);
     chkHeaderSuccess.Checked := ReadBool ('Keywords', 'EnableHeaderSuccess', False);
     chkHeaderRetry.Checked := ReadBool ('Keywords', 'EnableHeaderRetry', False);
     chkSourceFailure.Checked := ReadBool ('Keywords', 'EnableSourceFail', False);
     chkSourceSuccess.Checked := ReadBool ('Keywords', 'EnableSourceSuccess', False);
     chkSourceBan.Checked := ReadBool ('Keywords', 'EnableSourceBan', False);
     chkGlobalFailure.Checked := ReadBool ('Keywords', 'GlobalFail', False);
    end;
  finally
   IniFile.Free;
  end;
end;

procedure TfrmSettingsKeywords.SaveVariables;
var IniFile: TIniFile;

begin
  lstHeaderFailure.Items.SaveToFile (strLocPath + 'HeaderFail.ini');
  lstHeaderSuccess.Items.SaveToFile (strLocPath + 'HeaderSuccess.ini');
  lstHeaderRetry.Items.SaveToFile (strLocPath + 'HeaderRetry.ini');
  lstSourceFailure.Items.SaveToFile (strLocPath + 'SourceFail.ini');
  lstSourceSuccess.Items.SaveToFile (strLocPath + 'SourceSuccess.ini');
  lstSourceBan.Items.SaveToFile (strLocPath + 'SourceBan.ini');
  lstGlobalFailure.Items.SaveToFile (strLocPath + 'GlobalFail.ini');

  IniFile := TIniFile.Create (strLocPath + 'Settings.ini');
  try
   with IniFile do
    begin
     WriteBool ('Keywords', 'EnableHeaderFail', chkHeaderFailure.Checked);
     WriteBool ('Keywords', 'EnableHeaderSuccess', chkHeaderSuccess.Checked);
     WriteBool ('Keywords', 'EnableHeaderRetry', chkHeaderRetry.Checked);
     WriteBool ('Keywords', 'EnableSourceFail', chkSourceFailure.Checked);
     WriteBool ('Keywords', 'EnableSourceSuccess', chkSourceSuccess.Checked);
     WriteBool ('Keywords', 'EnableSourceBan', chkSourceBan.Checked);
     WriteBool ('Keywords', 'GlobalFail', chkGlobalFailure.Checked);
    end;
  finally
   IniFile.Free;
  end;
end;

procedure TfrmSettingsKeywords.Add1Click(Sender: TObject);
var strTmp: string;
    ListBox: TListBox;

begin
  strTmp := InputBox ('Add', 'Add a Key Phrase', '');
  if strTmp = '' then
   Exit;
  ListBox := (((Sender as TMenuItem).GetParentComponent as TPopupMenu).PopupComponent as TListBox);
  ListBox.Items.Add (strTmp);
  ListBoxHorScrollBar (ListBox);
end;

procedure TfrmSettingsKeywords.Edit1Click(Sender: TObject);
var strTmp : string;
    ListBox: TListBox;
    I: integer;

begin
  ListBox := (((Sender as TMenuItem).GetParentComponent as TPopupMenu).PopupComponent as TListBox);

  I := ListBox.ItemIndex;
  if I = -1 then
    Exit;

  try
   strTmp := InputBox ('Edit', 'Edit a Key Phrase', ListBox.Items.Strings[I]);
   ListBox.Items.Strings[I] := strTmp;
   ListBoxHorScrollBar (ListBox);
  except
    // For some reason, I is returning 0 instead of -1
    // Block Exception
  end;
end;

procedure TfrmSettingsKeywords.DeleteSelected1Click(Sender: TObject);
var ListBox: TListBox;

begin
  ListBox := (((Sender as TMenuItem).GetParentComponent as TPopupMenu).PopupComponent as TListBox);

  if ListBox.ItemIndex = -1 then
   Exit;

  ListBox.DeleteSelected;
end;

procedure TfrmSettingsKeywords.OpenListofKeyPhrases1Click(Sender: TObject);
var ListBox: TListBox;

begin
  ListBox := (((Sender as TMenuItem).GetParentComponent as TPopupMenu).PopupComponent as TListBox);

  if frmSentry.OpenDialog.Execute then
   begin
    ListBox.Items.LoadFromFile (frmSentry.OpenDialog.FileName);
    ListBoxHorScrollBar (ListBox, True);
   end;
end;

procedure TfrmSettingsKeywords.SaveListofKeyPhrases1Click(Sender: TObject);
var ListBox: TListBox;

begin
  ListBox := (((Sender as TMenuItem).GetParentComponent as TPopupMenu).PopupComponent as TListBox);

  if frmSentry.SaveDialog.Execute then
   ListBox.Items.SaveToFile (frmSentry.SaveDialog.FileName);
end;

procedure TfrmSettingsKeywords.lstHeaderFailureKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = 46 then
   (Sender as TListBox).DeleteSelected;
end;

end.
