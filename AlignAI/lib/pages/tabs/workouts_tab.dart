import 'package:flutter/material.dart';
import 'package:align_ai/data/workout_category_list.dart';
import 'package:align_ai/components/workout_category_widget.dart';

class WorkoutTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: workoutCategoryList.length,
              itemBuilder: ((context, index) => WorkoutCategoryWidget(
                    workOutCategoryModel: workoutCategoryList[index],
                  )),
            ),
          )
        ],
      ),
    );
  }
}
