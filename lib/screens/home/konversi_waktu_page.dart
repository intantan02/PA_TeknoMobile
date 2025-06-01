import 'package:flutter/material.dart';
import 'package:rekomendasi_buku/services/time_service.dart';


class KonversiWaktuPage extends StatefulWidget {
  @override
  _KonversiWaktuPageState createState() => _KonversiWaktuPageState();
}

class _KonversiWaktuPageState extends State<KonversiWaktuPage> {
  final TimeService _timeService = TimeService();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _fromZone = 'WIB';
  String _toZone = 'WITA';
  String _convertedTime = '';

  void _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _convert() {
    final result = _timeService.convertTime(_selectedTime, _fromZone, _toZone);
    setState(() {
      _convertedTime = '$result ($_toZone)';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Konversi Waktu')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _pickTime,
              child: Text('Pilih Waktu (${_selectedTime.format(context)})'),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildDropdown('Dari', _fromZone, (val) => setState(() => _fromZone = val))),
                SizedBox(width: 16),
                Expanded(child: _buildDropdown('Ke', _toZone, (val) => setState(() => _toZone = val))),
              ],
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _convert,
              child: Text('Konversi'),
            ),
            SizedBox(height: 24),
            Text(
              _convertedTime.isEmpty ? 'Belum dikonversi' : 'Hasil: $_convertedTime',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, String value, Function(String) onChanged) {
    final zones = ['WIB', 'WITA', 'WIT', 'London'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        DropdownButton<String>(
          value: value,
          items: zones.map((z) => DropdownMenuItem(value: z, child: Text(z))).toList(),
          onChanged: (val) => onChanged(val!),
        ),
      ],
    );
  }
}
