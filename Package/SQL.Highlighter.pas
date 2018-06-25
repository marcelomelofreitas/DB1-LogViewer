unit SQL.Highlighter;

interface

uses
  Vcl.ComCtrls;

type
  TSQLHighlighter = class
  private
    FRichEdit: TRichEdit;
    procedure HighlightKeyword(const aKeyword: string);
    procedure HighlightValues;
  public
    constructor Create(aRichEdit: TRichEdit);
    procedure HighlightSQL;
  end;

implementation

uses
  System.SysUtils, VCL.Graphics, Utils.Constants;

{ TSQLHighlighter }

constructor TSQLHighlighter.Create(aRichEdit: TRichEdit);
begin
  FRichEdit := aRichEdit;
end;

procedure TSQLHighlighter.HighlightSQL;
begin
  HighlightKeyword('SELECT');
  HighlightKeyword('FROM');
  HighlightKeyword('WHERE');
  HighlightKeyword('AND');
  HighlightKeyword('OR');
  HighlightKeyword('ON');
  HighlightKeyword('JOIN');
  HighlightKeyword('INNER');
  HighlightKeyword('OUTER');
  HighlightKeyword('LEFT');
  HighlightKeyword('RIGHT');
  HighlightKeyword('CASE');
  HighlightKeyword('CAST');
  HighlightKeyword('CONVERT');

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
  lEndPosition := 0;

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
