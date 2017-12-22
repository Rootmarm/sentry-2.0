unit uFrameToolsProxyAnalyzer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, Menus, ImgList, ExtCtrls, ComCtrls, Buttons, StdCtrls,
  ufrmToolsProxyAnalyzerOptions, uAnalyzerEngine, uAnalyzerListView,
  uAnalyzerBot;

type
  TFloatDockForm = class(TCustomDockForm);

  TfrmToolsProxyAnalyzer = class(TFrame)
    mnulstProxy: TPopupMenu;
    DeleteSelectedProxies1: TMenuItem;
    N2: TMenuItem;
    mnuProxy: TMenuItem;
    N1: TMenuItem;
    LoadAProxyList1: TMenuItem;
    SaveProxyList1: TMenuItem;
    Panel3: TPanel;
    Label1: TLabel;
    cmdOpen: TSpeedButton;
    cmdSave: TSpeedButton;
    cmdPaste: TSpeedButton;
    lstCProxy: TListView;
    Panel14: TPanel;
    lblBotCount: TLabel;
    cmdStart: TSpeedButton;
    cmdAbort: TSpeedButton;
    sldBot: TTrackBar;
    cmdRandomize: TSpeedButton;
    cmdUpdateMyList: TSpeedButton;
    ClearList1: TMenuItem;
    N3: TMenuItem;
    CopySelectedProxiesToClipboard1: TMenuItem;
    PasteProxiesFromClipboard1: TMenuItem;
    cmdClean: TSpeedButton;
    mnucmdClean: TPopupMenu;
    DeleteBadProxies1: TMenuItem;
    DeleteTimeouts1: TMenuItem;
    DeleteGateways1: TMenuItem;
    N4: TMenuItem;
    RemoveDuplicates1: TMenuItem;
    cmdOptions: TSpeedButton;
    Panel1: TPanel;
    Label2: TLabel;
    Panel4: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Shape1: TShape;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    lblGood: TLabel;
    lblBad: TLabel;
    lblCount: TLabel;
    Image4: TImage;
    Label6: TLabel;
    lblUnknown: TLabel;
    Image6: TImage;
    Label10: TLabel;
    lblTimeout: TLabel;
    Image5: TImage;
    Label9: TLabel;
    lblGateway: TLabel;
    cmdRetry: TSpeedButton;
    mnucmdRetry: TPopupMenu;
    RetryBads: TMenuItem;
    RetryTimeouts: TMenuItem;
    RetryUnknowns: TMenuItem;
    N5: TMenuItem;
    SendSelectedProxiesToMyList1: TMenuItem;
    SendAllProxiesToMyList1: TMenuItem;
    SendToBlacklist1: TMenuItem;
    SendToHTTPDebugger1: TMenuItem;
    procedure lstCProxyColumnClick(Sender: TObject; Column: TListColumn);
    procedure lstCProxyData(Sender: TObject; Item: TListItem);
    procedure lstCProxyKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure sldBotChange(Sender: TObject);
    procedure cmdOpenClick(Sender: TObject);
    procedure cmdSaveClick(Sender: TObject);
    procedure cmdCleanClick(Sender: TObject);
    procedure cmdPasteClick(Sender: TObject);
    procedure cmdRandomizeClick(Sender: TObject);
    procedure cmdUpdateMyListClick(Sender: TObject);
    procedure DeleteBadProxies1Click(Sender: TObject);
    procedure DeleteTimeouts1Click(Sender: TObject);
    procedure DeleteGateways1Click(Sender: TObject);
    procedure RemoveDuplicates1Click(Sender: TObject);
    procedure DeleteSelectedProxies1Click(Sender: TObject);
    procedure ClearList1Click(Sender: TObject);
    procedure mnuProxyClick(Sender: TObject);
    procedure CopySelectedProxiesToClipboard1Click(Sender: TObject);
    procedure PasteProxiesFromClipboard1Click(Sender: TObject);
    procedure LoadAProxyList1Click(Sender: TObject);
    procedure SaveProxyList1Click(Sender: TObject);
    procedure cmdOptionsClick(Sender: TObject);
    procedure cmdRetryClick(Sender: TObject);
    procedure RetryBadsClick(Sender: TObject);
    procedure EnableControls(Active: boolean);
    procedure cmdStartClick(Sender: TObject);
    procedure AnalyzerEngineBotLaunched(Sender: TObject; AHttpCli: TAnalyzerBot);
    procedure AnalyzerEngineBotComplete(Sender: TObject; AHttpCli: TAnalyzerBot);
    procedure AnalyzerEngineEngineComplete(Sender: TObject);
    procedure cmdAbortClick(Sender: TObject);
    procedure SendSelectedProxiesToMyList1Click(Sender: TObject);
    procedure SendToBlacklist1Click(Sender: TObject);
    procedure SendToHTTPDebugger1Click(Sender: TObject);
  private
    blnSort: boolean;
    iColumn: integer;
    lstProxy: TAnalyzerList;
    frmToolsProxyAnalyzerOptions: TfrmToolsProxyAnalyzerOptions;
    AnalyzerEngine: TAnalyzerEngine;

    // ------ Option Variables ------

    blnInternal: boolean;
    blnInternalAuth: boolean;
    strProxyJudge: string;
    strSpecificURL: string;
    strTimeout: string;
    blnNoLevels: boolean;
    blnExternal: boolean;
    blnSpecific: boolean;
    blnSpecificHead: boolean;
    strSpecificResponse: string;
    blnSpecificKeyPhrase: boolean;
    strSpecificKeyPhrase: string;
    blnHTTPS: boolean;
    strHTTPS: string;
    blnHostToIP: boolean;
    blnFloatDialog: boolean;
    blnSavePosition: boolean;
    iDockLeft: integer;
    iDockTop: integer;

    // ------ End Option Variables ------

    procedure ReadINISettings;
    procedure WriteINISettings;
    procedure UpdateStatistics;
    procedure UpdateProxyList;
    procedure SendToMyList(blnSelected: boolean = False);
  public
    procedure LoadVariables;
    procedure SaveVariables;
  end;

