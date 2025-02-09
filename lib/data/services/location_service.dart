import 'package:geolocator/geolocator.dart';
import 'package:mapmotion_flutter/core/interfaces/i_location_service.dart';
import 'package:mapmotion_flutter/domain/models/location.dart';

class LocationService implements ILocationService {
  @override
  Stream<Location> get locationStream {
    return Geolocator.getPositionStream().map(
      (position) => Location(latitude: position.latitude, longitude: position.longitude),
    );
  }
}
