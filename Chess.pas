unit Chess;

interface

{$REGION 'Used Units'}
  uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.Generics.Collections, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage;

{$ENDREGION}

{$REGION 'Types Definition'}
  type
      TChessPiece = class;

  {$REGION 'TChessCell Class'}
    // Classe Cellule dérivée de TShape
      TChessCell = class(TShape) // Forward declaration
      strict private
        fPiece : TChessPiece;
      published
        procedure CellCoordsDisplay(Sender: TObject);
        property Piece : TChessPiece read fPiece write fPiece;
  
      public
        { D�clarations publiques }
        constructor Create(Owner : TComponent); override; // Constructeur
      end;
  {$ENDREGION}

  {$REGION 'TChessBoard Type'}
    // Type du Plateau : Tableau de Cellules
    TChessBoard = array[0..63] of TChessCell;
  {$ENDREGION}
  
  
  {$REGION 'TChessPiece Class'}
    // Classe Pièce
    TChessPiece = class(TImage)
    strict private
    strict protected
      fIsFocused : Boolean;
      fCell : TChessCell; // Cellule de la pièce
      fColor : TColor; // Couleur de la pièce
      procedure CheckPossibleMovesOnStraightLine(possibleMoves : TList<TChessCell>; cellTag : Integer; tagDiff2Cells : Integer; tagLastCell : Integer);
        // Vérifie les mouvements possibles selon un paramètre saut de tag entre 2 cellules consécutives à check
    public
      { Déclarations publiques }
      property Cell : TChessCell read fCell write fCell; // Accesseur de la cellule de la pièce
      property Color : TColor read fColor; // Accesseur de la couleur de la pièce

      procedure DoOnClick(Sender: TObject);
      constructor Create(Owner : TComponent; Color : TColor); virtual; // Constructeur
      function GetPossibleMoves(Board : TChessBoard) : TList<TChessCell>; virtual; abstract;// Retourne la liste des cellules de déplacement possibles pour la pièce
      procedure Move(CellTag : Integer); // Déplacement de la pièce
    end;
  {$ENDREGION}
  
  {$REGION 'TChessPawn Class'}
    // Classe Pion
    TChessPawn = class(TChessPiece)
    strict private
    public
      { Déclarations publiques }
      constructor Create(Owner : TComponent; Color : TColor); override; // Constructeur
      function GetPossibleMoves(Board : TChessBoard) : TList<TChessCell>; override; // Retourne la liste des cellules de déplacement possibles pour la pièce
    end;
  {$ENDREGION}

  {$REGION 'TChessRook Class'}
    // Classe Pion
    TChessRook = class(TChessPiece)
    strict private
    public
      { Déclarations publiques }
      constructor Create(Owner : TComponent; Color: TColor); override; // Constructeur
      function GetPossibleMoves(Board : TChessBoard) : TList<TChessCell>; // Retourne la liste des cellules de déplacement possibles pour la pièce
    end;
  {$ENDREGION}

  {$REGION 'TChessKnight Class'}
    // Classe Pion
    TChessKnight = class(TChessPiece)
    strict private
    public
      { Déclarations publiques }
      constructor Create(Owner : TComponent; Color: TColor); override; // Constructeur
      function GetPossibleMoves(Board : TChessBoard) : TList<TChessCell>; // Retourne la liste des cellules de déplacement possibles pour la pièce
    end;
  {$ENDREGION}

  {$REGION 'TChessBishop Class'}
    // Classe Pion
    TChessBishop = class(TChessPiece)
    strict private
    public
      { Déclarations publiques }
      constructor Create(Owner : TComponent; Color: TColor); override; // Constructeur
      function GetPossibleMoves(Board : TChessBoard) : TList<TChessCell>; // Retourne la liste des cellules de déplacement possibles pour la pièce
    end;
  {$ENDREGION}
  
  {$REGION 'TChessKing Class'}
    // Classe Pion
    TChessKing = class(TChessPiece)
    strict private
    public
      { Déclarations publiques }
      constructor Create(Owner : TComponent; Color: TColor); override; // Constructeur
      function GetPossibleMoves(Board : TChessBoard) : TList<TChessCell>; // Retourne la liste des cellules de déplacement possibles pour la pièce
    end;
  {$ENDREGION}

  
  {$REGION 'TChessQueen Class'}
    // Classe Pion
    TChessQueen = class(TChessPiece)
    strict private
    public
      { Déclarations publiques }
      constructor Create(Owner : TComponent; Color: TColor); override; // Constructeur
      function GetPossibleMoves(Board : TChessBoard) : TList<TChessCell>; // Retourne la liste des cellules de déplacement possibles pour la pièce
    end;
  {$ENDREGION}

  {$REGION 'TChessPlayer Class'}
    TChessPlayer = class
    strict private
      fBishops : TList<TChessBishop>;
      fColor : TColor;
      fKing : TChessKing;
      fKnights : TList<TChessKnight>;
      fName : String;
      fPawns : TList<TChessPawn>;
      fProfilePicture : TImage;
      fQueens : TList<TChessQueen>;
      fRooks : TList<TChessRook>;
    public
      { Déclarations publiques }
      constructor Create(Owner : TComponent; Color : TColor; Name : String);
      property Bishops : TList<TChessBishop> read fBishops;
      property Color : TColor read fColor;
      property King : TChessKing read fKing;
      property Knights : TList<TChessKnight> read fKnights;
      property Name : String read fName;
      property Pawns : TList<TChessPawn> read fPawns;
      property ProfilePicture : TImage read fProfilePicture;
      property Queens : TList<TChessQueen> read fQueens;
      property Rooks : TList<TChessRook> read fRooks;
    end;

  {$ENDREGION}

  {$REGION 'TChessForm Class'}
    // Classe Fenêtre de Jeu dérivée de TForm
    TChessForm = class(TForm)
      procedure GenerateBoard(Sender: TObject); // Génération du plateau
      procedure DestroyBoard(Sender: TObject); // Destruction du plateau
    private
      { D�clarations priv�es }
      fLblCellIndicator: TLabel; // Label indiquant les coordonnées de la cellule sélectionnée
      fBoard: TChessBoard; // Plateau de jeu
      fBoardOutline: TShape; // Contour du plateau
      fPlayer1, fPlayer2 : TChessPlayer; // Joueurs
    public
      { D�clarations publiques }
      property Board: TChessBoard read fBoard ; // Accès au plateau de jeu
      property CellIndicator : TLabel read fLblCellIndicator; // Accès au label indiquant les coordonnées de la cellule sélectionnée
      property Player1 : TChessPlayer read fPlayer1; // Joueur 1
      property Player2 : TChessPlayer read fPlayer2; // Joueur 2
      constructor Create(Owner : TComponent); override; // Constructeur
    end;
  {$ENDREGION}
{$ENDREGION}

