unit ufrmToolsProxyAnalyzerOptions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, uIPBot, HttpProt, uAnalyzerListView;

type
  TfrmToolsProxyAnalyzerOptions = class(TForm)
    GroupBox1: TGroupBox;
    cmdOpenSpecSite: TSpeedButton;
    cmdOpenPJ: TSpeedButton;
    Bevel1: TBevel;
    Label1: TLabel;
    Bevel2: TBevel;
    chkInternal: TCheckBox;
    chkSpecific: TCheckBox;
    optSpecificHead: TRadioButton;
    optSpecificGet: TRadioButton;
    chkExternal: TCheckBox;
    txtSpecificResponse: TEdit;
    chkSpecificKeyPhrase: TCheckBox;
    txtSpecificKeyPhrase: TEdit;
    chkInternalAuth: TCheckBox;
    cboProxyJudge: TComboBox;
    cboSpecificSite: TComboBox;
    Panel1: TPanel;
    chkHTTPS: TCheckBox;
    txtHTTPS: TEdit;
    chkHostToIP: TCheckBox;
    cmdExternalIP: TSpeedButton;
    lblIP: TPanel;
    Label2: TLabel;
    chkFloatDialog: TCheckBox;
    chkSavePosition: TCheckBox;
    chkGetExternal: TCheckBox;
    Label3: TLabel;
    txtTimeout: TEdit;
    chkNoLevels: TCheckBox;
    Label4: TLabel;
    Bevel3: TBevel;
    Label5: TLabel;
    Label6: TLabel;
    Bevel5: TBevel;
    Image1: TImage;
    Label7: TLabel;
    Label8: TLabel;
    txtCharon: TEdit;
    cmdOpen: TSpeedButton;
    Label9: TLabel;
    Bevel4: TBevel;
    cmdCharon: TButton;
    Label10: TLabel;
    cmdOK: TButton;
    chkAutoDelete: TCheckBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cmdOpenSpecSiteClick(Sender: TObject);
    procedure cmdOpenPJClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lblIPDblClick(Sender: TObject);
    procedure cmdExternalIPClick(Sender: TObject);
    procedure AHttpCliRequestDone(Sender: TObject; RqType: THttpRequest; Error: Word);
    procedure chkInternalClick(Sender: TObject);
    procedure chkExternalClick(Sender: TObject);
    procedure chkSpecificClick(Sender: TObject);
    procedure chkSpecificKeyPhraseClick(Sender: TObject);
    procedure chkNoLevelsClick(Sender: TObject);
    procedure chkInternalAuthClick(Sender: TObject);
    procedure cmdOpenClick(Sender: TObject);
    procedure cmdCharonClick(Sender: TObject);
    procedure MutexThreadTerminate(Sender: TObject);
  private
    FActive: boolean;
    FProxyList: TAnalyzerList;

    procedure AddItemToComboBox(const ComboBox: TComboBox);
  public
    property ProxyList: TAnalyzerList read FProxyList write FProxyList;
  end;

var
  frmToolsProxyAnalyzerOptions: TfrmToolsProxyAnalyzerOptions;

implementation

uses ufrmMain, uFunctions, uFrameToolsProxyAnalyzer, uThreadMutex, IniFiles,
     ShellAPI;

{$R *.dfm}


procedure TfrmToolsProxyAnalyzerOptions.AddItemToComboBox(const ComboBox: TComboBox);
var strTmp: string;

begin
  strTmp := Trim (cboProxyJudge.Text);
  if (strTmp <> '') and (cboProxyJudge.Items.IndexOf (strTmp) = -1) then
   cboProxyJudge.Items.Add (strTmp);
end;

procedure TfrmToolsProxyAnalyzerOptions.FormClose(Sender: TObject; var Action: TCloseAction);
var IniFile: TIniFile;

