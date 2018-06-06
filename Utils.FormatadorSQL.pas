unit Utils.FormatadorSQL;

interface

uses
  System.SysUtils, System.Classes;

type
  TFormatadorSQL = class
  private
    FStringListClausulas: TStringList;
    FStringListJuncoes: TStringList;
    FStringListOperadores: TStringList;
    FNivelRecuo: integer;
    FAcumuladorRecuos: integer;
    FQuebrarLinha: boolean;
    FPosicaoMesmaLinha: integer;

    function FormatarData(const aData: TDateTime): string;
    function SubstituirString(const aTexto, aBusca, aSubstituicao: string): string;
    function PreencherParametrosSQL(const aSQL: string): string;
    function IdentarSQL(var aSQL: string): string;

    procedure CriarObjetosInternos;
    procedure DestruirObjetosInternos;
    procedure DecrementarRecuo(const aQtde: byte);
    procedure PreencherListas;

    procedure ProcessarClausula(const aValor: string; aBuilder: TStringBuilder);
    procedure ProcessarJuncao(const aValor: string; aBuilder: TStringBuilder);
    procedure ProcessarOperador(const aValor: string; aBuilder: TStringBuilder);
    procedure ProcessarSubSelect(const aSubSelect: string;
      var aPosicaoToken: integer; aBuilder: TStringBuilder);

    function PegarSubSelect(const aSQL: string): string;
    function PrepararSQL(const aSQL: string): string;
  public
    constructor Create;
    destructor Destroy; override;
    function FormatarSQL(aSQL: string): string;
  end;

implementation

uses
  Utils.Constantes, Utils.Helpers;

{ TFormatadorSQL }

function TFormatadorSQL.PegarSubSelect(const aSQL: string): string;
var
  lContadorParenteses: integer;
  lLetra: string;
begin
  result := EmptyStr;
  lContadorParenteses := 0;

  for lLetra in aSQL do
  begin
    if lLetra = '(' then
      inc(lContadorParenteses);

    if lLetra = ')' then
      Dec(lContadorParenteses);

    result := result + lLetra;

    if lContadorParenteses = 0 then
      Break;
  end;

  // Remove o '(' e ')'
  result := Copy(result, 2, result.Length - 2);
end;

procedure TFormatadorSQL.PreencherListas;
begin
  FStringListClausulas.Add('SELECT');
  FStringListClausulas.Add('FROM');
  FStringListClausulas.Add('WHERE');
  FStringListClausulas.Add('ORDER_BY');
  FStringListClausulas.Add('GROUP_BY');
  FStringListClausulas.Add('UNION');

  FStringListJuncoes.Add('JOIN');
  FStringListJuncoes.Add('INNER_JOIN');
  FStringListJuncoes.Add('LEFT_JOIN');
  FStringListJuncoes.Add('LEFT_OUTER_JOIN');
  FStringListJuncoes.Add('RIGHT_JOIN');
  FStringListJuncoes.Add('RIGHT_OUTER_JOIN');

  FStringListOperadores.Add('ON');
  FStringListOperadores.Add('AND');
end;

function TFormatadorSQL.PreencherParametrosSQL(const aSQL: string): string;
var
  nCont, nPosParams: integer;
  sSQL, sParams: string;
  lListaParametros, lListaValores: TStringList;
  lNome, lTipo, lValor, lValorFormatado, lCopia, lLetra: string;
  lAbriuParametro: boolean;
