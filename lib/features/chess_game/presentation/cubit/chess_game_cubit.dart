import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chess/chess.dart' as chess;
import 'chess_game_state.dart';

class ChessGameCubit extends Cubit<ChessGameState> {
  ChessGameCubit() : super(ChessGameInitial());

  void initGame() {
    emit(ChessGameLoading());
    final game = chess.Chess();
    emit(ChessGameInProgress(
      game: game,
      fen: game.fen,
      moveHistory: const [],
    ));
  }

  void makeMove(String from, String to) {
    if (state is ChessGameInProgress || state is ChessGameOver) {
      final dynamic currentState = state;
      final game = currentState.game as chess.Chess;
      final history = List<String>.from(currentState.moveHistory);
      
      try {
        // Tìm đối tượng Move chuẩn từ danh sách nước đi hợp lệ
        final List<chess.Move> legalMoves = game.generate_moves({'square': from});
        
        // Tìm nước đi có ô đích khớp với 'to'
        chess.Move? moveObj;
        for (var m in legalMoves) {
          if (m.toAlgebraic == to) {
            moveObj = m;
            break;
          }
        }

        if (moveObj != null) {
          // Lấy ký hiệu SAN trước khi thực hiện nước đi
          final String san = game.move_to_san(moveObj);
          
          // Thực hiện nước đi bằng đối tượng Move
          final bool success = game.move(moveObj);

          if (success) {
            history.add(san);
            if (game.game_over) {
              emit(ChessGameOver(
                result: _getResult(game),
                fen: game.fen,
                game: game,
                moveHistory: history,
              ));
            } else {
              emit(ChessGameInProgress(
                game: game,
                fen: game.fen,
                moveHistory: history,
              ));
            }
          }
        } else {
          debugPrint('Nước đi không hợp lệ hoặc không tìm thấy: $from -> $to');
        }
      } catch (e) {
        debugPrint('Lỗi phát sinh khi thực hiện nước đi: $e');
      }
    }
  }

  void undoMove() {
    if (state is ChessGameInProgress || state is ChessGameOver) {
      final dynamic currentState = state;
      final game = currentState.game as chess.Chess;
      final history = List<String>.from(currentState.moveHistory);
      
      final move = game.undo();
      if (move != null) {
        if (history.isNotEmpty) {
          history.removeLast();
        }
        emit(ChessGameInProgress(
          game: game,
          fen: game.fen,
          moveHistory: history,
        ));
      }
    }
  }

  String _getResult(chess.Chess game) {
    if (game.in_checkmate) return 'Checkmate';
    if (game.in_draw) return 'Draw';
    if (game.in_stalemate) return 'Stalemate';
    if (game.in_threefold_repetition) return 'Threefold Repetition';
    if (game.insufficient_material) return 'Insufficient Material';
    return 'Game Over';
  }
}
