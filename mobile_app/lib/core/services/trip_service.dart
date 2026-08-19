import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../shared/models/trip_model.dart';

class TripService {
  TripService._();

  static final TripService instance =
      TripService._();

  static const String _tripKey = 'current_trip';

  TripModel? _currentTrip;

  // ============================================================
  // INITIALIZE
  // ============================================================

  Future<void> initialize() async {
    final SharedPreferences prefs =
        await SharedPreferences.getInstance();

    final String? savedTrip =
        prefs.getString(_tripKey);

    if (savedTrip == null || savedTrip.isEmpty) {
      _currentTrip = null;
      return;
    }

    try {
      final dynamic decoded =
          jsonDecode(savedTrip);

      if (decoded is Map<String, dynamic>) {
        _currentTrip =
            TripModel.fromJson(decoded);
      } else {
        _currentTrip = null;
      }
    } catch (_) {
      _currentTrip = null;
    }
  }

  // ============================================================
  // CURRENT TRIP
  // ============================================================

  TripModel? get currentTrip {
    return _currentTrip;
  }

  // ============================================================
  // HAS TRIP
  // ============================================================

  bool get hasTrip {
    return _currentTrip != null;
  }

  // ============================================================
  // CREATE / SAVE TRIP
  // ============================================================

  Future<void> saveTrip(
    TripModel trip,
  ) async {
    _currentTrip = trip;

    await _saveToStorage(trip);
  }

  // ============================================================
  // UPDATE TRIP
  // ============================================================

  Future<void> updateTrip(
    TripModel trip,
  ) async {
    _currentTrip = trip;

    await _saveToStorage(trip);
  }

  // ============================================================
  // SAVE TO PHONE
  // ============================================================

  Future<void> _saveToStorage(
    TripModel trip,
  ) async {
    final SharedPreferences prefs =
        await SharedPreferences.getInstance();

    final String encodedTrip =
        jsonEncode(
      trip.toJson(),
    );

    await prefs.setString(
      _tripKey,
      encodedTrip,
    );
  }

  // ============================================================
  // DELETE TRIP
  // ============================================================

  Future<void> clearTrip() async {
    _currentTrip = null;

    final SharedPreferences prefs =
        await SharedPreferences.getInstance();

    await prefs.remove(_tripKey);
  }
}