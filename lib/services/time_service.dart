import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart'; // Tambahkan ini jika pakai TimeOfDay

class TimeService {
  static const String _baseUrl = 'http://worldtimeapi.org/api/timezone/';

  Future<DateTime?> getTimeInZone(String timezone) async {
    final response = await http.get(Uri.parse('$_baseUrl$timezone'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return DateTime.parse(data['datetime']);
    }
    return null;
  }

  Future<List<String>> getAvailableTimezones() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<String>();
    }
    return [];
  }

  // Tambahkan method ini
  String convertTime(TimeOfDay time, String fromZone, String toZone) {
    // Offset zona waktu dalam jam (contoh: WIB, WITA, WIT, London)
    final Map<String, int> offsets = {
      'WIB': 7,
      'WITA': 8,
      'WIT': 9,
      'London': 0,
    };

    int fromOffset = offsets[fromZone] ?? 0;
    int toOffset = offsets[toZone] ?? 0;

    final now = DateTime.now();
    final dateTime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    final diff = toOffset - fromOffset;
    final convertedDateTime = dateTime.add(Duration(hours: diff));

    final hour = convertedDateTime.hour.toString().padLeft(2, '0');
    final minute = convertedDateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
