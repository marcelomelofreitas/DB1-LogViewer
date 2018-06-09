unit Utils.FormatadorSQL;

interface

uses
  System.SysUtils, System.Classes;

type
  TClausulas = (clSelect, clFrom, clWhere);

  TFormatadorSQL = class
  private
    FStringListClausulas: TStringList;
    FStringListJuncoes: TStringList;
    FStringListOperadores: TStringList;
    FNivelRecuo: integer;
    FAcumuladorRecuos: integer;
    FPosicaoMesmaLinha: integer;
    FClausula: TClausulas;

    function FormatarData(const aData: TDateTime): string;
    function SubstituirString(const aTexto, aBusca, aSubstituicao: string): string;
    function PreencherParametrosSQL(const aSQL: string): string;
    function IdentarSQL(const aSQLFormatado: string): string;
    function VerificarDeveQuebrarLinha(const aValor: string): boolean;

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
    function FormatarSQL(const aSQL: string): string;
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

function TFormatadorSQL.PrepararSQL(const aSQL: string): string;
begin
  result := SubstituirString(aSQL, '  ', sESPACO);
  result := SubstituirString(result, ',', ', ');
  result := SubstituirString(result, 'LEFT JOIN', 'LEFT_JOIN');
  result := SubstituirString(result, 'LEFT OUTER JOIN', 'LEFT_OUTER_JOIN');
  result := SubstituirString(result, 'INNER JOIN', 'INNER_JOIN');
  result := SubstituirString(result, 'RIGHT JOIN', 'RIGHT_JOIN');
  result := SubstituirString(result, 'RIGHT OUTER JOIN', 'RIGHT_OUTER_JOIN');
  result := SubstituirString(result, 'ORDER BY', 'ORDER_BY');
  result := SubstituirString(result, 'GROUP BY', 'GROUP_BY');
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

  aBuilder.AppendSpaces(FNivelRecuo);

  if aValor.ToUpper.Equals('SELECT') then
    FClausula := clSelect
  else if aValor.ToUpper.Equals('FROM') then
    FClausula := clFrom
  else if aValor.ToUpper.Equals('WHERE') then
    FClausula := clWhere;
end;

procedure TFormatadorSQL.ProcessarJuncao(const aValor: string; aBuilder: TStringBuilder);
begin
  DecrementarRecuo(FAcumuladorRecuos - nRECUO);

  aBuilder
    .AppendSpaces(FNivelRecuo)
    .Append(aValor.ToUpper.Replace('_', sESPACO, [rfReplaceAll]))
    .Append(sESPACO);

  FPosicaoMesmaLinha := aValor.Length;
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

  FPosicaoMesmaLinha := aValor.Length;
end;

procedure TFormatadorSQL.ProcessarSubSelect(const aSubSelect: string;
      var aPosicaoToken: integer; aBuilder: TStringBuilder);
var
  lRecuoAtual: integer;
  lClausulaAtual: TClausulas;
begin
  lRecuoAtual := FNivelRecuo;
  lClausulaAtual := FClausula;

  // Configura o recuo das colunas do SubSelect
  Inc(FNivelRecuo, FPosicaoMesmaLinha + 2);

  // "-5" é o offset da palavra SELECT
  Inc(aPosicaoToken, aSubSelect.Length - 5);

  aBuilder
    //.AppendSpaces(FNivelRecuo)
    .Append('(')
    .Append(IdentarSQL(aSubSelect))
    .Append(')');

  FNivelRecuo := lRecuoAtual;
  FClausula := lClausulaAtual;
end;

function TFormatadorSQL.SubstituirString(const aTexto, aBusca,
  aSubstituicao: string): string;
begin
  result := StringReplace(aTexto, aBusca, aSubstituicao, [rfReplaceAll, rfIgnoreCase]);
end;

function TFormatadorSQL.VerificarDeveQuebrarLinha(const aValor: string): boolean;
var
  lUltimaLetraEhVirgula: boolean;
begin
  lUltimaLetraEhVirgula := (aValor[aValor.Length] = ',');
  result := lUltimaLetraEhVirgula and (FClausula <> clWhere);
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

function TFormatadorSQL.FormatarSQL(const aSQL: string): string;
var
  lSQLFormatado: string;
begin
  FNivelRecuo := 0;
  lSQLFormatado := PreencherParametrosSQL(aSQL);
  lSQLFormatado := PrepararSQL(lSQLFormatado);
  result := IdentarSQL(lSQLFormatado);
end;

function TFormatadorSQL.IdentarSQL(const aSQLFormatado: string): string;
var
  lValor: string;
  lSQL: string;
  lBuilder: TStringBuilder;
  lPosicaoToken: integer;

  procedure RecortarSQL;
  begin
    lSQL := Copy(lSQL, lPosicaoToken, lSQL.Length).Trim;
  end;

begin
  lSQL := aSQLFormatado;
  lBuilder := TStringBuilder.Create;
  try
    FAcumuladorRecuos := 0;
    FPosicaoMesmaLinha := 0;

    while lSQL.Length > 0 do
    begin
      lPosicaoToken := Pos(sESPACO, lSQL);

      if lPosicaoToken = 0 then
        lPosicaoToken := Succ(lSQL.Length);

      lValor := Copy(lSQL, 1, Pred(lPosicaoToken)).Trim;

      if lValor.ToUpper.Equals(sSUBSELECT) then
      begin
        ProcessarSubSelect(PegarSubSelect(lSQL), lPosicaoToken, lBuilder);
        RecortarSQL;
        Continue;
      end;

      if FStringListClausulas.IndexOf(lValor.ToUpper) >= 0 then
      begin
        ProcessarClausula(lValor, lBuilder);
        RecortarSQL;
        Continue;
      end;

      if FStringListJuncoes.IndexOf(lValor.ToUpper) >= 0 then
      begin
        ProcessarJuncao(lValor, lBuilder);
        RecortarSQL;
        Continue;
      end;

      if FStringListOperadores.IndexOf(lValor.ToUpper) >= 0 then
      begin
        ProcessarOperador(lValor, lBuilder);
        RecortarSQL;
        Continue;
      end;

      Inc(FPosicaoMesmaLinha, Succ(lValor.Length));

      lBuilder.Append(lValor).Append(sESPACO);

      if VerificarDeveQuebrarLinha(lValor) then
      begin
        lBuilder.AppendSpaces(FNivelRecuo);
        FPosicaoMesmaLinha := 0;
      end;

      RecortarSQL;
    end;

    result := lBuilder.ToString;
  finally
    lBuilder.Free;
  end;
end;

end.
