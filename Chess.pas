unit Chess;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.Generics.Collections, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TChessCell = class(TShape)
  published  
    procedure CellCoordsDisplay(Sender: TObject);

  public
    { D�clarations publiques }
    constructor Create(Owner : TComponent); override;
  end;

  TCellsArr = array[0..63] of TChessCell;

  TChessBoard = class
  private
    { D�clarations priv�es }
    _cells : TCellsArr;
    function GetCell(Col : Char; Row : Integer): TChessCell;
    procedure SetCell(Col : Char; Row : Integer; const Value: TChessCell);

    function GetBoardSize : Integer;

  public
    { D�clarations publiques }
    property Cell[Col : Char; Row : Integer]: TChessCell read GetCell write SetCell; default;
    property Size : Integer read GetBoardSize;
  end;

  TChessForm = class(TForm)
    procedure GenerateBoard(Sender: TObject);
    procedure DestroyBoard(Sender: TObject);
  strict private
    { D�clarations priv�es }
    _lblCellIndicator: TLabel;
    _board: TChessBoard;
    _boardOutline: TShape;
  public
    { D�clarations publiques }
    property Board: TChessBoard read _board;
    property CellIndicator : TLabel read _lblCellIndicator;
  end;







var
  {FormTotalementInutilePourQueLeCompilateurArreteDeMeCrierDessus : TfrmGame;}
  ChessForm: TChessForm;

implementation

{$R *.dfm}
{ TChessBoard }
function TChessBoard.GetCell(Col : Char; Row : Integer): TChessCell;
begin
  Result := _cells[(Ord(Col) - Ord('A')) + (Row - 1) * 8];
end;

procedure TChessBoard.SetCell(Col : Char; Row : Integer; const Value: TChessCell);
begin
  _cells[(Ord(Col) - Ord('A')) + (Row - 1) * 8] := Value;
end;

function TChessBoard.GetBoardSize: Integer;
begin
  Result := Length(_cells);
end;


{ TChessCell }

constructor TChessCell.Create(Owner : TComponent);
begin
  inherited Create(Owner);
  
  self.Width := 96;
  self.Height := 96;
  self.Shape := stRectangle;
  self.Pen.Color := RGB(66, 31, 0);
  self.Tag := 0;
  OnMouseEnter := CellCoordsDisplay;
end;

procedure TChessCell.CellCoordsDisplay(Sender: TObject);
begin
  ChessForm.CellIndicator.Caption := 'Cell ' + (Ord('A') + (TChessCell(Sender).Tag - 1) mod 8).ToString + (((TChessCell(Sender).Tag - 1) div 8) + 1).ToString;
end;


{ TChessForm }

procedure TChessForm.DestroyBoard(Sender: TObject);
begin
  //
end;

procedure TChessForm.GenerateBoard(Sender: TObject);
var
  col, row: Integer;
  sqrCell: TChessCell;
  lbl: TLabel;
begin
  _lblCellIndicator := TLabel.Create(self);
  _lblCellIndicator.Left := 0;
  _lblCellIndicator.Top := 0;
  _lblCellIndicator.Width := 4;
  _lblCellIndicator.Height := 16;
  _lblCellIndicator.Font.Charset := DEFAULT_CHARSET;
  _lblCellIndicator.Font.Color := clWhite;
  _lblCellIndicator.Font.Height := -13;
  _lblCellIndicator.Font.Name := 'Tahoma';
  _lblCellIndicator.Font.Style := [];
  _lblCellIndicator.ParentFont := False;
  for col := Ord('A') to Ord('H') do
  begin
    for row := 1 to 8 do
    begin
      sqrCell := TChessCell.Create(self);
      sqrCell.Parent := self;
      sqrCell.Left := (col - Ord('A')) * 96 + 48;
      sqrCell.Top := (row - 1) * 96 + 48;{
      sqrCell.Width := 96;
      sqrCell.Height := 96;
      sqrCell.Shape := stRectangle;
      sqrCell.Pen.Color := RGB(66, 31, 0);}
      sqrCell.Tag := (col - Ord('A')) + (row - 1) * 8;{
      OnMouseEnter := GetCellCoords;}
      if ((col - Ord('A')) mod 2 = 0) and (row - 1 mod 2 = 0) then
        sqrCell.Brush.Color := RGB(210, 206, 176)
      else
        sqrCell.Brush.Color := RGB(160, 137, 65);
      _board[Chr(col), row] := sqrCell;
    end;
  end;
  _lblCellIndicator.Caption := IntToStr(_board.Size) + ' cells';

  _boardOutline := TShape.Create(self);
  _boardOutline.Parent := self;
  _boardOutline.Left := 45;
  _boardOutline.Top := 45;
  _boardOutline.Width := 774;
  _boardOutline.Height := 774;
  _boardOutline.Shape := stRectangle;
  _boardOutline.Brush.Style := bsClear;
  _boardOutline.Pen.Color := RGB(66, 29, 0);
  _boardOutline.Pen.Width := 3;
end;

end.
