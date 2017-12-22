unit uFrameSettingsGeneral;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ComCtrls, Buttons, StdCtrls, uIPBot, HttpProt, WSocket, ExtCtrls,
  pngimage;

type
  TfrmSettingsGeneral = class(TFrame)
    Label10: TLabel;
    txtTimeout: TEdit;
    Label11: TLabel;
    Label1: TLabel;
    Bevel1: TBevel;
    chkResolveHost: TCheckBox;
    Image1: TImage;
    chkDebug: TCheckBox;
    chkFloatStatistics: TCheckBox;
    chkDebugMemo: TCheckBox;
    chkSnapShots: TCheckBox;
    Label78: TLabel;
    Label79: TLabel;
    Label80: TLabel;
    chkMinimizeTray: TCheckBox;
    cmdLoadSnapShot: TSpeedButton;
    Label2: TLabel;
    Bevel2: TBevel;
    cmdSaveSnapShot: TSpeedButton;
    procedure chkMinimizeTrayClick(Sender: TObject);
    procedure cmdLoadSnapShotClick(Sender: TObject);
    procedure cmdSaveSnapShotClick(Sender: TObject);
  private
    procedure AHttpCliRequestDone(Sender: TObject; RqType: THttpRequest; Error: Word);
    procedure CopyKeywordFileFromSnapShot(const strSnapShot, strKeywordFileName: string);
    procedure CopyKeywordFileToSnapShot(const strSnapShot, strKeywordFileName: string);
    procedure LoadUIFromSnapShot(const strSnapShot: string);
    procedure SaveUIToSnapShot(const strSnapShot: string);
  public
    procedure LoadVariables;
    procedure SaveVariables;
    procedure GetExternalIP;
  end;

implementation

uses ufrmMain, IniFiles, FastStrings, FastStringFuncs, uFunctions;

{$R *.dfm}

procedure TfrmSettingsGeneral.LoadVariables;
var IniFile: TIniFile;

begin
  if frmSentry.IP = '' then
   begin
    if frmSentry.GetExternal then
     GetExternalIP
    else
     frmSentry.IP := WSocket.LocalIPList[0];
   end;

  IniFile := TIniFile.Create (strLocPath + 'Settings.ini');

  try
   with IniFile do
    begin
     txtTimeout.Text := ReadString ('Settings', 'Timeout', '10');
     chkResolveHost.Checked := ReadBool ('Settings', 'ResolveHost', False);
     chkDebug.Checked := ReadBool ('Settings', 'Debug', False);
     chkFloatStatistics.Checked := ReadBool ('Settings', 'FloatStat', True);
     chkDebugMemo.Checked := ReadBool ('Settings', 'DebugMemo', False);
     chkSnapShots.Checked := ReadBool ('Settings', 'SnapShots', True);
     chkMinimizeTray.Checked := ReadBool ('Global', 'MinimizeTray', False);
    end;
  finally
   IniFile.Free;
  end;
end;

procedure TfrmSettingsGeneral.SaveVariables;
var IniFile: TIniFile;

begin
  IniFile := TIniFile.Create (strLocPath + 'Settings.ini');

  try
   with IniFile do
    begin
     WriteBool ('Global', 'MinimizeTray', chkMinimizeTray.Checked);

     WriteString ('Settings', 'Timeout', txtTimeout.Text);
     WriteBool ('Settings', 'ResolveHost', chkResolveHost.Checked);
     WriteBool ('Settings', 'Debug', chkDebug.Checked);
     WriteBool ('Settings', 'FloatStat', chkFloatStatistics.Checked);
     WriteBool ('Settings', 'DebugMemo', chkDebugMemo.Checked);
     WriteBool ('Settings', 'SnapShots', chkSnapShots.Checked);
    end;
  finally
   IniFile.Free;
  end;
end;

procedure TfrmSettingsGeneral.GetExternalIP;
var AHttpCli: TIPBot;

begin
  AHttpCli := TIPBot.Create (nil);

  AHttpCli.OnRequestDone := AHttpCliRequestDone;
  AHttpCli.GetASync;
end;

procedure TfrmSettingsGeneral.AHttpCliRequestDone(Sender: TObject; RqType: THttpRequest; Error: Word);
var AHttpCli: TIPBot;

begin
  AHttpCli := Sender as TIPBot;

  if AHttpCli.StatusCode = 200 then
   frmSentry.IP := AHttpCli.IP
  else
   frmSentry.StatusBar.Panels[0].Text := AHttpCli.Status;

  AHttpCli.Free;
end;

procedure TfrmSettingsGeneral.chkMinimizeTrayClick(Sender: TObject);
begin
  frmSentry.TrayIcon.Active := chkMinimizeTray.Checked;
end;

// Looks for SnapShot's Keyword File. If it exists, then it replaces Setting's
// Keyword File with the SnapShot one.
procedure TfrmSettingsGeneral.CopyKeywordFileToSnapShot(const strSnapShot, strKeywordFileName: string);
var strSnapShotPath: string;

