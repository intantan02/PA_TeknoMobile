import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class Utils {
  /// Format tanggal ke string dengan format "dd MMM yyyy"
  static String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('dd MMM yyyy');
    return formatter.format(date);
  }

  /// Format tanggal dan waktu ke string dengan format "dd MMM yyyy HH:mm"
  static String formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('dd MMM yyyy HH:mm');
    return formatter.format(dateTime);
  }

  /// Mengubah timestamp (millisecondsSinceEpoch) ke format tanggal string
  static String formatTimestamp(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return formatDate(date);
  }

  /// Mengubah durasi dalam detik ke format jam:menit:detik (HH:mm:ss)
  static String formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final secs = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$secs";
  }

  /// Validasi format email sederhana
  static bool isValidEmail(String email) {
    final RegExp regex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );
    return regex.hasMatch(email);
  }

  /// Hash string menggunakan SHA-256 (contoh untuk enkripsi password)
  static String hashString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Konversi string ke Title Case (setiap kata diawali huruf kapital)
  static String toTitleCase(String text) {
    if (text.isEmpty) return text;
    return text.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  /// Fungsi untuk menampilkan waktu relatif (misal: "5 menit yang lalu")
  static String timeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Baru saja';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} menit yang lalu';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari yang lalu';
    } else {
      return formatDate(dateTime);
    }
  }
}
