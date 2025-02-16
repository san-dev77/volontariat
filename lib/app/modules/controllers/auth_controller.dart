import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:volontariat/app/modules/views/landing.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Méthode pour se connecter
  Future<User?> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    // Afficher le loader
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // Récupérer les informations de l'utilisateur depuis Firestore
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user?.uid)
          .get();

      // Fermer le loader
      Navigator.pop(context);

      if (userDoc.exists) {
        // Récupérer les données de l'utilisateur
        var userData = userDoc.data();

        // Vérifier si le rôle est 'volontaire'
        if (userData is Map<String, dynamic> &&
            userData['role'] == 'volontaire') {
          // Rediriger vers l'écran d'accueil
          Navigator.pushReplacementNamed(context, '/home');
          return userCredential.user;
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Accès refusé'),
                content: Text("Vous n'êtes pas un volontaire"),
                actions: [
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
          await _auth.signOut();
          return null;
        }
      }

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      // Fermer le loader
      Navigator.pop(context);

      String message = 'Une erreur est survenue.';
      if (e.code == 'user-not-found') {
        message = 'Aucun utilisateur trouvé pour cet email.';
      } else if (e.code == 'wrong-password') {
        message = 'Mot de passe incorrect ou email invalide.';
      } else if (e.code == 'invalid-email') {
        message = 'Format d\'email invalide ou mot de passe incorrect.';
      }

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erreur'),
            content: Text(message),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return null;
    } catch (e) {
      // Fermer le loader
      Navigator.pop(context);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erreur'),
            content: Text("Une erreur inattendue s'est produite"),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return null;
    }
  }

  // Méthode pour déconnecter l'utilisateur
  Future<void> logout(BuildContext context) async {
    await _auth.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => Landing()),
      (Route<dynamic> route) => false,
    );
  }
}
