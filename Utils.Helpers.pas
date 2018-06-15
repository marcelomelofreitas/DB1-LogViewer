unit Utils.Helpers;

interface

uses
  System.SysUtils, System.Classes, System.IniFiles;

type
  TIniFileHelper = class helper for TIniFile
    function ReadValue(const aKey: string): string;
    procedure WriteValue(const aKey: string; const aValue: string);
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

function TIniFileHelper.ReadValue(const aKey: string): string;
begin
  result := Self.ReadString('Options', aKey, EmptyStr);
end;

procedure TIniFileHelper.WriteValue(const aKey: string; const aValue: string);
begin
  Self.WriteString('Options', aKey, aValue);
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
