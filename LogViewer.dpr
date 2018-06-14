program LogViewer;

uses
  Vcl.Forms,
  View.Monitor in 'View.Monitor.pas' {fMonitor},
  Utils.Options in 'Utils.Options.pas',
  Utils.Helpers in 'Utils.Helpers.pas',
  Utils.Constants in 'Utils.Constants.pas',
  Utils.SQLFormatter in 'Utils.SQLFormatter.pas',
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Aqua Light Slate');
  Application.Title := 'DB1 Log Viewer';
  Application.CreateForm(TfMonitor, fMonitor);
  ReportMemoryLeaksOnShutdown := True;
  Application.Run;
end.
