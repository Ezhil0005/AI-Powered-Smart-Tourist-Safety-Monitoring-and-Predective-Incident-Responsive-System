class TripModel {
  final String startLocation;
  final String destination;
  final DateTime date;
  final String startTime;
  final int travellers;
  final String emergencyContact;
  final bool shareLocation;
  final bool safeRoute;
  final bool riskAlerts;
  final String notes;

  const TripModel({
    required this.startLocation,
    required this.destination,
    required this.date,
    required this.startTime,
    required this.travellers,
    required this.emergencyContact,
    required this.shareLocation,
    required this.safeRoute,
    required this.riskAlerts,
    required this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'startLocation': startLocation,
      'destination': destination,
      'date': date.toIso8601String(),
      'startTime': startTime,
      'travellers': travellers,
      'emergencyContact': emergencyContact,
      'shareLocation': shareLocation,
      'safeRoute': safeRoute,
      'riskAlerts': riskAlerts,
      'notes': notes,
    };
  }

  factory TripModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TripModel(
      startLocation:
          json['startLocation'] as String? ?? '',
      destination:
          json['destination'] as String? ?? '',
      date:
          DateTime.parse(
        json['date'] as String,
      ),
      startTime:
          json['startTime'] as String? ?? '',
      travellers:
          (json['travellers'] as num?)?.toInt() ?? 1,
      emergencyContact:
          json['emergencyContact'] as String? ??
              'Emergency Contact',
      shareLocation:
          json['shareLocation'] as bool? ?? true,
      safeRoute:
          json['safeRoute'] as bool? ?? true,
      riskAlerts:
          json['riskAlerts'] as bool? ?? true,
      notes:
          json['notes'] as String? ?? '',
    );
  }
}