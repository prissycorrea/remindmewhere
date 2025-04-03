import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:latlong2/latlong.dart';

class LocationMonitorService {
  final List<Map<String, dynamic>> reminders;
  final Function onReminderTriggered;

  StreamSubscription<Position>? _positionStream;

  LocationMonitorService({
    required this.reminders,
    required this.onReminderTriggered,
  });

  void startMonitoring() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Serviço de localização desabilitado');
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        print('Permissão negada');
        return;
      }
    }

    _positionStream?.cancel();
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((position) {
      final currentLocation = LatLng(position.latitude, position.longitude);
      _checkProximity(currentLocation);
    });
  }

  void _checkProximity(LatLng currentLocation) {
    final distanceCalc = Distance();

    for (var reminder in reminders) {
      if (reminder['done'] == true) continue;

      final LatLng target = LatLng(
        reminder['location_lat'],
        reminder['location_lng'],
      );
      final distance = distanceCalc(currentLocation, target);

      if (distance <= reminder['distance']) {
        onReminderTriggered(reminder);
      }
    }
  }

  void stopMonitoring() {
    _positionStream?.cancel();
  }
}
