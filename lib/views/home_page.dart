import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/pomodoro_viewmodel.dart';
import '../models/pomodoro_timer.dart';
import '../services/supabase_service.dart';
import 'login_page.dart';
import 'settings_page.dart';
import 'history_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _logout(BuildContext context) async {
    await SupabaseService.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pomodoro Timer'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Historique',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const HistoryPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Paramètres',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SettingsPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Déconnexion',
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _SessionTypeSelector(),
              SizedBox(height: 40),
              _TimerDisplay(),
              SizedBox(height: 40),
              _TimerControls(),
            ],
          ),
        ),
      ),
    );
  }
}

class _SessionTypeSelector extends StatelessWidget {
  const _SessionTypeSelector();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PomodoroViewModel>();
    final currentType = viewModel.timer.sessionType;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Type de session',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: PomodoroSessionType.values.map((type) {
                return ChoiceChip(
                  label: Text(type.displayName),
                  selected: currentType == type,
                  onSelected: viewModel.timer.isRunning
                      ? null
                      : (_) => viewModel.changeSession(type),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimerDisplay extends StatelessWidget {
  const _TimerDisplay();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PomodoroViewModel>();
    final timer = viewModel.timer;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Text(
              timer.sessionType.displayName.toUpperCase(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              viewModel.formatDuration(timer.remainingSeconds),
              style: const TextStyle(
                fontSize: 72,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: timer.totalSeconds > 0
                  ? (timer.totalSeconds - timer.remainingSeconds) /
                      timer.totalSeconds
                  : 0,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                timer.sessionType == PomodoroSessionType.work
                    ? Colors.red
                    : Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimerControls extends StatelessWidget {
  const _TimerControls();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PomodoroViewModel>();
    final timer = viewModel.timer;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: timer.isRunning ? viewModel.pause : viewModel.start,
              icon: Icon(timer.isRunning ? Icons.pause : Icons.play_arrow),
              label: Text(timer.isRunning ? 'Pause' : 'Start'),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
            ElevatedButton.icon(
              onPressed: viewModel.reset,
              icon: const Icon(Icons.refresh),
              label: const Text('Reset'),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
