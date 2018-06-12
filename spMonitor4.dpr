program spMonitor4;

uses
  Vcl.Forms,
  View.Monitor in 'View.Monitor.pas' {fMonitor},
  Utils.Options in 'Utils.Options.pas',
  Utils.Helpers in 'Utils.Helpers.pas',
  Utils.Constants in 'Utils.Constants.pas',
  Utils.SQLFormatter in 'Utils.SQLFormatter.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'spMonitor4';
  Application.CreateForm(TfMonitor, fMonitor);
  Application.Run;
end.
