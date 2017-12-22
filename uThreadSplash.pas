unit uThreadSplash;

interface

uses Classes, ufrmSplash;

type
  TSplashThread = class(TThread)
  private
    SplashScreen: TfrmSplash;
  public
    procedure Execute; override;
    procedure DisplaySplash;
  end;

implementation

uses Windows;

// ---------------- TSplashThread ------------------- \\

procedure TSplashThread.Execute;
begin
  Synchronize (DisplaySplash);

  Sleep (2000);
  SplashScreen.Release;

  inherited;
end;

procedure TSplashThread.DisplaySplash;
begin
  SplashScreen := TfrmSplash.Create (nil);

  SplashScreen.Show;
  SplashScreen.Update;
end;

end.
