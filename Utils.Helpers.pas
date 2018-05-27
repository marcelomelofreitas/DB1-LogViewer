unit Utils.Helpers;

interface

uses
  IniFiles;

type
  TIniFileHelper = class helper for TIniFile
    function ReadValue(const aKey: string): boolean;
    procedure WriteValue(const aKey: string; const aValue: boolean);
  end;

implementation

{ TIniFileHelper }

function TIniFileHelper.ReadValue(const aKey: string): boolean;
begin
  result := Self.ReadBool('Opcoes', aKey, False);
end;

procedure TIniFileHelper.WriteValue(const aKey: string; const aValue: boolean);
begin
  Self.WriteBool('Opcoes', aKey, aValue);
end;

end.
