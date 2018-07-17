unit View.Monitor;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.Samples.Spin, Vcl.ComCtrls, Vcl.Menus,System.Actions, Vcl.ActnList,
  Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan, Vcl.ActnCtrls, Data.Bind.EngExt, Vcl.Bind.DBEngExt,
  System.Rtti, System.Bindings.Outputs, Vcl.Bind.Editors, Data.Bind.Components, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Component.FDLogViewer, Vcl.WinXCtrls, FireDAC.Stan.StorageBin, SynEdit,
  SynMemo, SynEditHighlighter, SynHighlighterSQL, SQL.Formatter, FireDAC.Phys.Intf, Utils.Options,
  FireDAC.DApt.Intf, System.ImageList, Vcl.ImgList, Vcl.ToolWin, Vcl.DBCtrls, Component.DBGridLog;

type
  TfMonitor = class(TForm)
    ActionClearLog: TAction;
    ActionManager: TActionManager;
    ActionOpenFile: TAction;
    ActionReloadLog: TAction;
    ActionToolBar: TActionToolBar;
    BevelSeparator1: TBevel;
    BevelSeparator2: TBevel;
    BindingsList: TBindingsList;
    CheckBoxAutoUpdate: TCheckBox;
    ComboBoxStyles: TComboBox;
    DataSource: TDataSource;
    DataSourceFilter: TDataSource;
    DBGrid: TDBGrid;
    DBGridFilter: TDBGridLog;
    DBNavigator: TDBNavigator;
    EditSQLFilter: TEdit;
    FDMemTableFilter: TFDMemTable;
    FDMemTableFilterClass: TStringField;
    FDMemTableFilterDatabase: TStringField;
    FDMemTableFilterDateTime: TStringField;
    FDMemTableFilterIP: TStringField;
    FDMemTableFilterMethod: TStringField;
    FDMemTableFilterType: TStringField;
    FDMemTableFilterUser: TStringField;
    GroupBoxAutoUpdate: TGroupBox;
    GroupBoxLog: TGroupBox;
    GroupBoxShortCuts: TGroupBox;
    GroupBoxSQL: TGroupBox;
    GroupBoxVisual: TGroupBox;
    ImageList: TImageList;
    LabelAlt1: TLabel;
    LabelAlt2: TLabel;
    LabelAlt3: TLabel;
    LabelAutoFormatInfo: TLabel;
    LabelClearFilters: TLabel;
    LabelClearLog: TLabel;
    LabelCopyColumnValue: TLabel;
    LabelCopySQL: TLabel;
    LabelCtrlC: TLabel;
    LabelCtrlL: TLabel;
    LabelCtrlO: TLabel;
    LabelCtrlQ: TLabel;
    LabeledEditClass: TLabeledEdit;
    LabeledEditDatabase: TLabeledEdit;
    LabeledEditDateTime: TLabeledEdit;
    LabeledEditIP: TLabeledEdit;
    LabeledEditMethod: TLabeledEdit;
    LabeledEditUser: TLabeledEdit;
    LabelF4: TLabel;
    LabelF5: TLabel;
    LabelFileName: TLabel;
    LabelFileNameValue: TLabel;
    LabelFilterSQL: TLabel;
    LabelIgnoreBasicLogInfo: TLabel;
    LabelInterval: TLabel;
    LabelOpenFile: TLabel;
    LabelRecordInfo: TLabel;
    LabelRecordInfoValue: TLabel;
    LabelReloadLog: TLabel;
    LabelRowSelectInfo: TLabel;
    LabelShowLogTab: TLabel;
    LabelShowOptionsTab: TLabel;
    LabelShowSQLTab: TLabel;
    LabelStyle: TLabel;
    LabelUseToDateFunctionInfo: TLabel;
    LinkControlToPropertyLabel: TLinkControlToProperty;
    LinkControlToPropertySpinEdit: TLinkControlToProperty;
    LogViewer: TFDLogViewer;
    MenuItemCopyColumnValue: TMenuItem;
    MenuItemCopySQL: TMenuItem;
    PageControl: TPageControl;
    PanelDBGridFilter: TPanel;
    PanelFilterSQL: TPanel;
    PanelGrid: TPanel;
    PanelOptions: TPanel;
    PanelSQL: TPanel;
    PanelSQLTab: TPanel;
    PopupMenu: TPopupMenu;
    SpinEditInterval: TSpinEdit;
    Splitter: TSplitter;
    SynMemoSQL: TSynMemo;
    SynMemoTab: TSynMemo;
    SynSQLSyn: TSynSQLSyn;
    TabSheetLog: TTabSheet;
    TabSheetOptions: TTabSheet;
    TabSheetSQL: TTabSheet;
    TimerAutoUpdate: TTimer;
    ToggleSwitchAutoFormatSQL: TToggleSwitch;
    ToggleSwitchHighlightErrors: TToggleSwitch;
    ToggleSwitchIgnoreBasicLog: TToggleSwitch;
    ToggleSwitchRowSelect: TToggleSwitch;
    ToggleSwitchShowBottomPanel: TToggleSwitch;
    ToggleSwitchShowLineNumbers: TToggleSwitch;
    ToggleSwitchShowOnlySQL: TToggleSwitch;
    ToggleSwitchStartMaximized: TToggleSwitch;
    ToggleSwitchStayOnTop: TToggleSwitch;
    ToggleSwitchUseToDateFunction: TToggleSwitch;
    FDMemTableFilterError: TStringField;
    PanelUpdateReminder: TPanel;
    LabelUpdateReminder: TLabel;
    LabelURL: TLabel;
    LabelShowOnlySQLInfo: TLabel;
    procedure ActionClearLogExecute(Sender: TObject);
    procedure ActionOpenFileExecute(Sender: TObject);
    procedure ActionReloadLogExecute(Sender: TObject);
    procedure CheckBoxAutoUpdateClick(Sender: TObject);
    procedure ComboBoxStylesSelect(Sender: TObject);
    procedure DBGridDblClick(Sender: TObject);
    procedure DBGridFilterColEnter(Sender: TObject);
    procedure DBGridFilterColResize(Sender: TObject);
    procedure DBGridFilterColumnMoved(Sender: TObject; FromIndex, ToIndex: Integer);
    procedure DBGridFilterKeyPress(Sender: TObject; var Key: Char);
    procedure DBGridKeyPress(Sender: TObject; var Key: Char);
    procedure EditSQLFilterKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure LabelAutoFormatInfoClick(Sender: TObject);
    procedure LabelIgnoreBasicLogInfoClick(Sender: TObject);
    procedure LabelRowSelectInfoClick(Sender: TObject);
    procedure LabelUseToDateFunctionInfoClick(Sender: TObject);
    procedure LogViewerAfterScroll(DataSet: TDataSet);
    procedure MenuItemCopyColumnValueClick(Sender: TObject);
    procedure MenuItemCopySQLClick(Sender: TObject);
    procedure PopupMenuPopup(Sender: TObject);
    procedure SpinEditIntervalChange(Sender: TObject);
    procedure SplitterMoved(Sender: TObject);
    procedure TabSheetSQLEnter(Sender: TObject);
    procedure TimerAutoUpdateTimer(Sender: TObject);
    procedure ToggleSwitchAutoFormatSQLClick(Sender: TObject);
    procedure ToggleSwitchHighlightErrorsClick(Sender: TObject);
    procedure ToggleSwitchIgnoreBasicLogClick(Sender: TObject);
    procedure ToggleSwitchRowSelectClick(Sender: TObject);
    procedure ToggleSwitchShowBottomPanelClick(Sender: TObject);
    procedure ToggleSwitchShowLineNumbersClick(Sender: TObject);
    procedure ToggleSwitchShowOnlySQLClick(Sender: TObject);
    procedure ToggleSwitchStartMaximizedClick(Sender: TObject);
    procedure ToggleSwitchStayOnTopClick(Sender: TObject);
    procedure ToggleSwitchUseToDateFunctionClick(Sender: TObject);
    procedure FDMemTableFilterTypeSetText(Sender: TField; const Text: string);
    procedure FDMemTableFilterErrorSetText(Sender: TField; const Text: string);
    procedure LabelURLClick(Sender: TObject);
    procedure LabelShowOnlySQLInfoClick(Sender: TObject);
  private
    // class fields
    FLoadingOptionsOnStartup: boolean;
    FSQLFormatter: TSQLFormatter;
    FLastDirectory: string;

    // event handlers
    procedure OnDrawColumnCellHighlight(Sender: TObject; const Rect: TRect; DataCol: Integer;
      Column: TColumn; State: TGridDrawState);
    procedure OnBeforeInsertAbort(DataSet: TDataSet);

    // private functions
    function IsFileNameValid: boolean;
    function IsContentValid: boolean;
    function OpenFile: string;

    // private procedures
    procedure AddFilterEmptyLine;
    procedure AssignGridDrawEvent;
    procedure BuildFilter;
    procedure ClearFilters;
    procedure CopyColumnValue;
    procedure GetMostRecentLog;
    procedure LoadLineDetails;
    procedure LoadLastDirectory(aOptions: TOptions);
    procedure LoadLog;
    procedure LoadLogOnTimer;
    procedure LoadOptions;
    procedure LoadPreferences(aOptions: TOptions);
    procedure LoadSelectedStyle(const aSelectedStyle: string);
    procedure LoadSQLBottomPanel;
    procedure LoadSQLTab;
    procedure LoadStylesList;
    procedure LoadPickLists;
    procedure LoadWindowParams(aOptions: TOptions);
    procedure ManageTimer;
    procedure OpenSQLTab;
    procedure SaveOption(const aKey: string; const aValue: string);
    procedure ShowInfoMessage(const aMessage: string);
    procedure ShowRecordInfo;
  end;

