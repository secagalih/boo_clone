import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';

class Personality extends Equatable {
  final String? mbti;
  final String? avatar;
  final double? ei;
  final double? ns;
  final double? ft;
  final double? jp;

  const Personality({
    this.mbti,
    this.avatar,
    this.ei,
    this.ns,
    this.ft,
    this.jp,
  });

  factory Personality.fromJson(Map<String, dynamic> json) {
    return Personality(
      mbti: json['mbti']?.toString(),
      avatar: json['avatar']?.toString(),
      ei: json['EI']?.toDouble(),
      ns: json['NS']?.toDouble(),
      ft: json['FT']?.toDouble(),
      jp: json['JP']?.toDouble(),
    );
  }

  @override
  List<Object?> get props => [mbti, avatar, ei, ns, ft, jp];
}

class MoreAboutUser extends Equatable {
  final String? exercise;
  final String? educationLevel;
  final String? drinking;
  final String? smoking;
  final String? kids;
  final String? religion;

  const MoreAboutUser({
    this.exercise,
    this.educationLevel,
    this.drinking,
    this.smoking,
    this.kids,
    this.religion,
  });

  factory MoreAboutUser.fromJson(Map<String, dynamic> json) {
    return MoreAboutUser(
      exercise: json['exercise']?.toString(),
      educationLevel: json['educationLevel']?.toString(),
      drinking: json['drinking']?.toString(),
      smoking: json['smoking']?.toString(),
      kids: json['kids']?.toString(),
      religion: json['religion']?.toString(),
    );
  }

  @override
  List<Object?> get props => [exercise, educationLevel, drinking, smoking, kids, religion];
}

class Preferences extends Equatable {
  final List<String> purpose;

  const Preferences({
    this.purpose = const [],
  });

