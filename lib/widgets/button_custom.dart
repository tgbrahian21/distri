import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ButtonCustom extends StatelessWidget {
  final String icon;
  final String text;
  final Widget route;
  const ButtonCustom({super.key, required this.icon, required this.text, required this.route});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: Container(
              padding: const EdgeInsets.all(15),
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(80),
                border: Border.all(color: Colors.black, width: 3),
              ),
              child:  ImageIcon(
                  AssetImage(icon))),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>  route,
                ));
          },
          iconSize: 60,
        ),
        Text(
          text,
          style:
              GoogleFonts.sofiaSans(textStyle: const TextStyle(fontSize: 20)),
        ),
      ],
    );
  }
}
