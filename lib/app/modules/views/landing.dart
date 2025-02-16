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
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/img/bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.7),
                Colors.black.withOpacity(0.5),
              ],
            ),
          ),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              SizedBox(
                width: 200,
                height: MediaQuery.of(context).size.height * 0.20,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  "assets/img/logo_blanc.jpg",
                  width: 300, // Ajustez cette valeur selon vos besoins
                  height: 150, // Ajustez cette valeur selon vos besoins
                  fit: BoxFit.cover,
                ),
              ),
              TextComponents(
                txt: "Volontariat",
                fw: FontWeight.bold,
                fontSize: 30,
                color: Colors.white,
              ),
              SizedBox(height: 150),
              TextComponents(
                txt: "Bienvenu à vous volontaire !",
                fw: FontWeight.bold,
                fontSize: 25,
                color: Colors.white,
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
                  color: Colors.white,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: Button(textButton: "Démarrer"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
