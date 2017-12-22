unit uFrameSettingsProxySettings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ExtCtrls, StdCtrls;

type
  TfrmSettingsProxySettings = class(TFrame)
    Label71: TLabel;
    txtProxyActivate: TEdit;
    Label2: TLabel;
    Bevel1: TBevel;
  private
    { Private declarations }
  public
    procedure LoadVariables;
    procedure SaveVariables;
  end;

implementation

{$R *.dfm}

uses IniFiles, ufrmMain;

procedure TfrmSettingsProxySettings.LoadVariables;
var IniFile: TIniFile;

begin
  IniFile := TIniFile.Create (strLocPath + 'Settings.ini');
  try
   with IniFile do
    begin
     txtProxyActivate.Text := ReadString ('Settings', 'ProxyActivate', '10');
    end;
  finally
   IniFile.Free;
  end;
end;

procedure TfrmSettingsProxySettings.SaveVariables;
var IniFile: TIniFile;

begin
  IniFile := TIniFile.Create (strLocPath + 'Settings.ini');
  try
   with IniFile do
    begin
     WriteString ('Settings', 'ProxyActivate', txtProxyActivate.Text);
    end;
  finally
   IniFile.Free;
  end;
end;


end.
