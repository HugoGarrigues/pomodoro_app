import 'package:flutter/foundation.dart';
import 'pomodoro_timer.dart';

class PomodoroSessionRecord {
  final PomodoroSessionType sessionType;
  final DateTime startTime;
  final DateTime endTime;

  PomodoroSessionRecord({
    required this.sessionType,
    required this.startTime,
    required this.endTime,
  });

  Duration get duration => endTime.difference(startTime);
}
