import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'viewmodels/pomodoro_viewmodel.dart';
import 'views/home_page.dart';

void main() {
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
        home: const HomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}