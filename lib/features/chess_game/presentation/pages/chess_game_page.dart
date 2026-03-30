import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chess/chess.dart' as chess;
import '../cubit/chess_game_cubit.dart';
import '../cubit/chess_game_state.dart';
import '../widgets/chess_board_widget.dart';

class ChessGamePage extends StatelessWidget {
  const ChessGamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF302E2B),
      appBar: AppBar(
        title: const Text('Chess Mobile - Pro'),
        backgroundColor: Colors.brown[900],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocListener<ChessGameCubit, ChessGameState>(
        listener: (context, state) {
          if (state is ChessGameOver) {
            _showGameOverDialog(context, state.result);
          }
        },
        child: BlocBuilder<ChessGameCubit, ChessGameState>(
          builder: (context, state) {
            if (state is ChessGameLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            } else if (state is ChessGameInProgress || state is ChessGameOver) {
              final game = (state is ChessGameInProgress)
                  ? state.game
                  : (state as ChessGameOver).game;
              final history = (state is ChessGameInProgress)
                  ? state.moveHistory
                  : (state as ChessGameOver).moveHistory;
              return _buildGameView(context, game, history);
            }
            return const Center(
              child: Text(
                'Lỗi hệ thống hoặc chưa có trò chơi',
                style: TextStyle(color: Colors.white),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildGameView(
    BuildContext context,
    chess.Chess game,
    List<String> moveHistory,
  ) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(height: 10),
          const _PlayerInfoTile(name: 'Đối thủ (Black)', isTurn: false),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ChessBoardWidget(
              game: game,
              pieces: _convertBoardToList(game),
              onMove: (from, to) {
                // Thực hiện nước đi thông qua Cubit
                context.read<ChessGameCubit>().makeMove(from, to);
                // Phản hồi rung nhẹ
                HapticFeedback.lightImpact();
              },
            ),
          ),
          const SizedBox(height: 10),
          const _PlayerInfoTile(name: 'Bạn (White)', isTurn: true),
          const SizedBox(height: 20),
          _buildControls(context),
          const SizedBox(height: 20),
          _buildMoveHistory(moveHistory),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildControls(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CircleAvatar(
          backgroundColor: Colors.white10,
          child: IconButton(
            onPressed: () => context.read<ChessGameCubit>().undoMove(),
            icon: const Icon(Icons.undo, color: Colors.white),
            tooltip: 'Hoàn tác',
          ),
        ),
        ElevatedButton.icon(
          onPressed: () => context.read<ChessGameCubit>().initGame(),
          icon: const Icon(Icons.restart_alt),
          label: const Text('Làm mới'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.brown[700],
            foregroundColor: Colors.white,
          ),
        ),
        CircleAvatar(
          backgroundColor: Colors.white10,
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildMoveHistory(List<String> history) {
    return Container(
      height: 120,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'LỊCH SỬ NƯỚC ĐI',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(color: Colors.white10),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: (history.length / 2).ceil(),
              itemBuilder: (context, index) {
                int moveNumber = index + 1;
                String whiteMove = history[index * 2];
                String blackMove = (index * 2 + 1 < history.length)
                    ? history[index * 2 + 1]
                    : '';

                return Container(
                  width: 100,
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.03),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$moveNumber.',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            whiteMove,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            blackMove,
                            style: const TextStyle(
                              color: Color(0xFF769656),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showGameOverDialog(BuildContext context, String result) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF302E2B),
        title: const Text(
          'Trận đấu kết thúc',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.emoji_events, color: Color(0xFF769656), size: 64),
            const SizedBox(height: 20),
            Text(
              result.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<ChessGameCubit>().initGame();
            },
            child: const Text(
              'CHƠI LẠI',
              style: TextStyle(color: Color(0xFF769656)),
            ),
          ),
        ],
      ),
    );
  }

  List<String?> _convertBoardToList(chess.Chess game) {
    List<String?> flatBoard = List.filled(64, null);
    for (int i = 0; i < 64; i++) {
      int row = i ~/ 8;
      int col = i % 8;
      String square =
          '${String.fromCharCode('a'.codeUnitAt(0) + col)}${8 - row}';
      var piece = game.get(square);
      if (piece != null) {
        // Gán nhãn 'w' cho trắng, 'b' cho đen kèm theo ký hiệu quân cờ
        String symbol = piece.type.toString()[0];
        flatBoard[i] = (piece.color == chess.Color.WHITE ? 'w' : 'b') + symbol;
      }
    }
    return flatBoard;
  }
}

class _PlayerInfoTile extends StatelessWidget {
  final String name;
  final bool isTurn;
  const _PlayerInfoTile({required this.name, required this.isTurn});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: isTurn ? Colors.white10 : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey[800],
                child: const Icon(Icons.person, color: Colors.white),
              ),
              const SizedBox(width: 10),
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if (isTurn) const Icon(Icons.timer, color: Color(0xFF769656)),
        ],
      ),
    );
  }
}
