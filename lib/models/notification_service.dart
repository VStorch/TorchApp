import 'dart:ui';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
  FlutterLocalNotificationsPlugin();

  static bool _initialized = false;

  // Inicializar o serviço de notificações
  static Future<void> initialize() async {
    if (_initialized) return;

    // Usa o ícone padrão do app (SEM ERROS)
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        print('Notificação tocada: ${details.payload}');
      },
    );

    _initialized = true;

    // Permissão no Android 13+
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  // Verificar se as notificações estão habilitadas nas preferências
  static Future<bool> _areNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    final notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
    final newAppointmentsEnabled =
        prefs.getBool('notify_new_appointments') ?? true;

    return notificationsEnabled && newAppointmentsEnabled;
  }

  // 🔔 Notificação: Novo agendamento pendente
  static Future<void> showNewAppointmentNotification({
    required String clientName,
    required String petName,
    required String serviceName,
    required String date,
    required String time,
  }) async {
    if (!await _areNotificationsEnabled()) {
      print('Notificações desabilitadas nas configurações');
      return;
    }

    const androidDetails = AndroidNotificationDetails(
      'new_appointments',
      'Novos Agendamentos',
      channelDescription: 'Notificações de novos agendamentos pendentes',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher', // ÍCONE PADRÃO DO APP
      color: Color(0xFFF4E04D),
      playSound: true,
      enableVibration: true,
      enableLights: true,
      ledColor: Color(0xFFF4E04D),
      ledOnMs: 1000,
      ledOffMs: 500,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'default',
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      '🐾 Novo Agendamento Pendente!',
      '$clientName agendou $serviceName para $petName\n📅 $date às $time',
      details,
      payload: 'new_appointment',
    );
  }

  static Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }

  static Future<void> cancel(int id) async {
    await _notifications.cancel(id);
  }
}