begin
  if FActive then
   begin
    Action := caNone;
    Exit;
   end;

  frmSentry.IP := lblIP.Caption;

  AddItemToComboBox (cboProxyJudge);
  AddItemToComboBox (cboSpecificSite);

  cboProxyJudge.Items.SaveToFile (strLocPath + 'ProxyJudges.ini');
  cboSpecificSite.Items.SaveToFile (strLocPath + 'SSites.ini');

  if Trim (txtSpecificResponse.Text) = '' then
   txtSpecificResponse.Text := '401';

  IniFile := TIniFile.Create (strLocPath + 'Settings.ini');
  try
   with IniFile do
    begin
     WriteBool ('Analyzer', 'InternalJudge', chkInternal.Checked);
     WriteBool ('Analyzer', 'Auth', chkInternalAuth.Checked);

     WriteString ('Analyzer', 'ProxyJudge', cboProxyJudge.Text);
     WriteString ('Analyzer', 'SpecificURL', cboSpecificSite.Text);
     WriteBool ('Analyzer', 'ExternalJudge', chkExternal.Checked);
     WriteBool ('Analyzer', 'SpecificSite', chkSpecific.Checked);
     WriteBool ('Analyzer', 'SpecificHead', optSpecificHead.Checked);
     WriteBool ('Analyzer', 'SpecificGet', optSpecificGet.Checked);
     WriteString ('Analyzer', 'SpecificResponse', txtSpecificResponse.Text);
     WriteBool ('Analyzer', 'SpecificPhrase', chkSpecificKeyPhrase.Checked);
     WriteString ('Analyzer', 'SpecificKey', txtSpecificKeyPhrase.Text);
     WriteString ('Analyzer', 'Timeout', txtTimeout.Text);
     WriteBool ('Analyzer', 'NoLevels', chkNoLevels.Checked);
     WriteBool ('Analyzer', 'AutoDelete', chkAutoDelete.Checked);

     WriteBool ('Analyzer', 'HTTPS', chkHTTPS.Checked);
     WriteString ('Analyzer', 'HTTPSSite', txtHTTPS.Text);
     WriteBool ('Analyzer', 'HostToIP', chkHostToIP.Checked);
     WriteBool ('Analyzer', 'FloatDialog', chkFloatDialog.Checked);
     WriteBool ('Analyzer', 'SavePosition', chkSavePosition.Checked);

     WriteString ('Analyzer', 'Charon', txtCharon.Text);

     WriteBool ('Global', 'GetExternal', chkGetExternal.Checked);
    end;
  finally
   IniFile.Free;
  end;
end;

procedure TfrmToolsProxyAnalyzerOptions.cmdOpenSpecSiteClick(Sender: TObject);
var I: integer;

begin
  if cboSpecificSite.Text <> '' then
   begin
    I := IniFileReadInteger (strLocPath + 'Settings.ini', 'Integration', 'BrowserIndex', bmpIE);
    LaunchSite (cboSpecificSite.Text, I);
   end;
end;

procedure TfrmToolsProxyAnalyzerOptions.cmdOpenPJClick(Sender: TObject);
var I: integer;

begin
  if cboProxyJudge.Text <> '' then
   begin
    I := IniFileReadInteger (strLocPath + 'Settings.ini', 'Integration', 'BrowserIndex', bmpIE);
    LaunchSite (cboProxyJudge.Text, I);
   end;
end;

procedure TfrmToolsProxyAnalyzerOptions.FormShow(Sender: TObject);
var IniFile: TIniFile;

begin
  lblIP.Caption := frmSentry.IP;

  if FileExists (strLocPath + 'ProxyJudges.ini') then
   cboProxyJudge.Items.LoadFromFile (strLocPath + 'ProxyJudges.ini');

  if FileExists (strLocPath + 'SSites.ini') then
   cboSpecificSite.Items.LoadFromFile (strLocPath + 'SSites.ini');

  if FileExists (strLocPath + 'Settings.ini') then
   begin
    IniFile := TIniFile.Create (strLocPath + 'Settings.ini');
    try
     with IniFile do
      begin
       chkInternal.Checked := ReadBool ('Analyzer', 'InternalJudge', False);
       chkInternalAuth.Checked := ReadBool ('Analyzer', 'Auth', False);

       cboProxyJudge.Text := ReadString ('Analyzer', 'ProxyJudge', '');
       cboSpecificSite.Text := ReadString ('Analyzer', 'SpecificURL', '');
       chkExternal.Checked := ReadBool ('Analyzer', 'ExternalJudge', False);
       chkSpecific.Checked := ReadBool ('Analyzer', 'SpecificSite', False);
       optSpecificHead.Checked := ReadBool ('Analyzer', 'SpecificHead', True);
       optSpecificGet.Checked := ReadBool ('Analyzer', 'SpecificGet', False);
       txtSpecificResponse.Text := ReadString ('Analyzer', 'SpecificResponse', '401');
       chkSpecificKeyPhrase.Checked := ReadBool ('Analyzer', 'SpecificPhrase', False);
       txtSpecificKeyPhrase.Text := ReadString ('Analyzer', 'SpecificKey', '');
       txtTimeout.Text := ReadString ('Analyzer', 'Timeout', '15');
       chkNoLevels.Checked := ReadBool ('Analyzer', 'NoLevels', False);
       chkAutoDelete.Checked := ReadBool ('Analyzer', 'AutoDelete', False);

       chkHTTPS.Checked := ReadBool ('Analyzer', 'HTTPS', False);
       txtHTTPS.Text := ReadString ('Analyzer', 'HTTPSSite', 'http://www.google.com:80');
       chkHostToIP.Checked := ReadBool ('Analyzer', 'HostToIP', True);
       chkFloatDialog.Checked := ReadBool ('Analyzer', 'FloatDialog', True);
       chkSavePosition.Checked := ReadBool ('Analyzer', 'SavePosition', True);

       txtCharon.Text := ReadString ('Analyzer', 'Charon', '');

       chkGetExternal.Checked := ReadBool ('Global', 'GetExternal', False);
      end;
    finally
     IniFile.Free;
    end;
   end;
end;

procedure TfrmToolsProxyAnalyzerOptions.lblIPDblClick(Sender: TObject);
var strTmp : string;

