import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PlatformScreen extends StatefulWidget {
  const PlatformScreen({Key? key}) : super(key: key);

  @override
  State<PlatformScreen> createState() => _PlatformScreenState();
}

class _PlatformScreenState extends State<PlatformScreen> {
  static const MethodChannel platformBattery =
      MethodChannel('training/battery');
  static const MethodChannel platformPressure =
      MethodChannel('training/method');
  static const EventChannel pressureChannel = EventChannel('training/pressure');

  String _batteryLevel = 'No information';
  String _sensorAvailable = 'Unknown';
  double _pressureReading = 0;
  StreamSubscription? pressureSubscription;

  _startReading() {
    pressureSubscription =
        pressureChannel.receiveBroadcastStream().listen((event) {
      setState(() {
        _pressureReading = event;
      });
    });
  }

  _stopReading() {
    setState(() {
      _pressureReading = 0;
    });
    pressureSubscription?.cancel();
    pressureSubscription = null;
  }

  Future<void> _checkAvailability() async {
    try {
      var available = await platformPressure.invokeMethod('isSensorAvailable');
      setState(() {
        _sensorAvailable = available
            ? 'Pressure sensor is available'
            : 'Pressure sensor is not available';
      });
    } on PlatformException catch (e) {
      _sensorAvailable = 'error: ${e.message}';
    }
  }

  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await platformBattery.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      batteryLevel = 'Failed to get battery level: ${e.message}';
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_batteryLevel),
            ElevatedButton(
              onPressed: _getBatteryLevel,
              child: const Padding(
                padding:
                    EdgeInsets.only(left: 36, right: 36, top: 11, bottom: 11),
                child: Text('Update'),
              ),
            ),
            Text(_sensorAvailable),
            ElevatedButton(
              onPressed: _checkAvailability,
              child: const Padding(
                padding:
                    EdgeInsets.only(left: 36, right: 36, top: 11, bottom: 11),
                child: Text('Update'),
              ),
            ),
            Text('Sensor value: $_pressureReading'),
            ElevatedButton(
              onPressed: _startReading,
              child: const Padding(
                padding:
                    EdgeInsets.only(left: 36, right: 36, top: 11, bottom: 11),
                child: Text('Start Stream'),
              ),
            ),
            ElevatedButton(
              onPressed: pressureSubscription == null ? () {} : _stopReading,
              child: const Padding(
                padding:
                    EdgeInsets.only(left: 36, right: 36, top: 11, bottom: 11),
                child: Text('Stop Stream'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