var
  fMonitor: TfMonitor;

implementation

uses
  VCL.Themes, ShellAPI, ClipBrd, Utils.Constants, Utils.Helpers, View.Loading,
  System.UITypes, StrUtils;

{$R *.dfm}

function TfMonitor.OpenFile: string;
var
  lOpenDialog: TOpenDialog;
begin
  lOpenDialog := TOpenDialog.Create(nil);
  try
    lOpenDialog.InitialDir := FLastDirectory;
    lOpenDialog.Filter := 'Log de métodos do servidor|spLogMetodoServidor*.txt|Arquivos TXT|*.txt';
    lOpenDialog.DefaultExt := 'txt';

    if not lOpenDialog.Execute then
      Exit;

    LabelFileNameValue.Caption := Trim(lOpenDialog.FileName);
    result := LabelFileNameValue.Caption;
  finally
    lOpenDialog.Free;
  end;
end;

procedure TfMonitor.ActionOpenFileExecute(Sender: TObject);
var
  lFileName: string;
begin
  lFileName := OpenFile;

  if lFileName.IsEmpty then
    Exit;

  LabelFileNameValue.Caption := lFileName.Trim;
  LogViewer.ResetCounter;
  LoadLog;
  BuildFilter;
end;

procedure TfMonitor.ActionReloadLogExecute(Sender: TObject);
begin
  LogViewer.ReloadLog;
