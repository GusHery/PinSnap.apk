class LocationPin {
  final String id;
  final String name;
  final String photoPath;
  final double latitude;
  final double longitude;
  final DateTime timestamp;

  LocationPin({
    required this.id,
    required this.name,
    required this.photoPath,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
  });

  factory LocationPin.fromJson(Map<String, dynamic> json) {
    return LocationPin(
      id: json['id'] as String,
      name: json['name'] as String,
      photoPath: json['photoPath'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'photoPath': photoPath,
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
