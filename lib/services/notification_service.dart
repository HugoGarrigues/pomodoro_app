import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import '../models/pomodoro_timer.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const macosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
      macOS: macosSettings,
    );

    await _notifications.initialize(initSettings);
    _isInitialized = true;

    // Demander les permissions sur Android 13+
    if (defaultTargetPlatform == TargetPlatform.android) {
      await _requestAndroidPermissions();
    }
  }

  Future<void> _requestAndroidPermissions() async {
    final androidPlugin = _notifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      await androidPlugin.requestNotificationsPermission();
    }
  }

  Future<void> showSessionCompleteNotification(PomodoroSessionType sessionType) async {
    if (!_isInitialized) {
      await initialize();
    }

    final (title, body) = _getNotificationContent(sessionType);

    const androidDetails = AndroidNotificationDetails(
      'pomodoro_session',
      'Session Pomodoro',
      channelDescription: 'Notifications pour les sessions Pomodoro terminées',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      enableVibration: true,
      playSound: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'default',
    );

    const macosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'default',
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
      macOS: macosDetails,
    );

    await _notifications.show(
      sessionType.index,
      title,
      body,
      notificationDetails,
    );
  }

  (String, String) _getNotificationContent(PomodoroSessionType sessionType) {
    switch (sessionType) {
      case PomodoroSessionType.work:
        return (
          '🍅 Session de travail terminée !',
          'Félicitations ! Il est temps de prendre une pause bien méritée.'
        );
      case PomodoroSessionType.shortBreak:
        return (
          '☕ Pause courte terminée !',
          'C\'est reparti ! Prêt pour une nouvelle session de travail ?'
        );
      case PomodoroSessionType.longBreak:
        return (
          '🛌 Pause longue terminée !',
          'Vous êtes reposé ! Temps de reprendre le travail avec énergie.'
        );
    }
  }

  Future<void> cancelAllNotifications() async {
    if (_isInitialized) {
      await _notifications.cancelAll();
    }
  }
}