end;

procedure TfMonitor.AddFilterEmptyLine;
begin
  FDMemTableFilter.Open;
  FDMemTableFilter.AppendRecord([]);
  FDMemTableFilter.BeforeInsert := OnBeforeInsertAbort;
end;

procedure TfMonitor.ActionClearLogExecute(Sender: TObject);
begin
  LogViewer.EmptyDataSet;
  LabelRecordInfoValue.Caption := EmptyStr;
  SynMemoSQL.Lines.Clear;
end;

procedure TfMonitor.AssignGridDrawEvent;
begin
  DBGrid.OnDrawColumnCell := nil;
  if ToggleSwitchHighlightErrors.IsOn then
    DBGrid.OnDrawColumnCell := OnDrawColumnCellHighlight;
end;

procedure TfMonitor.BuildFilter;
var
  lBuilderFilter: TStringBuilder;
  lField: TField;

  function GetFilterString(const aFilter: string): string;
  begin
    result := QuotedStr('%' + aFilter.Trim + '%');
  end;

begin
  if FDMemTableFilter.State in dsEditModes then
    FDMemTableFilter.Post;

  lBuilderFilter := TStringBuilder.Create;
  try
    for lField in FDMemTableFilter.Fields do
    begin
      if not lField.AsString.IsEmpty then
      begin
        lBuilderFilter
          .Append(' and ')
          .Append(lField.FieldName)
          .Append(' like ')
          .Append(GetFilterString(lField.AsString));
      end;
    end;

    if not Trim(EditSQLFilter.Text).IsEmpty then
    begin
      lBuilderFilter.Append(Format(' and Type = ''SQL'' and SQL like %s',
        [GetFilterString(EditSQLFilter.Text)]));
    end;

    LogViewer.SetLogFilter(lBuilderFilter.ToString);
  finally
    lBuilderFilter.Free;
  end;
end;

procedure TfMonitor.OpenSQLTab;
begin
  PageControl.ActivePage := TabSheetSQL;
end;

procedure TfMonitor.PopupMenuPopup(Sender: TObject);
begin
  MenuItemCopyColumnValue.Visible := not ToggleSwitchRowSelect.IsOn;
