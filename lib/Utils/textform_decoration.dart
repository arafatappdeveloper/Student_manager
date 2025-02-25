
import 'package:flutter/material.dart';

InputDecoration ModifyTextField (String label, Widget icon){
  return InputDecoration(
      hintText: label,
      prefixIcon: icon,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10)
      )
  );
}