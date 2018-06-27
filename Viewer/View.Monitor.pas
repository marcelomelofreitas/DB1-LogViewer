unit View.Monitor;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Data.DB, Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.Samples.Spin, Vcl.ComCtrls, Vcl.Menus,
  Utils.SQLFormatter, System.Actions, Vcl.ActnList,
  Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan, Vcl.ActnCtrls,
  Data.Bind.EngExt, Vcl.Bind.DBEngExt, System.Rtti, System.Bindings.Outputs,
  Vcl.Bind.Editors, Data.Bind.Components, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Component.FDLogViewer,
  Vcl.WinXCtrls, FireDAC.Phys.Intf, FireDAC.DApt.Intf, System.ImageList, Vcl.ImgList, Vcl.ToolWin,
  Component.RichEditSQL, FireDAC.Stan.StorageBin;

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
    DBGrid: TDBGrid;
    EditFileName: TEdit;
    GroupBoxAutoUpdate: TGroupBox;
    GroupBoxLog: TGroupBox;
    GroupBoxShortCuts: TGroupBox;
    GroupBoxVisual: TGroupBox;
    ImageList: TImageList;
    LabelAlt1: TLabel;
    LabelAlt2: TLabel;
    LabelAlt3: TLabel;
    LabelClearLog: TLabel;
    LabelCopyColumnValue: TLabel;
    LabelCopySQL: TLabel;
    LabelCtrlC: TLabel;
    LabelCtrlL: TLabel;
    LabelCtrlO: TLabel;
    LabelCtrlQ: TLabel;
    LabelF5: TLabel;
    LabelInterval: TLabel;
    LabelOpenFile: TLabel;
    LabelRecordInfo: TLabel;
    LabelReloadLog: TLabel;
    LabelShowLogTab: TLabel;
    LabelShowOptionsTab: TLabel;
    LabelShowSQLTab: TLabel;
    LabelStyle: TLabel;
    LinkControlToPropertyLabel: TLinkControlToProperty;
    LinkControlToPropertySpinEdit: TLinkControlToProperty;
    LogViewer: TFDLogViewer;
    MenuItemCopyColumnValue: TMenuItem;
    MenuItemCopySQL: TMenuItem;
    PageControl: TPageControl;
    PanelGrid: TPanel;
    PanelOptions: TPanel;
    PanelSQL: TPanel;
    PopupMenu: TPopupMenu;
    SpinEditInterval: TSpinEdit;
    Splitter: TSplitter;
    TabSheetLog: TTabSheet;
    TabSheetOptions: TTabSheet;
    TabSheetSQL: TTabSheet;
    TimerAutoUpdate: TTimer;
    ToggleSwitchHighlightErrors: TToggleSwitch;
    ToggleSwitchIgnoreBasicLog: TToggleSwitch;
    ToggleSwitchShowOnlySQL: TToggleSwitch;
    ToggleSwitchStayOnTop: TToggleSwitch;
    ToggleSwitchShowBottomPanel: TToggleSwitch;
    ToggleSwitchAutoFormatSQL: TToggleSwitch;
    LabelAutoFormatInfo: TLabel;
    LabelIgnoreBasicLogInfo: TLabel;
    RichEditSQLTab: TRichEditSQL;
    DBGridFilter: TDBGrid;
    DataSourceFilter: TDataSource;
    FDMemTableFilter: TFDMemTable;
    FDMemTableFilterType: TStringField;
    FDMemTableFilterDatabase: TStringField;
    FDMemTableFilterUser: TStringField;
    FDMemTableFilterIP: TStringField;
    FDMemTableFilterClass: TStringField;
    FDMemTableFilterMethod: TStringField;
    FDMemTableFilterDateTime: TStringField;
    RichEditSQLPanel: TRichEditSQL;
    procedure ActionClearLogExecute(Sender: TObject);
    procedure ActionOpenFileExecute(Sender: TObject);
    procedure ActionReloadLogExecute(Sender: TObject);
    procedure CheckBoxAutoUpdateClick(Sender: TObject);
    procedure ComboBoxStylesSelect(Sender: TObject);
    procedure DBGridDblClick(Sender: TObject);
    procedure DBGridKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure LogViewerAfterScroll(DataSet: TDataSet);
    procedure MenuItemCopyColumnValueClick(Sender: TObject);
    procedure MenuItemCopySQLClick(Sender: TObject);
    procedure TabSheetSQLEnter(Sender: TObject);
    procedure TimerAutoUpdateTimer(Sender: TObject);
    procedure ToggleSwitchHighlightErrorsClick(Sender: TObject);
    procedure ToggleSwitchIgnoreBasicLogClick(Sender: TObject);
    procedure ToggleSwitchShowBottomPanelClick(Sender: TObject);
    procedure ToggleSwitchShowOnlySQLClick(Sender: TObject);
    procedure ToggleSwitchStayOnTopClick(Sender: TObject);
    procedure LabelAutoFormatInfoClick(Sender: TObject);
    procedure LabelIgnoreBasicLogInfoClick(Sender: TObject);
    procedure ToggleSwitchAutoFormatSQLClick(Sender: TObject);
    procedure DBGridFilterKeyPress(Sender: TObject; var Key: Char);
    procedure DBGridFilterColEnter(Sender: TObject);
    procedure DBGridFilterKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    // class fields
    FLoadingOptionsAtStartup: boolean;

    // event handlers
    procedure OnDrawColumnCellHighlight(Sender: TObject; const Rect: TRect; DataCol: Integer;
      Column: TColumn; State: TGridDrawState);

    // private functions
    function IsFileNameValid: boolean;
    function IsContentValid: boolean;
    function OpenFile: string;

    // private procedures
    procedure AssignGridDrawEvent;
    procedure BuildFilter;
    procedure CopyColumnValue;
    procedure GetMostRecentLog;
    procedure LoadLog;
    procedure LoadLogAtTimer;
    procedure LoadOptions;
    procedure LoadSelectedStyle(const aSelectedStyle: string);
    procedure LoadSQLBottomPanel;
    procedure LoadStylesList;
    procedure LoadTypePickList;
    procedure ManageTimer;
    procedure OpenSQLTab;
    procedure SaveOption(const aKey: string; const aValue: string);
    procedure ShowRecordInfo;
  end;

