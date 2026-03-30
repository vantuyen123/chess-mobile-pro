import 'package:equatable/equatable.dart';

class ChessMatch extends Equatable {
  final String id;
  final String fen;
  final List<String> pgn;
  final DateTime startTime;
  final bool isGameOver;

  const ChessMatch({
    required this.id,
    required this.fen,
    required this.pgn,
    required this.startTime,
    this.isGameOver = false,
  });

  @override
  List<Object?> get props => [id, fen, pgn, isGameOver];
}
