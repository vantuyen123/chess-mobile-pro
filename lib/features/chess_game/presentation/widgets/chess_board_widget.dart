import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:chess/chess.dart' as chess;
import 'package:chess_interface/chess_interface_dart.dart' as ci;
import '../../../../core/constants/chess_svgs.dart';

class ChessBoardWidget extends StatefulWidget {
  final List<String?> pieces;
  final chess.Chess game;
  final Function(String from, String to) onMove;

  const ChessBoardWidget({
    super.key,
    required this.pieces,
    required this.game,
    required this.onMove,
  });

  @override
  State<ChessBoardWidget> createState() => _ChessBoardWidgetState();
}

class _ChessBoardWidgetState extends State<ChessBoardWidget> {
  // Danh sách các ô đang được highlight (nước đi hợp lệ)
  Set<String> highlightedSquares = {};

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1 / 1,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.brown[900]!, width: 2),
        ),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 64,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 8,
          ),
          itemBuilder: (context, index) {
            int row = index ~/ 8;
            int col = index % 8;
            String squareName = _getSquareName(row, col);

            bool isWhiteSquare = (row + col) % 2 == 0;
            Color squareColor = isWhiteSquare
                ? const Color(0xFFEEEED2)
                : const Color(0xFF769656);

            // Kiểm tra xem ô này có đang được highlight không
            bool isHighlighted = highlightedSquares.contains(squareName);

            return DragTarget<String>(
              onWillAcceptWithDetails: (details) => true,
              onAcceptWithDetails: (details) {
                widget.onMove(details.data, squareName);
                setState(() {
                  highlightedSquares.clear();
                });
              },
              builder: (context, candidateData, rejectedData) {
                return Container(
                  color: squareColor,
                  child: Stack(
                    children: [
                      // Hiển thị quân cờ (nếu có)
                      if (widget.pieces[index] != null)
                        Center(child: _buildDraggablePiece(index, squareName)),
                      // Hiển thị dấu chấm highlight nếu là nước đi hợp lệ
                      if (isHighlighted)
                        Center(
                          child: Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildDraggablePiece(int index, String squareName) {
    final String pieceCode = widget.pieces[index]!;

    // Sử dụng ChessPiece từ thư viện chess_interface để quản lý quân cờ
    final bool isWhite = pieceCode.startsWith('w');
    final String typeChar = pieceCode[1].toLowerCase();

    ci.PieceType type;
    switch (typeChar) {
      case 'p':
        type = ci.PieceType.pawn;
        break;
      case 'n':
        type = ci.PieceType.knight;
        break;
      case 'b':
        type = ci.PieceType.bishop;
        break;
      case 'r':
        type = ci.PieceType.rook;
        break;
      case 'q':
        type = ci.PieceType.queen;
        break;
      case 'k':
        type = ci.PieceType.king;
        break;
      default:
        type = ci.PieceType.pawn;
    }

    // ignore: unused_local_variable
    final ci.ChessPiece cp = ci.ChessPiece(
      type: type,
      color: isWhite ? ci.PieceColor.white : ci.PieceColor.black,
    );

    // Sử dụng bộ mã SVG Cburnett chuyên nghiệp
    final String svgContent = ChessSvgs.getSvg(pieceCode);

    Widget pieceWidget = Padding(
      padding: const EdgeInsets.all(4.0),
      child: SvgPicture.asset(
        svgContent,
        width: 40,
        height: 40,
        fit: BoxFit.contain,
      ),
    );

    return Draggable<String>(
      data: squareName,
      feedback: Material(
        color: Colors.transparent,
        child: SizedBox(width: 50, height: 50, child: pieceWidget),
      ),
      childWhenDragging: Opacity(opacity: 0.3, child: pieceWidget),
      onDragStarted: () {
        // Khi bắt đầu kéo, lấy danh sách các nước đi hợp lệ từ ô này
        final moves = widget.game.moves({
          'square': squareName,
          'verbose': true,
        });
        setState(() {
          highlightedSquares = moves.map((m) => m['to'] as String).toSet();
        });
      },
      onDraggableCanceled: (_, __) {
        setState(() {
          highlightedSquares.clear();
        });
      },
      child: pieceWidget,
    );
  }

  String _getSquareName(int row, int col) {
    return '${String.fromCharCode('a'.codeUnitAt(0) + col)}${8 - row}';
  }
}
