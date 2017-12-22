unit uFrameToolsHTTPDebugger;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, ExtCtrls, OleCtrls, ComCtrls, Buttons, uVTHttpWrapper,
  HttpProt, Menus, SHDocVw, ActiveX;

type
  TfrmToolsHTTPDebugger = class(TFrame)
    Panel25: TPanel;
    cmdAbort: TSpeedButton;
    cmdStart: TSpeedButton;
    Label40: TLabel;
    cboSite: TComboBox;
    PageControl7: TPageControl;
    TabSheet22: TTabSheet;
    lblByteCount: TLabel;
    memDebug: TRichEdit;
    TabSheet25: TTabSheet;
    WebBrowser: TWebBrowser;
    TabSheet23: TTabSheet;
    rgRequestMethod: TRadioGroup;
    GroupBox24: TGroupBox;
    Label41: TLabel;
    Label48: TLabel;
    Label50: TLabel;
    Label51: TLabel;
    Label81: TLabel;
    txtUserAgent: TEdit;
    txtCookie: TEdit;
    txtTimeout: TEdit;
    txtAcceptLanguage: TEdit;
    chkCustomHeader: TCheckBox;
    GroupBox25: TGroupBox;
    Label42: TLabel;
    Label43: TLabel;
    Label44: TLabel;
    txtProxy: TEdit;
    chkProxy: TCheckBox;
    chkSOCKS: TCheckBox;
    txtSOCKS: TEdit;
    txtSOCKSLevel: TEdit;
    cmdRetrieve: TButton;
    Label52: TLabel;
    Label47: TLabel;
    txtPOSTData: TEdit;
    txtReferer: TEdit;
    cmdReferer: TButton;
    Label45: TLabel;
    txtUsername: TEdit;
    txtPassword: TEdit;
    Label46: TLabel;
    chkRandom: TCheckBox;
    TabSheet1: TTabSheet;
    memHeader: TMemo;
    cmdBuild: TButton;
    cmdClear: TButton;
    Label1: TLabel;
    mnuDebug: TPopupMenu;
    Clear1: TMenuItem;
    chkDisablePageViewer: TCheckBox;
    procedure cmdRetrieveClick(Sender: TObject);
    procedure cmdRefererClick(Sender: TObject);
    procedure chkCustomHeaderClick(Sender: TObject);
    procedure cmdBuildClick(Sender: TObject);
    procedure cmdClearClick(Sender: TObject);
    procedure Clear1Click(Sender: TObject);
    procedure rgRequestMethodClick(Sender: TObject);
    procedure chkDisablePageViewerClick(Sender: TObject);

    procedure cmdStartClick(Sender: TObject);
    procedure cmdAbortClick(Sender: TObject);
  private
    AHttpCli: TVTHttpCli;
    FLockHeader: boolean;

    procedure EnableControls(Active: boolean);
    procedure SetStyle(const S: string);
    procedure SetProxy(var AHttpCli: TVTHttpCli);
    procedure GetRandomProxy;
    function  SanityCheck: boolean;
    procedure AHttpCliCommand(Sender: TObject; var s: String);
    procedure AHttpCliBeforeHeaderSend(Sender: TObject; const Method: String; Headers: TStrings);
    procedure AHttpCliHeaderBegin(Sender: TObject);
    procedure AHttpCliHeaderEnd(Sender: TObject);
    procedure AHttpCliCookie(Sender: TObject; const Data: String; var Accept: Boolean);
    procedure AHttpCliBotTimeout(Sender: TObject);
    procedure AHttpCliLocationChange (Sender: TObject);
    procedure AHttpCliRequestDone(Sender: TObject; RqType: THttpRequest; Error: Word);

  public
    procedure LoadVariables;
    procedure SaveVariables;
  end;

implementation

{$R *.dfm}

uses ufrmMain, IniFiles, uFunctions, IcsUrl, FastStrings, FastStringFuncs,
     uMyListListView;

procedure TfrmToolsHTTPDebugger.LoadVariables;
var strSuffix: string;
    IniFile: TIniFile;
    I: integer;

