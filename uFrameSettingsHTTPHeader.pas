unit uFrameSettingsHTTPHeader;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Menus, ImgList, Buttons, ufrmPOSTWizard,
  uPngSpeedButton;

type
  TfrmSettingsHTTPHeader = class(TFrame)
    GroupBox1: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    memHeader: TMemo;
    chkBasicAuth: TCheckBox;
    cmdBuildHeader: TButton;
    txtPOSTData: TEdit;
    GroupBox2: TGroupBox;
    lstUserAgents: TListBox;
    rgRequestMethod: TRadioGroup;
    rgReferer: TRadioGroup;
    mnuUserAgents: TPopupMenu;
    AddUserAgent1: TMenuItem;
    RemoveUserAgent1: TMenuItem;
    EditUserAgent1: TMenuItem;
    cmdWizard: TPngSpeedButton;
    chkAutoBuild: TCheckBox;
    procedure cmdBuildHeaderClick(Sender: TObject);
    procedure AddUserAgent1Click(Sender: TObject);
    procedure EditUserAgent1Click(Sender: TObject);
    procedure RemoveUserAgent1Click(Sender: TObject);
    procedure rgRequestMethodClick(Sender: TObject);
    procedure cmdWizardClick(Sender: TObject);
    procedure chkBasicAuthClick(Sender: TObject);
  private
    frmPOSTWizard: TfrmPOSTWizard;
  public
    procedure LoadVariables;
    procedure SaveVariables;
  end;

implementation

uses ufrmMain, HttpProt, FastStrings, FastStringFuncs, IniFiles, IcsUrl;

{$R *.dfm}

procedure TfrmSettingsHTTPHeader.cmdBuildHeaderClick(Sender: TObject);
var FProto, FUser, FPass, FHost, FPort, FPath, FMethod, FSite: string;

begin
  FSite := frmSentry.cboSite.Text;

  if FSite = '' then
   Exit;

  memHeader.Lines.Clear;

  ParseURL (FSite, FProto, FUser, FPass, FHost, FPort, FPath);
  FMethod := rgRequestMethod.Items.Strings[rgRequestMethod.ItemIndex];

  if rgRequestMethod.ItemIndex = rgPOST then
   memHeader.Lines.Add (FMethod + ' <FORM ACTION> HTTP/1.1')
  else
   memHeader.Lines.Add (FMethod + ' ' + FProto + '://' + FHost + FPath + ' HTTP/1.0');
  memHeader.Lines.Add ('Accept: */*');
  case rgReferer.ItemIndex of
   1: memHeader.Lines.Add ('Referer: ' + FProto + '://' + FHost);
   2: memHeader.Lines.Add ('Referer: ' + FSite);
  end;
  memHeader.Lines.Add ('User-Agent: <USER AGENT>');
  memHeader.Lines.Add ('Host: ' + FHost);
  memHeader.Lines.Add ('Pragma: no-cache');
  if chkBasicAuth.Checked then
   memHeader.Lines.Add ('Authorization: Basic <COMBO>');
  if FMethod = 'POST' then
   begin
    memHeader.Lines.Add ('Content-Type: application/x-www-form-urlencoded');
    memHeader.Lines.Add ('Connection: keep-alive');
    memHeader.Lines.Add ('Content-Length: <CONTENT LENGTH>');
   end;
end;

procedure TfrmSettingsHTTPHeader.AddUserAgent1Click(Sender: TObject);
var strTmp: string;

begin
  strTmp := InputBox ('Add User Agent', 'Add a User Agent', '');
  if Trim (strTmp) <> '' then
   lstUserAgents.Items.Add (strTmp);
end;

procedure TfrmSettingsHTTPHeader.EditUserAgent1Click(Sender: TObject);
var strTmp: string;
    I: integer;

begin
  I := lstUserAgents.ItemIndex;
  if I = -1 then
   Exit;

  strTmp := InputBox ('Add User Agent', 'Add a User Agent', lstUserAgents.Items.Strings[I]);
  if Trim (strTmp) <> '' then
   lstUserAgents.Items.Strings[I] := strTmp;
end;

procedure TfrmSettingsHTTPHeader.RemoveUserAgent1Click(Sender: TObject);
var I: integer;

begin
  for I := lstUserAgents.Count - 1 downto 0 do
   begin
    if lstUserAgents.Selected[I] then
     lstUserAgents.Items.Delete (I);
   end;

  lstUserAgents.ClearSelection;
end;

procedure TfrmSettingsHTTPHeader.rgRequestMethodClick(Sender: TObject);
var blnTmp: boolean;

begin
  blnTmp := (rgRequestMethod.ItemIndex = 2);
  Label5.Visible := blnTmp;
  txtPOSTData.Visible := blnTmp;
  cmdWizard.Visible := blnTmp;
  chkBasicAuth.Checked := not blnTmp;
end;

