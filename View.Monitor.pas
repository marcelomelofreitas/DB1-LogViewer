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
  Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan, Vcl.ToolWin, Vcl.ActnCtrls,
  Data.Bind.EngExt, Vcl.Bind.DBEngExt, System.Rtti, System.Bindings.Outputs,
  Vcl.Bind.Editors, Data.Bind.Components;

type
  TfMonitor = class(TForm)
    ActionAbrirLog: TAction;
    ActionAtualizarLog: TAction;
    ActionLimparLog: TAction;
    ActionManager: TActionManager;
    ActionToolBar: TActionToolBar;
    CheckBoxAtualizacaoAutomatica: TCheckBox;
    CheckBoxDestacarLinhasErros: TCheckBox;
    CheckBoxExibirPainelInferior: TCheckBox;
    CheckBoxExibirSomenteSQL: TCheckBox;
    ClientDataSet: TClientDataSet;
    ClientDataSetBase: TStringField;
    ClientDataSetClasse: TStringField;
    ClientDataSetDataHora: TStringField;
    ClientDataSetErro: TStringField;
    ClientDataSetIP: TStringField;
    ClientDataSetMetodo: TStringField;
    ClientDataSetSQL: TStringField;
    ClientDataSetTipo: TStringField;
    ClientDataSetUsuario: TStringField;
    ComboBoxTipo: TComboBox;
    DataSource: TDataSource;
    DBGrid: TDBGrid;
    EditArquivo: TEdit;
    EditFiltroClasse: TEdit;
    EditFiltroMetodo: TEdit;
    EditFiltroSQL: TEdit;
    GroupBoxAtualizacaoAutomatica: TGroupBox;
    GroupBoxFiltros: TGroupBox;
    GroupBoxLog: TGroupBox;
    ImageList: TImageList;
    LabelInformacaoRegistro: TLabel;
    LabelIntervalo: TLabel;
    MemoAbaSQL: TMemo;
    MemoSQL: TMemo;
    MenuItemCopiarColuna: TMenuItem;
    MenuItemCopiarSQL: TMenuItem;
    PageControl: TPageControl;
    PanelFiltro: TPanel;
    PanelGrid: TPanel;
    PanelOpcoes: TPanel;
    PopupMenu: TPopupMenu;
    SpinEditIntervalo: TSpinEdit;
    Splitter: TSplitter;
    TabSheetLog: TTabSheet;
    TabSheetOpcoes: TTabSheet;
    TabSheetSQL: TTabSheet;
    TimerAtualizacaoAutomatica: TTimer;
    BindingsList: TBindingsList;
    LinkControlToPropertyLabel: TLinkControlToProperty;
    LinkControlToPropertySpinEdit: TLinkControlToProperty;
    procedure ActionAbrirLogExecute(Sender: TObject);
    procedure ActionAtualizarLogExecute(Sender: TObject);
    procedure ActionLimparLogExecute(Sender: TObject);
    procedure CheckBoxAtualizacaoAutomaticaClick(Sender: TObject);
    procedure CheckBoxDestacarLinhasErrosClick(Sender: TObject);
    procedure CheckBoxExibirPainelInferiorClick(Sender: TObject);
    procedure CheckBoxExibirSomenteSQLClick(Sender: TObject);
    procedure ClientDataSetAfterScroll(DataSet: TDataSet);
    procedure ComboBoxTipoChange(Sender: TObject);
    procedure DBGridDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MemoAbaSQLKeyPress(Sender: TObject; var Key: Char);
    procedure MemoSQLKeyPress(Sender: TObject; var Key: Char);
    procedure MenuItemCopiarColunaClick(Sender: TObject);
    procedure MenuItemCopiarSQLClick(Sender: TObject);
    procedure TimerAtualizacaoAutomaticaTimer(Sender: TObject);
    procedure TabSheetSQLEnter(Sender: TObject);
    procedure DBGridKeyPress(Sender: TObject; var Key: Char);
  private
    // Class Fields
    FContador: integer;
    FStringListArquivo: TStringList;
    FStringListLinha: TStringList;
    FFormatadorSQL: TFormatadorSQL;

    // Event Handlers
    procedure OnDrawColumnCellPintura(Sender: TObject; const Rect: TRect; DataCol: Integer;
      Column: TColumn; State: TGridDrawState);
    procedure OnKeyPressCamposFiltros(Sender: TObject; var Key: Char);

    // Functions
    function AbrirArquivo: string;
    function FormatarSQL: string;
    function ObterDataHora: string;
    function ObterErro: string;
    function ObterNomeCampo(aComponente: TEdit): string;
    function VerificarDeveExibirSomenteSQL: boolean;
    function VerificarLinhaEhSQL: boolean;
    function VerificarArquivoEhValido: boolean;

    // Procdures
    procedure AbrirAbaSQL;
    procedure AssociarEventosCheckBoxes;
    procedure AssociarEventosFiltros;
    procedure AssociarEventoPinturaDBGrid;
    procedure AtualizarLog;
    procedure BuscarLogMaisRecente;
    procedure CarregarPreferencias;
    procedure CarregarLog;
    procedure CarregarSQLPainelInferior;
    procedure CopiarColuna;
    procedure ControlarTemporizador;
    procedure CriarObjetosInternos;
    procedure DestruirObjetosInternos;
    procedure ExibirInformacaoRegistro;
    procedure FiltrarRegistros(const aNomeCampo, aValor: string);
    procedure GravarPreferencia(const aChave: string; const aValor: boolean);
    procedure IncluirLinhaLog;
    procedure InicializarPropriedades;
    procedure LimparOutrosCamposFiltro(aComponente: TEdit);
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
  lOpenDialog: TOpenDialog;
