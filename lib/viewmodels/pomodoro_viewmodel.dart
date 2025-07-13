// lib/viewmodels/pomodoro_viewmodel.dart

import 'dart:async';

import 'package:flutter/material.dart';
import '../models/pomodoro_timer.dart';

class PomodoroViewModel extends ChangeNotifier {
  late PomodoroTimer _timer;
  PomodoroTimer get timer => _timer;

  DateTime? _sessionStartTime;
  final List<PomodoroSessionRecord> _history = [];
  List<PomodoroSessionRecord> get history => List.unmodifiable(_history);

  Timer? _ticker;

  PomodoroViewModel() {
    // Initialise avec session work de 25 minutes
    _timer = PomodoroTimer(
      totalSeconds: 25 * 60,
      remainingSeconds: 25 * 60,
      sessionType: PomodoroSessionType.work,
    );
  }

  void start() {
    if (_timer.isRunning) return;

    _sessionStartTime ??= DateTime.now();

    _timer = _timer.copyWith(isRunning: true);
    notifyListeners();

    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_timer.remainingSeconds > 0) {
        _timer = _timer.copyWith(remainingSeconds: _timer.remainingSeconds - 1);
        notifyListeners();
      } else {
        _endSession();
      }
    });
  }

  void pause() {
    if (!_timer.isRunning) return;

    _ticker?.cancel();
    _timer = _timer.copyWith(isRunning: false);
    notifyListeners();
  }

  void reset() {
    _ticker?.cancel();
    _sessionStartTime = null;
    _timer = PomodoroTimer(
      totalSeconds: _getSessionDuration(_timer.sessionType),
      remainingSeconds: _getSessionDuration(_timer.sessionType),
      sessionType: _timer.sessionType,
      isRunning: false,
    );
    notifyListeners();
  }

  void changeSession(PomodoroSessionType sessionType) {
    _ticker?.cancel();
    _sessionStartTime = null;
    _timer = PomodoroTimer(
      totalSeconds: _getSessionDuration(sessionType),
      remainingSeconds: _getSessionDuration(sessionType),
      sessionType: sessionType,
      isRunning: false,
    );
    notifyListeners();
  }

  int _getSessionDuration(PomodoroSessionType type) {
    switch (type) {
      case PomodoroSessionType.work:
        return 25 * 60;
      case PomodoroSessionType.shortBreak:
        return 5 * 60;
      case PomodoroSessionType.longBreak:
        return 1;
    }
  }

  void _endSession() {
    _ticker?.cancel();

    // Enregistre la session dans l'historique
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

    // Reset le timer et stop
    _timer = PomodoroTimer(
      totalSeconds: _getSessionDuration(_timer.sessionType),
      remainingSeconds: 0,
      sessionType: _timer.sessionType,
      isRunning: false,
    );
    notifyListeners();
  }
}
