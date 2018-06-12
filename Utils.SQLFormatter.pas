unit Utils.SQLFormatter;

interface

uses
  System.SysUtils, System.Classes;

type
  TSQLFormatter = class
  private
    FStringListClauses: TStringList;
    FStringListJoins: TStringList;
    FStringListOperators: TStringList;
    FStringListCommands: TStringList;
    FMarginLevel: integer;
    FMarginHeap: integer;
    FSameLinePosition: integer;
    FSingleCommand: boolean;

    function FormatDate(const aDate: TDateTime): string;
    function IdentSQL(const aPreparedSQL: string): string;
    function WriteSQLParameters(const aSQL: string): string;
    function RemovedUnusedSpaces(const aSQL: string): string;
    function ReplaceAllStrings(const aText, aOldPattern, aNewPattern: string): string;
    function VerificarDeveQuebrarLinha(const aValue: string): boolean;
    function VerificarEhComando(const aValue: string): boolean;

    procedure CreateInternalObjects;
    procedure DestroyInternalObjects;
    procedure DecMargin(const aQtde: byte);
    procedure InitializeStringLists;

    procedure ProcessClause(const aValue: string; aBuilder: TStringBuilder);
    procedure ProcessJoin(const aValue: string; aBuilder: TStringBuilder);
    procedure ProcessOperator(const aValue: string; aBuilder: TStringBuilder);
    procedure ProcessSubSelect(const aSQL: string;
      var aTokenPosition: integer; aBuilder: TStringBuilder);
    procedure ProcessCommand(const aSQL, aValue: string; var aTokenPosition: integer;
      aBuilder: TStringBuilder);

    function ExtractCommand(const aSQL: string): string;
    function ExtractSubSelect(const aSQL: string): string;
    function PrepareSQL(const aSQL: string): string;
  public
    constructor Create;
    destructor Destroy; override;
    function FormatSQL(const aSQL: string): string;
  end;

implementation

uses
  Utils.Constants, Utils.Helpers;

{ TFormatadorSQL }

function TSQLFormatter.ExtractSubSelect(const aSQL: string): string;
var
  lParenthesesCount: integer;
  lCharacter: string;
begin
  result := EmptyStr;
  lParenthesesCount := 0;

  for lCharacter in aSQL do
  begin
    if lCharacter = '(' then
      Inc(lParenthesesCount);

    if lCharacter = ')' then
      Dec(lParenthesesCount);

    result := result + lCharacter;

    if lParenthesesCount = 0 then
      Break;
  end;

  // Remove o '(' e ')'
  result := Copy(result, 2, result.Length - 2);
end;

procedure TSQLFormatter.InitializeStringLists;
begin
  FStringListClauses.Add('SELECT');
  FStringListClauses.Add('FROM');
  FStringListClauses.Add('WHERE');
  FStringListClauses.Add('ORDER_BY');
  FStringListClauses.Add('GROUP_BY');
  FStringListClauses.Add('UNION');

  FStringListJoins.Add('JOIN');
  FStringListJoins.Add('INNER_JOIN');
  FStringListJoins.Add('LEFT_JOIN');
  FStringListJoins.Add('LEFT_OUTER_JOIN');
  FStringListJoins.Add('RIGHT_JOIN');
  FStringListJoins.Add('RIGHT_OUTER_JOIN');

  FStringListOperators.Add('ON');
  FStringListOperators.Add('AND');
  FStringListOperators.Add('OR');

  FStringListCommands.Add('CAST');
  FStringListCommands.Add('(CAST');
  FStringListCommands.Add('CAST(');
  FStringListCommands.Add('CONVERT');
  FStringListCommands.Add('CONVERT(');
  FStringListCommands.Add('(CONVERT');
end;

function TSQLFormatter.WriteSQLParameters(const aSQL: string): string;
var
  nCont, nPosParams: integer;
  sSQL, sParams: string;
  lParametersList, lValuesList: TStringList;
  lName, lType, lValue, lFormattedValue, lCopy, lCharacter: string;
  lInsideParameter: boolean;
