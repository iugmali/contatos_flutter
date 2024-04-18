import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

import './contatos_list_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void Function() openHome = () {};


  @override
  initState() {
    super.initState();
    openHome = () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const ContatosListPage()));
    };
  }

  @override
  Widget build(BuildContext context) {

    const gradientColors = [
      Colors.green,
      Color.fromARGB(255, 200, 200, 200),
      Colors.white,
    ];
    const colorizeColors = [
      Color.fromARGB(200, 255, 255, 255),
      Color.fromARGB(200, 230, 255, 230),
      Color.fromARGB(200, 10, 150, 10),
      Color.fromARGB(200, 100, 255, 0),
    ];
    var animatedText = AnimatedTextKit(
      animatedTexts: [
        ColorizeAnimatedText('Lista de Contatos', textAlign: TextAlign.center, textStyle: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 50),colors: colorizeColors),
      ],
      totalRepeatCount: 5,
      isRepeatingAnimation: false,
      onTap: () {
      },
      onFinished: openHome,
    );

    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradientColors,
              stops: [
                0.3,
                0.8,
                0.95,
              ])),
        child: Center(
          child: SizedBox(
            width: 250.0,
            child: animatedText
          ),
        ),
    );
  }
}
