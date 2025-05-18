import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movelytics_app/firebase_options.dart';
import 'package:movelytics_app/providers/firebase_auth_provider.dart';
import 'package:movelytics_app/providers/shared_preference_provider.dart';
import 'package:movelytics_app/services/firebase_auth_service.dart';
import 'package:movelytics_app/services/shared_preference_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';
import 'theme/app_theme.dart';
import 'providers/theme_provider.dart';
import 'providers/user_provider.dart';
import 'providers/terminal_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final pref = await SharedPreferences.getInstance();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final firebaseAuth = FirebaseAuth.instance;
  final firebaseFirestore = FirebaseFirestore.instance;

  runApp(
    MultiProvider(
      providers: [
        Provider(
          create: (context) => FirebaseAuthService(
            firebaseAuth,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => FirebaseAuthProvider(
            context.read<FirebaseAuthService>(),
          ),
        ),
        Provider(
          create: (context) => SharedPreferencesService(
            pref,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => SharedPreferenceProvider(
            context.read<SharedPreferencesService>(),
          ),
        ),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => TerminalProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Visualisasi Kepadatan Penumpang',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      home: const LoginScreen(),
    );
  }
}
