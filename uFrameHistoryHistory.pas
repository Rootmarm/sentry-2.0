unit uFrameHistoryHistory;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ComCtrls, Buttons, StdCtrls, ExtCtrls, Menus, ImgList, 
  uHistoryEngine, uHistoryListView, uHistoryBot, uMyListListView;

type
  TFloatDockForm = class(TCustomDockForm);

  TfrmHistoryHistory = class(TFrame)
    Panel14: TPanel;
    lblBot: TLabel;
    cmdStart: TSpeedButton;
    cmdAbort: TSpeedButton;
    sldBot: TTrackBar;
    mnuClean: TPopupMenu;
    DeleteBad1: TMenuItem;
    DeleteTimeouts1: TMenuItem;
    N1: TMenuItem;
    RemoveDuplicates1: TMenuItem;
    mnuSort: TPopupMenu;
    SortUsingSiteName1: TMenuItem;
    SortUsingLogin1: TMenuItem;
    SortByPassword1: TMenuItem;
    SortByImage1: TMenuItem;
    mnulstHistory: TPopupMenu;
    AddEntry1: TMenuItem;
    DeleteSelected3: TMenuItem;
    N6: TMenuItem;
    EditProxyUsed1: TMenuItem;
    N18: TMenuItem;
    CopySelectedURLsToClipboard1: TMenuItem;
    LaunchinBrowser1: TMenuItem;
    mnuProxy: TMenuItem;
    N8: TMenuItem;
    OpenList1: TMenuItem;
    SaveHistory1: TMenuItem;
    N2: TMenuItem;
    EditFailureKeywords1: TMenuItem;
    EditSuccessKeywords1: TMenuItem;
    EditRequestMethod1: TMenuItem;
    DeleteRedirects1: TMenuItem;
    EditPOSTData1: TMenuItem;
    ClearList1: TMenuItem;
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
    Image6: TImage;
    Label10: TLabel;
    lblTimeout: TLabel;
    Image5: TImage;
    Label9: TLabel;
    lblRedirect: TLabel;
    Panel3: TPanel;
    cmdSort: TSpeedButton;
    cmdPaste: TSpeedButton;
    cmdClean: TSpeedButton;
    cmdSave: TSpeedButton;
    cmdOpen: TSpeedButton;
    Label7: TLabel;
    lstCHistory: TListView;
    Label6: TLabel;
    txtSearch: TEdit;
    Label8: TLabel;
    cmdSearch: TSpeedButton;
    EditFormAction1: TMenuItem;
    EditURL1: TMenuItem;
    CopySelectedProxiesToClipboard1: TMenuItem;
    CopySelectedCombosToClipboard1: TMenuItem;
    procedure lstCHistoryData(Sender: TObject; Item: TListItem);
    procedure lstCHistoryColumnClick(Sender: TObject; Column: TListColumn);
    procedure cmdOpenClick(Sender: TObject);
    procedure cmdSaveClick(Sender: TObject);
    procedure DeleteBad1Click(Sender: TObject);
    procedure DeleteRedirects1Click(Sender: TObject);
    procedure DeleteTimeouts1Click(Sender: TObject);
    procedure RemoveDuplicates1Click(Sender: TObject);
    procedure cmdPasteClick(Sender: TObject);
    procedure cmdCleanClick(Sender: TObject);
    procedure cmdSortClick(Sender: TObject);
    procedure SortUsingSiteName1Click(Sender: TObject);
    procedure SortUsingLogin1Click(Sender: TObject);
    procedure SortByPassword1Click(Sender: TObject);
    procedure SortByImage1Click(Sender: TObject);
    procedure sldBotChange(Sender: TObject);
    procedure AddEntry1Click(Sender: TObject);
    procedure DeleteSelected3Click(Sender: TObject);
    procedure ClearList1Click(Sender: TObject);
    procedure EditProxyUsed1Click(Sender: TObject);
    procedure EditFailureKeywords1Click(Sender: TObject);
    procedure EditSuccessKeywords1Click(Sender: TObject);
    procedure EditPOSTData1Click(Sender: TObject);
    procedure EditRequestMethod1Click(Sender: TObject);
    procedure mnuProxyClick(Sender: TObject);
    procedure CopySelectedURLsToClipboard1Click(Sender: TObject);
    procedure CopySelectedCombosToClipboard1Click(Sender: TObject);
    procedure CopySelectedProxiesToClipboard1Click(Sender: TObject);
    procedure LaunchinBrowser1Click(Sender: TObject);
    procedure OpenList1Click(Sender: TObject);
    procedure SaveHistory1Click(Sender: TObject);
    procedure lstCHistoryDblClick(Sender: TObject);
    procedure lstCHistoryKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure cmdSearchClick(Sender: TObject);
    procedure txtSearchKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);

    procedure EnableControls(Active: boolean);
    procedure cmdStartClick(Sender: TObject);
    procedure cmdAbortClick(Sender: TObject);
    procedure EditFormAction1Click(Sender: TObject);
    procedure EditURL1Click(Sender: TObject);
  private
    blnSort: boolean;
    iColumn: integer;
    HistoryEngine: THistoryEngine;
    FHistoryList: THistory;

    // frmHistoryOptions
    strSaveFilter, strHistoryTimeout: string;
    blnHistoryAfterFP, blnSameProxy, blnHistoryAppend,
    blnHistoryCheckHit, blnFloatDialog, blnSavePosition,
    blnProgressionHistory: boolean;
    iDefaultRequestMethod, iDockLeft, iDockTop: integer;

    procedure ReadINISettings;
    procedure WriteINISettings;
    function  SaveFilter(strPhrase: string; aSite: TSite): string;
    procedure UpdateHistoryList;
    procedure UpdateStatistics;
    procedure AHttpCliUpdateListview(Sender: TObject; AHttpCli: THistoryBot);
    procedure BotLaunched(Sender: TObject; AHttpCli: THistoryBot);
    procedure BotComplete(Sender: TObject; AHttpCli: THistoryBot);
    procedure EngineComplete(Sender: TObject);
  public
    procedure LoadVariables;
    procedure SaveVariables;

    property HistoryList: THistory read FHistoryList write FHistoryList;
  end;

