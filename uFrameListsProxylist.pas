unit uFrameListsProxylist;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, ImgList, Buttons, Menus,
  uMyListListView;

type
  TfrmListsProxylist = class(TFrame)
    lstCMyList: TListView;
    Label1: TLabel;
    Bevel1: TBevel;
    Label2: TLabel;
    Panel1: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Shape1: TShape;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    lblActive: TLabel;
    lblDisabled: TLabel;
    lblCount: TLabel;
    cmdOpen: TSpeedButton;
    cmdSave: TSpeedButton;
    cmdClear: TSpeedButton;
    cmdPaste: TSpeedButton;
    mnuMyList: TPopupMenu;
    DeleteSelectedProxies1: TMenuItem;
    N1: TMenuItem;
    ReactivateSelectedProxies1: TMenuItem;
    DisableSelectedProxies1: TMenuItem;
    LoadAProxyList1: TMenuItem;
    SaveProxyList1: TMenuItem;
    N2: TMenuItem;
    mnuProxy: TMenuItem;
    N3: TMenuItem;
    CopySelectedProxiesToClipboard1: TMenuItem;
    PasteProxiesFromClipboard1: TMenuItem;
    cmdClean: TSpeedButton;
    mnucmdClean: TPopupMenu;
    RemoveDuplicates1: TMenuItem;
    Image4: TImage;
    Label6: TLabel;
    lblBanned: TLabel;
    ClearList1: TMenuItem;
    N4: TMenuItem;
    SendToAnalyzer1: TMenuItem;
    SendToBlacklist1: TMenuItem;
    SendToHTTPDebugger1: TMenuItem;
    procedure lstCMyListColumnClick(Sender: TObject; Column: TListColumn);
    procedure lstCMyListData(Sender: TObject; Item: TListItem);
    procedure lstCMyListKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure cmdOpenClick(Sender: TObject);
    procedure cmdSaveClick(Sender: TObject);
    procedure cmdClearClick(Sender: TObject);
    procedure cmdPasteClick(Sender: TObject);
    procedure ReactivateSelectedProxies1Click(Sender: TObject);
    procedure DisableSelectedProxies1Click(Sender: TObject);
    procedure DeleteSelectedProxies1Click(Sender: TObject);
    procedure mnuProxyClick(Sender: TObject);
    procedure LoadAProxyList1Click(Sender: TObject);
    procedure SaveProxyList1Click(Sender: TObject);
    procedure CopySelectedProxiesToClipboard1Click(Sender: TObject);
    procedure PasteProxiesFromClipboard1Click(Sender: TObject);
    procedure cmdCleanClick(Sender: TObject);
    procedure RemoveDuplicates1Click(Sender: TObject);
    procedure ClearList1Click(Sender: TObject);
    procedure SendToAnalyzer1Click(Sender: TObject);
    procedure SendToBlacklist1Click(Sender: TObject);
    procedure SendToHTTPDebugger1Click(Sender: TObject);
  private
    blnSort: boolean;
    iColumn: integer;
    lstMyList: TMyList;

    procedure UpdateMyList;
  public
    procedure LoadVariables;
    procedure SaveVariables;
  end;

implementation

uses ufrmMain, Clipbrd, IniFiles, uFunctions;

{$R *.dfm}

procedure TfrmListsProxylist.LoadVariables;
var strSuffix: string;
    I: integer;

begin
  lstCMyList.DoubleBuffered := True;
  cmdClean.Glyph.TransparentColor := clFuchsia;
  iColumn := -1;

  lstMyList := TMyList.Create;
  if FileExists (strLocPath + 'MyList.ini') then
   begin
    lstMyList.LoadFromFile (strLocPath + 'MyList.ini', True, False);
    UpdateMyList;
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

procedure TfrmListsProxylist.SaveVariables;
begin
  lstCMyList.OnData := nil;
  
  lstMyList.SaveToFile (strLocPath + 'MyList.ini', True);
  FreeAndNil (lstMyList);
end;

procedure TfrmListsProxylist.UpdateMyList;
begin
  lstCMyList.Items.BeginUpdate;
  try
   lstCMyList.Items.Count := lstMyList.Count;
  finally
   lstCMyList.Items.EndUpdate;
   lblActive.Caption := IntToStr (lstMyList.Active);
   lblDisabled.Caption := IntToStr (lstMyList.Disabled);
   lblBanned.Caption := IntToStr (lstMyList.Banned);
   lblCount.Caption := IntToStr (lstMyList.Count);
   frmSentry.StatusBar.Panels[0].Text := 'Displaying ' + lblCount.Caption + ' Proxies in My List';
  end;
