import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final double fontsize;
  final String title;
  final void Function() function;
  final double width;
  final EdgeInsets margin;
  final Color color;
  final bool isTransparent;

  SecondaryButton({
    this.title,
    this.fontsize,
    this.function,
    this.width,
    this.margin,
    this.color,
    this.isTransparent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: margin,
      decoration: getBackground(),
      child: MaterialButton(
        padding: EdgeInsets.all(10),
        child: Text(
          title,
          style: TextStyle(fontSize: fontsize, color: color),
        ),
        onPressed: function,
      ),
    );
  }

  getBackground() {
    if (isTransparent) {
      return BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.all(Radius.circular(8)));
    }
    return BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: <Color>[Color(0xff35B7EA), Color(0xff314C9F)]),
        borderRadius: BorderRadius.all(Radius.circular(8)));
  }
}
