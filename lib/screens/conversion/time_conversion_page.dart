import 'package:flutter/material.dart';
import '../../services/time_service.dart';

class TimeConversionPage extends StatefulWidget {
  const TimeConversionPage({super.key});

  @override
  _TimeConversionPageState createState() => _TimeConversionPageState();
}

class _TimeConversionPageState extends State<TimeConversionPage> {
  final TimeService _timeService = TimeService();

  final List<String> _timeZones = ['WIB', 'WITA', 'WIT', 'London'];
  String _fromZone = 'WIB';
  String _toZone = 'London';

  TimeOfDay _selectedTime = TimeOfDay.now();
  String _convertedTime = '';

  void _convert() {
    final converted = _timeService.convertTime(
      _selectedTime,
      _fromZone,
      _toZone,
    );
    setState(() {
      _convertedTime = converted;
    });
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        _convert();
      });
    }
  }

  Widget _buildDropdown(String currentValue, ValueChanged<String?> onChanged) {
    return DropdownButton<String>(
      value: currentValue,
      items: _timeZones
          .map((zone) => DropdownMenuItem(value: zone, child: Text(zone)))
          .toList(),
      onChanged: onChanged,
    );
  }

  @override
  void initState() {
    super.initState();
    _convert();
  }

  @override
  Widget build(BuildContext context) {
    final formattedSelectedTime = _selectedTime.format(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Konversi Waktu'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Pilih waktu:'),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: _pickTime,
              child: Text(formattedSelectedTime),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text('Dari Zona'),
                    _buildDropdown(_fromZone, (val) {
                      if (val != null) {
                        setState(() {
                          _fromZone = val;
                          _convert();
                        });
                      }
                    }),
                  ],
                ),
                Column(
                  children: [
                    Text('Ke Zona'),
                    _buildDropdown(_toZone, (val) {
                      if (val != null) {
                        setState(() {
                          _toZone = val;
                          _convert();
                        });
                      }
                    }),
                  ],
                ),
              ],
            ),
            SizedBox(height: 32),
            Text(
              'Waktu di $_toZone: $_convertedTime',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
