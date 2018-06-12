unit Component.LogViewer;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Datasnap.DBClient;

type
  TLogViewer = class(TClientDataSet)
  private
    // Class Fields
    FLogFileName: string;
    FCounter: smallint;
    FStringListFile: TStringList;
    FStringListLine: TStringList;
    FShowOnlySQL: boolean;

    // DataSet Fields
    FType: TField;
    FDatabase: TField;
    FUser: TField;
    FIP: TField;
    FClass: TField;
    FMethod: TField;
    FSQL: TField;
    FDateTime: TField;
    FError: TField;

    // private functions
    function GetType: string;
    function GetDateTime: string;
    function GetError: string;

    // private procedures
    procedure AppendLineToDataSet;
    procedure AssignFields;
    procedure DefineFields;
    procedure LoadFile;
    procedure Initialize;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    // public functions
    function IsErrorLine: boolean;
    function IsSQLEmpty: boolean;
    function CopyValue(const aField: string): string;
    function GetSQL: string;
    function GetRecordCounter: string;

    // public procedures
    procedure LoadLog;
    procedure ReloadLog;
    procedure RemoveFilter;
    procedure SetLogFilter(const aFilter: string);

    // properties
    property LogFileName: string read FLogFileName write FLogFileName;
    property ShowOnlySQL: boolean read FShowOnlySQL write FShowOnlySQL;
  end;

procedure Register;

const
  POSITION_TYPE = 5;
  POSITION_DATABASE = 6;
  POSITION_USER = 9;
  POSITION_IP = 10;
  POSITION_DATE = 11;
  POSITION_TIME = 12;
  POSITION_CLASS = 13;
  POSITION_METHOD = 14;
  POSITION_SQL = 15;

implementation

procedure Register;
begin
  RegisterComponents('LogViewer', [TLogViewer]);
end;

{ TLogViewer }

procedure TLogViewer.AppendLineToDataSet;
begin
  Self.Append;
  FType.AsString := FStringListLine[POSITION_TYPE];
  FDataBase.AsString := FStringListLine[POSITION_DATABASE];
  FUser.AsString := FStringListLine[POSITION_USER];
  FIP.AsString := FStringListLine[POSITION_IP];
  FDateTime.AsString := GetDateTime;
  FClass.AsString := FStringListLine[POSITION_CLASS];
  FMethod.AsString := FStringListLine[POSITION_METHOD];
  FSQL.AsString := FStringListLine[POSITION_SQL];
  FError.AsString := GetError;
  Self.Post;
end;

procedure TLogViewer.AssignFields;
begin
  FType := Self.FieldByName('Type');
  FDatabase := Self.FieldByName('Database');
  FUser := Self.FieldByName('User');
  FIP := Self.FieldByName('IP');
  FClass := Self.FieldByName('Class');
  FMethod := Self.FieldByName('Method');
  FSQL := Self.FieldByName('SQL');
  FDateTime := Self.FieldByName('DateTime');
  FError := Self.FieldByName('Error');
end;

function TLogViewer.CopyValue(const aField: string): string;
begin
  result := Self.FieldByName(aField).AsString.Trim;
end;

constructor TLogViewer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  Initialize;
  DefineFields;
  AssignFields;
end;

procedure TLogViewer.DefineFields;
begin
  with Self.FieldDefs do
  begin
    Add('Type', ftString, 10);
    Add('Database', ftString, 20);
    Add('User', ftString, 50);
    Add('IP', ftString, 20);
    Add('Class', ftString, 100);
    Add('Method', ftString, 100);
    Add('SQL', ftString, 15000);
    Add('DateTime', ftString, 20);
    Add('Error', ftString, 1);
  end;
  Self.CreateDataSet;
  Self.FilterOptions := [foCaseInsensitive];
  Self.LogChanges := False;
end;

destructor TLogViewer.Destroy;
begin
  FStringListLine.Free;
  FStringListFile.Free;
  inherited;
end;

function TLogViewer.GetDateTime: string;
begin
  result := Format('%s  %s', [FStringListLine[POSITION_DATE],
    Copy(FStringListLine[POSITION_TIME], 0, 8)]);
end;

function TLogViewer.GetError: string;
begin
  result := EmptyStr;
  if (GetType.Equals('SAIDA')) and (not FStringListLine[POSITION_SQL].IsEmpty) then
  begin
    result := 'S';
  end;
end;

function TLogViewer.GetRecordCounter: string;
begin
  result := Format('Registro %d / %d', [Self.RecNo, Self.RecordCount]);
end;

function TLogViewer.GetSQL: string;
begin
  result := FSQL.AsString;
end;

function TLogViewer.GetType: string;
begin
  result := FStringListLine[POSITION_TYPE];
end;

procedure TLogViewer.Initialize;
begin
  FStringListFile := TStringList.Create;
  FStringListLine := TStringList.Create;

  Self.FCounter := 0;
  Self.FShowOnlySQL := False;
  Self.FLogFileName := EmptyStr;

  FStringListLine.Delimiter := ';';
  FStringListLine.StrictDelimiter := True;
end;

function TLogViewer.IsErrorLine: boolean;
begin
  result := FError.AsString = 'S';
end;

function TLogViewer.IsSQLEmpty: boolean;
begin
  result := FSQL.AsString.IsEmpty;
end;

procedure TLogViewer.LoadFile;
begin
  FStringListFile.LoadFromStream(TFileStream.Create(FLogFileName, fmOpenRead or fmShareDenyNone));
end;

procedure TLogViewer.LoadLog;
var
  lContador: integer;
  lOriginalAfterScroll: TDataSetNotifyEvent;
begin
  lOriginalAfterScroll := Self.AfterScroll;
  Self.AfterScroll := nil;
  Self.DisableControls;
  try
    LoadFile;

    for lContador := FCounter to Pred(FStringListFile.Count) do
    begin
      FStringListLine.DelimitedText := FStringListFile[lContador];

      if FShowOnlySQL and (not GetType.Equals('SQL')) then
        Continue;

      AppendLineToDataSet;
    end;
  finally
    Self.AfterScroll := lOriginalAfterScroll;
    Self.EnableControls;
  end;
  FCounter := FStringListFile.Count;
end;

procedure TLogViewer.ReloadLog;
begin
  Self.EmptyDataSet;
  FCounter := 0;
  LoadLog;
end;

procedure TLogViewer.RemoveFilter;
begin
  Self.Filter := EmptyStr;
  Self.Filtered := False;
  Self.Last;
end;

procedure TLogViewer.SetLogFilter(const aFilter: string);
begin
  Self.Filter := aFilter;
  Self.Filtered := True;
  Self.Last;
end;

end.