begin
  result := aSQL;
  nPosParams := AnsiPos('PARAMS=', aSQL.ToUpper);

  if nPosParams = 0 then
    Exit;

  sSQL := Copy(aSQL, 1, Pred(nPosParams));
  sParams := Copy(aSQL, nPosParams, Length(aSQL) - nPosParams + 1);

  Result := sSQL;

  lListaParametros := TStringList.Create;
  lListaValores := TStringList.Create;
  try
    lAbriuParametro := False;
    lCopia := EmptyStr;

    for lLetra in sParams do
    begin
      if lLetra = '[' then
      begin
        lAbriuParametro := True;
        Continue;
      end;

      if lLetra = ']' then
      begin
        lListaParametros.Add(lCopia);
        lAbriuParametro := False;
        lCopia := EmptyStr;
        Continue;
      end;

      if lAbriuParametro then
        lCopia := lCopia + lLetra;
    end;

    lListaParametros.Sort;
    lListaValores.StrictDelimiter := True;
    lListaValores.Delimiter := ',';

    for nCont := Pred(lListaParametros.Count) downto 0 do
    begin
      lListaValores.DelimitedText := lListaParametros[nCont];
      lNome := ':' + lListaValores[0];
      lTipo := lListaValores[1].ToUpper;
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
          lValor := DateTimeToStr(lValor.ToInteger);
        lValorFormatado := FormatarData(lValor.ToDouble);
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

function TFormatadorSQL.PrepararSQL(const aSQL: string): string;
begin
  result := aSQL;
  result := StringReplace(result, '  ', sESPACO, [rfReplaceAll]);
  result := StringReplace(result, ',', ', ', [rfReplaceAll]);
  result := StringReplace(result, 'LEFT JOIN', 'LEFT_JOIN', [rfReplaceAll]);
  result := StringReplace(result, 'LEFT OUTER JOIN', 'LEFT_OUTER_JOIN', [rfReplaceAll]);
  result := StringReplace(result, 'INNER JOIN', 'INNER_JOIN', [rfReplaceAll]);
  result := StringReplace(result, 'RIGHT JOIN', 'RIGHT_JOIN', [rfReplaceAll]);
  result := StringReplace(result, 'RIGHT OUTER JOIN', 'RIGHT_OUTER_JOIN', [rfReplaceAll]);
  result := StringReplace(result, 'ORDER BY', 'ORDER_BY', [rfReplaceAll]);
  result := StringReplace(result, 'GROUP BY', 'GROUP_BY', [rfReplaceAll]);
end;

procedure TFormatadorSQL.ProcessarClausula(const aValor: string; aBuilder: TStringBuilder);
begin
  DecrementarRecuo(FAcumuladorRecuos);

  if aBuilder.Length > 0 then
    aBuilder.AppendSpaces(FNivelRecuo);

  aBuilder.Append(aValor.ToUpper);

  Inc(FNivelRecuo, nRECUO);
  Inc(FAcumuladorRecuos, nRECUO);

  FPosicaoMesmaLinha := 0;

  if not aValor.ToUpper.Equals('SELECT') then
  begin
    aBuilder.AppendSpaces(FNivelRecuo);
    FQuebrarLinha := False;
  end;
end;

procedure TFormatadorSQL.ProcessarJuncao(const aValor: string; aBuilder: TStringBuilder);
begin
  DecrementarRecuo(FAcumuladorRecuos - nRECUO);

  aBuilder
    .AppendSpaces(FNivelRecuo)
    .Append(aValor.ToUpper.Replace('_', sESPACO, [rfReplaceAll]))
    .Append(sESPACO);

  FPosicaoMesmaLinha := 0;
end;

procedure TFormatadorSQL.ProcessarOperador(const aValor: string; aBuilder: TStringBuilder);
begin
  if not aValor.ToUpper.Equals('AND') then
  begin
    Inc(FNivelRecuo, nRECUO);
    Inc(FAcumuladorRecuos, nRECUO);
  end;

  aBuilder
    .AppendSpaces(FNivelRecuo)
    .Append(aValor.ToUpper)
    .Append(sESPACO);

  if aValor.ToUpper.Equals('ON') then
    aBuilder.Append(sESPACO);

  FPosicaoMesmaLinha := 0;
  FQuebrarLinha := False;
end;

procedure TFormatadorSQL.ProcessarSubSelect(const aSubSelect: string; var aPosicaoToken: integer;
  aBuilder: TStringBuilder);
var
  lRecuoAtual: integer;