implementation

uses ufrmMain, Clipbrd, FastStrings, FastStringFuncs, uFunctions, IniFiles;

{$R *.dfm}

procedure TfrmHistoryHistory.ReadINISettings;
var IniFile: TIniFile;
    I: integer;
    strSuffix: string;

begin
  IniFile := TIniFile.Create (strLocPath + 'Settings.ini');
  try
   with IniFile do
    begin
     sldBot.Position := ReadInteger ('History', 'Bots', 1);
     strSaveFilter := ReadString ('History', 'SaveFilter', '<PROTO><U>:<P>@<SITE>');
     strHistoryTimeout := ReadString ('History', 'Timeout', '10');
     blnHistoryAfterFP := ReadBool ('History', 'AfterFP', True);
     blnHistoryCheckHit := ReadBool ('History', 'CheckHits', False);
     blnSameProxy := ReadBool ('History', 'SameProxy', False);
     blnHistoryAppend := ReadBool ('History', 'Append', False);
     iDefaultRequestMethod := ReadInteger ('History', 'RequestMethod', 0);

     blnFloatDialog := ReadBool ('History', 'FloatDialog', True);
     blnSavePosition := ReadBool ('History', 'SavePosition', True);
     I := ReadInteger ('Integration', 'BrowserIndex', bmpIE);

     if blnSavePosition then
      begin
       iDockLeft := ReadInteger ('History', 'DockLeft', 0);
       iDockTop := ReadInteger ('History', 'DockTop', 0);
      end;
    end;
  finally
   IniFile.Free;
  end;

  case iDefaultRequestMethod of
   0: FHistoryList.DefaultReqMethod := 'HEAD';
   1: FHistoryList.DefaultReqMethod := 'GET';
   2: FHistoryList.DefaultReqMethod := 'POST';
  end;

  case I of
   bmpIE: strSuffix := 'IE';
   bmpFIREFOX: strSuffix := 'Firefox';
   bmpOPERA: strSuffix := 'Opera';
  end;

  mnuProxy.Caption := 'Use Proxy In ' + strSuffix;
  mnuProxy.ImageIndex := I;
