unit Utils.Opcoes;

interface

uses
  IniFiles;

type
  TIniFileHelper = class helper for TIniFile
    function ReadOption(const aKey: string): string;
  end;

  TOpcoes = class
  private
    FArquivoINI: TIniFile;

    function GetExibirSomenteSQL: boolean;
    function GetDestacarLinhasErro: boolean;
  public
    constructor Create;
    property ExibirSomenteSQL: boolean read GetExibirSomenteSQL;
    property DestacarLinhasErro: boolean read GetDestacarLinhasErro;
  end;

implementation

uses
  System.SysUtils;

{ TIniFileHelper }

function TIniFileHelper.ReadOption(const aKey: string): string;
begin
  result := Self.ReadString('Opcoes', aKey, 'N');
end;

{ TOpcoes }

constructor TOpcoes.Create;
begin
  FArquivoINI := TIniFile.Create(GetCurrentDir + '\spMonitor4.ini');
end;

function TOpcoes.GetDestacarLinhasErro: boolean;
begin
  result := FArquivoINI.ReadOption('DestacarLinhasErro') = 'S';
end;

function TOpcoes.GetExibirSomenteSQL: boolean;
begin
  result := FArquivoINI.ReadOption('ExibirSomenteSQL') = 'S';
end;

end.
