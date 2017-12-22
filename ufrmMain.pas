{
  _________              __                     ________
 /   _____/ ____   _____/  |________ ___.__.    \_____  \
 \_____  \_/ __ \ /    \   __\_  __ <   |  |     /  ____/
 /        \  ___/|   |  \  |  |  | \/\___  |    /       \
/_______  /\___  >___|  /__|  |__|   / ____|    \_______ \
        \/     \/     \/             \/                 \/

An Open Source HTTP Bruteforcer written by Sentinel in Delphi 7.

All units were written by Sentinel unless otherwise specified at the header
of the unit.

If you use a unit in your program from Sentry, please give its respective
authors credit.

If you compile Sentry, or modify it in any way, you must provide free access
to the binary and source to any third parties who may want it.

Free, Open Source 3rd Pary Components/Units Sentry uses:

FastStrings by Peter Morris - http://www.droopyeyesoftware.com
Jedi-VCL/JCL - http://www.delphi-jedi.com
ICS by François Piette - http://www.overbyte.be
PNG Components - http://www.nldelphi.com/cgi-bin/articles.exe/ShowArticle?ID=16318
uInternetExplorerUtils by =mæÐmå×= - http://madmax.deny.de

Pictures/Icons:

http://www.icon-king.com
http://www.carlitus.net

Thank you and enjoy the source code.

-- Sentinel

}

{ TO DO:

Hits discarded due to a matching failure key to appear in the fake tab of progression,
with the failure key identified listed next to them (with proxy also).
In case of a bad failure key you can see if you are missing legitimate hits, etc. Might not be practical enough to add though, optional setting perhaps?
}

unit ufrmMain;

// Compiler Directives

// Turn on Debug Information. This will use JCLDebug unit to provide useful
// information when an unhandled exception occurs.
// Project -> Insert JCL Debug Data must be checked to get useful data.
{.$DEFINE INCLUDE_DEBUG}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, JvExControls, JvComponent, JvOutlookBar, ComCtrls, IniFiles,
  XPMan, StdCtrls, Gauges, Buttons, ExtCtrls, uFrameSettingsGeneral,
  uFrameListsWordlist, uFrameListsProxylist, uFrameSettingsHTTPHeader,
  uFrameHistoryHistory, uFrameHistoryOptions, uFrameToolsProxyAnalyzer,
  uFrameSettingsProxySettings, uFavDialog, uFrameSettingsIntegration,
  uFrameToolsHTTPDebugger, uQuickLaunchMenu, uPngImageList, JvTrayIcon,
  uFrameProgressionProgression, uFrameSettingsFakeSettings,
  uFrameSettingsKeywords, uFrameAboutAboutSentry, uFrameListsBlacklist,
  uFrameToolsAutopilot;

const
  // Thread Message Constant
  TH_MESSAGE = WM_USER + 1;

  // Thread SubMessages
  TH_CHANGE_FRAME = 1;

  // Request Method Constants
  rgHEAD = 0;
  rgGET  = 1;
  rgPOST = 2;

  // ImageIndex Constants
  bmpIE = 4;
  bmpFIREFOX = 12;
  bmpOPERA = 13;

  // Frame Index Constants
  INDEX_SETTINGS_GENERAL        = 0;
  INDEX_SETTINGS_HTTPHEADER     = 1;
  INDEX_SETTINGS_INTEGRATION    = 2;
  INDEX_SETTINGS_PROXYSETTINGS  = 3;
  INDEX_SETTINGS_FAKESETTINGS   = 4;
  INDEX_SETTINGS_KEYWORDS       = 5;
  INDEX_LISTS_PROXYLIST         = 10;
  INDEX_LISTS_WORDLIST          = 11;
  INDEX_LISTS_BLACKLIST         = 12;
  INDEX_HISTORY_HISTORY         = 20;
  INDEX_HISTORY_OPTIONS         = 21;
  INDEX_TOOLS_AUTOPILOT         = 30;
  INDEX_TOOLS_HTTPDEBUGGER      = 31;
  INDEX_TOOLS_PROXYANALYZER     = 32;
  INDEX_PROGRESSION_PROGRESSION = 40;
  INDEX_ABOUT_ABOUTSENTRY       = 50;