begin
  strSnapShotPath := RemoveExtension (strSnapShot) + '-' + strKeywordFileName;
  if FileExists (strLocPath + strKeywordFileName) then
   CopyFile (PChar (strLocPath + strKeywordFileName), PChar (strSnapShotPath), False);
end;

// Looks for Setting's Keyword File. If it exists, then it replaces SnapShot's
// Keyword File with the Setting one.
procedure TfrmSettingsGeneral.CopyKeywordFileFromSnapShot(const strSnapShot, strKeywordFileName: string);
var strSnapShotPath: string;

begin
  strSnapShotPath := RemoveExtension (strSnapShot) + '-' + strKeywordFileName;
  if FileExists (strSnapShotPath) then
   CopyFile (PChar (strSnapShotPath), PChar (strLocPath + strKeywordFileName), False);
end;

// Copies over Setting's Files with SnapShot Files
procedure TfrmSettingsGeneral.LoadUIFromSnapShot(const strSnapShot: string);
var IniFileSnapShot, IniFileSettings: TIniFile;
    I, J: integer;
    lstSections, lstValues: TStringList;

begin
  IniFileSnapShot := TIniFile.Create (strSnapShot);
  IniFileSettings := TIniFile.Create (strLocPath + 'Settings.ini');
  lstSections := TStringList.Create;
  lstValues := TStringList.Create;
  try
   IniFileSnapShot.ReadSections (lstSections);

   for I := 0 to lstSections.Count - 1 do
    begin
     if SameText (lstSections.Strings[I], 'Wordlist') then
      Continue;
      
     IniFileSnapShot.ReadSectionValues (lstSections.Strings[I], lstValues);

     for J := 0 to lstValues.Count - 1 do
      IniFileSettings.WriteString (lstSections.Strings[I], lstValues.Names[J], lstValues.ValueFromIndex[J]);
    end;
  finally
   IniFileSnapShot.Free;
   IniFileSettings.Free;
   lstSections.Free;
   lstValues.Free;
  end;

  // Copy Keyword IniFiles
  CopyKeywordFileFromSnapShot (strSnapShot, 'HeaderFail.ini');
  CopyKeywordFileFromSnapShot (strSnapShot, 'HeaderSuccess.ini');
  CopyKeywordFileFromSnapShot (strSnapShot, 'HeaderRetry.ini');
  CopyKeywordFileFromSnapShot (strSnapShot, 'SourceBan.ini');
  CopyKeywordFileFromSnapShot (strSnapShot, 'SourceFail.ini');
  CopyKeywordFileFromSnapShot (strSnapShot, 'SourceSuccess.ini');
end;

// Copies over SnapShot Files with Setting's Files
procedure TfrmSettingsGeneral.SaveUIToSnapShot(const strSnapShot: string);
begin
  // Copy Settings
  CopyFile (PChar (strLocPath + 'Settings.ini'), PChar (strSnapShot), False);

  // Copy Keyword IniFiles
  CopyKeywordFileToSnapShot (strSnapShot, 'HeaderFail.ini');
  CopyKeywordFileToSnapShot (strSnapShot, 'HeaderSuccess.ini');
  CopyKeywordFileToSnapShot (strSnapShot, 'HeaderRetry.ini');
  CopyKeywordFileToSnapShot (strSnapShot, 'SourceBan.ini');
  CopyKeywordFileToSnapShot (strSnapShot, 'SourceFail.ini');
  CopyKeywordFileToSnapShot (strSnapShot, 'SourceSuccess.ini');
end;

procedure TfrmSettingsGeneral.cmdLoadSnapShotClick(Sender: TObject);
begin
  frmSentry.OpenDialog.Filter := 'INI Files (*.ini)|*.ini|Any File (*.*)|*.*';

  if frmSentry.OpenDialog.Execute then
   begin
    LoadUIFromSnapShot (frmSentry.OpenDialog.FileName);
    LoadVariables;

    frmSentry.StatusBar.Panels[0].Text := 'Loaded ' + ExtractFileName (frmSentry.OpenDialog.FileName) + ' Snap Shot';
   end;

  frmSentry.OpenDialog.Filter := 'Text Files (*.txt)|*.txt|Any File (*.*)|*.*';
end;

procedure TfrmSettingsGeneral.cmdSaveSnapShotClick(Sender: TObject);
begin
  frmSentry.SaveDialog.Filter := 'INI Files (*.ini)|*.ini|Any File (*.*)|*.*';

  if frmSentry.SaveDialog.Execute then
   begin
    SaveVariables;
    SaveUIToSnapShot (frmSentry.SaveDialog.FileName);
    frmSentry.StatusBar.Panels[0].Text := 'Saved ' + ExtractFileName (frmSentry.SaveDialog.FileName) + ' Snap Shot';
   end;

  frmSentry.SaveDialog.Filter := 'Text Files (*.txt)|*.txt|Any File (*.*)|*.*';
end;

end.
