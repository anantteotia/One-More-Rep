class ExerciseModel {
  final String name;
  final String category;
  final List<String> steps;
  final String sets;
  final String reps;
  final String duration;
  final String imageUrl;
  final List<String> equipment;
  final List<String> targetMuscles;
  final int difficulty;
  bool isFavourite;

  ExerciseModel({
    this.name,
    this.category,
    this.steps,
    this.sets,
    this.reps,
    this.duration,
    this.imageUrl,
    this.equipment,
    this.targetMuscles,
    this.difficulty,
    this.isFavourite = false,
  });
}