implementation

uses ufrmMain, uMyListListView, Clipbrd, IniFiles, HttpProt, uFunctions;

{$R *.dfm}

procedure TfrmToolsProxyAnalyzer.ReadINISettings;
var IniFile: TIniFile;
    I: integer;
    strSuffix: string;

begin
  IniFile := TIniFile.Create (strLocPath + 'Settings.ini');
  try
   with IniFile do
    begin
     sldBot.Position := ReadInteger ('Analyzer', 'Bots', 1);

     blnInternal := ReadBool ('Analyzer', 'InternalJudge', False);
     blnInternalAuth := ReadBool ('Analyzer', 'Auth', False);

     strProxyJudge := ReadString ('Analyzer', 'ProxyJudge', '');
     strSpecificURL := ReadString ('Analyzer', 'SpecificURL', '');
     blnExternal := ReadBool ('Analyzer', 'ExternalJudge', False);
     blnSpecific := ReadBool ('Analyzer', 'SpecificSite', False);
     blnSpecificHead := ReadBool ('Analyzer', 'SpecificHead', True);
     strSpecificResponse := ReadString ('Analyzer', 'SpecificResponse', '401');
     blnSpecificKeyPhrase := ReadBool ('Analyzer', 'SpecificPhrase', False);
     strSpecificKeyPhrase := ReadString ('Analyzer', 'SpecificKey', '');
     strTimeout := ReadString ('Analyzer', 'Timeout', '15');
     blnNoLevels := ReadBool ('Analyzer', 'NoLevels', False);

     blnHTTPS := ReadBool ('Analyzer', 'HTTPS', False);
     strHTTPS := ReadString ('Analyzer', 'HTTPSSite', 'http://www.google.com:80');
     blnHostToIP := ReadBool ('Analyzer', 'HostToIP', False);
     blnFloatDialog := ReadBool ('Analyzer', 'FloatDialog', True);
     blnSavePosition := ReadBool ('Analyzer', 'SavePosition', True);

     if blnSavePosition then
      begin
       iDockLeft := ReadInteger ('Analyzer', 'DockLeft', 0);
       iDockTop := ReadInteger ('Analyzer', 'DockTop', 0);
      end;

     I := ReadInteger ('Integration', 'BrowserIndex', bmpIE);
     case I of
      bmpIE: strSuffix := 'IE';
      bmpFIREFOX: strSuffix := 'Firefox';
      bmpOPERA: strSuffix := 'Opera';
     end;
     mnuProxy.Caption := 'Use Proxy In ' + strSuffix;
     mnuProxy.ImageIndex := I;
    end;
  finally
   IniFile.Free;
  end;
