import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:student_manager/Utils/model_text.dart';

Container CostomizeContainer (
    double height,
    color,
    text1,
    text2,
    text3,
    text,
    double size){
  return Container(
     height: height,
    decoration: BoxDecoration(
      border: Border.all(
        color: color
      ),
        borderRadius: BorderRadius.circular(10.r)
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
           Model_Text(text: text, size: size),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Model_Text(text: text1, size: size),
                Model_Text(text: text2, size: size),
              ],

            ),
        Model_Text(text: text3, size: size),
      ],
    ),
  );
}