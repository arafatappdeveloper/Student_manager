import 'package:flutter/material.dart';

class RaisedButton extends StatelessWidget {
  String title;
  final VoidCallback onTap;
  final isLoading;
  RaisedButton({super.key,required this.title,this.isLoading=false,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,

        decoration: BoxDecoration(
            color: Colors.deepPurple,
            borderRadius: BorderRadius.circular(10)
        ),
        child: Center(
          child: isLoading? CircularProgressIndicator(strokeWidth: 2,color: Colors.white,):
          Text(title,style: TextStyle(
              color: Colors.white
          ),),
        ),
      ),

    );
  }
}