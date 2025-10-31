import 'package:flutter/material.dart';
import 'package:engrisk/features/lessons/domain/entities/lesson_entity.dart';
import 'package:engrisk/features/lessons/domain/usecases/get_lessons_usecase.dart';
import 'package:engrisk/core/utils/audio_player_util.dart';

class LessonProvider extends ChangeNotifier {
  final GetLessonsUseCase getLessonsUseCase;
  final AudioPlayerUtil audioPlayerUtil;

  LessonProvider({
    required this.getLessonsUseCase,
    required this.audioPlayerUtil,
  });

  List<LessonEntity> _lessons = [];
  List<LessonEntity> get lessons => _lessons;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> loadLessons(String level) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _lessons = await getLessonsUseCase(level);
    } catch (e) {
      _error = 'Failed to load lessons: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> playLessonAudio(LessonEntity lesson) async {
    try {
      final audioUrl = await getLessonsUseCase.repository.getAudioUrl(lesson.audioKey);
      if (audioUrl.isNotEmpty) {
        await audioPlayerUtil.playAudio(audioUrl);
      }
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  @override
  void dispose() {
    audioPlayerUtil.dispose();
    super.dispose();
  }
}