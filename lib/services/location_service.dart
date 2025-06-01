import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<bool> checkPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permission ditolak user
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permission ditolak permanen, perlu arahkan user ke settings manual
      return false;
    }

    return true;
  }

  Future<Position?> getCurrentLocation() async {
    bool hasPermission = await checkPermission();
    if (!hasPermission) return null;

    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10), // Timeout biar ga nunggu terlalu lama
      );
    } catch (e) {
      // Misal lokasi tidak bisa didapatkan karena GPS mati atau timeout
      print('Error getting location: $e');
      return null;
    }
  }
}
