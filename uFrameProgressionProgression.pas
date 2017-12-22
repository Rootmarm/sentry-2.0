unit uFrameProgressionProgression;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ComCtrls, ImgList, Menus, StdCtrls, ExtCtrls, uBruteForcer,
  uProgressListView, uKeywordBot, IniFiles, uSnapShot, ufrmDebugEngine,
  JvComponent, JvPanel, JvExExtCtrls, Buttons, uPngSpeedButton,
  uHistoryListView;

type
  TFloatDockForm = class(TCustomDockForm);

  TfrmProgressionProgression = class(TFrame)
    Splitter1: TSplitter;
    Panel6: TPanel;
    lstCProgression: TListView;
    Panel4: TPanel;
    Splitter2: TSplitter;
    Panel1: TPanel;
    Label1: TLabel;
    Panel2: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    lbl200: TLabel;
    lbl3xx: TLabel;
    lbl403: TLabel;
    lbl404: TLabel;
    lbl5xx: TLabel;
    lblRetries: TLabel;
    lblTimeouts: TLabel;
    Label9: TLabel;
    lblPLeft: TLabel;
    Panel5: TPanel;
    Label10: TLabel;
    lbl401: TLabel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    lstHits: TListBox;
    lstRedirects: TListBox;
    lstFakes: TListBox;
    lblPDisabled: TLabel;
    Label12: TLabel;
    lblPBanned: TLabel;
    Label14: TLabel;
    Label11: TLabel;
    lblFakes: TLabel;
    Label15: TLabel;
    lblHits: TLabel;
    Label13: TLabel;
    mnuLists: TPopupMenu;
    LaunchInBrowser1: TMenuItem;
    mnuProxy: TMenuItem;
    Panel3: TPanel;
    Label16: TLabel;
    Label17: TLabel;
    sldBots: TTrackBar;
    sldWordlist: TTrackBar;
    lblBots: TLabel;
    lblWordlist: TLabel;
    mnuWordlist: TPopupMenu;
    ResetWordlistPosition1: TMenuItem;
    CopyURLToClipboard1: TMenuItem;
    SendToHistory1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    CopyProxyToClipboard1: TMenuItem;
    mnuDebugMemo: TPopupMenu;
    ClearMemo1: TMenuItem;
    N3: TMenuItem;
    MinimizeMemo1: TMenuItem;
    panProgression: TJvPanel;
    cmdOpenMemo: TPngSpeedButton;
    cmdOpenDebug: TPngSpeedButton;
    cmdDebugEngine: TPngSpeedButton;
    cmdReloadSettings: TPngSpeedButton;
    CopyComboToClipboad1: TMenuItem;
    N4: TMenuItem;
    BanProxy1: TMenuItem;
    BanProxyAndAddToBlacklist1: TMenuItem;
    procedure lstCProgressionData(Sender: TObject; Item: TListItem);
    procedure mnuProxyClick(Sender: TObject);
    procedure LaunchInBrowser1Click(Sender: TObject);
    procedure sldBotsChange(Sender: TObject);
    procedure sldWordlistChange(Sender: TObject);
    procedure ResetWordlistPosition1Click(Sender: TObject);
    procedure CopyURLToClipboard1Click(Sender: TObject);
    procedure CopyComboToClipboad1Click(Sender: TObject);
    procedure CopyProxyToClipboard1Click(Sender: TObject);
    procedure BanProxy1Click(Sender: TObject);
    procedure BanProxyAndAddToBlacklist1Click(Sender: TObject);
    procedure SendToHistory1Click(Sender: TObject);
    procedure MinimizeMemo1Click(Sender: TObject);
    procedure ClearMemo1Click(Sender: TObject);
    procedure lstCProgressionMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure panProgressionMouseLeave(Sender: TObject);
    procedure cmdOpenDebugClick(Sender: TObject);
    procedure cmdOpenMemoClick(Sender: TObject);
    procedure cmdDebugEngineClick(Sender: TObject);
    procedure cmdReloadSettingsClick(Sender: TObject);
  private
    lstProgression: TProgressList;
    iDockLeft, iDockTop: integer;
    blnFloatDialog, blnPopupMemo, blnWriteDebug: boolean;
    FBruteForcer: TBruteForcer;
    FSnapShot: TSnapShot;
    FPopupMemo: TMemo;
    FDebugFile: TextFile;
    FLogFile: TextFile;
    blnAssignedDebugFile: boolean;
    blnAssignedLogFile: boolean;
    frmDebugEngine: TfrmDebugEngine;
    FHistoryList: THistory;

    function  GetStringAfterLastSpace(const S: string): string;
    function  FormatKeywords(const strFileName: string): string;
    procedure ReadINISettings;
    procedure WriteINISettings;
    procedure UpdateProgressList;
    function  GetStringFromListBox(Sender: TObject): string;
    function  BanProxy(Sender: TObject): string;

    procedure UpdateStatistics;
    procedure EnableControls(const blnActive: boolean);
    function  GetFailureKeys(IniFile: TIniFile; const strPath: string; const blnSnapShot: boolean): string;
    procedure LoadSettings(strDomain: string = '');
    procedure WriteHitToFiles(const strURL, strProxy: string; AHttpCli: TKeywordBot);
    procedure WriteHitToDebug(AHttpCli: TKeywordBot; strURL, strProxy: string);
    procedure PopupMemo(AHttpCli: TKeywordBot; const strURL, strProxy: string);
    procedure BruteForcerBotComplete(Sender: TObject; AHttpCli: TKeywordBot);
    procedure BruteForcerFakeFound(Sender: TObject; AHttpCli: TKeywordBot; const strCombo: string; const iPIndex: integer);
    procedure BruteForcerHitFound(Sender: TObject; AHttpCli: TKeywordBot);
    procedure BruteForcerRedirectFound(Sender: TObject; AHttpCli: TKeywordBot);
    procedure BruteForcerUpdateListview(Sender: TObject; AHttpCli: TKeywordBot);
    procedure BruteForcerUpdateProgressList(Sender: TObject);
    procedure BruteForcerServerFound(Sender: TObject);
    procedure BruteForcerEngineComplete(Sender: TObject);
    procedure SnapShotSnapShotDoesNotExist(Sender: TObject);
    procedure SnapShotSnapShotExists(Sender: TObject);
    procedure SnapShotWordlistPositionExists(Sender: TObject);
    function  SanityCheck(var blnWarning: boolean): boolean;
    procedure AssignSnapShot;
  public
    procedure LoadVariables;
    procedure SaveVariables;
    procedure StartBruteForcer;
    procedure AbortBruteForcer;

    property BruteForcer: TBruteForcer read FBruteForcer;
    property HistoryList: THistory read FHistoryList write FHistoryList;
  end;

