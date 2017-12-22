unit ufrmDebugEngine;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, uBruteForcer, uKeywordBot, uFormBot, uBasicBot;

type
  TfrmDebugEngine = class(TForm)
    memDebugEngine: TMemo;
    cmdRefresh: TButton;
    cmdClose: TButton;
    procedure FormShow(Sender: TObject);
    procedure cmdRefreshClick(Sender: TObject);
    procedure cmdCloseClick(Sender: TObject);
  private
    FBruteForcer: TBruteForcer;

    function  GetRequestMethod: string;
    procedure DisplayBotData(AHttpCli: TKeywordBot);
    procedure DisplayEngineData;
  public
    property BruteForcer: TBruteForcer read FBruteForcer write FBruteForcer;
  end;

implementation

{$R *.dfm}

uses FastStrings, FastStringFuncs, uFunctions, DateUtils;

function TfrmDebugEngine.GetRequestMethod: string;
begin
  case FBruteForcer.RequestMethod of
    rgHEAD: Result := 'HEAD';
    rgGET: Result := 'GET';
    rgPOST: Result := 'POST';
  end;
end;

procedure TfrmDebugEngine.DisplayBotData(AHttpCli: TKeywordBot);

begin
  with memDebugEngine.Lines, AHttpCli do
   begin
    // Display Common properties between Basic Bot and Form Bot
    Add ('Proxy: ' + Proxy + ':' + ProxyPort);
    Add ('Username: ' + Username);
    Add ('Password: ' + Password);
    Add ('Cookie: ' + Cookie);
    Add ('Header: ' + AHttpCli.SentHeader);

    if FBruteForcer.RequestMethod = rgPOST then
     begin
      with AHttpCli as TFormBot do
       begin
        Add ('Form Cookie: ' + FormCookie);
        Add ('Form Referer: ' + FormReferer);
        Add ('Form URL: ' + FormURL);
        Add ('POST Data: ' + POSTData);
        Add ('------- Form Data -------');
        Add ('Cookie: ' + FormData^.Cookie);
        Add ('Action: ' + FormData^.Action);
        Add ('Username: ' + FormData^.Username);
        Add ('Password: ' + FormData^.Password);
        Add ('Additional Data: ' + FormData^.AddData);
       end;
     end;
   end;
end;

procedure TfrmDebugEngine.DisplayEngineData;
var I: integer;
    lstBots: TList;

begin
  memDebugEngine.Clear;

  with FBruteForcer, memDebugEngine.Lines do
   begin
    if Assigned (BanKeywords) then
     Add ('Ban Keywords: ' + FastReplace (BanKeywords.Text, #13#10, ';'));
    Add ('Bots: ' + IntToStr (Bots));
    Add ('Constrain Hits: ' + IntToStr (ConstrainHits));
    Add ('Custom Header: ' + FastReplace (CustomHeader, #13#10, ';'));
    Add ('Enable AfterFingerPrint: ' + BoolToStr (EnableAfterFP, True));
    Add ('Enable Check Hits With Another Proxy: ' + BoolToStr (EnableCheckHits, True));
    Add ('Enable Combo Constraints: ' + BoolToStr (EnableComboConstraints, True));
    Add ('Enable Meta Redirects: ' + BoolToStr (EnableMetaRedirects, True));
    Add ('Enable Resolve Host: ' + BoolToStr (EnableResolveHost, True));
    Add ('Follow Redirects: ' + BoolToStr (FollowRedirects, True));
    Add ('Form Action: ' + FormAction);
    Add ('Form Cookie (Used To Get Form Data): ' + FormCookie);
    Add ('Form Referer (Used To Get Form Data): ' + FormReferer);
    Add ('Form URL: ' + FormURL);
    Add ('Header Failure Keys: ' + HeaderFailureKeys);
    if Assigned (HeaderRetryCodes) then
     Add ('Header Retry Codes: ' + FastReplace (HeaderRetryCodes.Text, #13#10, ';'));
    Add ('Header Success Keys: ' + HeaderSuccessKeys);
    Add ('Proxies Active: ' + IntToStr (MyList.Active));
    Add ('Proxies Banned: ' + IntToStr (MyList.Banned));
    Add ('Proxies Disabled: ' + IntToStr (MyList.Disabled));
    Add ('Password Max: ' + IntToStr (PasswordMax));
    Add ('Password Min: ' + IntToStr (PasswordMin));
    Add ('Wordlist Position: ' + IntToStr (Position));
    Add ('POST Data: ' + POSTData);
    Add ('Reactivate Proxies When <=: ' + IntToStr (ProxiesActive));
    Add ('Refresh Session Data: ' + BoolToStr (RefreshSession, True));
    Add ('Request Method: ' + GetRequestMethod);
    Add ('Required Content-Length: ' + IntToStr (RequiredLength));
    Add ('Source Failure Keywords: ' + SourceFailureKeys);
    Add ('Timeout: ' + IntToStr (Timeout));
    Add ('URL: ' + URL);
    if Assigned (UserAgentList) then
     Add ('User-Agents: ' + FastReplace (UserAgentList.Text, #13#10, ';'));
    Add ('Username Max: ' + IntToStr (UsernameMax));
    Add ('Username Min: ' + IntToStr (UsernameMin));
    Add ('Wordlist: ' + Wordlist.Wordlist);
    Add ('');
    Add (CreateHeader ('Dumping Bot Data'));

    lstBots := GetBots;
    try
     for I := 0 to lstBots.Count - 1 do
      begin
       Add (CreateHeader ('Bot ' + IntToStr (I + 1)));
       DisplayBotData (TKeywordBot (lstBots.Items[I]));
      end;
    finally
     lstBots.Free;
    end;
   end;
end;

procedure TfrmDebugEngine.FormShow(Sender: TObject);
begin
  if Assigned (FBruteForcer) then
   DisplayEngineData;
end;

procedure TfrmDebugEngine.cmdRefreshClick(Sender: TObject);
begin
  try
   FormShow (nil);
  except
    MessageDlg ('Cannot Refresh - Engine has already been stopped.', mtWarning, [mbOK], 0);
  end;
end;

procedure TfrmDebugEngine.cmdCloseClick(Sender: TObject);
begin
  Self.Close;
end;

end.