end;

procedure TfrmToolsProxyAnalyzer.WriteINISettings;
var IniFile: TIniFile;

begin
  IniFile := TIniFile.Create (strLocPath + 'Settings.ini');
  try
   with IniFile, TFloatDockForm (Panel1.Parent) do
    begin
     WriteInteger ('Analyzer', 'DockLeft', Left);
     WriteInteger ('Analyzer', 'DockTop', Top);
     WriteInteger ('Analyzer', 'Bots', sldBot.Position);
    end;
  finally
   IniFile.Free;
  end;
end;

procedure TfrmToolsProxyAnalyzer.LoadVariables;
var Rect: TRect;

begin
  iColumn := -1;
  cmdClean.Glyph.TransparentColor := clFuchsia;
  lstCProxy.DoubleBuffered := True;

  if Assigned (lstProxy) = False then
   begin
    lstProxy := TAnalyzerList.Create;
    if FileExists (strLocPath + 'Proxy.ini') then
     lstProxy.LoadFromFile (strLocPath + 'Proxy.ini', sdSaved, False);

    UpdateProxyList;
   end;

  ReadINISettings;

  if blnFloatDialog then
   begin
    if iDockLeft = 0 then
     iDockLeft := Screen.Width - Screen.Width div 4;
    if iDockTop = 0 then
     iDockTop := Screen.Height - Screen.Height div 3;

    Rect.Left := iDockLeft;
    Rect.Top := iDockTop;
    Rect.Right := Rect.Left + Panel1.Width;
    Rect.Bottom := Rect.Top + 202;

    Panel1.FloatingDockSiteClass := TFloatDockForm;
    Panel1.ManualFloat (Rect);

    TFloatDockForm (Panel1.Parent).BorderIcons := [];
   end;
end;

procedure TfrmToolsProxyAnalyzer.SaveVariables;
begin
  lstCProxy.OnData := nil;

  WriteINISettings;
  if blnFloatDialog then
   TFloatDockForm (Panel1.Parent).Free;

  lstProxy.SaveToFile (strLocPath + 'Proxy.ini', sdSaved);
  FreeAndNil (lstProxy);
end;

procedure TfrmToolsProxyAnalyzer.UpdateStatistics;
begin
   lblGood.Caption := IntToStr (lstProxy.Good);
   lblBad.Caption := IntToStr (lstProxy.Bad);
   lblGateway.Caption := IntToStr (lstProxy.Gateway);
   lblUnknown.Caption := IntToStr (lstProxy.Unknown);
   lblTimeout.Caption := IntToStr (lstProxy.Timeout);
end;

procedure TfrmToolsProxyAnalyzer.UpdateProxyList;
begin
  lstCProxy.Items.BeginUpdate;
  try
   lstCProxy.Items.Count := lstProxy.Count;
  finally
   lstCProxy.Items.EndUpdate;
   UpdateStatistics;
   lblCount.Caption := IntToStr (lstProxy.Count);
   frmSentry.StatusBar.Panels[0].Text := 'Displaying ' + lblCount.Caption + ' Proxies in Analyzer';
  end;
end;

procedure TfrmToolsProxyAnalyzer.lstCProxyColumnClick(Sender: TObject; Column: TListColumn);
begin
  if Column.Index = iColumn then
   blnSort := not blnSort
  else
   begin
    iColumn := Column.Index;
    blnSort := False;
   end;
  with lstProxy do
   begin
    case Column.Index of
     0: SortProxyAlpha (blnSort);
     1: SortPortAlpha (blnSort);
     2: SortPingAlpha (blnSort);
     3: SortStatusAlpha (blnSort);
     4: SortGatewayAlpha (blnSort);
     5: SortAnonymousAlpha (blnSort);
     6: SortLevelAlpha (blnSort);
     7: SortHTTPAlpha (blnSort);
     8: SortHTTPSAlpha (blnSort);
     9: SortSpeedAlpha (blnSort);
    end;
   end;
  UpdateProxyList;
