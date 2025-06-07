import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import '../../services/time_service.dart';

class KonversiWaktuPage extends StatefulWidget {
  @override
  _KonversiWaktuPageState createState() => _KonversiWaktuPageState();
}

class _KonversiWaktuPageState extends State<KonversiWaktuPage> {
  final TimeService _timeService = TimeService();
  TimeOfDay selectedTime = TimeOfDay.now();

  String fromZone = 'WIB';
  String toZone = 'WITA';
  String result = '';

  final List<String> allZones = [
    'WIB', 'WITA', 'WIT',
    'London', 'Washington DC', 'US (New York)', 'UK', 'Malaysia',
    'Singapore', 'Korea', 'Thailand', 'Jepang', 'China',
    'Rusia (Moscow)', 'Arab (Riyadh)', 'Dubai', 'Turki', 'Yunani'
  ];

  void _pickTime() async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              onSurface: Colors.blue,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.blue),
            ),
          ),
          child: child!,
        );
      },
    );
    if (time != null) {
      setState(() {
        selectedTime = time;
        _convertTime();
      });
    }
  }

  void _convertTime() {
    final converted = _timeService.convertTime(selectedTime, fromZone, toZone);
    setState(() {
      result = '${selectedTime.format(context)} $fromZone = $converted $toZone';
    });
  }

  Widget _buildDropdown(String label, String selected, ValueChanged<String?> onChanged) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          DropdownSearch<String>(
            selectedItem: selected,
            items: allZones,
            onChanged: onChanged,
            popupProps: PopupProps.menu(
              showSearchBox: true,
              searchFieldProps: TextFieldProps(
                decoration: InputDecoration(
                  hintText: "Cari zona...",
                  filled: true,
                  fillColor: Colors.blue.shade50,
                  contentPadding: EdgeInsets.all(12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                style: TextStyle(color: Colors.blue[900]),
              ),
              constraints: BoxConstraints(maxHeight: 250),
            ),
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                filled: true,
                fillColor: Colors.blue.shade50,
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
            dropdownButtonProps: DropdownButtonProps(
              icon: Icon(Icons.arrow_drop_down, color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: Text('Konversi Waktu'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _pickTime,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: Text('Pilih Waktu (${selectedTime.format(context)})'),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                _buildDropdown('Dari Zona', fromZone, (val) {
                  if (val != null) {
                    setState(() {
                      fromZone = val;
                      _convertTime();
                    });
                  }
                }),
                SizedBox(width: 16),
                _buildDropdown('Ke Zona', toZone, (val) {
                  if (val != null) {
                    setState(() {
                      toZone = val;
                      _convertTime();
                    });
                  }
                }),
              ],
            ),
            SizedBox(height: 24),
            Text(
              result,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue[900]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
