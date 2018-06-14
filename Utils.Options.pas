unit Utils.Options;

interface

uses
  IniFiles;

type
  TOptions = class
  private
    FINIFile: TIniFile;
  public
    constructor Create;
    destructor Destroy; override;

    // writes the value in the INI file
    procedure SaveOption(const aKey: string; const aValue: string);

    // reads the value from the INI file
    function ReadValue(const aKey: string): string;

    // reads the value from the INI file and compares it with 1 (True)
    function ReadEnabled(const aKey: string): boolean;
  end;

implementation

uses
  System.SysUtils, Utils.Helpers, Utils.Constants, Dialogs;

{ TOpcoes }

constructor TOptions.Create;
begin
  FINIFile := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'LogViewer.ini');
end;

destructor TOptions.Destroy;
begin
  FINIFile.Free;
  inherited;
end;

function TOptions.ReadEnabled(const aKey: string): boolean;
begin
  result := Self.ReadValue(aKey) = '-1';
end;

function TOptions.ReadValue(const aKey: string): string;
begin
  result := FINIFile.ReadValue(aKey);
end;

procedure TOptions.SaveOption(const aKey: string; const aValue: string);
begin
  FINIFile.WriteValue(aKey, aValue);
end;

end.
