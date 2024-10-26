import 'package:flutter/material.dart';
import 'package:vista_practica/widgets/button_decoration_widget.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/Splash.jpeg'), fit: BoxFit.cover),
        ),
        child: Align(
              alignment: Alignment.bottomCenter,
              child: ButtonDecorationWidget(text: "INICIAR", onPressed: (){
                Navigator.pushNamed(context, '/Login'); 
              },
              ),
            ),
      ),
    );
  }
}