import 'package:flutter/material.dart';
import 'package:student_manager/Utils/model_text.dart'; // Adjust the import as needed

class ButtomContainer extends StatelessWidget {
  final double height;
  final double width;
  final Color backgroundColor;
  final Color borderColor;
  final String text;
  final double textSize;
  final bool isSelected;

  const ButtomContainer({
    Key? key,
    required this.height,
    required this.width,
    required this.backgroundColor,
    required this.borderColor,
    required this.text,
    required this.textSize,
    this.isSelected = false, // Optional parameter with default value
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: isSelected ? backgroundColor : Colors.white, // Conditional color
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
      ),
      child: Center(
        child: Model_Text(
          text: text,
          size: textSize,
        ),
      ),
    );
  }
}