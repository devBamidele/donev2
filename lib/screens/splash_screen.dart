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
    var duration = const Duration(milliseconds: 2000);
    return Timer(duration, myRoute);
  }

  myRoute() => Navigator.of(context).pushReplacement(_createRoute());

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const HomeScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

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
