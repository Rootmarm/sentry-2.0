unit uSnapShot;

interface

uses Classes, uBruteForcer;

type
  TSnapShot = class(TObject)
  private
    FDomain: string;
    FSnapShotFile: string;
    FWordlist: string;
    FWordlistPosition: integer;
    FBruteForcer: TBruteForcer; // Pointer to the BruteForcer Engine
    FOnSnapShotDoesNotExist: TNotifyEvent;
    FOnSnapShotExists: TNotifyEvent;
    FOnWordlistPositionExists: TNotifyEvent;

    function  ExtractWordlistName(const strWordlist: string): string;
    function  SaveKeywordsToFile(const strFileName, strKeywords: string): string;
    procedure TriggerSnapShotDoesNotExist;
    procedure TriggerSnapShotExists;
    procedure TriggerWordlistPositionExists;
  public
    constructor Create(const strFile: string); overload;
    constructor Create(pBruteForcer: TBruteForcer; const strURL: string); overload;
    procedure   Initialize;
    procedure   SaveSettings;

    property Domain: string read FDomain;
    property Wordlist: string read FWordlist;
    property WordlistPosition: integer read FWordlistPosition write FWordlistPosition;
    property OnSnapShotDoesNotExist: TNotifyEvent read FOnSnapShotDoesNotExist write FOnSnapShotDoesNotExist;
    property OnSnapShotExists: TNotifyEvent read FOnSnapShotExists write FOnSnapShotExists;
    property OnWordlistPositionExists: TNotifyEvent read FOnWordlistPositionExists write FOnWordlistPositionExists;
  end;

implementation

uses SysUtils, FastStrings, FastStringFuncs, uFunctions, IniFiles, Dialogs;

constructor TSnapShot.Create(const strFile: string);
begin
  inherited Create;

  FSnapShotFile := strFile;
end;

constructor TSnapShot.Create(pBruteForcer: TBruteForcer; const strURL: string);
begin
  inherited Create;

  FBruteForcer := pBruteForcer;

  // Remove www. prefix from Domain
  FDomain := FastReplace (GetDomain (strURL), 'www.', '');
  FSnapShotFile := ExtractFilePath (ParamStr (0)) + 'SnapShots\' + FDomain + '.ini';
end;

procedure TSnapShot.Initialize;
begin
  if FileExists (FSnapShotFile) then
   begin
    // Look for Wordlist in current snapshot
    FWordlist := ExtractWordlistName (IniFileReadString (ExtractFilePath (ParamStr (0)) + 'Settings.ini', 'Lists', 'Wordlist', ''));
    FWordlistPosition := IniFileReadInteger (FSnapShotFile, 'Wordlist', FWordlist, 0);
    if FWordlistPosition > 0 then
     TriggerWordlistPositionExists
    else
     TriggerSnapShotExists;
   end
  else
   begin
    if DirectoryExists (ExtractFilePath (FSnapShotFile)) = False then
     begin
      if CreateDir (ExtractFilePath (FSnapShotFile)) = False then
       MessageDlg('Error Creating Directory: ' + ExtractFilePath (FSnapShotFile), mtError, [mbOK], 0);
     end;
     
    TriggerSnapShotDoesNotExist;
   end;
end;

function TSnapShot.ExtractWordlistName(const strWordlist: string): string;
var strTmp: string;

begin
  if strWordlist = '' then
   Result := ''
  else
   begin
    strTmp := ExtractFileName (strWordlist);
    Result := RemoveExtension (strTmp);
   end;
end;

// Takes a string of keywords delimited by a ';' and saves them to a file
// in list format
function TSnapShot.SaveKeywordsToFile(const strFileName, strKeywords: string): string;
var F: TextFile;