procedure TfrmSettingsHTTPHeader.LoadVariables;
var IniFile: TIniFile;

begin
  if FileExists (strLocPath + 'UserAgents.ini') then
   lstUserAgents.Items.LoadFromFile (strLocPath + 'UserAgents.ini');

  IniFile := TIniFile.Create (strLocPath + 'Settings.ini');
  try
   with IniFile do
    begin
     rgRequestMethod.ItemIndex := ReadInteger ('Settings', 'RequestMethod', 1);
     rgReferer.ItemIndex := ReadInteger ('Settings', 'Referer', 0);
     memHeader.Text := FastReplace (ReadString ('Settings', 'HTTPHeader', ''), '|', #13#10);
     txtPOSTData.Text := ReadString ('Settings', 'POSTData', '');
     chkBasicAuth.Checked := ReadBool ('Settings', 'BasicAuth', True);
     chkAutoBuild.Checked := ReadBool ('Settings', 'AutoBuild', True);
    end;
  finally
   IniFile.Free;
  end;
end;

procedure TfrmSettingsHTTPHeader.SaveVariables;
var IniFile: TIniFile;

begin
  if (chkAutoBuild.Checked = False) and (rgRequestMethod.ItemIndex <> rgPOST) and ((frmSentry.cboSite.Text = '') or (FastPosNoCase (memHeader.Text, frmSentry.cboSite.Text, Length (memHeader.Text), Length (frmSentry.cboSite.Text), 1) = 0)) then
   begin
    if MessageDlg ('Could not detect the current Site in your HTTP Header.  Would you like to rebuild it?', mtWarning, [mbYes, mbNo], 0) = mrYes then
     cmdBuildHeaderClick (nil);
   end;

  if lstUserAgents.Items.Count = 0 then
   begin
    if MessageDlg ('Your User-Agent List is empty.' + #13#10#13#10 +
                   'It is strongly recommended that you use at least one User-Agent.' + #13#10#13#10 +
                   'Would you like to add the following User-Agents to your list?' + #13#10#13#10 +
                   'Mozilla/5.0 (Windows; U; Windows NT 5.1; de-DE; rv:1.7.5) Gecko/20041122 Firefox/1.0' + #13#10 +
                   'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1) Opera 7.54 [en]' + #13#10 +
                   'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)' + #13#10 +
                   'Mozilla/5.0 (compatible; Konqueror/3.3; Linux) (KHTML, like Gecko)' + #13#10 +
                   'Avant Browser (http://www.avantbrowser.com)' + #13#10 +
                   'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; MyIE2; FDM; .NET CLR 1.1.4322)', mtWarning, [mbYes, mbNo], 0) = mrYes then
      begin
       lstUserAgents.Items.Add ('Mozilla/5.0 (Windows; U; Windows NT 5.1; de-DE; rv:1.7.5) Gecko/20041122 Firefox/1.0');
       lstUserAgents.Items.Add ('Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1) Opera 7.54 [en]');
       lstUserAgents.Items.Add ('Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)');
       lstUserAgents.Items.Add ('Mozilla/5.0 (compatible; Konqueror/3.3; Linux) (KHTML, like Gecko)');
       lstUserAgents.Items.Add ('Avant Browser (http://www.avantbrowser.com)');
       lstUserAgents.Items.Add ('Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; MyIE2; FDM; .NET CLR 1.1.4322)');
      end;
   end;

  lstUserAgents.Items.SaveToFile (strLocPath + 'UserAgents.ini');

  IniFile := TIniFile.Create (strLocPath + 'Settings.ini');
  try
   with IniFile do
    begin
     WriteInteger ('Settings', 'RequestMethod', rgRequestMethod.ItemIndex);
     WriteInteger ('Settings', 'Referer', rgReferer.ItemIndex);
     WriteString ('Settings', 'HTTPHeader', FastReplace (memHeader.Text, #13#10, '|'));
     WriteString ('Settings', 'POSTData', txtPOSTData.Text);
     WriteBool ('Settings', 'BasicAuth', chkBasicAuth.Checked);
     WriteBool ('Settings', 'AutoBuild', chkAutoBuild.Checked);
    end;
  finally
   IniFile.Free;
  end;
end;

procedure TfrmSettingsHTTPHeader.cmdWizardClick(Sender: TObject);
begin
  if frmSentry.cboSite.Text = '' then
   begin
    MessageDlg ('You need to enter a site to scan for POST Data.', mtError, [mbOK], 0);
    Exit;
   end;

  frmPOSTWizard := TfrmPOSTWizard.Create (nil);
  try
   frmPOSTWizard.ShowModal;
  finally
   frmPOSTWizard.Free;
  end;
end;

procedure TfrmSettingsHTTPHeader.chkBasicAuthClick(Sender: TObject);
begin
  if rgRequestMethod.ItemIndex = rgPOST then
   chkBasicAuth.Checked := False;
end;

end.
