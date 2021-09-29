import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'CircleBlur.dart';
import 'RectBlurPainter.dart';

class BackgroundStack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomLeft,
                  colors: [Color(0xff314C9F), Color(0xff35B7EA)])),
        ),
        // Opacity(
        //   opacity: 0.25,
        //   child: Align(
        //     alignment: Alignment.centerRight,
        //     child: Container(
        //       margin: EdgeInsets.only(
        //         top: MediaQuery.of(context).size.height * 0.2,
        //         right: MediaQuery.of(context).size.height * 0.1,
        //       ),
        //       child: CustomPaint(
        //         foregroundPainter: RectBlurPainter(
        //           circleWidth: MediaQuery.of(context).size.height * 0.15,
        //           blurSigma: 10.0,
        //           color: Colors.blueAccent,
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        // Opacity(
        //   opacity: 0.2,
        //   child: Align(
        //     alignment: Alignment.topLeft,
        //     child: Container(
        //       margin: EdgeInsets.only(
        //         top: MediaQuery.of(context).size.height * 0.2,
        //         right: MediaQuery.of(context).size.height * 0.1,
        //       ),
        //       child: CustomPaint(
        //         foregroundPainter: RectBlurPainter(
        //           circleWidth: MediaQuery.of(context).size.height * 0.1,
        //           blurSigma: 6.0,
        //           color: Colors.blueAccent,
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        // Opacity(
        //   opacity: 0.3,
        //   child: Align(
        //     alignment: Alignment.bottomLeft,
        //     child: Container(
        //       margin: EdgeInsets.only(
        //         bottom: MediaQuery.of(context).size.height * 0.1,
        //         right: MediaQuery.of(context).size.width * 0.3,
        //       ),
        //       child: CustomPaint(
        //         foregroundPainter:
        //             CircleBlurPainter(circleWidth: 300, blurSigma: 100.0),
        //       ),
        //     ),
        //   ),
        // ),
        // Opacity(
        //   opacity: 0.3,
        //   child: Align(
        //     alignment: Alignment.topRight,
        //     child: Container(
        //       margin: EdgeInsets.only(top: 100),
        //       child: CustomPaint(
        //         foregroundPainter:
        //             CircleBlurPainter(circleWidth: 400, blurSigma: 40),
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
