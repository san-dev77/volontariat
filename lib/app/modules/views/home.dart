import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:volontariat/app/components/caroussel.dart';
import 'package:volontariat/app/components/text_components.dart';
import 'package:volontariat/app/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    final user = context.watch<User?>();

    if (user == null) {
      return Center(
        child: Text('Chargement des données utilisateur...'),
      );
    }

    String initials = user.displayName != null && user.displayName!.isNotEmpty
        ? user.displayName!
            .split(" ")
            .map((e) => e[0])
            .take(2)
            .join()
            .toUpperCase()
        : user.email!.substring(0, 2).toUpperCase();

    return Scaffold(
      body: Column(
        children: [
          // Zone supérieure (avatar, texte de bienvenue, icône de notifications)
          Container(
            height: MediaQuery.of(context).size.height * 0.25,
            color: mainColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 70,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Avatar avec les initiales
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 28,
                        child: Text(
                          initials,
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Bienvenue, volontaire !",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                user.email ?? "",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Icône de notifications
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ],
                  ),
                  // Texte de bienvenue

                  // Date
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      ' ${DateFormat('EEEE, d MMMM').format(DateTime.now())}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ),

          // Contenu principal
          Expanded(
            child: Column(
              children: [
                SizedBox(height: 5),
                _buildClassicCard(
                    image: 'assets/icones/logo_app.png',
                    title: 'Motivation du jour 🎯💪',
                    text: "lorem ipsum dolor concpetor truc test test "),
                SizedBox(height: 10),
                TextComponents(
                  txt: "Actualités",
                  color: Colors.black,
                  fw: FontWeight.bold,
                  fontSize: 17,
                ),

                CarouselCard(
                  card1: _buildCard(
                    image: 'assets/img/activity1.png',
                    text: 'Actualité 1 : Découvrez nos nouveaux projets !',
                  ),
                  card2: _buildCard(
                    image: 'assets/img/activity2.png',
                    text: 'Actualité 2 : Rejoignez notre programme !',
                  ),
                ),
                // Nouvelle Card ajoutée
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildCard({required String image, required String text}) {
  return Card(
    elevation: 5,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    child: Container(
      width: 300,
      height: 200,
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.asset(
                image,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildClassicCard(
    {required String image, required String title, required String text}) {
  return Card(
    elevation: 10,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Image.asset(
            image,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
          SizedBox(width: 10),
          Expanded(
              child: Column(
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
              Text(
                text,
                style: TextStyle(fontSize: 16),
              ),
            ],
          )),
        ],
      ),
    ),
  );
}
