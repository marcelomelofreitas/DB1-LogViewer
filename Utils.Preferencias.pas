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
    function GetExibirPainelInferior: boolean;
  public
    constructor Create;
    destructor Destroy; override;
    procedure GravarPreferencia(const aChave: string; const aValor: boolean);

    property HabilitarAtualizacaoAutomatica: boolean read GetHabilitarAtualizacaoAutomatica;
    property ExibirSomenteSQL: boolean read GetExibirSomenteSQL;
    property DestacarLinhasErro: boolean read GetDestacarLinhasErro;
    property ExibirPainelInferior: boolean read GetExibirPainelInferior;
  end;

implementation

uses
  System.SysUtils, Utils.Helpers, Utils.Constantes, Dialogs;

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
  result := FArquivoINI.ReadValue(sDESTACAR_LINHAS_ERRO);
end;

function TPreferencias.GetExibirPainelInferior: boolean;
begin
  result := FArquivoINI.ReadValue(sEXIBIR_PAINEL_INFERIOR);
end;

function TPreferencias.GetExibirSomenteSQL: boolean;
begin
  result := FArquivoINI.ReadValue(sEXIBIR_SOMENTE_SQL);
end;

function TPreferencias.GetHabilitarAtualizacaoAutomatica: boolean;
begin
  result := FArquivoINI.ReadValue(sHABILITAR_ATUALIZACAO_AUTOMATICA);
end;

procedure TPreferencias.GravarPreferencia(const aChave: string;
  const aValor: boolean);
begin
  FArquivoINI.WriteValue(aChave, aValor);
end;

end.
