unit View.Monitor;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.ExtCtrls, Vcl.Grids,
  Vcl.DBGrids, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.Samples.Spin, Vcl.ComCtrls, Vcl.Menus,
  Utils.SQLFormatter, System.Actions, Vcl.ActnList,
  Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan, Vcl.ActnCtrls,
  Data.Bind.EngExt, Vcl.Bind.DBEngExt, System.Rtti, System.Bindings.Outputs,
  Vcl.Bind.Editors, Data.Bind.Components, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Component.FDLogViewer, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, System.ImageList, Vcl.ImgList, Vcl.ToolWin;

type
  TfMonitor = class(TForm)
    ActionClearLog: TAction;
    ActionManager: TActionManager;
    ActionOpenFile: TAction;
    ActionReloadLog: TAction;
    ActionToolBar: TActionToolBar;
    BindingsList: TBindingsList;
    CheckBoxAlwaysOnTop: TCheckBox;
    CheckBoxAutoUpdate: TCheckBox;
    CheckBoxHighlightErrors: TCheckBox;
    CheckBoxIgnoreBasicLog: TCheckBox;
    CheckBoxShowBottomPanel: TCheckBox;
    CheckBoxShowOnlySQL: TCheckBox;
    ComboBoxStyles: TComboBox;
    ComboBoxType: TComboBox;
    DataSource: TDataSource;
    DBGrid: TDBGrid;
    EditFileName: TEdit;
    EditFilterClass: TEdit;
    EditFilterMethod: TEdit;
    EditFilterSQL: TEdit;
    GroupBoxAutoUpdate: TGroupBox;
    GroupBoxFilters: TGroupBox;
    GroupBoxLog: TGroupBox;
    GroupBoxVisual: TGroupBox;
    ImageList: TImageList;
    LabelInterval: TLabel;
    LabelRecordInfo: TLabel;
    LabelStyle: TLabel;
    LinkControlToPropertyLabel: TLinkControlToProperty;
    LinkControlToPropertySpinEdit: TLinkControlToProperty;
    LogViewer: TFDLogViewer;
    MemoSQL: TMemo;
    MemoSQLTab: TMemo;
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
    procedure ActionClearLogExecute(Sender: TObject);
    procedure ActionOpenFileExecute(Sender: TObject);
    procedure ActionReloadLogExecute(Sender: TObject);
    procedure ComboBoxStylesSelect(Sender: TObject);
    procedure ComboBoxTypeChange(Sender: TObject);
    procedure DBGridDblClick(Sender: TObject);
    procedure DBGridKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure LogViewerAfterScroll(DataSet: TDataSet);
    procedure MemoSQLKeyPress(Sender: TObject; var Key: Char);
    procedure MemoSQLTabKeyPress(Sender: TObject; var Key: Char);
    procedure MenuItemCopyColumnValueClick(Sender: TObject);
    procedure MenuItemCopySQLClick(Sender: TObject);
    procedure TabSheetSQLEnter(Sender: TObject);
    procedure TimerAutoUpdateTimer(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    // class fields
    FSQLFormatter: TSQLFormatter;

    // event handlers
    procedure OnDrawColumnCellHighlight(Sender: TObject; const Rect: TRect; DataCol: Integer;
      Column: TColumn; State: TGridDrawState);
    procedure OnKeyPressFilterComponents(Sender: TObject; var Key: Char);

    // checkboxes event handlers
    procedure CheckBoxAutoUpdateClick(Sender: TObject);
    procedure CheckBoxHighlightErrorsClick(Sender: TObject);
    procedure CheckBoxShowBottomPanelClick(Sender: TObject);
    procedure CheckBoxShowOnlySQLClick(Sender: TObject);
    procedure CheckBoxAlwaysOnTopClick(Sender: TObject);
    procedure CheckBoxIgnoreBasicLogClick(Sender: TObject);

    // private functions
    function FormatSQL: string;
    function GetFieldName(aComponent: TEdit): string;
    function IsFileNameValid: boolean;
    function OpenFile: string;

    // private procedures
    procedure AssignCheckBoxesEvents;
    procedure AssignFilterEvents;
    procedure AssignGridDrawEvent;
    procedure ClearFilterComponents(aComponent: TEdit);
    procedure CopyColumnValue;
    procedure FilterRecords(const aFieldName, aValue: string);
    procedure GetMostRecentLog;
    procedure LoadLog;
    procedure LoadOptions;
    procedure LoadSelectedStyle(const aSelectedStyle: string);
    procedure LoadSQLBottomPanel;
    procedure LoadStylesList;
    procedure ManageTimer;
    procedure OpenSQLTab;
    procedure SaveOption(const aKey: string; const aValue: string);
    procedure ShowRecordInfo;
  end;

var
  fMonitor: TfMonitor;

implementation

uses
  VCL.Themes, ClipBrd, Utils.Options, Utils.Constants, View.Loading;

{$R *.dfm}

function TfMonitor.OpenFile: string;
var
  lOpenDialog: TOpenDialog;
begin
  lOpenDialog := TOpenDialog.Create(nil);
  try
    lOpenDialog.InitialDir := 'Q:\bin';
    lOpenDialog.Filter := 'Log de métodos do servidor|spLogMetodoServidor*.txt';
    lOpenDialog.DefaultExt := 'txt';

    if not lOpenDialog.Execute then
      Exit;

    result := Trim(lOpenDialog.FileName);
    EditFileName.Text := Trim(lOpenDialog.FileName);
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
  MemoSQL.Lines.Clear;
end;

procedure TfMonitor.AssignGridDrawEvent;
begin
  DBGrid.OnDrawColumnCell := nil;
  if CheckBoxHighlightErrors.Checked then
    DBGrid.OnDrawColumnCell := OnDrawColumnCellHighlight;
end;

procedure TfMonitor.AssignCheckBoxesEvents;
begin
  CheckBoxAutoUpdate.OnClick := CheckBoxAutoUpdateClick;
  CheckBoxShowOnlySQL.OnClick := CheckBoxShowOnlySQLClick;
  CheckBoxHighlightErrors.OnClick := CheckBoxHighlightErrorsClick;
  CheckBoxShowBottomPanel.OnClick := CheckBoxShowBottomPanelClick;
  CheckBoxAlwaysOnTop.OnClick := CheckBoxAlwaysOnTopClick;
  CheckBoxIgnoreBasicLog.OnClick := CheckBoxIgnoreBasicLogClick;
end;

procedure TfMonitor.AssignFilterEvents;
begin
  EditFilterClass.OnKeyPress := OnKeyPressFilterComponents;
  EditFilterMethod.OnKeyPress := OnKeyPressFilterComponents;
  EditFilterSQL.OnKeyPress := OnKeyPressFilterComponents;
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

procedure TfMonitor.LoadLog;
var
  fLoading: TfLoading;
begin
  if not IsFileNameValid then
    Exit;

  TimerAutoUpdate.Enabled := False;

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

procedure TfMonitor.LoadOptions;
var
  lOptions: TOptions;
begin
  lOptions := TOptions.Create;
  try
    // Auto Update
    CheckBoxAutoUpdate.Checked := lOptions.ReadEnabled(sAUTO_UPDATE_ENABLED);
    LabelInterval.Enabled := lOptions.ReadEnabled(sAUTO_UPDATE_ENABLED);
    SpinEditInterval.Enabled := lOptions.ReadEnabled(sAUTO_UPDATE_ENABLED);

    // Show Only SQL
    CheckBoxShowOnlySQL.Checked := lOptions.ReadEnabled(sSHOW_ONLY_SQL);
    LogViewer.ShowOnlySQL := lOptions.ReadEnabled(sSHOW_ONLY_SQL);

    // Highlight Errors
    CheckBoxHighlightErrors.Checked := lOptions.ReadEnabled(sHIGHLIGHT_ERRORS);

    // Show Bottom Panel
    CheckBoxShowBottomPanel.Checked := lOptions.ReadEnabled(sSHOW_BOTTOM_PANEL);
    PanelSQL.Visible := lOptions.ReadEnabled(sSHOW_BOTTOM_PANEL);

    // Don't Load Basic Log (TfpgServidorDM)
    CheckBoxIgnoreBasicLog.Checked := lOptions.ReadEnabled(sIGNORE_BASIC_LOG);
    LogViewer.IgnoreBasicLog := lOptions.ReadEnabled(sIGNORE_BASIC_LOG);

    // AlwaysOnTop
    CheckBoxAlwaysOnTop.Checked := lOptions.ReadEnabled(sALWAYS_ON_TOP);
    if CheckBoxAlwaysOnTop.Checked then
      Self.FormStyle := fsStayOnTop;

    // Theme
    LoadSelectedStyle(lOptions.ReadValue(sSELECTED_THEME));
  finally
    lOptions.Free;
  end;
end;

procedure TfMonitor.LoadSelectedStyle(const aSelectedStyle: string);
var
  lStyleName: string;
begin
  lStyleName := aSelectedStyle;
  if lStyleName.IsEmpty then
    lStyleName := 'Windows';

  ComboBoxStyles.ItemIndex := ComboBoxStyles.Items.IndexOf(lStyleName);
  TStyleManager.SetStyle(lStyleName);
end;

procedure TfMonitor.LoadSQLBottomPanel;
begin
  if not CheckBoxShowBottomPanel.Checked then
    Exit;

  MemoSQL.Lines.Clear;
  if not LogViewer.IsSQLEmpty then
    MemoSQL.Lines.Text := FormatSQL;
end;

procedure TfMonitor.LoadStylesList;
var
  lStyle :String;
begin
  ComboBoxStyles.Clear;

  for lStyle in TStyleManager.StyleNames do
    ComboBoxStyles.Items.Add(lStyle);
end;

procedure TfMonitor.CheckBoxShowBottomPanelClick(Sender: TObject);
var
  lEnable: boolean;
begin
  lEnable := CheckBoxShowBottomPanel.Checked;
  PanelSQL.Visible := lEnable;
  SaveOption(sSHOW_BOTTOM_PANEL, lEnable.ToString);

  if lEnable then
    LoadSQLBottomPanel;
end;

procedure TfMonitor.CheckBoxAlwaysOnTopClick(Sender: TObject);
var
  lEnable: boolean;
begin
  lEnable := CheckBoxAlwaysOnTop.Checked;
  SaveOption(sALWAYS_ON_TOP, lEnable.ToString);

  Self.FormStyle := fsNormal;
  if lEnable then
    Self.FormStyle := fsStayOnTop;
end;

procedure TfMonitor.CheckBoxAutoUpdateClick(Sender: TObject);
var
  lEnable: boolean;
begin
  lEnable := CheckBoxAutoUpdate.Checked;
  TimerAutoUpdate.Enabled := lEnable;
  SaveOption(sAUTO_UPDATE_ENABLED, lEnable.ToString);
end;

procedure TfMonitor.CheckBoxIgnoreBasicLogClick(Sender: TObject);
var
  lEnable: boolean;
begin
  lEnable := CheckBoxIgnoreBasicLog.Checked;
  SaveOption(sIGNORE_BASIC_LOG, lEnable.ToString);
  LogViewer.IgnoreBasicLog := lEnable;
  LogViewer.ReloadLog;
end;

procedure TfMonitor.CheckBoxHighlightErrorsClick(Sender: TObject);
var
  lEnable: boolean;
begin
  lEnable := CheckBoxHighlightErrors.Checked;
  SaveOption(sHIGHLIGHT_ERRORS, lEnable.ToString);
  AssignGridDrawEvent;
end;

procedure TfMonitor.CheckBoxShowOnlySQLClick(Sender: TObject);
var
  lEnable: boolean;
begin
  lEnable := CheckBoxShowOnlySQL.Checked;
  SaveOption(sSHOW_ONLY_SQL, lEnable.ToString);
  LogViewer.ShowOnlySQL := lEnable;
  LogViewer.ReloadLog;
end;

procedure TfMonitor.ComboBoxStylesSelect(Sender: TObject);
begin
  TStyleManager.SetStyle(ComboBoxStyles.Text);
  SaveOption(sSELECTED_THEME, ComboBoxStyles.Text);
end;

procedure TfMonitor.ComboBoxTypeChange(Sender: TObject);
var
  lValue: string;
begin
  lValue := EmptyStr;
  if ComboBoxType.ItemIndex > 0 then
    lValue := ComboBoxType.Text;

  FilterRecords('Type', lValue);
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

procedure TfMonitor.DBGridKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    OpenSQLTab;
end;

procedure TfMonitor.OnKeyPressFilterComponents(Sender: TObject; var Key: Char);
var
  lComponent: TEdit;
  lFieldName: string;
begin
  if Key = #13 then
  begin
    Key := #0;
    lComponent := (Sender as TEdit);
    lFieldName := GetFieldName(lComponent);
    ClearFilterComponents(lComponent);
    FilterRecords(lFieldName, lComponent.Text);
   end;
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

function TfMonitor.IsFileNameValid: boolean;
begin
  result := False;

  if Trim(EditFileName.Text).IsEmpty then
    Exit;

  if not FileExists(EditFileName.Text) then
    Exit;

  result := True;
end;

procedure TfMonitor.FilterRecords(const aFieldName, aValue: string);
var
  lFilter: string;
  lValue: string;
begin
  if aValue.IsEmpty then
  begin
    LogViewer.RemoveFilter;
    Exit;
  end;

  lFilter := EmptyStr;
  if aFieldName = 'SQL' then
    lFilter := Format('Type = %s AND ', [aFieldName.QuotedString]);

  lValue := '%' + aValue + '%';
  lFilter := lFilter.Format('%s like %s', [aFieldName, lValue.QuotedString]);

  LogViewer.SetLogFilter(lFilter);
end;

function TfMonitor.FormatSQL: string;
begin
  result := FSQLFormatter.FormatSQL(LogViewer.GetSQL);
end;

procedure TfMonitor.FormCreate(Sender: TObject);
begin
  FSQLFormatter := TSQLFormatter.Create;
  LoadStylesList;
  LoadOptions;
  GetMostRecentLog;
  AssignCheckBoxesEvents;
  AssignFilterEvents;
  AssignGridDrawEvent;
end;

procedure TfMonitor.FormDestroy(Sender: TObject);
begin
  FSQLFormatter.Free;
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
  lOptions := TOptions.Create;
  try
    lOptions.SaveOption(aKey, aValue);
  finally
    lOptions.Free;
  end;
end;

procedure TfMonitor.ClearFilterComponents(aComponent: TEdit);
begin
  ComboBoxType.ItemIndex := 0;

  if EditFilterClass.Name <> aComponent.Name then
    EditFilterClass.Clear;

  if EditFilterMethod.Name <> aComponent.Name then
    EditFilterMethod.Clear;

  if EditFilterSQL.Name <> aComponent.Name then
    EditFilterSQL.Clear;
end;

procedure TfMonitor.LogViewerAfterScroll(DataSet: TDataSet);
begin
  ShowRecordInfo;
  LoadSQLBottomPanel;
end;

procedure TfMonitor.MemoSQLTabKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = ^A then
    MemoSQLTab.SelectAll;
end;

procedure TfMonitor.MemoSQLKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = ^C then
    ClipBoard.AsText := MemoSQL.Lines.Text;

  if Key = ^A then
    MemoSQL.SelectAll;
end;

procedure TfMonitor.MenuItemCopyColumnValueClick(Sender: TObject);
begin
  CopyColumnValue;
end;

procedure TfMonitor.MenuItemCopySQLClick(Sender: TObject);
begin
  Clipboard.AsText := FormatSQL;
end;

function TfMonitor.GetFieldName(aComponent: TEdit): string;
begin
  result := StringReplace(aComponent.Name, 'EditFilter', EmptyStr, []);
end;

procedure TfMonitor.TabSheetSQLEnter(Sender: TObject);
begin
  MemoSQLTab.Lines.Text := FormatSQL;
end;

procedure TfMonitor.TimerAutoUpdateTimer(Sender: TObject);
begin
  LoadLog;
end;

end.