begin
  if FileExists (strLocPath + 'DebugSites.ini') then
   cboSite.Items.LoadFromFile (strLocPath + 'DebugSites.ini');

  IniFile := TIniFile.Create (strLocPath + 'Settings.ini');
  try
   with IniFile do
    begin
     cboSite.Text := ReadString ('Debugger', 'Site', '');
     rgRequestMethod.ItemIndex := ReadInteger ('Debugger', 'RequestMethod', 0);
     chkProxy.Checked := ReadBool ('Debugger', 'UseProxy', False);
     txtProxy.Text := ReadString ('Debugger', 'Proxy', '');
     chkSOCKS.Checked := ReadBool ('Debugger', 'UseSOCKS', False);
     txtSOCKS.Text := ReadString ('Debugger', 'SOCKS', '');
     txtSOCKSLevel.Text := ReadString ('Debugger', 'SOCKSLevel', '5');
     txtUsername.Text := ReadString ('Debugger', 'Username', '');
     txtPassword.Text := ReadString ('Debugger', 'Password', '');
     txtUserAgent.Text := ReadString ('Debugger', 'Agent', 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)');
     txtTimeout.Text := ReadString ('Debugger', 'Timeout', '30');
     txtReferer.Text := ReadString ('Debugger', 'Referer', '');
     txtPOSTData.Text := ReadString ('Debugger', 'PostData', '');
     txtCookie.Text := ReadString ('Debugger', 'Cookie', '');
     txtAcceptLanguage.Text := ReadString ('Debugger', 'Language', '');
     chkRandom.Checked := ReadBool ('Debugger', 'RandomMyList', False);
     chkDisablePageViewer.Checked := ReadBool ('Debugger', 'DisablePageViewer', False);

     I := ReadInteger ('Integration', 'BrowserIndex', bmpIE);
     case I of
      bmpIE: strSuffix := 'IE';
      bmpFIREFOX: strSuffix := 'Firefox';
      bmpOPERA: strSuffix := 'Opera';
     end;
     cmdRetrieve.Caption := cmdRetrieve.Caption + strSuffix;
    end;
  finally
   IniFile.Free;
  end;
end;

procedure TfrmToolsHTTPDebugger.SaveVariables;
var IniFile: TIniFile;

begin
  cboSite.Items.SaveToFile (strLocPath + 'DebugSites.ini');

  IniFile := TIniFile.Create (strLocPath + 'Settings.ini');
  try
   with IniFile do
    begin
     WriteString ('Debugger', 'Site', cboSite.Text);
     WriteInteger ('Debugger', 'RequestMethod', rgRequestMethod.ItemIndex);
     WriteBool ('Debugger', 'UseProxy', chkProxy.Checked);
     WriteString ('Debugger', 'Proxy', txtProxy.Text);
     WriteBool ('Debugger', 'UseSOCKS', chkSOCKS.Checked);
     WriteString ('Debugger', 'SOCKS', txtSOCKS.Text);
     WriteString ('Debugger', 'SOCKSLevel', txtSOCKSLevel.Text);
     WriteString ('Debugger', 'Username', txtUsername.Text);
     WriteString ('Debugger', 'Password', txtPassword.Text);
     WriteString ('Debugger', 'Agent', txtUserAgent.Text);
     WriteString ('Debugger', 'Timeout', txtTimeout.Text);
     WriteString ('Debugger', 'Referer', txtReferer.Text);
     WriteString ('Debugger', 'PostData', txtPOSTData.Text);
     WriteString ('Debugger', 'Cookie', txtCookie.Text);
     WriteString ('Debugger', 'Language', txtAcceptLanguage.Text);
     WriteBool ('Debugger', 'RandomMyList', chkRandom.Checked);
     WriteBool ('Debugger', 'DisablePageViewer', chkDisablePageViewer.Checked);
    end;
  finally
   IniFile.Free;
  end;
end;

