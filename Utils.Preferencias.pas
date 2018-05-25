unit Utils.Preferencias;

interface

uses
  IniFiles;

type
  TPreferencias = class
  private
    FArquivoINI: TIniFile;

    function GetHabilitarAtualizacaoAutomatica: boolean;
    function GetExibirSomenteSQL: boolean;
    function GetDestacarLinhasErro: boolean;
  public
    constructor Create;
    destructor Destroy; override;

    property HabilitarAtualizacaoAutomatica: boolean read GetHabilitarAtualizacaoAutomatica;
    property ExibirSomenteSQL: boolean read GetExibirSomenteSQL;
    property DestacarLinhasErro: boolean read GetDestacarLinhasErro;
  end;

implementation

uses
  System.SysUtils, Utils.Helpers;

{ TOpcoes }

constructor TPreferencias.Create;
begin
  FArquivoINI := TIniFile.Create(GetCurrentDir + '\spMonitor4.ini');
end;

destructor TPreferencias.Destroy;
begin
  FArquivoINI.Free;
  inherited;
end;

function TPreferencias.GetDestacarLinhasErro: boolean;
begin
  result := FArquivoINI.ReadValue('DestacarLinhasErro') = 'S';
end;

function TPreferencias.GetExibirSomenteSQL: boolean;
begin
  result := FArquivoINI.ReadValue('ExibirSomenteSQL') = 'S';
end;

function TPreferencias.GetHabilitarAtualizacaoAutomatica: boolean;
begin
  result := FArquivoINI.ReadValue('HabilitarAtualizacaoAutomatica') = 'S';
end;

end.
