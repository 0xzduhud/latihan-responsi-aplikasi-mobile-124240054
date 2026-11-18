import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'pages/login_page.dart';
import 'pages/main_page.dart';
import 'storage/preferences_service.dart';

const Color appBlack = Color(0xFF000000);
const Color cardBlack = Color(0xFF171717);
const Color accentRed = Color(0xFFF44336);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('favorites');

  final isLoggedIn = await PreferencesService.isLoggedIn();
  runApp(LatresApp(isLoggedIn: isLoggedIn));
}

class LatresApp extends StatelessWidget {
  final bool isLoggedIn;
  const LatresApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    final darkScheme = ColorScheme.fromSeed(
      seedColor: accentRed,
      brightness: Brightness.dark,
      surface: cardBlack,
    );

    return MaterialApp(
      title: 'NontonSkuy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: darkScheme.copyWith(
          primary: accentRed,
          secondary: accentRed,
          surface: cardBlack,
        ),
        scaffoldBackgroundColor: appBlack,
        appBarTheme: const AppBarTheme(
          backgroundColor: appBlack,
          foregroundColor: Colors.white,
          centerTitle: false,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          color: cardBlack,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: cardBlack,
          labelStyle: const TextStyle(color: Colors.white70),
          prefixIconColor: Colors.white70,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: const BorderSide(color: Colors.white24),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: const BorderSide(color: accentRed, width: 1.5),
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: appBlack,
          indicatorColor: accentRed.withOpacity(0.18),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            return TextStyle(
              color: states.contains(WidgetState.selected)
                  ? accentRed
                  : Colors.white60,
              fontSize: 12,
            );
          }),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            return IconThemeData(
              color: states.contains(WidgetState.selected)
                  ? accentRed
                  : Colors.white60,
            );
          }),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: accentRed,
            foregroundColor: Colors.white,
            disabledBackgroundColor: Colors.white24,
            disabledForegroundColor: Colors.white54,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
          ),
        ),
        textTheme: ThemeData.dark().textTheme.apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
      ),
      home: isLoggedIn ? const MainPage() : const LoginPage(),
    );
  }
}
