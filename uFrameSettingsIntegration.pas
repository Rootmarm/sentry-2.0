unit uFrameSettingsIntegration;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ExtCtrls, StdCtrls, Buttons, pngimage;

type
  TfrmSettingsIntegration = class(TFrame)
    Label2: TLabel;
    Bevel1: TBevel;
    Image1: TImage;
    Image2: TImage;
    Label1: TLabel;
    Label3: TLabel;
    chkFirefox: TCheckBox;
    chkIE: TCheckBox;
    Label4: TLabel;
    txtFirefoxPath: TEdit;
    cmdOpenFirefox: TSpeedButton;
    Label5: TLabel;
    txtFirefoxPref: TEdit;
    cmdOpenPref: TSpeedButton;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Image3: TImage;
    Label11: TLabel;
    chkOpera: TCheckBox;
    Label12: TLabel;
    txtOperaPath: TEdit;
    cmdOperaOpen: TSpeedButton;
    Label13: TLabel;
    cmdOperaHelp: TSpeedButton;
    Label14: TLabel;
    procedure cmdOpenFirefoxClick(Sender: TObject);
    procedure cmdOpenPrefClick(Sender: TObject);
    procedure cmdOperaOpenClick(Sender: TObject);
    procedure chkFirefoxClick(Sender: TObject);
    procedure chkIEClick(Sender: TObject);
    procedure chkOperaClick(Sender: TObject);
    procedure cmdOperaHelpClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure LoadVariables;
    procedure SaveVariables;
  end;

implementation

uses ufrmMain, IniFiles;

{$R *.dfm}

procedure TfrmSettingsIntegration.cmdOpenFirefoxClick(Sender: TObject);
begin
  frmSentry.OpenDialog.Filter := 'Exe File (*.exe)|*.exe';

  if frmSentry.OpenDialog.Execute then
   txtFirefoxPath.Text := frmSentry.OpenDialog.FileName;

  frmSentry.OpenDialog.Filter := 'Text Files (*.txt)|*.txt|Any File (*.*)|*.*';
end;

procedure TfrmSettingsIntegration.cmdOpenPrefClick(Sender: TObject);
begin
  frmSentry.OpenDialog.Filter := 'JS File (*.js)|*.js';
  frmSentry.OpenDialog.Options := frmSentry.OpenDialog.Options + [ofForceShowHidden];

  if frmSentry.OpenDialog.Execute then
   txtFirefoxPref.Text := frmSentry.OpenDialog.FileName;

  frmSentry.OpenDialog.Filter := 'Text Files (*.txt)|*.txt|Any File (*.*)|*.*';
  frmSentry.OpenDialog.Options := frmSentry.OpenDialog.Options - [ofForceShowHidden];
end;

procedure TfrmSettingsIntegration.cmdOperaOpenClick(Sender: TObject);
begin
  frmSentry.OpenDialog.Filter := 'Exe File (*.exe)|*.exe';

  if frmSentry.OpenDialog.Execute then
   txtOperaPath.Text := frmSentry.OpenDialog.FileName;

  frmSentry.OpenDialog.Filter := 'Text Files (*.txt)|*.txt|Any File (*.*)|*.*';
end;

procedure TfrmSettingsIntegration.chkFirefoxClick(Sender: TObject);
begin
  if chkFirefox.Checked then
   begin
    chkIE.Checked := False;
    chkOpera.Checked := False;
   end;
end;

procedure TfrmSettingsIntegration.chkIEClick(Sender: TObject);
begin
  if chkIE.Checked then
   begin
    chkFirefox.Checked := False;
    chkOpera.Checked := False;
   end;
end;

procedure TfrmSettingsIntegration.chkOperaClick(Sender: TObject);
begin
  if chkOpera.Checked then
   begin
    chkFirefox.Checked := False;
    chkIE.Checked := False;
   end;
end;

procedure TfrmSettingsIntegration.LoadVariables;
var IniFile: TIniFile;

begin
  IniFile := TIniFile.Create (strLocPath + 'Settings.ini');
  try
   with IniFile do
    begin
     chkIE.Checked := ReadBool ('Integration', 'IE', True);
     chkFirefox.Checked := ReadBool ('Integration', 'Firefox', False);
     chkOpera.Checked := ReadBool ('Integration', 'Opera', False);
     txtFirefoxPath.Text := ReadString ('Integration', 'FirefoxPath', '');
     txtFirefoxPref.Text := ReadString ('Integration', 'FirefoxPref', '');
     txtOperaPath.Text := ReadString ('Integration', 'OperaPath', '');
    end;
  finally
   IniFile.Free;
  end;
end;

procedure TfrmSettingsIntegration.SaveVariables;
var IniFile: TIniFile;
    I: integer;

begin
  if (chkIE.Checked = False) and (chkFirefox.Checked = False) and (chkOpera.Checked = False) then
   chkIE.Checked := True;

  if chkIE.Checked then
   I := bmpIE
  else if chkFirefox.Checked then
   I := bmpFIREFOX
  else
   I := bmpOPERA;

  IniFile := TIniFile.Create (strLocPath + 'Settings.ini');
  try
   with IniFile do
    begin
     WriteBool ('Integration', 'IE', chkIE.Checked);
     WriteBool ('Integration', 'Firefox', chkFirefox.Checked);
     WriteBool ('Integration', 'Opera', chkOpera.Checked);
     WriteString ('Integration', 'FirefoxPath', txtFirefoxPath.Text);
     WriteString ('Integration', 'FirefoxPref', txtFirefoxPref.Text);
     WriteString ('Integration', 'OperaPath', txtOperaPath.Text);
     WriteInteger ('Integration', 'BrowserIndex', I);
    end;
  finally
   IniFile.Free;
  end;
end;

procedure TfrmSettingsIntegration.cmdOperaHelpClick(Sender: TObject);
begin
  MessageDlg ('To use Opera with Sentry, you cannot use profiles.' + #13#10#13#10 +
              'To disable them, open C:\Program Files\Opera75\OperaDef6.ini and make sure:' + #13#10#13#10 +
              '[System]' + #13#10 +
              'Multi User = 0' + #13#10#13#10 +
              'If you do not do this, Proxy Integration with Opera will not work.', mtInformation, [mbOK], 0);

end;

end.
