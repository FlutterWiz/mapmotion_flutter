import 'package:geolocator/geolocator.dart';
import 'package:mapmotion_flutter/core/constants/enums/location_permission_status_enum.dart';
import 'package:mapmotion_flutter/core/interfaces/i_location_permission_service.dart';

class LocationPermissionService implements ILocationPermissionService {
  @override
  Future<bool> isLocationPermissionGranted() async {
    final LocationPermission status = await Geolocator.checkPermission();
    final bool isGranted = status == LocationPermission.always || status == LocationPermission.whileInUse;

    return isGranted;
  }

  @override
  Future<bool> isLocationServicesEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  @override
  Future<LocationPermissionStatusEnum> requestLocationPermission() async {
    final status = await Geolocator.checkPermission();
    final isGranted = status == LocationPermission.always || status == LocationPermission.whileInUse;
    final deniedForever = status == LocationPermission.deniedForever;

    if (isGranted) return LocationPermissionStatusEnum.granted;
    if (deniedForever) return LocationPermissionStatusEnum.permanentlyDenied;
    return LocationPermissionStatusEnum.denied;
  }

  @override
  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  @override
  Future<void> openApplicationSettings() async {
    await Geolocator.openAppSettings();
  }

  @override
  Stream<bool> get locationPermissionStatusStream {
    final serviceEnabled = ServiceStatus.enabled;

    return Geolocator.getServiceStatusStream().map((status) => status == serviceEnabled);
  }
}
