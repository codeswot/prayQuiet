import 'dart:convert';

class PrayerApiModel {
  final String location;
  final String calculationMethod;
  final String asrjuristicMethod;
  final Map<String, dynamic> praytimes;

  PrayerApiModel({
    required this.location,
    required this.calculationMethod,
    required this.asrjuristicMethod,
    required this.praytimes,
  });

  factory PrayerApiModel.fromRawJson(String str) =>
      PrayerApiModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PrayerApiModel.fromJson(Map<String, dynamic> json) => PrayerApiModel(
        location: json["location"],
        calculationMethod: json["calculationMethod"],
        asrjuristicMethod: json["asrjuristicMethod"],
        praytimes: json["praytimes"],
      );

  Map<String, dynamic> toJson() => {
        "location": location,
        "calculationMethod": calculationMethod,
        "asrjuristicMethod": asrjuristicMethod,
        "praytimes": praytimes,
      };
}

class Prayers {
  final String fajr;
  final String sunrise;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String ishaA;

  Prayers({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.ishaA,
  });

  factory Prayers.fromRawJson(String str) => Prayers.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Prayers.fromJson(Map<String, dynamic> json) => Prayers(
        fajr: json["Fajr"],
        sunrise: json["Sunrise"],
        dhuhr: json["Dhuhr"],
        asr: json["Asr"],
        maghrib: json["Maghrib"],
        ishaA: json["Isha'a"],
      );

  Map<String, dynamic> toJson() => {
        "Fajr": fajr,
        "Sunrise": sunrise,
        "Dhuhr": dhuhr,
        "Asr": asr,
        "Maghrib": maghrib,
        "Isha'a": ishaA,
      };
}
