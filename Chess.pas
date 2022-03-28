unit Chess;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.Generics.Collections, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TfrmGame = class(TForm)
    sqrCell_A2: TShape;
    sqrCell_A3: TShape;
    sqrCell_A4: TShape;
    sqrCell_A5: TShape;
    sqrCell_A6: TShape;
    sqrCell_A7: TShape;
    sqrCell_A8: TShape;
    sqrCell_A1: TShape;
    sqrCell_B2: TShape;
    sqrCell_B3: TShape;
    sqrCell_B4: TShape;
    sqrCell_B5: TShape;
    sqrCell_B6: TShape;
    sqrCell_B7: TShape;
    sqrCell_B8: TShape;
    sqrCell_B1: TShape;
    sqrCell_C2: TShape;
    sqrCell_C3: TShape;
    sqrCell_C4: TShape;
    sqrCell_C5: TShape;
    sqrCell_C6: TShape;
    sqrCell_C7: TShape;
    sqrCell_C8: TShape;
    sqrCell_C1: TShape;
    sqrCell_D2: TShape;
    sqrCell_D3: TShape;
    sqrCell_D4: TShape;
    sqrCell_D5: TShape;
    sqrCell_D6: TShape;
    sqrCell_D7: TShape;
    sqrCell_D8: TShape;
    sqrCell_D1: TShape;
    sqrCell_E1: TShape;
    sqrCell_E8: TShape;
    sqrCell_E7: TShape;
    sqrCell_E6: TShape;
    sqrCell_E5: TShape;
    sqrCell_E4: TShape;
    sqrCell_E3: TShape;
    sqrCell_E2: TShape;
    sqrCell_F1: TShape;
    sqrCell_F8: TShape;
    sqrCell_F7: TShape;
    sqrCell_F6: TShape;
    sqrCell_F5: TShape;
    sqrCell_F4: TShape;
    sqrCell_F3: TShape;
    sqrCell_F2: TShape;
    sqrCell_G1: TShape;
    sqrCell_G8: TShape;
    sqrCell_G7: TShape;
    sqrCell_G6: TShape;
    sqrCell_G5: TShape;
    sqrCell_G4: TShape;
    sqrCell_G3: TShape;
    sqrCell_G2: TShape;
    sqrCell_H1: TShape;
    sqrCell_H8: TShape;
    sqrCell_H7: TShape;
    sqrCell_H6: TShape;
    sqrCell_H5: TShape;
    sqrCell_H4: TShape;
    sqrCell_H3: TShape;
    sqrCell_H2: TShape;
    Label1: TLabel;

    procedure GenerateSet(Sender: TObject);
    procedure DestroySet(Sender: TObject);
  strict private
    { D�clarations priv�es }
    fCellsList: TObjectList<TShape>;
  public
    { D�clarations publiques }
    property Cells : TObjectList<TShape> read fCellsList;
  end;

var
  frmGame: TfrmGame;

implementation

{$R *.dfm}

procedure TfrmGame.DestroySet(Sender: TObject);
begin
  fCellsList.free;
end;

procedure TfrmGame.GenerateSet(Sender: TObject);
var
  i: Integer;
begin
  fcellsList.Create;
  fcellsList.Add(sqrCell_A1);
  fcellsList.Add(sqrCell_A2);
  fcellsList.Add(sqrCell_A3);
  fcellsList.Add(sqrCell_A4);
  fcellsList.Add(sqrCell_A5);
  fcellsList.Add(sqrCell_A6);
  fcellsList.Add(sqrCell_A7);
  fcellsList.Add(sqrCell_A8);
  fcellsList.Add(sqrCell_B1);
  fcellsList.Add(sqrCell_B2);
  fcellsList.Add(sqrCell_B3);
  fcellsList.Add(sqrCell_B4);
  fcellsList.Add(sqrCell_B5);
  fcellsList.Add(sqrCell_B6);
  fcellsList.Add(sqrCell_B7);
  fcellsList.Add(sqrCell_B8);
  fcellsList.Add(sqrCell_C1);
  fcellsList.Add(sqrCell_C2);
  fcellsList.Add(sqrCell_C3);
  fcellsList.Add(sqrCell_C4);
  fcellsList.Add(sqrCell_C5);
  fcellsList.Add(sqrCell_C6);
  fcellsList.Add(sqrCell_C7);
  fcellsList.Add(sqrCell_C8);
  fcellsList.Add(sqrCell_D1);
  fcellsList.Add(sqrCell_D2);
  fcellsList.Add(sqrCell_D3);
  fcellsList.Add(sqrCell_D4);
  fcellsList.Add(sqrCell_D5);
  fcellsList.Add(sqrCell_D6);
  fcellsList.Add(sqrCell_D7);
  fcellsList.Add(sqrCell_D8);
  fcellsList.Add(sqrCell_E1);
  fcellsList.Add(sqrCell_E2);
  fcellsList.Add(sqrCell_E3);
  fcellsList.Add(sqrCell_E4);
  fcellsList.Add(sqrCell_E5);
  fcellsList.Add(sqrCell_E6);
  fcellsList.Add(sqrCell_E7);
  fcellsList.Add(sqrCell_E8);
  fcellsList.Add(sqrCell_F1);
  fcellsList.Add(sqrCell_F2);
  fcellsList.Add(sqrCell_F3);
  fcellsList.Add(sqrCell_F4);
  fcellsList.Add(sqrCell_F5);
  fcellsList.Add(sqrCell_F6);
  fcellsList.Add(sqrCell_F7);
  fcellsList.Add(sqrCell_F8);
  fcellsList.Add(sqrCell_G1);
  fcellsList.Add(sqrCell_G2);
  fcellsList.Add(sqrCell_G3);
  fcellsList.Add(sqrCell_G4);
  fcellsList.Add(sqrCell_G5);
  fcellsList.Add(sqrCell_G6);
  fcellsList.Add(sqrCell_G7);
  fcellsList.Add(sqrCell_G8);
  fcellsList.Add(sqrCell_H1);
  fcellsList.Add(sqrCell_H2);
  fcellsList.Add(sqrCell_H3);
  fcellsList.Add(sqrCell_H4);
  fcellsList.Add(sqrCell_H5);
  fcellsList.Add(sqrCell_H6);
  fcellsList.Add(sqrCell_H7);
  fcellsList.Add(sqrCell_H8);

  i := 0;
  while i < fcellsList.Count - 1 do
  begin
    fcellsList[i].Brush.Color := RGB(210, 206, 176) {11587282};
    fcellsList[i + 1].Brush.Color := RGB(160, 137, 65) {4295072};
    i := i + 2;
  end;
  Label1.Caption := IntToStr(fcellsList.Count);
end;

 end.