end;

procedure TfrmHistoryHistory.WriteINISettings;
var IniFile: TIniFile;

begin
  IniFile := TIniFile.Create (strLocPath + 'Settings.ini');
  try
   with IniFile, TFloatDockForm (Panel1.Parent) do
    begin
     WriteInteger ('History', 'DockLeft', Left);
     WriteInteger ('History', 'DockTop', Top);
     WriteInteger ('History', 'Bots', sldBot.Position);
    end;
  finally
   IniFile.Free;
  end;
end;

function TfrmHistoryHistory.SaveFilter(strPhrase: string; aSite: TSite): string;
var iLength: integer;

begin
  iLength := Length (strPhrase);
  Result := strPhrase;

  if FastPosNoCase (strPhrase, '<PROTO>', iLength, 7, 1) <> 0 then
   Result := FastReplace (Result, '<PROTO>', GetProtocol (aSite.Site));
  if FastPosNoCase (strPhrase, '<U>', iLength, 3, 1) <> 0 then
   Result := FastReplace (Result, '<U>', GetUsername (aSite.Site));
  if FastPosNoCase (strPhrase, '<P>', iLength, 3, 1) <> 0 then
   Result := FastReplace (Result, '<P>', GetPassword (aSite.Site));
  if FastPosNoCase (strPhrase, '<SITE>', iLength, 6, 1) <> 0 then
   Result := FastReplace (Result, '<SITE>', GetMembersURL (aSite.Site));
  if FastPosNoCase (strPhrase, '<BASE>', iLength, 6, 1) <> 0 then
   Result := FastReplace (Result, '<BASE>', GetBaseURL (aSite.Site));
  if FastPosNoCase (strPhrase, '<WORDLIST>', iLength, 10, 1) <> 0 then
   Result := FastReplace (Result, '<WORDLIST>', aSite.Wordlist);
  if FastPosNoCase (strPhrase, '<PROXY>', iLength, 7, 1) <> 0 then
   Result := FastReplace (Result, '<PROXY>', aSite.Proxy);
  if FastPosNoCase (strPhrase, '<STATUS>', iLength, 8, 1) <> 0 then
   Result := FastReplace (Result, '<STATUS>', aSite.Status);
end;

procedure TfrmHistoryHistory.UpdateHistoryList;
begin
  lstCHistory.Items.BeginUpdate;
  try
   lstCHistory.Items.Count := FHistoryList.Count;
  finally
   lstCHistory.Items.EndUpdate;
   UpdateStatistics;
   lblCount.Caption := IntToStr (FHistoryList.Count);
   frmSentry.StatusBar.Panels[0].Text := 'Displaying ' + IntToStr (FHistoryList.Count) + ' Sites in History';
  end;
end;

procedure TfrmHistoryHistory.UpdateStatistics;
begin
   lblGood.Caption := IntToStr (FHistoryList.Good);
   lblBad.Caption := IntToStr (FHistoryList.Bad);
   lblRedirect.Caption := IntToStr (FHistoryList.Redirect);
   lblTimeout.Caption := IntToStr (FHistoryList.Timeout);
end;

procedure TfrmHistoryHistory.lstCHistoryData(Sender: TObject; Item: TListItem);
begin
  if Item.Index >= FHistoryList.Count then
   Exit;

  with FHistoryList[Item.Index] do
   begin
    Item.Caption := Site;
    Item.SubItems.Add (Proxy);
    Item.SubItems.Add (Status);
    Item.SubItems.Add (FailKeys);
    Item.SubItems.Add (SuccessKeys);
    Item.SubItems.Add (FormAction); 
    Item.SubItems.Add (POSTData); 
    Item.SubItems.Add (ReqMethod);
    Item.SubItems.Add (Wordlist);
    Item.ImageIndex := ImageIndex;
   end;
end;

