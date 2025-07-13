import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/pomodoro_viewmodel.dart';
import '../models/pomodoro_timer.dart';

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

    final workController =
        TextEditingController(text: (viewModel.workDuration ~/ 60).toString());
    final shortBreakController =
        TextEditingController(text: (viewModel.shortBreakDuration ~/ 60).toString());
    final longBreakController =
        TextEditingController(text: (viewModel.longBreakDuration ~/ 60).toString());

    return Scaffold(
      appBar: AppBar(title: const Text("Pomodoro")),
      body: SingleChildScrollView(
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
            const SizedBox(height: 40),
            const Text('Personnaliser les durées (en minutes)', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            // Champ Work
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Work: '),
                SizedBox(
                  width: 60,
                  child: TextField(
                    controller: workController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                    onSubmitted: (value) {
                      final intValue = int.tryParse(value) ?? 25;
                      viewModel.setDuration(PomodoroSessionType.work, intValue * 60);
                    },
                  ),
                ),
                const Text(' min'),
              ],
            ),
            const SizedBox(height: 12),

            // Champ Short Break
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Short Break: '),
                SizedBox(
                  width: 60,
                  child: TextField(
                    controller: shortBreakController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                    onSubmitted: (value) {
                      final intValue = int.tryParse(value) ?? 5;
                      viewModel.setDuration(PomodoroSessionType.shortBreak, intValue * 60);
                    },
                  ),
                ),
                const Text(' min'),
              ],
            ),
            const SizedBox(height: 12),

            // Champ Long Break
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Long Break: '),
                SizedBox(
                  width: 60,
                  child: TextField(
                    controller: longBreakController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                    onSubmitted: (value) {
                      final intValue = int.tryParse(value) ?? 15;
                      viewModel.setDuration(PomodoroSessionType.longBreak, intValue * 60);
                    },
                  ),
                ),
                const Text(' min'),
              ],
            ),

            const SizedBox(height: 40),
            const Text('Choix du son d’alerte', style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: viewModel.selectedSound,
              items: viewModel.availableSounds.map((soundPath) {
                final name = soundPath.split('/').last;
                return DropdownMenuItem(
                  value: soundPath,
                  child: Text(name),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  viewModel.setSelectedSound(value);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
