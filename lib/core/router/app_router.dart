import 'package:go_router/go_router.dart';
import '../../features/chess_game/presentation/pages/start_page.dart';
import '../../features/chess_game/presentation/pages/chess_game_page.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const StartPage(),
      ),
      GoRoute(
        path: '/game',
        builder: (context, state) => const ChessGamePage(),
      ),
    ],
  );
}
