// lib/views/pomodoro_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/pomodoro_viewmodel.dart';
import '../models/pomodoro_timer.dart';
import 'pomodoro_history_page.dart';

class PomodoroPage extends StatelessWidget {
  const PomodoroPage({super.key});

  String formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<PomodoroViewModel>(context);
    final timer = viewModel.timer;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pomodoro"),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PomodoroHistoryPage()),
              );
            },
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                formatTime(timer.remainingSeconds),
                style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              Text("Session: ${timer.sessionType.name.toUpperCase()}"),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(onPressed: viewModel.start, child: const Text("Start")),
                  const SizedBox(width: 12),
                  ElevatedButton(onPressed: viewModel.pause, child: const Text("Pause")),
                  const SizedBox(width: 12),
                  ElevatedButton(onPressed: viewModel.reset, child: const Text("Reset")),
                ],
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => viewModel.changeSession(PomodoroSessionType.work),
                    child: const Text("Work"),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () => viewModel.changeSession(PomodoroSessionType.shortBreak),
                    child: const Text("Short Break"),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () => viewModel.changeSession(PomodoroSessionType.longBreak),
                    child: const Text("Long Break"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
