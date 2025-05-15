class Terminal {
  final String name;
  final String location;
  final double latitude;
  final double longitude;
  final String description;
  final String city;
  final int estimatedPassengers;
  final double rating;
  final String type;
  final String density; // Added for density level (Rendah, Sedang, Tinggi)

  Terminal({
    required this.name,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.city,
    required this.estimatedPassengers,
    required this.rating,
    required this.type,
    required this.density,
  });

  factory Terminal.fromJson(Map<String, dynamic> json) {
    // Determine density based on estimated passengers
    String density;
    int passengers = json['estimated_passengers'] ?? 0;
    
    // If no passengers data, assign random density for demonstration
    if (passengers == 0) {
      final densityOptions = ['Rendah', 'Sedang', 'Tinggi'];
      density = densityOptions[DateTime.now().microsecond % 3];
    } else if (passengers < 3000) {
      density = 'Rendah';
    } else if (passengers < 6000) {
      density = 'Sedang';
    } else {
      density = 'Tinggi';
    }

    return Terminal(
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] ?? '',
      city: json['city'] ?? '',
      estimatedPassengers: json['estimated_passengers'] ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      type: json['type'] ?? '',
      density: density,
    );
  }
}