procedure TfrmHistoryHistory.lstCHistoryColumnClick(Sender: TObject; Column: TListColumn);
begin
  if Column.Index = iColumn then
   blnSort := not blnSort
  else
   begin
    iColumn := Column.Index;
    blnSort := False;
   end;
  with FHistoryList do
   begin
    case Column.Index of
     0: SortSiteAlpha (blnSort);
     1: SortProxyAlpha (blnSort);
     2: SortStatusAlpha (blnSort);
     3: SortFailKeysAlpha (blnSort);
     4: SortSuccessKeysAlpha (blnSort);
     5: SortFormActionAlpha (blnSort);
     6: SortReqMethodAlpha (blnSort);
     7: SortWordlistAlpha (blnSort);
    end;
   end;
  UpdateHistoryList;
end;

procedure TfrmHistoryHistory.cmdOpenClick(Sender: TObject);
var I: integer;

begin
  frmSentry.OpenDialog.Options := frmSentry.OpenDialog.Options + [ofAllowMultiSelect];
  if frmSentry.OpenDialog.Execute then
   begin
    for I := 0 to frmSentry.OpenDialog.Files.Count - 1 do
     FHistoryList.LoadFromFile (frmSentry.OpenDialog.Files.Strings[I], False, True);

    UpdateHistoryList;
   end;
  frmSentry.OpenDialog.Options := frmSentry.OpenDialog.Options - [ofAllowMultiSelect];
end;

procedure TfrmHistoryHistory.cmdSaveClick(Sender: TObject);
var I: integer;
    F: TextFile;

begin
  if lstCHistory.SelCount = 0 then
   lstCHistory.SelectAll;
  if blnHistoryAppend then
   frmSentry.SaveDialog.Options := frmSentry.OpenDialog.Options - [ofOverwritePrompt];

  if frmSentry.SaveDialog.Execute then
   begin
    AssignFile (F, frmSentry.SaveDialog.FileName);
    if (blnHistoryAppend) and (FileExists (frmSentry.SaveDialog.FileName)) then
     Append (F)
    else
     Rewrite (F);

    try
     for I := 0 to FHistoryList.Count - 1 do
      begin
       if lstCHistory.Items[I].Selected then
        Writeln (F, SaveFilter (strSaveFilter, FHistoryList.Items[I]));
      end;
    finally
     CloseFile (F);
     frmSentry.StatusBar.Panels[0].Text := 'Saved Selected Sites To "' + frmSentry.SaveDialog.FileName + '"';
    end;
   end;

  if blnHistoryAppend then
   frmSentry.SaveDialog.Options := frmSentry.OpenDialog.Options + [ofOverwritePrompt];
end;

procedure TfrmHistoryHistory.DeleteBad1Click(Sender: TObject);
begin
  FHistoryList.DeleteImageIndex (3);
  UpdateHistoryList;
end;

procedure TfrmHistoryHistory.DeleteRedirects1Click(Sender: TObject);
begin
  FHistoryList.DeleteImageIndex (5);
  UpdateHistoryList;
end;

procedure TfrmHistoryHistory.DeleteTimeouts1Click(Sender: TObject);
begin
  FHistoryList.DeleteImageIndex (4);
  UpdateHistoryList;
end;

procedure TfrmHistoryHistory.RemoveDuplicates1Click(Sender: TObject);
var I: integer;

begin
  I := FHistoryList.RemoveDuplicates;
  MessageDlg ('Removed ' + IntToStr (I) + ' Duplicates', mtInformation, [mbOK], 0);
  UpdateHistoryList;
end;

procedure TfrmHistoryHistory.cmdPasteClick(Sender: TObject);
var lstTmp: TStringList;

begin
  lstTmp := TStringList.Create;
  try
   lstTmp.Text := Clipboard.AsText;
   FHistoryList.LoadFromStrings (lstTmp);
  finally
   lstTmp.Free;
   UpdateHistoryList;
  end;
end;

procedure TfrmHistoryHistory.cmdCleanClick(Sender: TObject);
var Point: TPoint;

begin
  GetCursorPos (Point);
  mnuClean.Popup (Point.X, Point.Y);
end;

procedure TfrmHistoryHistory.cmdSortClick(Sender: TObject);
var Point: TPoint;

begin
  GetCursorPos (Point);
  mnuSort.Popup (Point.X, Point.Y);
end;

