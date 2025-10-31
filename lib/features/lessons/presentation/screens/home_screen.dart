import 'package:flutter/material.dart';
import 'package:engrisk/core/widgets/custom_bottom_navigation.dart';
import 'package:engrisk/core/widgets/social_icons_row.dart';
import 'lesson_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),

                      // Beginner Section
                      _buildLevelCard(
                        title: 'Beginner',
                        description: 'Khóa học cơ bản cho người mới bắt đầu! Học các từ vựng và cấu trúc cơ bản',
                        onPressed: () => _navigateToLessonScreen(context, 'Beginner'),
                      ),

                      const SizedBox(height: 24),

                      // Intermediate Section
                      _buildLevelCard(
                        title: 'Intermediate',
                        description: 'Khóa học trung cấp giúp bạn nâng cao kỹ năng tiếng Anh của mình',
                        onPressed: () => _navigateToLessonScreen(context, 'Intermediate'),
                      ),

                      const SizedBox(height: 24),

                      // Advanced Section
                      _buildLevelCard(
                        title: 'Advanced',
                        description: 'Khóa học nâng cao giúp bạn trở thành người sử dụng tiếng Anh thành thạo',
                        onPressed: () => _navigateToLessonScreen(context, 'Advanced'),
                      ),

                      const SizedBox(height: 40),

                      // Connect with Engrisk
                      Column(
                        children: [
                          const Text(
                            'Connect with Engrisk',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const SocialIconsRow(),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Bottom Navigation - GIỮ NGUYÊN FOOTER
          CustomBottomNavigation(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLevelCard({
    required String title,
    required String description,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
                height: 1.4,
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Start Lesson',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToLessonScreen(BuildContext context, String level) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LessonScreen(level: level),
      ),
    );
  }
}