end;

procedure TfrmToolsProxyAnalyzer.lstCProxyData(Sender: TObject; Item: TListItem);
begin
  if Item.Index >= lstProxy.Count then
   Exit;

  with lstProxy[Item.Index] do
   begin
    Item.Caption := Proxy;
    Item.SubItems.Add (Port);
    Item.SubItems.Add (Ping);
    Item.SubItems.Add (Status);
    Item.SubItems.Add (Gateway);
    Item.SubItems.Add (Anonymous);
    Item.SubItems.Add (Level);
    Item.SubItems.Add (HTTP);
    Item.SubItems.Add (HTTPS);
    Item.SubItems.Add (Speed);
    Item.ImageIndex := ImageIndex;
   end;
end;

procedure TfrmToolsProxyAnalyzer.lstCProxyKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
   46: DeleteSelectedProxies1Click (nil);
   65: lstCProxy.SelectAll;
  end;
end;

procedure TfrmToolsProxyAnalyzer.sldBotChange(Sender: TObject);
begin
  lblBotCount.Caption := IntToStr (sldBot.Position);
end;

procedure TfrmToolsProxyAnalyzer.cmdOpenClick(Sender: TObject);
var I: integer;

begin
  frmSentry.OpenDialog.Options := frmSentry.OpenDialog.Options + [ofAllowMultiSelect];
  if frmSentry.OpenDialog.Execute then
   begin
    for I := 0 to frmSentry.OpenDialog.Files.Count - 1 do
     lstProxy.LoadFromFile (frmSentry.OpenDialog.Files.Strings[I], sdNone, True);
   end;
  UpdateProxyList;
  frmSentry.OpenDialog.Options := frmSentry.OpenDialog.Options - [ofAllowMultiSelect];
end;

procedure TfrmToolsProxyAnalyzer.cmdSaveClick(Sender: TObject);
begin
  if frmSentry.SaveDialog.Execute then
   begin
    lstProxy.SaveToFile (frmSentry.SaveDialog.FileName, sdNone);
    frmSentry.StatusBar.Panels[0].Text := 'Saved Proxy List To ' + frmSentry.SaveDialog.FileName;
   end;
end;

procedure TfrmToolsProxyAnalyzer.cmdCleanClick(Sender: TObject);
var MyPoint: TPoint;

begin
  GetCursorPos (MyPoint);
  mnucmdClean.Popup (MyPoint.X, MyPoint.Y);
end;

procedure TfrmToolsProxyAnalyzer.cmdPasteClick(Sender: TObject);
var lstTmp: TStringList;

begin
  lstTmp := TStringList.Create;
  try
   lstTmp.Text := Clipboard.AsText;
   lstProxy.LoadFromStrings (lstTmp);
  finally
   lstTmp.Free;
   UpdateProxyList;
  end;
end;

procedure TfrmToolsProxyAnalyzer.cmdRandomizeClick(Sender: TObject);
begin
  lstProxy.Randomize;
  UpdateProxyList;
end;

procedure TfrmToolsProxyAnalyzer.SendToMyList(blnSelected: boolean = False);
var F: TextFile;
    I: integer;
    ChangeFrameRecord: PChangeFrame;

begin
  AssignFile (F, strLocPath + 'MyList.ini');
  Rewrite (F);

  try
   for I := 0 to lstProxy.Count - 1 do
    begin
     if blnSelected then
      begin
       if lstCProxy.Items[I].Selected then
        Writeln (F, lstProxy.Items[I].WriteToMyList);
      end
     else
      Writeln (F, lstProxy.Items[I].WriteToMyList);
    end;
  finally
   CloseFile (F);
  end;

  // Send a message to the main form to change the page
  New (ChangeFrameRecord);
  ChangeFrameRecord^.iCurrentFrame := INDEX_TOOLS_PROXYANALYZER;
  ChangeFrameRecord^.iDisplayFrame := INDEX_LISTS_PROXYLIST;
  PostMessage (frmSentry.Handle, TH_MESSAGE, TH_CHANGE_FRAME, Integer (ChangeFrameRecord));
end;