implementation

{$R *.dfm}

uses FastStrings, FastStringFuncs, ufrmMain, uWordlist, uFunctions,
     uMyListListView, ShellAPI, Clipbrd, uFormBot;

// Returns the string after the first space found, starting from the back of the param string
function TfrmProgressionProgression.GetStringAfterLastSpace(const S: string): string;
var I: integer;

begin
  Result := '';

  for I := Length (S) downto 1 do
   begin
    if S[I] = ' ' then
     begin
      Result := CopyStr (S, I + 1, Length (S));
      Break;
     end;
   end;
end;

// Given a Location to a file, it takes the keywords and formats them in
// a string with a ';' as the delimiter
function TfrmProgressionProgression.FormatKeywords(const strFileName: string): string;
var lstList: TStrings;

begin
  Result := '';
  lstList := TStringList.Create;

  try
   if FileExists (strFileName) then
    begin
     lstList.LoadFromFile (strFileName);
     Result := FastReplace (Trim (lstList.Text), #13#10, ';');
    end;
  finally
   lstList.Free;
  end;
end;

procedure TfrmProgressionProgression.ReadINISettings;
var IniFile: TIniFile;

begin
  IniFile := TIniFile.Create (strLocPath + 'Settings.ini');
  try
   with IniFile do
    begin
     blnFloatDialog := ReadBool ('Settings', 'FloatStat', True);
     if blnFloatDialog then
      begin
       iDockLeft := ReadInteger ('Progression', 'DockLeft', 0);
       iDockTop := ReadInteger ('Progression', 'DockTop', 0);
      end;
     sldWordlist.Max := ReadInteger ('Lists', 'WordlistLen', 1);
     sldWordlist.Position := ReadInteger ('Lists', 'StartSearch', 1);
     sldBots.Position := ReadInteger ('Settings', 'Bots', 1);
     frmSentry.prgStatus.MaxValue := sldWordlist.Max;
    end;
  finally
   IniFile.Free;
  end;
end;

procedure TfrmProgressionProgression.WriteINISettings;
var IniFile: TIniFile;

begin
  IniFile := TIniFile.Create (strLocPath + 'Settings.ini');
  try
   with IniFile, TFloatDockForm (Panel1.Parent) do
    begin
     WriteInteger ('Progression', 'DockLeft', Left);
     WriteInteger ('Progression', 'DockTop', Top);
     WriteInteger ('Lists', 'StartSearch', sldWordlist.Position);
     WriteInteger ('Settings', 'Bots', sldBots.Position);
    end;
  finally
   IniFile.Free;
  end;
end;

procedure TfrmProgressionProgression.LoadVariables;
var MyRect: TRect;
    I: integer;
    strSuffix: string;

begin
  lstCProgression.DoubleBuffered := True;
  ReadINISettings;
  lstProgression := TProgressList.Create;

  if FileExists (strLocPath + 'History.ini') then
   FHistoryList := THistory.Create (strLocPath + 'History.ini')
  else
   FHistoryList := THistory.Create;

  if blnFloatDialog then
   begin
    if iDockLeft = 0 then
     iDockLeft := Screen.Width - Screen.Width div 4;
    if iDockTop = 0 then
     iDockTop := Screen.Height - Screen.Height div 3;

    MyRect.Left := iDockLeft;
    MyRect.Top := iDockTop;
    MyRect.Right := MyRect.Left + Panel1.Width;
    MyRect.Bottom := MyRect.Top + 150;

    Panel1.FloatingDockSiteClass := TFloatDockForm;
    Panel1.ManualFloat (MyRect);

    TFloatDockForm (Panel1.Parent).BorderIcons := [];
   end;

  I := IniFileReadInteger (strLocPath + 'Settings.ini', 'Integration', 'BrowserIndex', bmpIE);
  case I of
   bmpIE: strSuffix := 'IE';
   bmpFIREFOX: strSuffix := 'Firefox';
   bmpOPERA: strSuffix := 'Opera';
  end;

  mnuProxy.Caption := 'Use Proxy In ' + strSuffix;
  mnuProxy.ImageIndex := I;
end;

procedure TfrmProgressionProgression.SaveVariables;
begin
  lstCProgression.OnData := nil;

  FHistoryList.SaveToFile (strLocPath + 'History.ini');
  FHistoryList.Free;

  WriteINISettings;
  if blnFloatDialog then
   TFloatDockForm (Panel1.Parent).Free;
  FreeAndNil (lstProgression);
  if Assigned (FPopupMemo) then
   TFloatDockForm (FPopupMemo.Parent).Free;
end;

procedure TfrmProgressionProgression.UpdateProgressList;
begin
  lstCProgression.Items.BeginUpdate;
  try
   lstCProgression.Items.Count := lstProgression.Count;
  finally
   lstCProgression.Items.EndUpdate;
  end;
end;

procedure TfrmProgressionProgression.lstCProgressionData(Sender: TObject; Item: TListItem);
begin
  if Item.Index >= lstProgression.Count then
   Exit;

  with lstProgression[Item.Index] do
   begin
    Item.Caption := IntToStr (BotNumber);
    Item.SubItems.Add (Proxy);
    Item.SubItems.Add (Username);
    Item.SubItems.Add (Password);
    Item.SubItems.Add (Response);
   end;
end;

function TfrmProgressionProgression.GetStringFromListBox(Sender: TObject): string;
var ListBox: TListBox;
    I: integer;

begin
  if Sender is TMenuItem then
   ListBox := ((Sender as TMenuItem).GetParentComponent as TPopupMenu).PopupComponent as TListBox
  else
   ListBox := Sender as TListBox;

  I := ListBox.ItemIndex;
  if I = -1 then
   Result := ''
  else
   Result := ListBox.Items.Strings[I];
end;

procedure TfrmProgressionProgression.mnuProxyClick(Sender: TObject);
var strTmp: string;

begin
  strTmp := GetStringFromListBox (Sender);
  if strTmp = '' then
   Exit;

  strTmp := GetStringAfterLastSpace (strTmp);

  if SetProxy (strTmp, mnuProxy.ImageIndex) then
   MessageBox (Application.Handle, PChar ('Using Proxy "' + strTmp + '"' + #13#10#13#10 +
                                          'Browser needs to be restarted for Proxy Settings to take effect.'), 'Success', MB_ICONINFORMATION + MB_APPLMODAL);
end;

procedure TfrmProgressionProgression.LaunchInBrowser1Click(Sender: TObject);
var I: integer;
    strTmp: string;

begin
  strTmp := GetStringFromListBox (Sender);
  if strTmp = '' then
   Exit;

  SetLength (strTmp, FastCharPos (strTmp, ' ', 1) - 1);

  I := IniFileReadInteger (strLocPath + 'Settings.ini', 'Integration', 'BrowserIndex', bmpIE);
  LaunchSite (strTmp, I);
end;

procedure TfrmProgressionProgression.sldBotsChange(Sender: TObject);
begin
  lblBots.Caption := IntToStr (sldBots.Position);

  if Assigned (FBruteForcer) then
   FBruteForcer.Bots := sldBots.Position;
end;

procedure TfrmProgressionProgression.sldWordlistChange(Sender: TObject);
begin
  lblWordlist.Caption := IntToStr (sldWordlist.Position);

  if (Assigned (frmSentry.frmHistoryHistory) = False) and (Assigned (frmSentry.frmToolsProxyAnalyzer) = False) then
   frmSentry.prgStatus.Progress := sldWordlist.Position;

  if Assigned (FBruteForcer) then
   FBruteForcer.Position := sldWordlist.Position;
end;

procedure TfrmProgressionProgression.ResetWordlistPosition1Click(Sender: TObject);
begin
  sldWordlist.Position := 1;
end;

procedure TfrmProgressionProgression.CopyURLToClipboard1Click(Sender: TObject);
var strTmp: string;

begin
  strTmp := GetStringFromListBox (Sender);
  if strTmp = '' then
   Exit;

  SetLength (strTmp, FastCharPos (strTmp, ' ', 1) - 1);

  Clipboard.AsText := strTmp;
end;

procedure TfrmProgressionProgression.CopyComboToClipboad1Click(Sender: TObject);
var strTmp: string;

begin
  strTmp := GetStringFromListBox (Sender);
  if strTmp = '' then
   Exit;

  SetLength (strTmp, FastCharPos (strTmp, ' ', 1) - 1);
  Clipboard.AsText := GetUsername (strTmp) + ':' + GetPassword (strTmp);
end;

procedure TfrmProgressionProgression.CopyProxyToClipboard1Click(Sender: TObject);
var strTmp: string;

begin
  strTmp := GetStringFromListBox (Sender);
  if strTmp = '' then
   Exit;

  strTmp := GetStringAfterLastSpace (strTmp);

  Clipboard.AsText := strTmp;
end;

function TfrmProgressionProgression.BanProxy(Sender: TObject): string;
var strTmp: string;

begin
  strTmp := GetStringFromListBox (Sender);
  if strTmp = '' then
   Exit;

  Result := GetStringAfterLastSpace (strTmp);

  if (Assigned (FBruteForcer)) and (Assigned (FBruteForcer.MyList)) then
   FBruteForcer.MyList.SetProxyInList (Result, bmpBANNED);
end;

procedure TfrmProgressionProgression.BanProxy1Click(Sender: TObject);
begin
  BanProxy (Sender);
end;

procedure TfrmProgressionProgression.BanProxyAndAddToBlacklist1Click(Sender: TObject);
var F: TextFile;
    strFile, strProxy: string;
    I: integer;

begin
  strProxy := BanProxy (Sender);
  I := FastCharPos (strProxy, ':', 8);
  if I <> 0 then
   SetLength (strProxy, I - 1);

  strFile := strLocPath + 'Blacklist.ini';

  AppendOrRewriteFile (F, strFile);
  try
   Writeln (F, strProxy);
  finally
   CloseFile (F);
  end;
end;

procedure TfrmProgressionProgression.SendToHistory1Click(Sender: TObject);
var strURL, strProxy: string;

begin
  strURL := GetStringFromListBox (Sender);
  if strURL = '' then
   Exit;

  strProxy := GetStringAfterLastSpace (strURL);

  SetLength (strURL, FastCharPos (strURL, ' ', 1) - 1);

  WriteHitToFiles (strURL, strProxy, nil);
  CloseFile (FLogFile);
  blnAssignedLogFile := False;
end;

procedure TfrmProgressionProgression.MinimizeMemo1Click(Sender: TObject);
begin
  SendMessage (FPopupMemo.Parent.Handle, WM_SYSCOMMAND, SC_MINIMIZE, 0);
end;

procedure TfrmProgressionProgression.ClearMemo1Click(Sender: TObject);
begin
  FPopupMemo.Clear;
end;

procedure TfrmProgressionProgression.lstCProgressionMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  panProgression.Visible := (lstCProgression.Width - X < 50);
end;

procedure TfrmProgressionProgression.panProgressionMouseLeave(Sender: TObject);
begin
  panProgression.Visible := False;
end;

procedure TfrmProgressionProgression.cmdOpenDebugClick(Sender: TObject);
begin
  ShellExecute (0, 'open', 'notepad.exe', PChar (strLocPath + 'Debug.txt'), 'c:/', 1);
end;

procedure TfrmProgressionProgression.cmdOpenMemoClick(Sender: TObject);
begin
  if Assigned (FPopupMemo) then
   FPopupMemo.Show;
end;

procedure TfrmProgressionProgression.cmdDebugEngineClick(Sender: TObject);
begin
  if Assigned (frmDebugEngine) = False then
    frmDebugEngine := TfrmDebugEngine.Create (Self);

  frmDebugEngine.BruteForcer := FBruteForcer;
  frmDebugEngine.Show;
end;

procedure TfrmProgressionProgression.cmdReloadSettingsClick(Sender: TObject);
begin
  if Assigned (FBruteForcer) then
   LoadSettings;
end;

///////////////////////////////////////////////////////////////////////////////
//                         Start BruteForcer                                 //
///////////////////////////////////////////////////////////////////////////////

procedure TfrmProgressionProgression.UpdateStatistics;
begin
  with FBruteForcer.Statistics^ do
   begin
    lbl200.Caption := IntToStr (i200);
    lbl3xx.Caption := IntToStr (i3xx);
    lbl401.Caption := IntToStr (i401);
    lbl403.Caption := IntToStr (i403);
    lbl404.Caption := IntToStr (i404);
    lbl5xx.Caption := IntToStr (i5xx);
    lblRetries.Caption := IntToStr (iRetry);
    lblTimeouts.Caption := IntToStr (iTimeout);
    lblPLeft.Caption := IntToStr (iPLeft);
    lblPBanned.Caption := IntToStr (iPBanned);
    lblPDisabled.Caption := IntToStr (iPDisabled);
    lblHits.Caption := IntToStr (iHits);
    lblFakes.Caption := IntToStr (iFakes);
   end;
end;

procedure TfrmProgressionProgression.EnableControls(const blnActive: boolean);
begin
  frmSentry.cboSite.Enabled := blnActive;
  frmSentry.cmdStart.Enabled := blnActive;
  frmSentry.cmdAbort.Enabled := not blnActive;

  if blnActive = False then
   begin
    lstHits.Items.Clear;
    lstFakes.Items.Clear;
    lstRedirects.Items.Clear;
    lstProgression.Clear;
   end;
end;

// IniFile must be usable when passing into this function
function TfrmProgressionProgression.GetFailureKeys(IniFile: TIniFile; const strPath: string; const blnSnapShot: boolean): string;
begin
  Result := '';

  if (IniFile.ReadBool ('Keywords', 'EnableSourceFail', False)) or (IniFile.ReadBool ('Keywords', 'GlobalFail', False)) then
   begin
    // Don't use Global Failure Keywords if a SnapShot is being used
    if blnSnapShot = False then
     Result := FormatKeywords (strLocPath + 'GlobalFail.ini');
    if Result <> '' then
     Result := Result + ';';
    Result := Result + FormatKeywords (strPath + 'SourceFail.ini');

    // Clear ";" from the end of the string if it exists
    if RightStr (Result, 1) = ';' then
     SetLength (Result, Length (Result) - 1);
   end;
end;

// If a domain is passed in, a SnapShot is being used
procedure TfrmProgressionProgression.LoadSettings(strDomain: string = '');
var IniFile: TIniFile;
    strPath, strWordlist: string;

begin
  strPath := strLocPath;
  if strDomain <> '' then
   strPath := strPath + 'SnapShots\' + strDomain + '-';

  if strDomain = '' then
   // Not using a SnapShot, load Settings.ini file
   IniFile := TIniFile.Create (strLocPath + 'Settings.ini')
  else
   // Using a SnapShot, load from SnapShot file which is based off the Domain
   IniFile := TIniFile.Create (strLocPath + 'SnapShots\' + strDomain + '.ini');
  try
   with IniFile, FBruteForcer do
    begin
     ProgressList          := lstProgression;
     RequestMethod         := ReadInteger ('Settings', 'RequestMethod', rgGET);

     if ReadBool ('Keywords', 'EnableHeaderRetry', False) then
      begin
       HeaderRetryCodes := TStringList.Create;
       HeaderRetryCodes.LoadFromFile (strPath + 'HeaderRetry.ini');
      end;
     if ReadBool ('Keywords', 'EnableHeaderFail', False) then
      HeaderFailureKeys    := FormatKeywords (strPath + 'HeaderFail.ini');
     if ReadBool ('Keywords', 'EnableHeaderSuccess', False) then
      HeaderSuccessKeys    := FormatKeywords (strPath + 'HeaderSuccess.ini');

     // POST specific Engine Options
     if RequestMethod = rgPOST then
      begin
       POSTData           := ReadString ('Settings', 'POSTData', '');
       FormAction         := ReadString ('Form', 'Action', '');
       FormReferer        := ReadString ('Form', 'ReqReferer', '');
       FormCookie         := ReadString ('Form', 'ReqCookie', '');
       RefreshSession     := ReadBool ('Form', 'RefreshSession', False);
       FormURL            := frmSentry.cboSite.Text;
      end;

     // Keyword Engine Options, used in GET and POST
     if RequestMethod <> rgHEAD then
      begin
       if ReadBool ('Keywords', 'EnableSourceBan', False) then
        begin
         BanKeywords := TStringList.Create;
         BanKeywords.LoadFromFile (strPath + 'SourceBan.ini');
        end;
       SourceFailureKeys     := GetFailureKeys (IniFile, strPath, (strDomain <> ''));
       if ReadBool ('Keywords', 'EnableSourceSuccess', False) then
        SourceSuccessKeys    := FormatKeywords (strPath + 'SourceSuccess.ini');
      end;

     Bots                  := sldBots.Position;
     if ReadBool ('Fake', 'EnableConHits', False) then
      ConstrainHits := ReadInteger ('Fake', 'ConHits', 10);
     CustomHeader          := FastReplace (ReadString ('Settings', 'HTTPHeader', ''), '|', #13#10);
     EnableAfterFP         := ReadBool ('Fake', 'AfterFP', True);
     EnableCheckHits       := ReadBool ('Fake', 'CheckHits', False);
     EnableComboConstraints := ReadBool ('Lists', 'LengthFilter', False);
     EnableMetaRedirects   := ReadBool ('Fake', 'MetaRedirect', False);
     EnableResolveHost     := ReadBool ('Settings', 'ResolveHost', False);

     // Always Follow Redirects with GET with Keywords
     if ((RequestMethod = rgGET) and ((SourceFailureKeys <> '') or (SourceSuccessKeys <> ''))) then
      FollowRedirects      := True
     else
      FollowRedirects      := ReadBool ('Fake', 'FollowRedirect', False);

     PasswordMax           := ReadInteger ('Lists', 'PasswordEnd', 8);
     PasswordMin           := ReadInteger ('Lists', 'PasswordStart', 6);

     if ReadBool ('Fake', 'EnableConLength', False) then
      RequiredLength       := ReadInteger ('Fake', 'ConLength', 200)
     else
      RequiredLength       := -1;

     Timeout               := ReadInteger ('Settings', 'Timeout', 10);
     URL                   := frmSentry.cboSite.Text;

     UsernameMax           := ReadInteger ('Lists', 'UsernameEnd', 8);
     UsernameMin           := ReadInteger ('Lists', 'UsernameStart', 6);

     UserAgentList := TStringList.Create;
     if FileExists (strLocPath + 'UserAgents.ini') then
      UserAgentList.LoadFromFile (strLocPath + 'UserAgents.ini');
    end;
  finally
   IniFile.Free;
  end;

  // This Information is not included in SnapShots
  IniFile := TIniFile.Create (strLocPath + 'Settings.ini');
  try
   with IniFile, FBruteForcer do
    begin
     blnPopupMemo          := ReadBool ('Settings', 'DebugMemo', False);
     blnWriteDebug         := ReadBool ('Settings', 'Debug', False);
     ProxiesActive         := ReadInteger ('Settings', 'ProxyActivate', 10);
    
     if (Assigned (FSnapShot)) and (FSnapShot.WordlistPosition > 0) then
      Position             := FSnapShot.WordlistPosition
     else
      Position             := sldWordlist.Position - 1;
     // Wordlist must exist when Loading Engine Settings
     strWordlist           := ReadString ('Lists', 'Wordlist', '');
     Wordlist              := TWordlist.Create (strWordlist);
    end;
  finally
   IniFile.Free;
  end;
end;

// Returns False if Sanity Check Failed
function TfrmProgressionProgression.SanityCheck(var blnWarning: boolean): boolean;
var IniFile: TIniFile;
    strWordlist, strMyList: string;

begin
  Result := False;

  IniFile := TIniFile.Create (strLocPath + 'Settings.ini');
  try
   strWordlist := IniFile.ReadString ('Lists', 'Wordlist', '');
   if (strWordlist = '') or (FileExists (strWordlist) = False) then
   begin
    MessageDlg ('No Wordlist Entered.', mtWarning, [mbOK], 0);
    Exit;
   end;

   if (IniFile.ReadInteger ('Settings', 'RequestMethod', 1) = rgPOST)
       and (IniFile.ReadString ('Settings', 'POSTData', '') = '') then
    begin
     MessageDlg ('Trying to send a Post Request without POST Data.', mtWarning, [mbOK], 0);
     Exit;
    end;
  finally
   IniFile.Free;
  end;

  // Fix URL if no protocol is specified
  if GetProtocol (frmSentry.cboSite.Text) = '' then
   frmSentry.cboSite.Text := 'http://' + frmSentry.cboSite.Text;

  blnWarning := False;

  strMyList := strLocPath + 'MyList.ini';
  if GetFileSize (strMyList) = 0 then
   begin
    if MessageDlg ('You are about to start a test without any proxies in My List.' +
                   #13#10#13#10 + 'Are you sure you want to do this?', mtWarning, [mbYes, mbNo], 0) in [mrNo] then
     Exit
    else
     blnWarning := True;
   end;

  Result := True;
end;

// Assigns a SnapShot if user chooses to use them.
// If not, then just load settings.
procedure TfrmProgressionProgression.AssignSnapShot;
begin
  if IniFileReadBool (strLocPath + 'Settings.ini', 'Settings', 'SnapShots', True) then
   begin
    FSnapShot := TSnapShot.Create (FBruteForcer, frmSentry.cboSite.Text);
    FSnapShot.OnSnapShotDoesNotExist := SnapShotSnapShotDoesNotExist;
    FSnapShot.OnSnapShotExists := SnapShotSnapShotExists;
    FSnapShot.OnWordlistPositionExists := SnapShotWordlistPositionExists;
    FSnapShot.Initialize;
   end
  else
   LoadSettings;
end;

procedure TfrmProgressionProgression.StartBruteForcer;
var blnWarning: boolean;

begin
  // Site Check is performed in ufrmMain cmdStartClick because a check for
  // a valid HTTP Header needs to be done before entering this unit

  if SanityCheck (blnWarning) = False then
   Exit;

  EnableControls (False);

  FBruteForcer := TBruteForcer.Create;

  AssignSnapShot;

  // Set all Assigned File variables = False
  blnAssignedLogFile := False;
  blnAssignedDebugFile := False;

  with FBruteForcer do
   begin
    if blnWarning = False then
     MyList := TMyList.Create (strLocPath + 'MyList.ini');

    OnBotComplete := BruteForcerBotComplete;
    OnEngineComplete := BruteForcerEngineComplete;
    OnFakeFound := BruteForcerFakeFound;
    OnHitFound := BruteForcerHitFound;
    OnRedirectFound := BruteForcerRedirectFound;
    OnUpdateListview := BruteForcerUpdateListview;
    OnUpdateProgressList := BruteForcerUpdateProgressList;
    OnServerFound := BruteForcerServerFound;

    InitializeEngine;
    CreateAllBots;
   end;
end;

procedure TfrmProgressionProgression.AbortBruteForcer;
begin
  FBruteForcer.AbortEngine;
  frmSentry.StatusBar.Panels[0].Text := 'Aborting Engine...';
end;

procedure TfrmProgressionProgression.WriteHitToFiles(const strURL, strProxy: string; AHttpCli: TKeywordBot);
var strReqMethod, strSourceFailureKeys, strSourceSuccessKeys, strWordlist,
    strFormAction, strPOSTData: string;
    IniFile: TIniFile;
    aSite: TSite;

begin
  strFormAction := '';
  strPOSTData := '';

  strWordlist := CopyStr (frmSentry.StatusBar.Panels[1].Text, 11, Length (frmSentry.StatusBar.Panels[1].Text));

  if Assigned (AHttpCli) then
   begin
    case FBruteForcer.RequestMethod of
     rgHEAD: strReqMethod := 'HEAD';
     rgGET:  strReqMethod := 'GET';
     rgPOST:
     begin
      strReqMethod := 'POST';
      with AHttpCli as TFormBot do
       begin
        strFormAction := FormData^.Action;
        strPOSTData := POSTData;
       end;
     end;
    end;

    strSourceFailureKeys := FBruteForcer.SourceFailureKeys;
    strSourceSuccessKeys := FBruteForcer.SourceSuccessKeys;
   end
  else
   begin
    IniFile := TIniFile.Create (strLocPath + 'Settings.ini');

    try
     case IniFile.ReadInteger ('Settings', 'RequestMethod', rgGET) of
      rgHEAD: strReqMethod := 'HEAD';
      rgGET:  strReqMethod := 'GET';
      rgPOST: strReqMethod := 'POST';
     end;

     strSourceFailureKeys := GetFailureKeys (IniFile, strLocPath, Assigned (FSnapShot));
     strSourceSuccessKeys := '';

     if IniFile.ReadBool ('Keywords', 'EnableSourceSuccess', False) then
      strSourceSuccessKeys := FormatKeywords (strLocPath + 'SourceSuccess.ini');
    finally
     IniFile.Free;
    end;
   end;

  // Add Hit To History List
  aSite := TSite.Create;
  aSite.Site := strURL;
  aSite.Proxy := strProxy;
  aSite.FailKeys := strSourceFailureKeys;
  aSite.SuccessKeys := strSourceSuccessKeys;
  aSite.FormAction := strFormAction;
  aSite.POSTData := strPOSTData;
  aSite.ReqMethod := strReqMethod;
  aSite.Wordlist := strWordlist;

  FHistoryList.Add (aSite);

  // Write Hit To LogFile
  if blnAssignedLogFile = False then
   begin
    AppendOrRewriteFile (FLogFile, strLocPath + 'LogFile.txt');
    blnAssignedLogFile := True;
   end;

  Writeln (FLogFile, strURL + '|' + strProxy + '||' +
           strSourceFailureKeys + '|' + strSourceSuccessKeys + '|' +
           strFormAction + '|' + strPOSTData + '|' + strReqMethod +
           '|' + strWordlist + '|0');
  Flush (FLogFile);
end;

procedure TfrmProgressionProgression.WriteHitToDebug(AHttpCli: TKeywordBot; strURL, strProxy: string);
var strFile: string;

begin
  if blnAssignedDebugFile = False then
   begin
    strFile := strLocPath + 'Debug.txt';
    AppendOrRewriteFile (FDebugFile, strFile);
    blnAssignedDebugFile := True;
   end;

  Writeln (FDebugFile, 'Hit: ' + strURL + '    Proxy: ' + strProxy + '    Time: ' + DateTimeToStr (Now));
  Writeln (FDebugFile, CreateHeader ('Start Header'));
  Writeln (FDebugFile, AHttpCli.SentHeader);
  Writeln (FDebugFile, '');
  Writeln (FDebugFile, AHttpCli.RcvdHeader.Text);
  Writeln (FDebugFile, CreateHeader ('End Header'));
  Writeln (FDebugFile, CreateHeader ('Start Source'));
  Writeln (FDebugFile, AHttpCli.Source);
  Writeln (FDebugFile, CreateHeader ('End Source'));
  Writeln (FDebugFile, '');
  Flush (FDebugFile);
end;

procedure TfrmProgressionProgression.PopupMemo(AHttpCli: TKeywordBot; const strURL, strProxy: string);
var MyRect: TRect;

begin
  if Assigned (FPopupMemo) = False then
   begin
    FPopupMemo := TMemo.Create (Self);
    FPopupMemo.Parent := Self;
    FPopupMemo.DragKind := dkDock;
    FPopupMemo.FloatingDockSiteClass := TFloatDockForm;
    FPopupMemo.ScrollBars := ssBoth;
    FPopupMemo.PopupMenu := mnuDebugMemo;
    MyRect.Top := Screen.Height div 5;
    MyRect.Bottom := Screen.Height - MyRect.Top;
    MyRect.Left := Screen.Width div 5;
    MyRect.Right := Screen.Width - MyRect.Left;

    FPopupMemo.ManualFloat (MyRect);
    TFloatDockForm (FPopupMemo.Parent).FormStyle := fsNormal;
   end
  else
   FPopupMemo.Show;

  FPopupMemo.Lines.Add ('Hit: ' + strURL + '    Proxy: ' + strProxy + '    Time: ' + DateTimeToStr (Now));
  FPopupMemo.Lines.Add (CreateHeader ('Start Header'));
  FPopupMemo.Lines.Add (AHttpCli.SentHeader);
  FPopupMemo.Lines.Add ('');
  FPopupMemo.Lines.AddStrings (AHttpCli.RcvdHeader);
  FPopupMemo.Lines.Add (CreateHeader ('End Header'));
  FPopupMemo.Lines.Add (CreateHeader ('Start Source'));
  FPopupMemo.Lines.Add (AHttpCli.Source);
  FPopupMemo.Lines.Add (CreateHeader ('End Source'));
  FPopupMemo.Lines.Add ('');
end;

procedure TfrmProgressionProgression.BruteForcerBotComplete(Sender: TObject; AHttpCli: TKeywordBot);
begin
  // Update the listitem to reflect Status property changes
  lstCProgression.Items[AHttpCli.Bot].Update;

  // Update Statistics window
  UpdateStatistics;
  frmSentry.prgStatus.Progress := FBruteForcer.Position;
  frmSentry.StatusBar.Panels[0].Text := Format ('[%d / %d] - %d%s Done',
                                        [frmSentry.prgStatus.Progress, frmSentry.prgStatus.MaxValue, frmSentry.prgStatus.PercentDone, '%']);
  Application.Title := 'Sentry 2 - ' + frmSentry.StatusBar.Panels[0].Text;
  frmSentry.TrayIcon.Hint := Application.Title;

  // Update Wordlist Slider
  sldWordlist.Position := FBruteForcer.Position;

  Application.ProcessMessages;
end;

procedure TfrmProgressionProgression.BruteForcerFakeFound(Sender: TObject; AHttpCli: TKeywordBot; const strCombo: string; const iPIndex: integer);
var strURL, strProxy: string;

begin
  strURL := GetProtocol (frmSentry.cboSite.Text) + strCombo + '@' + GetMembersURL (frmSentry.cboSite.Text);

  if Assigned (FBruteForcer.MyList) then
   strProxy := FBruteForcer.MyList.Items[iPIndex].WriteToString
  else
   strProxy := '';

  lstFakes.Items.Add (strURL + ' Reason: ' + AHttpCli.Status + ' Proxy: ' + strProxy);
  ListBoxHorScrollBar (lstFakes);
end;

procedure TfrmProgressionProgression.BruteForcerHitFound(Sender: TObject; AHttpCli: TKeywordBot);
var strURL, strProxy: string;

begin
  // Use the ComboBox Text because BruteForcer.URL may be resolved to IP form
  strURL := GetProtocol (frmSentry.cboSite.Text) + AHttpCli.Username + ':' + AHttpCli.Password + '@' + GetMembersURL (frmSentry.cboSite.Text);

  if Assigned (FBruteForcer.MyList) then
   strProxy := FBruteForcer.MyList.Items[AHttpCli.Tag].WriteToString
  else
   strProxy := '';

  lstHits.Items.Add (strURL + ' Proxy: ' + strProxy);
  ListBoxHorScrollBar (lstHits);

  WriteHitToFiles (strURL, strProxy, AHttpCli);

  if blnWriteDebug then
   WriteHitToDebug (AHttpCli, strURL, strProxy);

  if blnPopupMemo then
   PopupMemo (AHttpCli, strURL, strProxy);
end;

procedure TfrmProgressionProgression.BruteForcerRedirectFound(Sender: TObject; AHttpCli: TKeywordBot);
var strProxy: string;

begin
  if Assigned (FBruteForcer.MyList) then
   strProxy := FBruteForcer.MyList.Items[AHttpCli.Tag].WriteToString
  else
   strProxy := '';

  lstRedirects.Items.Add (GetProtocol (AHttpCli.Location) + AHttpCli.Username + ':' + AHttpCli.Password + '@' + GetMembersURL (AHttpCli.Location) + ' Proxy: ' + strProxy);
  ListBoxHorScrollBar (lstRedirects);
end;

procedure TfrmProgressionProgression.BruteForcerUpdateListview(Sender: TObject; AHttpCli: TKeywordBot);
begin
  lstCProgression.Items[AHttpCli.Bot].Update;
  // Fixes Update Retry bug and gives more realtime statistics
  UpdateStatistics;
end;

procedure TfrmProgressionProgression.BruteForcerUpdateProgressList(Sender: TObject);
begin
  UpdateProgressList;
end;

procedure TfrmProgressionProgression.BruteForcerServerFound(Sender: TObject);
begin
  frmSentry.lblServer.Caption := ' ' + FBruteForcer.Server;
end;

procedure TfrmProgressionProgression.BruteForcerEngineComplete(Sender: TObject);
begin
  if Assigned (FSnapShot) then
   begin
    FSnapShot.SaveSettings;
    FreeAndNil (FSnapShot);
   end;

  FreeAndNil (FBruteForcer);

  // Close Files if assigned
  if blnAssignedDebugFile then
   CloseFile (FDebugFile);
  if blnAssignedLogFile then
   CloseFile (FLogFile);

  blnAssignedDebugFile := False;
  blnAssignedLogFile := False;

  EnableControls (True);
end;

procedure TfrmProgressionProgression.SnapShotSnapShotDoesNotExist(Sender: TObject);
begin
  LoadSettings;
end;

procedure TfrmProgressionProgression.SnapShotSnapShotExists(Sender: TObject);
begin
  if MessageDlg ('A Snap Shot exists for this site.' + #13#10#13#10 +
                 'Would you like to use it?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
   LoadSettings (FSnapShot.Domain)
  else
   LoadSettings;
end;

procedure TfrmProgressionProgression.SnapShotWordlistPositionExists(Sender: TObject);
begin
  case MessageDlg ('A Snap Shot exists for this site which contains Wordlist Information.' + #13#10#13#10 +
                   'Wordlist = ' + FSnapShot.Wordlist + #13#10 +
		   'Position = ' + IntToStr (FSnapShot.WordlistPosition) + #13#10#13#10 +
		   'Do you wish to use this Wordlist Information?' + #13#10#13#10 +
		   'Yes = Use Snap Shot with Wordlist Information' + #13#10 +
		   'No = Use Snap Shot without Wordlist Information' + #13#10 +
		   'Cancel = Do not use the Snap Shot', mtConfirmation, [mbYes, mbNo, mbCancel], 0) of
   mrYes: LoadSettings (FSnapShot.Domain);

   mrNo:
    begin
     FSnapShot.WordlistPosition := 0;
     LoadSettings (FSnapShot.Domain);
    end;

   mrCancel:
    begin
     FSnapShot.WordlistPosition := 0;
     LoadSettings;
    end;
  end;
end;

end.