procedure TfrmToolsHTTPDebugger.cmdRetrieveClick(Sender: TObject);
var I: integer;

begin
  I := IniFileReadInteger (strLocPath + 'Settings.ini', 'Integration', 'BrowserIndex', bmpIE);
  txtProxy.Text := GetProxy (I);
end;

procedure TfrmToolsHTTPDebugger.cmdRefererClick(Sender: TObject);
begin
  txtReferer.Text := '[REFERER = SITE]';
end;

procedure TfrmToolsHTTPDebugger.chkCustomHeaderClick(Sender: TObject);
begin
  TabSheet1.TabVisible := chkCustomHeader.Checked;
  if chkCustomHeader.Checked then
   PageControl7.ActivePageIndex := 3;
end;

procedure TfrmToolsHTTPDebugger.cmdBuildClick(Sender: TObject);
var FProto, FUser, FPass, FHost, FPort, FPath, FMethod, FSite: string;

begin
  FSite := cboSite.Text;

  if FSite = '' then
   Exit;

  memHeader.Lines.Clear;

  ParseURL (FSite, FProto, FUser, FPass, FHost, FPort, FPath);
  FMethod := rgRequestMethod.Items.Strings[rgRequestMethod.ItemIndex];

  if FMethod = 'POST' then
   memHeader.Lines.Add (FMethod + ' ' + FProto + '://' + FHost + FPath + ' HTTP/1.1')
  else
   memHeader.Lines.Add (FMethod + ' ' + FProto + '://' + FHost + FPath + ' HTTP/1.0');
  memHeader.Lines.Add ('Accept: */*');
  if FMethod = 'POST' then
   begin
    memHeader.Lines.Add ('Content-Type: application/x-www-form-urlencoded');
    memHeader.Lines.Add ('Connection: keep-alive');
   end;
  if FUser <> '' then
   memHeader.Lines.Add ('Authorization: Basic ' + EncodeStr (encBase64, FUser + ':' + FPass));
  if txtReferer.Text <> '' then
   begin
    if txtReferer.Text = '[REFERER = SITE]' then
     memHeader.Lines.Add ('Referer: ' + FSite)
    else
     memHeader.Lines.Add ('Referer: ' + txtReferer.Text);
   end;
  if txtUserAgent.Text <> '' then
   memHeader.Lines.Add ('User-Agent: ' + txtUserAgent.Text);
  if txtAcceptLanguage.Text <> '' then
   memHeader.Lines.Add ('Accept Language: ' + txtAcceptLanguage.Text);
  if txtCookie.Text <> '' then
   memHeader.Lines.Add ('Cookie: ' + txtCookie.Text);
  memHeader.Lines.Add ('Host: ' + FHost);
  memHeader.Lines.Add ('Pragma: no-cache');
end;

procedure TfrmToolsHTTPDebugger.cmdClearClick(Sender: TObject);
begin
  memHeader.Lines.Clear;
end;

procedure TfrmToolsHTTPDebugger.Clear1Click(Sender: TObject);
begin
  memDebug.Lines.Clear;
end;

procedure TfrmToolsHTTPDebugger.rgRequestMethodClick(Sender: TObject);
begin
  txtPOSTData.Enabled := (rgRequestMethod.ItemIndex = rgPOST);
end;

procedure TfrmToolsHTTPDebugger.chkDisablePageViewerClick(Sender: TObject);
begin
  TabSheet25.TabVisible := not chkDisablePageViewer.Checked;
end;

////////////////////////////////////////////////////////////////////////////////
//                           Start HTTP Debugger Code                         //
////////////////////////////////////////////////////////////////////////////////

procedure TfrmToolsHTTPDebugger.EnableControls(Active: boolean);
begin
  cmdStart.Enabled := Active;
  cmdAbort.Enabled := not Active;
  frmSentry.OutlookBar.Enabled := Active;
  FLockHeader := False;
  if Active = False then
   begin
    if cboSite.Items.IndexOf (cboSite.Text) = -1 then
     cboSite.Items.Add (cboSite.Text);
    frmSentry.StatusBar.Panels[0].Text := 'Sending Request...';
   end;
