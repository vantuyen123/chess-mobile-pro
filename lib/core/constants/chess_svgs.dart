class ChessSvgs {
  // Bộ quân cờ Cburnett (Wikipedia/Lichess Standard)

  static const String whitePawn = 'assets/images/chess_pieces/white_pawn.svg';

  static const String whiteKnight = 'assets/images/chess_pieces/white_knight.svg';
  static const String whiteBishop = 'assets/images/chess_pieces/white_bishop.svg';
  static const String whiteRook = 'assets/images/chess_pieces/white_rook.svg';

  static const String whiteQueen = 'assets/images/chess_pieces/white_queen.svg';

  static const String whiteKing = 'assets/images/chess_pieces/white_king.svg';

  static const String blackPawn = 'assets/images/chess_pieces/black_pawn.svg';

  static const String blackKnight =
      'assets/images/chess_pieces/black_knight.svg';
  static const String blackBishop =
      'assets/images/chess_pieces/black_bishop.svg';
  static const String blackRook = 'assets/images/chess_pieces/black_rook.svg';
  static const String blackQueen = 'assets/images/chess_pieces/black_queen.svg';
  static const String blackKing = 'assets/images/chess_pieces/black_king.svg';
  //

  static String getSvg(String pieceCode) {
    switch (pieceCode) {
      case 'wp':
        return whitePawn;
      case 'wn':
        return whiteKnight;
      case 'wb':
        return whiteBishop;
      case 'wr':
        return whiteRook;
      case 'wq':
        return whiteQueen;
      case 'wk':
        return whiteKing;
      case 'bp':
        return blackPawn;
      case 'bn':
        return blackKnight;
      case 'bb':
        return blackBishop;
      case 'br':
        return blackRook;
      case 'bq':
        return blackQueen;
      case 'bk':
        return blackKing;
      default:
        return '';
    }
  }
}
