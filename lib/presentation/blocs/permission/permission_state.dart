import 'package:equatable/equatable.dart';

class PermissionState extends Equatable {
  const PermissionState({
    this.isLocationServiceEnabled = false,
    this.isLocationPermissionGranted = false,
  });

  final bool isLocationServiceEnabled;
  final bool isLocationPermissionGranted;

  @override
  List<Object?> get props => [isLocationServiceEnabled, isLocationPermissionGranted];

  PermissionState copyWith({
    bool? isLocationServiceEnabled,
    bool? isLocationPermissionGranted,
  }) {
    return PermissionState(
      isLocationServiceEnabled: isLocationServiceEnabled ?? this.isLocationServiceEnabled,
      isLocationPermissionGranted: isLocationPermissionGranted ?? this.isLocationPermissionGranted,
    );
  }

  /// Returns the initial [PermissionState] with default values.
  factory PermissionState.initial() => const PermissionState();
}
