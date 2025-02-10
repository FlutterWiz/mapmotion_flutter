import 'package:equatable/equatable.dart';

class ApplicationLifeCycleState extends Equatable {
  const ApplicationLifeCycleState({
    this.isResumed = true,
  });

  /// If true, the app is in the resumed state; if false, it's in the background.
  final bool isResumed;

  @override
  List<Object?> get props => [isResumed];

  ApplicationLifeCycleState copyWith({
    bool? isResumed,
  }) {
    return ApplicationLifeCycleState(
      isResumed: isResumed ?? this.isResumed,
    );
  }

  factory ApplicationLifeCycleState.resumed() => const ApplicationLifeCycleState();
  factory ApplicationLifeCycleState.background() => const ApplicationLifeCycleState(isResumed: false);

  @override
  String toString() => 'ApplicationLifeCycleState(isResumed: $isResumed)';
}
