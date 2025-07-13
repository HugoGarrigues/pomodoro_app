import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/pomodoro_viewmodel.dart';
import 'pomodoro_history_page.dart';
import '../models/pomodoro_timer.dart';

class PomodoroPage extends StatefulWidget {
  const PomodoroPage({super.key});

  @override
  State<PomodoroPage> createState() => _PomodoroPageState();
}

class _PomodoroPageState extends State<PomodoroPage> {
  final TextEditingController _workController = TextEditingController();
  final TextEditingController _shortBreakController = TextEditingController();
  final TextEditingController _longBreakController = TextEditingController();

  @override
  void dispose() {
    _workController.dispose();
    _shortBreakController.dispose();
    _longBreakController.dispose();
    super.dispose();
  }

  String formatDuration(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PomodoroViewModel>();
    final timer = viewModel.timer;

    _workController.text = (viewModel.workDuration ~/ 60).toString();
    _shortBreakController.text = (viewModel.shortBreakDuration ~/ 60).toString();
    _longBreakController.text = (viewModel.longBreakDuration ~/ 60).toString();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pomodoro Timer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Historique',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const PomodoroHistoryPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              timer.sessionType.name.toUpperCase(),
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(height: 20),
            Text(
              formatDuration(timer.remainingSeconds),
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: timer.isRunning ? viewModel.pause : viewModel.start,
                  child: Text(timer.isRunning ? 'Pause' : 'Start'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: viewModel.reset,
                  child: const Text('Reset'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 8,
              children: PomodoroSessionType.values.map((type) {
                return ChoiceChip(
                  label: Text(type.name.toUpperCase()),
                  selected: timer.sessionType == type,
                  onSelected: (_) => viewModel.changeSession(type),
                );
              }).toList(),
            ),
            const Divider(height: 40),
            const Text(
              'Modifier les durées (minutes)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildDurationField(
              label: 'Travail',
              controller: _workController,
              onSubmitted: (value) {
                final mins = int.tryParse(value);
                if (mins != null && mins > 0) {
                  viewModel.setDuration(PomodoroSessionType.work, mins * 60);
                }
              },
            ),
            _buildDurationField(
              label: 'Pause courte',
              controller: _shortBreakController,
              onSubmitted: (value) {
                final mins = int.tryParse(value);
                if (mins != null && mins > 0) {
                  viewModel.setDuration(PomodoroSessionType.shortBreak, mins * 60);
                }
              },
            ),
            _buildDurationField(
              label: 'Pause longue',
              controller: _longBreakController,
              onSubmitted: (value) {
                final mins = int.tryParse(value);
                if (mins != null && mins > 0) {
                  viewModel.setDuration(PomodoroSessionType.longBreak, mins * 60);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDurationField({
    required String label,
    required TextEditingController controller,
    required Function(String) onSubmitted,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(width: 120, child: Text(label)),
          Expanded(
            child: TextField(
              keyboardType: TextInputType.number,
              controller: controller,
              onSubmitted: onSubmitted,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
