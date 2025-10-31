import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:engrisk/features/lessons/data/datasources/lesson_remote_data_source.dart';
import 'package:engrisk/features/lessons/data/repositories/lesson_repository_impl.dart';
import 'package:engrisk/features/lessons/domain/repositories/lesson_repository.dart';
import 'package:engrisk/features/lessons/domain/usecases/get_lessons_usecase.dart';
import 'package:engrisk/features/lessons/presentation/providers/lesson_provider.dart';
import 'package:engrisk/core/utils/audio_player_util.dart';
import 'package:engrisk/features/lessons/presentation/screens/translation_exercise_screen.dart';
import 'package:engrisk/features/lessons/presentation/screens/fill_blank_exercise_screen.dart';
import 'package:engrisk/features/lessons/presentation/screens/multiple_choice_exercise_screen.dart';
import 'package:engrisk/core/widgets/custom_bottom_navigation.dart';

// Import LessonEntity
import 'package:engrisk/features/lessons/domain/entities/lesson_entity.dart';

class LessonScreen extends StatefulWidget {
  final String level;

  const LessonScreen({super.key, required this.level});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  late LessonProvider _lessonProvider;

  @override
  void initState() {
    super.initState();
    _initializeDependencies();
  }

  void _initializeDependencies() {
    final remoteDataSource = LessonRemoteDataSource(FirebaseFirestore.instance);
    final LessonRepository repository = LessonRepositoryImpl(remoteDataSource);
    final getLessonsUseCase = GetLessonsUseCase(repository);
    final audioPlayerUtil = AudioPlayerUtil();

    _lessonProvider = LessonProvider(
      getLessonsUseCase: getLessonsUseCase,
      audioPlayerUtil: audioPlayerUtil,
    );

    _loadLessons();
  }

  void _loadLessons() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _lessonProvider.loadLessons(widget.level);
    });
  }

  void _navigateToExerciseScreen(String exerciseType, LessonEntity lesson) {
    switch (exerciseType) {
      case 'Dịch Việt - Anh':
      case 'Dịch Anh - Việt':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TranslationExerciseScreen(
              sentence: _getSentenceForLesson(lesson.title),
              correctAnswer: _getCorrectAnswerForLesson(lesson.title),
            ),
          ),
        );
        break;
      case 'Nghe và Điền từ':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FillBlankExerciseScreen(
              sentence: _getSentenceForLesson(lesson.title),
              correctAnswer: _getCorrectAnswerForLesson(lesson.title),
            ),
          ),
        );
        break;
      case 'Nghe và Chọn đáp án':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MultipleChoiceExerciseScreen(
              options: _getOptionsForLesson(lesson.title),
              correctAnswer: _getCorrectAnswerForLesson(lesson.title),
            ),
          ),
        );
        break;
      default:
        _lessonProvider.playLessonAudio(lesson);
    }
  }

  String _getSentenceForLesson(String title) {
    final sentences = {
      'Bài 1: Chào hỏi': 'Xin chào, bạn khỏe không?',
      'Bài 2: Màu sắc': 'The sky is blue.',
      'Bài 3: Giới từ': 'I go to school ______ bus.',
      'Bài 4: Bạn bè': 'She is writing a letter to her friend.',
    };
    return sentences[title] ?? 'Default sentence';
  }

  String _getCorrectAnswerForLesson(String title) {
    final answers = {
      'Bài 1: Chào hỏi': 'Hello, how are you?',
      'Bài 2: Màu sắc': 'Bầu trời màu xanh.',
      'Bài 3: Giới từ': 'by',
      'Bài 4: Bạn bè': 'She is writing a letter to her friend.',
    };
    return answers[title] ?? 'Default answer';
  }

  List<String> _getOptionsForLesson(String title) {
    if (title == 'Bài 4: Bạn bè') {
      return [
        'She is reading a letter to her friend.',
        'They are writing a letter to her friend.',
        'He is writing a letter to his friend.',
        'She is writing a letter to her friend.',
      ];
    }
    return ['Option 1', 'Option 2', 'Option 3', 'Option 4'];
  }

  @override
  void dispose() {
    _lessonProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.level,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: AnimatedBuilder(
        animation: _lessonProvider,
        builder: (context, _) {
          if (_lessonProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_lessonProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Loading mock data...',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  CircularProgressIndicator(
                    color: const Color(0xFF4CAF50),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Lessons List
                Expanded(
                  child: ListView(
                    children: [
                      ..._lessonProvider.lessons.asMap().entries.map((entry) =>
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _buildLessonItem(entry.value, entry.key),
                          ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                const SizedBox(height: 24),

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) {
            Navigator.popUntil(context, (route) => route.isFirst);
          }
          // Handle other tabs
        },
      ),
    );
  }

  Widget _buildLessonItem(LessonEntity lesson, int index) {
    // Danh sách màu cho các bài học
    final List<Color> lessonColors = [
      const Color(0xFFFF6B6B), // Đỏ
      const Color(0xFF4ECDC4), // Xanh ngọc
      const Color(0xFFFFD166), // Vàng
      const Color(0xFF6A0572), // Tím
    ];

    // Danh sách icon cho các bài học
    final List<IconData> lessonIcons = [
      Icons.handshake,        // Chào hỏi
      Icons.palette,          // Màu sắc
      Icons.language,         // Giới từ
      Icons.people,           // Bạn bè
    ];

    final Color lessonColor = lessonColors[index % lessonColors.length];
    final IconData lessonIcon = lessonIcons[index % lessonIcons.length];

    return GestureDetector(
      onTap: () => _navigateToExerciseScreen(lesson.exerciseType, lesson),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: lessonColor.withOpacity(0.1), // Màu nền nhạt
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: lessonColor.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Icon với màu tương ứng
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: lessonColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  lessonIcon,
                  color: lessonColor,
                  size: 20,
                ),
              ),

              const SizedBox(width: 16),

              // Lesson Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lesson.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      lesson.exerciseType,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow Icon
              Icon(
                Icons.arrow_forward_ios,
                color: lessonColor, // Màu mũi tên theo bài học
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}