type
  PChangeFrame = ^TChangeFrame;
  TChangeFrame = record
    iCurrentFrame,
    iDisplayFrame: integer;
  end;

  TfrmSentry = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    cmdOpenSite: TSpeedButton;
    prgStatus: TGauge;
    Label35: TLabel;
    cmdStart: TSpeedButton;
    cmdAbort: TSpeedButton;
    cboSite: TComboBox;
    lblServer: TPanel;
    StatusBar: TStatusBar;
    OutlookBar: TJvOutlookBar;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    ilMenus: TImageList;
    ilListViews: TImageList;
    cmdQuickLaunch: TSpeedButton;
    ilOutlookBar2: TPngImageList;
    pngOutlookBar: TPngImageCollection;
    Panel2: TPanel;
    TrayIcon: TJvTrayIcon;
    procedure OutlookBarButtonClick(Sender: TObject; Index: Integer);
    procedure FormPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cmdOpenSiteClick(Sender: TObject);
    procedure cmdQuickLaunchClick(Sender: TObject);
    procedure cmdStartClick(Sender: TObject);
    procedure cmdAbortClick(Sender: TObject);
    procedure OutlookBarPageChange(Sender: TObject; Index: Integer);
    procedure cboSiteEnter(Sender: TObject);
    procedure cboSiteExit(Sender: TObject);
  private
    FQuickLaunchMenu: TQuickLaunchMenu;
    iActiveFrame: integer;

    // Needed for frmToolsProxyAnalyzerOptions
    blnGetExternal: boolean;
    strIP: string;
    FEnterURL: string;

    procedure RepaintFrame(const iFrameNumber: integer);
    procedure FreeFrame(const iFrameNumber: integer);
    procedure SetFrame(var MyFrame: TFrame);
    procedure DisplayFrame(const iNewFrame, iCurrentFrame: integer);
    function  CheckForValidHeader: boolean;
    procedure AddSiteToComboBox;
    procedure FixURL;
    procedure LoadSettings;
    procedure SaveSettings;
    procedure BuildHeader;
{$IFDEF INCLUDE_DEBUG}
    procedure ApplicationException(Sender: TObject; E: Exception);
{$ENDIF}

    procedure ThreadMessage(var Message: TMessage); message TH_MESSAGE;
  public
    frmSettingsGeneral: TfrmSettingsGeneral;
    frmSettingsHTTPHeader: TfrmSettingsHTTPHeader;
    frmSettingsIntegration: TfrmSettingsIntegration;
    frmSettingsProxySettings: TfrmSettingsProxySettings;
    frmSettingsFakeSettings: TfrmSettingsFakeSettings;
    frmSettingsKeywords: TfrmSettingsKeywords;
    frmListsProxylist: TfrmListsProxylist;
    frmListsWordlist: TfrmListsWordlist;
    frmListsBlacklist: TfrmListsBlacklist;
    frmHistoryHistory: TfrmHistoryHistory;
    frmHistoryOptions: TfrmHistoryOptions;
    frmToolsAutopilot: TfrmToolsAutopilot;
    frmToolsHTTPDebugger: TfrmToolsHTTPDebugger;
    frmToolsProxyAnalyzer: TfrmToolsProxyAnalyzer;
    frmProgressionProgression: TfrmProgressionProgression;
    frmAboutAboutSentry: TfrmAboutAboutSentry;

    property GetExternal: boolean read blnGetExternal;
    property IP: string read strIP write strIP;
  end;

var
  frmSentry: TfrmSentry;
  // Global variable which contains path that EXE is ran from
  strLocPath: string;

implementation

{$R *.dfm}

uses uFunctions, IcsUrl, FastStrings
     {$IFDEF INCLUDE_DEBUG}, JclDebug{$ENDIF};