{$REGION 'Gobal Variables'}
  var
    ChessForm: TChessForm;
{$ENDREGION}

implementation

{$REGION 'DFM Files'}
  {$R *.dfm}
{$ENDREGION}

{$REGION 'Methods'}
  
  {$REGION 'TChessCell Methods'}
    { TChessCell }
    
    constructor TChessCell.Create(Owner : TComponent);
    begin
      inherited Create(Owner);
      self.Width := 64;
      self.Height := 64;
      self.Shape := stRectangle;
      self.Pen.Color := RGB(66, 31, 0);
      //OnMouseEnter := CellCoordsDisplay;
    end;
    
    procedure TChessCell.CellCoordsDisplay(Sender: TObject);
    begin
      ChessForm.fLblCellIndicator.Caption := 'Cell ' + (Ord('A') + (TChessCell(Sender).Tag - 1) mod 8).ToString + (((TChessCell(Sender).Tag - 1) div 8) + 1).ToString();
    end;
    
  {$ENDREGION}
  
  {$REGION 'TChessPiece Methods'}
    { TChessPiece }

    procedure TChessPiece.DoOnClick(Sender: TObject);
    begin
      GetPossibleMoves(ChessForm.Board);
    end;

    constructor TChessPiece.Create(Owner : TComponent; Color : TColor);
    begin
      inherited Create(Owner);
      self.Width := 84;
      self.Height := 84;
      self.fColor := Color;
      self.fIsFocused := False;
      self.Parent := ChessForm;
      self.OnClick := DoOnClick;
    end; 
    
    
    procedure TChessPiece.CheckPossibleMovesOnStraightLine(possibleMoves : TList<TChessCell>; cellTag : Integer; tagDiff2Cells : Integer; tagLastCell : Integer);
    // Vérifie les mouvements possibles sur un pattern régulier
    // (in/dé.crémentation de i par un nombre constant en paramètre tagDiff2Cells)
    var
      i : Integer;
    begin
      i := cellTag + tagDiff2Cells;
      if possibleMoves <> nil then
      begin
        // Tant que la cellule n'est pas vide ni hors du plateau
        while
          (((tagLastCell > cellTag) and (i <= tagLastCell)) or ((tagLastCell < cellTag) and (i >= tagLastCell)))  // Tant que i ne dépasse pas le tag de la
                                                                                                          // dernière cellule (selon le sens du déplacement)
          and Assigned(ChessForm.Board[i].Piece) do                                                                    // Et qu'une case n'est pas occupée
        begin
          possibleMoves.Add(ChessForm.Board[i]);                                                                    // On ajoute la case correspondante
                                                                                                          // à la liste des déplacements possibles
          i := i + tagDiff2Cells;                                                                     // Et on passe à la suivante
        end;
        if ((tagLastCell > cellTag) and (i <= tagLastCell))         // Cas où i est décrémenté
          or ((tagLastCell < cellTag) and (i >= tagLastCell)) then  // Cas où i est incrémenté
                                                                // Si l'arrêt de la boucle est dû à la présence d'une pièce
                                                                // (la boucle s'est arrêtée avant la fin du plateau peut importe le côté)
          if ChessForm.Board[i].Piece.Color <> self.Color then   // Si cette pièce est de la couleur opposée
            possibleMoves.Add(ChessForm.Board[i]);      
      end;                  // On ajoute la cellule en tant que déplacement possible
    end;
    
    procedure TChessPiece.Move(CellTag : Integer);
    begin
      self.cell.Piece := nil;
      self.cell := ChessForm.Board[CellTag];
      self.cell.Piece := self;
      self.Left := self.cell.Left + (self.cell.Width - self.Width) div 2;
      self.Top := self.cell.Top + (self.cell.Height - self.Height) div 2;
    end;
    
  {$ENDREGION}
  
  {$REGION 'TChessPawn Methods'}
    { TChessPawn }
    
    constructor TChessPawn.Create(Owner : TComponent; Color : TColor); 
    begin
      inherited Create(Owner, Color);
      if Color = clWhite then
        self.Picture.LoadFromFile('./img/Pieces/White/WPawn.png')
      else if Color = clBlack then
        self.Picture.LoadFromFile('./img/Pieces/Black/BPawn.png');
    end;
    
    function TChessPawn.GetPossibleMoves(Board : TChessBoard) : TList<TChessCell>;
    var
      _possibleMoves : TList<TChessCell>;
      _direction : Integer;
      i : Integer;
    begin
      _possibleMoves := TList<TChessCell>.Create;
      try
        if self.Color = clWhite then
          _direction := -1
        else if self.Color = clBlack then
          _direction := 1;

        if self.Cell.Tag + 8 <= 0 then
        begin
          if Board[self.Cell.Tag + 8 * _direction].piece = nil then
            _possibleMoves.Add(Board[self.Cell.Tag + 8 * _direction]);

          if (self.Cell.Tag mod 8) < 7 then
          begin
            if Board[self.Cell.Tag + 8 * _direction + 1].piece <> nil then
              if Board[self.Cell.Tag + 8 * _direction + 1].piece.Color <> self.Color then
                _possibleMoves.Add(Board[self.Cell.Tag + 8 * _direction + 1]);
          end;

          if (self.Cell.Tag mod 8) > 0 then
          begin
            if Board[self.Cell.Tag + 8 * _direction - 1].piece <> nil then
              if Board[self.Cell.Tag + 8 * _direction - 1].piece.Color <> self.Color then
                _possibleMoves.Add(Board[self.Cell.Tag + 8 * _direction - 1]);
          end;
        end;
      
        Result := _possibleMoves;
      finally
        _possibleMoves.Free;
      end;
    end;
    
  {$ENDREGION}
  
  {$REGION 'TChessRook Methods'}
    { TChessRook }
  
    constructor TChessRook.Create(Owner : TComponent; Color : TColor);
    begin
      inherited Create(Owner, Color);
      if Color = clWhite then
        self.Picture.LoadFromFile('./img/Pieces/White/WRook.png')
      else if Color = clBlack then
        self.Picture.LoadFromFile('./img/Pieces/Black/BRook.png');
    end;
  
  
    function TChessRook.GetPossibleMoves(Board : TChessBoard) : TList<TChessCell>;
    var
      _possibleMoves : TList<TChessCell>;
    begin
      _possibleMoves := TList<TChessCell>.Create;
      try
        // Check en ligne vers le Haut
        CheckPossibleMovesOnStraightLine(_possibleMoves, self.Cell.Tag, -8, self.Cell.Tag mod 8);
          // Décrémentation de 8 entre chaque case pour atteindre celle juste au dessus
          // Dernière case à vérifier = Première Case de la première ligne (0) + colonne de la pièce
    
        // Check en ligne vers le Bas
        CheckPossibleMovesOnStraightLine(_possibleMoves, self.Cell.Tag, 8, 56 + self.Cell.Tag mod 8 );
          // Incrémentation de 8 entre chaque case pour atteindre celle juste en dessous
          // Dernière case à vérifier = Première Case de la dernière ligne (56) + colonne de la pièce
    
        // Check en ligne vers la Gauche
        CheckPossibleMovesOnStraightLine(_possibleMoves, self.Cell.Tag, -1, (self.Cell.Tag div 8) * 8 );
          // Décrémentation de 1 entre chaque case pour atteindre celle juste à gauche
          // Dernière case à vérifier = Numéro (de 0 à 7) de la ligne * nombre de cases dans une ligne
    
        // Check en ligne vers la Droite
        CheckPossibleMovesOnStraightLine(_possibleMoves, self.Cell.Tag, 1, ((self.Cell.Tag div 8) + 1) * 8 - 1 );
          // Décrémentation de 1 entre chaque case pour atteindre celle juste à gauche
          // Dernière case à vérifier = Numéro (de 0 à 7) de la ligne du dessous * nombre de cases dans une ligne - 1

        Result := _possibleMoves;
      finally
        _possibleMoves.Free;
      end;
    end;
  
  {$ENDREGION}
  

  {$REGION 'TChessKnight Methods'}
    { TChessRook }
  
    constructor TChessKnight.Create(Owner : TComponent; Color : TColor);
    begin
      inherited Create(Owner, Color);
      if Color = clWhite then
        self.Picture.LoadFromFile('./img/Pieces/White/WKnight.png')
      else if Color = clBlack then
        self.Picture.LoadFromFile('./img/Pieces/Black/BKnight.png');
    end;
  
  
    function TChessKnight.GetPossibleMoves(Board : TChessBoard) : TList<TChessCell>;
    var
      _possibleMoves : TList<TChessCell>;
      i : Integer;
    begin
      _possibleMoves := TList<TChessCell>.Create;
      try
        //
        Result := _possibleMoves;
      finally
        _possibleMoves.Free;
      end;
    end;
  
  {$ENDREGION}

  {$REGION 'TChessBishop Methods'}
    { TChessBishop }
  
    constructor TChessBishop.Create(Owner : TComponent; Color : TColor);
    begin
      inherited Create(Owner, Color);
      if Color = clWhite then
        self.Picture.LoadFromFile('./img/Pieces/White/WBishop.png')
      else if Color = clBlack then
        self.Picture.LoadFromFile('./img/Pieces/Black/BBishop.png');
    end;
  
  
    function TChessBishop.GetPossibleMoves(Board : TChessBoard) : TList<TChessCell>;
    var
      _possibleMoves : TList<TChessCell>;
      i : Integer;
    begin
      _possibleMoves := TList<TChessCell>.Create;
      try
        //
        Result := _possibleMoves;
      finally
        _possibleMoves.Free;
      end;
    end;
  
  {$ENDREGION}

  {$REGION 'TChessKing Methods'}
    { TChessKing }
  
    constructor TChessKing.Create(Owner : TComponent; Color : TColor);
    begin
      inherited Create(Owner, Color);
      if Color = clWhite then
        self.Picture.LoadFromFile('./img/Pieces/White/WKing.png')
      else if Color = clBlack then
        self.Picture.LoadFromFile('./img/Pieces/Black/BKing.png');
    end;
  
  
    function TChessKing.GetPossibleMoves(Board : TChessBoard) : TList<TChessCell>;
    var
      _possibleMoves : TList<TChessCell>;
      i : Integer;
    begin
      _possibleMoves := TList<TChessCell>.Create;
      try
        //
        Result := _possibleMoves;
      finally
        _possibleMoves.Free;
      end;
    end;
  
  {$ENDREGION}

  {$REGION 'TChessQueen Methods'}
    { TChessQueen }
  
    constructor TChessQueen.Create(Owner : TComponent; Color : TColor);
    begin
      inherited Create(Owner, Color);
      if Color = clWhite then
        self.Picture.LoadFromFile('./img/Pieces/White/WQueen.png')
      else if Color = clBlack then
        self.Picture.LoadFromFile('./img/Pieces/Black/BQueen.png');
    end;
  
  
    function TChessQueen.GetPossibleMoves(Board : TChessBoard) : TList<TChessCell>;
    var
      _possibleMoves : TList<TChessCell>;
      i : Integer;
    begin
      _possibleMoves := TList<TChessCell>.Create;
      try
        //
        Result := _possibleMoves;
      finally
        _possibleMoves.Free;
      end;
    end;
  
  {$ENDREGION}

  {$REGION 'TChessPlayer Methods'}
    { TChessPlayer }

    constructor TChessPlayer.Create(Owner : TComponent; Color : TColor; Name : String);
    var
      i : Integer;
    begin
      self.fColor := Color;
      self.fName := Name;
      self.fProfilePicture := TImage.Create(ChessForm);
      if Color = clWhite then
        self.fProfilePicture.Picture.LoadFromFile('./img/Pieces/White/WKing.png')
      else if Color = clBlack then
        self.fProfilePicture.Picture.LoadFromFile('./img/Pieces/Black/BKing.png');

      fPawns := TList<TChessPawn>.Create;
      for i := 0 to 7 do
      begin
        fPawns.Add(TChessPawn.Create(TComponent(Self), Color));
        fPawns[i].Left := 54 + i * 96;
        if Color = clWhite then
          fPawns[i].Top := 630
        else if Color = clBlack then
          fPawns[i].Top := 150;
      end;

      fRooks := TList<TChessRook>.Create;
      fRooks.Add(TChessRook.Create(TComponent(Self), Color));
      fRooks.Add(TChessRook.Create(TComponent(Self), Color));
      fRooks[0].Left := 54;
      fRooks[0].Top := 726;
      fRooks[1].Left := 726;
      fRooks[1].Top := 726;

      fKnights := TList<TChessKnight>.Create;
      fKnights.Add(TChessKnight.Create(TComponent(Self), Color));
      fKnights.Add(TChessKnight.Create(TComponent(Self), Color));
      fKnights[0].Left := 150;
      if Color = clWhite then
      begin;
        fKnights[0].Top := 726;
        fKnights[1].Top := 726;
      end
      else if Color = clBlack then
      begin
        fKnights[0].Top := 54;
        fKnights[1].Top := 54;
      end;
      fKnights[0].Top := 726;
      fKnights[1].Left := 630;
      fKnights[1].Top := 726;
      fBishops := TList<TChessBishop>.Create;
      fBishops.Add(TChessBishop.Create(TComponent(Self), Color));
      fBishops.Add(TChessBishop.Create(TComponent(Self), Color));
      fBishops[0].Left := 54 + 96;
      fBishops[0].Top := 726;
      fBishops[1].Left := 726 + 96;
      fBishops[1].Top := 726;
      fQueens := TList<TChessQueen>.Create;
      fQueens.Add(TChessQueen.Create(TComponent(Self), Color));
      fKing := TChessKing.Create(TComponent(Self), Color);
    end;
  {$ENDREGION}

  {$REGION 'TChessForm Methods'}
    { TChessForm }
    
    constructor TChessForm.Create(Owner : TComponent);
    begin
      inherited Create(Owner);
      Left := 0;
      Top := 0;
      Caption := 'Chess Game - By LejusVDP';
      ClientHeight := 864;
      ClientWidth := 864;
      Color := 64;
      Font.Charset := DEFAULT_CHARSET;
      Font.Color := clWindowText;
      Font.Height := -11;
      Font.Name := 'Tahoma';
      Font.Style := [];
      OldCreateOrder := False;
      OnCreate := GenerateBoard;
      PixelsPerInch := 64;
    end;
    
    procedure TChessForm.DestroyBoard(Sender: TObject);
    var
      i : Integer;
    begin
      for i := 0 to Player1.Queens.Count - 1 do
        Player1.Queens[i].Free;
      Player1.Queens.Free;
      for i := 0 to Player1.Bishops.Count - 1 do
        Player1.Bishops[i].Free;
      Player1.Bishops.Free;
      for i := 0 to Player1.Rooks.Count - 1 do
        Player1.Rooks[i].Free;
      Player1.Rooks.Free;
      for i := 0 to Player1.Knights.Count - 1 do
        Player1.Knights[i].Free;
      Player1.Knights.Free;
      for i := 0 to Player1.Pawns.Count - 1 do
        Player1.Pawns[i].Free;
      Player1.Pawns.Free;
      Player1.King.Free;
      for i := 0 to Player2.Queens.Count - 1 do
        Player2.Queens[i].Free;
      Player2.Queens.Free;
      for i := 0 to Player2.Bishops.Count - 1 do
        Player2.Bishops[i].Free;
      Player2.Bishops.Free;
      for i := 0 to Player2.Rooks.Count - 1 do
        Player2.Rooks[i].Free;
      Player2.Rooks.Free;
      for i := 0 to Player2.Knights.Count - 1 do
        Player2.Knights[i].Free;
      Player2.Knights.Free;
      for i := 0 to Player2.Pawns.Count - 1 do
        Player2.Pawns[i].Free;
      Player2.Pawns.Free;
      for i := 0 to 63 do
        fBoard[i].Free;
    end;
    
    procedure TChessForm.GenerateBoard(Sender: TObject);
    var
      _isWhite : Boolean;
    begin
      fLblCellIndicator:= TLabel.Create(Self);
      fLblCellIndicator.Parent := Self;
      fLblCellIndicator.Left := 0;
      fLblCellIndicator.Top := 0;
      fLblCellIndicator.Width := 4;
      fLblCellIndicator.Height := 16;
      fLblCellIndicator.Font.Charset := DEFAULT_CHARSET;
      fLblCellIndicator.Font.Color := clWhite;
      fLblCellIndicator.Font.Height := -15;
      fLblCellIndicator.Font.Name := 'Tahoma';
      fLblCellIndicator.Font.Style := [];
      fLblCellIndicator.ParentFont := False;
    
      _isWhite := True;
      for var index := 0 to 63 do
      begin
        self.fBoard[index] := TChessCell.Create(self);
        self.fBoard[index].Parent := self;
        self.fBoard[index].Left := 48 + (index mod 8) * 96;
        self.fBoard[index].Top := 48 + (index div 8) * 96;
        self.fBoard[index].Tag := index;
        if _isWhite then
          self.fBoard[index].Brush.Color := RGB(210, 206, 176)
        else
          self.fBoard[index].Brush.Color := RGB(160, 137, 65);
        _isWhite := not _isWhite;
        if index mod 8 = 7 then
          _isWhite := not _isWhite;
      end;
    
      fLblCellIndicator.Caption := IntToStr(fBoard[0].Height);
    
      fBoardOutline := TShape.Create(self);
      fBoardOutline.Parent := self;
      fBoardOutline.Left := 45;
      fBoardOutline.Top := 45;
      fBoardOutline.Width := 774;
      fBoardOutline.Height := 774;
      fBoardOutline.Shape := stRectangle;
      fBoardOutline.Brush.Style := bsClear;
      fBoardOutline.Pen.Color := RGB(66, 29, 0);
      fBoardOutline.Pen.Width := 3;

      // Create the players
      Self.fPlayer1 := TChessPlayer.Create(self, clWhite, 'Player 1');
      Self.fPlayer1 := TChessPlayer.Create(self, clBlack, 'Player 2');
      Self.fPlayer1.ProfilePicture.Left := 8;
      Self.fPlayer1.ProfilePicture.Top := 8;
      Self.fplayer2.ProfilePicture.Left := 864 - 8 - fPlayer2.ProfilePicture.Width;
      Self.fPlayer2.ProfilePicture.Left := 864 - 8 - fPlayer2.ProfilePicture.Height;
      Self.fPlayer1.ProfilePicture.Parent := self;
      Self.fPlayer2.ProfilePicture.Parent := self;
    end;

  {$ENDREGION}
{$ENDREGION}

end.