begin
  lOpenDialog := TOpenDialog.Create(nil);
  try
    lOpenDialog.InitialDir := 'Q:\bin';
    lOpenDialog.Filter := 'Log de métodos do servidor|*.txt';
    lOpenDialog.DefaultExt := 'txt';

    if not lOpenDialog.Execute then
      Exit;

    result := Trim(lOpenDialog.FileName);
    EditArquivo.Text := Trim(lOpenDialog.FileName);
  finally
    lOpenDialog.Free;
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
  AtualizarLog;
end;

procedure TfMonitor.ActionLimparLogExecute(Sender: TObject);
begin
  ClientDataSet.EmptyDataSet;
  LabelInformacaoRegistro.Caption := EmptyStr;
end;

procedure TfMonitor.AssociarEventoPinturaDBGrid;
begin
  DBGrid.OnDrawColumnCell := nil;
  if CheckBoxDestacarLinhasErros.Checked then
    DBGrid.OnDrawColumnCell := OnDrawColumnCellPintura;
end;

procedure TfMonitor.AssociarEventosCheckBoxes;
begin
  CheckBoxAtualizacaoAutomatica.OnClick := CheckBoxAtualizacaoAutomaticaClick;
  CheckBoxExibirSomenteSQL.OnClick := CheckBoxExibirSomenteSQLClick;
  CheckBoxDestacarLinhasErros.OnClick := CheckBoxDestacarLinhasErrosClick;
  CheckBoxExibirPainelInferior.OnClick := CheckBoxExibirPainelInferiorClick;
end;

procedure TfMonitor.AssociarEventosFiltros;
begin
  EditFiltroClasse.OnKeyPress := OnKeyPressCamposFiltros;
  EditFiltroMetodo.OnKeyPress := OnKeyPressCamposFiltros;
  EditFiltroSQL.OnKeyPress := OnKeyPressCamposFiltros;
end;

procedure TfMonitor.AtualizarLog;
begin
  ClientDataSet.EmptyDataSet;
  FContador := 0;
  CarregarLog;
end;

procedure TfMonitor.AbrirAbaSQL;
begin
  PageControl.ActivePage := TabSheetSQL;
end;

procedure TfMonitor.BuscarLogMaisRecente;
var
  lSearchRec: TSearchRec;
  lHoraArquivo: TFileTime;
  lNomeArquivo: string;
