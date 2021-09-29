import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'CircleBlur.dart';
import 'RectBlurPainter.dart';

class BackgroundSecondaryStack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Color(0xff191415),
            )),
        // Container(
        //     width: MediaQuery.of(context).size.width,
        //     height: MediaQuery.of(context).size.height,
        //     decoration: BoxDecoration(
        //       image: DecorationImage(
        //         image: AssetImage('assets/images/background-dots.png'),
        //         fit: BoxFit.cover,
        //       ),
        //     )),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Image.asset(
            'assets/images/background-dots.png',
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}
