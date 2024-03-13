import 'package:flutter/material.dart';
import 'package:align_ai/models/exercise_model.dart';
import 'package:align_ai/pages/exercise_detail_page.dart';

class ExerciseCardWidget extends StatelessWidget {
  final ExerciseModel exerciseModel;
  const ExerciseCardWidget({this.exerciseModel});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          ExerciseDetailPage.routeName,
          arguments: exerciseModel,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade600),
          borderRadius: BorderRadius.circular(12.0),
          color: Colors.grey.shade700,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade800,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          //move the texts to the left
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(5),
                topLeft: Radius.circular(5),
              ),
              child: Image.network(
                exerciseModel.imageUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 250,
                    child: Text(
                      exerciseModel.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        // overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  //create the rating out of 5 star
                  Row(
                    children: [
                      ...List.generate(
                        5,
                        (index) => Icon(
                          index + 1 <= exerciseModel.difficulty
                              ? Icons.star
                              : Icons.star_outline,
                          size: 18,
                          color: Colors.orange,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            //user .join because the name would requlst as Equipment: [Lat Pulldown machine]
            //rather than Equipment: Lat Pulldown machine
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'Equipment: ${exerciseModel.equipment.join(',')}',
                style: TextStyle(
                  color: Colors.grey.shade300,
                  fontWeight: FontWeight.w300,
                  fontSize: 14,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
