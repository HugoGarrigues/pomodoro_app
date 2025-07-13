import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/pomodoro_viewmodel.dart';
import '../models/pomodoro_timer.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Durées des sessions',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),
            _DurationSetting(
              title: 'Session de travail',
              sessionType: PomodoroSessionType.work,
              icon: Icons.work,
            ),
            SizedBox(height: 16),
            _DurationSetting(
              title: 'Pause courte',
              sessionType: PomodoroSessionType.shortBreak,
              icon: Icons.free_breakfast,
            ),
            SizedBox(height: 16),
            _DurationSetting(
              title: 'Pause longue',
              sessionType: PomodoroSessionType.longBreak,
              icon: Icons.hotel,
            ),
          ],
        ),
      ),
    );
  }
}

class _DurationSetting extends StatefulWidget {
  final String title;
  final PomodoroSessionType sessionType;
  final IconData icon;

  const _DurationSetting({
    required this.title,
    required this.sessionType,
    required this.icon,
  });

  @override
  State<_DurationSetting> createState() => _DurationSettingState();
}

class _DurationSettingState extends State<_DurationSetting> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int _getCurrentDuration(PomodoroViewModel viewModel) {
    switch (widget.sessionType) {
      case PomodoroSessionType.work:
        return viewModel.workDuration ~/ 60;
      case PomodoroSessionType.shortBreak:
        return viewModel.shortBreakDuration ~/ 60;
      case PomodoroSessionType.longBreak:
        return viewModel.longBreakDuration ~/ 60;
    }
  }

  Future<void> _updateDuration(PomodoroViewModel viewModel, int minutes) async {
    switch (widget.sessionType) {
      case PomodoroSessionType.work:
        await viewModel.setWorkDuration(minutes);
        break;
      case PomodoroSessionType.shortBreak:
        await viewModel.setShortBreakDuration(minutes);
        break;
      case PomodoroSessionType.longBreak:
        await viewModel.setLongBreakDuration(minutes);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PomodoroViewModel>();
    final currentMinutes = _getCurrentDuration(viewModel);
    
    // Mettre à jour le contrôleur si nécessaire
    if (_controller.text != currentMinutes.toString()) {
      _controller.text = currentMinutes.toString();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(widget.icon, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '$currentMinutes minutes',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 80,
              child: TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  suffixText: 'min',
                ),
                onSubmitted: (value) {
                  final minutes = int.tryParse(value);
                  if (minutes != null && minutes > 0 && minutes <= 120) {
                    _updateDuration(viewModel, minutes);
                  } else {
                    // Remettre la valeur précédente si invalide
                    _controller.text = currentMinutes.toString();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Veuillez entrer une valeur entre 1 et 120 minutes'),
                      ),
                    );
                  }
                },
              ),
            ),
            const SizedBox(width: 8),
            Column(
              children: [
                IconButton(
                  onPressed: () {
                    final newValue = currentMinutes + 1;
                    if (newValue <= 120) {
                      _updateDuration(viewModel, newValue);
                    }
                  },
                  icon: const Icon(Icons.keyboard_arrow_up),
                  iconSize: 20,
                ),
                IconButton(
                  onPressed: () {
                    final newValue = currentMinutes - 1;
                    if (newValue >= 1) {
                      _updateDuration(viewModel, newValue);
                    }
                  },
                  icon: const Icon(Icons.keyboard_arrow_down),
                  iconSize: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}