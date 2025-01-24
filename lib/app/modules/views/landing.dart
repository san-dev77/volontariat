import "package:volontariat/app/components/button.dart";
import "package:volontariat/app/modules/views/login.dart";
import "package:volontariat/app/utils/colors.dart";
import "package:volontariat/app/components/text_components.dart";
import "package:flutter/material.dart";

class Landing extends StatelessWidget {
  const Landing({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondColor,
      ),
      body: Container(
        color: secondColor,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            SizedBox(
              width: 200,
              height: 50,
            ),
            Image.asset(
              "assets/icones/logo_app.png",
              scale: 2.8,
            ),
            TextComponents(
              txt: "Volontariat",
              fw: FontWeight.bold,
              fontSize: 30,
            ),
            SizedBox(height: 150), // Adding space between the text and the logo
            TextComponents(
              txt: "Bienvenu à vous volontaire !",
              fw: FontWeight.bold,
              fontSize: 20,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              padding: EdgeInsets.all(10),
              child: TextComponents(
                txt:
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                fw: FontWeight.normal,
                fontSize: 16,
                tpos: TextAlign.center,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          LoginScreen()), // Navigate to the next page
                );
              },
              child: Button(textButton: "Démarrer"),
            )
          ],
        ),
      ),
    );
  }
}
