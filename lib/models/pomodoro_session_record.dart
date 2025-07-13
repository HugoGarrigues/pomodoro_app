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
  
  String get formattedDuration {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
  
  String get formattedStartTime {
    return '${startTime.day}/${startTime.month}/${startTime.year} ${startTime.hour}:${startTime.minute.toString().padLeft(2, '0')}';
  }
}