procedure TfrmSentry.RepaintFrame(const iFrameNumber: integer);
begin
  case iFrameNumber of
   INDEX_SETTINGS_GENERAL:        frmSettingsGeneral.Update;
   INDEX_SETTINGS_HTTPHEADER:     frmSettingsHTTPHeader.Update;
   INDEX_SETTINGS_INTEGRATION:    frmSettingsIntegration.Update;
   INDEX_SETTINGS_PROXYSETTINGS:  frmSettingsProxySettings.Update;
   INDEX_SETTINGS_FAKESETTINGS:   frmSettingsFakeSettings.Update;
   INDEX_SETTINGS_KEYWORDS:       frmSettingsKeywords.Update;
   INDEX_LISTS_PROXYLIST:         frmListsProxylist.Update;
   INDEX_LISTS_WORDLIST:          frmListsWordlist.Update;
   INDEX_LISTS_BLACKLIST:         frmListsBlacklist.Update;
   INDEX_HISTORY_HISTORY:         frmHistoryHistory.Update;
   INDEX_HISTORY_OPTIONS:         frmHistoryOptions.Update;
   INDEX_TOOLS_AUTOPILOT:         frmToolsAutopilot.Update;
   INDEX_TOOLS_HTTPDEBUGGER:      frmToolsHTTPDebugger.Update;
   INDEX_TOOLS_PROXYANALYZER:     frmToolsProxyAnalyzer.Update;
   INDEX_PROGRESSION_PROGRESSION: frmProgressionProgression.Update;
   INDEX_ABOUT_ABOUTSENTRY:       frmAboutAboutSentry.Update;
  end;
end;

procedure TfrmSentry.FreeFrame(const iFrameNumber: integer);
begin
  // Avoid repainting a nil'd form on program close
  if iFrameNumber = iActiveFrame then
   iActiveFrame := -1;

  case iFrameNumber of
   INDEX_SETTINGS_GENERAL:
    begin
     frmSettingsGeneral.SaveVariables;
     FreeAndNil (frmSettingsGeneral);
    end;

   INDEX_SETTINGS_HTTPHEADER:
    begin
     frmSettingsHTTPHeader.SaveVariables;
     FreeAndNil (frmSettingsHTTPHeader);
    end;

   INDEX_SETTINGS_INTEGRATION:
    begin
     frmSettingsIntegration.SaveVariables;
     FreeAndNil (frmSettingsIntegration);
    end;

   INDEX_SETTINGS_PROXYSETTINGS:
    begin
     frmSettingsProxySettings.SaveVariables;
     FreeAndNil (frmSettingsProxySettings);
    end;

   INDEX_SETTINGS_FAKESETTINGS:
    begin
     frmSettingsFakeSettings.SaveVariables;
     FreeAndNil (frmSettingsFakeSettings);
    end;

   INDEX_SETTINGS_KEYWORDS:
    begin
     frmSettingsKeywords.SaveVariables;
     FreeAndNil (frmSettingsKeywords);
    end;

   INDEX_LISTS_PROXYLIST:
    begin
     frmListsProxylist.SaveVariables;
     FreeAndNil (frmListsProxylist);
    end;

   INDEX_LISTS_WORDLIST:
    begin
     frmListsWordlist.SaveVariables;
     FreeAndNil (frmListsWordlist);
    end;

   INDEX_LISTS_BLACKLIST:
    begin
     frmListsBlacklist.SaveVariables;
     FreeAndNil (frmListsBlacklist);
    end;

   INDEX_HISTORY_HISTORY:
    begin
     // History test is running, don't free the form
     if frmHistoryHistory.cmdStart.Enabled = False then
      Exit;

     frmHistoryHistory.SaveVariables;
     FreeAndNil (frmHistoryHistory);
    end;

   INDEX_HISTORY_OPTIONS:
    begin
     frmHistoryOptions.SaveVariables;
     FreeAndNil (frmHistoryOptions);
    end;

   INDEX_TOOLS_AUTOPILOT:
    begin
//     frmToolsAutopilot.SaveVariables;
     FreeAndNil (frmToolsAutopilot);
    end;

   INDEX_TOOLS_HTTPDEBUGGER:
    begin
     frmToolsHTTPDebugger.SaveVariables;
     FreeAndNil (frmToolsHTTPDebugger);
    end;

   INDEX_TOOLS_PROXYANALYZER:
    begin
     // Proxy test is running, don't free the form
     if frmToolsProxyAnalyzer.cmdStart.Enabled = False then
      Exit;

     frmToolsProxyAnalyzer.SaveVariables;
     FreeAndNil (frmToolsProxyAnalyzer);
    end;

   INDEX_PROGRESSION_PROGRESSION:
    begin
     // Bruteforcer is running, don't free the form
     if cmdStart.Enabled = False then
      Exit;

     frmProgressionProgression.SaveVariables;
     FreeAndNil (frmProgressionProgression);
    end;

   INDEX_ABOUT_ABOUTSENTRY: FreeAndNil (frmAboutAboutSentry);
  end;
end;

procedure TfrmSentry.ThreadMessage(var Message: TMessage);
var ChangeFrameRecord: PChangeFrame;

