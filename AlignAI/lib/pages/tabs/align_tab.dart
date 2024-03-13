import 'package:align_ai/main.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import '../armpress_page.dart';
import '../squat_page.dart';

class AlignTab extends StatelessWidget {
  final List<CameraDescription> cameras;
  AlignTab(this.cameras);

  static const String id = 'main_screen';
  @override
  Widget build(BuildContext context) {
    return Column(
      //mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 50),
        Container(
          padding: EdgeInsets.only(left: 16.0, right: 16.0),
          child: Text(
            'Check Your Posture \n With AI',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 32,
            ),
          ),
        ),
        SizedBox(height: 30),
        Container(
          padding: EdgeInsets.only(left: 16.0, right: 16.0),
          child: Text(
            'Exercises',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 24.0,
            ),
          ),
        ),
        SizedBox(height: 20),
        Container(
          child: SizedBox(
            height: 150,
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: 5.0),
              scrollDirection: Axis.horizontal,
              children: [
                Stack(
                  children: <Widget>[
                    Container(
                      width: 140,
                      height: 140,
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          backgroundColor: Colors.white,
                        ),
                        onPressed: () => onSelectArmPress(
                            context: context, modelName: 'posenet'),
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          child: Image.asset('images/arm_press.PNG'),
                        ),
                      ),
                    ),
                  ],
                ),
                Stack(
                  children: <Widget>[
                    Container(
                      width: 140,
                      height: 140,
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          backgroundColor: Colors.white,
                        ),
                        onPressed: () => onSelectSquat(
                            context: context, modelName: 'posenet'),
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          child: Image.asset('images/squat.PNG'),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

void onSelectArmPress({BuildContext context, String modelName}) async {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ArmPressPage(
        cameras: cameras,
        title: modelName,
      ),
    ),
  );
}

void onSelectSquat({BuildContext context, String modelName}) async {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => SquatPage(
        cameras: cameras,
        title: modelName,
      ),
    ),
  );
}
