import 'dart:async';
import 'package:flutter/material.dart';
import '../models/pomodoro_timer.dart';

class PomodoroViewModel extends ChangeNotifier {
  Timer? _timer;
  late PomodoroTimer _timerModel;

  PomodoroViewModel()
      : _timerModel = PomodoroTimer(
          totalSeconds: _durationFor(PomodoroSessionType.work),
          remainingSeconds: _durationFor(PomodoroSessionType.work),
          sessionType: PomodoroSessionType.work,
        );

  PomodoroTimer get timer => _timerModel;

  void start() {
    if (_timer != null && _timer!.isActive) return;

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_timerModel.remainingSeconds > 0) {
        _timerModel = PomodoroTimer(
          totalSeconds: _timerModel.totalSeconds,
          remainingSeconds: _timerModel.remainingSeconds - 1,
          sessionType: _timerModel.sessionType,
          isRunning: true,
        );
        notifyListeners();
      } else {
        stop();
      }
    });
  }

  void pause() {
    _timer?.cancel();
    _timerModel = PomodoroTimer(
      totalSeconds: _timerModel.totalSeconds,
      remainingSeconds: _timerModel.remainingSeconds,
      sessionType: _timerModel.sessionType,
      isRunning: false,
    );
    notifyListeners();
  }

  void reset() {
    _timer?.cancel();
    final duration = _durationFor(_timerModel.sessionType);
    _timerModel = PomodoroTimer(
      totalSeconds: duration,
      remainingSeconds: duration,
      sessionType: _timerModel.sessionType,
      isRunning: false,
    );
    notifyListeners();
  }

  void stop() {
    _timer?.cancel();
    _timerModel = PomodoroTimer(
      totalSeconds: _timerModel.totalSeconds,
      remainingSeconds: 0,
      sessionType: _timerModel.sessionType,
      isRunning: false,
    );
    notifyListeners();
  }

  void changeSession(PomodoroSessionType type) {
    _timer?.cancel();
    final duration = _durationFor(type);
    _timerModel = PomodoroTimer(
      totalSeconds: duration,
      remainingSeconds: duration,
      sessionType: type,
      isRunning: false,
    );
    notifyListeners();
  }

  static int _durationFor(PomodoroSessionType type) {
    switch (type) {
      case PomodoroSessionType.work:
        return 25 * 60;
      case PomodoroSessionType.shortBreak:
        return 5 * 60;
      case PomodoroSessionType.longBreak:
        return 15 * 60;
    }
  }
}
