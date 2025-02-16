import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:volontariat/app/modules/splash/splash_screen.dart';
import 'package:volontariat/app/modules/views/home.dart';
import 'package:volontariat/app/modules/views/landing.dart';
import 'package:volontariat/app/modules/views/login.dart'; // Chemin de ton écran de connexion
import 'package:volontariat/app/modules/views/main_screen.dart';
import 'package:volontariat/app/utils/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(); // Initialisation de Firebase
    debugPrint("Firebase initialisé avec succès !");
  } catch (e) {
    debugPrint("Erreur lors de l'initialisation de Firebase : $e");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
      value:
          FirebaseAuth.instance.authStateChanges(), // Stream d'état utilisateur
      initialData: null,
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: mainColor),
          useMaterial3: true,
        ),
        home: SplashScreenWrapper(), // Afficher d'abord le SplashScreen
      ),
    );
  }
}

class SplashScreenWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(
          Duration(seconds: 3)), // Afficher le SplashScreen pendant 3 secondes
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return AuthWrapper(); // Une fois le délai écoulé, vérifier l'état de l'utilisateur
        } else {
          return SplashScreen(); // Afficher le SplashScreen pendant 3 secondes
        }
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context); // Accès à l'utilisateur actuel

    // Redirection vers l'écran de connexion si l'utilisateur est déconnecté
    if (user == null) {
      return Landing();
    } else {
      return MainScreen(); // Si l'utilisateur est connecté, rediriger vers la page d'accueil
    }
  }
}
