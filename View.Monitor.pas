unit View.Monitor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.ExtCtrls, Vcl.Grids,
  Vcl.DBGrids,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  FireDAC.Comp.BatchMove, FireDAC.Comp.BatchMove.DataSet,
  FireDAC.Comp.BatchMove.Text, Vcl.StdCtrls,
  Vcl.Buttons, FireDAC.UI.Intf, FireDAC.VCLUI.Wait, FireDAC.Comp.UI,
  Vcl.Samples.Spin, Datasnap.DBClient, Vcl.ComCtrls;

type
  TfMonitor = class(TForm)
    DataSource: TDataSource;
    FDGUIxWaitCursor: TFDGUIxWaitCursor;
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
    function DeveExibirSomentSQL: boolean;
    function LinhaEhSQL: boolean;
    procedure CarregarLog;
    procedure ControlarTemporizador;
    procedure CriarStringLists;
    procedure DestruirStringLists;
    function PegarDataHora: string;
  end;

var
  fMonitor: TfMonitor;

implementation

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
  CarregarLog;
  Exit;

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
  Contador: integer;
begin
  FStringListLinha.Delimiter := ';';
  FStringListLinha.StrictDelimiter := True;

  ClientDataSet.DisableControls;
  ClientDataSet.LogChanges := False;

  FStringListArquivo.LoadFromFile(EditArquivo.Text);

  for Contador := FContador to Pred(FStringListArquivo.Count) do
  begin
    FStringListLinha.DelimitedText := FStringListArquivo[Contador];

    if DeveExibirSomentSQL and not (LinhaEhSQL) then
    if FStringListLinha[5] <> 'SQL' then
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

  FContador := FStringListArquivo.Count;

  ClientDataSet.EnableControls;

  TimerAtualizacaoAutomatica.Enabled := False;

  ControlarTemporizador;
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

function TfMonitor.DeveExibirSomentSQL: boolean;
begin
  result := CheckBoxExibirSomenteSQL.Checked;
end;

procedure TfMonitor.FormCreate(Sender: TObject);
begin
  CriarStringLists;
  FContador := 0;
end;

procedure TfMonitor.FormDestroy(Sender: TObject);
begin
  DestruirStringLists;
end;

function TfMonitor.LinhaEhSQL: boolean;
begin

end;

function TfMonitor.PegarDataHora: string;
begin
  result := Format('%s  %s', [FStringListLinha[11], Copy(FStringListLinha[12], 0, 8)]);
end;

procedure TfMonitor.TimerAtualizacaoAutomaticaTimer(Sender: TObject);
begin
  CarregarLog;
end;

end.
