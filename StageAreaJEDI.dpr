program StageAreaJEDI;

uses
  Forms,
  frmPrincipal in 'frmPrincipal.pas' {FStageAreaJEDI},
  frmCredencial in 'frmCredencial.pas' {FCredencial};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFCredencial, FCredencial);
  Application.Run;
end.