end;

procedure TfMonitor.GetMostRecentLog;
var
  lSearchRec: TSearchRec;
  lFileTime: TFileTime;
  lFileName: string;
begin
  if FindFirst(FLastDirectory + 'spLogMetodoServidor*.txt', faNormal, lSearchRec) <> 0 then
    Exit;

  lFileTime.dwLowDateTime := 0;
  lFileTime.dwHighDateTime := 0;

  repeat
    if CompareFileTime(lSearchRec.FindData.ftCreationTime, lFileTime) = 1 then
    begin
      lFileTime := lSearchRec.FindData.ftCreationTime;
      lFileName := lSearchRec.Name;
    end;
  until FindNext(lSearchRec) <> 0;

  FindClose(lSearchRec);
  LabelFileNameValue.Caption := FLastDirectory + lFileName.Trim;
  LoadLog;
end;

procedure TfMonitor.LabelURLClick(Sender: TObject);
begin
  ShellExecute(Self.WindowHandle, 'open',
    'https://colabore.softplan.com.br/display/~andre.celestino/LogViewer', nil, nil, SW_SHOWNORMAL);
end;

procedure TfMonitor.LabelAutoFormatInfoClick(Sender: TObject);
var
  lStringBuilder: TStringBuilder;
begin
  lStringBuilder := TStringBuilder.Create;
  try
    lStringBuilder
      .Append('Habilitar essa opção pode impactar na performance ao navegar entre os registros.')
      .AppendLine.AppendLine
      .Append('Obs: A opção se refere apenas ao painel inferior na aba "Log". ')
      .Append('Na aba "SQL", a identação SEMPRE será aplicada.');

    ShowInfoMessage(lStringBuilder.ToString);
  finally
    lStringBuilder.Free;
  end;
end;

procedure TfMonitor.LabelIgnoreBasicLogInfoClick(Sender: TObject);
begin
  ShowInfoMessage(
    'Ignora os métodos da classe TfpgServidorDM, como "Login", "LoginInterno" e "AutenticarUsuario".');
end;

procedure TfMonitor.LabelRowSelectInfoClick(Sender: TObject);
begin
  ShowInfoMessage(
    'Ao habilitar essa opção, a cópia do valor da coluna (Ctrl + Q) ficará indisponível.');
end;

procedure TfMonitor.LabelShowOnlySQLInfoClick(Sender: TObject);
begin
  ShowInfoMessage('Ignora os logs do tipo "ENTRADA", "SAIDA" e "AVISO".');
end;

procedure TfMonitor.LabelUseToDateFunctionInfoClick(Sender: TObject);
begin
  ShowInfoMessage('A função "to_date" normalmente é utilizada em SQLs do banco de dados Oracle.');
end;

procedure TfMonitor.LoadLastDirectory(aOptions: TOptions);
begin
  FLastDirectory := aOptions.ReadValue(sLAST_DIRECTORY);

  if FLastDirectory.IsEmpty then
    FLastDirectory := sDEFAULT_DIRECTORY;
end;

procedure TfMonitor.LoadLineDetails;
begin
  LabeledEditDatabase.Text := LogViewer.FieldByName('Database').AsString;
  LabeledEditUser.Text := LogViewer.FieldByName('User').AsString;
  LabeledEditIP.Text := LogViewer.FieldByName('IP').AsString;
  LabeledEditDateTime.Text := LogViewer.FieldByName('DateTime').AsString;
  LabeledEditClass.Text := LogViewer.FieldByName('Class').AsString;
  LabeledEditMethod.Text := LogViewer.FieldByName('Method').AsString;
end;

procedure TfMonitor.LoadLog;
var
  fLoading: TfLoading;
begin
  if not IsFileNameValid then
    Exit;

  if not IsContentValid then
    Exit;

  SaveOption(sLAST_DIRECTORY, ExtractFilePath(LabelFileNameValue.Caption));

  TimerAutoUpdate.Enabled := False;
  LogViewer.EmptyDataSet;

  fLoading := TfLoading.Create(nil);
  try
    fLoading.Show;
    Application.ProcessMessages;
    LogViewer.LogFileName := LabelFileNameValue.Caption;
    LogViewer.LoadLog;
  finally
    fLoading.Free;
  end;

  ShowRecordInfo;
  ManageTimer;
  LoadSQLBottomPanel;
end;

procedure TfMonitor.LoadLogOnTimer;
begin
  if not IsFileNameValid then
    Exit;

  LogViewer.LoadLog;
