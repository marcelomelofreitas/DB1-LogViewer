unit View.Monitor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.ExtCtrls, Vcl.Grids,
  Vcl.DBGrids, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.Samples.Spin, Datasnap.DBClient, Vcl.ComCtrls;

type
  TfMonitor = class(TForm)
    DataSource: TDataSource;
    TimerAtualizacaoAutomatica: TTimer;
    ClientDataSet: TClientDataSet;
    ClientDataSetTipo: TStringField;
    ClientDataSetBase: TStringField;
    ClientDataSetUsuario: TStringField;
    ClientDataSetIP: TStringField;
    ClientDataSetClasse: TStringField;
    ClientDataSetMetodo: TStringField;
    ClientDataSetSQL: TStringField;
    ClientDataSetDataHora: TStringField;
    PageControl: TPageControl;
    TabSheetLog: TTabSheet;
    PanelOpcoes: TPanel;
    BitBtnAbrirLog: TBitBtn;
    BitBtnAtualizarLog: TBitBtn;
    BitBtnLimparLog: TBitBtn;
    EditArquivo: TEdit;
    GroupBoxAtualizacaoAutomatica: TGroupBox;
    LabelIntervalo: TLabel;
    CheckBoxAtualizacaoAutomatica: TCheckBox;
    SpinEditIntervalo: TSpinEdit;
    PanelGrid: TPanel;
    DBGrid: TDBGrid;
    PanelFiltro: TPanel;
    TabSheetOpcoes: TTabSheet;
    GroupBoxLog: TGroupBox;
    CheckBoxExibirSomenteSQL: TCheckBox;
    CheckBoxDestacarLinhasErros: TCheckBox;
    procedure BitBtnLimparLogClick(Sender: TObject);
    procedure BitBtnAbrirLogClick(Sender: TObject);
    procedure BitBtnAtualizarLogClick(Sender: TObject);
    procedure TimerAtualizacaoAutomaticaTimer(Sender: TObject);
    procedure CheckBoxAtualizacaoAutomaticaClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FContador: integer;
    FStringListArquivo: TStringList;
    FStringListLinha: TStringList;

    function AbrirArquivo: string;
    function VerificarDeveExibirSomentSQL: boolean;
    function VerificarLinhaEhSQL: boolean;
    procedure CarregarPreferencias;
    procedure CarregarLog;
    procedure ControlarTemporizador;
    procedure CriarStringLists;
    procedure DestruirStringLists;
    procedure InicializarPropriedades;
    function PegarDataHora: string;
  end;

var
  fMonitor: TfMonitor;

implementation

uses
  Utils.Preferencias;

{$R *.dfm}

function TfMonitor.AbrirArquivo: string;
var
  OpenDialog: TOpenDialog;
begin
  OpenDialog := TOpenDialog.Create(nil);
  try
    OpenDialog.InitialDir := 'Q:\bin';
    OpenDialog.Filter := 'Log de métodos do servidor|*.txt';
    OpenDialog.DefaultExt := 'txt';

    if not OpenDialog.Execute then
      Exit;

    result := Trim(OpenDialog.FileName);
    EditArquivo.Text := Trim(OpenDialog.FileName);
  finally
    OpenDialog.Free;
  end;
end;

procedure TfMonitor.BitBtnAbrirLogClick(Sender: TObject);
var
  lArquivo: string;
begin
  lArquivo := AbrirArquivo;

  if lArquivo.IsEmpty then
    Exit;

  EditArquivo.Text := lArquivo.Trim;
  CarregarLog;
end;

procedure TfMonitor.BitBtnAtualizarLogClick(Sender: TObject);
begin
  CarregarLog;
end;

procedure TfMonitor.BitBtnLimparLogClick(Sender: TObject);
begin
  ClientDataSet.EmptyDataSet;
end;

procedure TfMonitor.CarregarLog;
var
  lContador: integer;
