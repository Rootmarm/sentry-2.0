unit uFrameAboutAboutSentry;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, JvExControls, JvComponent, JvScrollText, ExtCtrls, StdCtrls,
  pngimage;

type
  TfrmAboutAboutSentry = class(TFrame)
    Label2: TLabel;
    Bevel1: TBevel;
    Panel1: TPanel;
    ScrollText: TJvScrollText;
    GroupBox32: TGroupBox;
    lblWebpage: TLabel;
    lblWebpage2: TLabel;
    imgSecuribox: TImage;
    imgDeny: TImage;
    imgICE: TImage;
    procedure lblWebpageClick(Sender: TObject);
    procedure lblWebpageMouseEnter(Sender: TObject);
    procedure lblWebpageMouseLeave(Sender: TObject);
    procedure imgSecuriboxClick(Sender: TObject);
    procedure imgICEClick(Sender: TObject);
    procedure imgDenyClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses uFunctions, ShellAPI, ufrmMain;

procedure TfrmAboutAboutSentry.lblWebpageClick(Sender: TObject);
const bmpIE = 4;
      bmpFIREFOX = 12;
      bmpOPERA = 13;

var I: integer;

begin
  I := IniFileReadInteger (strLocPath + 'Settings.ini', 'Integration', 'BrowserIndex', bmpIE);

  with Sender as TLabel do
   LaunchSite (Caption, I);
end;

procedure TfrmAboutAboutSentry.lblWebpageMouseEnter(Sender: TObject);
begin
   with Sender as TLabel do
    Font.Style := [fsBold, fsUnderline];
end;

procedure TfrmAboutAboutSentry.lblWebpageMouseLeave(Sender: TObject);
begin
   with Sender as TLabel do
    Font.Style := [fsBold];
end;

procedure TfrmAboutAboutSentry.imgSecuriboxClick(Sender: TObject);
const SECURIBOX_URL = 'http://www.securibox.net';

begin
  ShellExecute (0, 'open', SECURIBOX_URL, nil, 'C:\', 1)
end;

procedure TfrmAboutAboutSentry.imgICEClick(Sender: TObject);
const ICE_URL = 'http://www.icefortress.com';

begin
  ShellExecute (0, 'open', ICE_URL, nil, 'C:\', 1)
end;

procedure TfrmAboutAboutSentry.imgDenyClick(Sender: TObject);
const DENY_URL = 'http://deny.de';

begin
  ShellExecute (0, 'open', DENY_URL, nil, 'C:\', 1)
end;

end.
