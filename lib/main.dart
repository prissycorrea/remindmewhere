import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:remindmewhere/home_page.dart';
import 'create_reminder_page.dart';
import 'profile_page.dart';
import 'package:remindmewhere/services/location_service.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RemindMeWhere',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: HomePage(),
      routes: {
        '/create': (context) => const CreateReminderPage(),
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}

class TestLocationPage extends StatefulWidget {
  const TestLocationPage({super.key});

  @override
  State<TestLocationPage> createState() => _TestLocationPageState();
}

class _TestLocationPageState extends State<TestLocationPage> {
  Position? _position;

  @override
  void initState() {
    super.initState();
    initLocation();
  }

  Future<void> initLocation() async {
    final permissionGranted = await LocationService.checkPermissions();
    if (!permissionGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permissões não concedidas')),
      );
      return;
    }

    LocationService.getPositionStream().listen((position) {
      setState(() {
        _position = position;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Monitoramento de Localização")),
      body: Center(
        child:
            _position == null
                ? const CircularProgressIndicator()
                : Text(
                  'Lat: ${_position!.latitude}, Long: ${_position!.longitude}',
                  style: const TextStyle(fontSize: 16),
                ),
      ),
    );
  }
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> showReminderNotification(String title) async {
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'reminder_channel',
    'Lembretes',
    importance: Importance.max,
    priority: Priority.high,
  );

  const NotificationDetails platformDetails = NotificationDetails(
    android: androidDetails,
  );

  await flutterLocalNotificationsPlugin.show(
    0,
    'Você está próximo!',
    title,
    platformDetails,
  );
}