procedure TfrmToolsProxyAnalyzer.cmdUpdateMyListClick(Sender: TObject);
begin
  SendToMyList;
end;

procedure TfrmToolsProxyAnalyzer.DeleteBadProxies1Click(Sender: TObject);
begin
  lstProxy.DeleteBasedOnImage (3);
  lstProxy.DeleteBasedOnImage (5);
  UpdateProxyList;
end;

procedure TfrmToolsProxyAnalyzer.DeleteTimeouts1Click(Sender: TObject);
begin
  lstProxy.DeleteBasedOnImage (4);
  UpdateProxyList;
end;

procedure TfrmToolsProxyAnalyzer.DeleteGateways1Click(Sender: TObject);
begin
  lstProxy.DeleteGateways;
  UpdateProxyList;
end;

procedure TfrmToolsProxyAnalyzer.RemoveDuplicates1Click(Sender: TObject);
var I: integer;

begin
  I := lstProxy.RemoveDuplicates;
  UpdateProxyList;
  frmSentry.StatusBar.Panels[0].Text := 'Removed ' + IntToStr (I) + ' Duplicates';
  lstCProxy.ClearSelection;
end;

procedure TfrmToolsProxyAnalyzer.DeleteSelectedProxies1Click(Sender: TObject);
var I: integer;

begin
  for I := lstProxy.Count - 1 downto 0 do
   begin
    if lstCProxy.Items[I].Selected then
     lstProxy.Delete (I);
   end;
  UpdateProxyList;
  lstCProxy.ClearSelection;
end;

procedure TfrmToolsProxyAnalyzer.ClearList1Click(Sender: TObject);
begin
  lstProxy.Clear;
  UpdateProxyList;
end;

procedure TfrmToolsProxyAnalyzer.mnuProxyClick(Sender: TObject);
var I: integer;
    strProxy: string;

begin
  I := lstCProxy.ItemIndex;
  if I = -1 then
   Exit;

  strProxy := lstProxy.Items[I].WriteToString;
  if SetProxy (strProxy, mnuProxy.ImageIndex) then
   MessageBox (Application.Handle, PChar ('Using Proxy "' + strProxy + '"' + #13#10#13#10 +
                                          'Browser needs to be restarted for Proxy Settings to take effect.'), 'Success', MB_ICONINFORMATION + MB_APPLMODAL);
end;

procedure TfrmToolsProxyAnalyzer.CopySelectedProxiesToClipboard1Click(Sender: TObject);
var I: integer;
    lstTmp: TStringList;

begin
  lstTmp := TStringList.Create;

  try
   for I := 0 to lstProxy.Count - 1 do
    begin
     if lstCProxy.Items[I].Selected then
      lstTmp.Add (lstProxy.Items[I].WriteToString);
    end;
  finally
   Clipboard.AsText := TrimRight (lstTmp.Text);
   lstTmp.Free;
  end;
end;

procedure TfrmToolsProxyAnalyzer.PasteProxiesFromClipboard1Click(Sender: TObject);
begin
  cmdPasteClick (nil);
end;

procedure TfrmToolsProxyAnalyzer.LoadAProxyList1Click(Sender: TObject);
begin
  cmdOpenClick (nil);
end;

procedure TfrmToolsProxyAnalyzer.SaveProxyList1Click(Sender: TObject);
begin
  cmdSaveClick (nil);
end;

procedure TfrmToolsProxyAnalyzer.cmdOptionsClick(Sender: TObject);
begin
  WriteINISettings;

  frmToolsProxyAnalyzerOptions := TfrmToolsProxyAnalyzerOptions.Create (nil);

  try
   frmToolsProxyAnalyzerOptions.ProxyList := lstProxy;
   frmToolsProxyAnalyzerOptions.ShowModal;
  finally
   lstProxy := frmToolsProxyAnalyzerOptions.ProxyList;
   frmToolsProxyAnalyzerOptions.Free;
  end;

  LoadVariables;
  UpdateProxyList;
end;

procedure TfrmToolsProxyAnalyzer.cmdRetryClick(Sender: TObject);
var MyPoint: TPoint;

begin
  GetCursorPos (MyPoint);

  mnucmdRetry.Popup (MyPoint.X, MyPoint.Y); 
end;

