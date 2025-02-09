import 'package:mapmotion_flutter/core/constants/enums/location_permission_status_enum.dart';

/// An abstract interface for managing and monitoring location permissions and services.
///
/// This interface defines methods to:
/// - Check if the location permission is granted by the user.
/// - Check if the device's location services are enabled.
/// - Request location permission from the user.
/// - Open the device's location settings to enable location services.
/// - Open the app settings for further permission management.
/// - Provide a stream to track changes in location permission status.
abstract class ILocationPermissionService {
  /// Checks if the location permission is currently granted by the user.
  Future<bool> isLocationPermissionGranted();

  /// Checks if the device's location services are enabled.
  Future<bool> isLocationServicesEnabled();

  /// Requests location permission from the user.
  ///
  /// This method should trigger the appropriate permission prompt if the permission
  /// has not yet been granted.
  Future<LocationPermissionStatusEnum> requestLocationPermission();

  /// Opens the device's location settings.
  ///
  /// This allows the user to manually enable location services from the system settings.
  Future<void> openLocationSettings();

  /// Opens the application-specific settings.
  ///
  /// This allows the user to adjust app-specific permissions, including location permission,
  /// within the device's app settings screen.
  Future<void> openApplicationSettings();

  /// A stream that tracks changes to the location permission status.
  Stream<bool> get locationPermissionStatusStream;
}
