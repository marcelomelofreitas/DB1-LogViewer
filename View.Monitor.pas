unit View.Monitor;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.ExtCtrls, Vcl.Grids,
  Vcl.DBGrids, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.Samples.Spin, Datasnap.DBClient, Vcl.ComCtrls, Vcl.Menus,
  Utils.FormatadorSQL, System.ImageList, Vcl.ImgList, System.Actions, Vcl.ActnList,
  Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan, Vcl.ToolWin, Vcl.ActnCtrls;

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
    EditArquivo: TEdit;
    PanelGrid: TPanel;
    DBGrid: TDBGrid;
    PanelFiltro: TPanel;
    TabSheetOpcoes: TTabSheet;
    GroupBoxLog: TGroupBox;
    CheckBoxExibirSomenteSQL: TCheckBox;
    CheckBoxDestacarLinhasErros: TCheckBox;
    LabelInformacaoRegistro: TLabel;
    PopupMenu: TPopupMenu;
    MenuItemCopiarColuna: TMenuItem;
    MenuItemCopiarSQL: TMenuItem;
    TabSheetSQL: TTabSheet;
    MemoAbaSQL: TMemo;
    Splitter: TSplitter;
    PanelFiltroSQL: TPanel;
    Label1: TLabel;
    EditFiltroSQL: TEdit;
    MemoSQL: TMemo;
    CheckBoxExibirPainelInferior: TCheckBox;
    ImageList: TImageList;
    ActionToolBar1: TActionToolBar;
    ActionManager: TActionManager;
    ActionAbrirLog: TAction;
    ActionAtualizarLog: TAction;
    ActionLimparLog: TAction;
    GroupBoxAtualizacaoAutomatica: TGroupBox;
    LabelIntervalo: TLabel;
    CheckBoxAtualizacaoAutomatica: TCheckBox;
    SpinEditIntervalo: TSpinEdit;
    GroupBox1: TGroupBox;
    Edit1: TEdit;
    ClientDataSetErro: TStringField;
    procedure TimerAtualizacaoAutomaticaTimer(Sender: TObject);
    procedure CheckBoxAtualizacaoAutomaticaClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ClientDataSetAfterScroll(DataSet: TDataSet);
    procedure CheckBoxExibirSomenteSQLClick(Sender: TObject);
    procedure CheckBoxDestacarLinhasErrosClick(Sender: TObject);
    procedure MenuItemCopiarColunaClick(Sender: TObject);
    procedure MenuItemCopiarSQLClick(Sender: TObject);
    procedure DBGridDblClick(Sender: TObject);
    procedure MemoAbaSQLKeyPress(Sender: TObject; var Key: Char);
    procedure EditFiltroSQLKeyPress(Sender: TObject; var Key: Char);
    procedure CheckBoxExibirPainelInferiorClick(Sender: TObject);
    procedure MemoSQLKeyPress(Sender: TObject; var Key: Char);
    procedure ActionAbrirLogExecute(Sender: TObject);
    procedure ActionAtualizarLogExecute(Sender: TObject);
    procedure ActionLimparLogExecute(Sender: TObject);
    procedure DBGridDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer;
      Column: TColumn; State: TGridDrawState);
  private
    FContador: integer;
    FStringListArquivo: TStringList;
    FStringListLinha: TStringList;
    FFormatadorSQL: TFormatadorSQL;

    // Event Handlers
    procedure EventoPinturaLinha(Sender: TObject; const Rect: TRect; DataCol: Integer;
      Column: TColumn; State: TGridDrawState);

    function AbrirArquivo: string;
    function FormatarSQL: string;
    function ObterDataHora: string;
    function ObterErro: string;
    function VerificarDeveExibirSomenteSQL: boolean;
    function VerificarLinhaEhSQL: boolean;
    function VerificarArquivoEhValido: boolean;
    procedure AbrirAbaSQL;
    procedure AssociarEventosCheckBoxes;
    procedure CarregarPreferencias;
    procedure CarregarLog;
    procedure CopiarColuna;
    procedure CopiarSQL;
    procedure BuscarLogMaisRecente;
    procedure ControlarTemporizador;
    procedure CriarObjetosInternos;
    procedure DestruirObjetosInternos;
    procedure ExibirInformacaoRegistro;
    procedure FiltrarRegistrosPorSQL;
    procedure GravarPreferencia(const aChave: string; const aValor: boolean);
    procedure IncluirLinhaLog;
    procedure InicializarPropriedades;
    procedure RemoverEventosCheckBoxes;
  end;

