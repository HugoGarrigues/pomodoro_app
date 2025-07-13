import 'dart:async';
import 'package:flutter/material.dart';
import '../models/pomodoro_timer.dart';

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

class PomodoroViewModel extends ChangeNotifier {
  PomodoroTimer _timer;
  Timer? _ticker;
  DateTime? _sessionStartTime;
  final List<PomodoroSessionRecord> _history = [];

  // Durées personnalisables en secondes (par défaut 25/5/15)
  int workDuration = 25 * 60;
  int shortBreakDuration = 5 * 60;
  int longBreakDuration = 15 * 60;

  PomodoroViewModel()
      : _timer = PomodoroTimer(
          totalSeconds: 25 * 60,
          remainingSeconds: 25 * 60,
          sessionType: PomodoroSessionType.work,
          isRunning: false,
        );

  PomodoroTimer get timer => _timer;
  List<PomodoroSessionRecord> get history => List.unmodifiable(_history);

  // Getters demandés pour pomodoro_page.dart
  PomodoroSessionType get currentSessionType => _timer.sessionType;

  int get remaining => _timer.remainingSeconds;

  bool get isRunning => _timer.isRunning;

  void start() {
    if (_timer.isRunning) return;

    _sessionStartTime ??= DateTime.now();

    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timer.remainingSeconds > 0) {
        _timer = PomodoroTimer(
          totalSeconds: _timer.totalSeconds,
          remainingSeconds: _timer.remainingSeconds - 1,
          sessionType: _timer.sessionType,
          isRunning: true,
        );
        notifyListeners();
      } else {
        _endSession();
      }
    });
    notifyListeners();
  }

  void pause() {
    _ticker?.cancel();
    _timer = PomodoroTimer(
      totalSeconds: _timer.totalSeconds,
      remainingSeconds: _timer.remainingSeconds,
      sessionType: _timer.sessionType,
      isRunning: false,
    );
    notifyListeners();
  }

  void reset() {
    _ticker?.cancel();
    _timer = PomodoroTimer(
      totalSeconds: _getSessionDuration(_timer.sessionType),
      remainingSeconds: _getSessionDuration(_timer.sessionType),
      sessionType: _timer.sessionType,
      isRunning: false,
    );
    _sessionStartTime = null;
    notifyListeners();
  }

  void changeSession(PomodoroSessionType type) {
    _ticker?.cancel();
    _timer = PomodoroTimer(
      totalSeconds: _getSessionDuration(type),
      remainingSeconds: _getSessionDuration(type),
      sessionType: type,
      isRunning: false,
    );
    _sessionStartTime = null;
    notifyListeners();
  }

  int _getSessionDuration(PomodoroSessionType type) {
    switch (type) {
      case PomodoroSessionType.work:
        return workDuration;
      case PomodoroSessionType.shortBreak:
        return shortBreakDuration;
      case PomodoroSessionType.longBreak:
        return longBreakDuration;
    }
  }

  void _endSession() {
    _ticker?.cancel();

    final endTime = DateTime.now();
    if (_sessionStartTime != null) {
      _history.add(
        PomodoroSessionRecord(
          sessionType: _timer.sessionType,
          startTime: _sessionStartTime!,
          endTime: endTime,
        ),
      );
    }

    _sessionStartTime = null;

    _timer = PomodoroTimer(
      totalSeconds: _getSessionDuration(_timer.sessionType),
      remainingSeconds: 0,
      sessionType: _timer.sessionType,
      isRunning: false,
    );
    notifyListeners();

    // TODO: ajouter son et alertes ici plus tard
  }

  // Méthode pour modifier la durée selon le type
  void setDuration(PomodoroSessionType type, int seconds) {
    switch (type) {
      case PomodoroSessionType.work:
        workDuration = seconds;
        break;
      case PomodoroSessionType.shortBreak:
        shortBreakDuration = seconds;
        break;
      case PomodoroSessionType.longBreak:
        longBreakDuration = seconds;
        break;
    }
    // Reset si session courante modifiée
    if (_timer.sessionType == type) {
      reset();
    }
    notifyListeners();
  }
}
