import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeNotifications();
  scheduleNotification(); // Não usar await para não bloquear main
  runApp(const MyApp());
}

Future<void> initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('ic_notification'); // Ícone da notificação

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    // Sem onSelectNotification para não abrir app ao clicar
  );
}

void scheduleNotification() {
  const androidDetails = AndroidNotificationDetails(
    'kanji_channel',
    'Kanji Diário',
    channelDescription: 'Notificações recorrentes para revisar kanji',
    importance: Importance.max,
    priority: Priority.high,
    visibility: NotificationVisibility.public,
    icon: 'ic_notification',
    styleInformation: BigTextStyleInformation(
      'Leitura: かん\nSignificado: Emoção, sentimento',
      contentTitle: '【感】',
      summaryText: 'Kanji do dia',
    ),
  );

  const platformDetails = NotificationDetails(android: androidDetails);

  // Mostra imediatamente a primeira notificação
  flutterLocalNotificationsPlugin.show(
    0,
    '【感】',
    'Leitura: かん\nSignificado: Emoção, sentimento',
    platformDetails,
  );

  // Agendamento com Timer para repetir a notificação a cada 1 minuto
  Timer.periodic(const Duration(minutes: 1), (Timer timer) async {
    await flutterLocalNotificationsPlugin.show(
      0,
      '【感】',
      'Leitura: かん\nSignificado: Emoção, sentimento',
      platformDetails,
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(child: Text('Rodando em background...')),
      ),
    );
  }
}
