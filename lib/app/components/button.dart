import "package:volontariat/app/utils/colors.dart";
import "package:flutter/material.dart";

class Button extends StatelessWidget {
  String textButton;
  Button({super.key, required this.textButton});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width / 2,
      decoration: BoxDecoration(
        color: mainColor,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Center(
        child: Text(
          textButton,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}
