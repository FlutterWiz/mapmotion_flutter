import 'package:equatable/equatable.dart';
import 'package:mapmotion_flutter/domain/models/location.dart';

class LocationState extends Equatable {
  const LocationState({
    this.userLocation,
  });

  /// Represents the current location of the user.
  /// It can be null if no location is available.
  final Location? userLocation;

  @override
  List<Object?> get props => [userLocation];

  LocationState copyWith({
    Location? userLocation,
  }) {
    return LocationState(
      userLocation: userLocation ?? this.userLocation,
    );
  }

  /// Returns the initial [LocationState] with default values.
  factory LocationState.initial() => const LocationState();
}