var
  fMonitor: TfMonitor;

implementation

uses
  VCL.Themes, ClipBrd, Utils.Options, Utils.Constants, Utils.Helpers,
  View.Loading, System.UITypes;

{$R *.dfm}

function TfMonitor.OpenFile: string;
var
  lOpenDialog: TOpenDialog;
begin
  lOpenDialog := TOpenDialog.Create(nil);
  try
    lOpenDialog.InitialDir := 'Q:\bin';
    lOpenDialog.Filter := 'Log de métodos do servidor|spLogMetodoServidor*.txt|Arquivos TXT|*.txt';
    lOpenDialog.DefaultExt := 'txt';

    if not lOpenDialog.Execute then
      Exit;

    EditFileName.Text := Trim(lOpenDialog.FileName);
    result := EditFileName.Text;
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

  EditFileName.Text := lFileName.Trim;
  LogViewer.ResetCounter;
  LoadLog;
end;

procedure TfMonitor.ActionReloadLogExecute(Sender: TObject);
begin
  LogViewer.ReloadLog;
end;

procedure TfMonitor.ActionClearLogExecute(Sender: TObject);
begin
  LogViewer.EmptyDataSet;
  LabelRecordInfo.Caption := EmptyStr;
  RichEditSQLPanel.Lines.Clear;
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
begin
  lBuilderFilter := TStringBuilder.Create;
  try
    lBuilderFilter.Append('1 = 1');

    for lField in FDMemTableFilter.Fields do
    begin
      if not lField.AsString.IsEmpty then
      begin
        lBuilderFilter
          .Append(' and ')
          .Append(lField.FieldName)
          .Append(' like ')
          .Append(QuotedStr('%' + lField.AsString + '%'));
      end;
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

procedure TfMonitor.GetMostRecentLog;
var
  lSearchRec: TSearchRec;
  lFileTime: TFileTime;
  lFileName: string;
