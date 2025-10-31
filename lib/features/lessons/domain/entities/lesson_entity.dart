class LessonEntity {
  final String id;
  final String title;
  final String description;
  final String level;
  final String audioKey;
  final String exerciseType;

  const LessonEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.level,
    required this.audioKey,
    required this.exerciseType,
  });
}