procedure TfrmHistoryHistory.SortUsingSiteName1Click(Sender: TObject);
begin
  if iColumn = 4 then
   blnSort := not blnSort
  else
   begin
    blnSort := False;
    iColumn := 4;
   end;

  FHistoryList.SortSiteNameAlpha (blnSort);
  UpdateHistoryList;
end;

procedure TfrmHistoryHistory.SortUsingLogin1Click(Sender: TObject);
begin
  if iColumn = 5 then
   blnSort := not blnSort
  else
   begin
    blnSort := False;
    iColumn := 5;
   end;

  FHistoryList.SortUserNameAlpha (blnSort);
  UpdateHistoryList;
end;

procedure TfrmHistoryHistory.SortByPassword1Click(Sender: TObject);
begin
  if iColumn = 6 then
   blnSort := not blnSort
  else
   begin
    blnSort := False;
    iColumn := 6;
   end;

  FHistoryList.SortPasswordAlpha (blnSort);
  UpdateHistoryList;
end;

procedure TfrmHistoryHistory.SortByImage1Click(Sender: TObject);
begin
  if iColumn = 7 then
   blnSort := not blnSort
  else
   begin
    blnSort := False;
    iColumn := 7;
   end;

  FHistoryList.SortImageIndexAlpha (blnSort);
  UpdateHistoryList;
end;

procedure TfrmHistoryHistory.sldBotChange(Sender: TObject);
begin
  lblBot.Caption := IntToStr (sldBot.Position);
end;

procedure TfrmHistoryHistory.LoadVariables;
var Rect: TRect;

begin
  // FHistoryList can already be assigned if it is being passed in by
  // the Progression Frame.
  blnProgressionHistory := Assigned (FHistoryList);
  if blnProgressionHistory = False then
   begin
    FHistoryList := THistory.Create;
    if FileExists (strLocPath + 'History.ini') then
     FHistoryList.LoadFromFile (strLocPath + 'History.ini', True, False);
   end;

  iColumn := -1;
  cmdClean.Glyph.TransparentColor := clFuchsia;
  lstCHistory.DoubleBuffered := True;
  UpdateHistoryList;

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
    Rect.Bottom := Rect.Top + 233;

    Panel1.FloatingDockSiteClass := TFloatDockForm;
    Panel1.ManualFloat (Rect);

    TFloatDockForm (Panel1.Parent).BorderIcons := [];
   end;
end;

procedure TfrmHistoryHistory.SaveVariables;
begin
  lstCHistory.OnData := nil;
  WriteINISettings;
  if blnFloatDialog then
   TFloatDockForm (Panel1.Parent).Free;
  if blnProgressionHistory = False then
   begin
    FHistoryList.SaveToFile (strLocPath + 'History.ini');
    FreeAndNil (FHistoryList);
   end;
end;

procedure TfrmHistoryHistory.AddEntry1Click(Sender: TObject);
var strTmp: string;
    aItem: TSite;

begin
  strTmp := InputBox ('Add Site', 'Add a Site "http://USER:PASS@SITE"', '');
  if Trim (strTmp) <> '' then
   begin
    aItem := TSite.Create;
    aItem.Site := strTmp;
    aItem.ReqMethod := FHistoryList.DefaultReqMethod;
    FHistoryList.Add (aItem);

    UpdateHistoryList;
   end;
end;

procedure TfrmHistoryHistory.DeleteSelected3Click(Sender: TObject);
var I: integer;

begin
  for I := FHistoryList.Count - 1 downto 0 do
   begin
    if lstCHistory.Items[I].Selected then
     FHistoryList.Delete (I);
   end;

  lstCHistory.ClearSelection;
  UpdateHistoryList;
end;

procedure TfrmHistoryHistory.ClearList1Click(Sender: TObject);
begin
  FHistoryList.Clear;
  UpdateHistoryList;
end;

procedure TfrmHistoryHistory.EditURL1Click(Sender: TObject);
var strTmp: string;
    I: integer;

begin
  I := lstCHistory.ItemIndex;
  if I = -1 then
   Exit;

  strTmp := InputBox ('Edit URL', 'Edit URL (http://USER:PASS@SITE)', FHistoryList.Items[I].Site);
  FHistoryList.Items[I].Site := strTmp;
  UpdateHistoryList;
end;

