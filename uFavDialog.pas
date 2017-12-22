// Coded By Sentinel
//
// Adds a Favorite ComboBox to Open and Save Dialogs
// where a user can add folders later for easy navigation.
// Uses JCL V 1.90
unit uFavDialog;

interface

uses
  SysUtils, Classes, Dialogs, OpenDlgFavAdapter;

type
  TFavoriteDialog = class(TFavOpenDialog)
  private
    FFavOpenDialog: TFavOpenDialog;
    FIniFileName: string;
    procedure DialogClose(Sender: TObject);
    procedure DialogShow(Sender: TObject);
  public
    constructor Create;
    destructor  Destroy; override;
  published
    property IniFileName            : string        read  FIniFileName
                                                    write FIniFileName;
  end;

implementation

constructor TFavoriteDialog.Create;
begin
  inherited Create;

  FFavOpenDialog := InitializeFavOpenDialog;
  FFavOpenDialog.DisableHelpButton := True;
  FFavOpenDialog.HookDialogs;
  FFavOpenDialog.OnClose := DialogClose;
  FFavOpenDialog.OnShow := DialogShow;
  FIniFileName := ExtractFilePath (ParamStr (0)) + 'Fav.ini';
end;

//--------------------------------------------------------------------------------------------------

destructor TFavoriteDialog.Destroy;
begin
  FFavOpenDialog.UnhookDialogs;
  inherited;
end;

//--------------------------------------------------------------------------------------------------

procedure TFavoriteDialog.DialogClose(Sender: TObject);
begin
  if FIniFileName <> '' then
   FFavOpenDialog.FavoriteFolders.SaveToFile (FIniFileName);
end;

//--------------------------------------------------------------------------------------------------

procedure TFavoriteDialog.DialogShow(Sender: TObject);
begin
  FFavOpenDialog.LoadFavorites (FIniFileName);
end;

//--------------------------------------------------------------------------------------------------

var F: TFavoriteDialog;

initialization
  F := TFavoriteDialog.Create;
finalization
  F.Free;
end.
