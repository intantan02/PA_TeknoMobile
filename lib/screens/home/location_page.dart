import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rekomendasi_buku/services/location_service.dart';


class LocationPage extends StatefulWidget {
  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  final LocationService _locationService = LocationService();
  Completer<GoogleMapController> _mapController = Completer();

  LatLng? _currentPosition;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    Position? position = await _locationService.getCurrentLocation();

    if (position != null) {
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _loading = false;
      });
    } else {
      // Kalau lokasi ga bisa didapatkan
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mendapatkan lokasi. Pastikan GPS aktif dan izin diberikan.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lokasi Saya'),
        backgroundColor: Colors.blue,
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : _currentPosition == null
              ? Center(child: Text('Lokasi tidak tersedia'))
              : GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _currentPosition!,
                    zoom: 15,
                  ),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  mapType: MapType.normal,
                  onMapCreated: (GoogleMapController controller) {
                    _mapController.complete(controller);
                  },
                ),
    );
  }
}
