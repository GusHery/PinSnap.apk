import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/location_pin.dart';

class LocalStorageService {
  static const String _locationPinsKey = 'location_pins';

  Future<void> saveLocationPin(LocationPin pin) async {
    final prefs = await SharedPreferences.getInstance();
    final pins = await getAllLocationPins();

    pins.add(pin);

    final jsonList = pins.map((pin) => jsonEncode(pin.toJson())).toList();
    await prefs.setStringList(_locationPinsKey, jsonList);
  }

  Future<List<LocationPin>> getAllLocationPins() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_locationPinsKey) ?? [];

    return jsonList
        .map((json) => LocationPin.fromJson(jsonDecode(json)))
        .toList();
  }

  Future<LocationPin?> getLocationPin(String id) async {
    final pins = await getAllLocationPins();
    try {
      return pins.firstWhere((pin) => pin.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> deleteLocationPin(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final pins = await getAllLocationPins();

    pins.removeWhere((pin) => pin.id == id);

    final jsonList = pins.map((pin) => jsonEncode(pin.toJson())).toList();
    await prefs.setStringList(_locationPinsKey, jsonList);
  }

  Future<void> updateLocationPin(LocationPin pin) async {
    final prefs = await SharedPreferences.getInstance();
    final pins = await getAllLocationPins();

    final index = pins.indexWhere((p) => p.id == pin.id);
    if (index >= 0) {
      pins[index] = pin;
      final jsonList = pins.map((pin) => jsonEncode(pin.toJson())).toList();
      await prefs.setStringList(_locationPinsKey, jsonList);
    }
  }
}
