import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/pomodoro_viewmodel.dart';
import '../models/pomodoro_timer.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PomodoroViewModel>();
    final history = viewModel.history;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique des sessions'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: history.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Aucune session terminée',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Complétez votre première session pour voir l\'historique',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : Column(
              children: [
                _HistoryStats(history: history),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      final record = history[history.length - 1 - index]; // Plus récent en premier
                      return _HistoryItem(record: record);
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

class _HistoryStats extends StatelessWidget {
  final List history;

  const _HistoryStats({required this.history});

  @override
  Widget build(BuildContext context) {
    final workSessions = history.where((r) => r.sessionType == PomodoroSessionType.work).length;
    final breakSessions = history.length - workSessions;
    final totalTime = history.fold<Duration>(
      Duration.zero,
      (sum, record) => sum + record.duration,
    );

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Statistiques',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(
                  icon: Icons.work,
                  label: 'Sessions de travail',
                  value: workSessions.toString(),
                  color: Colors.red,
                ),
                _StatItem(
                  icon: Icons.free_breakfast,
                  label: 'Sessions de pause',
                  value: breakSessions.toString(),
                  color: Colors.green,
                ),
                _StatItem(
                  icon: Icons.timer,
                  label: 'Temps total',
                  value: '${totalTime.inHours}h ${totalTime.inMinutes % 60}m',
                  color: Colors.blue,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _HistoryItem extends StatelessWidget {
  final dynamic record;

  const _HistoryItem({required this.record});

  IconData _getIconForSessionType(PomodoroSessionType type) {
    switch (type) {
      case PomodoroSessionType.work:
        return Icons.work;
      case PomodoroSessionType.shortBreak:
        return Icons.free_breakfast;
      case PomodoroSessionType.longBreak:
        return Icons.hotel;
    }
  }

  Color _getColorForSessionType(PomodoroSessionType type) {
    switch (type) {
      case PomodoroSessionType.work:
        return Colors.red;
      case PomodoroSessionType.shortBreak:
      case PomodoroSessionType.longBreak:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColorForSessionType(record.sessionType);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(
            _getIconForSessionType(record.sessionType),
            color: color,
          ),
        ),
        title: Text(
          record.sessionType.displayName,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(record.formattedStartTime),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            record.formattedDuration,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            ),
          ),
        ),
      ),
    );
  }
}