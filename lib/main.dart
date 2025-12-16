import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swipable_stack/swipable_stack.dart';
import 'bloc/swipe_bloc.dart';
import 'bloc/swipe_event.dart';
import 'bloc/swipe_state.dart';
import 'widgets/profile_card.dart';
import 'widgets/action_button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Boo Dating App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink, brightness: Brightness.light),
        useMaterial3: true,
      ),
      home: BlocProvider(create: (context) => SwipeBloc()..add(const LoadProfilesEvent()), child: const HomeScreen()),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late SwipableStackController _controller;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _controller = SwipableStackController();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleLike(String profileId) {
    context.read<SwipeBloc>().add(LikeProfileEvent(profileId));
    _controller.next(swipeDirection: SwipeDirection.right, duration: const Duration(milliseconds: 300));
    _scrollToTop();
  }

  void _handlePass(String profileId) {
    context.read<SwipeBloc>().add(PassProfileEvent(profileId));
    _controller.next(swipeDirection: SwipeDirection.left, duration: const Duration(milliseconds: 300));
    _scrollToTop();
  }

  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F1010),
      appBar: AppBar(
        backgroundColor: Color(0xFF000000),
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.favorite, color: Color(0xFF4ED5CD)),
            const SizedBox(width: 8),
            const Text(
              'Boo',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
      ),
      body: BlocBuilder<SwipeBloc, SwipeState>(
        builder: (context, state) {
          if (state.status == SwipeStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == SwipeStatus.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(state.errorMessage ?? 'An error occurred', style: const TextStyle(fontSize: 16), textAlign: TextAlign.center),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      context.read<SwipeBloc>().add(const LoadProfilesEvent());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state.status == SwipeStatus.completed) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle_outline, size: 80, color: Colors.green),
                  const SizedBox(height: 24),
                  const Text('No more profiles!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Text('You liked ${state.likedProfiles.length} profiles', style: const TextStyle(fontSize: 18, color: Colors.grey)),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<SwipeBloc>().add(const ResetProfilesEvent());
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Start Over'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            );
          }

          if (state.status == SwipeStatus.loaded) {
            if (state.currentIndex >= state.profiles.length) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('No more profiles!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<SwipeBloc>().add(const ResetProfilesEvent());
                      },
                      child: const Text('Start Over'),
                    ),
                  ],
                ),
              );
            }

            return SafeArea(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: SwipableStack(
                          controller: _controller,
                          allowVerticalSwipe: false,
                          onSwipeCompleted: (index, direction) {
                            final profile = state.profiles[index];
                            if (direction == SwipeDirection.right) {
                              context.read<SwipeBloc>().add(LikeProfileEvent(profile.id));
                            } else if (direction == SwipeDirection.left) {
                              context.read<SwipeBloc>().add(PassProfileEvent(profile.id));
                            }
                          },
                          builder: (context, properties) {
                            final itemIndex = properties.index % state.profiles.length;
                            final profile = state.profiles[itemIndex];

                            return ProfileCard(profile: profile);
                          },
                          overlayBuilder: (context, properties) {
                            final opacity = properties.swipeProgress.clamp(0.0, 1.0);
                            final isRight = properties.direction == SwipeDirection.right;
                            final isLeft = properties.direction == SwipeDirection.left;

                            return Stack(
                              children: [
                                if (isRight)
                                  Positioned(
                                    top: 50,
                                    left: 30,
                                    child: Opacity(
                                      opacity: opacity,
                                      child: Transform.rotate(
                                        angle: -0.3,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.green, width: 4),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: const Text(
                                            'LIKE',
                                            style: TextStyle(color: Colors.green, fontSize: 32, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                if (isLeft)
                                  Positioned(
                                    top: 50,
                                    right: 30,
                                    child: Opacity(
                                      opacity: opacity,
                                      child: Transform.rotate(
                                        angle: 0.3,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.red, width: 4),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: const Text(
                                            'NOPE',
                                            style: TextStyle(color: Colors.red, fontSize: 32, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Looking For',
                            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          for (var purpose in state.profiles[state.currentIndex].preferences?.purpose ?? [])
                            Badge(label: Text(purpose), backgroundColor: Colors.blue),
                          SizedBox(height: 16),

                          Text(
                            state.profiles[state.currentIndex].description,
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    if (state.profiles[state.currentIndex].interests.isNotEmpty)
                    Container(
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Interests',
                            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              for (var interest in state.profiles[state.currentIndex].interests)
                                Badge(
                                  label: Text(
                                    '#' + interest.name,
                                    style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                                  ),
                                  backgroundColor: Colors.blue,
                                  padding: EdgeInsets.only(right: 8, left: 8),
                                ),
                            ],
                          ),

                          SizedBox(height: 16),
                        ],
                      ),
                    ),
                    if (state.profiles[state.currentIndex].personality != null)
                    Container(
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Personality',
                            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              if (state.profiles[state.currentIndex].personality?.mbti != null)
                                Badge(
                                  label: Text(
                                    state.profiles[state.currentIndex].personality!.mbti!,
                                    style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                                  ),
                                  backgroundColor: Colors.purple,
                                  padding: EdgeInsets.only(right: 8, left: 8),
                                ),
                              if (state.profiles[state.currentIndex].personality?.avatar != null)
                                Badge(
                                  label: Text(
                                    state.profiles[state.currentIndex].personality!.avatar!,
                                    style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                                  ),
                                  backgroundColor: Colors.deepPurple,
                                  padding: EdgeInsets.only(right: 8, left: 8),
                                ),
                            ],
                          ),

                          SizedBox(height: 16),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              if (state.profiles[state.currentIndex].personality?.ei != null)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'EI',
                                      style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 4),
                                    Badge(
                                      label: Text(
                                        state.profiles[state.currentIndex].personality!.ei!.toStringAsFixed(2),
                                        style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                                      ),
                                      backgroundColor: Colors.orange,
                                      padding: EdgeInsets.only(right: 8, left: 8),
                                    ),
                                  ],
                                ),
                              if (state.profiles[state.currentIndex].personality?.ns != null)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'NS',
                                      style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 4),
                                    Badge(
                                      label: Text(
                                        state.profiles[state.currentIndex].personality!.ns!.toStringAsFixed(2),
                                        style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                                      ),
                                      backgroundColor: Colors.blue,
                                      padding: EdgeInsets.only(right: 8, left: 8),
                                    ),
                                  ],
                                ),
                              if (state.profiles[state.currentIndex].personality?.ft != null)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'FT',
                                      style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 4),
                                    Badge(
                                      label: Text(
                                        state.profiles[state.currentIndex].personality!.ft!.toStringAsFixed(2),
                                        style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                                      ),
                                      backgroundColor: Colors.green,
                                      padding: EdgeInsets.only(right: 8, left: 8),
                                    ),
                                  ],
                                ),
                              if (state.profiles[state.currentIndex].personality?.jp != null)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'JP',
                                      style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 4),
                                    Badge(
                                      label: Text(
                                        state.profiles[state.currentIndex].personality!.jp!.toStringAsFixed(2),
                                        style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                                      ),
                                      backgroundColor: Colors.red,
                                      padding: EdgeInsets.only(right: 8, left: 8),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return const Center(child: Text('Something went wrong'));
        },
      ),
      bottomNavigationBar: BlocBuilder<SwipeBloc, SwipeState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Pass button
                ActionButton(
                  icon: Icons.close,
                  color: Color(0xFFF24C36),
                  size: 70,
                  onPressed: () {
                    if (state.status == SwipeStatus.loaded) {
                      _handlePass(state.profiles[state.currentIndex].id);
                    }
                  },
                ),
                // Like button
                ActionButton(
                  icon: Icons.favorite,
                  color: Color(0xFF4ED5CD),
                  size: 70,
                  onPressed: () {
                    if (state.status == SwipeStatus.loaded) {
                      _handleLike(state.profiles[state.currentIndex].id);
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