begin
  ClientDataSet.DisableControls;
  try
    TimerAtualizacaoAutomatica.Enabled := False;
    FStringListArquivo.LoadFromFile(EditArquivo.Text);

    for lContador := FContador to Pred(FStringListArquivo.Count) do
    begin
      FStringListLinha.DelimitedText := FStringListArquivo[lContador];

      if VerificarDeveExibirSomentSQL and (not VerificarLinhaEhSQL) then
        Continue;

      ClientDataSet.Append;
      ClientDataSetTipo.AsString := FStringListLinha[5];
      ClientDataSetBase.AsString := FStringListLinha[6];
      ClientDataSetUsuario.AsString := FStringListLinha[9];
      ClientDataSetIP.AsString := FStringListLinha[10];
      ClientDataSetDataHora.AsString := PegarDataHora;
      ClientDataSetClasse.AsString := FStringListLinha[13];
      ClientDataSetMetodo.AsString := FStringListLinha[14];
      ClientDataSetSQL.AsString := FStringListLinha[15];
      ClientDataSet.Post;
    end;
  finally
    ClientDataSet.EnableControls;
  end;

  FContador := FStringListArquivo.Count;
  ControlarTemporizador;
end;

procedure TfMonitor.CarregarPreferencias;
var
  lPreferencias: TPreferencias;
begin
  lPreferencias := TPreferencias.Create;
  try
    CheckBoxAtualizacaoAutomatica.Checked :=
      lPreferencias.HabilitarAtualizacaoAutomatica;
    CheckBoxExibirSomenteSQL.Checked := lPreferencias.ExibirSomenteSQL;
    CheckBoxDestacarLinhasErros.Checked := lPreferencias.DestacarLinhasErro;
  finally
    lPreferencias.Free;
  end;
end;

procedure TfMonitor.CheckBoxAtualizacaoAutomaticaClick(Sender: TObject);
var
  lHabilitar: boolean;
begin
  lHabilitar := CheckBoxAtualizacaoAutomatica.Checked;
  LabelIntervalo.Enabled := lHabilitar;
  SpinEditIntervalo.Enabled := lHabilitar;
  TimerAtualizacaoAutomatica.Enabled := lHabilitar;
end;

procedure TfMonitor.ControlarTemporizador;
begin
  TimerAtualizacaoAutomatica.Interval := SpinEditIntervalo.Value * 1000;
  TimerAtualizacaoAutomatica.Enabled := CheckBoxAtualizacaoAutomatica.Checked;
end;

procedure TfMonitor.CriarStringLists;
begin
  FStringListArquivo := TStringList.Create;
  FStringListLinha := TStringList.Create;
end;

procedure TfMonitor.DestruirStringLists;
begin
  FStringListArquivo.Free;
  FStringListLinha.Free;
end;

function TfMonitor.VerificarDeveExibirSomentSQL: boolean;
begin
  result := CheckBoxExibirSomenteSQL.Checked;
end;

procedure TfMonitor.FormCreate(Sender: TObject);
begin
  CriarStringLists;
  InicializarPropriedades;
  CarregarPreferencias;
end;

procedure TfMonitor.FormDestroy(Sender: TObject);
begin
  DestruirStringLists;
end;

procedure TfMonitor.InicializarPropriedades;
begin
  ClientDataSet.LogChanges := False;
  FStringListLinha.Delimiter := ';';
  FStringListLinha.StrictDelimiter := True;
  FContador := 0;
end;

function TfMonitor.VerificarLinhaEhSQL: boolean;
begin
  result := FStringListLinha[5] = 'SQL';
end;

function TfMonitor.PegarDataHora: string;
begin
  result := Format('%s  %s', [FStringListLinha[11],
    Copy(FStringListLinha[12], 0, 8)]);
end;

procedure TfMonitor.TimerAtualizacaoAutomaticaTimer(Sender: TObject);
begin
  CarregarLog;
end;

end.