begin
  if strKeywords <> '' then
   begin
    AssignFile (F, strFileName);
    Rewrite (F);

    try
     Writeln (F, FastReplace (strKeywords, ';', #13#10));
    finally
     CloseFile (F);
    end;
   end;
end;

procedure TSnapShot.SaveSettings;
var IniFile: TIniFile;
    strPath: string;

begin
  strPath := ExtractFilePath (FSnapShotFile) + FDomain + '-';

  IniFile := TIniFile.Create (FSnapShotFile);
  try
   with IniFile, FBruteForcer do
    begin
     WriteInteger ('Settings', 'RequestMethod', RequestMethod);

     WriteBool ('Keywords', 'EnableHeaderRetry', Assigned (HeaderRetryCodes));
     if Assigned (HeaderRetryCodes) then
      HeaderRetryCodes.SaveToFile (strPath + 'HeaderRetry.ini')
     else
      DeleteFile (strPath + 'HeaderRetry.ini');

     WriteBool ('Keywords', 'EnableHeaderFail', (HeaderFailureKeys <> ''));
     SaveKeywordsToFile (strPath + 'HeaderFail.ini', HeaderFailureKeys);
     WriteBool ('Keywords', 'EnableHeaderSuccess', (HeaderSuccessKeys <> ''));
     SaveKeywordsToFile (strPath + 'HeaderSuccess.ini', HeaderSuccessKeys);

     WriteBool ('Keywords', 'EnableSourceBan', Assigned (BanKeywords));
     if Assigned (BanKeywords) then
      BanKeywords.SaveToFile (strPath + FDomain + 'SourceBan.ini')
     else
      DeleteFile (strPath + 'SourceBan.ini');

     WriteBool ('Keywords', 'EnableSourceFail', (SourceFailureKeys <> ''));
     SaveKeywordsToFile (strPath + 'SourceFail.ini', SourceFailureKeys);
     WriteBool ('Keywords', 'EnableSourceSuccess', (SourceSuccessKeys <> ''));
     SaveKeywordsToFile (strPath + 'SourceSuccess.ini', SourceSuccessKeys);
     WriteInteger ('Settings', 'Bots', Bots);
     WriteBool ('Fake', 'EnableConHits', (ConstrainHits > 0));
     WriteInteger ('Fake', 'ConHits', ConstrainHits);
     WriteString ('Settings', 'HTTPHeader', FastReplace (CustomHeader, #13#10, '|'));
     WriteBool ('Fake', 'AfterFP', EnableAfterFP);
     WriteBool ('Fake', 'CheckHits', EnableCheckHits);
     WriteBool ('Lists', 'LengthFilter', EnableComboConstraints);
     WriteBool ('Fake', 'MetaRedirect', EnableMetaRedirects);
     WriteBool ('Settings', 'ResolveHost', EnableResolveHost);
     WriteBool ('Fake', 'FollowRedirect', FollowRedirects);
     WriteInteger ('Lists', 'PasswordEnd', PasswordMax);
     WriteInteger ('Lists', 'PasswordStart', PasswordMin);
     WriteBool ('Fake', 'EnableConLength', (RequiredLength > -1));
     WriteInteger ('Fake', 'ConLength', RequiredLength);
     WriteInteger ('Settings', 'Timeout', Timeout);
     WriteInteger ('Lists', 'UsernameEnd', UsernameMax);
     WriteInteger ('Lists', 'UsernameStart', UsernameMin);
     WriteString ('Settings', 'POSTData', POSTData);
     WriteString ('Form', 'Action', FormAction);
     WriteString ('Form', 'ReqReferer', FormReferer);
     WriteString ('Form', 'ReqCookie', FormCookie);
     WriteBool ('Form', 'RefreshSession', RefreshSession);

     // Save Wordlist Information only if it is not at the end.
     // If at the end, then save a 0 which means start from beginning.
     if Position < FBruteForcer.Wordlist.Count then
      WriteInteger ('Wordlist', ExtractWordlistName (FBruteForcer.Wordlist.Wordlist), Position)
     else
      WriteInteger ('Wordlist', ExtractWordlistName (FBruteForcer.Wordlist.Wordlist), 0);
    end;
  finally
   IniFile.Free;
  end;
end;

procedure TSnapShot.TriggerSnapShotDoesNotExist;
begin
  if Assigned (FOnSnapShotDoesNotExist) then
   FOnSnapShotDoesNotExist (Self);
end;

procedure TSnapShot.TriggerSnapShotExists;
begin
  if Assigned (FOnSnapShotExists) then
   FOnSnapShotExists (Self);
end;

procedure TSnapShot.TriggerWordlistPositionExists;
begin
  if Assigned (FOnWordlistPositionExists) then
   FOnWordlistPositionExists (Self);
end;

end.
