import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:remindmewhere/widgets/current_location_map.dart';

class CreateReminderPage extends StatefulWidget {
  const CreateReminderPage({super.key});

  @override
  State<CreateReminderPage> createState() => _CreateReminderPage();
}

class _CreateReminderPage extends State<CreateReminderPage> {
  final TextEditingController _reminderController = TextEditingController();
  final List<int> _distances = [100, 200, 500, 1000];
  int _selectedDistance = 200;

  // Local exemplo (pode ser atualizado via GPS depois)
  final LatLng _location = LatLng(-23.5505, -46.6333); // São Paulo

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E), // preto suave
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: const Text(
          'Novo lembrete',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
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
                  _distances.map((distance) {
                    return DropdownMenuItem<int>(
                      value: distance,
                      child: Text('$distance metros'),
                    );
                  }).toList(),
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
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: const CurrentLocationMap(),
            ),

            const Spacer(),
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
                  // Aqui vamos salvar o lembrete
                  final reminder = _reminderController.text;
                  final distance = _selectedDistance;
                  print('Salvar: $reminder a $distance metros de $_location');
                },
                child: const Text(
                  'Salvar lembrete',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