procedure TfrmToolsProxyAnalyzer.RetryBadsClick(Sender: TObject);
begin
  cmdStartClick (Sender);
end;

////////////////////////////////////////////////////////////////////////////////
//                     Start Analyzer Code                                    //
////////////////////////////////////////////////////////////////////////////////

procedure TfrmToolsProxyAnalyzer.EnableControls(Active: boolean);
begin
  cmdClean.Enabled := Active;
  cmdPaste.Enabled := Active;
  cmdRetry.Enabled := Active;
  sldBot.Enabled := Active;
  cmdStart.Enabled := Active;
  cmdAbort.Enabled := not Active;
  cmdRandomize.Enabled := Active;
  cmdOptions.Enabled := Active;
  cmdUpdateMyList.Enabled := Active;

  if Active then
   lstCProxy.OnKeyDown := lstCProxyKeyDown
  else
   begin
    frmSentry.prgStatus.Progress := 0;
    lstCProxy.OnKeyDown := nil;
   end;

  if blnNoLevels then
   lstCProxy.Column[6].Width := 0
  else
   lstCProxy.Column[6].Width := 165;
end;

procedure TfrmToolsProxyAnalyzer.cmdStartClick(Sender: TObject);
begin
  if lstProxy.Count = 0 then
   Exit;

  if lstCProxy.SelCount = 0 then
   lstCProxy.SelectAll;

  EnableControls (False);

  AnalyzerEngine := TAnalyzerEngine.Create;

  with AnalyzerEngine do
   begin
    RequestMethod := httpGET;
    Proxylist := lstProxy;
    URL := strProxyJudge;
    IP := frmSentry.IP;
    Bots := sldBot.Position;
    NoLevels := blnNoLevels;

    // Add Top Level Engine
    if blnExternal then
     Engine := [engAnalyzer];
    if blnInternal then
     begin
      Engine := [engInternal];
      if blnInternalAuth then
       begin
        InternalAuth := True;
        Engine := Engine + [engSpecific];
       end;
     end;

    if blnSpecificKeyPhrase then
     Engine := [engKeyword];

    // Add 2nd Level Engines
    if blnHTTPS then
     Engine := Engine + [engHTTPS];
    if (blnSpecific) and (strSpecificURL <> '') then
     Engine := Engine + [engSpecific];

    HTTPSSite := strHTTPS;
    SpecificSite := strSpecificURL;
    Keyword := strSpecificKeyPhrase;
    CustomResponse := StrToInt (strSpecificResponse);
    Timeout := StrToInt (strTimeout);
    OnBotLaunched := AnalyzerEngineBotLaunched;
    OnBotComplete := AnalyzerEngineBotComplete;
    OnEngineComplete := AnalyzerEngineEngineComplete;

    if Sender = cmdStart then
     frmSentry.prgStatus.MaxValue := BuildSelectedItemList (lstCProxy)
    else if Sender = RetryBads then
     frmSentry.prgStatus.MaxValue := BuildImageItemList (lstCProxy, 3)
    else if Sender = RetryTimeouts then
     frmSentry.prgStatus.MaxValue := BuildImageItemList (lstCProxy, 4)
    else if Sender = RetryUnknowns then
     frmSentry.prgStatus.MaxValue := BuildImageItemList (lstCProxy, 5);

    try
     InitializeEngine;
    except
     MessageDlg ('Port 80 already in use', mtError, [mbOK], 0);
     AnalyzerEngineEngineComplete (AnalyzerEngine);
     Exit;
    end;

    CreateAllBots;
   end;
end;

procedure TfrmToolsProxyAnalyzer.AnalyzerEngineBotLaunched(Sender: TObject; AHttpCli: TAnalyzerBot);
begin
  lstProxy.UnsetProxy (lstProxy.Items[AHttpCli.Position]);

  with lstProxy.Items[AHttpCli.Position] do
   begin
    Status := 'Analyzing';
    ImageIndex := 6;
   end;

  lstCProxy.Items[AHttpCli.Position].Update;
end;

