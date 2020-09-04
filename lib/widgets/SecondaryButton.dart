import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final double fontsize;
  final String title;
  final void Function() function;
  final double width;
  final EdgeInsets margin;
  final Color color;

  SecondaryButton({this.title, this.fontsize, this.function, this.width, this.margin, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: margin,
      child: MaterialButton(
        padding: EdgeInsets.all(20),
        child: Text(
          title,
          style: TextStyle(
              fontSize: fontsize, color: color),
        ),
        onPressed: function,
      ),
    );
  }

}
