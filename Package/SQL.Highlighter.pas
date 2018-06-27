unit SQL.Highlighter;

interface

uses
  Vcl.ComCtrls;

type
  TSQLHighlighter = class
  private
    FRichEdit: TRichEdit;

    // private functions
    procedure HighlightKeyword(const aKeyword: string);
    procedure HighlightValues;
  public
    constructor Create(aRichEdit: TRichEdit);

    // main function
    procedure HighlightSQL;
  end;

const
  Commands: array[0..33] of string =
  (
    'SELECT', 'UPDATE', 'DELETE', 'INSERT', 'INTO', 'SET',
    'FROM', 'WHERE', 'AND', 'OR', 'ON', 'GROUP', 'ORDER', 'BY', 'AS',
    'JOIN', 'INNER', 'OUTER', 'LEFT', 'RIGHT', 'UNION',
    'CAST', 'CONVERT', 'CASE', 'SUM', 'COUNT', 'MIN', 'MAX',
    'IS', 'NOT', 'NULL', 'LIKE', 'TOP', 'DISTINCT'
   );

implementation

uses
  System.SysUtils, VCL.Graphics;

{ TSQLHighlighter }

constructor TSQLHighlighter.Create(aRichEdit: TRichEdit);
begin
  FRichEdit := aRichEdit;
end;

procedure TSQLHighlighter.HighlightSQL;
var
  Count: byte;
begin
  for Count := 0 to High(Commands) do
  begin
    HighlightKeyword(Commands[Count]);
  end;

  HighlightValues;

  FRichEdit.SelStart := 0;
  FRichEdit.SelLength := 0;
end;

procedure TSQLHighlighter.HighlightValues;
var
  lStartPosition: integer;
  lEndPosition: integer;

  function GetStartPosition(const aOffset: integer): integer;
  begin
    result := FRichEdit.FindText('''', aOffset,
      FRichEdit.Lines.Text.Length, []);
  end;

  function GetEndPosition: integer;
  begin
    result := FRichEdit.FindText('''', Succ(lStartPosition),
      FRichEdit.Lines.Text.Length, []);
  end;

begin
  lStartPosition := GetStartPosition(0);
  lEndPosition := GetEndPosition;
  while lStartPosition <> -1 do
  begin
    FRichEdit.SelStart := lStartPosition;
    FRichEdit.SelLength := Succ(lEndPosition - lStartPosition);
    FRichEdit.SelAttributes.Color := $0000A600;

    lStartPosition := GetStartPosition(Succ(lEndPosition));
    lEndPosition := GetEndPosition;
  end;
end;

procedure TSQLHighlighter.HighlightKeyword(const aKeyword: string);
var
  lOccurrence: integer;

  function GetNextOccurrence(const aOffset: integer): integer;
  begin
    result := FRichEdit.FindText(aKeyword, aOffset,
      FRichEdit.Lines.Text.Length, [stWholeWord]);
  end;
begin
  lOccurrence := GetNextOccurrence(0);
  while lOccurrence <> -1 do
  begin
    FRichEdit.SelStart := lOccurrence;
    FRichEdit.SelLength := Length(aKeyword);
    FRichEdit.SelAttributes.Color := clBlue;
    lOccurrence := GetNextOccurrence(lOccurrence + Length(aKeyword));
  end;
end;

end.