begin
  result := aSQL;
  nPosParams := AnsiPos('PARAMS=', aSQL.ToUpper);

  if nPosParams = 0 then
    Exit;

  sSQL := Copy(aSQL, 1, Pred(nPosParams));
  sParams := Copy(aSQL, nPosParams, Length(aSQL) - nPosParams + 1);

  Result := sSQL;

  lParametersList := TStringList.Create;
  lValuesList := TStringList.Create;
  try
    lInsideParameter := False;
    lCopy := EmptyStr;

    for lCharacter in sParams do
    begin
      if lCharacter = '[' then
      begin
        lInsideParameter := True;
        Continue;
      end;

      if lCharacter = ']' then
      begin
        lParametersList.Add(lCopy);
        lInsideParameter := False;
        lCopy := EmptyStr;
        Continue;
      end;

      if lInsideParameter then
        lCopy := lCopy + lCharacter;
    end;

    lParametersList.Sort;
    lValuesList.StrictDelimiter := True;
    lValuesList.Delimiter := ',';

    for nCont := Pred(lParametersList.Count) downto 0 do
    begin
      lValuesList.DelimitedText := lParametersList[nCont];
      lName := ':' + lValuesList[0];
      lType := lValuesList[1].ToUpper;
      lValue := lValuesList[2];

      if lValuesList.Count < 3 then
      begin
        lFormattedValue := 'null';
        Result := ReplaceAllStrings(Result, lName, lFormattedValue);
        Continue;
      end;

      if ((lType = 'FTFIXEDCHAR') or (lType = 'FTSTRING')) and (QuotedStr(Copy(lValue, 2, Length(lValue) - 2)) <> lValue) then
        lFormattedValue := QuotedStr(lValue)
      else if (lType = 'FTDATETIME') or (lType = 'FTDATE') then
      begin
        if AnsiPos('/', lValue) = 0 then
          lValue := DateTimeToStr(lValue.ToInteger);
        lFormattedValue := FormatDate(StrToDateTime(lValue));
      end
      else
        lFormattedValue := lValue;

      Result := ReplaceAllStrings(Result, lName, lFormattedValue);
    end;

  finally
    lParametersList.Free;
    lValuesList.Free;
  end;
end;

function TSQLFormatter.PrepareSQL(const aSQL: string): string;
begin
  result := ReplaceAllStrings(aSQL, '  ', sSPACE);
  result := ReplaceAllStrings(result, ',', ', ');
  result := ReplaceAllStrings(result, 'LEFT JOIN', 'LEFT_JOIN');
  result := ReplaceAllStrings(result, 'LEFT OUTER JOIN', 'LEFT_OUTER_JOIN');
  result := ReplaceAllStrings(result, 'INNER JOIN', 'INNER_JOIN');
  result := ReplaceAllStrings(result, 'RIGHT JOIN', 'RIGHT_JOIN');
  result := ReplaceAllStrings(result, 'RIGHT OUTER JOIN', 'RIGHT_OUTER_JOIN');
  result := ReplaceAllStrings(result, 'ORDER BY', 'ORDER_BY');
  result := ReplaceAllStrings(result, 'GROUP BY', 'GROUP_BY');
end;

procedure TSQLFormatter.ProcessClause(const aValue: string; aBuilder: TStringBuilder);
begin
  DecMargin(FMarginHeap);

  if aBuilder.Length > 0 then
    aBuilder.AppendSpaces(FMarginLevel);

  aBuilder.Append(aValue.Replace('_', sSPACE, [rfReplaceAll]));

  Inc(FMarginLevel, nMARGIN);
  Inc(FMarginHeap, nMARGIN);

  FSameLinePosition := 0;

  aBuilder.AppendSpaces(FMarginLevel);

  FSingleCommand := False;
  if aValue.Equals('WHERE') then
  begin
    Inc(FMarginLevel);
    Inc(FMarginHeap);
    FSingleCommand := True;
  end;
