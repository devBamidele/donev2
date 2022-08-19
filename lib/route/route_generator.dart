import 'package:donev2/screens/add_screen.dart';
import 'package:donev2/screens/category_screen.dart';
import 'package:donev2/screens/home_screen.dart';
import 'package:flutter/material.dart';

import '../model/todo.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case HomeScreen.tag:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case AddScreen.tag:
        final args = settings.arguments as Todo?;
        return MaterialPageRoute(builder: (_) => AddScreen(id: args));
      case CategoryScreen.tag:
        return MaterialPageRoute(builder: (_) => const CategoryScreen());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
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