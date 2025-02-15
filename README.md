# MapMotion Flutter

**MapMotion Flutter** is an open-source Flutter project that demonstrates robust permission management using `flutter_bloc` along with interactive map animations and dynamic path recording.

## Showcase

<p align="center">
  <img src="https://github.com/FlutterWiz/mapmotion_flutter/blob/main/assets/showcases/showcase1.gif?raw=true" width="600">
  <img src="https://github.com/FlutterWiz/mapmotion_flutter/blob/main/assets/showcases/showcase2.gif?raw=true" width="600">
</p>

## Features

- **Permission Management**  
  Robust handling of location permissions and service availability using `flutter_bloc`.
  
- **Interactive Mapping**  
  Smooth map interactions using [flutter_map](https://pub.dev/packages/flutter_map) along with [latlong2](https://pub.dev/packages/latlong2) and [flutter_map_animations](https://pub.dev/packages/flutter_map_animations).

- **Animated Markers & Dynamic Paths**  
  Engaging marker animations with [Lottie](https://pub.dev/packages/lottie) and real-time polyline tracking of your movement.

- **MVVM Architecture**  
  Clean separation of UI and business logic following Flutter’s recommended MVVM structure.

- **Analysis Options**  
  Built-in options for tracking and analyzing your movement data.

## Packages Used

- [get_it](https://pub.dev/packages/get_it)
- [geolocator](https://pub.dev/packages/geolocator)
- [equatable](https://pub.dev/packages/equatable)
- [flutter_bloc](https://pub.dev/packages/flutter_bloc)
- [flutter_map](https://pub.dev/packages/flutter_map)
- [latlong2](https://pub.dev/packages/latlong2)
- [flutter_map_animations](https://pub.dev/packages/flutter_map_animations)
- [lottie](https://pub.dev/packages/lottie)
- [soft_edge_blur](https://pub.dev/packages/soft_edge_blur)

## Usage
- **Interactive Map**  
  Tap anywhere on the map to animate the marker to the tapped location.
  
- **Dynamic Path Recording**  
  As the marker moves, a polyline is drawn behind it to track your movement.

- **Permission Handling**  
  The app gracefully handles location permissions and shows a dedicated view if permissions are denied or location services are off.

## Tutorials
<img src="https://github.com/user-attachments/assets/3a384a90-1faf-4994-9349-23aa86d3c40b" width="200">
<img src="https://github.com/user-attachments/assets/b73a0208-4dbb-4016-93ec-bf0f6f7d9feb" width="200">

- **YouTube & Medium**  
  - YouTube Videos 🎥
    - [Part 1: Handling Location, Permissions & App Lifecycle](https://youtu.be/X8EX7yqoy1A)
    - [Part 2: Interactive Maps, Animations & Path Tracking](https://youtu.be/Xz0HVcZ41v8)
  - Medium Article (Coming Soon) ✍️

## License

This project is open-source and available under the MIT License.
