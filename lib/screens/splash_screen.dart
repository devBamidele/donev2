import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:donev2/bloc/todo_bloc.dart';
import 'package:donev2/constants.dart';
import 'package:donev2/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  static const tag = '/splash';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  initState() {
    super.initState();
    startTime();
  }

  startTime() async {
    return Timer(const Duration(milliseconds: 2000), myRoute);
  }

  myRoute() => Navigator.of(context).pushReplacementNamed(HomeScreen.tag);

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoBloc>(
      builder: (BuildContext context, data, Widget? child) {
        return Scaffold(
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 80),
                child: AnimatedTextKit(
                  onFinished: () {
                    data.verifyKey();
                    data.setMaxChar(context);
                  },
                  totalRepeatCount: 1,
                  isRepeatingAnimation: false,
                  animatedTexts: [
                    TyperAnimatedText(
                      'DONE',
                      textStyle: const TextStyle(
                        fontFamily: 'Asap',
                        fontStyle: FontStyle.italic,
                        letterSpacing: 2.5,
                        color: kShadowColor,
                        fontSize: 95,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                      speed: const Duration(milliseconds: 320),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