begin
  // WParam holds our Action
  // LParam holds a Pointer to our Data we are sending to the action casted as an integer
  //
  // How To Post a Message
  // PostMessage (frmSentry.Handle, TH_MESSAGE, TH_ACTION, DATA_ARGUMENT);
  case Message.WParam of
   TH_CHANGE_FRAME:
    begin
     ChangeFrameRecord := PChangeFrame (Message.LParam);
     OutlookBar.ActivePageIndex := ChangeFrameRecord^.iDisplayFrame div 10;
     DisplayFrame (ChangeFrameRecord^.iDisplayFrame, ChangeFrameRecord^.iCurrentFrame);

     Dispose (ChangeFrameRecord);
    end;
  end;
end;

procedure TfrmSentry.SetFrame(var MyFrame: TFrame);
begin
  MyFrame.Parent := Panel2;
  MyFrame.Align := alClient;
end;

procedure TfrmSentry.DisplayFrame(const iNewFrame, iCurrentFrame: integer);
begin
  if iNewFrame = iCurrentFrame then
   Exit;

  FreeFrame (iCurrentFrame);

  case iNewFrame of
   INDEX_SETTINGS_GENERAL:
    begin
     frmSettingsGeneral := TfrmSettingsGeneral.Create (nil);
     SetFrame (TFrame (frmSettingsGeneral));
     frmSettingsGeneral.LoadVariables;

     frmSettingsGeneral.Invalidate;
    end;

   INDEX_SETTINGS_HTTPHEADER:
    begin
     frmSettingsHTTPHeader := TfrmSettingsHTTPHeader.Create (nil);
     SetFrame (TFrame (frmSettingsHTTPHeader));
     frmSettingsHTTPHeader.LoadVariables;

     frmSettingsHTTPHeader.Invalidate;
    end;

   INDEX_SETTINGS_INTEGRATION:
    begin
     frmSettingsIntegration := TfrmSettingsIntegration.Create (nil);
     SetFrame (TFrame (frmSettingsIntegration));
     frmSettingsIntegration.LoadVariables;

     frmSettingsIntegration.Invalidate;
    end;

   INDEX_SETTINGS_PROXYSETTINGS:
    begin
     frmSettingsProxySettings := TfrmSettingsProxySettings.Create (nil);
     SetFrame (TFrame (frmSettingsProxySettings));
     frmSettingsProxySettings.LoadVariables;

     frmSettingsProxySettings.Invalidate;
    end;

   INDEX_SETTINGS_FAKESETTINGS:
    begin
     frmSettingsFakeSettings := TfrmSettingsFakeSettings.Create (nil);
     SetFrame (TFrame (frmSettingsFakeSettings));
     frmSettingsFakeSettings.LoadVariables;

     frmSettingsFakeSettings.Invalidate;
    end;

   INDEX_SETTINGS_KEYWORDS:
    begin
     frmSettingsKeywords := TfrmSettingsKeywords.Create (nil);
     SetFrame (TFrame (frmSettingsKeywords));
     frmSettingsKeywords.LoadVariables;

     frmSettingsKeywords.Invalidate;
    end;

   INDEX_LISTS_PROXYLIST:
    begin
     frmListsProxylist := TfrmListsProxylist.Create (nil);
     SetFrame (TFrame (frmListsProxylist));
     frmListsProxylist.LoadVariables;

     frmListsProxylist.Invalidate;
    end;

   INDEX_LISTS_WORDLIST:
    begin
     frmListsWordlist := TfrmListsWordlist.Create (nil);
     SetFrame (TFrame (frmListsWordlist));
     frmListsWordlist.LoadVariables;

     frmListsWordlist.Invalidate;
    end;

   INDEX_LISTS_BLACKLIST:
    begin
     frmListsBlacklist := TfrmListsBlacklist.Create (nil);
     SetFrame (TFrame (frmListsBlacklist));
     frmListsBlacklist.LoadVariables;

     frmListsBlacklist.Invalidate;
    end;

   INDEX_HISTORY_HISTORY:
    begin
     if Assigned (frmHistoryHistory) = False then
      begin
       frmHistoryHistory := TfrmHistoryHistory.Create (nil);
       SetFrame (TFrame (frmHistoryHistory));

       // Pass pointer of the history list to the history frame
       if Assigned (frmProgressionProgression) then
        frmHistoryHistory.HistoryList := frmProgressionProgression.HistoryList;

       frmHistoryHistory.LoadVariables;

       frmHistoryHistory.Invalidate;
      end;
    end;

   INDEX_HISTORY_OPTIONS:
    begin
     frmHistoryOptions := TfrmHistoryOptions.Create (nil);
     SetFrame (TFrame (frmHistoryOptions));
     frmHistoryOptions.LoadVariables;

     frmHistoryOptions.Invalidate;
    end;

   INDEX_TOOLS_AUTOPILOT:
    begin
     frmToolsAutopilot := TfrmToolsAutopilot.Create (nil);
     SetFrame (TFrame (frmToolsAutopilot));
