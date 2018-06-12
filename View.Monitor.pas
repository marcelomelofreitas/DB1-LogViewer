unit View.Monitor;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.ExtCtrls, Vcl.Grids,
  Vcl.DBGrids, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.Samples.Spin, Datasnap.DBClient, Vcl.ComCtrls, Vcl.Menus,
  Utils.SQLFormatter, System.ImageList, Vcl.ImgList, System.Actions, Vcl.ActnList,
  Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan, Vcl.ToolWin, Vcl.ActnCtrls,
  Data.Bind.EngExt, Vcl.Bind.DBEngExt, System.Rtti, System.Bindings.Outputs,
  Vcl.Bind.Editors, Data.Bind.Components, Component.LogViewer;

type
  TfMonitor = class(TForm)
    ActionOpenFile: TAction;
    ActionReloadLog: TAction;
    ActionClearLog: TAction;
    ActionManager: TActionManager;
    ActionToolBar: TActionToolBar;
    CheckBoxAutoUpdate: TCheckBox;
    CheckBoxHighlightErrors: TCheckBox;
    CheckBoxShowBottomPanel: TCheckBox;
    CheckBoxShowOnlySQL: TCheckBox;
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
    ImageList: TImageList;
    LabelRecordInfo: TLabel;
    LabelInterval: TLabel;
    MemoSQLTab: TMemo;
    MemoSQL: TMemo;
    MenuItemCopyColumnValue: TMenuItem;
    MenuItemCopySQL: TMenuItem;
    PageControl: TPageControl;
    PanelSQL: TPanel;
    PanelGrid: TPanel;
    PanelOptions: TPanel;
    PopupMenu: TPopupMenu;
    SpinEditInterval: TSpinEdit;
    Splitter: TSplitter;
    TabSheetLog: TTabSheet;
    TabSheetOptions: TTabSheet;
    TabSheetSQL: TTabSheet;
    TimerAutoUpdate: TTimer;
    BindingsList: TBindingsList;
    LinkControlToPropertyLabel: TLinkControlToProperty;
    LinkControlToPropertySpinEdit: TLinkControlToProperty;
    LogViewer: TLogViewer;
    procedure ActionOpenFileExecute(Sender: TObject);
    procedure ActionReloadLogExecute(Sender: TObject);
    procedure ActionClearLogExecute(Sender: TObject);
    procedure CheckBoxAutoUpdateClick(Sender: TObject);
    procedure CheckBoxHighlightErrorsClick(Sender: TObject);
    procedure CheckBoxShowBottomPanelClick(Sender: TObject);
    procedure CheckBoxShowOnlySQLClick(Sender: TObject);
    procedure ComboBoxTypeChange(Sender: TObject);
    procedure DBGridDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MemoSQLTabKeyPress(Sender: TObject; var Key: Char);
    procedure MemoSQLKeyPress(Sender: TObject; var Key: Char);
    procedure MenuItemCopyColumnValueClick(Sender: TObject);
    procedure MenuItemCopySQLClick(Sender: TObject);
    procedure TimerAutoUpdateTimer(Sender: TObject);
    procedure TabSheetSQLEnter(Sender: TObject);
    procedure DBGridKeyPress(Sender: TObject; var Key: Char);
    procedure LogViewerAfterScroll(DataSet: TDataSet);
  private
    // Class Fields
    FSQLFormatter: TSQLFormatter;

    // Event Handlers
    procedure OnDrawColumnCellHighlight(Sender: TObject; const Rect: TRect; DataCol: Integer;
      Column: TColumn; State: TGridDrawState);
    procedure OnKeyPressFilterComponents(Sender: TObject; var Key: Char);

    // Functions
    function OpenFile: string;
    function FormatSQL: string;
    function GetFieldName(aComponent: TEdit): string;
    function IsFileNameValid: boolean;

    // Procdures
    procedure OpenSQLTab;
    procedure AssignCheckBoxesEvents;
    procedure AssignFilterEvents;
    procedure AssignGridDrawEvent;
    procedure BuscarLogMaisRecente;
    procedure LoadOptions;
    procedure LoadLog;
    procedure LoadSQLBottomPanel;
    procedure CopyColumnValue;
    procedure ManageTimer;
    procedure ShowRecordInfo;
    procedure FilterRecords(const aNomeCampo, aValor: string);
    procedure SaveOption(const aKey: string; const aValue: boolean);
    procedure ClearFilterComponents(aComponent: TEdit);
    procedure RemoveCheckBoxesEvents;
  end;

var
  fMonitor: TfMonitor;

implementation

uses
  ClipBrd, Utils.Helpers, Utils.Options, Utils.Constants;

{$R *.dfm}

function TfMonitor.OpenFile: string;
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

