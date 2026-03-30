import 'package:get_it/get_it.dart';
import 'features/chess_game/presentation/cubit/chess_game_cubit.dart';

final sl = GetIt.instance; // sl: Service Locator

Future<void> init() async {
  // Features - Chess Game
  // Cubit
  sl.registerFactory(() => ChessGameCubit());

  // Use cases (Add later if needed)
  
  // Repository (Add later if needed)
  
  // Data sources (Add later if needed)

  // Core
  
  // External
}
