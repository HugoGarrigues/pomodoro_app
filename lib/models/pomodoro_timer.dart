// lib/models/pomodoro_timer.dart

enum PomodoroSessionType { work, shortBreak, longBreak }

class PomodoroTimer {
  final int totalSeconds;
  final int remainingSeconds;
  final PomodoroSessionType sessionType;
  final bool isRunning;

  PomodoroTimer({
    required this.totalSeconds,
    required this.remainingSeconds,
    required this.sessionType,
    this.isRunning = false,
  });

  PomodoroTimer copyWith({
    int? totalSeconds,
    int? remainingSeconds,
    PomodoroSessionType? sessionType,
    bool? isRunning,
  }) {
    return PomodoroTimer(
      totalSeconds: totalSeconds ?? this.totalSeconds,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      sessionType: sessionType ?? this.sessionType,
      isRunning: isRunning ?? this.isRunning,
    );
  }
}

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
