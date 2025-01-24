import "package:flutter/material.dart";

class TextComponents extends StatelessWidget {
  Color color;
  FontWeight fw;
  double fontSize;
  TextAlign tpos;
  String txt;
  EdgeInsetsGeometry margin;
  EdgeInsetsGeometry padding;

  TextComponents({
    super.key,
    required this.txt,
    this.color = Colors.black,
    this.fontSize = 16,
    this.fw = FontWeight.normal,
    this.tpos = TextAlign.center,
    this.margin = const EdgeInsets.all(0),
    this.padding = const EdgeInsets.all(0),
  });
  @override
  Widget build(BuildContext context) {
    return Text(
      txt,
      style: TextStyle(color: color, fontSize: fontSize, fontWeight: fw),
    );
  }
}
