unit Utils.Helpers;

interface

uses
  System.SysUtils, System.Classes, System.IniFiles, Vcl.StdCtrls;

type
  TIniFileHelper = class helper for TIniFile
    function ReadValue(const aKey: string): boolean;
    procedure WriteValue(const aKey: string; const aValue: boolean);
  end;

  TEditHelper = class helper for TEdit
    function IsEmpty: boolean;
  end;

  TStringBuilderHelper = class helper for TStringBuilder
    function AppendSpaces(const aCount: byte): TStringBuilder;
  end;

  TStringListHelper = class helper for TStringList
    function Exists(const aValue: string): boolean;
  end;

implementation

uses
  Utils.Constants;

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

{ TStringBuilderHelper }

function TStringBuilderHelper.AppendSpaces(const aCount: byte): TStringBuilder;
begin
  result := Self.AppendLine.Append(StringOfChar(sSPACE, aCount));
end;

{ TStringListHelper }

function TStringListHelper.Exists(const aValue: string): boolean;
begin
  result := Self.IndexOf(aValue.ToUpper) >= 0;
end;

end.
