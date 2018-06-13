unit Utils.Options;

interface

uses
  IniFiles;

type
  TOptions = class
  private
    FINIFile: TIniFile;

    function GetAutoUpdateEnabled: boolean;
    function GetShowOnlySQL: boolean;
    function GetHighlightErrors: boolean;
    function GetShowBottomPanel: boolean;
  public
    constructor Create;
    destructor Destroy; override;
    procedure SaveOption(const aKey: string; const aValue: boolean);

    property AutoUpdateEnabled: boolean read GetAutoUpdateEnabled;
    property ShowOnlySQL: boolean read GetShowOnlySQL;
    property HighlightErrors: boolean read GetHighlightErrors;
    property ShowBottomPanel: boolean read GetShowBottomPanel;
  end;

implementation

uses
  System.SysUtils, Utils.Helpers, Utils.Constants, Dialogs;

{ TOpcoes }

constructor TOptions.Create;
begin
  FINIFile := TIniFile.Create(ExtractFilePath(ParamStr(0)) + '\LogViewer.ini');
end;

destructor TOptions.Destroy;
begin
  FINIFile.Free;
  inherited;
end;

function TOptions.GetHighlightErrors: boolean;
begin
  result := FINIFile.ReadValue(sHIGHLIGHT_ERRORS);
end;

function TOptions.GetShowBottomPanel: boolean;
begin
  result := FINIFile.ReadValue(sSHOW_BOTTOM_PANEL);
end;

function TOptions.GetShowOnlySQL: boolean;
begin
  result := FINIFile.ReadValue(sSHOW_ONLY_SQL);
end;

function TOptions.GetAutoUpdateEnabled: boolean;
begin
  result := FINIFile.ReadValue(sAUTO_UPDATE_ENABLED);
end;

procedure TOptions.SaveOption(const aKey: string; const aValue: boolean);
begin
  FINIFile.WriteValue(aKey, aValue);
end;

end.
