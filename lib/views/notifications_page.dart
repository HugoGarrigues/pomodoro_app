import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/pomodoro_viewmodel.dart';
import '../services/notification_service.dart';
import '../models/pomodoro_timer.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Gestion des notifications',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),
            _NotificationInfo(),
            SizedBox(height: 24),
            _TestNotifications(),
          ],
        ),
      ),
    );
  }
}

class _NotificationInfo extends StatelessWidget {
  const _NotificationInfo();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue[600]),
                const SizedBox(width: 8),
                const Text(
                  'À propos des notifications',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Les notifications vous alertent automatiquement à la fin de chaque session Pomodoro :',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            const _NotificationTypeItem(
              icon: Icons.work,
              title: 'Fin de session de travail',
              description: 'Vous rappelle de prendre une pause',
              color: Colors.red,
            ),
            const SizedBox(height: 8),
            const _NotificationTypeItem(
              icon: Icons.free_breakfast,
              title: 'Fin de pause courte',
              description: 'Vous invite à reprendre le travail',
              color: Colors.green,
            ),
            const SizedBox(height: 8),
            const _NotificationTypeItem(
              icon: Icons.hotel,
              title: 'Fin de pause longue',
              description: 'Vous encourage à commencer un nouveau cycle',
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationTypeItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const _NotificationTypeItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                description,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TestNotifications extends StatelessWidget {
  const _TestNotifications();

  @override
  Widget build(BuildContext context) {
    final notificationService = NotificationService();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.science, color: Colors.orange[600]),
                const SizedBox(width: 8),
                const Text(
                  'Tester les notifications',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Testez les différents types de notifications pour vous assurer qu\'elles fonctionnent correctement :',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    await notificationService.showSessionCompleteNotification(
                      PomodoroSessionType.work,
                    );
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Notification de fin de travail envoyée'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.work, size: 16),
                  label: const Text('Travail'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[50],
                    foregroundColor: Colors.red[700],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    await notificationService.showSessionCompleteNotification(
                      PomodoroSessionType.shortBreak,
                    );
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Notification de fin de pause courte envoyée'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.free_breakfast, size: 16),
                  label: const Text('Pause courte'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[50],
                    foregroundColor: Colors.green[700],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    await notificationService.showSessionCompleteNotification(
                      PomodoroSessionType.longBreak,
                    );
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Notification de fin de pause longue envoyée'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.hotel, size: 16),
                  label: const Text('Pause longue'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[50],
                    foregroundColor: Colors.blue[700],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}