begin
  if FindFirst('Q:\Bin\spLogMetodoServidor*.txt', faNormal, lSearchRec) <> 0 then
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
  EditFileName.Text := 'Q:\bin\' + lFileName.Trim;
  LoadLog;
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

    MessageDlg(lStringBuilder.ToString, mtInformation, [mbOK], 0);
  finally
    lStringBuilder.Free;
  end;
end;

procedure TfMonitor.LabelIgnoreBasicLogInfoClick(Sender: TObject);
var
  lStringBuilder: TStringBuilder;
begin
  lStringBuilder := TStringBuilder.Create;
  try
    lStringBuilder
      .Append('Ignora os métodos da classe TfpgServidorDM, como:')
      .AppendLine.AppendLine
      .Append('- Login').AppendLine
      .Append('- LoginInterno').AppendLine
      .Append('- AutenticarUsuario');

    MessageDlg(lStringBuilder.ToString, mtInformation, [mbOK], 0);
  finally
    lStringBuilder.Free;
  end;
end;

procedure TfMonitor.LoadLog;
var
  fLoading: TfLoading;
begin
  if not IsFileNameValid then
    Exit;

  if not IsContentValid then
    Exit;

  TimerAutoUpdate.Enabled := False;
  LogViewer.EmptyDataSet;

  fLoading := TfLoading.Create(nil);
  try
    fLoading.Show;
    Application.ProcessMessages;
    LogViewer.LogFileName := EditFileName.Text;
    LogViewer.LoadLog;
  finally
    fLoading.Free;
  end;

  ShowRecordInfo;
  ManageTimer;
  LoadSQLBottomPanel;
end;

procedure TfMonitor.LoadLogAtTimer;
begin
  if not IsFileNameValid then
    Exit;

  LogViewer.LoadLog;
  ShowRecordInfo;
  LoadSQLBottomPanel;
end;

procedure TfMonitor.LoadOptions;
var
  lOptions: TOptions;
begin
  FLoadingOptionsAtStartup := True;
  lOptions := TOptions.Create;
  try
    CheckBoxAutoUpdate.Checked := lOptions.ReadEnabled(sAUTO_UPDATE_ENABLED);
    ToggleSwitchShowOnlySQL.Checked := lOptions.ReadEnabled(sSHOW_ONLY_SQL);
    ToggleSwitchHighlightErrors.Checked := lOptions.ReadEnabled(sHIGHLIGHT_ERRORS);
    ToggleSwitchShowBottomPanel.Checked := lOptions.ReadEnabled(sSHOW_BOTTOM_PANEL);
    ToggleSwitchIgnoreBasicLog.Checked := lOptions.ReadEnabled(sIGNORE_BASIC_LOG);
    ToggleSwitchStayOnTop.Checked := lOptions.ReadEnabled(sSTAY_ON_TOP);
    LoadSelectedStyle(lOptions.ReadValue(sSELECTED_STYLE));
  finally
    lOptions.Free;
    FLoadingOptionsAtStartup := False;
  end;
end;

procedure TfMonitor.LoadSelectedStyle(const aSelectedStyle: string);
var
  lStyleName: string;
begin
  lStyleName := aSelectedStyle;
  if lStyleName.IsEmpty then
    lStyleName := sDEFAULT_STYLE;

  ComboBoxStyles.ItemIndex := ComboBoxStyles.Items.IndexOf(lStyleName);
  TStyleManager.SetStyle(lStyleName);
end;

procedure TfMonitor.LoadSQLBottomPanel;
begin
  if not ToggleSwitchShowBottomPanel.IsOn then
    Exit;

  RichEditSQLPanel.Lines.Clear;

  if LogViewer.IsSQLEmpty then
    Exit;

  RichEditSQLPanel.Lines.Text := LogViewer.GetSQL;

  if ToggleSwitchAutoFormatSQL.IsOn then
    RichEditSQLPanel.FormatSQL;

  //RichEditSQLPanel.HightlightSQL;
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

procedure TfMonitor.LoadTypePickList;
var
  lTypeColumn: TColumn;
