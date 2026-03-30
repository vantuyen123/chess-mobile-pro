import 'package:equatable/equatable.dart';
import 'package:chess/chess.dart' as chess;

abstract class ChessGameState extends Equatable {
  const ChessGameState();

  @override
  List<Object?> get props => [];
}

class ChessGameInitial extends ChessGameState {}

class ChessGameLoading extends ChessGameState {}

class ChessGameInProgress extends ChessGameState {
  final chess.Chess game;
  final String fen;
  final List<String> moveHistory; // Thêm lịch sử nước đi dạng SAN

  const ChessGameInProgress({
    required this.game,
    required this.fen,
    required this.moveHistory,
  });

  @override
  List<Object?> get props => [fen, moveHistory];
}

class ChessGameOver extends ChessGameState {
  final String result;
  final String fen;
  final chess.Chess game;
  final List<String> moveHistory; // Thêm lịch sử nước đi dạng SAN

  const ChessGameOver({
    required this.result,
    required this.fen,
    required this.game,
    required this.moveHistory,
  });

  @override
  List<Object?> get props => [result, fen, moveHistory];
}