end;

procedure TSQLFormatter.ProcessCommand(const aSQL, aValue: string; var aTokenPosition: integer;
      aBuilder: TStringBuilder);
var
  lCommand: string;
begin
  lCommand := ExtractCommand(aSQL);
  Inc(aTokenPosition, lCommand.Length - aValue.Length);
  aBuilder.Append(lCommand).Append(sSPACE);
  FSingleCommand := False;
end;

procedure TSQLFormatter.ProcessJoin(const aValue: string; aBuilder: TStringBuilder);
begin
  DecMargin(FMarginHeap - nMARGIN);

  aBuilder
    .AppendSpaces(FMarginLevel)
    .Append(aValue.Replace('_', sSPACE, [rfReplaceAll]))
    .Append(sSPACE);

  FSameLinePosition := aValue.Length;
end;

procedure TSQLFormatter.ProcessOperator(const aValue: string; aBuilder: TStringBuilder);
var
  lOperatorMarginLevel: integer;
begin
  if (not aValue.Equals('AND')) and (not aValue.Equals('OR')) then
  begin
    Inc(FMarginLevel, nMARGIN);
    Inc(FMarginHeap, nMARGIN);
  end;

  lOperatorMarginLevel := FMarginLevel;

  if aValue.Equals('AND') then
    Dec(lOperatorMarginLevel);

  aBuilder
    .AppendSpaces(lOperatorMarginLevel)
    .Append(aValue.ToUpper)
    .Append(sSPACE);

  FSameLinePosition := aValue.Length;
end;

procedure TSQLFormatter.ProcessSubSelect(const aSQL: string;
      var aTokenPosition: integer; aBuilder: TStringBuilder);
var
  lSubSelect: string;
  lActualMargin: integer;
  lActualHeap: integer;
  lActualSingleCommand: boolean;
begin
  lSubSelect := ExtractSubSelect(aSQL);
  lActualMargin := FMarginLevel;
  lActualHeap := FMarginHeap;
  lActualSingleCommand := FSingleCommand;

  // Configura o recuo das colunas do SubSelect
  Inc(FMarginLevel, FSameLinePosition + 1);

  // "-5" é o offset da palavra SELECT
  Inc(aTokenPosition, lSubSelect.Length - 5);

  aBuilder
    .Append('(')
    .Append(IdentSQL(lSubSelect))
    .Append(')');

  FMarginLevel := lActualMargin;
  FMarginHeap := lActualHeap;
  FSingleCommand := lActualSingleCommand;
end;

function TSQLFormatter.RemovedUnusedSpaces(const aSQL: string): string;
begin
  result := ReplaceAllStrings(aSQL, ' )', ')');
  result := ReplaceAllStrings(result, '( ', '(');
end;

function TSQLFormatter.ReplaceAllStrings(const aText, aOldPattern, aNewPattern: string): string;
begin
  result := StringReplace(aText, aOldPattern, aNewPattern, [rfReplaceAll, rfIgnoreCase]);
end;

function TSQLFormatter.VerificarDeveQuebrarLinha(const aValue: string): boolean;
var
  lLastCharacterIsComma: boolean;
begin
  lLastCharacterIsComma := (aValue[aValue.Length] = ',');
  result := lLastCharacterIsComma and (not FSingleCommand);
end;

function TSQLFormatter.VerificarEhComando(const aValue: string): boolean;
var
  lCommand: string;
begin
  result := False;
  for lCommand in FStringListCommands do
  begin
    if aValue.StartsWith(lCommand) then
    begin
      result := True;
      Break;
    end;
  end;
end;

constructor TSQLFormatter.Create;
begin
  CreateInternalObjects;
  InitializeStringLists;
end;

procedure TSQLFormatter.CreateInternalObjects;
begin
  FStringListClauses := TStringList.Create;
  FStringListJoins := TStringList.Create;
  FStringListOperators := TStringList.Create;
  FStringListCommands := TStringList.Create;