procedure TfrmToolsProxyAnalyzer.AnalyzerEngineBotComplete(Sender: TObject; AHttpCli: TAnalyzerBot);
 var I: integer;

 begin
  I := AHttpCli.Position;
  with lstProxy.Items[AHttpCli.Position] do
   begin
    if (blnHostToIP) and (AHttpCli.Result^.IP <> '') then
     Proxy := AHttpCli.Result^.IP;
    Status := AHttpCli.Status;
    Gateway := AHttpCli.Result^.Gateway;
    if Length (Gateway) > 2 then
     lstProxy.SetGateway (I);
    Anonymous := AHttpCli.Result^.Anonymous;
    Level := AHttpCli.Result^.Level;
    HTTP := AHttpCli.Result^.HTTP;
    HTTPS := AHttpCli.Result^.HTTPS;
    Speed := '';
    Ping := '';

    case AHttpCli.Judgement of
     judGood:
      begin
       Speed := IntToStr (AHttpCli.Speed);
       Ping := IntToStr (AHttpCli.Ping);
       lstProxy.SetGood (I);
      end;
     judBad: lstProxy.SetBad (I);
     judTimeout: lstProxy.SetTimeout (I);
     judUnknown: lstProxy.SetUnknown (I);
    end;
   end;

  lstCProxy.Items[I].Update;
  UpdateStatistics;
  frmSentry.prgStatus.AddProgress (1);

  frmSentry.StatusBar.Panels[0].Text := '[' + IntToStr (frmSentry.prgStatus.Progress) + ' / ' +
                       IntToStr (frmSentry.prgStatus.MaxValue) + '] - ' + IntToStr (frmSentry.prgStatus.PercentDone) +
                       '% Done';

  Application.ProcessMessages;
end;

procedure TfrmToolsProxyAnalyzer.AnalyzerEngineEngineComplete(Sender: TObject);
begin
  EnableControls (True);

  FreeAndNil (AnalyzerEngine);

  if IniFileReadBool (strLocPath + 'Settings.ini', 'Analyzer', 'AutoDelete', False) then
   begin
    lstProxy.DeleteBasedOnImage (3);
    lstProxy.DeleteBasedOnImage (4);
    lstProxy.DeleteBasedOnImage (5);
    UpdateProxyList;
   end;

  // Free some memory
  SetProcessWorkingSetSize (GetCurrentProcess, $FFFFFFFF, $FFFFFFFF);
end;

procedure TfrmToolsProxyAnalyzer.cmdAbortClick(Sender: TObject);
begin
  AnalyzerEngine.AbortEngine;
  frmSentry.StatusBar.Panels[0].Text := 'Aborting Engine...';
end;

procedure TfrmToolsProxyAnalyzer.SendSelectedProxiesToMyList1Click(Sender: TObject);
begin
  SendToMyList (True);
end;

procedure TfrmToolsProxyAnalyzer.SendToBlacklist1Click(Sender: TObject);
var I, J: integer;
    F: TextFile;

begin
  J := 0;

  AppendOrRewriteFile (F, strLocPath + 'Blacklist.ini');
  try
   for I := 0 to lstProxy.Count - 1 do
    begin
     if lstCProxy.Items[I].Selected then
      begin
       Writeln (F, lstProxy.Items[I].Proxy);
       Inc (J);
      end;
    end;
  finally
   CloseFile (F);
  end;

  DeleteSelectedProxies1Click (nil);

  frmSentry.StatusBar.Panels[0].Text := 'Added ' + IntToStr (J) + ' Proxies To Blacklist';
end;

procedure TfrmToolsProxyAnalyzer.SendToHTTPDebugger1Click(Sender: TObject);
var ChangeFrameRecord: PChangeFrame;

begin
  if lstCProxy.ItemIndex <> -1 then
   begin
    IniFileWriteString (strLocPath + 'Settings.ini', 'Debugger', 'Proxy', lstProxy.Items[lstCProxy.ItemIndex].WriteToString);

    // Send a message to the main form to change the page
    New (ChangeFrameRecord);
    ChangeFrameRecord^.iCurrentFrame := INDEX_TOOLS_PROXYANALYZER;
    ChangeFrameRecord^.iDisplayFrame := INDEX_TOOLS_HTTPDEBUGGER;
    PostMessage (frmSentry.Handle, TH_MESSAGE, TH_CHANGE_FRAME, Integer (ChangeFrameRecord));
   end;
end;

end.
