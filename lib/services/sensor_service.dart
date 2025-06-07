import 'package:sensors_plus/sensors_plus.dart';

class SensorService {
  // Stream untuk mendapatkan data accelerometer secara realtime
  Stream<AccelerometerEvent> get accelerometerEvents => accelerometerEvents;

  // Stream untuk mendapatkan data gyroscope secara realtime
  Stream<GyroscopeEvent> get gyroscopeEvents => gyroscopeEvents;

  // Mendengarkan data accelerometer
  void listenAccelerometer(void Function(AccelerometerEvent event) onData) {
    accelerometerEvents.listen(onData);
  }

  // Mendengarkan data gyroscope
  void listenGyroscope(void Function(GyroscopeEvent event) onData) {
    gyroscopeEvents.listen(onData);
  }
}