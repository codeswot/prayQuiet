import 'dart:convert';

class PrayerInfo {
  final DateTime prayerDateTime;
  final String prayerName;

  PrayerInfo(this.prayerDateTime, this.prayerName);

  // Method to create PrayerInfo object from JSON Map
  factory PrayerInfo.fromJson(Map<String, dynamic> json) {
    return PrayerInfo(
      DateTime.parse(json['dateTime']),
      json['prayerName'] as String,
    );
  }

  // Method to create PrayerInfo object from raw JSON string
  factory PrayerInfo.fromRawJson(String jsonString) {
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    return PrayerInfo.fromJson(jsonMap);
  }

  // Method to convert PrayerInfo object to JSON Map
  Map<String, dynamic> toJson() {
    return {
      'dateTime': prayerDateTime.toIso8601String(),
      'prayerName': prayerName,
    };
  }

  // Method to convert PrayerInfo object to raw JSON string
  String toRawJson() {
    return json.encode(toJson());
  }
}
