import 'package:donev2/bloc/todo_bloc.dart';
import 'package:donev2/theme_data/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_router/router.gr.dart';
import 'notification/notification_service.dart';
import 'package:responsive_framework/responsive_framework.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // Get an instance of the App Router
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TodoBloc>(
      create: (_) => TodoBloc(),
      child: MaterialApp.router(
        // Make it responsive to different screen sizes
        builder: (context, child) => ResponsiveWrapper.builder(
          child,
          maxWidth: 1700,
          minWidth: 350,
          defaultScale: true,
          breakpoints: [
            // Define the breakpoints
            const ResponsiveBreakpoint.resize(350, name: MOBILE),
            const ResponsiveBreakpoint.autoScale(600, name: TABLET),
            const ResponsiveBreakpoint.resize(800, name: DESKTOP),
            const ResponsiveBreakpoint.autoScale(1700, name: 'XL'),
          ],
        ),
        theme: MyTheme().themeData,
        debugShowCheckedModeBanner: false,
        routerDelegate: _appRouter.delegate(),
        routeInformationParser: _appRouter.defaultRouteParser(),
      ),
    );
  }
}