procedure TfMonitor.BuscarLogMaisRecente;
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
begin
  if not IsFileNameValid then
    Exit;

  TimerAutoUpdate.Enabled := False;
  LogViewer.LogFileName := EditFileName.Text;
  LogViewer.LoadLog;

  ShowRecordInfo;
  ManageTimer;
  LoadSQLBottomPanel;
end;

procedure TfMonitor.LoadOptions;
var
  lOptions: TOptions;
begin
  RemoveCheckBoxesEvents;
  lOptions := TOptions.Create;
  try
    CheckBoxAutoUpdate.Checked := lOptions.AutoUpdateEnabled;
    LabelInterval.Enabled := lOptions.AutoUpdateEnabled;
    SpinEditInterval.Enabled := lOptions.AutoUpdateEnabled;
    CheckBoxShowOnlySQL.Checked := lOptions.ShowOnlySQL;
    LogViewer.ShowOnlySQL := lOptions.ShowOnlySQL;
    CheckBoxHighlightErrors.Checked := lOptions.HighlightErrors;
    CheckBoxShowBottomPanel.Checked := lOptions.ShowBottomPanel;
    PanelSQL.Visible := lOptions.ShowBottomPanel;
  finally
    lOptions.Free;
    AssignCheckBoxesEvents;
  end;
end;

procedure TfMonitor.LoadSQLBottomPanel;
begin
  if not CheckBoxShowBottomPanel.Checked then
    Exit;

  MemoSQL.Lines.Clear;
  if not LogViewer.IsSQLEmpty then
    MemoSQL.Lines.Text := FormatSQL;
end;

procedure TfMonitor.CheckBoxShowBottomPanelClick(Sender: TObject);
begin
  SaveOption(sSHOW_BOTTOM_PANEL, CheckBoxShowBottomPanel.Checked);
end;

procedure TfMonitor.CheckBoxAutoUpdateClick(Sender: TObject);
var
  lEnable: boolean;
begin
  lEnable := CheckBoxAutoUpdate.Checked;
  TimerAutoUpdate.Enabled := lEnable;
  SaveOption(sAUTO_UPDATE_ENABLED, lEnable);
end;

procedure TfMonitor.CheckBoxHighlightErrorsClick(Sender: TObject);
var
  lEnable: boolean;
begin
  lEnable := CheckBoxHighlightErrors.Checked;
  SaveOption(sHIGHLIGHT_ERRORS, lEnable);
  AssignGridDrawEvent;
end;

procedure TfMonitor.CheckBoxShowOnlySQLClick(Sender: TObject);
var
  lEnable: boolean;
begin
  lEnable := CheckBoxShowOnlySQL.Checked;
  SaveOption(sSHOW_ONLY_SQL, lEnable);
  LogViewer.ShowOnlySQL := lEnable;
  LogViewer.ReloadLog;
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

  if EditFileName.IsEmpty then
    Exit;

  if not FileExists(EditFileName.Text) then
    Exit;

  result := True;
end;

procedure TfMonitor.FilterRecords(const aNomeCampo, aValor: string);
var
  lFilter: string;
  lValue: string;
begin
  if aValor.IsEmpty then
  begin
    LogViewer.RemoveFilter;
    Exit;
  end;

  lFilter := EmptyStr;
  if aNomeCampo = 'SQL' then
    lFilter := Format('Type = %s AND ', ['SQL'.QuotedString]);

  lValue := '%' + aValor + '%';
  lFilter := lFilter + Format('%s like %s', [aNomeCampo, lValue.QuotedString]);

  LogViewer.SetLogFilter(lFilter);
end;

function TfMonitor.FormatSQL: string;
begin
  result := FSQLFormatter.FormatSQL(LogViewer.GetSQL);
end;

procedure TfMonitor.FormCreate(Sender: TObject);
var
  k: char;
begin
  FSQLFormatter := TSQLFormatter.Create;
  LoadOptions;
  BuscarLogMaisRecente;
  AssignCheckBoxesEvents;
  AssignFilterEvents;
  AssignGridDrawEvent;

  EditFileName.Text := 'C:\Andre.Celestino\logErro.txt';
  LoadLog;
  k := #13;
  EditFilterMethod.Text := 'pesquise';
  EditFilterMethod.OnKeyPress(EditFilterMethod, k);
end;

procedure TfMonitor.FormDestroy(Sender: TObject);
begin
  FSQLFormatter.Free;
end;

procedure TfMonitor.SaveOption(const aKey: string; const aValue: boolean);
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

procedure TfMonitor.RemoveCheckBoxesEvents;
begin
  CheckBoxAutoUpdate.OnClick := nil;
  CheckBoxShowOnlySQL.OnClick := nil;
  CheckBoxHighlightErrors.OnClick := nil;
  CheckBoxShowBottomPanel.OnClick := nil;
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
