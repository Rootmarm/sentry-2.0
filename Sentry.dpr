program Sentry;

uses
  Windows,
  Forms,
  ufrmMain in 'ufrmMain.pas' {frmSentry},
  ufrmSplash in 'ufrmSplash.pas' {frmSplash},
  uFrameSettingsGeneral in 'uFrameSettingsGeneral.pas' {frmSettingsGeneral: TFrame},
  uFrameListsWordlist in 'uFrameListsWordlist.pas' {frmListsWordlist: TFrame},
  uFrameListsProxylist in 'uFrameListsProxylist.pas' {frmListsProxylist: TFrame},
  uFrameSettingsHTTPHeader in 'uFrameSettingsHTTPHeader.pas' {frmSettingsHTTPHeader: TFrame},
  uFrameHistoryHistory in 'uFrameHistoryHistory.pas' {frmHistoryHistory: TFrame},
  uFrameHistoryOptions in 'uFrameHistoryOptions.pas' {frmHistoryOptions: TFrame},
  uFrameToolsProxyAnalyzer in 'uFrameToolsProxyAnalyzer.pas' {frmToolsProxyAnalyzer: TFrame},
  ufrmToolsProxyAnalyzerOptions in 'ufrmToolsProxyAnalyzerOptions.pas' {frmToolsProxyAnalyzerOptions},
  uFrameSettingsProxySettings in 'uFrameSettingsProxySettings.pas' {frmSettingsProxySettings: TFrame},
  uFrameSettingsIntegration in 'uFrameSettingsIntegration.pas' {frmSettingsIntegration: TFrame},
  ufrmPOSTWizard in 'ufrmPOSTWizard.pas' {frmPOSTWizard},
  uFrameToolsHTTPDebugger in 'uFrameToolsHTTPDebugger.pas' {frmToolsHTTPDebugger: TFrame},
  uThreadSplash in 'uThreadSplash.pas',
  ufrmQuickLaunch in 'ufrmQuickLaunch.pas' {frmQuickLaunch},
  uFrameProgressionProgression in 'uFrameProgressionProgression.pas' {frmProgressionProgression: TFrame},
  uFrameSettingsFakeSettings in 'uFrameSettingsFakeSettings.pas' {frmSettingsFakeSettings: TFrame},
  uFrameSettingsKeywords in 'uFrameSettingsKeywords.pas' {frmSettingsKeywords: TFrame},
  uFrameAboutAboutSentry in 'uFrameAboutAboutSentry.pas' {frmAboutAboutSentry: TFrame},
  ufrmDebugEngine in 'ufrmDebugEngine.pas' {frmDebugEngine},
  uFrameListsBlacklist in 'uFrameListsBlacklist.pas' {frmListsBlacklist: TFrame},
  uFrameToolsAutopilot in 'uFrameToolsAutopilot.pas' {frmToolsAutopilot: TFrame};

{$R *.res}

var SplashThread: TSplashThread;

begin
  if ParamStr (1) <> '-nosplash' then
   begin
    SplashThread := TSplashThread.Create (False);
    SplashThread.FreeOnTerminate := True;
    SplashThread.Resume;
   end;

  Application.Initialize;
  Application.CreateForm(TfrmSentry, frmSentry);
  Application.Run;
end.
