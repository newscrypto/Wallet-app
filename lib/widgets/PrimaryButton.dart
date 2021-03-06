import 'package:flutter/material.dart';
import 'package:newscrypto_wallet/utils/Palete.dart';

class PrimaryButton extends StatelessWidget {
  final double fontsize;
  final String title;
  final void Function() function;
  final double width;
  final EdgeInsets margin;
  final EdgeInsets padding;

  PrimaryButton(
      {this.title,
      this.fontsize,
      this.function,
      this.width,
      this.margin,
      this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: MaterialButton(
        color: Colors.white,
        textColor: Palette.blue,
        padding: padding,
        child: Text(
          title,
          style: TextStyle(fontSize: fontsize, fontWeight: FontWeight.bold),
        ),
        onPressed: function,
      ),
    );
  }
}
