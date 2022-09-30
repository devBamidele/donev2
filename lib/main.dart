import 'package:donev2/bloc/todo_bloc.dart';
import 'package:donev2/route/route_generator.dart';
import 'package:donev2/screens/splash_screen.dart';
import 'package:donev2/theme_data/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'notification/notification_service.dart';
import 'package:responsive_framework/responsive_framework.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TodoBloc>(
      create: (_) => TodoBloc(),
      child: MaterialApp(
        // Make it responsive to different screen sizes
        builder: (context, child) => ResponsiveWrapper.builder(
          child,
          maxWidth: 1700,
          minWidth: 350,
          defaultScale: true,
          breakpoints: [
            // The responsive breakpoints for various screen sizes
            const ResponsiveBreakpoint.resize(350, name: MOBILE),
            const ResponsiveBreakpoint.autoScale(600, name: TABLET),
            const ResponsiveBreakpoint.resize(800, name: DESKTOP),
            const ResponsiveBreakpoint.autoScale(1700, name: 'XL'),
          ],
        ),
        theme: MyTheme().themeData,
        debugShowCheckedModeBanner: false,
        initialRoute: SplashScreen.tag,
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}
