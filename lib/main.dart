import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'injection_container.dart' as di;
import 'features/chess_game/presentation/cubit/chess_game_cubit.dart';
import 'features/chess_game/presentation/provider/game_provider.dart';
import 'core/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Dùng cho logic Clean Architecture (Cubit)
        BlocProvider(create: (context) => di.sl<ChessGameCubit>()),
        // Dùng cho logic Provider truyền thống
        ChangeNotifierProvider(create: (context) => GameProvider()),
      ],
      child: MaterialApp.router(
        title: 'Chess Free',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.brown,
          useMaterial3: true,
        ),
        routerConfig: AppRouter.router,
      ),
    );
  }
}
