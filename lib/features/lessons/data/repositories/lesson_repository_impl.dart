import 'package:engrisk/features/lessons/domain/entities/lesson_entity.dart';
import 'package:engrisk/features/lessons/domain/repositories/lesson_repository.dart';
import '../datasources/lesson_remote_data_source.dart';

class LessonRepositoryImpl implements LessonRepository {
  final LessonRemoteDataSource remoteDataSource;

  LessonRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<LessonEntity>> getLessonsByLevel(String level) {
    return remoteDataSource.getLessonsByLevel(level);
  }

  @override
  Future<String> getAudioUrl(String audioKey) {
    return remoteDataSource.getAudioUrl(audioKey);
  }
}