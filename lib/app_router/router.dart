import 'package:auto_route/auto_route.dart';
import 'package:donev2/screens/category_screen.dart';
import 'package:donev2/screens/splash_screen.dart';

import '../screens/add_screen.dart';
import '../screens/edit_screen.dart';
import '../screens/home_screen.dart';

@MaterialAutoRouter(
  routes: <AutoRoute>[
    AutoRoute(page: SplashScreen, initial: true),
    CustomRoute(
      path: HomeScreen.tag,
      page: HomeScreen,
      //customRouteBuilder:,
    ),
    AutoRoute(path: AddScreen.tag, page: AddScreen),
    AutoRoute(path: EditScreen.tag, page: EditScreen),
    AutoRoute(path: CategoryScreen.tag, page: CategoryScreen),
  ],
)
class $AppRouter {}
