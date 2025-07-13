import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/pomodoro_timer.dart';
import '../models/pomodoro_session_record.dart';
import '../services/notification_service.dart';

class PomodoroViewModel extends ChangeNotifier {
  PomodoroTimer _timer;
  Timer? _ticker;
  DateTime? _sessionStartTime;
  final List<PomodoroSessionRecord> _history = [];
  final NotificationService _notificationService = NotificationService();

  // Durées par défaut en secondes
  int _workDuration = 25 * 60;
  int _shortBreakDuration = 5 * 60;
  int _longBreakDuration = 15 * 60;

  PomodoroViewModel()
      : _timer = PomodoroTimer(
          totalSeconds: 25 * 60,
          remainingSeconds: 25 * 60,
          sessionType: PomodoroSessionType.work,
          isRunning: false,
        ) {
    _loadSettings();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    try {
      await _notificationService.initialize();
    } catch (e) {
      // En cas d'erreur d'initialisation des notifications, on continue sans
      debugPrint('Erreur lors de l\'initialisation des notifications: $e');
    }
  }

  // Getters
  PomodoroTimer get timer => _timer;
  List<PomodoroSessionRecord> get history => List.unmodifiable(_history);
  int get workDuration => _workDuration;
  int get shortBreakDuration => _shortBreakDuration;
  int get longBreakDuration => _longBreakDuration;

  // Méthodes de contrôle du timer
  void start() {
    if (_timer.isRunning) return;

    _sessionStartTime ??= DateTime.now();

    _timer = PomodoroTimer(
      totalSeconds: _timer.totalSeconds,
      remainingSeconds: _timer.remainingSeconds,
      sessionType: _timer.sessionType,
      isRunning: true,
    );

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

  // Méthodes de configuration
  Future<void> setWorkDuration(int minutes) async {
    _workDuration = minutes * 60;
    await _saveSettings();
    if (_timer.sessionType == PomodoroSessionType.work) {
      reset();
    }
    notifyListeners();
  }

  Future<void> setShortBreakDuration(int minutes) async {
    _shortBreakDuration = minutes * 60;
    await _saveSettings();
    if (_timer.sessionType == PomodoroSessionType.shortBreak) {
      reset();
    }
    notifyListeners();
  }

  Future<void> setLongBreakDuration(int minutes) async {
    _longBreakDuration = minutes * 60;
    await _saveSettings();
    if (_timer.sessionType == PomodoroSessionType.longBreak) {
      reset();
    }
    notifyListeners();
  }

  // Méthodes privées
  int _getSessionDuration(PomodoroSessionType type) {
    switch (type) {
      case PomodoroSessionType.work:
        return _workDuration;
      case PomodoroSessionType.shortBreak:
        return _shortBreakDuration;
      case PomodoroSessionType.longBreak:
        return _longBreakDuration;
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

      // Envoyer la notification de fin de session
      _sendSessionCompleteNotification();
    }

    _sessionStartTime = null;

    _timer = PomodoroTimer(
      totalSeconds: _getSessionDuration(_timer.sessionType),
      remainingSeconds: 0,
      sessionType: _timer.sessionType,
      isRunning: false,
    );
    notifyListeners();
  }

  Future<void> _sendSessionCompleteNotification() async {
    try {
      await _notificationService.showSessionCompleteNotification(_timer.sessionType);
    } catch (e) {
      // En cas d'erreur, on continue sans notification
      debugPrint('Erreur lors de l\'envoi de la notification: $e');
    }
  }

  // Sauvegarde et chargement des paramètres
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('work_duration', _workDuration ~/ 60);
    await prefs.setInt('short_break_duration', _shortBreakDuration ~/ 60);
    await prefs.setInt('long_break_duration', _longBreakDuration ~/ 60);
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _workDuration = (prefs.getInt('work_duration') ?? 25) * 60;
    _shortBreakDuration = (prefs.getInt('short_break_duration') ?? 5) * 60;
    _longBreakDuration = (prefs.getInt('long_break_duration') ?? 15) * 60;
    
    // Mettre à jour le timer actuel si nécessaire
    _timer = PomodoroTimer(
      totalSeconds: _getSessionDuration(_timer.sessionType),
      remainingSeconds: _getSessionDuration(_timer.sessionType),
      sessionType: _timer.sessionType,
      isRunning: false,
    );
    notifyListeners();
  }

  String formatDuration(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _notificationService.cancelAllNotifications();
    super.dispose();
  }
}