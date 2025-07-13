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
    required this.isRunning,
  });
}
