import '../entities/lesson_entity.dart';

abstract class LessonRepository {
  Future<List<LessonEntity>> getLessonsByLevel(String level);
  Future<String> getAudioUrl(String audioKey);
}