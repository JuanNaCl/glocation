import 'package:go_router/go_router.dart';

import '../presentation/screens/screens.dart';


// GoRouter configuration
final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: HomeScreen.name,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/writeData',
      name: WriteDataScreen.name,
      builder: (context, state) => const WriteDataScreen(),
    ),
    GoRoute(
      path: '/loadData',
      name: LoadDataScreen.name,
      builder: (context, state) => const LoadDataScreen(),
    ),
  ],
);
