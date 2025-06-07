import 'package:flutter/material.dart';

// Service untuk konversi waktu antar zona
class TimeService {
  final List<Map<String, dynamic>> zones = [
    {'name': 'WIB', 'offset': 7},
    {'name': 'WITA', 'offset': 8},
    {'name': 'WIT', 'offset': 9},
    {'name': 'London', 'offset': 0},
    {'name': 'Washington DC', 'offset': -4},
    {'name': 'US (New York)', 'offset': -4},
    {'name': 'UK', 'offset': 0},
    {'name': 'Malaysia', 'offset': 8},
    {'name': 'Singapore', 'offset': 8},
    {'name': 'Korea', 'offset': 9},
    {'name': 'Thailand', 'offset': 7},
    {'name': 'Jepang', 'offset': 9},
    {'name': 'China', 'offset': 8},
    {'name': 'Rusia (Moscow)', 'offset': 3},
    {'name': 'Arab (Riyadh)', 'offset': 3},
    {'name': 'Dubai', 'offset': 4},
    {'name': 'Turki', 'offset': 3},
    {'name': 'Yunani', 'offset': 3},
  ];

  String convertTime(TimeOfDay time, String fromZone, String toZone) {
    final fromOffset = zones.firstWhere((z) => z['name'] == fromZone)['offset'] as int;
    final toOffset = zones.firstWhere((z) => z['name'] == toZone)['offset'] as int;

    final now = DateTime.now();
    final dateTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);

    final diff = toOffset - fromOffset;
    final convertedDateTime = dateTime.add(Duration(hours: diff));

    final hour = convertedDateTime.hour.toString().padLeft(2, '0');
    final minute = convertedDateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

// Stateful Widget untuk UI konversi waktu
class TimeConversionPage extends StatefulWidget {
  @override
  _TimeConversionPageState createState() => _TimeConversionPageState();
}

class _TimeConversionPageState extends State<TimeConversionPage> {
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _result = '';
  late Map<String, dynamic> _fromZone;
  late Map<String, dynamic> _toZone;

  final TimeService _timeService = TimeService();

  @override
  void initState() {
    super.initState();
    _fromZone = _timeService.zones.firstWhere((z) => z['name'] == 'WIB');
    _toZone = _timeService.zones.firstWhere((z) => z['name'] == 'London');
  }

  void _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: _selectedTime);
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        _result = '';
      });
    }
  }

  void _convert() {
    if (_fromZone == null || _toZone == null) return;

    final converted = _timeService.convertTime(_selectedTime, _fromZone['name'], _toZone['name']);

    setState(() {
      _result =
          'Waktu di ${_fromZone['name']}: ${_selectedTime.format(context)}\n'
          'Waktu di ${_toZone['name']}: $converted';
    });
  }

  Widget _buildDropdown(String label, Map<String, dynamic> value, ValueChanged<Map<String, dynamic>> onChanged) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          SizedBox(height: 6),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButton<Map<String, dynamic>>(
              value: value,
              isExpanded: true,
              underline: SizedBox(),
              items: _timeService.zones.map((zone) {
                return DropdownMenuItem<Map<String, dynamic>>(
                  value: zone,
                  child: Text(zone['name']),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) onChanged(val);
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[700],
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text('Konversi Waktu Zona Dunia'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                _buildDropdown('Dari Zona', _fromZone, (val) {
                  setState(() => _fromZone = val);
                }),
                SizedBox(width: 16),
                _buildDropdown('Ke Zona', _toZone, (val) {
                  setState(() => _toZone = val);
                }),
              ],
            ),
            SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[900]),
              onPressed: _pickTime,
              child: Text('Pilih Waktu: ${_selectedTime.format(context)}'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[900]),
              onPressed: _convert,
              child: Text('Konversi'),
            ),
            SizedBox(height: 32),
            Text(
              _result,
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
