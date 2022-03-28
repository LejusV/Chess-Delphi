program chessproj;

uses
  Vcl.Forms,
  Chess in 'Chess.pas' {frmGame};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmGame, frmGame);
  Application.Run;
end.
