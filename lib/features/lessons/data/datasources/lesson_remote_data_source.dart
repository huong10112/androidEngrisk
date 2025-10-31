import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:engrisk/features/lessons/domain/entities/lesson_entity.dart';

class LessonRemoteDataSource {
  final FirebaseFirestore _firestore;

  LessonRemoteDataSource(this._firestore);

  Future<List<LessonEntity>> getLessonsByLevel(String level) async {
    try {
      final querySnapshot = await _firestore
          .collection('lessons')
          .where('level', isEqualTo: level)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.map((doc) {
          final data = doc.data();
          return LessonEntity(
            id: doc.id,
            title: data['title'] ?? '',
            description: data['description'] ?? '',
            level: data['level'] ?? '',
            audioKey: data['audioKey'] ?? '',
            exerciseType: data['exerciseType'] ?? '',
          );
        }).toList();
      } else {
        return _getMockLessons(level);
      }
    } catch (e) {
      print('Error getting lessons from Firestore: $e');
      return _getMockLessons(level);
    }
  }

  List<LessonEntity> _getMockLessons(String level) {
    final lessons = [
      LessonEntity(
        id: '1',
        title: 'Bài 1: Chào hỏi',
        description: 'Dịch Việt - Anh',
        level: 'Beginner',
        audioKey: 'greeting',
        exerciseType: 'Dịch Việt - Anh',
      ),
      LessonEntity(
        id: '2',
        title: 'Bài 2: Màu sắc',
        description: 'Dịch Anh - Việt',
        level: 'Beginner',
        audioKey: 'colors',
        exerciseType: 'Dịch Anh - Việt',
      ),
      LessonEntity(
        id: '3',
        title: 'Bài 3: Giới từ',
        description: 'Nghe và Điền từ',
        level: 'Beginner',
        audioKey: 'prepositions',
        exerciseType: 'Nghe và Điền từ',
      ),
      LessonEntity(
        id: '4',
        title: 'Bài 4: Bạn bè',
        description: 'Nghe và Chọn đáp án',
        level: 'Beginner',
        audioKey: 'friends',
        exerciseType: 'Nghe và Chọn đáp án',
      ),
    ];

    return lessons.where((lesson) => lesson.level == level).toList();
  }

  Future<String> getAudioUrl(String audioKey) async {
    // Audio URLs từ nguồn công khai
    final audioUrls = {
      'greeting': 'https://assets.mixkit.co/sfx/preview/mixkit-correct-answer-tone-2870.mp3',
      'colors': 'https://assets.mixkit.co/sfx/preview/mixkit-correct-answer-tone-2870.mp3',
      'prepositions': 'https://assets.mixkit.co/sfx/preview/mixkit-correct-answer-tone-2870.mp3',
      'friends': 'https://assets.mixkit.co/sfx/preview/mixkit-correct-answer-tone-2870.mp3',
    };

    return audioUrls[audioKey] ?? 'https://assets.mixkit.co/sfx/preview/mixkit-correct-answer-tone-2870.mp3';
  }
}