var
  fMonitor: TfMonitor;

implementation

uses
  ClipBrd, Utils.Helpers, Utils.Preferencias, Utils.Constantes;

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

procedure TfMonitor.ActionAbrirLogExecute(Sender: TObject);
var
  lArquivo: string;
begin
  lArquivo := AbrirArquivo;

  if lArquivo.IsEmpty then
    Exit;

  EditArquivo.Text := lArquivo.Trim;
  CarregarLog;
end;

procedure TfMonitor.ActionAtualizarLogExecute(Sender: TObject);
begin
  CarregarLog;
end;

procedure TfMonitor.ActionLimparLogExecute(Sender: TObject);
begin
  ClientDataSet.EmptyDataSet;
  LabelInformacaoRegistro.Caption := EmptyStr;
end;

procedure TfMonitor.AssociarEventosCheckBoxes;
begin
  CheckBoxAtualizacaoAutomatica.OnClick := CheckBoxAtualizacaoAutomaticaClick;
  CheckBoxExibirSomenteSQL.OnClick := CheckBoxExibirSomenteSQLClick;
  CheckBoxDestacarLinhasErros.OnClick := CheckBoxDestacarLinhasErrosClick;
  CheckBoxExibirPainelInferior.OnClick := CheckBoxExibirPainelInferiorClick;
end;

procedure TfMonitor.AbrirAbaSQL;
begin
  MemoAbaSQL.Lines.Text := FormatarSQL;
  PageControl.ActivePage := TabSheetSQL;
end;

procedure TfMonitor.BuscarLogMaisRecente;
var
  SearchRec: TSearchRec;
  lHoraArquivo: TFileTime;
  lNomeArquivo: string;
begin
  if FindFirst('Q:\Bin\spLogMetodoServidor*.txt', faNormal, SearchRec) <> 0 then
    Exit;

  lHoraArquivo.dwLowDateTime := 0;
  lHoraArquivo.dwHighDateTime := 0;

  repeat
    if CompareFileTime(SearchRec.FindData.ftCreationTime, lHoraArquivo) = 1 then
    begin
      lHoraArquivo := SearchRec.FindData.ftCreationTime;
      lNomeArquivo := SearchRec.Name;
    end;
  until FindNext(SearchRec) <> 0;

  FindClose(SearchRec);
  EditArquivo.Text := 'Q:\bin\' + lNomeArquivo.Trim;
  CarregarLog;
end;

procedure TfMonitor.CarregarLog;
var
  lLinha: string;
begin
  if not VerificarArquivoEhValido then
    Exit;

  ClientDataSet.AfterScroll := nil;
  ClientDataSet.DisableControls;
  TimerAtualizacaoAutomatica.Enabled := False;
  try
    FStringListArquivo.LoadFromStream(
      TFileStream.Create(EditArquivo.Text, fmOpenRead or fmShareDenyNone));

    for lLInha in FStringListArquivo do
    begin
      FStringListLinha.DelimitedText := lLInha;

      if VerificarDeveExibirSomenteSQL and (not VerificarLinhaEhSQL) then
        Continue;

      IncluirLinhaLog;
    end;

  finally
    ClientDataSet.AfterScroll := ClientDataSetAfterScroll;
    ClientDataSet.EnableControls;
  end;

  ExibirInformacaoRegistro;
  FContador := FStringListArquivo.Count;
  ControlarTemporizador;

  if not ClientDataSetSQL.AsString.IsEmpty then
    MemoSQL.Lines.Text := FormatarSQL;
end;

procedure TfMonitor.CarregarPreferencias;
var
  lPreferencias: TPreferencias;
begin
  RemoverEventosCheckBoxes;
  lPreferencias := TPreferencias.Create;
  try
    CheckBoxAtualizacaoAutomatica.Checked := lPreferencias.HabilitarAtualizacaoAutomatica;
    CheckBoxExibirSomenteSQL.Checked := lPreferencias.ExibirSomenteSQL;
    CheckBoxDestacarLinhasErros.Checked := lPreferencias.DestacarLinhasErro;
    CheckBoxExibirPainelInferior.Checked := lPreferencias.ExibirPainelInferior;
  finally
    lPreferencias.Free;
    AssociarEventosCheckBoxes;
  end;
