import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/pomodoro_viewmodel.dart';
import 'views/pomodoro_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => PomodoroViewModel(),
      child: const PomodoroApp(),
    ),
  );
}

class PomodoroApp extends StatelessWidget {
  const PomodoroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pomodoro-App',
      theme: ThemeData.dark(),
      home: const PomodoroPage(),
    );
  }
}
