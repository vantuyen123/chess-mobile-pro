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
        child: ElevatedButton(
          onPressed: () {
            context.read<ChessGameCubit>().initGame();
            context.go('/game');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF769656),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          ),
          child: const Text('Bắt đầu Trận đấu', style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}