procedure TfrmHistoryHistory.EditProxyUsed1Click(Sender: TObject);
var strTmp: string;
    I: integer;

begin
  I := lstCHistory.ItemIndex;
  if I = -1 then
   Exit;

  strTmp := InputBox ('Edit Proxy', 'Edit Proxy for Selected Sites', FHistoryList.Items[I].Proxy);
  for I := 0 to FHistoryList.Count - 1 do
   begin
    if lstCHistory.Items[I].Selected then
     FHistoryList.Items[I].Proxy := strTmp;
   end;
  UpdateHistoryList;
end;

procedure TfrmHistoryHistory.EditFailureKeywords1Click(Sender: TObject);
var strTmp: string;
    I, J: integer;

begin
  I := lstCHistory.ItemIndex;
  if I = -1 then
   Exit;

  strTmp := InputBox ('Edit Failure Keywords', 'Use '';'' to separate (Example: first;second)', FHistoryList.Items[I].FailKeys);
  J := Length (strTmp);
  if (J <> 0) and (strTmp[J] = ';') then
   SetLength (strTmp, J - 1);

  for I := 0 to FHistoryList.Count - 1 do
   begin
    if lstCHistory.Items[I].Selected then
     FHistoryList.Items[I].FailKeys := strTmp;
   end;
  UpdateHistoryList;
end;

procedure TfrmHistoryHistory.EditSuccessKeywords1Click(Sender: TObject);
var strTmp: string;
    I, J: integer;

begin
  I := lstCHistory.ItemIndex;
  if I = -1 then
   Exit;

  strTmp := InputBox ('Edit Success Keywords', 'Use '';'' to separate (Example: first;second)', FHistoryList.Items[I].SuccessKeys);

  J := Length (strTmp);
  if (J <> 0) and (strTmp[J] = ';') then
   SetLength (strTmp, J - 1);

  for I := 0 to FHistoryList.Count - 1 do
   begin
    if lstCHistory.Items[I].Selected then
     FHistoryList.Items[I].SuccessKeys := strTmp;
   end;
  UpdateHistoryList;
end;

procedure TfrmHistoryHistory.EditFormAction1Click(Sender: TObject);
var strTmp: string;
    I: integer;

begin
  I := lstCHistory.ItemIndex;
  if I = -1 then
   Exit;

  strTmp := InputBox ('Edit Form Action', 'Full URL to Form Action', FHistoryList.Items[I].FormAction);
  for I := 0 to FHistoryList.Count - 1 do
   begin
    if lstCHistory.Items[I].Selected then
     FHistoryList.Items[I].FormAction := strTmp;
   end;
  UpdateHistoryList;
end;

procedure TfrmHistoryHistory.EditPOSTData1Click(Sender: TObject);
var strTmp: string;
    I: integer;

begin
  I := lstCHistory.ItemIndex;
  if I = -1 then
   Exit;

  strTmp := InputBox ('Edit POST Data', 'User <USER> and <PASS> for combo variables', FHistoryList.Items[I].POSTData);
  for I := 0 to FHistoryList.Count - 1 do
   begin
    if lstCHistory.Items[I].Selected then
     FHistoryList.Items[I].POSTData := strTmp;
   end;
  UpdateHistoryList;
end;

procedure TfrmHistoryHistory.EditRequestMethod1Click(Sender: TObject);
var strTmp: string;
    I: integer;

begin
  I := lstCHistory.ItemIndex;
  if I = -1 then
   Exit;

  strTmp := InputBox ('Edit Request Method', 'Either HEAD/GET/POST', FHistoryList.Items[I].ReqMethod);
  if Trim (strTmp) <> '' then
   begin
    for I := 0 to FHistoryList.Count - 1 do
     begin
      if lstCHistory.Items[I].Selected then
       FHistoryList.Items[I].ReqMethod := strTmp;
     end;
    UpdateHistoryList;
   end;
end;

procedure TfrmHistoryHistory.mnuProxyClick(Sender: TObject);
var I: integer;
    strProxy: string;