end;

procedure TfMonitor.LoadOptions;
var
  lOptions: TOptions;
begin
  FLoadingOptionsOnStartup := True;
  lOptions := TOptions.Create;
  try
    LoadPreferences(lOptions);
    LoadWindowParams(lOptions);
    LoadLastDirectory(lOptions);
  finally
    lOptions.Free;
    FLoadingOptionsOnStartup := False;
  end;
end;

procedure TfMonitor.LoadPreferences(aOptions: TOptions);
begin
  CheckBoxAutoUpdate.Checked := aOptions.ReadEnabled(sAUTO_UPDATE_ENABLED);
  SpinEditInterval.Value := StrToIntDef(aOptions.ReadValue(nAUTO_UPDATE_INTERVAL), 1);
  ToggleSwitchShowOnlySQL.Active := aOptions.ReadEnabled(sSHOW_ONLY_SQL);
  ToggleSwitchHighlightErrors.Active := aOptions.ReadEnabled(sHIGHLIGHT_ERRORS);
  ToggleSwitchShowBottomPanel.Active := aOptions.ReadEnabled(sSHOW_BOTTOM_PANEL);
  ToggleSwitchIgnoreBasicLog.Active := aOptions.ReadEnabled(sIGNORE_BASIC_LOG);
  ToggleSwitchRowSelect.Active := aOptions.ReadEnabled(sROW_SELECT);
  ToggleSwitchStayOnTop.Active := aOptions.ReadEnabled(sSTAY_ON_TOP);
  ToggleSwitchShowLineNumbers.Active := aOptions.ReadEnabled(sSHOW_LINE_NUMBERS);
  ToggleSwitchUseToDateFunction.Active := aOptions.ReadEnabled(sUSE_TODATE_FUNCTION);
  LoadSelectedStyle(aOptions.ReadValue(sSELECTED_STYLE));
end;

procedure TfMonitor.LoadSelectedStyle(const aSelectedStyle: string);
var
  lStyleName: string;
begin
  lStyleName := IfThen(aSelectedStyle.IsEmpty, sDEFAULT_STYLE, aSelectedStyle);
  ComboBoxStyles.ItemIndex := ComboBoxStyles.Items.IndexOf(lStyleName);
  TStyleManager.SetStyle(lStyleName);
end;

procedure TfMonitor.LoadSQLBottomPanel;
begin
  if not ToggleSwitchShowBottomPanel.IsOn then
    Exit;

  SynMemoSQL.Lines.Clear;

  if LogViewer.IsSQLEmpty then
    Exit;

  SynMemoSQL.Lines.Text := LogViewer.GetSQL;

  if ToggleSwitchAutoFormatSQL.IsOn then
    SynMemoSQL.Lines.Text := FSQLFormatter.FormatSQL(LogViewer.GetSQL)
  else
    SynMemoSQL.Lines.Text := LogViewer.GetSQL.Replace('  ', sSPACE, [rfReplaceAll]);
end;

procedure TfMonitor.LoadSQLTab;
begin
  SynMemoTab.Lines.Clear;

  if LogViewer.IsSQLEmpty then
  Exit;

  SynMemoTab.Lines.Text := FSQLFormatter.FormatSQL(LogViewer.GetSQL);
  LoadLineDetails;
end;

procedure TfMonitor.LoadStylesList;
var
  lStyle :String;
  lStringListStyles: TStringList;
begin
  lStringListStyles := TStringList.Create;
  try
    for lStyle in TStyleManager.StyleNames do
      lStringListStyles.Add(lStyle);

    lStringListStyles.Sort;
    ComboBoxStyles.Clear;

    for lStyle in lStringListStyles do
      ComboBoxStyles.Items.Add(lStyle);
  finally
    lStringListStyles.Free;
  end;
end;

procedure TfMonitor.LoadPickLists;
begin
  with DBGridFilter.Columns[nTYPE_COLUMN].PickList do
  begin
    Add('ENTRADA');
    Add('AVISO');
    Add('SAIDA');
    Add('SQL');
  end;

  with DBGridFilter.Columns[nERROR_COLUMN].PickList do
  begin
    Add(EmptyStr);
    Add('S');
  end;
end;

procedure TfMonitor.LoadWindowParams(aOptions: TOptions);
var
  lValue: string;