begin
  if FindFirst('Q:\Bin\spLogMetodoServidor*.txt', faNormal, lSearchRec) <> 0 then
    Exit;

  lHoraArquivo.dwLowDateTime := 0;
  lHoraArquivo.dwHighDateTime := 0;

  repeat
    if CompareFileTime(lSearchRec.FindData.ftCreationTime, lHoraArquivo) = 1 then
    begin
      lHoraArquivo := lSearchRec.FindData.ftCreationTime;
      lNomeArquivo := lSearchRec.Name;
    end;
  until FindNext(lSearchRec) <> 0;

  FindClose(lSearchRec);
  EditArquivo.Text := 'Q:\bin\' + lNomeArquivo.Trim;
  CarregarLog;
end;

procedure TfMonitor.CarregarLog;
var
  lContador: integer;
begin
  if not VerificarArquivoEhValido then
    Exit;

  ClientDataSet.AfterScroll := nil;
  ClientDataSet.DisableControls;
  TimerAtualizacaoAutomatica.Enabled := False;
  try
    FStringListArquivo.LoadFromStream(
      TFileStream.Create(EditArquivo.Text, fmOpenRead or fmShareDenyNone));

    for lContador := FContador to Pred(FStringListArquivo.Count) do
    begin
      FStringListLinha.DelimitedText := FStringListArquivo[lContador];

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
  CarregarSQLPainelInferior;
end;

procedure TfMonitor.CarregarPreferencias;
var
  lPreferencias: TPreferencias;
begin
  RemoverEventosCheckBoxes;
  lPreferencias := TPreferencias.Create;
  try
    CheckBoxAtualizacaoAutomatica.Checked := lPreferencias.HabilitarAtualizacaoAutomatica;
    LabelIntervalo.Enabled := lPreferencias.HabilitarAtualizacaoAutomatica;
    SpinEditIntervalo.Enabled := lPreferencias.HabilitarAtualizacaoAutomatica;
    CheckBoxExibirSomenteSQL.Checked := lPreferencias.ExibirSomenteSQL;
    CheckBoxDestacarLinhasErros.Checked := lPreferencias.DestacarLinhasErro;
    CheckBoxExibirPainelInferior.Checked := lPreferencias.ExibirPainelInferior;
  finally
    lPreferencias.Free;
    AssociarEventosCheckBoxes;
  end;
end;

procedure TfMonitor.CarregarSQLPainelInferior;
begin
  MemoSQL.Lines.Clear;
  if not ClientDataSetSQL.AsString.IsEmpty then
    MemoSQL.Lines.Text := FormatarSQL;
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
  TimerAtualizacaoAutomatica.Enabled := lHabilitar;
  GravarPreferencia(sHABILITAR_ATUALIZACAO_AUTOMATICA, lHabilitar);
end;

procedure TfMonitor.CheckBoxDestacarLinhasErrosClick(Sender: TObject);
var
  lHabilitar: boolean;
begin
  lHabilitar := CheckBoxDestacarLinhasErros.Checked;
  GravarPreferencia(sDESTACAR_LINHAS_ERRO, lHabilitar);
  AssociarEventoPinturaDBGrid;
end;

procedure TfMonitor.CheckBoxExibirSomenteSQLClick(Sender: TObject);
begin
  GravarPreferencia(sEXIBIR_SOMENTE_SQL, CheckBoxExibirSomenteSQL.Checked);
  AtualizarLog;
end;

procedure TfMonitor.ClientDataSetAfterScroll(DataSet: TDataSet);
begin
  ExibirInformacaoRegistro;
  CarregarSQLPainelInferior;
end;

procedure TfMonitor.ComboBoxTipoChange(Sender: TObject);
var
  lValor: string;
begin
  lValor := EmptyStr;
  if ComboBoxTipo.ItemIndex > 0 then
    lValor := ComboBoxTipo.Text;

  FiltrarRegistros('Tipo', lValor);
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

procedure TfMonitor.DBGridKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    AbrirAbaSQL;
end;

procedure TfMonitor.DestruirObjetosInternos;
begin
  FStringListArquivo.Free;
  FStringListLinha.Free;
  FFormatadorSQL.Free;
end;

procedure TfMonitor.OnKeyPressCamposFiltros(Sender: TObject; var Key: Char);
var
  lComponente: TEdit;
  lNomeCampo: string;