end;

procedure TfrmToolsHTTPDebugger.SetStyle(const S: string);
begin
  memDebug.SelAttributes.Style := [fsBold];
  memDebug.SelAttributes.Color := clNavy;
  memDebug.Lines.Add (CreateHeader (S));
end;

procedure TfrmToolsHTTPDebugger.SetProxy(var AHttpCli: TVTHttpCli);
var I: integer;

begin
  I := FastCharPos (txtProxy.Text, ':', 1);
  if I <> 0 then
   begin
    AHttpCli.Proxy := CopyStr (txtProxy.Text, 1, I - 1);
    AHttpCli.ProxyPort := CopyStr (txtProxy.Text, I + 1, Length (txtProxy.Text));
   end;
end;

procedure TfrmToolsHTTPDebugger.GetRandomProxy;
var lstMyList: TMyList;

begin
  lstMyList := TMyList.Create (strLocPath + 'MyList.ini');
  try
   Randomize;
   txtProxy.Text := lstMyList.Items[Random (lstMyList.Count)].WriteToString;
   SetProxy (AHttpCli);
  finally
   lstMyList.Free;
  end;
end;

// Returns false if a test fails
function TfrmToolsHTTPDebugger.SanityCheck: boolean;
begin
  Result := False;

  if cboSite.Text = '' then
   begin
    MessageDlg ('No Site Entered.', mtInformation, [mbOK], 0);
    Exit;
   end;

  if (rgRequestMethod.ItemIndex = rgPOST) and (txtPOSTData.Text = '') then
   begin
    MessageDlg ('No POST Data entered.', mtInformation, [mbOK], 0);
    Exit;
   end;

  Result := True;
end;

procedure TfrmToolsHTTPDebugger.cmdStartClick(Sender: TObject);
var I: integer;
    MySendStream: TMemoryStream;

begin
  if SanityCheck = False then
   Exit;

  EnableControls (False);

  AHttpCli := TVTHttpCli.Create (nil);

  AHttpCli.URL := cboSite.Text;
  AHttpCli.Username := txtUsername.Text;
  AHttpCli.Password := txtPassword.Text;
  AHttpCli.Timeout := StrToInt (txtTimeout.Text);
  AHttpCli.FollowRedirects := True;
  AHttpCli.OnCommand := AHttpCliCommand;
  AHttpCli.OnHeaderBegin := AHttpCliHeaderBegin;
  AHttpCli.OnHeaderEnd := AHttpCliHeaderEnd;
  AHttpCli.OnCookie := AHttpCliCookie;
  AHttpCli.OnRequestDone := AHttpCliRequestDone;
  AHttpCli.OnLocationChange := AHttpCliLocationChange;
  AHttpCli.OnBotTimeout := AHttpCliBotTimeout;

  if chkProxy.Checked then
   SetProxy (AHttpCli)
  else if chkSOCKS.Checked then
   begin
    I := FastCharPos (txtSOCKS.Text, ':', 1);
    if I <> 0 then
     begin
      AHttpCli.SocksServer := CopyStr (txtSOCKS.Text, 1, I - 1);
      AHttpCli.SocksPort := CopyStr (txtSOCKS.Text, I + 1, Length (txtSOCKS.Text));
      AHttpCli.SocksLevel := txtSOCKSLevel.Text;
     end;
   end
  else if chkRandom.Checked then
   begin
    GetRandomProxy;
    SetProxy (AHttpCli);
   end;

  if chkCustomHeader.Checked then
   AHttpCli.OnBeforeHeaderSend := AHttpCliBeforeHeaderSend
  else
   begin
    AHttpCli.AcceptLanguage := txtAcceptLanguage.Text;
    AHttpCli.Reference := txtReferer.Text;
    AHttpCli.Agent := txtUserAgent.Text;
    AHttpCli.Cookie := txtCookie.Text;
   end;

   case rgRequestMethod.ItemIndex of
    rgHEAD: AHttpCli.HeadASync;
    rgGET:
     begin
      AHttpCli.RcvdStream := TMemoryStream.Create;
      AHttpCli.GetASync;
     end;

    rgPOST:
     begin
      AHttpCli.RcvdStream := TMemoryStream.Create;

      SetPOSTData (MySendStream, txtPOSTData.Text);
      AHttpCli.SendStream := MySendStream;
      AHttpCli.PostASync;
     end;
   end;