//     frmToolsAutopilot.LoadVariables;

     frmToolsAutopilot.Invalidate;
    end;

   INDEX_TOOLS_HTTPDEBUGGER:
    begin
     frmToolsHTTPDebugger := TfrmToolsHTTPDebugger.Create (nil);
     SetFrame (TFrame (frmToolsHTTPDebugger));
     frmToolsHTTPDebugger.LoadVariables;

     frmToolsHTTPDebugger.Invalidate;
    end;

   INDEX_TOOLS_PROXYANALYZER:
    begin
     if Assigned (frmToolsProxyAnalyzer) = False then
      begin
       frmToolsProxyAnalyzer := TfrmToolsProxyAnalyzer.Create (nil);
       SetFrame (TFrame (frmToolsProxyAnalyzer));
       frmToolsProxyAnalyzer.LoadVariables;

       frmToolsProxyAnalyzer.Invalidate;
      end;
    end;

   INDEX_PROGRESSION_PROGRESSION:
    begin
     if Assigned (frmProgressionProgression) = False then
      begin
       frmProgressionProgression := TfrmProgressionProgression.Create (nil);
       SetFrame (TFrame (frmProgressionProgression));
       frmProgressionProgression.LoadVariables;

       frmProgressionProgression.Invalidate;
      end;
    end;

   INDEX_ABOUT_ABOUTSENTRY:
    begin
     frmAboutAboutSentry := TfrmAboutAboutSentry.Create (nil);
     SetFrame (TFrame (frmAboutAboutSentry));

     frmAboutAboutSentry.Invalidate;
    end;
  end;

  iActiveFrame := iNewFrame;
  SetProcessWorkingSetSize (GetCurrentProcess, $FFFFFFFF, $FFFFFFFF);
end;

procedure TfrmSentry.OutlookBarButtonClick(Sender: TObject; Index: Integer);
begin
  // The index is stored as a 2 digit number
  // The leftmost digit is the OutlookBar Active Page
  // The rightmost digit is the Page Index
  Index := OutlookBar.ActivePageIndex * 10 + Index;
  DisplayFrame (Index, iActiveFrame);
end;

procedure TfrmSentry.FormPaint(Sender: TObject);
begin
  RepaintFrame (iActiveFrame);
end;

procedure TfrmSentry.FormCreate(Sender: TObject);
begin
{$IFDEF INCLUDE_DEBUG}
  Application.OnException := ApplicationException;
{$ENDIF}
  LoadSettings;
  OutlookBar.ActivePageIndex := 0;
  DisplayFrame (iActiveFrame, -1);
end;

procedure TfrmSentry.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeFrame (iActiveFrame);
  SaveSettings;
end;

procedure TfrmSentry.LoadSettings;
var IniFile: TIniFile;
    strWordlist: string;

begin
  // Initialize Global with File Path to EXE File
  strLocPath := ExtractFilePath (Application.ExeName);

  // 10 seconds for Hints
  Application.HintHidePause := 10000;

  // Freed on Shutdown
  FQuickLaunchMenu := TQuickLaunchMenu.Create (Self);
  FQuickLaunchMenu.Load;
  FQuickLaunchMenu.PopulateMenu;

  if FileExists (strLocPath + 'Sites.ini') then
   cboSite.Items.LoadFromFile (strLocPath + 'Sites.ini');

  IniFile := TIniFile.Create (strLocPath + 'Settings.ini');
  try
   with IniFile do
    begin
     cboSite.Text := ReadString ('Global', 'Site', '');
     blnGetExternal := ReadBool ('Global', 'GetExternal', False);
     TrayIcon.Active := ReadBool ('Global', 'MinimizeTray', False);

     strWordlist := ReadString ('Lists', 'Wordlist', '');
     if FileExists (strWordlist) then
      StatusBar.Panels[1].Text := 'Wordlist: ' + ExtractFileName (strWordlist);
    end;
  finally
   IniFile.Free;
  end;
