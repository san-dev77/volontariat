import "package:volontariat/app/modules/views/landing.dart";
import "package:flutter/material.dart";

time(BuildContext context) {
  Future.delayed(Duration(seconds: 3), () {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Landing(),
        ));
    // print('splash !!!!');
  });
}
