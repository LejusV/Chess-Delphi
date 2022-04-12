program chessproj;

uses
  Vcl.Forms,
  Chess in 'Chess.pas' {ChessForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TChessForm, ChessForm);
  Application.Run;
end.