end;

procedure TSQLFormatter.DecMargin(const aQtde: byte);
begin
  if FMarginLevel > 0 then
  begin
    Dec(FMarginLevel, aQtde);
    Dec(FMarginHeap, aQtde);
  end;
end;

destructor TSQLFormatter.Destroy;
begin
  DestroyInternalObjects;
  inherited;
end;

procedure TSQLFormatter.DestroyInternalObjects;
begin
  FStringListClauses.Free;
  FStringListJoins.Free;
  FStringListOperators.Free;
  FStringListCommands.Free;
end;

function TSQLFormatter.FormatDate(const aDate: TDateTime): string;
begin
  result := QuotedStr(FormatDateTime('dd/mm/yyyy hh:nn:ss', aDate));
end;

function TSQLFormatter.FormatSQL(const aSQL: string): string;
var
  lPreparedSQL: string;
begin
  FMarginLevel := 0;
  lPreparedSQL := WriteSQLParameters(aSQL);
  lPreparedSQL := PrepareSQL(lPreparedSQL);
  result := IdentSQL(lPreparedSQL);
end;

function TSQLFormatter.IdentSQL(const aPreparedSQL: string): string;
var
  lValue: string;
  lSQL: string;
  lBuilder: TStringBuilder;
  lTokenPosition: integer;

  procedure RecortarSQL;
  begin
    lSQL := Copy(lSQL, lTokenPosition, lSQL.Length).Trim;
  end;

begin
  lSQL := aPreparedSQL;
  lBuilder := TStringBuilder.Create;
  try
    FMarginHeap := 0;
    FSameLinePosition := 0;

    while lSQL.Length > 0 do
    begin
      lTokenPosition := Pos(sSPACE, lSQL);

      if lTokenPosition = 0 then
        lTokenPosition := Succ(lSQL.Length);

      lValue := Copy(lSQL, 1, Pred(lTokenPosition)).Trim;

      if lValue.ToUpper.Equals(sSUBSELECT) then
      begin
        ProcessSubSelect(lSQL, lTokenPosition, lBuilder);
        RecortarSQL;
        Continue;
      end;

      if FStringListClauses.Exists(lValue) then
      begin
        ProcessClause(lValue.ToUpper, lBuilder);
        RecortarSQL;
        Continue;
      end;

      if FStringListJoins.Exists(lValue) then
      begin
        ProcessJoin(lValue.ToUpper, lBuilder);
        RecortarSQL;
        Continue;
      end;

      if FStringListOperators.Exists(lValue) then
      begin
        ProcessOperator(lValue.ToUpper, lBuilder);
        RecortarSQL;
        Continue;
      end;

      if VerificarEhComando(lValue.ToUpper) then
      begin
        ProcessCommand(lSQL, lValue, lTokenPosition, lBuilder);
        RecortarSQL;
        Continue;
      end;

      Inc(FSameLinePosition, Succ(lValue.Length));

      lBuilder.Append(lValue).Append(sSPACE);

      if VerificarDeveQuebrarLinha(lValue) then
      begin
        lBuilder.AppendSpaces(FMarginLevel);
        FSameLinePosition := 0;
      end;

      RecortarSQL;
    end;

    result := lBuilder.ToString;
    result := RemovedUnusedSpaces(result);
  finally
    lBuilder.Free;
  end;
end;

function TSQLFormatter.ExtractCommand(const aSQL: string): string;
var
  lParenthesesCount: integer;
  lCharacter: string;
begin
  result := EmptyStr;
  lParenthesesCount := -1;

  for lCharacter in aSQL do
  begin
    if lCharacter = '(' then
    begin
      if lParenthesesCount >= 0 then
        Inc(lParenthesesCount)
      else
        lParenthesesCount := Abs(lParenthesesCount);
    end;

    if lCharacter = ')' then
      Dec(lParenthesesCount);

    result := result + lCharacter;

    if lParenthesesCount = 0 then
      Break;
  end;
end;

end.
