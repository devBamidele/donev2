import 'package:donev2/screens/add_screen.dart';
import 'package:donev2/screens/category_screen.dart';
import 'package:donev2/screens/edit_screen.dart';
import 'package:donev2/screens/home_screen.dart';
import 'package:flutter/material.dart';

import '../model/todo.dart';
import '../screens/search_screen.dart';
import '../screens/splash_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SplashScreen.tag:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case HomeScreen.tag:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case AddScreen.tag:
        return MaterialPageRoute(builder: (_) => const AddScreen());
      case EditScreen.tag:
        final args = settings.arguments as Todo;
        return MaterialPageRoute(builder: (_) => EditScreen(id: args));
      case CategoryScreen.tag:
        return MaterialPageRoute(builder: (_) => const CategoryScreen());
      case SearchScreen.tag:
        return MaterialPageRoute(builder: (_) => const SearchScreen());
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
