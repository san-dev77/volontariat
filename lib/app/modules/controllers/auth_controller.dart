import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Méthode pour se connecter
  Future<User?> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      debugPrint("Utilisateur connecté : ${userCredential.user?.email}");

      // Récupérer les informations de l'utilisateur depuis Firestore
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user?.uid)
          .get();
      if (userDoc.exists) {
        // Récupérer les données de l'utilisateur
        var userData = userDoc.data();

        // Vérifier si le rôle est 'volontaire'
        if (userData is Map<String, dynamic> &&
            userData['role'] == 'volontaire') {
          debugPrint("Données de l'utilisateur  : ${userData["role"]}");
        } else {
          debugPrint("L'utilisateur n'a pas le rôle requis.");
          return null; // Ou gérer le cas où le rôle n'est pas 'volontaire'
        }
      }

      // Afficher la pop-up animée après la connexion réussie
      _showAnimatedPopup(context, userCredential.user);

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      String message = 'Une erreur est survenue.';
      if (e.code == 'user-not-found') {
        message = 'Aucun utilisateur trouvé pour cet email.';
      } else if (e.code == 'wrong-password') {
        message = 'Mot de passe incorrect.';
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
      return null;
    } catch (e) {
      print("Erreur : $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur : $e")),
      );
      return null;
    }
  }

  void _showAnimatedPopup(BuildContext context, User? user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AnimatedDialog(user: user);
      },
    );
  }

  // Méthode pour déconnecter l'utilisateur
  Future<void> logout(BuildContext context) async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, '/login');
    debugPrint("Utilisateur déconnecté.");
  }
}

class AnimatedDialog extends StatelessWidget {
  final User? user;

  AnimatedDialog({required this.user});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Connexion réussie!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('Bienvenue, ${"volontaire "}!'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      ),
    );
  }
}