begin
  strTmp := InputBox ('IP', 'Enter Your IP Address', lblIP.Caption);
  if strTmp <> '' then
   lblIP.Caption := strTmp;
end;

procedure TfrmToolsProxyAnalyzerOptions.cmdExternalIPClick(Sender: TObject);
var AHttpCli: TIPBot;

begin
  cmdExternalIP.Enabled := False;
  AHttpCli := TIPBot.Create (nil);

  AHttpCli.OnRequestDone := AHttpCliRequestDone;
  AHttpCli.GetASync;
end;

procedure TfrmToolsProxyAnalyzerOptions.AHttpCliRequestDone(Sender: TObject; RqType: THttpRequest; Error: Word);
var AHttpCli: TIPBot;

begin
  AHttpCli := Sender as TIPBot;

  if AHttpCli.StatusCode = 200 then
   lblIP.Caption := AHttpCli.IP
  else
   MessageDlg (AHttpCli.Status, mtInformation, [mbOK], 0);

  AHttpCli.Free;
  cmdExternalIP.Enabled := True;
end;

procedure TfrmToolsProxyAnalyzerOptions.chkInternalClick(Sender: TObject);
begin
  if chkInternal.Checked then
   begin
    chkExternal.Checked := False;
    chkNoLevels.Checked := True;
    chkSpecificKeyPhrase.Checked := False;
    txtHTTPS.Text := lblIP.Caption + ':80';
   end;
end;

procedure TfrmToolsProxyAnalyzerOptions.chkExternalClick(Sender: TObject);
begin
  if chkExternal.Checked then
   begin
    chkInternal.Checked := False;
    chkSpecificKeyPhrase.Checked := False;
    chkInternalAuth.Checked := False;
   end;
end;

procedure TfrmToolsProxyAnalyzerOptions.chkSpecificClick(Sender: TObject);
begin
  if chkInternal.Checked then
   chkSpecific.Checked := False;

  if chkSpecific.Checked then
   begin
    chkSpecificKeyPhrase.Checked := False;
    chkInternalAuth.Checked := False;
   end;
end;

procedure TfrmToolsProxyAnalyzerOptions.chkSpecificKeyPhraseClick(Sender: TObject);
begin
  if chkInternal.Checked then
   chkSpecificKeyPhrase.Checked := False;

  if chkSpecificKeyPhrase.Checked then
   begin
    chkSpecific.Checked := False;
    chkExternal.Checked := False;
   end;
end;

procedure TfrmToolsProxyAnalyzerOptions.chkNoLevelsClick(Sender: TObject);
begin
  if chkInternal.Checked then
   chkNoLevels.Checked := True;
end;

procedure TfrmToolsProxyAnalyzerOptions.chkInternalAuthClick(Sender: TObject);
begin
  if chkExternal.Checked then
   chkInternalAuth.Checked := False;

  if chkInternal.Checked then
   chkSpecific.Checked := False;
end;

procedure TfrmToolsProxyAnalyzerOptions.cmdOpenClick(Sender: TObject);
begin
  frmSentry.OpenDialog.Filter := 'Charon Executable (Charon.exe)|Charon.exe';

  if frmSentry.OpenDialog.Execute then
   txtCharon.Text := frmSentry.OpenDialog.FileName;

  frmSentry.OpenDialog.Filter := 'Text Files (*.txt)|*.txt|Any File (*.*)|*.*';
end;

procedure TfrmToolsProxyAnalyzerOptions.cmdCharonClick(Sender: TObject);
var strInput, strOutput: string;
    MutexThread: TMutexThread;

begin
  if txtCharon.Text <> '' then
   begin
    strInput := strLocPath + 'CInput.tmp';
    strOutput := strLocPath + 'COutput.tmp';

    // Save current Proxy List to a temp file for Charon
    FProxyList.SaveToFile (strInput, sdCharon);

    if ShellExecute (0, 'open', PChar (txtCharon.Text), PChar ('-bigauto "' + strInput + '" "' + strOutput + '"'),
                     PChar (ExtractFilePath (txtCharon.Text)), 1) > 32 then
     begin
      FProxyList.Clear;

      // Create and launch thread
      MutexThread := TMutexThread.Create (True);
      MutexThread.FreeOnTerminate := True;
      MutexThread.OutputFile := strOutput;
      MutexThread.OnTerminate := MutexThreadTerminate;
      // Give Charon some time to load before we start checking Mutex
      Sleep (2000);
      MutexThread.Resume;
      FActive := True;
     end
    else
     MessageDlg ('There was a problem executing Charon.', mtError, [mbOK], 0);

    DeleteFile (strInput);
   end;
end;

procedure TfrmToolsProxyAnalyzerOptions.MutexThreadTerminate(Sender: TObject);
var strOutput: string;

begin
  strOutput := (Sender as TMutexThread).OutputFile;

  // Charon is done, load the proxylist back into Sentry
  FProxyList.LoadFromFile (strOutput, sdCharon, False);

  DeleteFile (strOutput);
  FActive := False;
end;

end.
