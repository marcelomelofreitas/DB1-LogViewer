unit Utils.Helpers;

interface

uses
  IniFiles;

type
  TIniFileHelper = class helper for TIniFile
    function ReadValue(const aKey: string): string;
  end;

implementation

{ TIniFileHelper }

function TIniFileHelper.ReadValue(const aKey: string): string;
begin
  result := Self.ReadString('Opcoes', aKey, 'N');
end;

end.
