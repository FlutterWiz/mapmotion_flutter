import 'package:mapmotion_flutter/domain/models/location.dart';

abstract class ILocationService {
  /// A stream that emits the current location.
  Stream<Location> get locationStream;
}