begin
  I := lstCHistory.ItemIndex;
  if I = -1 then
   Exit;

  strProxy := FHistoryList.Items[I].Proxy;
  if SetProxy (strProxy, mnuProxy.ImageIndex) then
   MessageBox (Application.Handle, PChar ('Using Proxy "' + strProxy + '"' + #13#10#13#10 +
                                          'Browser needs to be restarted for Proxy Settings to take effect.'), 'Success', MB_ICONINFORMATION + MB_APPLMODAL);
end;

procedure TfrmHistoryHistory.CopySelectedURLsToClipboard1Click(Sender: TObject);
var lstTmp: TStringList;
    I: integer;

begin
  lstTmp := TStringList.Create;
  try
   for I := 0 to FHistoryList.Count - 1 do
    begin
     if lstCHistory.Items[I].Selected then
      lstTmp.Add (FHistoryList.Items[I].Site);
    end;
    Clipboard.AsText := TrimRight (lstTmp.Text);
   finally
    frmSentry.StatusBar.Panels[0].Text := 'Copied ' + IntToStr (lstTmp.Count) + ' Sites to Clipboard';
    lstTmp.Free;
   end;
end;

procedure TfrmHistoryHistory.CopySelectedCombosToClipboard1Click(Sender: TObject);
var lstTmp: TStringList;
    I: integer;

begin
  lstTmp := TStringList.Create;
  try
   for I := 0 to FHistoryList.Count - 1 do
    begin
     if lstCHistory.Items[I].Selected then
      begin
       with FHistoryList.Items[I] do
        lstTmp.Add (GetUsername (Site) + ':' + GetPassword (Site));
      end;
    end;
    Clipboard.AsText := TrimRight (lstTmp.Text);
   finally
    frmSentry.StatusBar.Panels[0].Text := 'Copied ' + IntToStr (lstTmp.Count) + ' Combos to Clipboard';
    lstTmp.Free;
   end;
end;

procedure TfrmHistoryHistory.CopySelectedProxiesToClipboard1Click(Sender: TObject);
var lstTmp: TStringList;
    I: integer;

begin
  lstTmp := TStringList.Create;
  try
   for I := 0 to FHistoryList.Count - 1 do
    begin
     if lstCHistory.Items[I].Selected then
      lstTmp.Add (FHistoryList.Items[I].Proxy);
    end;
    Clipboard.AsText := TrimRight (lstTmp.Text);
   finally
    frmSentry.StatusBar.Panels[0].Text := 'Copied ' + IntToStr (lstTmp.Count) + ' Proxies to Clipboard';
    lstTmp.Free;
   end;
end;

procedure TfrmHistoryHistory.LaunchinBrowser1Click(Sender: TObject);
var I, J: integer;

begin
  J := lstCHistory.ItemIndex;
  if J = -1 then
   Exit;

  I := IniFileReadInteger (strLocPath + 'Settings.ini', 'Integration', 'BrowserIndex', bmpIE);
  LaunchSite (FHistoryList.Items[J].Site, I);
end;

procedure TfrmHistoryHistory.OpenList1Click(Sender: TObject);
begin
  cmdOpenClick (nil);
end;

procedure TfrmHistoryHistory.SaveHistory1Click(Sender: TObject);
begin
  cmdSaveClick (nil);
end;

procedure TfrmHistoryHistory.lstCHistoryDblClick(Sender: TObject);
begin
  LaunchinBrowser1Click (nil);
end;

procedure TfrmHistoryHistory.lstCHistoryKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
   46: DeleteSelected3Click (nil);
   65: lstCHistory.SelectAll;
  end;
end;

procedure TfrmHistoryHistory.cmdSearchClick(Sender: TObject);
var I, J: integer;

begin
  lstCHistory.ClearSelection;

  if (txtSearch.Text <> '') and (FHistoryList.Count <> 0) then
   begin
    J := FHistoryList.Find (txtSearch.Text);

    for I := 0 to J - 1 do
     lstCHistory.Items[I].Selected := True;
   end;
end;

procedure TfrmHistoryHistory.txtSearchKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = 13 then
   cmdSearchClick (nil);
end;

////////////////////////////////////////////////////////////////////////////////
//                     Start History Code                                     //
////////////////////////////////////////////////////////////////////////////////

