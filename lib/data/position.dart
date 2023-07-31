import 'dart:convert';

class Position {
  final double lat;
  final double lng;
  final bool mock;

  Position({
    required this.lat,
    required this.lng,
    required this.mock,
  });

  factory Position.fromRawJson(String str) =>
      Position.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Position.fromJson(Map<String, dynamic> json) => Position(
        lat: json["lat"]?.toDouble(),
        lng: json["lng"]?.toDouble(),
        mock: json["mock"],
      );

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
        "mock": mock,
      };
}
