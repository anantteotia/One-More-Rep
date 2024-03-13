import 'package:flutter/material.dart';
import 'package:align_ai/data/exercise.dart';

import 'package:align_ai/models/workout_category_model.dart';
import 'package:align_ai/pages/exercise_list_page.dart';

class WorkoutCategoryWidget extends StatelessWidget {
  final WorkoutCategoryModel workOutCategoryModel;
  const WorkoutCategoryWidget({
    Key key,
    this.workOutCategoryModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //add inkwell to this so when the user click on the card it can
        //navigate to a new screen
        InkWell(
          onTap: () {
            Navigator.of(context)
                .pushNamed(ExerciseListPage.routeName, arguments: {
              'title': workOutCategoryModel.categoryName,
              //83
              'listOfExercise': exerciseList
                  .where((element) =>
                      element.category == workOutCategoryModel.categoryName)
                  .toList(),
            });
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              child: Stack(
                //with the stack, the location of each widget matters
                children: [
                  Image.network(
                    workOutCategoryModel.imageSource,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    //position the text to the bottom left rather than the top left
                    bottom: 0,
                    child: Container(
                      height: 40,
                      width: 400,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black,
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            workOutCategoryModel.categoryName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        )
      ],
    );
  }
}
