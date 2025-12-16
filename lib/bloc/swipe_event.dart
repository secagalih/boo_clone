import 'package:equatable/equatable.dart';

/// Base class for all swipe events
abstract class SwipeEvent extends Equatable {
  const SwipeEvent();

  @override
  List<Object?> get props => [];
}

/// Event triggered when user likes a profile
class LikeProfileEvent extends SwipeEvent {
  final String profileId;

  const LikeProfileEvent(this.profileId);

  @override
  List<Object?> get props => [profileId];
}

/// Event triggered when user passes on a profile
class PassProfileEvent extends SwipeEvent {
  final String profileId;

  const PassProfileEvent(this.profileId);

  @override
  List<Object?> get props => [profileId];
}

/// Event triggered when profiles are loaded
class LoadProfilesEvent extends SwipeEvent {
  const LoadProfilesEvent();
}

/// Event triggered to reset the profile stack
class ResetProfilesEvent extends SwipeEvent {
  const ResetProfilesEvent();
}

