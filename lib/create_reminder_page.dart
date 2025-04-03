import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:convert';

class CreateReminderPage extends StatefulWidget {
  final Function(Map<String, dynamic>)? onSave;

  const CreateReminderPage({super.key, this.onSave});

  @override
  State<CreateReminderPage> createState() => _CreateReminderPageState();
}

class _CreateReminderPageState extends State<CreateReminderPage> {
  final TextEditingController _reminderController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final MapController _mapController = MapController();

  final List<int> _distances = [100, 200, 500, 1000];
  int _selectedDistance = 200;

  LatLng _selectedLocation = LatLng(-23.5505, -46.6333); // São Paulo
  List<Map<String, dynamic>> _suggestions = [];
  bool _isLoadingSuggestions = false;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      await Geolocator.requestPermission();
    }
  }

  void _onSearchChanged(String query) async {
    if (query.isEmpty) {
      setState(() => _suggestions = []);
      return;
    }

    setState(() => _isLoadingSuggestions = true);

    final uri = Uri.parse(
      'https://nominatim.openstreetmap.org/search?q=$query&format=json&addressdetails=1&limit=5',
    );

    final response = await http.get(
      uri,
      headers: {'User-Agent': 'remindmewhere/1.0 (your@email.com)'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _suggestions = List<Map<String, dynamic>>.from(data);
        _isLoadingSuggestions = false;
      });
    }
  }

  void _selectSuggestion(Map<String, dynamic> suggestion) {
    final latlng = LatLng(
      double.parse(suggestion['lat']),
      double.parse(suggestion['lon']),
    );

    setState(() {
      _selectedLocation = latlng;
      _searchController.text = suggestion['display_name'];
      _suggestions = [];
    });

    _mapController.move(latlng, 15.0);
  }

  Future<void> _useCurrentLocation() async {
    try {
      final pos = await Geolocator.getCurrentPosition();
      final latlng = LatLng(pos.latitude, pos.longitude);

      List<Placemark> placemarks = await placemarkFromCoordinates(
        latlng.latitude,
        latlng.longitude,
      );

      final place = placemarks.first;
      final address =
          "${place.street}, ${place.subLocality}, ${place.locality} - ${place.administrativeArea}";

      setState(() {
        _selectedLocation = latlng;
        _searchController.text = address;
        _suggestions = [];
      });

      _mapController.move(latlng, 15.0);
    } catch (e) {
      print('Erro ao obter localização atual: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao obter localização atual.')),
      );
    }
  }

  Future<void> _updateAddressFromTap(LatLng point) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        point.latitude,
        point.longitude,
      );

      final place = placemarks.first;
      final address =
          "${place.street}, ${place.subLocality}, ${place.locality} - ${place.administrativeArea}";

      setState(() {
        _selectedLocation = point;
        _searchController.text = address;
        _suggestions = [];
      });

      _mapController.move(point, 15.0);
    } catch (e) {
      print('Erro ao converter ponto em endereço: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: const Text(
          'Novo lembrete',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Me lembre de',
              style: TextStyle(color: Color(0xFF9AC2FF), fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _reminderController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Ex: Comprar pão',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFF2C2C2E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Quando estiver a',
              style: TextStyle(color: Color(0xFF9AC2FF), fontSize: 16),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<int>(
              value: _selectedDistance,
              dropdownColor: const Color(0xFF2C2C2E),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF2C2C2E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: Colors.white),
              iconEnabledColor: Colors.white,
              items:
                  _distances
                      .map(
                        (distance) => DropdownMenuItem(
                          value: distance,
                          child: Text('$distance metros'),
                        ),
                      )
                      .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedDistance = value);
                }
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Do local',
              style: TextStyle(color: Color(0xFF9AC2FF), fontSize: 16),
            ),
            const SizedBox(height: 8),
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    height: 200,
                    child: FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        center: _selectedLocation,
                        zoom: 15.0,
                        onTap:
                            (tapPosition, point) =>
                                _updateAddressFromTap(point),
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.remindmewhere',
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: _selectedLocation,
                              width: 40,
                              height: 40,
                              child: const Icon(
                                Icons.location_pin,
                                color: Colors.redAccent,
                                size: 40,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  right: 10,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                onChanged: _onSearchChanged,
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  hintText: 'Buscar endereço',
                                  hintStyle: TextStyle(color: Colors.white70),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.my_location,
                                color: Colors.white,
                              ),
                              onPressed: _useCurrentLocation,
                            ),
                          ],
                        ),
                      ),
                      if (_isLoadingSuggestions)
                        const LinearProgressIndicator(),
                      if (_suggestions.isNotEmpty)
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _suggestions.length,
                            itemBuilder: (context, index) {
                              final suggestion = _suggestions[index];
                              return ListTile(
                                title: Text(suggestion['display_name']),
                                onTap: () => _selectSuggestion(suggestion),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F66FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  final title = _reminderController.text.trim();
                  final location = _searchController.text.trim();
                  final distance = _selectedDistance;

                  if (title.isEmpty || location.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Preencha todos os campos')),
                    );
                    return;
                  }

                  final reminder = {
                    'title': title,
                    'location': location,
                    'distance': distance,
                    'lat': _selectedLocation.latitude,
                    'lng': _selectedLocation.longitude,
                    'done': false,
                    'createdAt': DateTime.now().toIso8601String(),
                    'completedAt': null,
                  };

                  if (widget.onSave != null) {
                    widget.onSave!(reminder);
                  }

                  Navigator.pop(context, {
                    'title': _reminderController.text,
                    'location': _searchController.text,
                    'distance': _selectedDistance,
                    'latitude': _selectedLocation.latitude,
                    'longitude': _selectedLocation.longitude,
                  });
                },

                child: const Text(
                  'Salvar lembrete',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
