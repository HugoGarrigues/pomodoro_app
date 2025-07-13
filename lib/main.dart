import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/supabase_service.dart';
import 'viewmodels/pomodoro_viewmodel.dart';
import 'views/home_page.dart';
import 'views/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.init();

  runApp(const PomodoroApp());
}

class PomodoroApp extends StatelessWidget {
  const PomodoroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PomodoroViewModel(),
      child: MaterialApp(
        title: 'Pomodoro App',
        theme: ThemeData(
          primarySwatch: Colors.red,
          useMaterial3: true,
        ),
        home: const AuthGate(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final session = SupabaseService.currentSession;
    return session != null ? const HomePage() : const LoginPage();
  }
}
