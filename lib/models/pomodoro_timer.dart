enum PomodoroSessionType { 
  work, 
  shortBreak, 
  longBreak;
  
  String get displayName {
    switch (this) {
      case PomodoroSessionType.work:
        return 'Travail';
      case PomodoroSessionType.shortBreak:
        return 'Pause courte';
      case PomodoroSessionType.longBreak:
        return 'Pause longue';
    }
  }
}

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