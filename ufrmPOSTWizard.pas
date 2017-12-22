unit ufrmPOSTWizard;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, uVTHttpWrapper, HttpProt, StdCtrls, ExtCtrls;

type
  TfrmPOSTWizard = class(TForm)
    Label6: TLabel;
    txtAction: TEdit;
    txtUsername: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    txtPassword: TEdit;
    Label7: TLabel;
    txtAddData: TEdit;
    txtCookie: TEdit;
    Label8: TLabel;
    Bevel2: TBevel;
    cmdAnalyze: TButton;
    cmdClear: TButton;
    cmdUse: TButton;
    chkRefreshSession: TCheckBox;
    Label1: TLabel;
    txtFormCookie: TEdit;
    txtFormReferer: TEdit;
    Label2: TLabel;
    Label5: TLabel;
    Bevel1: TBevel;
    procedure cmdClearClick(Sender: TObject);
    procedure cmdAnalyzeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    procedure AHttpCliAnalyzeRequestDone(Sender: TObject; RqType: THttpRequest; Error: Word);
  public
    { Public declarations }
  end;

implementation

uses ufrmMain, FastStrings, FastStringFuncs, uFormParserBot, uFormParser,
     uFrameSettingsHTTPHeader, IniFiles;

{$R *.dfm}

procedure TfrmPOSTWizard.cmdClearClick(Sender: TObject);
begin
  txtAction.Text := '';
  txtUsername.Text := '';
  txtPassword.Text := '';
  txtAddData.Text := '';
  txtCookie.Text := '';
end;

procedure TfrmPOSTWizard.cmdAnalyzeClick(Sender: TObject);
var AHttpCli: TFormParserBot;

begin
  cmdClearClick (nil);
  AHttpCli := TFormParserBot.Create (nil);
  AHttpCli.FollowRedirects := True;
  AHttpCli.FormURL := frmSentry.cboSite.Text;
  AHttpCli.Reference := txtFormReferer.Text;
  AHttpCli.Cookie := txtFormCookie.Text;

//  if (blnExtProxy) and (Assigned (lstMyList)) then
//   begin
//    I := RandomRange (0, lstMyList.Count);
//    AHttpCli.Proxy := lstMyList.Items[I].Proxy;
//    AHttpCli.ProxyPort := lstMyList.Items[I].Port;
//   end;

  AHttpCli.OnRequestDone := AHttpCliAnalyzeRequestDone;
  AHttpCli.GetASync;
end;

procedure TfrmPOSTWizard.AHttpCliAnalyzeRequestDone(Sender: TObject; RqType: THttpRequest; Error: Word);
var AHttpCli: TFormParserBot;

begin
  AHttpCli := Sender as TFormParserBot;

  if AHttpCli.StatusCode = 200 then
   begin
    AHttpCli.ParseForm;

    with AHttpCli.FormData^ do
     begin
      txtAction.Text := Action;
      txtUsername.Text := Username;
      txtPassword.Text := Password;
      txtAddData.Text := AddData;
      txtCookie.Text := Cookie;
     end;
   end
  else
   MessageDlg (AHttpCli.Status, mtInformation, [mbOK], 0);

  AHttpCli.Free;
end;

procedure TfrmPOSTWizard.FormCreate(Sender: TObject);
var IniFile: TIniFile;

begin
  IniFile := TIniFile.Create (strLocPath + 'Settings.ini');
  try
   with IniFile do
    begin
     txtAction.Text := ReadString ('Form', 'Action', '');
     txtUsername.Text := ReadString ('Form', 'Username', '');
     txtPassword.Text := ReadString ('Form', 'Password', '');
     txtAddData.Text := ReadString ('Form', 'AddData', '');
     txtCookie.Text := ReadString ('Form', 'Cookie', '');
     txtFormReferer.Text := ReadString ('Form', 'ReqReferer', '');
     txtFormCookie.Text := ReadString ('Form', 'ReqCookie', '');
     chkRefreshSession.Checked := ReadBool ('Form', 'RefreshSession', False);
    end;
  finally
   IniFile.Free;
  end;

  if txtAction.Text = '' then
   cmdAnalyzeClick (nil);
end;

procedure TfrmPOSTWizard.FormClose(Sender: TObject; var Action: TCloseAction);
var FFormData: PFormData;
    IniFile: TIniFile;

begin
  New (FFormData);
  try
   with frmSentry.frmSettingsHTTPHeader, FFormData^ do
    begin
     Action := txtAction.Text;
     Username := txtUsername.Text;
     Password := txtPassword.Text;
     AddData := txtAddData.Text;

     cmdBuildHeaderClick (nil);
     if (txtCookie.Text <> '') and (chkRefreshSession.Checked = False) then
      memHeader.Lines.Add ('Cookie: ' + txtCookie.Text);

     txtPOSTData.Text := BuildPOSTData (FFormData);
    end;
  finally
   Dispose (FFormData);
  end;

  IniFile := TIniFile.Create (strLocPath + 'Settings.ini');
  try
   with IniFile do
    begin
     // Not used by the Form Engine
     WriteString ('Form', 'Username', txtUsername.Text);
     WriteString ('Form', 'Password', txtPassword.Text);
     WriteString ('Form', 'AddData', txtAddData.Text);
     WriteString ('Form', 'Cookie', txtCookie.Text);
     // Used by the Form Engine
     WriteString ('Form', 'Action', txtAction.Text);
     WriteString ('Form', 'ReqReferer', txtFormReferer.Text);
     WriteString ('Form', 'ReqCookie', txtFormCookie.Text);
     WriteBool ('Form', 'RefreshSession', chkRefreshSession.Checked);
    end;
  finally
   IniFile.Free;
  end;
end;

end.