begin
  lTypeColumn := DBGridFilter.Columns[0];
  lTypeColumn.PickList.Add('ENTRADA');
  lTypeColumn.PickList.Add('AVISO');
  lTypeColumn.PickList.Add('SAIDA');
  lTypeColumn.PickList.Add('SQL');
end;

procedure TfMonitor.CheckBoxAutoUpdateClick(Sender: TObject);
var
  lEnable: boolean;
begin
  lEnable := CheckBoxAutoUpdate.Checked;
  TimerAutoUpdate.Enabled := lEnable;
  SaveOption(sAUTO_UPDATE_ENABLED, lEnable.ToString);
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
begin
  if DBGridFilter.SelectedField.FieldName.ToUpper.Equals('TYPE') then
    DBGridFilter.EditorMode := True;
end;

procedure TfMonitor.DBGridFilterKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_DELETE then
  begin
    FDMemTableFilter.Edit;
    DBGridFilter.SelectedField.Clear;
    FDMemTableFilter.Post;
    BuildFilter;
  end;
end;

procedure TfMonitor.DBGridFilterKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    BuildFilter;
  end;
end;

procedure TfMonitor.DBGridKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    OpenSQLTab;
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

procedure TfMonitor.ShowRecordInfo;
begin
  if LogViewer.IsEmpty then
  begin
    LabelRecordInfo.Caption := EmptyStr;
    Exit;
  end;

  LabelRecordInfo.Caption := LogViewer.GetRecordCounter;
end;

function TfMonitor.IsContentValid: boolean;
var
  lFileStream: TFileStream;
  lStringListFile: TStringList;
  lStringListLine: TStringList;
begin
  lFileStream := TFileStream.Create(EditFileName.Text, fmOpenRead or fmShareDenyNone);
  lStringListFile := TStringList.Create;
  lStringListLine := TStringList.Create;
  try
    lStringListFile.LoadFromStream(lFileStream);

    lStringListLine.Delimiter := ';';
    lStringListLine.StrictDelimiter := True;
    lStringListLine.DelimitedText := lStringListFile[0];
    result := lStringListLine.Count = 16;
  finally
    lStringListLine.Free;
    lStringListFile.Free;
    lFileStream.Free;
  end;

  if not result then
  begin
    LogViewer.EmptyDataSet;
    RichEditSQLPanel.Lines.Clear;
    EditFileName.Clear;
    LabelRecordInfo.Caption := EmptyStr;

    MessageDlg('Arquivo de log inválido.', mtWarning, [mbOK], 0);
  end;
end;

function TfMonitor.IsFileNameValid: boolean;
begin
  result := False;

  if Trim(EditFileName.Text).IsEmpty then
    Exit;

  if not FileExists(EditFileName.Text) then
    Exit;

  result := True;
end;

procedure TfMonitor.FormCreate(Sender: TObject);
begin
  LoadStylesList;
  LoadOptions;
  LoadTypePickList;
  GetMostRecentLog;
  AssignGridDrawEvent;
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
end;

procedure TfMonitor.SaveOption(const aKey: string; const aValue: string);
var
  lOptions: TOptions;
begin
  if FLoadingOptionsAtStartup then
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
end;

procedure TfMonitor.MenuItemCopyColumnValueClick(Sender: TObject);
begin
  CopyColumnValue;
end;

procedure TfMonitor.MenuItemCopySQLClick(Sender: TObject);
begin
  RichEditSQLTab.Lines.Text := LogViewer.GetSQL;
  RichEditSQLTab.FormatSQL;
  Clipboard.AsText := RichEditSQLTab.Lines.Text;
end;

procedure TfMonitor.TabSheetSQLEnter(Sender: TObject);
begin
  if LogViewer.IsSQLEmpty then
    Exit;

  RichEditSQLTab.Lines.Text := LogViewer.GetSQL;
  RichEditSQLTab.FormatSQL;
  RichEditSQLTab.HightlightSQL;
end;

procedure TfMonitor.TimerAutoUpdateTimer(Sender: TObject);
begin
  LoadLogAtTimer;
end;

procedure TfMonitor.ToggleSwitchAutoFormatSQLClick(Sender: TObject);
begin
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

end.
