import 'package:flutter_bloc/flutter_bloc.dart';
import 'swipe_event.dart';
import 'swipe_state.dart';
import '../models/user_profile.dart';

class SwipeBloc extends Bloc<SwipeEvent, SwipeState> {
  SwipeBloc() : super(const SwipeState()) {
    on<LoadProfilesEvent>(_onLoadProfiles);
    on<LikeProfileEvent>(_onLikeProfile);
    on<PassProfileEvent>(_onPassProfile);
    on<ResetProfilesEvent>(_onResetProfiles);
  }

  Future<void> _onLoadProfiles(LoadProfilesEvent event, Emitter<SwipeState> emit) async {
    emit(state.copyWith(status: SwipeStatus.loading));

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final profiles = await UserProfile.getSampleProfiles();

      emit(SwipeState(status: SwipeStatus.loaded, profiles: profiles, currentIndex: 0, likedProfiles: const [], passedProfiles: const []));
    } catch (e) {
      emit(state.copyWith(status: SwipeStatus.error, errorMessage: 'Failed to load profiles: ${e.toString()}'));
    }
  }

  void _onLikeProfile(LikeProfileEvent event, Emitter<SwipeState> emit) {
    if (state.status == SwipeStatus.loaded) {
      final newLikedProfiles = List<String>.from(state.likedProfiles)..add(event.profileId);
      final newIndex = state.currentIndex + 1;

      if (newIndex >= state.profiles.length) {
        emit(state.copyWith(status: SwipeStatus.completed, likedProfiles: newLikedProfiles, currentIndex: newIndex));
      } else {
        emit(state.copyWith(currentIndex: newIndex, likedProfiles: newLikedProfiles));
      }
    }
  }

  void _onPassProfile(PassProfileEvent event, Emitter<SwipeState> emit) {
    if (state.status == SwipeStatus.loaded) {
      final newPassedProfiles = List<String>.from(state.passedProfiles)..add(event.profileId);
      final newIndex = state.currentIndex + 1;

      if (newIndex >= state.profiles.length) {
        emit(state.copyWith(status: SwipeStatus.completed, passedProfiles: newPassedProfiles, currentIndex: newIndex));
      } else {
        emit(state.copyWith(currentIndex: newIndex, passedProfiles: newPassedProfiles));
      }
    }
  }

  Future<void> _onResetProfiles(ResetProfilesEvent event, Emitter<SwipeState> emit) async {
    add(const LoadProfilesEvent());
  }
}
