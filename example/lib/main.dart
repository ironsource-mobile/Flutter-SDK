import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import './app_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeService();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: AppScreen());
  }
}

Future<void> initializeService() async {
  if (!Platform.isAndroid) return;

  final service = FlutterBackgroundService();
  service.invoke("stopService");

  /// OPTIONAL, using custom notification channel id
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'bitbunny_foreground', // id
    '걸음수보다 더 크게 수익 쌓는 앱테크',
    description: '걸음수보다 더 크게 수익 쌓는 앱테크', // description
    importance: Importance.low, // importance must be at low or higher level
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(
      iOS: DarwinInitializationSettings(),
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    ),
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: true,

      notificationChannelId: 'bitbunny_foreground',
      initialNotificationTitle: '걸음수보다 더 크게 수익 쌓는 앱테크',
      initialNotificationContent: '오늘의 걸음수 : -',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,

      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,
      // you have to enable background fetch capability on xcode project
      // onBackground: onIosBackground,
    ),
  );

  service.startService();
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  //
  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  // if (service is AndroidServiceInstance) {
  //   DailyPedometer pedometer = await DailyPedometer.create();
  //   pedometer.setMode(true);
  //   pedometer.stepCountStream.listen((event) async {
  //     // 여기서 push 처리 하는게 더 좋지만 현재는 백그라운드 제어 불가능..
  //   });

  //   // bring to foreground
  //   Timer.periodic(const Duration(seconds: 1), (timer) async {
  //     if (await service.isForegroundService()) {
  //       int step = pedometer.steps;

  //       // if you don't using custom notification, uncomment this
  //       service.setForegroundNotificationInfo(
  //         title: '걸음수보다 더 크게 수익 쌓는 앱테크',
  //         content: '오늘의 걸음수 : $step',
  //       );
  //     }
  //   });
  // }
}
