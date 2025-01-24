import "package:volontariat/app/components/button.dart";
import "package:volontariat/app/components/text_components.dart";
import "package:volontariat/app/modules/controllers/controller.dart";
import "package:volontariat/app/utils/colors.dart";
import "package:flutter/material.dart";

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {
  @override
  void initState() {
    // time(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height, // Take full height
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center vertically
              children: [
                Image.asset(
                  "assets/icones/logo_app.png",
                  scale: 2,
                ),
                SizedBox(height: 10),
                TextComponents(
                  txt: "Volontariat",
                  fontSize: 40,
                  tpos: TextAlign.center,
                  fw: FontWeight.bold,
                ),
              ],
            ),
          ),
        ));
  }
}
