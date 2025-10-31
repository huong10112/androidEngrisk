import '../entities/lesson_entity.dart';
import '../repositories/lesson_repository.dart';

class GetLessonsUseCase {
  final LessonRepository repository;

  GetLessonsUseCase(this.repository);

  Future<List<LessonEntity>> call(String level) {
    return repository.getLessonsByLevel(level);
  }
}