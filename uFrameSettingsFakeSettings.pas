unit uFrameSettingsFakeSettings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmSettingsFakeSettings = class(TFrame)
    Label1: TLabel;
    Bevel2: TBevel;
    chkConstrainHits: TCheckBox;
    Label2: TLabel;
    txtConstrainHits: TEdit;
    chkAfterFP: TCheckBox;
    chkCheckHits: TCheckBox;
    chkMetaRedirect: TCheckBox;
    chkFollowRedirects: TCheckBox;
    chkContentLength: TCheckBox;
    Label3: TLabel;
    txtContentLength: TEdit;
    Label4: TLabel;
  private
    { Private declarations }
  public
    procedure LoadVariables;
    procedure SaveVariables;
  end;

implementation

{$R *.dfm}

uses IniFiles, ufrmMain;

procedure TfrmSettingsFakeSettings.LoadVariables;
var IniFile: TIniFile;

begin
  IniFile := TIniFile.Create (strLocPath + 'Settings.ini');
  try
   with IniFile do
    begin
     chkAfterFP.Checked := ReadBool ('Fake', 'AfterFP', True);
     chkCheckHits.Checked := ReadBool ('Fake', 'CheckHits', False);
     chkMetaRedirect.Checked := ReadBool ('Fake', 'MetaRedirect', False);
     chkFollowRedirects.Checked := ReadBool ('Fake', 'FollowRedirect', False);
     chkConstrainHits.Checked := ReadBool ('Fake', 'EnableConHits', False);
     txtConstrainHits.Text := ReadString ('Fake', 'ConHits', '10');
     chkContentLength.Checked := ReadBool ('Fake', 'EnableConLength', False);
     txtContentLength.Text := ReadString ('Fake', 'ConLength', '200');
    end;
  finally
   IniFile.Free;
  end;
end;

procedure TfrmSettingsFakeSettings.SaveVariables;
var IniFile: TIniFile;

begin
  IniFile := TIniFile.Create (strLocPath + 'Settings.ini');
  try
   with IniFile do
    begin
     WriteBool ('Fake', 'AfterFP', chkAfterFP.Checked);
     WriteBool ('Fake', 'CheckHits', chkCheckHits.Checked);
     WriteBool ('Fake', 'MetaRedirect', chkMetaRedirect.Checked);
     WriteBool ('Fake', 'FollowRedirect', chkFollowRedirects.Checked);
     WriteBool ('Fake', 'EnableConHits', chkConstrainHits.Checked);
     WriteString ('Fake', 'ConHits', txtConstrainHits.Text);
     WriteBool ('Fake', 'EnableConLength', chkContentLength.Checked);
     WriteString ('Fake', 'ConLength', txtContentLength.Text);
    end;
  finally
   IniFile.Free;
  end;
end;

end.
