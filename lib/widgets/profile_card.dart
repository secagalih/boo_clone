import 'package:flutter/material.dart';
import '../models/user_profile.dart';

class ProfileCard extends Widget {
  final UserProfile profile;
  final VoidCallback? onSwipe;

  const ProfileCard({super.key, required this.profile, this.onSwipe});

  @override
  Element createElement() => _ProfileCardElement(this);
}

class _ProfileCardElement extends ComponentElement {
  _ProfileCardElement(super.widget);

  @override
  ProfileCard get widget => super.widget as ProfileCard;

  @override
  Widget build() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                widget.profile.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.person, size: 100, color: Colors.grey),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey[300],
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
              ),
            ),

            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withValues(alpha: 0.8)],
                    stops: const [0.6, 1.0],
                  ),
                ),
              ),
            ),

            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.profile.name,
                      style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    if (widget.profile.work != '')
                      Row(
                        children: [
                          const Icon(Icons.work, color: Colors.white, size: 20),
                          const SizedBox(width: 4),
                          Text(widget.profile.work ?? '', style: const TextStyle(color: Colors.white, fontSize: 16)),
                        ],
                      ),
                    const SizedBox(height: 8),
                    if (widget.profile.education != '')
                      Row(
                        children: [
                          const Icon(Icons.school, color: Colors.white, size: 20),
                          const SizedBox(width: 4),
                          Text(widget.profile.education ?? '', style: const TextStyle(color: Colors.white, fontSize: 16)),
                        ],
                      ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.white, size: 20),
                        const SizedBox(width: 4),
                        Text(widget.profile.location, style: const TextStyle(color: Colors.white, fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Badge(
                          padding: EdgeInsets.all(5),
                          backgroundColor: widget.profile.gender == 'male' ? Colors.blue : Colors.pink,
                          label: Row(
                            children: [
                              Icon(widget.profile.gender == 'male' ? Icons.male : Icons.female, color: Colors.white, size: 20),
                              Text(widget.profile.age.toString(), style: const TextStyle(color: Colors.white, fontSize: 16)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Badge(
                          padding: EdgeInsets.all(5),
                          backgroundColor: Colors.redAccent,
                          label: Text(widget.profile.personality?.mbti ?? '', style: const TextStyle(color: Colors.white, fontSize: 16)),
                        ),
                        const SizedBox(width: 8),
                        Badge(
                          padding: EdgeInsets.all(5),
                          backgroundColor: Colors.blueAccent,
                          label: Text(widget.profile.horoscope ?? '', style: const TextStyle(color: Colors.white, fontSize: 16)),
                        ),
                      ],
                    ),
                    // Bio
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
