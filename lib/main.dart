import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/app_theme.dart';
import 'state/app_state.dart';
import 'screens/auth/login_screen.dart';
import 'screens/app_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  final state = AppState();
  await state.initialize();
  runApp(HimmahApp(state: state));
}

class HimmahApp extends StatelessWidget {
  const HimmahApp({super.key, required this.state});
  final AppState state;

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
            builder: (_, __) => state.isLoggedIn ? const AppShell() : const LoginScreen(),
          ),
        ),
      ),
    );
  }
}