end;

procedure TfMonitor.CheckBoxExibirPainelInferiorClick(Sender: TObject);
begin
  GravarPreferencia(sEXIBIR_PAINEL_INFERIOR, CheckBoxExibirPainelInferior.Checked);
end;

procedure TfMonitor.CheckBoxAtualizacaoAutomaticaClick(Sender: TObject);
var
  lHabilitar: boolean;
begin
  lHabilitar := CheckBoxAtualizacaoAutomatica.Checked;
  LabelIntervalo.Enabled := lHabilitar;
  SpinEditIntervalo.Enabled := lHabilitar;
  TimerAtualizacaoAutomatica.Enabled := lHabilitar;

  GravarPreferencia(sHABILITAR_ATUALIZACAO_AUTOMATICA, lHabilitar);
end;

procedure TfMonitor.CheckBoxDestacarLinhasErrosClick(Sender: TObject);
var
  lHabilitar: boolean;
begin
  lHabilitar := CheckBoxDestacarLinhasErros.Checked;
  GravarPreferencia(sDESTACAR_LINHAS_ERRO, lHabilitar);

  DBGrid.OnDrawColumnCell := nil;
  if lHabilitar then
    DBGrid.OnDrawColumnCell := EventoPinturaLinha;
end;

procedure TfMonitor.CheckBoxExibirSomenteSQLClick(Sender: TObject);
begin
  GravarPreferencia(sEXIBIR_SOMENTE_SQL, CheckBoxExibirSomenteSQL.Checked);
end;

procedure TfMonitor.ClientDataSetAfterScroll(DataSet: TDataSet);
begin
  ExibirInformacaoRegistro;

  if not ClientDataSetSQL.AsString.IsEmpty then
    MemoSQL.Lines.Text := FormatarSQL;
end;

procedure TfMonitor.ControlarTemporizador;
begin
  TimerAtualizacaoAutomatica.Interval := SpinEditIntervalo.Value * 1000;
  TimerAtualizacaoAutomatica.Enabled := CheckBoxAtualizacaoAutomatica.Checked;
end;

procedure TfMonitor.CopiarColuna;
var
  lNomeColuna: string;
begin
  lNomeColuna := DBGrid.SelectedField.FieldName;
  Clipboard.AsText := ClientDataSet.FieldByName(lNomeColuna).AsString;
end;

procedure TfMonitor.CopiarSQL;
begin
  Clipboard.AsText := FormatarSQL;
end;

procedure TfMonitor.CriarObjetosInternos;
begin
  FStringListArquivo := TStringList.Create;
  FStringListLinha := TStringList.Create;
  FFormatadorSQL := TFormatadorSQL.Create;
end;

procedure TfMonitor.DBGridDblClick(Sender: TObject);
begin
  AbrirAbaSQL;
end;

procedure TfMonitor.DBGridDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer;
  Column: TColumn; State: TGridDrawState);
begin
  if not CheckBoxDestacarLinhasErros.Checked then
    Exit;
// verifica se o registro está inativo
if ClientDataSet.FieldByName('Ativo').AsString = 'N' then
begin
  // formata a linha em vermelho e itálico
  DBGrid.Canvas.Font.Style := [fsItalic];
  DBGrid.Canvas.Font.Color := clRed;

  // pinta a linha
  DBGrid.DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;
end;

procedure TfMonitor.DestruirObjetosInternos;
begin
  FStringListArquivo.Free;
  FStringListLinha.Free;
  FFormatadorSQL.Free;
end;

procedure TfMonitor.EditFiltroSQLKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    FiltrarRegistrosPorSQL;
   end;
end;

procedure TfMonitor.EventoPinturaLinha(Sender: TObject; const Rect: TRect; DataCol: Integer;
  Column: TColumn; State: TGridDrawState);
begin
  if ClientDataSet.FieldByName('Erro').AsString = 'S' then
  begin
    DBGrid.Canvas.Brush.Color := $00B9B9FF;
    DBGrid.DefaultDrawColumnCell(Rect, DataCol, Column, State);
  end;
end;

procedure TfMonitor.ExibirInformacaoRegistro;
begin
  LabelInformacaoRegistro.Caption := Format('Registro %d / %d',
    [ClientDataSet.RecNo, ClientdataSet.RecordCount]);
