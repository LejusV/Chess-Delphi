//// Projet "Chess" Réalisé par Jules Vandeputte Alias LejusVDP et Alexandre Teixeira dans le cadre du cours de Production d'Applications de DUT
//// Je suis désolé de la longueur du fichier (Vive la balise $REGION), j'ai essayé au maximum de regrouper le code répété en une méthode appelée et de combiner des tests logiques plutôt que de les découper en 6 if else
//// La fonction du Pion fonctionnant en prenant en compte la Direction de celui-ci aurait été 2 fois plus longue sans la variable _direction qui évite les tests de la couleur du pion et permet un calcul global.
//// Bonne Lecture et bon jeu !
//// Jules V. & Alexandre T.

unit Chess;

interface

{$REGION 'Used Units'}
  uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.Generics.Collections, System.Math, Vcl.Graphics,
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
      public
  
      public
        { D�clarations publiques }
        property Piece : TChessPiece read fPiece write fPiece;
        procedure CellCoordsDisplay(Sender: TObject); // Ne marche pas très bien (censée être appelée par l'événement OnMouseEnter)       
        constructor Create(Owner : TComponent); override; // Constructeur
        procedure DoOnClick(Sender : TObject); // OnClick : vérifie si la cellule fait partie des mouvements possible d'une
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
      fPossibleMoves : TList<TChessCell>; // Liste des cases de déplacement possible
      procedure CheckPossibleMovesOnStraightLine(possibleMoves : TList<TChessCell>; cellTag : Integer; tagDiff2Cells : Integer; tagLastCell : Integer);
        // Vérifie les mouvements possibles selon un paramètre saut de tag entre 2 cellules consécutives à check
    public
      { Déclarations publiques }
      property Cell : TChessCell read fCell write fCell; // Accesseur de la cellule de la pièce
      property Color : TColor read fColor; // Accesseur de la couleur de la pièce
      property IsFocused : Boolean read fIsFocused write fIsFocused; // Accesseur de l'état de la pièce
      property PossibleMoves : TList<TChessCell> read fPossibleMoves; // Accesseur de la liste des cases de déplacement possible

      procedure Select; // Sélectionne la pièce
      procedure Unselect; // Désélectionne la pièce
      procedure DoOnClick(Sender: TObject);
      constructor Create(Owner : TComponent; Color : TColor); // Constructeur Personalisé appelant le constructeur Create(Owner : TComponent)
      procedure GetPossibleMoves(Board : TChessBoard; PossibleMoves : TList<TChessCell>); virtual; abstract;// Retourne la liste des cellules de déplacement possibles pour la pièce
      procedure Move(CellTag : Integer); virtual; // Déplacement de la pièce
    end;
  {$ENDREGION}
  
  {$REGION 'TChessPawn Class'}
    // Classe Pion
    TChessPawn = class(TChessPiece)
    strict private
    public
      { Déclarations publiques }
      constructor Create(Owner : TComponent; Color : TColor); // Constructeur
      procedure GetPossibleMoves(Board : TChessBoard; PossibleMoves : TList<TChessCell>); override; // Retourne la liste des cellules de déplacement possibles pour la pièce
      procedure Move(CellTag : Integer); override; // Déplacement de la pièce
    end;
  {$ENDREGION}

  {$REGION 'TChessRook Class'}
    // Classe Pion
    TChessRook = class(TChessPiece)
    strict private
    public
      { Déclarations publiques }
      constructor Create(Owner : TComponent; Color: TColor); // Constructeur
      procedure GetPossibleMoves(Board : TChessBoard; PossibleMoves : TList<TChessCell>); override; // Retourne la liste des cellules de déplacement possibles pour la pièce
    end;
  {$ENDREGION}

  {$REGION 'TChessKnight Class'}
    // Classe Pion
    TChessKnight = class(TChessPiece)
    strict private
    public
      { Déclarations publiques }
      constructor Create(Owner : TComponent; Color: TColor); // Constructeur
      procedure GetPossibleMoves(Board : TChessBoard; PossibleMoves : TList<TChessCell>); override; // Retourne la liste des cellules de déplacement possibles pour la pièce
    end;
  {$ENDREGION}

  {$REGION 'TChessBishop Class'}
    // Classe Pion
    TChessBishop = class(TChessPiece)
    strict private
    public
      { Déclarations publiques }
      constructor Create(Owner : TComponent; Color: TColor); // Constructeur
      procedure GetPossibleMoves(Board : TChessBoard; PossibleMoves : TList<TChessCell>); override; // Retourne la liste des cellules de déplacement possibles pour la pièce
    end;
  {$ENDREGION}
  
  {$REGION 'TChessKing Class'}
    // Classe Pion
    TChessKing = class(TChessPiece)
    strict private
    public
      { Déclarations publiques }
      constructor Create(Owner : TComponent; Color: TColor); // Constructeur
      procedure GetPossibleMoves(Board : TChessBoard; PossibleMoves : TList<TChessCell>); override; // Retourne la liste des cellules de déplacement possibles pour la pièce
    end;
  {$ENDREGION}

  
  {$REGION 'TChessQueen Class'}
    // Classe Pion
    TChessQueen = class(TChessPiece)
    strict private
    public
      { Déclarations publiques }
      constructor Create(Owner : TComponent; Color: TColor); // Constructeur
      procedure GetPossibleMoves(Board : TChessBoard; PossibleMoves : TList<TChessCell>); override; // Retourne la liste des cellules de déplacement possibles pour la pièce
    end;
  {$ENDREGION}

  {$REGION 'TChessPlayer Class'}
    TChessPlayer = class
    strict private
      fBishops : TList<TChessBishop>;
      fColor : TColor;
      fIsTurn : Boolean;
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
      function IsKingChecked(Opponent : TChessPlayer): Boolean;
      property Bishops : TList<TChessBishop> read fBishops;
      property Color : TColor read fColor;
      property IsTurn : Boolean read fIsTurn write fIsTurn;
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
      function GetPlayerByColor(Color : TColor) : TChessPlayer; // Getter du joueur par la couleur de ses pions
    strict private
      { D�clarations priv�es }
      fLblCellIndicator: TLabel; // TLabel pour le nom du joueur dont c'est le tour (et l'échec de son Roi)
      fBoard: TChessBoard; // Plateau de jeu
      fBoardOutline: TShape; // Contour du plateau
      fFocusedPiece : TChessPiece; // Pièce sélectionnée (peut être nulle)
      fPlayer1, fPlayer2 : TChessPlayer; // Les 2 Joueurs
    public
      { D�clarations publiques }
      property Board: TChessBoard read fBoard ; // Accès au plateau de jeu
      property CellIndicator : TLabel read fLblCellIndicator; // Accès au label indiquant les coordonnées de la cellule sélectionnée
      property FocusedPiece : TChessPiece read fFocusedPiece write fFocusedPiece;
      property Player1 : TChessPlayer read fPlayer1; // Joueur 1
      property Player2 : TChessPlayer read fPlayer2; // Joueur 2
      constructor Create(Owner : TComponent); override; // Constructeur
      procedure GameOver(Winner : TChessPlayer); // Fonction de fin de partie
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
    
    procedure TChessCell.CellCoordsDisplay(Sender: TObject);
    begin
      ChessForm.CellIndicator.Caption := Char(Ord('A') + (Self.Tag) mod 8) + IntToStr(8 - (Self.Tag) div 8);
    end;
    
    constructor TChessCell.Create(Owner : TComponent);
    begin
      inherited Create(Owner);
      Self.Width := 64;
      Self.Height := 64;
      Self.Shape := stRectangle;
      Self.Pen.Color := RGB(66, 31, 0);
      //OnMouseEnter := CellCoordsDisplay;
      Self.OnClick := DoOnClick;
    end;

    procedure TChessCell.DoOnClick(Sender : TObject);
    begin
      if ChessForm.FocusedPiece <> nil then
      begin
        if ChessForm.FocusedPiece.PossibleMoves.Contains(Self) then
        begin
          ChessForm.FocusedPiece.Move(Self.Tag);
          ChessForm.FocusedPiece.DoOnClick(ChessForm.FocusedPiece);
          ChessForm.FocusedPiece := nil;
        end
        else
        begin
          ChessForm.FocusedPiece.Unselect;
        end;
      end;
    end;
    
  {$ENDREGION}
  
  {$REGION 'TChessPiece Methods'}
    { TChessPiece }

    // Selectionne la pièce appelante
    procedure TChessPiece.Select;
    var
      i : Integer;
    begin

      Self.fPossibleMoves := TList<TChessCell>.Create;
      // Recherche et insertion des cellules de déplacement possibles dans la liste
      Self.GetPossibleMoves(ChessForm.Board, Self.fPossibleMoves);
      // Vérification de la création de la liste
      if Self.fPossibleMoves <> nil then
      begin
        for i := 0 to Self.fPossibleMoves.Count - 1 do
        begin
          // Aspect visuel des cellules de mouvements possibles
          Self.fPossibleMoves[i].Brush.Style := bsDiagCross;
        end;
      end;
      // Modification des variables indiquant quelle pièce est sélectionnée
      ChessForm.FocusedPiece := Self;
      Self.fIsFocused := True;
    end;

    // Déselectionne la pièce appelante
    procedure TChessPiece.Unselect;
    var
      i : Integer;
    begin
      if Self.fPossibleMoves <> nil then
      begin
        for i := 0 to Self.fPossibleMoves.Count - 1 do
        begin
          Self.fPossibleMoves[i].Brush.Style := bsSolid;
        end;
        Self.fPossibleMoves.Free;
      end;
      ChessForm.FocusedPiece := nil;
      Self.fIsFocused := False;
    end;

    // Au clic sur une pièce, choisit l'opération à effectuer selon le contexte
    procedure TChessPiece.DoOnClick(Sender: TObject);
    begin
      // Si la pièce cliquée n'est pas sélectionnée
      if Self.fIsFocused = False then 
      begin
        // Si une pièce est sélectionnée
        if ChessForm.FocusedPiece <> nil then
        begin
          // Si la pièce cliquée est sur une cellule de déplacement possible de la pièce sélectionnée
          if ChessForm.FocusedPiece.PossibleMoves.Contains(Self.Cell)
            // Simple assurance qu'une pièce ne peut pas manger une pièce de sa propre couleur
            // Même si ça ne devrait pas arriver au vu des vérifs de GetPossibleMoves
            and (ChessForm.FocusedPiece.Color <> Self.fColor) then
          begin
            // Déplacement de la pièce sélectionnée sur la cellule cliquée (et Free de la pièce cliquée gérée par la Méthode move)
            // Qui sera à terme complété par un affichage des pièces prises
            ChessForm.FocusedPiece.Move(Self.Cell.Tag);
            ChessForm.FocusedPiece.Unselect;
          end
          else
          begin
            ChessForm.FocusedPiece.Unselect;
            // Si la pièce cliquée est de la couleur du joueur dont c'est le tour
            if ChessForm.GetPlayerByColor(Self.fColor).IsTurn = True then
              Self.Select;
          end;
        end
        // Sinon (Si aucune pièce n'est sélectionnée)
        else
        begin
          // Si la pièce cliquée est de la couleur du joueur dont c'est le tour
          if ChessForm.GetPlayerByColor(Self.fColor).IsTurn = True then
            Self.Select;
        end;
      end
      else
        Self.Unselect;
    end;

    // Constructeur de la classe TChessPiece
    constructor TChessPiece.Create(Owner : TComponent; Color : TColor);
    begin
      inherited Create(Owner);
      Self.Width := 60;
      Self.Height := 60;
      Self.fIsFocused := False;
      Self.Parent := ChessForm;
      Self.OnClick := DoOnClick;
      Self.fColor := Color;
      Self.Proportional := True;
      Self.Center := True;
    end; 
    
    // Vérifie les mouvements possibles sur un pattern régulier
    // (in/dé.crémentation de i par un nombre constant en paramètre tagDiff2Cells)
    procedure TChessPiece.CheckPossibleMovesOnStraightLine(
      possibleMoves : TList<TChessCell>;
      cellTag : Integer;
      tagDiff2Cells : Integer;
      tagLastCell : Integer
    );
    var
      i : Integer;
    begin
      // On commence à la première cellule de la ligne juste après la cellule de départ
      i := cellTag + tagDiff2Cells;
      if possibleMoves <> nil then
      begin
        // Tant que la cellule n'est pas vide ni hors du plateau
        while
          // Tant que i ne dépasse pas le tag de la dernière cellule (selon le sens du déplacement)
          (((tagLastCell > cellTag) and (i <= tagLastCell)) or ((tagLastCell < cellTag) and (i >= tagLastCell)))
                                                                                                          
          // Et que la case n'est pas occupée
          and (ChessForm.Board[i].Piece = nil) do
        begin
          // On ajoute la case correspondante à la liste des déplacements possibles
          possibleMoves.Add(ChessForm.Board[i]);
          // Et on passe à la suivante
          i := i + tagDiff2Cells;
        end;

        // Si l'arrêt de la boucle est dû à la présence d'une pièce
        // (la boucle s'est arrêtée avant la fin du plateau peut importe le côté)
        if ((tagLastCell > cellTag) and (i <= tagLastCell))         // Cas où i est décrémenté
          or ((tagLastCell < cellTag) and (i >= tagLastCell)) then  // Cas où i est incrémenté
        begin
          // Si cette pièce est de la couleur opposée  
          if ChessForm.Board[i].Piece.Color <> Self.fColor then
            // On ajoute la cellule en tant que déplacement possible
            possibleMoves.Add(ChessForm.Board[i]);
        end;
      end;
    end;
    
    procedure TChessPiece.Move(CellTag : Integer);
    begin
      Self.Cell.Piece := nil;
      Self.Cell := ChessForm.Board[CellTag];
      if (ChessForm.Board[CellTag].Piece <> nil) and (Self.Cell.Piece <> Self) then
      begin
        if ChessForm.Board[CellTag].Piece = ChessForm.Player1.King then
        begin
          ChessForm.GameOver(ChessForm.Player2);
          Exit;
        end
        else if  ChessForm.Board[CellTag].Piece = ChessForm.Player2.King then
        begin
          ChessForm.GameOver(ChessForm.Player1);
          Exit;
        end;
        ChessForm.Board[CellTag].Piece.Free;
      end;
      Self.Cell.Piece := Self;
      Self.Left := Self.cell.Left + (Self.cell.Width - Self.Width) div 2;
      Self.Top := Self.cell.Top + (Self.cell.Height - Self.Height) div 2;
      if Self.fColor = clWhite then
      begin
        ChessForm.Player1.IsTurn := False;
        ChessForm.Player2.IsTurn := True;
        // Si le joueur 2 est en échec
        if ChessForm.Player2.IsKingChecked(ChessForm.Player1) then
        begin
          ChessForm.CellIndicator.Caption := 'Player 2 (Checked)';
          ChessForm.CellIndicator.Font.Color := clRed;
          ChessForm.CellIndicator.Left := ChessForm.Width - 168;
          ChessForm.CellIndicator.Top := 2;
        end
        else
        begin
          ChessForm.CellIndicator.Caption := 'Player 2';
          ChessForm.CellIndicator.Font.Color := clWhite;
          ChessForm.CellIndicator.Left := ChessForm.Width - 84;
          ChessForm.CellIndicator.Top := 2;
        end;
      end
      else if Self.fColor = clBlack then
      begin
        ChessForm.Player1.IsTurn := True;
        ChessForm.Player2.IsTurn := False;
        ChessForm.CellIndicator.Caption := 'Player 1';
        ChessForm.CellIndicator.Font.Color := clWhite;
        ChessForm.CellIndicator.Left := 2;
        ChessForm.CellIndicator.Top := ChessForm.ClientHeight - ChessForm.CellIndicator.Height - 2;
        // Si le roi du joueur 1 est en échec
        if ChessForm.Player1.IsKingChecked(ChessForm.Player2) then
        begin
          ChessForm.CellIndicator.Caption := 'Player 1 (Checked)';
          ChessForm.CellIndicator.Color := clRed;
        end;
      end
      else
        raise Exception.Create('Erreur : Couleur de la pièce non définie');
    end;
    
  {$ENDREGION}
  
  {$REGION 'TChessPawn Methods'}
    { TChessPawn }
    
    constructor TChessPawn.Create(Owner : TComponent; Color : TColor); 
    begin
      inherited Create(Owner, Color);
      if Color = clWhite then
        Self.Picture.LoadFromFile('../../img/Pieces/White/WPawn.png')
      else if Color = clBlack then
        Self.Picture.LoadFromFile('../../img/Pieces/Black/BPawn.png');
    end;
    
    procedure TChessPawn.GetPossibleMoves(Board : TChessBoard; PossibleMoves : TList<TChessCell>);
    var
      _direction : Integer;
    begin
      _direction := 0;
      if PossibleMoves <> nil then
      begin
        if Self.fColor = clWhite then
          _direction := -1
        else if Self.fColor = clBlack then
          _direction := 1;
        
        // Si le pion n'est pas arrivé au bout du plateau (selon sa direction)
        if (Self.Cell.Tag + 8 * _direction >= 0) and (Self.Cell.Tag + 8 * _direction <= 63) then
        begin
          // S'il n'y a pas de pièce devant lui (toujours selon sa direction)
          if Board[Self.Cell.Tag + 8 * _direction].piece = nil then
          begin
            // Il peut se déplacer d'une case vers l'avant
            PossibleMoves.Add(Board[Self.Cell.Tag + 8 * _direction]);

            if (((Self.Cell.Tag + _direction * 16) div 8 = 3) and (_direction = 1)) or (((Self.Cell.Tag + _direction * 16) div 8 = 4) and (_direction = -1)) then
              PossibleMoves.Add(ChessForm.Board[Self.Cell.Tag + _direction * 16]);
          end;

          // Si le pion n'est pas sur la colonne toute à droite
          if (Self.Cell.Tag mod 8) < 7 then
          begin
            // Si une pièce est sur la case devant à droite ('devant' variant selon la direction)
            if Board[Self.Cell.Tag + 8 * _direction + 1].piece <> nil then
            begin
              // Si cette pièce est de la couleur opposée
              if Board[Self.Cell.Tag + 8 * _direction + 1].piece.Color <> Self.fColor then
                // Il peut manger cette pièce
                PossibleMoves.Add(Board[Self.Cell.Tag + 8 * _direction + 1]);
            end;

          end;

          // Si le pion n'est pas sur la colonne toute à gauche
          if (Self.Cell.Tag mod 8) > 0 then
          begin
            // Si une pièce est sur la case devant à gauche ('devant' variant selon la direction)
            if Board[Self.Cell.Tag + 8 * _direction - 1].piece <> nil then
              // Si cette pièce est de la couleur opposée
              if Board[Self.Cell.Tag + 8 * _direction - 1].piece.Color <> Self.fColor then
                // Il peut manger cette pièce
                PossibleMoves.Add(Board[Self.Cell.Tag + 8 * _direction - 1]);
          end;
        end;
      end
      else
        Exception.Create('TChessPawn: PossibleMoves is nil');
    end;

    // Méthode overrite Move pour le Pion qui rajoute un test de promotion en Dame à la méthode parente
    procedure TChessPawn.Move(CellTag : Integer);
    var
      _newQueen : TChessQueen;
    begin
      // On appelle le code parent qu'on ne modifie pas
      inherited Move(CellTag);
      // Si le pion est arrivé au bout du plateau (selon sa couleur)
      if (Self.fColor = clWhite) then
      begin
        if (Self.Cell.Tag div 8 = 0) then
        begin
          _newQueen := TChessQueen.Create(ChessForm, clWhite); // Création d'une nouvelle Dame
          _newQueen.Cell := ChessForm.Board[CellTag]; // On lui affecte la case du pion
          ChessForm.Board[CellTag].Piece := _newQueen; // On affecte la Dame à la case
          // Alignement visuel
          ChessForm.Board[CellTag].Piece.Left := ChessForm.Board[CellTag].Left + 3;
          ChessForm.Board[CellTag].Piece.Top := ChessForm.Board[CellTag].Top + 3;
          ChessForm.Player1.Queens.Add(_newQueen); // Ajout à la liste des Dames du joueur 1
          Self.Free; // On détruit le pion
        end;
      end
      else if (Self.fColor = clBlack) then
      begin
        if (Self.Cell.Tag div 8 = 7) then
        begin
          _newQueen := TChessQueen.Create(ChessForm, clBlack);
          _newQueen.Cell := ChessForm.Board[CellTag];
          ChessForm.Board[CellTag].Piece := _newQueen;
          ChessForm.Board[CellTag].Piece.Left := ChessForm.Board[CellTag].Left + 3;
          ChessForm.Board[CellTag].Piece.Top := ChessForm.Board[CellTag].Top + 3;
          ChessForm.Player2.Queens.Add(_newQueen);
          Self.Free;
        end;
      end;
    end;
    
  {$ENDREGION}
  
  {$REGION 'TChessRook Methods'}
    { TChessRook }
    // Constructeur de la classe TChessRook (Tour)
    constructor TChessRook.Create(Owner : TComponent; Color : TColor);
    begin
      inherited Create(Owner, Color);
      if Color = clWhite then
        Self.Picture.LoadFromFile('../../img/Pieces/White/WRook.png')
      else if Color = clBlack then
        Self.Picture.LoadFromFile('../../img/Pieces/Black/BRook.png');
    end;
  
    // Méthode overrite GetPossibleMoves pour la Tour qui vérifie les cases dans 4 directions (haut, bas, gauche, droite)
    procedure TChessRook.GetPossibleMoves(Board : TChessBoard; PossibleMoves : TList<TChessCell>);
    begin
      if PossibleMoves <> nil then
      begin
        // Check en ligne vers le Haut
        CheckPossibleMovesOnStraightLine(PossibleMoves, Self.Cell.Tag, -8, Self.Cell.Tag mod 8);
          // Décrémentation de 8 entre chaque case pour atteindre celle juste au dessus
          // Dernière case à vérifier = Première Case de la première ligne (0) + colonne de la pièce
    
        // Check en ligne vers le Bas
        CheckPossibleMovesOnStraightLine(PossibleMoves, Self.Cell.Tag, 8, 56 + Self.Cell.Tag mod 8 );
          // Incrémentation de 8 entre chaque case pour atteindre celle juste en dessous
          // Dernière case à vérifier = Première Case de la dernière ligne (56) + colonne de la pièce
    
        // Check en ligne vers la Gauche
        CheckPossibleMovesOnStraightLine(PossibleMoves, Self.Cell.Tag, -1, (Self.Cell.Tag div 8) * 8 );
          // Décrémentation de 1 entre chaque case pour atteindre celle juste à gauche
          // Dernière case à vérifier = Numéro (de 0 à 7) de la ligne * nombre de cases dans une ligne
    
        // Check en ligne vers la Droite
        CheckPossibleMovesOnStraightLine(PossibleMoves, Self.Cell.Tag, 1, ((Self.Cell.Tag div 8) + 1) * 8 - 1 );
          // Décrémentation de 1 entre chaque case pour atteindre celle juste à gauche
          // Dernière case à vérifier = Numéro (de 0 à 7) de la ligne du dessous * nombre de cases dans une ligne - 1
      end
      else
        Exception.Create('TChessRook: PossibleMoves is nil');
    end;
  
  {$ENDREGION}
  
  {$REGION 'TChessKnight Methods'}
    { TChessRook }
    // Constructeur de la classe TChessKnight (Cavalier)
    constructor TChessKnight.Create(Owner : TComponent; Color : TColor);
    begin
      inherited Create(Owner, Color);
      if Color = clWhite then
        Self.Picture.LoadFromFile('../../img/Pieces/White/WKnight.png')
      else if Color = clBlack then
        Self.Picture.LoadFromFile('../../img/Pieces/Black/BKnight.png');
    end;
  
    // Méthode overrite GetPossibleMoves pour le Cavalier qui vérifie les cases à une distance de 2 sur un axe et 1 sur l'autre
    procedure TChessKnight.GetPossibleMoves(Board : TChessBoard; PossibleMoves : TList<TChessCell>);
    begin
      if PossibleMoves <> nil then
      begin
        // Check en Col+2 Ligne+1
        if ((Self.Cell.Tag mod 8) < 6) and (Self.Cell.Tag + 8 + 2 < 64) 
          and not ((Board[Self.Cell.Tag + 8 + 2].Piece <> nil) and (Board[Self.Cell.Tag + 8 + 2].Piece.Color = Self.fColor)) then
            PossibleMoves.Add(ChessForm.Board[Self.Cell.Tag + 8 + 2]);
        // Check en Col-2 Ligne+1
        if ((Self.Cell.Tag mod 8) > 1) and (Self.Cell.Tag + 8 - 2 < 64)
          and not ((Board[Self.Cell.Tag + 8 - 2].Piece <> nil) and (Board[Self.Cell.Tag + 8 - 2].Piece.Color = Self.fColor)) then
          PossibleMoves.Add(Board[Self.Cell.Tag + 8 - 2]);
        // Check en Col+2 Ligne-1
        if ((Self.Cell.Tag mod 8) < 6) and (Self.Cell.Tag - 8 + 2 >= 0)
          and not ((Board[Self.Cell.Tag - 8 + 2].Piece <> nil) and (Board[Self.Cell.Tag - 8 + 2].Piece.Color = Self.fColor)) then
          PossibleMoves.Add(Board[Self.Cell.Tag - 8 + 2]);
        // Check en Col-2 Ligne-1
        if ((Self.Cell.Tag mod 8) > 1) and (Self.Cell.Tag - 8 - 2 >= 0)
          and not ((Board[Self.Cell.Tag - 8 - 2].Piece <> nil) and (Board[Self.Cell.Tag - 8 - 2].Piece.Color = Self.fColor)) then
          PossibleMoves.Add(Board[Self.Cell.Tag - 8 - 2]);
        // Check en Col+1 Ligne+2
        if ((Self.Cell.Tag mod 8) < 7) and (Self.Cell.Tag + 16 + 1 < 64)
          and not ((Board[Self.Cell.Tag + 16 + 1].Piece <> nil) and (Board[Self.Cell.Tag + 16 + 1].Piece.Color = Self.fColor)) then
          PossibleMoves.Add(Board[Self.Cell.Tag + 16 + 1]);
        // Check en Col-1 Ligne+2
        if ((Self.Cell.Tag mod 8) > 0) and (Self.Cell.Tag + 16 - 1 < 64)
          and not ((Board[Self.Cell.Tag + 16 - 1].Piece <> nil) and (Board[Self.Cell.Tag + 16 - 1].Piece.Color = Self.fColor)) then
          PossibleMoves.Add(Board[Self.Cell.Tag + 16 - 1]);
        // Check en Col+1 Ligne-2
        if ((Self.Cell.Tag mod 8) < 7) and (Self.Cell.Tag - 16 + 1 >= 0)
          and not ((Board[Self.Cell.Tag - 16 + 1].Piece <> nil) and (Board[Self.Cell.Tag - 16 + 1].Piece.Color = Self.fColor)) then
          PossibleMoves.Add(Board[Self.Cell.Tag - 16 + 1]);
        // Check en Col-1 Ligne-2
        if ((Self.Cell.Tag mod 8) > 0) and (Self.Cell.Tag - 16 - 1 >= 0)
          and not ((Board[Self.Cell.Tag - 16 - 1].Piece <> nil) and (Board[Self.Cell.Tag - 16 - 1].Piece.Color = Self.fColor)) then
          PossibleMoves.Add(Board[Self.Cell.Tag - 16 - 1]);
      end
      else
        Exception.Create('TChessKnight: PossibleMoves is nil');
    end;
  
  {$ENDREGION}

  {$REGION 'TChessBishop Methods'}
    { TChessBishop }
  
    constructor TChessBishop.Create(Owner : TComponent; Color : TColor);
    begin
      inherited Create(Owner, Color);
      if Color = clWhite then
        Self.Picture.LoadFromFile('../../img/Pieces/White/WBishop.png')
      else if Color = clBlack then
        Self.Picture.LoadFromFile('../../img/Pieces/Black/BBishop.png');
    end;
  
  
    procedure TChessBishop.GetPossibleMoves(Board : TChessBoard; PossibleMoves : TList<TChessCell>);
    var
      i : Integer;
    begin
      if PossibleMoves <> nil then
      begin
        // Check en diagonale vers le Haut-Gauche
        i := Self.Cell.Tag;
        while ((i mod 8) <> 0) and ((i div 8) <> 0) do
          i := i - 9;
        CheckPossibleMovesOnStraightLine(PossibleMoves, Self.Cell.Tag, -9, i);
          // Décrémentation de 9 entre chaque case pour atteindre celle juste en haut à gauche
          // Dernière case à vérifier = Case colonne de la pièce et 1ère ligne - numéro de la ligne de la pièce
    
        // Check en diagonale vers le Haut-Droite
        i := Self.Cell.Tag;
        while ((i mod 8) <> 7) and ((i div 8) <> 0) do
          i := i - 7;
        CheckPossibleMovesOnStraightLine(PossibleMoves, Self.Cell.Tag, -7, i);
          // Décrémentation de 9 entre chaque case pour atteindre celle juste en haut à gauche
          // Dernière case à vérifier = Case colonne de la pièce et 1ère ligne - numéro de la ligne de la pièce
    
        // Check en diagonale vers le Bas-Gauche
        i := Self.Cell.Tag;
        while ((i mod 8) <> 0) and ((i div 8) <> 7) do
          i := i + 7;
        CheckPossibleMovesOnStraightLine(PossibleMoves, Self.Cell.Tag, 7, i);
          // Décrémentation de 9 entre chaque case pour atteindre celle juste en haut à gauche
          // Dernière case à vérifier = Case colonne de la pièce et 1ère ligne - numéro de la ligne de la pièce
    
        // Check en diagonale vers le Bas-Droite
        i := Self.Cell.Tag;
        while ((i mod 8) <> 7) and ((i div 8) <> 7) do
          i := i + 9;
        CheckPossibleMovesOnStraightLine(PossibleMoves, Self.Cell.Tag, 9, i);
          // Décrémentation de 9 entre chaque case pour atteindre celle juste en haut à gauche
          // Dernière case à vérifier = Case colonne de la pièce et 1ère ligne - numéro de la ligne de la pièce
      end
      else
        Exception.Create('TChessBishop: PossibleMoves is nil');
    end;
  
  {$ENDREGION}

  {$REGION 'TChessKing Methods'}
    { TChessKing }
  
    constructor TChessKing.Create(Owner : TComponent; Color : TColor);
    begin
      inherited Create(Owner, Color);
      if Color = clWhite then
        Self.Picture.LoadFromFile('../../img/Pieces/White/WKing.png')
      else if Color = clBlack then
        Self.Picture.LoadFromFile('../../img/Pieces/Black/BKing.png');
    end;
  
  
    procedure TChessKing.GetPossibleMoves(Board : TChessBoard; PossibleMoves : TList<TChessCell>);
    begin
      if PossibleMoves <> nil then
      begin
        // Check en Col+1 Ligne+0
        if ((Self.Cell.Tag mod 8) < 7)
          and not ((Board[Self.Cell.Tag + 1].Piece <> nil) and (Board[Self.Cell.Tag + 1].Piece.Color = Self.fColor)) then
          PossibleMoves.Add(Board[Self.Cell.Tag + 1]);
        // Check en Col-1 Ligne+0
        if ((Self.Cell.Tag mod 8) > 0)
          and not ((Board[Self.Cell.Tag - 1].Piece <> nil) and (Board[Self.Cell.Tag - 1].Piece.Color = Self.fColor)) then
          PossibleMoves.Add(Board[Self.Cell.Tag - 1]);
        // Check en Col+0 Ligne+1
        if (Self.Cell.Tag + 8 < 64)
          and not ((Board[Self.Cell.Tag + 8].Piece <> nil) and (Board[Self.Cell.Tag + 8].Piece.Color = Self.fColor)) then
          PossibleMoves.Add(Board[Self.Cell.Tag + 8]);
        // Check en Col+0 Ligne-1
        if (Self.Cell.Tag - 8 >= 0)
          and not ((Board[Self.Cell.Tag - 8].Piece <> nil) and (Board[Self.Cell.Tag - 8].Piece.Color = Self.fColor)) then
          PossibleMoves.Add(Board[Self.Cell.Tag - 8]);
        // Check en Col+1 Ligne+1
        if ((Self.Cell.Tag mod 8) < 7) and (Self.Cell.Tag + 8 + 1 < 64)
          and not ((Board[Self.Cell.Tag + 8 + 1].Piece <> nil) and (Board[Self.Cell.Tag + 8 + 1].Piece.Color = Self.fColor)) then
          PossibleMoves.Add(Board[Self.Cell.Tag + 8 + 1]);
        // Check en Col-1 Ligne+1
        if ((Self.Cell.Tag mod 8) > 0) and (Self.Cell.Tag + 8 - 1 < 64)
          and not ((Board[Self.Cell.Tag + 8 - 1].Piece <> nil) and (Board[Self.Cell.Tag + 8 - 1].Piece.Color = Self.fColor)) then
          PossibleMoves.Add(Board[Self.Cell.Tag + 8 - 1]);
        // Check en Col+1 Ligne-1
        if ((Self.Cell.Tag mod 8) < 7) and (Self.Cell.Tag - 8 + 1 >= 0)
          and not ((Board[Self.Cell.Tag - 8 + 1].Piece <> nil) and (Board[Self.Cell.Tag - 8 + 1].Piece.Color = Self.fColor)) then
          PossibleMoves.Add(Board[Self.Cell.Tag - 8 + 1]);
        // Check en Col-1 Ligne-1
        if ((Self.Cell.Tag mod 8) > 0) and (Self.Cell.Tag - 8 - 1 >= 0)
          and not ((Board[Self.Cell.Tag - 8 - 1].Piece <> nil) and (Board[Self.Cell.Tag - 8 - 1].Piece.Color = Self.fColor)) then
          PossibleMoves.Add(Board[Self.Cell.Tag - 8 - 1]);
      end
      else
        Exception.Create('TChessKing: PossibleMoves is nil');
    end;
  
  {$ENDREGION}

  {$REGION 'TChessQueen Methods'}
    { TChessQueen }
  
    constructor TChessQueen.Create(Owner : TComponent; Color : TColor);
    begin
      inherited Create(Owner, Color);
      if Color = clWhite then
        Self.Picture.LoadFromFile('../../img/Pieces/White/WQueen.png')
      else if Color = clBlack then
        Self.Picture.LoadFromFile('../../img/Pieces/Black/BQueen.png');
    end;
  
  
    procedure TChessQueen.GetPossibleMoves(Board : TChessBoard; PossibleMoves : TList<TChessCell>);
    var
      i : Integer;
    begin
      if PossibleMoves <> nil then
      begin
        // Check en ligne vers le Haut
        CheckPossibleMovesOnStraightLine(PossibleMoves, Self.Cell.Tag, -8, Self.Cell.Tag mod 8);
          // Décrémentation de 8 entre chaque case pour atteindre celle juste au dessus
          // Dernière case à vérifier = Première Case de la première ligne (0) + colonne de la pièce
    
        // Check en ligne vers le Bas
        CheckPossibleMovesOnStraightLine(PossibleMoves, Self.Cell.Tag, 8, 56 + Self.Cell.Tag mod 8 );
          // Incrémentation de 8 entre chaque case pour atteindre celle juste en dessous
          // Dernière case à vérifier = Première Case de la dernière ligne (56) + colonne de la pièce
    
        // Check en ligne vers la Gauche
        CheckPossibleMovesOnStraightLine(PossibleMoves, Self.Cell.Tag, -1, (Self.Cell.Tag div 8) * 8 );
          // Décrémentation de 1 entre chaque case pour atteindre celle juste à gauche
          // Dernière case à vérifier = Numéro (de 0 à 7) de la ligne * nombre de cases dans une ligne
    
        // Check en ligne vers la Droite
        CheckPossibleMovesOnStraightLine(PossibleMoves, Self.Cell.Tag, 1, ((Self.Cell.Tag div 8) + 1) * 8 - 1 );
          // Décrémentation de 1 entre chaque case pour atteindre celle juste à gauche
          // Dernière case à vérifier = Numéro (de 0 à 7) de la ligne du dessous * nombre de cases dans une ligne - 1

        // Check en diagonale vers le Haut-Gauche
        i := Self.Cell.Tag;
        while ((i mod 8) <> 0) and ((i div 8) <> 0) do
          i := i - 9;
        CheckPossibleMovesOnStraightLine(PossibleMoves, Self.Cell.Tag, -9, i);
          // Décrémentation de 9 entre chaque case pour atteindre celle juste en haut à gauche
          // Dernière case à vérifier = Case colonne de la pièce et 1ère ligne - numéro de la ligne de la pièce
    
        // Check en diagonale vers le Haut-Droite
        i := Self.Cell.Tag;
        while ((i mod 8) <> 7) and ((i div 8) <> 0) do
          i := i - 7;
        CheckPossibleMovesOnStraightLine(PossibleMoves, Self.Cell.Tag, -7, i);
          // Décrémentation de 9 entre chaque case pour atteindre celle juste en haut à gauche
          // Dernière case à vérifier = Case colonne de la pièce et 1ère ligne - numéro de la ligne de la pièce
    
        // Check en diagonale vers le Bas-Gauche
        i := Self.Cell.Tag;
        while ((i mod 8) <> 0) and ((i div 8) <> 7) do
          i := i + 7;
        CheckPossibleMovesOnStraightLine(PossibleMoves, Self.Cell.Tag, 7, i);
          // Décrémentation de 9 entre chaque case pour atteindre celle juste en haut à gauche
          // Dernière case à vérifier = Case colonne de la pièce et 1ère ligne - numéro de la ligne de la pièce
    
        // Check en diagonale vers le Bas-Droite
        i := Self.Cell.Tag;
        while ((i mod 8) <> 7) and ((i div 8) <> 7) do
          i := i + 9;
        CheckPossibleMovesOnStraightLine(PossibleMoves, Self.Cell.Tag, 9, i);
          // Décrémentation de 9 entre chaque case pour atteindre celle juste en haut à gauche
          // Dernière case à vérifier = Case colonne de la pièce et 1ère ligne - numéro de la ligne de la pièce
      end
      else
        Exception.Create('TChessQueen: PossibleMoves is nil');
    end;
  
  {$ENDREGION}

  {$REGION 'TChessPlayer Methods'}
    { TChessPlayer }
    // Constructeur de la classe TChessPlayer (Joueur de la partie)
    constructor TChessPlayer.Create(Owner : TComponent; Color : TColor; Name : String);
    var
      i : Integer;
    begin
      // Initialisation des attributs généraux
      Self.fColor := Color;
      Self.fIsTurn := False;
      Self.fName := Name;
      Self.fProfilePicture := TImage.Create(ChessForm);
      Self.ProfilePicture.Height := 32;
      Self.ProfilePicture.Width := 32;
      Self.fProfilePicture.Proportional := True;
      Self.fProfilePicture.Center := True;
      Self.ProfilePicture.Parent := ChessForm;

      // Initialisation des attributs la liste des pièces
      fPawns := TList<TChessPawn>.Create;

      fRooks := TList<TChessRook>.Create;
      // Ajout de 2 Tours
      fRooks.Add(TChessRook.Create(ChessForm, Color));
      fRooks.Add(TChessRook.Create(ChessForm, Color));

      fKnights := TList<TChessKnight>.Create;
      // Ajout de 2 Cavaliers
      fKnights.Add(TChessKnight.Create(ChessForm, Color));
      fKnights.Add(TChessKnight.Create(ChessForm, Color));

      fBishops := TList<TChessBishop>.Create;
      // Ajout de 2 Fous
      fBishops.Add(TChessBishop.Create(ChessForm, Color));
      fBishops.Add(TChessBishop.Create(ChessForm, Color));

      fQueens := TList<TChessQueen>.Create;
      // Ajout d'une Reine
      fQueens.Add(TChessQueen.Create(ChessForm, Color));

      // Ajout d'un Roi
      fKing := TChessKing.Create(ChessForm, Color);

      // Organistion des pièces sur le plateau selon la couleur du joueur
      if Self.fColor = clWhite then
      begin
        Self.fProfilePicture.Picture.LoadFromFile('../../img/player2.png');
        Self.fProfilePicture.Left := 0;
        Self.fProfilePicture.Top := 0;

        for i := 0 to 7 do
        begin
          // Ajout des 8 pions
          fPawns.Add(TChessPawn.Create(ChessForm, Color));
          // Les 8 pions blancs prennent toute la 7ème ligne
          ChessForm.Board[48 + i].Piece := fPawns[i];
          fPawns[i].Cell := ChessForm.Board[48 + i];
          fPawns[i].Left := fPawns[i].Cell.Left + 3;
          fPawns[i].Top := fPawns[i].Cell.Top + 3;
        end;

        // Les 2 Tours blanches prennent les extrémités de la 1ère ligne
        ChessForm.Board[56].Piece := fRooks[0];
        fRooks[0].Cell := ChessForm.Board[56];
        ChessForm.Board[63].Piece := fRooks[1];
        fRooks[1].Cell := ChessForm.Board[63];
        fRooks[0].Left := fRooks[0].Cell.Left + 3;
        fRooks[0].Top := fRooks[0].Cell.Top + 3;
        fRooks[1].Left := fRooks[1].Cell.Left + 3;
        fRooks[1].Top := fRooks[1].Cell.Top + 3;
        
        // Les 2 Cavaliers blancs prennent les 2ème cases les + extérieures de la 1ème ligne
        ChessForm.Board[57].Piece := fKnights[0];
        fKnights[0].Cell := ChessForm.Board[57];
        ChessForm.Board[62].Piece := fKnights[1];
        fKnights[1].Cell := ChessForm.Board[62];
        fKnights[0].Left := fKnights[0].Cell.Left + 3;
        fKnights[0].Top := fKnights[0].Cell.Top + 3;
        fKnights[1].Left := fKnights[1].Cell.Left + 3;
        fKnights[1].Top := fKnights[1].Cell.Top + 3;

        // Les 2 Fous blancs prennent les 3ème cases les + extérieures de la 1ème ligne
        ChessForm.Board[58].Piece := fBishops[0];
        fBishops[0].Cell := ChessForm.Board[58];
        ChessForm.Board[61].Piece := fBishops[1];
        fBishops[1].Cell := ChessForm.Board[61];
        fBishops[0].Left := fBishops[0].Cell.Left + 3;
        fBishops[0].Top := fBishops[0].Cell.Top + 3;
        fBishops[1].Left := fBishops[1].Cell.Left + 3;
        fBishops[1].Top := fBishops[1].Cell.Top + 3;

        // La Reine blanche prend la case de gauche la plus intérieure de la 1ère ligne
        ChessForm.Board[59].Piece := fQueens[0];
        fQueens[0].Cell := ChessForm.Board[59];
        fQueens[0].Left := fQueens[0].Cell.Left + 3;
        fQueens[0].Top := fQueens[0].Cell.Top + 3;
        
        // Le Roi blanc prend la case de droite la plus intérieure de la 1ère ligne
        ChessForm.Board[60].Piece := fKing;
        fKing.Cell := ChessForm.Board[60];
        fKing.Left := fKing.Cell.Left + 3;
        fKing.Top := fKing.Cell.Top + 3;

      end
      // de même pour les pièces noires
      else if Self.fColor = clBlack then
      begin
        Self.fProfilePicture.Picture.LoadFromFile('../../img/player1.png');
        Self.fProfilePicture.Left := 864 - Self.ProfilePicture.Width;
        Self.fProfilePicture.Top := 864 - Self.ProfilePicture.Height;

        for i := 0 to 7 do
        begin
          fPawns.Add(TChessPawn.Create(ChessForm, Color));
          ChessForm.Board[8 + i].Piece := fPawns[i];
          fPawns[i].Cell := ChessForm.Board[8 + i];
          fPawns[i].Left := fPawns[i].Cell.Left + 3;
          fPawns[i].Top := fPawns[i].Cell.Top + 3;
        end;

        ChessForm.Board[0].Piece := fRooks[0];
        fRooks[0].Cell := ChessForm.Board[0];
        ChessForm.Board[7].Piece := fRooks[1];
        fRooks[1].Cell := ChessForm.Board[7];
        fRooks[0].Left := fRooks[0].Cell.Left + 3;
        fRooks[0].Top := fRooks[0].Cell.Top + 3;
        fRooks[1].Left := fRooks[1].Cell.Left + 3;
        fRooks[1].Top := fRooks[1].Cell.Top + 3;
        
        ChessForm.Board[1].Piece := fKnights[0];
        fKnights[0].Cell := ChessForm.Board[1];
        ChessForm.Board[6].Piece := fKnights[1];
        fKnights[1].Cell := ChessForm.Board[6];
        fKnights[0].Left := fKnights[0].Cell.Left + 3;
        fKnights[0].Top := fKnights[0].Cell.Top + 3;
        fKnights[1].Left := fKnights[1].Cell.Left + 3;
        fKnights[1].Top := fKnights[1].Cell.Top + 3;

        ChessForm.Board[2].Piece := fBishops[0];
        fBishops[0].Cell := ChessForm.Board[2];
        ChessForm.Board[5].Piece := fBishops[1];
        fBishops[1].Cell := ChessForm.Board[5];
        fBishops[0].Left := fBishops[0].Cell.Left + 3;
        fBishops[0].Top := fBishops[0].Cell.Top + 3;
        fBishops[1].Left := fBishops[1].Cell.Left + 3;
        fBishops[1].Top := fBishops[1].Cell.Top + 3;

        ChessForm.Board[3].Piece := fQueens[0];
        fQueens[0].Cell := ChessForm.Board[3];
        fQueens[0].Left := fQueens[0].Cell.Left + 3;
        fQueens[0].Top := fQueens[0].Cell.Top + 3;
        
        ChessForm.Board[4].Piece := fKing;
        fKing.Cell := ChessForm.Board[4];
        fKing.Left := fKing.Cell.Left + 3;
        fKing.Top := fKing.Cell.Top + 3;
      end;

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
    end;

    // Fonction renvoyant un booléen selon si le Roi du joueur est en échec ou pas
    function TChessPlayer.IsKingChecked(Opponent : TChessPlayer): Boolean;
    var 
      i : Integer;
      _possibleMovesOfPlayer : TList<TChessCell>;
    begin
      Result := False;
      // On ne sait jamais
      if Self.fKing <> nil then
      begin
        _possibleMovesOfPlayer := TList<TChessCell>.Create;
        // Est-ce qu'un Pion peut prendre le Roi ?
        if Opponent.fPawns <> nil then
        begin
          for i := 0 to Opponent.fPawns.Count - 1 do
          begin
            Opponent.fPawns[i].GetPossibleMoves(ChessForm.Board, _possibleMovesOfPlayer);
            if _possibleMovesOfPlayer.Contains(Self.fKing.Cell) then
            begin
              Result := True;
              Exit;
            end;
            _possibleMovesOfPlayer.Clear;
          end;
        end;
        // Est-ce qu'une Tou peut prendre le Roi ?
        if Opponent.fRooks <> nil then
        begin
          for i := 0 to Opponent.fRooks.Count - 1 do
          begin
            Opponent.fRooks[i].GetPossibleMoves(ChessForm.Board, _possibleMovesOfPlayer);
            if _possibleMovesOfPlayer.Contains(Self.fKing.Cell) then
            begin
              Result := True;
              Exit;
            end;
            _possibleMovesOfPlayer.Clear;
          end;
        end;
        // Est-ce qu'un cavalier peut prendre le Roi ?
        if Opponent.fKnights <> nil then
        begin
          for i := 0 to Opponent.fKnights.Count - 1 do
          begin
            Opponent.fKnights[i].GetPossibleMoves(ChessForm.Board, _possibleMovesOfPlayer);
            if _possibleMovesOfPlayer.Contains(Self.fKing.Cell) then
            begin
              Result := True;
              Exit;
            end;
            _possibleMovesOfPlayer.Clear;
          end;
        end;
        // Est-ce qu'un Fou peut prendre le Roi ?
        if Opponent.fBishops <> nil then
        begin
          for i := 0 to Opponent.fBishops.Count - 1 do
          begin
            Opponent.fBishops[i].GetPossibleMoves(ChessForm.Board, _possibleMovesOfPlayer);
            if _possibleMovesOfPlayer.Contains(Self.fKing.Cell) then
            begin
              Result := True;
              Exit;
            end;
            _possibleMovesOfPlayer.Clear;
          end;
        end;
        // Est-ce qu'une Reine peut prendre le Roi ?
        if Opponent.fQueens <> nil then
        begin
          for i := 0 to Opponent.fQueens.Count - 1 do
          begin
            Opponent.fQueens[i].GetPossibleMoves(ChessForm.Board, _possibleMovesOfPlayer);
            if _possibleMovesOfPlayer.Contains(Self.fKing.Cell) then
            begin
              Result := True;
              Exit;
            end;
            _possibleMovesOfPlayer.Clear;
          end;
        end;
        // Est-ce qu'un Roi peut prendre le Roi ?
        // Oui, c'est techniquement impossible car implquant que l'autre Roi est aussi en échec.
        // Mais le Mat n'est pas encore implémenté car vraiment trop fastidieux.
        // Peut-être dans la version 132.
        if Opponent.fKing <> nil then
        begin
          Opponent.fKing.GetPossibleMoves(ChessForm.Board, _possibleMovesOfPlayer);
          if _possibleMovesOfPlayer.Contains(Self.fKing.Cell) then
          begin
            Result := True;
            Exit;
          end;
          _possibleMovesOfPlayer.Clear;
        end;
      end;
    end;

  {$ENDREGION}

  {$REGION 'TChessForm Methods'}
    { TChessForm }
    // Constructeur de la classe TChessForm (Fenêtre principale du Chess)
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
    
    // Procédure de destruction du plateau entier appelée lors de la destruction de la fenêtre principale
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
      Player2.King.Free;

      for i := 0 to 63 do
        fBoard[i].Free;
      
      Player1.Free;
      Player2.Free;
      
      Self.fLblCellIndicator.Free;
      Self.fBoardOutline.Free;
    end;

    // Procédure de génération du plateau entier appelée lors de la création de la fenêtre principale
    procedure TChessForm.GenerateBoard(Sender: TObject);
    var
      _isWhite : Boolean;
    begin
      // TShape sans corps, avec contour pour rendre plus joli le contour du plateau
      fBoardOutline := TShape.Create(Self);
      fBoardOutline.Parent := Self;
      fBoardOutline.Left := 45;
      fBoardOutline.Top := 45;
      fBoardOutline.Width := 774;
      fBoardOutline.Height := 774;
      fBoardOutline.Shape := stRectangle;
      fBoardOutline.Brush.Style := bsClear;
      fBoardOutline.Pen.Color := RGB(66, 29, 0);
      fBoardOutline.Pen.Width := 3;

      // Label pour le nom du joueur dont c'est le tour (et l'échec de son Roi)
      fLblCellIndicator:= TLabel.Create(Self);
      fLblCellIndicator.Parent := Self;
      fLblCellIndicator.Left := 1;
      fLblCellIndicator.Top := Self.ClientHeight - 17;
      fLblCellIndicator.Width := 4;
      fLblCellIndicator.Height := 16;
      fLblCellIndicator.Font.Charset := DEFAULT_CHARSET;
      fLblCellIndicator.Font.Color := clWhite;
      fLblCellIndicator.Font.Height := -17;
      fLblCellIndicator.Font.Name := 'Tahoma';
      fLblCellIndicator.Font.Style := [];
      fLblCellIndicator.ParentFont := False;
    
      _isWhite := True;
      for var index := 0 to 63 do
      begin
        Self.fBoard[index] := TChessCell.Create(Self);
        Self.fBoard[index].Parent := Self;
        Self.fBoard[index].Left := 48 + (index mod 8) * 96;
        Self.fBoard[index].Top := 48 + (index div 8) * 96;
        Self.fBoard[index].Tag := index;
        if _isWhite then
          Self.fBoard[index].Brush.Color := RGB(210, 206, 176)
        else
          Self.fBoard[index].Brush.Color := RGB(160, 137, 65);
        _isWhite := not _isWhite;
        if index mod 8 = 7 then
          _isWhite := not _isWhite;
      end;

      // Create the players
      Self.fPlayer1 := TChessPlayer.Create(Self, clWhite, 'Player 1');
      Self.fPlayer2 := TChessPlayer.Create(Self, clBlack, 'Player 2');
    
      //if fBoard[8].Piece <> nil then
      fLblCellIndicator.Caption :=  'White Starts';

      Self.fPlayer1.IsTurn := True;
    end;

    procedure TChessForm.GameOver(Winner : TChessPlayer);
    begin
      if Winner = Player1 then
        Self.fLblCellIndicator.Caption := 'Player 1 Wins !'
      else
        fLblCellIndicator.Caption := 'Player 2 Wins !';
      
      fLblCellIndicator.Font.Color := clRed;
      Self.fLblCellIndicator.BringToFront;
      Self.fLblCellIndicator.Left := (Self.ClientWidth div 2) - 145;
      Self.fLblCellIndicator.Top := (Self.ClientHeight div 2) - 20;
      Self.fLblCellIndicator.Font.Size := 24;
      Self.fLblCellIndicator.Top := (Self.ClientHeight div 2) - 20;
      Self.fBoardOutline.BringToFront;
    end;

    function TChessForm.GetPlayerByColor(Color : TColor) : TChessPlayer;
    begin
      Result := nil;
      if Color = clWhite then
        Result := fPlayer1
      else if Color = clBlack then
        Result := fPlayer2;
    end;

{$ENDREGION}
{$ENDREGION}


end.
