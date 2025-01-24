import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:volontariat/app/modules/views/home.dart';
import 'package:volontariat/app/modules/views/landing.dart';
import 'package:volontariat/app/modules/views/rapport.dart';
import 'package:volontariat/app/utils/colors.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Liste des écrans principaux
  final List<Widget> _screens = [HomeScreen(), RapportScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex], // Affiche l'écran actif
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.flip, // Style animé (peut être modifié)
        backgroundColor: mainColor, // Couleur de la barre
        elevation: 5,
        color: Colors.white, // Couleur des icônes inactives
        activeColor: Colors.white, // Couleur des icônes actives

        items: [
          TabItem(icon: Icons.home, title: 'Accueil'),
          TabItem(icon: Icons.message_outlined, title: 'Rapports'),
          TabItem(icon: Icons.person, title: 'Profil'),
          TabItem(icon: Icons.settings, title: 'Paramètres'),
        ],
        initialActiveIndex: _currentIndex, // Par défaut, l'onglet actif
        onTap: (int index) {
          setState(() {
            _currentIndex = index; // Met à jour l'index actif
          });
        },
      ),
    );
  }

  Widget buildTabItem(IconData icon, String title, bool isActive) {
    return Container(
      decoration: BoxDecoration(
        color: isActive
            ? Colors.white
            : Colors.transparent, // Couleur de fond pour l'icône active
        borderRadius:
            BorderRadius.circular(8), // Arrondir les coins si nécessaire
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon,
              color: isActive
                  ? Colors.blue
                  : Colors.white), // Change la couleur de l'icône
          Text(title,
              style: TextStyle(
                  color: isActive
                      ? Colors.blue
                      : Colors.white)), // Change la couleur du texte
        ],
      ),
    );
  }
}