end;

procedure TfrmSentry.SaveSettings;
var IniFile: TIniFile;

begin
  cboSite.Items.SaveToFile (strLocPath + 'Sites.ini');

  IniFile := TIniFile.Create (strLocPath + 'Settings.ini');
  try
   IniFile.WriteString ('Global', 'Site', cboSite.Text);
  finally
   IniFile.Free;
  end;
end;

procedure TfrmSentry.cmdOpenSiteClick(Sender: TObject);
var I: integer;

begin
  if cboSite.Text <> '' then
   begin
    I := IniFileReadInteger (strLocPath + 'Settings.ini', 'Integration', 'BrowserIndex', bmpIE);
    LaunchSite (GetProtocol (cboSite.Text) + GetBaseURL (cboSite.Text), I);
   end;
end;

procedure TfrmSentry.cmdQuickLaunchClick(Sender: TObject);
var MyPoint : TPoint;

begin
  GetCursorPos (MyPoint);
  FQuickLaunchMenu.Menu.Popup (MyPoint.X, MyPoint.Y);
end;

function TfrmSentry.CheckForValidHeader: boolean;
var strHeader: string;
    IniFile: TIniFile;

begin
  Result := True;

  IniFile := TIniFile.Create (strLocPath + 'Settings.ini');
  try
   strHeader := IniFile.ReadString ('Settings', 'HTTPHeader', '');

   if FastPosNoCase (strHeader, frmSentry.cboSite.Text, Length (strHeader), Length (frmSentry.cboSite.Text), 1) = 0 then
    begin
     if IniFile.ReadInteger ('Settings', 'RequestMethod', 1) in [rgHEAD, rgGET] then
      begin
       if IniFile.ReadBool ('Settings', 'AutoBuild', True) then
        BuildHeader
       else
        begin
         if MessageDlg ('Could not detect the current Site in your HTTP Header.' + #13#10#13#10 +
                        'Would you like to auto-build the Header or cancel?', mtWarning, [mbOK, mbCancel], 0) = mrOK then

          BuildHeader
         else
          begin
           // Display HTTP Header Frame
           DisplayFrame (1, iActiveFrame);
           Result := False;
          end;
        end;
      end;
    end;
  finally
   IniFile.Free;
  end;
end;

procedure TfrmSentry.AddSiteToComboBox;
var I, J: integer;
    strURL1, strURL2: string;

begin
  strURL1 := GetMembersURL (cboSite.Text);
  J := Length (strURL1);

  for I := 0 to cboSite.Items.Count - 1 do
   begin
    strURL2 := GetMembersURL (cboSite.Items.Strings[I]);

    if FastPosNoCase (strURL1, strURL2, J, Length (strURL2), 1) <> 0 then
     Exit;
   end;

  cboSite.Items.Add (cboSite.Text);
end;

procedure TfrmSentry.FixURL;
var strPath: string;

begin
  strPath := GetPath (frmSentry.cboSite.Text);
  if (strPath <> '') and (FastCharPos (strPath, '.', 1) = 0) and (FastCharPos (strPath, '?', 1) = 0) then
   begin
    // Check to see if a / is at the end
    if strPath[Length (strPath)] <> '/' then
     frmSentry.cboSite.Text := frmSentry.cboSite.Text + '/';
   end;
end;

procedure TfrmSentry.cmdStartClick(Sender: TObject);
begin
  // Save HTTP Header information if it is the current frame
  if iActiveFrame = 1 then
   frmSettingsHTTPHeader.SaveVariables;

  if frmSentry.cboSite.Text = '' then
   begin
    MessageDlg ('No Site Entered.', mtWarning, [mbOK], 0);
    Exit;
   end
  else
   begin
    FixURL;
    AddSiteToComboBox;
   end;

  if CheckForValidHeader then
   begin
    // Display Progression Frame
    DisplayFrame (INDEX_PROGRESSION_PROGRESSION, iActiveFrame);

    frmProgressionProgression.StartBruteForcer;
   end;
end;

procedure TfrmSentry.cmdAbortClick(Sender: TObject);
begin
  frmProgressionProgression.AbortBruteForcer;
end;

