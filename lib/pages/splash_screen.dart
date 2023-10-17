import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

import './contatos_list_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  openHome() {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => const ContatosListPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    openHome();
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.green,
                Colors.white,
              ],
              stops: [
                0.6,
                0.8,
              ])),
        child: Center(
          child: DefaultTextStyle(
            style: const TextStyle(
              fontSize: 40.0,
            ),
            child: AnimatedTextKit(
              animatedTexts: [
                WavyAnimatedText('Lista de contatos!', speed: const Duration(milliseconds: 50)),
              ],
              isRepeatingAnimation: true,
              onTap: () {
              },
            ),
          ),
        ),
    );
  }
}
