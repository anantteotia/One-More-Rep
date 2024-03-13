import 'package:flutter/material.dart';
import 'package:align_ai/data/exercise.dart';
import 'package:align_ai/models/exercise_model.dart';
import 'package:align_ai/components/exercise_card_widget.dart';

class ExerciseListPage extends StatelessWidget {
  static const routeName = 'exercise-list-page';

  const ExerciseListPage();

  @override
  Widget build(BuildContext context) {
    //83
    final args =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    final String title = args['title'];
    final List<ExerciseModel> listOfExercise = args['listOfExercise'];

    final ExerciseModel exerciseModel = exerciseList[0];
    return Scaffold(
      //this is to bring in the same theme from the material app
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: ListView.separated(
          physics: const BouncingScrollPhysics(),
          itemCount: listOfExercise.length,
          separatorBuilder: (context, index) {
            return const SizedBox(
              height: 20,
            );
          },
          itemBuilder: (context, index) {
            return ExerciseCardWidget(
              exerciseModel: listOfExercise[index],
            );
          },
        ),
      ),
    );
  }
}