end;

procedure TfrmToolsHTTPDebugger.AHttpCliCommand(Sender: TObject; var s: String);
begin
  memDebug.Lines.Add ('> ' + s);
end;

procedure TfrmToolsHTTPDebugger.AHttpCliBeforeHeaderSend(Sender: TObject; const Method: String; Headers: TStrings);
begin
  // Lock Header for Redirects
  if FLockHeader then
   Exit;

  Headers.Text := Trim (memHeader.Text);
  if Method = 'POST' then
   Headers.Add ('Content-Length: ' + IntToStr ((Sender as TVTHttpCli).SendStream.Size));

  Headers.Text := Headers.Text;
end;

procedure TfrmToolsHTTPDebugger.AHttpCliHeaderBegin(Sender: TObject);
begin
  SetStyle ('Begin Header');
end;

procedure TfrmToolsHTTPDebugger.AHttpCliHeaderEnd(Sender: TObject);
begin
  memDebug.Lines.AddStrings (AHttpCli.RcvdHeader);
  SetStyle ('End Header');
end;

procedure TfrmToolsHTTPDebugger.AHttpCliCookie(Sender: TObject; const Data: String; var Accept: Boolean);
begin
  SetStyle ('Cookie');
  memDebug.Lines.Add (Data);
  SetStyle ('End Cookie');
end;

procedure TfrmToolsHTTPDebugger.AHttpCliBotTimeout(Sender: TObject);
begin
  SetStyle ('Timeout');
end;

procedure TfrmToolsHTTPDebugger.AHttpCliLocationChange (Sender: TObject);
begin
  FLockHeader := True;
  SetStyle ('Redirected');
  memDebug.Lines.Add ('Location changed to "' + AHttpCli.Location + '"');
end;

procedure TfrmToolsHTTPDebugger.AHttpCliRequestDone(Sender: TObject; RqType: THttpRequest; Error: Word);
var strFile: string;
    lstList: TStrings;

begin
  if rgRequestMethod.ItemIndex <> rgHEAD then
   begin
    strFile := strLocPath + 'Source.html';

    (AHttpCli.RcvdStream as TMemoryStream).SaveToFile (strFile);

    if chkDisablePageViewer.Checked = False then
     WebBrowser.Navigate ('file:///' + strFile);

    lblByteCount.Caption := 'Received Byte Count: ' + IntToStr (AHttpCli.RcvdCount);

    SetStyle ('Start Source');

    lstList := TStringList.Create;
    try
     AHttpCli.RcvdStream.Seek (0, soFromBeginning);
     lstList.LoadFromStream (AHttpCli.RcvdStream);
     lstList.Text := FastReplace (lstList.Text, #10, #13#10);
     memDebug.Lines.AddStrings (lstList);
    finally
     lstList.Free;
    end;

    SetStyle ('End Source');
   end;

  SetStyle ('End Transmission');
  memDebug.Lines.Add ('');

  frmSentry.StatusBar.Panels[0].Text := 'Reply From: ' + cboSite.Text + ' ( ' + AHttpCli.Status + ' )';

  FreeAndNil (AHttpCli);
  EnableControls (True);
end;

procedure TfrmToolsHTTPDebugger.cmdAbortClick(Sender: TObject);
begin
  AHttpCli.CloseAsync;
  frmSentry.StatusBar.Panels[0].Text := 'Aborting Engine...';
end;

// Needed initialization/finalization to fix copy/paste\
// because of TWebbrowser's limitations

initialization
 OleInitialize (nil);

finalization
 OleUninitialize;

end.
