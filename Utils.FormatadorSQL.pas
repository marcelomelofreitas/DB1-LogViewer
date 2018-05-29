unit Utils.FormatadorSQL;

interface

type
  TFormatadorSQL = class
  private
    function FormatarData(const aData: TDateTime): string;
    function SubstituirString(const aTexto, aBusca, aSubstituicao: string): string;
    function PreencherParametrosSQL(const aSQL: string): string;
    function IdentarSQL(var aSQL: string): string;
    function ObterPosicao(const aString, aSubString: string;
      const aInicio: integer): integer;
  public
    function FormatarSQL(const aSQL: string): string;
  end;

implementation

uses
  System.SysUtils, System.Classes, Utils.Constantes;

{ TFormatadorSQL }

function TFormatadorSQL.PreencherParametrosSQL(const aSQL: string): string;
var
  nCont, nPosParams: integer;
  sSQL, sParams: string;
  lListaParametros, lListaValores: TStringList;
  lNome, lTipo, lValor, lValorFormatado, lCopia, lLetra: string;
  lEncontrouParametro: boolean;
begin
  nPosParams := AnsiPos('PARAMS=', AnsiUpperCase(aSQL));

  if nPosParams = 0 then
  begin
    result := aSQL;
    Exit;
  end;

  sSQL := Copy(aSQL, 1, Pred(nPosParams));
  sParams := Copy(aSQL, nPosParams, Length(aSQL) - nPosParams + 1);

  Result := sSQL;

  lListaParametros := TStringList.Create;
  lListaValores := TStringList.Create;
  try
    lEncontrouParametro := False;
    lCopia := EmptyStr;

    for lLetra in sParams do
    begin
      if lLetra = '[' then
      begin
        lEncontrouParametro := True;
        Continue;
      end;

      if lLetra = ']' then
      begin
        lListaParametros.Add(lCopia);
        lEncontrouParametro := False;
        lCopia := EmptyStr;
        Continue;
      end;

      if lEncontrouParametro then
        lCopia := lCopia + lLetra;
    end;

    lListaParametros.Sort;

    lListaValores.StrictDelimiter := True;
    lListaValores.Delimiter := ',';
    for nCont := Pred(lListaParametros.Count) downto 0 do
    begin
      lListaValores.DelimitedText := lListaParametros[nCont];
      lNome := ':' + lListaValores[0];
      lTipo := AnsiUpperCase(lListaValores[1]);
      lValor := lListaValores[2];

      if lListaValores.Count < 3 then
      begin
        lValorFormatado := 'null';
        Result := SubstituirString(Result, lNome, lValorFormatado);
        Continue;
      end;

      if ((lTipo = 'FTFIXEDCHAR') or (lTipo = 'FTSTRING')) and (QuotedStr(Copy(lValor, 2, Length(lValor) - 2)) <> lValor) then
        lValorFormatado := QuotedStr(lValor)
      else if (lTipo = 'FTDATETIME') or (lTipo = 'FTDATE') then
      begin
        if AnsiPos('/', lValor) = 0 then
          lValor := DateTimeToStr(StrToInt(lValor));
        lValorFormatado := FormatarData(StrToDateTime(lValor));
      end
      else
        lValorFormatado := lValor;

      Result := SubstituirString(Result, lNome, lValorFormatado);
    end;

  finally
    lListaParametros.Free;
    lListaValores.Free;
  end;
end;

function TFormatadorSQL.SubstituirString(const aTexto, aBusca,
  aSubstituicao: string): string;
begin
  result := StringReplace(aTexto, aBusca, aSubstituicao, [rfReplaceAll, rfIgnoreCase]);
end;

function TFormatadorSQL.FormatarData(const aData: TDateTime): string;
begin
  result := QuotedStr(FormatDateTime('dd/mm/yyyy hh:nn:ss', aData));
end;

function TFormatadorSQL.FormatarSQL(const aSQL: string): string;
var
  lSQLFormatado: string;
begin
  lSQLFormatado := PreencherParametrosSQL(aSQL);
  lSQLFormatado := IdentarSQL(lSQLFormatado);
  result := lSQLFormatado;