// Builds a Header based on the INI File options and saves it to the INI File.
// Pulled out of uFrameSettingsHTTPHeader because we need to call this function
// if the user changes the site in the combobox we need to rebuild the Header.
procedure TfrmSentry.BuildHeader;
var FProto, FUser, FPass, FHost, FPort, FPath, FMethod, FSite: string;
    lstHeader: TStrings;
    IniFile: TIniFile;
    I: integer;

begin
  FSite := frmSentry.cboSite.Text;

  if FSite = '' then
   Exit;

  IniFile := TIniFile.Create (strLocPath + 'Settings.ini');
  lstHeader := TStringList.Create;
  try
   ParseURL (FSite, FProto, FUser, FPass, FHost, FPort, FPath);
   I := IniFile.ReadInteger ('Settings', 'RequestMethod', rgGET);
   case I of
    rgHEAD: FMethod := 'HEAD';
    rgGET:  FMethod := 'GET';
    rgPOST: FMethod := 'POST';
   end;

   if FMethod = 'POST' then
    lstHeader.Add (FMethod + ' ' + FProto + '://' + FHost + FPath + ' HTTP/1.1')
   else
    lstHeader.Add (FMethod + ' ' + FProto + '://' + FHost + FPath + ' HTTP/1.0');
   lstHeader.Add ('Accept: */*');

   I := IniFile.ReadInteger ('Settings', 'Referer', 0);
   case I of
    1: lstHeader.Add ('Referer: ' + FProto + '://' + FHost);
    2: lstHeader.Add ('Referer: ' + FSite);
   end;
   lstHeader.Add ('User-Agent: <USER AGENT>');
   lstHeader.Add ('Host: ' + FHost);
   lstHeader.Add ('Pragma: no-cache');

   if IniFile.ReadBool ('Settings', 'BasicAuth', True) then
    lstHeader.Add ('Authorization: Basic <COMBO>');
   if FMethod = 'POST' then
    begin
     lstHeader.Add ('Content-Type: application/x-www-form-urlencoded');
     lstHeader.Add ('Connection: keep-alive');
     lstHeader.Add ('Content-Length: <CONTENT LENGTH>');
    end;

   IniFile.WriteString ('Settings', 'HTTPHeader', FastReplace (lstHeader.Text, #13#10, '|'));
  finally
   IniFile.Free;
   lstHeader.Free;
  end;
end;

procedure TfrmSentry.OutlookBarPageChange(Sender: TObject; Index: Integer);
begin
  if Index in [4, 5] then
   DisplayFrame (Index * 10, iActiveFrame);
end;

procedure TfrmSentry.cboSiteEnter(Sender: TObject);
begin
  FEnterURL := cboSite.Text;
end;

procedure TfrmSentry.cboSiteExit(Sender: TObject);
var strFile: string;

begin
  // A New site has been entered, reset some stuff
  if FEnterURL <> cboSite.Text then
   begin
    strFile := strLocPath + 'Settings.ini';

    // Reset Wordlist Position
    IniFileWriteInteger (strFile, 'Lists', 'StartSearch', 1);
    if Assigned (frmProgressionProgression) then
     frmProgressionProgression.ResetWordlistPosition1Click (nil);

    // Reset Form Action which will Cause POST Wizard to reset
    IniFileWriteString (strFile, 'Form', 'Action', '');
   end;
end;

{$IFDEF INCLUDE_DEBUG}
procedure TfrmSentry.ApplicationException(Sender: TObject; E: Exception);
var lstList: TStringList;

begin
  lstList := TStringList.Create;
  try
   lstList.Add (DateTimeToStr (Now));
   // Log unhandled exception stack info
   JclLastExceptStackListToStrings (lstList, False, True, True, False);
   lstList.SaveToFile (strLocPath + 'Exception.txt');
  finally
   lstList.Free;
  end;

  Application.ShowException (E);
  Application.Terminate;
end;
{$ENDIF}

{$IFDEF INCLUDE_DEBUG}
initialization
  // Enable raw mode (default mode uses stack frames which aren't always generated by the compiler)
  Include (JclStackTrackingOptions, stRawMode);
  // Disable stack tracking in dynamically loaded modules (it makes stack tracking code a bit faster)
  Include (JclStackTrackingOptions, stStaticModuleList);

  // Initialize Exception tracking
  JclStartExceptionTracking;
finalization
  // Uninitialize Exception tracking
  JclStopExceptionTracking;
{$ENDIF}
end.