end;

procedure TfrmListsProxylist.lstCMyListColumnClick(Sender: TObject; Column: TListColumn);
begin
  if Column.Index = iColumn then
   blnSort := not blnSort
  else
   begin
    iColumn := Column.Index;
    blnSort := False;
   end;
  with lstMyList do
   begin
    case Column.Index of
     0: SortProxyAlpha (blnSort);
     1: SortPortAlpha (blnSort);
     2: SortStatusAlpha (blnSort);
    end;
   end;
  UpdateMyList;
end;

procedure TfrmListsProxylist.lstCMyListData(Sender: TObject; Item: TListItem);
begin
  if Item.Index >= lstMyList.Count then
   Exit;

  with lstMyList[Item.Index] do
   begin
    Item.Caption := Proxy;
    Item.SubItems.Add (Port);
    Item.SubItems.Add (Status);
    Item.ImageIndex := ImageIndex;
   end;
end;

procedure TfrmListsProxylist.lstCMyListKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
   46: DeleteSelectedProxies1Click (nil);
   65: lstCMyList.SelectAll;
  end;
end;

procedure TfrmListsProxylist.cmdOpenClick(Sender: TObject);
var I: integer;

begin
  frmSentry.OpenDialog.Options := frmSentry.OpenDialog.Options + [ofAllowMultiSelect];

  if frmSentry.OpenDialog.Execute then
   begin
    for I := 0 to frmSentry.OpenDialog.Files.Count - 1 do
     lstMyList.LoadFromFile (frmSentry.OpenDialog.Files.Strings[I], False, True);

    UpdateMyList;
   end;

  frmSentry.OpenDialog.Options := frmSentry.OpenDialog.Options - [ofAllowMultiSelect];
end;

procedure TfrmListsProxylist.cmdSaveClick(Sender: TObject);
begin
  if frmSentry.SaveDialog.Execute then
   begin
    lstMyList.SaveToFile (frmSentry.SaveDialog.FileName, False);
    frmSentry.StatusBar.Panels[0].Text := 'Saved My List To ' + frmSentry.SaveDialog.FileName;
   end;
end;

procedure TfrmListsProxylist.cmdClearClick(Sender: TObject);
begin
  lstMyList.Clear;
  UpdateMyList;
end;

procedure TfrmListsProxylist.cmdPasteClick(Sender: TObject);
var lstTmp: TStringList;

begin
  lstTmp := TStringList.Create;
  try
   lstTmp.Text := Clipboard.AsText;
   lstMyList.LoadFromStrings (lstTmp);
  finally
   lstTmp.Free;
   UpdateMyList;
  end;
end;

procedure TfrmListsProxylist.ReactivateSelectedProxies1Click(Sender: TObject);
var I: integer;

begin
  for I := 0 to lstMyList.Count - 1 do
   begin
    if lstCMyList.Items[I].Selected then
     lstMyList.ReactivateProxy (I);
   end;
  UpdateMyList;
end;

procedure TfrmListsProxylist.DisableSelectedProxies1Click(Sender: TObject);
var I: integer;

begin
  for I := 0 to lstMyList.Count - 1 do
   begin
    if lstCMyList.Items[I].Selected then
     lstMyList.DisableProxy (I, 'Manually Disabled');
   end;
  UpdateMyList;
end;

procedure TfrmListsProxylist.DeleteSelectedProxies1Click(Sender: TObject);
var I: integer;

begin
  for I := lstMyList.Count - 1 downto 0 do
   begin
    if lstCMyList.Items[I].Selected then
     lstMyList.Delete (I);
   end;
  UpdateMyList;
  lstCMyList.ClearSelection;
end;

procedure TfrmListsProxylist.mnuProxyClick(Sender: TObject);
var I: integer;
    strProxy: string;

begin
  I := lstCMyList.ItemIndex;
  if I = -1 then
   Exit;

  strProxy := lstMyList.Items[I].WriteToString;
  if SetProxy (strProxy, mnuProxy.ImageIndex) then
   MessageBox (Application.Handle, PChar ('Using Proxy "' + strProxy + '"' + #13#10#13#10 +
                                          'Browser needs to be restarted for Proxy Settings to take effect.'), 'Success', MB_ICONINFORMATION + MB_APPLMODAL);
