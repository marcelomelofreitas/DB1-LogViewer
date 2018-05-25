program spMonitor4;

uses
  Vcl.Forms,
  View.Monitor in 'View.Monitor.pas' {fMonitor},
  Utils.Preferencias in 'Utils.Preferencias.pas',
  Utils.Helpers in 'Utils.Helpers.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'spMonitor4';
  Application.CreateForm(TfMonitor, fMonitor);
  Application.Run;
end.
