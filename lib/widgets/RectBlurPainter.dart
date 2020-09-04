
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RectBlurPainter extends CustomPainter {

  RectBlurPainter({@required this.circleWidth, this.blurSigma, this.color});

  double circleWidth;
  double blurSigma;
  Color color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint line = new Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurSigma);
    final rect = Rect.fromLTRB(0, 0, circleWidth, circleWidth);
    canvas.drawRect(rect, line);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}