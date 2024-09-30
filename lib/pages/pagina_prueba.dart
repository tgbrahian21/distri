/*import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sizer/sizer.dart';
import 'package:vista_practica/utils/Button_info.dart';
import 'package:vista_practica/utils/Buttons.dart';
import 'package:vista_practica/widgets/button_custom.dart';

class Pagemain extends StatefulWidget {
  static const String routeName = 'Pagina Principal';
  const Pagemain({super.key});

  @override
  State<Pagemain> createState() => _PagemainState();
}

class _PagemainState extends State<Pagemain> {
  final GlobalKey<ScaffoldState> _formdKey = GlobalKey<ScaffoldState>();
  final List<ButtonInfo> _buttons = getButtons();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: SingleChildScrollView(
          child: FormBuilder(
            key: _formdKey,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20.h,
                    width: 80.w,
                    child: Image.network(
                      'https://www.distriserviciosesp.com/assets/img/Icon2-1-1536x265.png',
                      height: 400,
                      width: 400,
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                    child: Text(
                      'Preoperacionales',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.only(top: 30),
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, 
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                      ),
                      shrinkWrap: true,
                      itemCount: _buttons.length,
                      itemBuilder: (context, index) {
                        
                        bool isLastOddButton = _buttons.length % 2 != 0 && index == _buttons.length - 1;

                        if (isLastOddButton) {
                          
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ButtonCustom(
                                icon: _buttons[index].icon,
                                text: _buttons[index].text,
                                route: _buttons[index].route,
                              ),
                            ],
                          );
                        } else {
                          
                          return Column(
                            children: [
                              ButtonCustom(
                                icon: _buttons[index].icon,
                                text: _buttons[index].text,
                                route: _buttons[index].route,
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}*/