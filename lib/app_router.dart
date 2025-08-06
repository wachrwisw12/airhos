import 'dart:async';
import 'package:arihos/features/timekeeper/ui/timekeeper_histrory.dart';
import 'package:arihos/features/timekeeper/ui/timekeeper_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'core/widgets/splash_screen.dart';
import 'features/auth/controller/auth_controller.dart';
import 'features/auth/ui/login_screen.dart';
import 'features/home/ui/home_screen.dart';

GoRouter createRouter(WidgetRef ref) {
  final authNotifier = ref.read(authControllerProvider.notifier);
  return GoRouter(
    initialLocation: '/loading',
    refreshListenable: GoRouterRefreshStream(authNotifier.stream),
    redirect: (context, state) {
      final auth = ref.read(authControllerProvider);
      if (auth.isLoading) return null;
      final loggedIn = auth.token != null;
      final isLoginPage = state.uri.path == '/';
      final isLoadingPage = state.uri.path == '/loading';
      print(state.uri.path);
      if (!loggedIn && !isLoginPage) return '/';
      if (loggedIn && (isLoginPage || isLoadingPage)) return '/home';
      return null;
    },
    routes: [
      GoRoute(path: '/loading', builder: (context, state) => SplashScreen()),

      GoRoute(path: '/', builder: (context, state) => const LoginScreen()),

      /// ShellRoute ครอบทุกหน้าหลัง login
      ShellRoute(
        builder: (context, state, child) {
          final location = state.uri.path;
          return MainScaffold(location: location, child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/timekeeper',
            builder: (context, state) => TimekeepingScreen(),
            routes: [
              GoRoute(
                path: '/timekeeperhistory',
                builder: (context, state) => const TimekeeperHistroryScreen(),
              ),
            ],
          ),
          // GoRoute(
          //   path: '/details',
          //   builder: (context, state) => const DetailsScreen(),
          // ),
        ],
      ),
    ],
  );
}

// Layout หลัก ที่มี BottomNavigationBar
class MainScaffold extends StatelessWidget {
  final Widget child;
  final String location;

  const MainScaffold({super.key, required this.child, required this.location});

  @override
  Widget build(BuildContext context) {
    final tabs = ['/home', '/profile', '/settings'];
    int currentIndex = tabs.indexWhere((path) => location.startsWith(path));

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex == -1 ? 0 : currentIndex,
        onTap: (index) {
          context.go(tabs[index]);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'หน้าแรก'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'โปรไฟล์'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'แจ้งเตือน',
          ),
        ],
      ),
    );
  }
}

// ตัวช่วยให้ GoRouter รู้ว่า auth state เปลี่ยน
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen((_) {
      notifyListeners();
    });
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