begin
  lValue := aOptions.ReadValue(nSQL_BOTTOM_PANEL_HEIGHT);
  if not lValue.IsEmpty then
    PanelSQL.Height := lValue.ToInteger;

  ToggleSwitchStartMaximized.Active := aOptions.ReadEnabled(sSTART_MAXIMIZED);
  if ToggleSwitchStartMaximized.IsOn then
  begin
    Self.WindowState := wsMaximized;
    Exit;
  end;

  lValue := aOptions.ReadValue(nHEIGHT);
  if not lValue.IsEmpty then
    Self.Height := lValue.ToInteger;

  lValue := aOptions.ReadValue(nWIDTH);
  if not lValue.IsEmpty then
    Self.Width := lValue.ToInteger;

  lValue := aOptions.ReadValue(nLEFT);
  if not lValue.IsEmpty then
    Self.Left := lValue.ToInteger;

  lValue := aOptions.ReadValue(nTOP);
  if not lValue.IsEmpty then
    Self.Top := lValue.ToInteger;
end;

procedure TfMonitor.CheckBoxAutoUpdateClick(Sender: TObject);
var
  lEnable: boolean;
begin
  lEnable := CheckBoxAutoUpdate.Checked;
  LabelInterval.Enabled := lEnable;
  SpinEditInterval.Enabled := lEnable;
  TimerAutoUpdate.Enabled := lEnable;
  SaveOption(sAUTO_UPDATE_ENABLED, lEnable.ToString);
end;

procedure TfMonitor.ClearFilters;
var
  lField: TField;
begin
  FDMemTableFilter.Edit;

  for lField in FDMemTableFilter.Fields do
    lField.Clear;

  EditSQLFilter.Clear;

  BuildFilter;
end;

procedure TfMonitor.ComboBoxStylesSelect(Sender: TObject);
begin
  TStyleManager.SetStyle(ComboBoxStyles.Text);
  SaveOption(sSELECTED_STYLE, ComboBoxStyles.Text);
end;

procedure TfMonitor.ManageTimer;
begin
  TimerAutoUpdate.Interval := SpinEditInterval.Value * 1000;
  TimerAutoUpdate.Enabled := CheckBoxAutoUpdate.Checked;
end;

procedure TfMonitor.CopyColumnValue;
var
  lFieldName: string;
begin
  lFieldName := DBGrid.SelectedField.FieldName;
  Clipboard.AsText := LogViewer.CopyValue(lFieldName);
end;

procedure TfMonitor.DBGridDblClick(Sender: TObject);
begin
  OpenSQLTab;
end;

procedure TfMonitor.DBGridFilterColEnter(Sender: TObject);
var
  lFieldName: string;
begin
  lFieldName := DBGridFilter.SelectedField.FieldName.ToUpper;
  if (lFieldName.Equals('TYPE')) or (lFieldName.Equals('ERROR')) then
    DBGridFilter.EditorMode := True;
end;

procedure TfMonitor.DBGridFilterColResize(Sender: TObject);
var
  Counter: integer;
begin
  for Counter := 0 to Pred(DBGridFilter.Columns.Count) do
    DBGrid.Columns[Counter].Width := DBGridFilter.Columns[Counter].Width;
end;

procedure TfMonitor.DBGridFilterColumnMoved(Sender: TObject; FromIndex,
  ToIndex: Integer);
var
  Counter: integer;
begin
  for Counter := 0 to Pred(DBGridFilter.Columns.Count) do
  begin
    DBGrid.Columns[Counter].FieldName := DBGridFilter.Columns[Counter].FieldName;
    DBGrid.Columns[Counter].Width := DBGridFilter.Columns[Counter].Width;
  end;
end;

procedure TfMonitor.DBGridFilterKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    BuildFilter;
  end;
end;

procedure TfMonitor.DBGridKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    OpenSQLTab;
  end;
end;

procedure TfMonitor.EditSQLFilterKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    BuildFilter;
  end;
end;

procedure TfMonitor.OnBeforeInsertAbort(DataSet: TDataSet);
begin
  Abort;
end;

procedure TfMonitor.OnDrawColumnCellHighlight(Sender: TObject; const Rect: TRect; DataCol: Integer;
  Column: TColumn; State: TGridDrawState);
begin
  if LogViewer.IsErrorLine then
  begin
    DBGrid.Canvas.Brush.Color := $00B9B9FF;
    DBGrid.DefaultDrawColumnCell(Rect, DataCol, Column, State);
  end;
end;

procedure TfMonitor.ShowInfoMessage(const aMessage: string);
begin
  MessageDlg(aMessage, mtInformation, [mbOK], 0);
end;

