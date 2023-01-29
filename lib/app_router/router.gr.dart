// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i6;
import 'package:donev2/model/todo.dart' as _i8;
import 'package:donev2/screens/add_screen.dart' as _i3;
import 'package:donev2/screens/category_screen.dart' as _i5;
import 'package:donev2/screens/edit_screen.dart' as _i4;
import 'package:donev2/screens/home_screen.dart' as _i2;
import 'package:donev2/screens/splash_screen.dart' as _i1;
import 'package:flutter/material.dart' as _i7;

class AppRouter extends _i6.RootStackRouter {
  AppRouter([_i7.GlobalKey<_i7.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i6.PageFactory> pagesMap = {
    SplashScreenRoute.name: (routeData) {
      return _i6.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i1.SplashScreen(),
      );
    },
    HomeScreenRoute.name: (routeData) {
      return _i6.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i2.HomeScreen(),
        transitionsBuilder: _i6.TransitionsBuilders.slideLeft,
        durationInMilliseconds: 200,
        opaque: true,
        barrierDismissible: false,
      );
    },
    AddScreenRoute.name: (routeData) {
      return _i6.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i3.AddScreen(),
      );
    },
    EditScreenRoute.name: (routeData) {
      final args = routeData.argsAs<EditScreenRouteArgs>();
      return _i6.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i4.EditScreen(
          id: args.id,
          key: args.key,
        ),
      );
    },
    CategoryScreenRoute.name: (routeData) {
      return _i6.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i5.CategoryScreen(),
      );
    },
  };

  @override
  List<_i6.RouteConfig> get routes => [
        _i6.RouteConfig(
          SplashScreenRoute.name,
          path: '/',
        ),
        _i6.RouteConfig(
          HomeScreenRoute.name,
          path: '/home',
        ),
        _i6.RouteConfig(
          AddScreenRoute.name,
          path: '/add',
        ),
        _i6.RouteConfig(
          EditScreenRoute.name,
          path: '/edit',
        ),
        _i6.RouteConfig(
          CategoryScreenRoute.name,
          path: '/category',
        ),
      ];
}

/// generated route for
/// [_i1.SplashScreen]
class SplashScreenRoute extends _i6.PageRouteInfo<void> {
  const SplashScreenRoute()
      : super(
          SplashScreenRoute.name,
          path: '/',
        );

  static const String name = 'SplashScreenRoute';
}

/// generated route for
/// [_i2.HomeScreen]
class HomeScreenRoute extends _i6.PageRouteInfo<void> {
  const HomeScreenRoute()
      : super(
          HomeScreenRoute.name,
          path: '/home',
        );

  static const String name = 'HomeScreenRoute';
}

/// generated route for
/// [_i3.AddScreen]
class AddScreenRoute extends _i6.PageRouteInfo<void> {
  const AddScreenRoute()
      : super(
          AddScreenRoute.name,
          path: '/add',
        );

  static const String name = 'AddScreenRoute';
}

/// generated route for
/// [_i4.EditScreen]
class EditScreenRoute extends _i6.PageRouteInfo<EditScreenRouteArgs> {
  EditScreenRoute({
    required _i8.Todo id,
    _i7.Key? key,
  }) : super(
          EditScreenRoute.name,
          path: '/edit',
          args: EditScreenRouteArgs(
            id: id,
            key: key,
          ),
        );

  static const String name = 'EditScreenRoute';
}

class EditScreenRouteArgs {
  const EditScreenRouteArgs({
    required this.id,
    this.key,
  });

  final _i8.Todo id;

  final _i7.Key? key;

  @override
  String toString() {
    return 'EditScreenRouteArgs{id: $id, key: $key}';
  }
}

/// generated route for
/// [_i5.CategoryScreen]
class CategoryScreenRoute extends _i6.PageRouteInfo<void> {
  const CategoryScreenRoute()
      : super(
          CategoryScreenRoute.name,
          path: '/category',
        );

  static const String name = 'CategoryScreenRoute';
}
