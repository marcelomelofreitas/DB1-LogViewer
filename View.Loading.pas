unit View.Loading;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TfLoading = class(TForm)
    PanelLoading: TPanel;
    LabelLoading: TLabel;
  end;

var
  fLoading: TfLoading;

implementation

{$R *.dfm}

end.
