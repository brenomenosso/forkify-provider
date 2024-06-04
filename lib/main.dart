import 'package:asyncstate/asyncstate.dart';
import 'package:flutter/material.dart';
import 'package:forky_app_provider/pages/splash_page.dart';
import 'package:forky_app_provider/providers/dishe_proivider.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DisheProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AsyncStateBuilder(builder: (navigatorObserver) {
      return MaterialApp(
        title: 'Dishe App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        navigatorObservers: [navigatorObserver],
        home: const SplashPage(),
      );
    });
  }
}