end;

procedure TfrmListsProxylist.LoadAProxyList1Click(Sender: TObject);
begin
  cmdOpenClick (nil);
end;

procedure TfrmListsProxylist.SaveProxyList1Click(Sender: TObject);
begin
  cmdSaveClick (nil);
end;

procedure TfrmListsProxylist.CopySelectedProxiesToClipboard1Click(Sender: TObject);
var I: integer;
    lstTmp: TStringList;

begin
  lstTmp := TStringList.Create;

  try
   for I := 0 to lstMyList.Count - 1 do
    begin
     if lstCMyList.Items[I].Selected then
      lstTmp.Add (lstMyList.Items[I].WriteToString);
    end;
  finally
   Clipboard.AsText := TrimRight (lstTmp.Text);
   lstTmp.Free;
  end;
end;

procedure TfrmListsProxylist.PasteProxiesFromClipboard1Click(Sender: TObject);
begin
  cmdPasteClick (nil);
end;

procedure TfrmListsProxylist.cmdCleanClick(Sender: TObject);
var MyPoint: TPoint;

begin
  GetCursorPos (MyPoint);
  mnucmdClean.Popup (MyPoint.X, MyPoint.Y);
end;

procedure TfrmListsProxylist.RemoveDuplicates1Click(Sender: TObject);
var I: integer;

begin
  I := lstMyList.RemoveDuplicates;
  UpdateMyList;
  frmSentry.StatusBar.Panels[0].Text := 'Removed ' + IntToStr (I) + ' Duplicates';
  lstCMyList.ClearSelection;
end;

procedure TfrmListsProxylist.ClearList1Click(Sender: TObject);
begin
  cmdClearClick (nil);
end;

procedure TfrmListsProxylist.SendToAnalyzer1Click(Sender: TObject);
var I: integer;
    F: TextFile;
    strFile: string;
    ChangeFrameRecord: PChangeFrame;

begin
  if lstCMyList.ItemIndex = -1 then
   Exit;

  strFile := strLocPath + 'Proxy.ini';
  AppendOrRewriteFile (F, strFile);
  try
   for I := 0 to lstMyList.Count - 1 do
    begin
     if lstCMyList.Items[I].Selected then
      Writeln (F, lstMyList.Items[I].Proxy + ';' + lstMyList.Items[I].Port + ';;;;;;;;;0');
    end;
  finally
   CloseFile (F);
  end;

  // Send a message to the main form to change the page
  New (ChangeFrameRecord);
  ChangeFrameRecord^.iCurrentFrame := INDEX_LISTS_PROXYLIST;
  ChangeFrameRecord^.iDisplayFrame := INDEX_TOOLS_PROXYANALYZER;
  PostMessage (frmSentry.Handle, TH_MESSAGE, TH_CHANGE_FRAME, Integer (ChangeFrameRecord));
end;

procedure TfrmListsProxylist.SendToBlacklist1Click(Sender: TObject);
var I, J: integer;
    F: TextFile;

begin
  J := 0;

  AppendOrRewriteFile (F, strLocPath + 'Blacklist.ini');
  try
   for I := 0 to lstMyList.Count - 1 do
    begin
     if lstCMyList.Items[I].Selected then
      begin
       Writeln (F, lstMyList.Items[I].Proxy);
       Inc (J);
      end;
    end;
  finally
   CloseFile (F);
  end;

  DeleteSelectedProxies1Click (nil);

  frmSentry.StatusBar.Panels[0].Text := 'Added ' + IntToStr (J) + ' Proxies To Blacklist';
end;

procedure TfrmListsProxylist.SendToHTTPDebugger1Click(Sender: TObject);
var ChangeFrameRecord: PChangeFrame;

begin
  if lstCMyList.ItemIndex <> -1 then
   begin
    IniFileWriteString (strLocPath + 'Settings.ini', 'Debugger', 'Proxy', lstMyList.Items[lstCMyList.ItemIndex].WriteToString);

    // Send a message to the main form to change the page
    New (ChangeFrameRecord);
    ChangeFrameRecord^.iCurrentFrame := INDEX_LISTS_PROXYLIST;
    ChangeFrameRecord^.iDisplayFrame := INDEX_TOOLS_HTTPDEBUGGER;
    PostMessage (frmSentry.Handle, TH_MESSAGE, TH_CHANGE_FRAME, Integer (ChangeFrameRecord));
   end;
end;

end.
