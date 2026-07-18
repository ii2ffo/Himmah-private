import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/app_theme.dart';
import 'state/app_state.dart';
import 'screens/auth/login_screen.dart';
import 'screens/app_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(const HimmahApp());
}

class HimmahApp extends StatefulWidget {
  const HimmahApp({super.key});

  @override
  State<HimmahApp> createState() => _HimmahAppState();
}

class _HimmahAppState extends State<HimmahApp> {
  final AppState state = AppState();

  @override
  Widget build(BuildContext context) {
    return AppStateScope(
      notifier: state,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'همّة',
        locale: const Locale('ar'),
        theme: AppTheme.light,
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: AnimatedBuilder(
            animation: state,
            builder: (_, __) => state.isLoggedIn
                ? const AppShell()
                : const LoginScreen(),
          ),
        ),
      ),
    );
  }
}