procedure TfrmHistoryHistory.EnableControls(Active: boolean);
begin
  cmdClean.Enabled := Active;
  cmdPaste.Enabled := Active;
  cmdSort.Enabled := Active;
  sldBot.Enabled := Active;
  cmdStart.Enabled := Active;
  cmdAbort.Enabled := not Active;
  if Active then
   lstCHistory.OnKeyDown := lstCHistoryKeyDown
  else
   begin
    frmSentry.prgStatus.Progress := 0;
    lstCHistory.OnKeyDown := nil;
   end
end;

procedure TfrmHistoryHistory.cmdStartClick(Sender: TObject);
var blnWarning: boolean;
    strMyList: string;

begin
  if FHistoryList.Count = 0 then
   Exit;

  blnWarning := False;
  strMyList := strLocPath + 'MyList.ini';
  if GetFileSize (strMyList) = 0 then
   begin
    if MessageDlg ('You are about to start a history test without any proxies in My List.' +
                   #13#10#13#10 + 'Are you sure you want to do this?', mtWarning, [mbYes, mbNo], 0) in [mrNo] then
     Exit
    else
     blnWarning := True;
   end;

  if lstCHistory.ItemIndex = -1 then
   lstCHistory.SelectAll;

  EnableControls (False);

  HistoryEngine := THistoryEngine.Create;

  with HistoryEngine do
   begin
    Bots := sldBot.Position;
    EnableAfterFP := blnHistoryAfterFP;
    EnableSameProxy := blnSameProxy;
    EnableCheckHits := blnHistoryCheckHit;
    History := FHistoryList;

    if blnWarning = False then
     MyList := TMyList.Create (strMyList);

    Timeout := StrToInt (strHistoryTimeout);
    frmSentry.prgStatus.MaxValue := BuildSelectedItemList (lstCHistory);

    OnUpdateListview := AHttpCliUpdateListview;
    OnBotLaunched := BotLaunched;
    OnBotComplete := BotComplete;
    OnEngineComplete := EngineComplete;

    InitializeEngine;
    CreateAllBots;
   end;
end;

procedure TfrmHistoryHistory.AHttpCliUpdateListview(Sender: TObject; AHttpCli: THistoryBot);
begin
  lstCHistory.Items[AHttpCli.Position].Update;
end;

procedure TfrmHistoryHistory.BotLaunched(Sender: TObject; AHttpCli: THistoryBot);
begin
  FHistoryList.UnsetSite (FHistoryList.Items[AHttpCli.Position]);

  with FHistoryList.Items[AHttpCli.Position] do
   begin
    ImageIndex := 6;
    lstCHistory.Items[AHttpCli.Position].Update;
   end;
end;

procedure TfrmHistoryHistory.BotComplete(Sender: TObject; AHttpCli: THistoryBot);
var I: integer;

begin
  I := AHttpCli.Position;

  with FHistoryList.Items[I] do
   begin
    Status := AHttpCli.Status;
    case AHttpCli.Judgement of
     judGood:     FHistoryList.SetGood (I);
     judBad:      FHistoryList.SetBad (I);
     judTimeout:  FHistoryList.SetTimeout (I);
     judRedirect: FHistoryList.SetRedirect (I);
    end;
   end;

   lstCHistory.Items[I].Update;
   UpdateStatistics;
   frmSentry.prgStatus.AddProgress (1);

   frmSentry.StatusBar.Panels[0].Text := '[' + IntToStr (frmSentry.prgStatus.Progress) + ' / ' +
                       IntToStr (frmSentry.prgStatus.MaxValue) + '] - ' + IntToStr (frmSentry.prgStatus.PercentDone) +
                       '% Done';

   Application.ProcessMessages;
end;

procedure TfrmHistoryHistory.EngineComplete(Sender: TObject);
begin
  FreeAndNil (HistoryEngine);
  frmSentry.StatusBar.Panels[0].Text := 'History Verification Complete';
  EnableControls (True);
end;

procedure TfrmHistoryHistory.cmdAbortClick(Sender: TObject);
begin
  HistoryEngine.AbortEngine;
  frmSentry.StatusBar.Panels[0].Text := 'Aborting Engine...';
end;

end.
