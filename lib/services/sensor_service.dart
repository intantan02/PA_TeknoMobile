import 'package:sensors_plus/sensors_plus.dart';
import 'package:sensors_plus/sensors_plus.dart' as SensorsPlus;

class SensorService {
  Stream<AccelerometerEvent> get accelerometerEvents => SensorsPlus.accelerometerEvents;
  Stream<GyroscopeEvent> get gyroscopeEvents => SensorsPlus.gyroscopeEvents;

  // Contoh fungsi untuk mendapatkan data sensor secara realtime
  void listenAccelerometer(void Function(AccelerometerEvent event) onData) {
    accelerometerEvents.listen(onData);
  }

  void listenGyroscope(void Function(GyroscopeEvent event) onData) {
    gyroscopeEvents.listen(onData);
  }
}
