unit Component.DBGridLog;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.Grids, Vcl.DBGrids,
  Winapi.Messages;

type
  TDBGridLog = class(TDBGrid)
  private
    FColResize: TNotifyEvent;

    procedure WMNCCalcSize(var Msg: TMessage); message WM_NCCALCSIZE;
  protected
    procedure ColWidthsChanged; override;
  published
    property OnColResize: TNotifyEvent read FColResize Write FColResize;
  end;

procedure Register;

implementation

uses
  Winapi.Windows;

procedure Register;
begin
  RegisterComponents('LogViewer', [TDBGridLog]);
end;

{ TDBGridLog }

procedure TDBGridLog.ColWidthsChanged;
begin
  inherited;

  if Assigned(FColResize) then
    FColResize(Self);
end;

procedure TDBGridLog.WMNCCalcSize(var Msg: TMessage);
var
  Style: Integer;
begin
  Style := GetWindowLong(Handle, GWL_STYLE);
  if (Style and WS_HSCROLL) <> 0 then
    SetWindowLong(Handle, GWL_STYLE, Style and not WS_HSCROLL);

  inherited;
end;

end.