  factory Preferences.fromJson(Map<String, dynamic> json) {
    return Preferences(
      purpose: (json['purpose'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  @override
  List<Object?> get props => [purpose];
}

class Interest extends Equatable {
  final String id;
  final String? category;
  final String? interest;
  final String name;
  final bool? allowImages;
  final int? numFollowers;
  final int? numQuestions;
  final List<String> similar;

  const Interest({
    required this.id,
    this.category,
    this.interest,
    required this.name,
    this.allowImages,
    this.numFollowers,
    this.numQuestions,
    this.similar = const [],
  });

  factory Interest.fromJson(Map<String, dynamic> json) {
    return Interest(
      id: json['_id']?.toString() ?? '',
      category: json['category']?.toString(),
      interest: json['interest']?.toString(),
      name: json['name']?.toString() ?? '',
      allowImages: json['allowImages'] as bool?,
      numFollowers: json['numFollowers'] as int?,
      numQuestions: json['numQuestions'] as int?,
      similar: (json['similar'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  @override
  List<Object?> get props =>
      [id, category, interest, name, allowImages, numFollowers, numQuestions, similar];
}

class UserProfile extends Equatable {
  final String id;
  final String name;
  final int age;
  final String description;
  final String imageUrl;
  final String location;
  final String? gender;
  final Personality? personality;
  final String? education;
  final String? work;
  final MoreAboutUser? moreAboutUser;
  final bool crown;
  final String? handle;
  final bool teleport;
  final Preferences? preferences;
  final bool hideQuestions;
  final bool hideComments;
  final String? horoscope;
  final List<Interest> interests;
  final List<String> interestNames;
  final List<String> languages;
  final String? timezone;
  final List<dynamic> interestPoints;
  final List<String> tags;

  const UserProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.description,
    required this.imageUrl,
    required this.location,
    this.gender,
    this.personality,
    this.education,
    this.work,
    this.moreAboutUser,
    this.crown = false,
    this.handle,
    this.teleport = false,
    this.preferences,
    this.hideQuestions = false,
    this.hideComments = false,
    this.horoscope,
    this.interests = const [],
    this.interestNames = const [],
    this.languages = const [],
    this.timezone,
    this.interestPoints = const [],
    this.tags = const [],
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    // Generate avatar image based on gender and hash of ID for variety
    final gender = json['gender']?.toString() ?? 'male';
    final id = json['_id']?.toString() ?? '';

    // Use ID hash to select from multiple avatar images
    final hash = id.hashCode.abs() % 10;

    final femaleAvatars = [
      'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=800',
      'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=800',
      'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=800',
      'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=800',
      'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=800',
      'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?w=800',
      'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=800',
      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800',
      'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?w=800',
      'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=800',
    ];

    final maleAvatars = [
      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800',
      'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=800',
      'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=800',
      'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=800',
      'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=800',
      'https://images.unsplash.com/photo-1531427186611-ecfd6d936c79?w=800',
      'https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?w=800',
      'https://images.unsplash.com/photo-1522556189639-b150ed9c4330?w=800',
      'https://images.unsplash.com/photo-1504257432389-52343af06ae3?w=800',
      'https://images.unsplash.com/photo-1513956589380-bad6acb9b9d4?w=800',
    ];

    final imageUrl = gender == 'female' ? femaleAvatars[hash] : maleAvatars[hash];

    // Parse personality
    final Personality? personality = json['personality'] != null
        ? Personality.fromJson(json['personality'] as Map<String, dynamic>)
        : null;

    // Parse moreAboutUser
    final MoreAboutUser? moreAboutUser = json['moreAboutUser'] != null
        ? MoreAboutUser.fromJson(json['moreAboutUser'] as Map<String, dynamic>)
        : null;

    // Parse preferences
    final Preferences? preferences = json['preferences'] != null
        ? Preferences.fromJson(json['preferences'] as Map<String, dynamic>)
        : null;

    // Parse interests
    final List<Interest> interests = (json['interests'] as List<dynamic>?)
            ?.map((interestJson) =>
                Interest.fromJson(interestJson as Map<String, dynamic>))
            .toList() ??
        [];

    // Parse interestNames
    final List<String> interestNames = (json['interestNames'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];

    // Parse languages
    final List<String> languages = (json['languages'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];

    // Parse tags
    final List<String> tags = (json['tags'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];

    // Parse interestPoints
    final List<dynamic> interestPoints = json['interestPoints'] as List<dynamic>? ?? [];

    return UserProfile(
      id: id,
      name: json['firstName']?.toString() ?? 'Unknown',
      age: json['age'] as int? ?? 18,
      description: json['description']?.toString() ?? '',
      imageUrl: imageUrl,
      location: json['location']?.toString() ?? '',
      gender: gender,
      personality: personality,
      education: json['education']?.toString(),
      work: json['work']?.toString(),
      moreAboutUser: moreAboutUser,
      crown: json['crown'] as bool? ?? false,
      handle: json['handle']?.toString(),
      teleport: json['teleport'] as bool? ?? false,
      preferences: preferences,
      hideQuestions: json['hideQuestions'] as bool? ?? false,
      hideComments: json['hideComments'] as bool? ?? false,
      horoscope: json['horoscope']?.toString(),
      interests: interests,
      interestNames: interestNames,
      languages: languages,
      timezone: json['timezone']?.toString(),
      interestPoints: interestPoints,
      tags: tags,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        age,
        description,
        imageUrl,
        location,
        gender,
        personality,
        education,
        work,
        moreAboutUser,
        crown,
        handle,
        teleport,
        preferences,
        hideQuestions,
        hideComments,
        horoscope,
        interests,
        interestNames,
        languages,
        timezone,
        interestPoints,
        tags,
      ];

  static Future<List<UserProfile>> getSampleProfiles() async {
    try {
      final String response = await rootBundle.loadString('lib/models/mock_data.json');
      final data = json.decode(response);
      final List<dynamic> profilesJson = data['profiles'] ?? [];

      return profilesJson.map((json) => UserProfile.fromJson(json)).toList();
    } catch (e) {
      // Return fallback profiles if JSON loading fails
      return _getFallbackProfiles();
    }
  }

  static List<UserProfile> _getFallbackProfiles() {
    return [
      const UserProfile(
        id: '1',
        name: 'Sarah',
        age: 25,
        description: 'Adventure seeker 🏔️ | Coffee enthusiast ☕ | Love hiking and photography',
        imageUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=800',
        location: 'New York, NY',
      ),
      const UserProfile(
        id: '2',
        name: 'Michael',
        age: 28,
        description: 'Software engineer 💻 | Dog lover 🐕 | Always up for trying new restaurants',
        imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800',
        location: 'San Francisco, CA',
      ),
      const UserProfile(
        id: '3',
        name: 'Emily',
        age: 26,
        description: 'Yoga instructor 🧘‍♀️ | Plant mom 🌱 | Beach lover and sunset chaser',
        imageUrl: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=800',
        location: 'Los Angeles, CA',
      ),
      const UserProfile(
        id: '4',
        name: 'David',
        age: 30,
        description: 'Chef 👨‍🍳 | Music festival enthusiast 🎵 | Looking for my sous chef in life',
        imageUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=800',
        location: 'Austin, TX',
      ),
      const UserProfile(
        id: '5',
        name: 'Jessica',
        age: 27,
        description: 'Artist 🎨 | Travel junkie ✈️ | Can\'t resist good wine and deep conversations',
        imageUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=800',
        location: 'Miami, FL',
      ),
    ];
  }
}