end;

function TfMonitor.VerificarArquivoEhValido: boolean;
begin
  result := False;

  if EditArquivo.IsEmpty then
    Exit;

  if not FileExists(EditArquivo.Text) then
    Exit;

  result := True;
end;

function TfMonitor.VerificarDeveExibirSomenteSQL: boolean;
begin
  result := CheckBoxExibirSomenteSQL.Checked;
end;

procedure TfMonitor.FiltrarRegistrosPorSQL;
begin
  if ClientDataSet.IsEmpty then
    Exit;

  if EditFiltroSQL.IsEmpty then
  begin
    ClientDataSet.Filtered := False;
    Exit;
  end;

  ClientDataSet.Filter := Format('SQL like %s',
    [QuotedStr('%' + EditFiltroSQL.Text + '%')]);
  ClientDataSet.Filtered := True;
end;

function TfMonitor.FormatarSQL: string;
begin
  result := FFormatadorSQL.FormatarSQL(ClientDataSetSQL.AsString);
end;

procedure TfMonitor.FormCreate(Sender: TObject);
begin
  CriarObjetosInternos;
  InicializarPropriedades;
  CarregarPreferencias;
  BuscarLogMaisRecente;
  AssociarEventosCheckBoxes;
end;

procedure TfMonitor.FormDestroy(Sender: TObject);
begin
  DestruirObjetosInternos;
end;

procedure TfMonitor.GravarPreferencia(const aChave: string;
  const aValor: boolean);
var
  lPreferencias: TPreferencias;
begin
  lPreferencias := TPreferencias.Create;
  try
    lPreferencias.GravarPreferencia(aChave, aValor);
  finally
    lPreferencias.Free;
  end;
end;

procedure TfMonitor.IncluirLinhaLog;
begin
  ClientDataSet.Append;
  ClientDataSetTipo.AsString := FStringListLinha[5];
  ClientDataSetBase.AsString := FStringListLinha[6];
  ClientDataSetUsuario.AsString := FStringListLinha[9];
  ClientDataSetIP.AsString := FStringListLinha[10];
  ClientDataSetDataHora.AsString := ObterDataHora;
  ClientDataSetClasse.AsString := FStringListLinha[13];
  ClientDataSetMetodo.AsString := FStringListLinha[14];
  ClientDataSetSQL.AsString := FStringListLinha[15];
  ClientDataSetErro.AsString := ObterErro;
  ClientDataSet.Post;
end;

procedure TfMonitor.InicializarPropriedades;
begin
  ClientDataSet.LogChanges := False;
  FStringListLinha.Delimiter := ';';
  FStringListLinha.StrictDelimiter := True;
  FContador := 0;
end;

procedure TfMonitor.MemoAbaSQLKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = ^C then
    ClipBoard.AsText := MemoAbaSQL.Lines.Text;

  if Key = ^A then
    MemoAbaSQL.SelectAll;
end;

procedure TfMonitor.MemoSQLKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = ^C then
    ClipBoard.AsText := MemoSQL.Lines.Text;

  if Key = ^A then
    MemoSQL.SelectAll;
end;

procedure TfMonitor.MenuItemCopiarColunaClick(Sender: TObject);
begin
  CopiarColuna;
end;

procedure TfMonitor.MenuItemCopiarSQLClick(Sender: TObject);
begin
  CopiarSQL;
end;

function TfMonitor.VerificarLinhaEhSQL: boolean;
begin
  result := FStringListLinha[5] = 'SQL';
end;

function TfMonitor.ObterDataHora: string;
begin
  result := Format('%s  %s', [FStringListLinha[11],
    Copy(FStringListLinha[12], 0, 8)]);
end;

function TfMonitor.ObterErro: string;
begin
  result := EmptyStr;
  //if FStringListLinha[5] = '';
end;

procedure TfMonitor.RemoverEventosCheckBoxes;
begin
  CheckBoxAtualizacaoAutomatica.OnClick := nil;
  CheckBoxExibirSomenteSQL.OnClick := nil;
  CheckBoxDestacarLinhasErros.OnClick := nil;
  CheckBoxExibirPainelInferior.OnClick := nil;
end;

procedure TfMonitor.TimerAtualizacaoAutomaticaTimer(Sender: TObject);
begin
  CarregarLog;
end;

end.
