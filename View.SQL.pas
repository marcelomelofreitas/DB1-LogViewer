unit View.SQL;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TfFormularioSQL = class(TForm)
    MemoSQL: TMemo;
  private
    procedure SetSQL(const aSQL: string);
  public
    property SQL: string write SetSQL;
  end;

implementation

uses
  ClipBrd;

{$R *.dfm}

procedure TfFormularioSQL.SetSQL(const aSQL: string);
begin
  MemoSQL.Lines.Text := aSQL;
end;

end.
