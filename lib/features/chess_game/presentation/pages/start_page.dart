import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../cubit/chess_game_cubit.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                context.read<ChessGameCubit>().initGame();
                context.go('/game');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF769656),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                minimumSize: const Size(250, 55),
              ),
              child: const Text('Bắt đầu Trận đấu', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.push('/bot_difficulty');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[700],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                minimumSize: const Size(250, 55),
              ),
              child: const Text('Đánh với máy', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