procedure TfMonitor.ShowRecordInfo;
begin
  if LogViewer.IsEmpty then
  begin
    LabelRecordInfoValue.Caption := EmptyStr;
    Exit;
  end;

  LabelRecordInfoValue.Caption := LogViewer.GetRecordCounter;
end;

procedure TfMonitor.SpinEditIntervalChange(Sender: TObject);
begin
  TimerAutoUpdate.Interval := SpinEditInterval.Value * 1000;
end;

procedure TfMonitor.SplitterMoved(Sender: TObject);
begin
  SaveOption(nSQL_BOTTOM_PANEL_HEIGHT, PanelSQL.Height.ToString);
end;

function TfMonitor.IsContentValid: boolean;
var
  lFileStream: TFileStream;
  lStringListFile: TStringList;
  lStringListLine: TStringList;
begin
  lFileStream := TFileStream.Create(LabelFileNameValue.Caption, fmOpenRead or fmShareDenyNone);
  lStringListFile := TStringList.Create;
  lStringListLine := TStringList.Create;
  try
    lStringListFile.LoadFromStream(lFileStream);

    lStringListLine.Delimiter := ';';
    lStringListLine.StrictDelimiter := True;
    lStringListLine.DelimitedText := lStringListFile[0];
    result := lStringListLine.Count >= 16;
  finally
    lStringListLine.Free;
    lStringListFile.Free;
    lFileStream.Free;
  end;

  if not result then
  begin
    LogViewer.EmptyDataSet;
    SynMemoSQL.Lines.Clear;
    LabelFileNameValue.Caption := EmptyStr;
    LabelRecordInfoValue.Caption := EmptyStr;

    MessageDlg('Arquivo de log inválido.', mtWarning, [mbOK], 0);
  end;
end;

function TfMonitor.IsFileNameValid: boolean;
begin
  result := False;

  if Trim(LabelFileNameValue.Caption).IsEmpty then
    Exit;

  if not FileExists(LabelFileNameValue.Caption) then
    Exit;

  result := True;
end;

procedure TfMonitor.FDMemTableFilterErrorSetText(Sender: TField; const Text: string);
begin
  Sender.AsString := Text;
  BuildFilter;
end;

procedure TfMonitor.FDMemTableFilterTypeSetText(Sender: TField; const Text: string);
begin
  Sender.AsString := Text;
  BuildFilter;
end;

procedure TfMonitor.FormClose(Sender: TObject; var Action: TCloseAction);
var
  lOptions: TOptions;
begin
  lOptions := TOptions.Create;
  try
    lOptions.SaveOption(nHEIGHT, Self.Height.ToString);
    lOptions.SaveOption(nWIDTH, Self.Width.ToString);
    lOptions.SaveOption(nLEFT, Self.Left.ToString);
    lOptions.SaveOption(nTOP, Self.Top.ToString);
  finally
    lOptions.Free;
  end;
end;

procedure TfMonitor.FormCreate(Sender: TObject);
begin
  FSQLFormatter := TSQLFormatter.Create;
  FDMemTableFilter.LogChanges := False;

  AddFilterEmptyLine;
  LoadStylesList;
  LoadOptions;
  LoadPickLists;
  AssignGridDrawEvent;
end;

procedure TfMonitor.FormDestroy(Sender: TObject);
begin
  FSQLFormatter.Free;
  inherited;
end;

procedure TfMonitor.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Shift = [ssAlt]) and (Key = 49) then
    PageControl.ActivePage := TabSheetLog;

  if (Shift = [ssAlt]) and (Key = 50) then
    PageControl.ActivePage := TabSheetSQL;

  if (Shift = [ssAlt]) and (Key = 51) then
    PageControl.ActivePage := TabSheetOptions;

  if Key = VK_F4 then
    ClearFilters;
end;

procedure TfMonitor.FormShow(Sender: TObject);
begin
  GetMostRecentLog;
end;

procedure TfMonitor.SaveOption(const aKey: string; const aValue: string);
var
  lOptions: TOptions;
begin
  if FLoadingOptionsOnStartup then
    Exit;

  lOptions := TOptions.Create;
  try
    lOptions.SaveOption(aKey, aValue);
  finally
    lOptions.Free;
  end;
end;

procedure TfMonitor.LogViewerAfterScroll(DataSet: TDataSet);
begin
  ShowRecordInfo;
  LoadSQLBottomPanel;

  if PageControl.ActivePage = TabSheetSQL then
    LoadSQLTab;
end;

