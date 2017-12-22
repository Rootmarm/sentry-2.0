unit uFrameHistoryOptions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TfrmHistoryOptions = class(TFrame)
    Label1: TLabel;
    Bevel1: TBevel;
    Label2: TLabel;
    cboSaveFilter: TComboBox;
    cmdSaveHelp: TSpeedButton;
    Label98: TLabel;
    Bevel2: TBevel;
    chkSameProxy: TCheckBox;
    Label97: TLabel;
    chkAppendHistory: TCheckBox;
    Label36: TLabel;
    txtTimeout: TEdit;
    Label39: TLabel;
    chkAfterFP: TCheckBox;
    chkCheckHits: TCheckBox;
    rgRequestMethod: TRadioGroup;
    Label4: TLabel;
    chkFloatDialog: TCheckBox;
    chkSavePosition: TCheckBox;
    Bevel3: TBevel;
    procedure cmdSaveHelpClick(Sender: TObject);
    procedure LoadVariables;
    procedure SaveVariables;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses ufrmMain, IniFiles;

{$R *.dfm}

procedure TfrmHistoryOptions.cmdSaveHelpClick(Sender: TObject);
begin
  MessageBox (Application.Handle, 'Variables:' + #13#10#13#10 +
                                  'Protocol (including "://") = <PROTO>' + #13#10 +
                                  'Member''s URL = <SITE>' + #13#10 +
                                  'Base URL = <BASE>' + #13#10 +
                                  'Username = <U>' + #13#10 +
                                  'Password = <P>' + #13#10 +
                                  'Proxy = <PROXY>' + #13#10 +
                                  'Status = <STATUS>' + #13#10 +
                                  'Wordlist = <WORDLIST>' + #13#10#13#10 +
                                  'Raw text can be added anywhere.', 'Sentry', MB_ICONINFORMATION);
end;

procedure TfrmHistoryOptions.LoadVariables;
var IniFile: TIniFile;

begin
  if FileExists (strLocPath + 'Filters.ini') then
   cboSaveFilter.Items.LoadFromFile (strLocPath + 'Filters.ini');

  IniFile := TIniFile.Create (strLocPath + 'Settings.ini');
  try
   with IniFile do
    begin
     cboSaveFilter.Text := ReadString ('History', 'SaveFilter', '<PROTO><U>:<P>@<SITE>');
     txtTimeout.Text := ReadString ('History', 'Timeout', '10');
     chkAfterFP.Checked := ReadBool ('History', 'AfterFP', True);
     chkCheckHits.Checked := ReadBool ('History', 'CheckHits', False);
     chkSameProxy.Checked := ReadBool ('History', 'SameProxy', False);
     chkAppendHistory.Checked := ReadBool ('History', 'Append', False);
     rgRequestMethod.ItemIndex := ReadInteger ('History', 'RequestMethod', 1);
     chkFloatDialog.Checked := ReadBool ('History', 'FloatDialog', True);
     chkSavePosition.Checked := ReadBool ('History', 'SavePosition', True);
    end;
  finally
   IniFile.Free;
  end;
end;

procedure TfrmHistoryOptions.SaveVariables;
var IniFile: TIniFile;

begin
  if cboSaveFilter.Items.IndexOf (cboSaveFilter.Text) = -1 then
   cboSaveFilter.Items.Add (cboSaveFilter.Text);
  cboSaveFilter.Items.SaveToFile (strLocPath + 'Filters.ini');

  IniFile := TIniFile.Create (strLocPath + 'Settings.ini');
  try
   with IniFile do
    begin
     WriteString ('History', 'SaveFilter', cboSaveFilter.Text);
     WriteString ('History', 'Timeout', txtTimeout.Text);
     WriteBool ('History', 'AfterFP', chkAfterFP.Checked);
     WriteBool ('History', 'CheckHits', chkCheckHits.Checked);
     WriteBool ('History', 'SameProxy', chkSameProxy.Checked);
     WriteBool ('History', 'Append', chkAppendHistory.Checked);
     WriteInteger ('History', 'RequestMethod', rgRequestMethod.ItemIndex);
     WriteBool ('History', 'FloatDialog', chkFloatDialog.Checked);
     WriteBool ('History', 'SavePosition', chkSavePosition.Checked);
    end;
  finally
   IniFile.Free;
  end;
end;

end.