begin
  if Key = #13 then
  begin
    Key := #0;
    lComponente := (Sender as TEdit);
    lNomeCampo := ObterNomeCampo(lComponente);
    LimparOutrosCamposFiltro(lComponente);
    FiltrarRegistros(lNomeCampo, lComponente.Text);
   end;
end;

procedure TfMonitor.OnDrawColumnCellPintura(Sender: TObject; const Rect: TRect; DataCol: Integer;
  Column: TColumn; State: TGridDrawState);
begin
  if ClientDataSetErro.AsString = 'S' then
  begin
    DBGrid.Canvas.Brush.Color := $00B9B9FF;
    DBGrid.DefaultDrawColumnCell(Rect, DataCol, Column, State);
  end;
end;

procedure TfMonitor.ExibirInformacaoRegistro;
begin
  if ClientDataSet.IsEmpty then
  begin
    LabelInformacaoRegistro.Caption := EmptyStr;
    Exit;
  end;

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

procedure TfMonitor.FiltrarRegistros(const aNomeCampo, aValor: string);
var
  lFiltro: string;
  lValor: string;
begin
  if aValor.IsEmpty then
  begin
    ClientDataSet.Filter := EmptyStr;
    ClientDataSet.Filtered := False;
    ClientDataSet.Last;
  end;

  lFiltro := EmptyStr;
  if aNomeCampo = 'SQL' then
    lFiltro := Format('Tipo = %s AND ', ['SQL'.QuotedString]);

  lValor := '%' + aValor + '%';
  lFiltro := lFiltro + Format('%s like %s', [aNomeCampo, lValor.QuotedString]);
  ClientDataSet.Filter := lFiltro;
  ClientDataSet.Filtered := True;
  ClientDataSet.Last;
end;

function TfMonitor.FormatarSQL: string;
begin
  result := FFormatadorSQL.FormatarSQL(ClientDataSetSQL.AsString);
end;

procedure TfMonitor.FormCreate(Sender: TObject);
var
  k: char;
begin
  CriarObjetosInternos;
  InicializarPropriedades;
  CarregarPreferencias;
  BuscarLogMaisRecente;
  AssociarEventosCheckBoxes;
  AssociarEventosFiltros;
  AssociarEventoPinturaDBGrid;

  EditArquivo.Text := 'C:\Andre.Celestino\logErro.txt';
  CarregarLog;
  k := #13;
  EditFiltroMetodo.Text := 'pesquise';
  EditFiltroMetodo.OnKeyPress(EditFiltroMetodo, k);
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
  ClientDataSet.FilterOptions := [foCaseInsensitive];
  FStringListLinha.Delimiter := ';';
  FStringListLinha.StrictDelimiter := True;
  FContador := 0;
end;

procedure TfMonitor.LimparOutrosCamposFiltro(aComponente: TEdit);
begin
  ComboBoxTipo.ItemIndex := 0;

  if EditFiltroClasse.Name <> aComponente.Name then
    EditFiltroClasse.Clear;

  if EditFiltroMetodo.Name <> aComponente.Name then
    EditFiltroMetodo.Clear;

  if EditFiltroSQL.Name <> aComponente.Name then
    EditFiltroSQL.Clear;
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
  Clipboard.AsText := FormatarSQL;
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
  if (FStringListLinha[5] = 'SAIDA') and (FStringListLinha[15] <> EmptyStr) then
    result := 'S';
end;

function TfMonitor.ObterNomeCampo(aComponente: TEdit): string;
begin
  result := StringReplace(aComponente.Name, 'EditFiltro', EmptyStr, []);
end;

procedure TfMonitor.RemoverEventosCheckBoxes;
begin
  CheckBoxAtualizacaoAutomatica.OnClick := nil;
  CheckBoxExibirSomenteSQL.OnClick := nil;
  CheckBoxDestacarLinhasErros.OnClick := nil;
  CheckBoxExibirPainelInferior.OnClick := nil;
end;

procedure TfMonitor.TabSheetSQLEnter(Sender: TObject);
begin
  MemoAbaSQL.Lines.Text := FormatarSQL;
end;

procedure TfMonitor.TimerAtualizacaoAutomaticaTimer(Sender: TObject);
begin
  CarregarLog;
end;

end.