begin
  lRecuoAtual := FNivelRecuo;

  // Configura o recuo das colunas do SubSelect
  Inc(FNivelRecuo, FPosicaoMesmaLinha - 3);

  // "-5" é o offset da palavra SELECT
  Inc(aPosicaoToken, aSubSelect.Length - 5);

  aBuilder
    .Append('(')
    .Append(FormatarSQL(aSubSelect))
    .Append(')');

  FNivelRecuo := lRecuoAtual;
end;

function TFormatadorSQL.SubstituirString(const aTexto, aBusca,
  aSubstituicao: string): string;
begin
  result := StringReplace(aTexto, aBusca, aSubstituicao, [rfReplaceAll, rfIgnoreCase]);
end;

constructor TFormatadorSQL.Create;
begin
  CriarObjetosInternos;
  PreencherListas;
end;

procedure TFormatadorSQL.CriarObjetosInternos;
begin
  FStringListClausulas := TStringList.Create;
  FStringListJuncoes := TStringList.Create;
  FStringListOperadores := TStringList.Create;
end;

procedure TFormatadorSQL.DecrementarRecuo(const aQtde: byte);
begin
  if FNivelRecuo > 0 then
  begin
    Dec(FNivelRecuo, aQtde);
    Dec(FAcumuladorRecuos, aQtde);
  end;
end;

destructor TFormatadorSQL.Destroy;
begin
  DestruirObjetosInternos;
  inherited;
end;

procedure TFormatadorSQL.DestruirObjetosInternos;
begin
  FStringListClausulas.Free;
  FStringListJuncoes.Free;
  FStringListOperadores.Free;
end;

function TFormatadorSQL.FormatarData(const aData: TDateTime): string;
begin
  result := QuotedStr(FormatDateTime('dd/mm/yyyy hh:nn:ss', aData));
end;

function TFormatadorSQL.FormatarSQL(aSQL: string): string;
var
  lSQLFormatado: string;
begin
  FNivelRecuo := 0;
  lSQLFormatado := PreencherParametrosSQL(aSQL);
  lSQLFormatado := IdentarSQL(lSQLFormatado);
  result := lSQLFormatado;
end;

function TFormatadorSQL.IdentarSQL(var aSQL: string): string;
var
  lValor: string;
  lBuilder: TStringBuilder;
  lPosicaoToken: integer;

  procedure RecortarSQL;
  begin
    aSQL := Copy(aSQL, lPosicaoToken, aSQL.Length).Trim;
  end;

begin
  lBuilder := TStringBuilder.Create;
  try
    aSQL := PrepararSQL(aSQL);
    FAcumuladorRecuos := 0;
    FQuebrarLinha := True;
    FPosicaoMesmaLinha := 0;

    while aSQL.Length > 0 do
    begin
      lPosicaoToken := Pos(sESPACO, aSQL);

      if lPosicaoToken = 0 then
        lPosicaoToken := Succ(aSQL.Length);

      lValor := Copy(aSQL, 1, Pred(lPosicaoToken));
      Inc(FPosicaoMesmaLinha, Succ(lValor.Length));
      lValor := lValor.Trim;

      if lValor.ToUpper.Equals(sSUBSELECT) then
      begin
        ProcessarSubSelect(PegarSubSelect(aSQL), lPosicaoToken, lBuilder);
        RecortarSQL;
        Continue;
      end;

      if FStringListClausulas.IndexOf(lValor) >= 0 then
      begin
        ProcessarClausula(lValor, lBuilder);
        RecortarSQL;
        Continue;
      end;

      if FStringListJuncoes.IndexOf(lValor) >= 0 then
      begin
        ProcessarJuncao(lValor, lBuilder);
        RecortarSQL;
        Continue;
      end;

      if FStringListOperadores.IndexOf(lValor) >= 0 then
      begin
        ProcessarOperador(lValor, lBuilder);
        RecortarSQL;
        Continue;
      end;

      if FQuebrarLinha then
        lBuilder.AppendSpaces(FNivelRecuo);

      lBuilder.Append(lValor).Append(sESPACO);

      RecortarSQL;
    end;

    result := lBuilder.ToString;
  finally
    lBuilder.Free;
  end;
end;

end.
