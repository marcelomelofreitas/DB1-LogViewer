unit Component.DBGridLog;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.Grids, Vcl.DBGrids;

type
  TDBGridLog = class(TDBGrid)
  private
    FColResize: TNotifyEvent;
  protected
    procedure ColWidthsChanged; override;
  published
    property OnColResize: TNotifyEvent read FColResize Write FColResize;
  end;

procedure Register;

implementation

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

end.
