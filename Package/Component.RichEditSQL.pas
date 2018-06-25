unit Component.RichEditSQL;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.StdCtrls, Vcl.ComCtrls,
  SQL.Formatter, SQL.Highlighter;

type
  TRichEditSQL = class(TRichEdit)
  private
    FSQLFormatter: TSQLFormatter;
    FSQLHighlighter: TSQLHighlighter;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure FormatSQL;
    procedure HightlightSQL;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('LogViewer', [TRichEditSQL]);
end;

{ TRichEditSQL }

constructor TRichEditSQL.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FSQLFormatter := TSQLFormatter.Create;
  FSQLHighlighter := TSQLHighlighter.Create(Self);
end;

destructor TRichEditSQL.Destroy;
begin
  FSQLHighlighter.Free;
  FSQLFormatter.Free;
  inherited;
end;

procedure TRichEditSQL.FormatSQL;
begin
  Self.Lines.Text := FSQLFormatter.FormatSQL(Self.Lines.Text);
  FSQLHighlighter.HighlightSQL;
end;

procedure TRichEditSQL.HightlightSQL;
begin
  FSQLHighlighter.HighlightSQL;
end;

end.
