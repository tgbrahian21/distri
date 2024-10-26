import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vista_practica/utils/app_colors.dart';

class ButtonDecorationWidget extends StatelessWidget {

final String text;
final VoidCallback onPressed;
final Color color;
const ButtonDecorationWidget({
  super.key,
  required this.text,
  required this.onPressed,
  this.color = AppColors.oscureColor,

});

@override

Widget build(BuildContext context){
  return SizedBox(
    width: double.infinity,
    child: CupertinoButton(borderRadius: BorderRadius.circular(100),
    color: color,
     onPressed: onPressed,
    child: Text(
      text, style: const TextStyle(color: Colors.white, fontSize: 20),
    ),),
  );
}



}