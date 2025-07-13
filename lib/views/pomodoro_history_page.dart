import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/pomodoro_viewmodel.dart';
import '../models/pomodoro_timer.dart';

class PomodoroHistoryPage extends StatelessWidget {
  const PomodoroHistoryPage({super.key});

  String formatDuration(Duration d) {
    final minutes = d.inMinutes.toString().padLeft(2, '0');
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final history = context.watch<PomodoroViewModel>().history;

    return Scaffold(
      appBar: AppBar(title: const Text("Historique des sessions")),
      body: ListView.builder(
        itemCount: history.length,
        itemBuilder: (context, index) {
          final record = history[index];
          return ListTile(
            leading: Icon(_iconForSessionType(record.sessionType)),
            title: Text(record.sessionType.name.toUpperCase()),
            subtitle: Text(
                "Durée: ${formatDuration(record.duration)}\n${record.startTime}"),
            isThreeLine: true,
          );
        },
      ),
    );
  }

  IconData _iconForSessionType(PomodoroSessionType type) {
    switch (type) {
      case PomodoroSessionType.work:
        return Icons.work;
      case PomodoroSessionType.shortBreak:
        return Icons.free_breakfast;
      case PomodoroSessionType.longBreak:
        return Icons.hotel;
    }
  }
}