end;

function TFormatadorSQL.IdentarSQL(var aSQL: string): string;
var
  sql: string;
  Text: string;
  preline: string;
  posline: string;
  separ: TStringList;
  commandsOpen: TStringList;
  commands: TStringList;
  tipo: string;
  separActual: string;
  spaces: string;
  commandLast: string;
  separLast: string;
  qtParOpen: integer;
  posParOpen: integer;
  qtParClose: integer;
  posParClose: integer;
  nivel: integer;
  posLastBreak: integer;
  isFunction: boolean;
  funcao: string;
  posBreak: integer;
  ipos: integer;
  i: integer;
  line1: string;
  nivel1: string;
  nivelactual: string;
  line: string;
  bAspasAbertas: boolean;
  bQuebraLinhaAberta: boolean;
begin

  if Length(aSQL) <= 0 then
  begin
    Result := EmptyStr;
    Exit;
  end;

  separ := TStringList.Create;
  commandsOpen := TStringList.Create;
  commands := TStringList.Create;
  try
    separ.Add('AND');
    separ.Add('OR');

    commandsOpen.Add('SELECT');
    commandsOpen.Add('(SELECT');
    commandsOpen.Add('LEFT JOIN');
    commandsOpen.Add('LEFT OUTER JOIN');
    commandsOpen.Add('RIGHT JOIN');
    commandsOpen.Add('RIGHT OUTER JOIN');
    commandsOpen.Add('FULL JOIN');
    commandsOpen.Add('FULL OUTER JOIN');
    commandsOpen.Add('JOIN');
    commandsOpen.Add('INNER JOIN');
    commandsOpen.Add('UPDATE');
    commandsOpen.Add('DELETE');

    commands.Add('FROM');
    commands.Add('WHERE');
    commands.Add('ORDER BY');
    commands.Add('GROUP BY');
    commands.Add('ON');
    commands.Add('UNION');
    commands.Add('SET');

    aSQL := aSQL.Trim;
    aSQL := stringreplace(aSQL, chr(13), ' ', [rfreplaceall]);
    aSQL := stringreplace(aSQL, chr(10), ' ', [rfreplaceall]);
    aSQL := stringreplace(aSQL, chr(15), ' ', [rfreplaceall]);

    i := 1;
    bAspasAbertas := False;
    Text := '';
    while i <= Length(aSQL) - 1 do
    begin
      if aSQL[i] = Chr(39) then
        bAspasAbertas := not bAspasAbertas;

      if (aSQL[i] = #32) and (aSQL[i + 1] <> #32) then
      begin
        Text := Text + aSQL[i];
        Inc(i);
      end
      else
      if (aSQL[i] = #32) and (aSQL[i + 1] = #32) and (not bAspasAbertas) then
      begin
        Text := Text + aSQL[i];
        while (i < Length(aSQL) - 1) and (aSQL[i] = #32) do
          Inc(i);
      end
      else
      begin
        Text := Text + aSQL[i];
        Inc(i);
      end;
    end;
    Text := Text + aSQL[Length(aSQL)];

    sql := EmptyStr;
    Text := ' ' + Text;
    spaces := '                       ';
    nivel := 0;
    posLastBreak := 0;
    funcao := EmptyStr;
    preLine := EmptyStr;
    posLine := EmptyStr;
    separActual := EmptyStr;
    tipo := EmptyStr;

    while True do
    begin
      posBreak := Length(Text) + 1;

      if (tipo = 'commands') then
        commandLast := separActual;

      separLast := separActual;

      ipos := ObterPosicao(Text, ',', poslastBreak); // verificar aqui se nao casa erro
      if (ipos > -1) and (ipos < posBreak) then
      begin
        posBreak := ipos;
        tipo := 'comma';
        separActual := ',';
      end;

      for i := 0 to separ.Count - 1 do
      begin
        ipos := ObterPosicao(AnsiUpperCase(Text), ' ' + separ.Strings[i] + ' ', posLastBreak);

        if (ipos > -1) and (ipos < posBreak) then
        begin
          posBreak := ipos;
          tipo := 'separ';
          separActual := separ.Strings[i];
        end;
      end;

      for i := 0 to commandsOpen.Count - 1 do
      begin
        ipos := ObterPosicao(AnsiUpperCase(Text), ' ' + commandsOpen.Strings[i] + ' ', posLastBreak);
        if (ipos > -1) and (iPos < posBreak) then
        begin
          posBreak := ipos;
          if (ipos = 0) then
          begin
            Inc(nivel);
            separActual := commandsOpen.Strings[i];
            tipo := 'commands';
          end
          else
          begin
            separActual := sESPACO;
            tipo := sESPACO;
          end;
        end;
      end;

      for i := 0 to Pred(Commands.Count) do
      begin
        ipos := ObterPosicao(AnsiUpperCase(Text), sESPACO + commands.strings[i] + sESPACO, posLastBreak);
        if (ipos > -1) and (ipos < posBreak) then
        begin
          posBreak := ipos;
          if (ipos = 0) then
          begin
            separActual := commands.strings[i];
            tipo := 'commands';
          end
          else
          begin
            separActual := sESPACO;
            tipo := sESPACO;
          end;
        end;
      end;

      if (posBreak > 0) and (posBreak <> Length(Text) + 1) and (tipo = 'comma') then
      begin
        line1 := Copy(Text, 1, posBreak);

        qtParOpen := 0;
        posParOpen := 0;
        while (ObterPosicao(line1, '(', posParOpen) > -1) do
        begin
          posParOpen := ObterPosicao(line1, '(', posParOpen) + 1;
          Inc(qtParOpen);
        end;

        qtParClose := 0;
        posParClose := 0;
        while (ObterPosicao(line1, ')', posParClose) > -1) do
        begin
          posParClose := ObterPosicao(line1, ')', posParClose) + 1;
          Inc(qtParClose);
        end;

        if (qtParOpen > qtParClose) then
          isFunction := True
        else
          isFunction := False;
      end
      else
        isFunction := False;

      if posBreak = (Length(Text) + 1) then
        break;

      if (tipo = 'commands') and (commandLast = 'ON') and (separActual <> 'ON') then
        Dec(nivel)
      else if (nivel < 1) then
        nivel := 1;

      nivel1 := Copy(spaces, 1, (nivel * 3) - 1);
      nivelActual := nivel1;
      line := '';

      if (tipo = 'commands') then
      begin
        line := separActual + sESPACO;
        Text := Copy(Text, Length(separActual) + 2, Length(Text));
        nivelActual := Copy(nivelActual, 3, Length(nivelActual));
      end
      else
      if (tipo = sESPACO) then
      begin
        line := TrimRight(TrimLeft(Copy(Text, 1, PosBreak))) + sESPACO;
        Text := Copy(Text, posBreak + 1, Length(Text));
      end
      else
      if (tipo = 'separ') then
      begin
        line := Copy(Text, 1, posBreak + Length(trimright(separActual)) + 1);
        Text := copy(Text, posBreak + length(separActual) + 2, length(Text));
      end
      else
      if (tipo = 'comma') and (isFunction = False) then
      begin
        line := trimright(copy(Text, 1, posBreak + 1));
        Text := copy(Text, posBreak + length(separActual) + 1, length(Text));
      end;

      if (isFunction = False) then
      begin
        if (AnsiUpperCase(TrimLeft(TrimRight(Line))) <> 'ON') and
          ((AnsiUpperCase(TrimLeft(TrimRight(CommandLast))) = 'LEFT JOIN') or
          (AnsiUpperCase(TrimLeft(TrimRight(CommandLast))) = 'LEFT OUTER JOIN') or
          (AnsiUpperCase(TrimLeft(TrimRight(CommandLast))) = 'RIGHT JOIN') or
          (AnsiUpperCase(TrimLeft(TrimRight(CommandLast))) = 'RIGHT OUTER JOIN') or
          (AnsiUpperCase(TrimLeft(TrimRight(CommandLast))) = 'FULL JOIN') or
          (AnsiUpperCase(TrimLeft(TrimRight(CommandLast))) = 'FULL OUTER JOIN') or
          (AnsiUpperCase(TrimLeft(TrimRight(CommandLast))) = 'JOIN') or
          (AnsiUpperCase(TrimLeft(TrimRight(CommandLast))) = 'INNER JOIN')) then
          sql := sql + preLine + ' ' + line + ' '
        else if (AnsiUpperCase(TrimLeft(TrimRight(Line))) = 'LEFT JOIN') or
          (AnsiUpperCase(TrimLeft(TrimRight(Line))) = 'LEFT OUTER JOIN') or
          (AnsiUpperCase(TrimLeft(TrimRight(Line))) = 'RIGHT JOIN') or
          (AnsiUpperCase(TrimLeft(TrimRight(Line))) = 'RIGHT OUTER JOIN') or
          (AnsiUpperCase(TrimLeft(TrimRight(Line))) = 'FULL JOIN') or
          (AnsiUpperCase(TrimLeft(TrimRight(Line))) = 'FULL OUTER JOIN') or
          (AnsiUpperCase(TrimLeft(TrimRight(Line))) = 'JOIN') or
          (AnsiUpperCase(TrimLeft(TrimRight(Line))) = 'INNER JOIN') then
          sql := sql + preLine + nivelActual + line + ' '
        else
          sql := sql + preLine + nivelActual + line + posLine + Chr(13) + Chr(10);

        posLastBreak := 0;
      end
      else
        posLastBreak := posBreak + 1;

      qtParOpen := 0;
      posParOpen := 0;
      while (ObterPosicao(line, '(', posParOpen) > -1) do
      begin
        posParOpen := ObterPosicao(line, '(', posParOpen) + 1;
        Inc(qtParOpen);
      end;

      qtParClose := 0;
      posParClose := 0;
      while (ObterPosicao(line, ')', posParClose) > -1) do
      begin
        posParClose := ObterPosicao(line, ')', posParClose) + 1;
        Inc(qtParClose);
      end;

      if (qtParClose > qtParOpen) then
        nivel := nivel + (qtParOpen - qtParClose);
    end;
    result := sql + Copy(spaces, 1, nivel + 2) + trimright(Text);
  finally
    commands.Free;
    commandsOpen.Free;
    separ.Free;
  end;

  i := 1;
  aSQL := result;
  bAspasAbertas := False;
  bQuebraLinhaAberta := True;
  Text := '';
  while i <= Length(aSQL) - 1 do
  begin
    if aSQL[i] = Chr(39) then
      bAspasAbertas := not bAspasAbertas;
    if (aSQL[i] = #13) and (aSQL[i + 1] = #10) then
      bQuebraLInhaAberta := True;

    if (aSQL[i] = #32) and (aSQL[i + 1] <> #32) then
    begin
      Text := Text + aSQL[i];
      Inc(i);
    end
    else
    if (aSQL[i] = #32) and (aSQL[i + 1] = #32) and (not bAspasAbertas) then
    begin
      if not bQuebraLinhaAberta then
      begin
        Text := Text + aSQL[i];
        while (i < Length(aSQL) - 1) and (aSQL[i] = #32) do
          Inc(i);
      end
      else
      begin
        while (i < Length(aSQL) - 1) and (aSQL[i] = #32) do
        begin
          Text := Text + aSQL[i];
          Inc(i);
        end;
        bQuebraLinhaAberta := False;
      end;
    end
    else
    begin
      Text := Text + aSQL[i];
      Inc(i);
    end;
  end;
  result := Text + aSQL[length(aSQL)] + ';';
end;

function TFormatadorSQL.ObterPosicao(const aString, aSubString: string; const aInicio: integer): integer;
var
  aStringCopiada: string;
begin
  aStringCopiada := Copy(aString, aInicio, Length(aString));
  result := Pos(aSubString, aStringCopiada);
  if result = 0 then
    result := -1
  else
    result := result + aInicio - 1;
end;

end.