procedure TfMonitor.MenuItemCopyColumnValueClick(Sender: TObject);
begin
  CopyColumnValue;
end;

procedure TfMonitor.MenuItemCopySQLClick(Sender: TObject);
begin
  SynMemoTab.Lines.Text := FSQLFormatter.FormatSQL(LogViewer.GetSQL);
  Clipboard.AsText := SynMemoTab.Lines.Text;
end;

procedure TfMonitor.TabSheetSQLEnter(Sender: TObject);
begin
  LoadSQLTab;
  end;

procedure TfMonitor.TimerAutoUpdateTimer(Sender: TObject);
begin
  LoadLogOnTimer;
end;

procedure TfMonitor.ToggleSwitchAutoFormatSQLClick(Sender: TObject);
begin
  LoadSQLBottomPanel;
  SaveOption(sAUTO_FORMAT_SQL, ToggleSwitchIgnoreBasicLog.IsOn.ToString);
end;

procedure TfMonitor.ToggleSwitchHighlightErrorsClick(Sender: TObject);
var
  lEnable: boolean;
begin
  lEnable := ToggleSwitchHighlightErrors.IsOn;
  SaveOption(sHIGHLIGHT_ERRORS, lEnable.ToString);
  AssignGridDrawEvent;
end;

procedure TfMonitor.ToggleSwitchIgnoreBasicLogClick(Sender: TObject);
var
  lEnable: boolean;
begin
  lEnable := ToggleSwitchIgnoreBasicLog.IsOn;
  SaveOption(sIGNORE_BASIC_LOG, lEnable.ToString);
  LogViewer.IgnoreBasicLog := lEnable;
  LogViewer.ResetCounter;
  LoadLog;
end;

procedure TfMonitor.ToggleSwitchRowSelectClick(Sender: TObject);
var
  lEnable: boolean;
begin
  lEnable := ToggleSwitchRowSelect.IsOn;
  SaveOption(sROW_SELECT, lEnable.ToString);

  LabelCtrlQ.Enabled := not lEnable;
  LabelCopySQL.Enabled := not lEnable;

  DBGrid.Options := DBGrid.Options - [dgRowSelect];
  if lEnable then
    DBGrid.Options := DBGrid.Options + [dgRowSelect];
end;

procedure TfMonitor.ToggleSwitchShowLineNumbersClick(Sender: TObject);
var
  lEnable: boolean;
begin
  lEnable := ToggleSwitchShowLineNumbers.IsOn;
  SynMemoSQL.Gutter.Visible := lEnable;
  SynMemoTab.Gutter.Visible := lEnable;
  SaveOption(sSHOW_LINE_NUMBERS, lEnable.ToString);
end;

procedure TfMonitor.ToggleSwitchShowBottomPanelClick(Sender: TObject);
var
  lEnable: boolean;
begin
  lEnable := ToggleSwitchShowBottomPanel.IsOn;
  PanelSQL.Visible := lEnable;
  Splitter.Visible := lEnable;
  SaveOption(sSHOW_BOTTOM_PANEL, lEnable.ToString);

  if lEnable then
    LoadSQLBottomPanel;
end;

procedure TfMonitor.ToggleSwitchShowOnlySQLClick(Sender: TObject);
var
  lEnable: boolean;
begin
  lEnable := ToggleSwitchShowOnlySQL.IsOn;
  SaveOption(sSHOW_ONLY_SQL, lEnable.ToString);
  LogViewer.ShowOnlySQL := lEnable;
  LogViewer.ResetCounter;
  LoadLog;
end;

procedure TfMonitor.ToggleSwitchStartMaximizedClick(Sender: TObject);
begin
  SaveOption(sSTART_MAXIMIZED, ToggleSwitchStartMaximized.IsOn.ToString);
end;

procedure TfMonitor.ToggleSwitchStayOnTopClick(Sender: TObject);
var
  lEnable: boolean;
begin
  lEnable := ToggleSwitchStayOnTop.IsOn;
  SaveOption(sSTAY_ON_TOP, lEnable.ToString);

  Self.FormStyle := fsNormal;
  if lEnable then
    Self.FormStyle := fsStayOnTop;
end;

procedure TfMonitor.ToggleSwitchUseToDateFunctionClick(Sender: TObject);
var
  lEnable: boolean;
begin
  lEnable := ToggleSwitchUseToDateFunction.IsOn;
  FSQLFormatter.UseToDateFunction := lEnable;
  SaveOption(sUSE_TODATE_FUNCTION, lEnable.ToString);
end;

end.