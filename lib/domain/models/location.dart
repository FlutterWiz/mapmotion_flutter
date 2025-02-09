import 'package:equatable/equatable.dart';

/// A model representing a geographical location with a latitude and longitude.
class Location extends Equatable {
  final double latitude;
  final double longitude;

  const Location({
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object> get props => [latitude, longitude];

  @override
  String toString() => 'Location(latitude: $latitude, longitude: $longitude)';
}
