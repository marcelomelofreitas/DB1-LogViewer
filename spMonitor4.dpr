program spMonitor4;

uses
  Vcl.Forms,
  View.Monitor in 'View.Monitor.pas' {fMonitor},
  Utils.Preferencias in 'Utils.Preferencias.pas',
  Utils.Helpers in 'Utils.Helpers.pas',
  Utils.Constantes in 'Utils.Constantes.pas',
  Utils.FormatadorSQL in 'Utils.FormatadorSQL.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'spMonitor4';
  Application.CreateForm(TfMonitor, fMonitor);
  Application.Run;
end.
