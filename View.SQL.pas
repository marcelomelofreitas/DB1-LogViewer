unit View.SQL;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TfFormularioSQL = class(TForm)
    MemoSQL: TMemo;
    procedure MemoSQLKeyPress(Sender: TObject; var Key: Char);
  private
    procedure SetSQL(const aSQL: string);
  public
    property SQL: string write SetSQL;
  end;

implementation

uses
  ClipBrd;

{$R *.dfm}

procedure TfFormularioSQL.MemoSQLKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = ^C then
    ClipBoard.AsText := MemoSQL.Lines.Text;

  if Key = ^A then
    MemoSQL.SelectAll;
end;

procedure TfFormularioSQL.SetSQL(const aSQL: string);
begin
  MemoSQL.Lines.Text := aSQL;
end;

end.
