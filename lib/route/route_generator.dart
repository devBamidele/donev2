import 'package:donev2/screens/add_screen.dart';
import 'package:donev2/screens/category_screen.dart';
import 'package:donev2/screens/edit_screen.dart';
import 'package:donev2/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../model/todo.dart';
import '../screens/splash_screen.dart';

/// Manages navigation through routes
class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SplashScreen.tag:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case HomeScreen.tag:
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
      case AddScreen.tag:
        return MaterialPageRoute(builder: (_) => const AddScreen());
      case EditScreen.tag:
        final args = settings.arguments as Todo;
        return MaterialPageRoute(builder: (_) => EditScreen(id: args));
      case CategoryScreen.tag:
        return MaterialPageRoute(builder: (_) => const CategoryScreen());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    SystemNavigator.pop();
    return MaterialPageRoute(builder: (_) {
      return const Scaffold(
        body: Center(
          child: Text(
            'Sorry, no route was found',
          ),
        ),
      );
    });
  }
}
