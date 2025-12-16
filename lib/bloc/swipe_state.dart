import 'package:equatable/equatable.dart';
import '../models/user_profile.dart';

enum SwipeStatus { initial, loading, loaded, completed, error }

class SwipeState extends Equatable {
  final SwipeStatus status;
  final List<UserProfile> profiles;
  final int currentIndex;
  final List<String> likedProfiles;
  final List<String> passedProfiles;
  final String? errorMessage;

  const SwipeState({
    this.status = SwipeStatus.initial,
    this.profiles = const [],
    this.currentIndex = 0,
    this.likedProfiles = const [],
    this.passedProfiles = const [],
    this.errorMessage,
  });

  SwipeState copyWith({
    SwipeStatus? status,
    List<UserProfile>? profiles,
    int? currentIndex,
    List<String>? likedProfiles,
    List<String>? passedProfiles,
    String? errorMessage,
  }) {
    return SwipeState(
      status: status ?? this.status,
      profiles: profiles ?? this.profiles,
      currentIndex: currentIndex ?? this.currentIndex,
      likedProfiles: likedProfiles ?? this.likedProfiles,
      passedProfiles: passedProfiles ?? this.passedProfiles,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, profiles, currentIndex, likedProfiles, passedProfiles, errorMessage];
}
