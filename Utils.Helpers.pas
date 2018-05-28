unit Utils.Helpers;

interface

uses
  System.IniFiles, Vcl.StdCtrls;

type
  TIniFileHelper = class helper for TIniFile
    function ReadValue(const aKey: string): boolean;
    procedure WriteValue(const aKey: string; const aValue: boolean);
  end;

  TEditHelper = class helper for TEdit
    function IsEmpty: boolean;
  end;

implementation

uses
  System.SysUtils;

{ TIniFileHelper }

function TIniFileHelper.ReadValue(const aKey: string): boolean;
begin
  result := Self.ReadBool('Opcoes', aKey, False);
end;

procedure TIniFileHelper.WriteValue(const aKey: string; const aValue: boolean);
begin
  Self.WriteBool('Opcoes', aKey, aValue);
end;

{ TEditHelper }

function TEditHelper.IsEmpty: boolean;
begin
  result := Trim(Self.Text) = EmptyStr;
end;

end.
