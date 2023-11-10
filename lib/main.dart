import 'package:bike_app/firebase_options.dart';
import 'package:bike_app/router.dart';
import 'package:bike_app/t_app_theme.dart';
import 'package:bike_app/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bike Tracker',
      debugShowCheckedModeBanner: false,
      home: const SignInWrapper(),
      themeMode: ThemeMode.dark,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      onGenerateRoute: generateRoute,
    );
  }
}
