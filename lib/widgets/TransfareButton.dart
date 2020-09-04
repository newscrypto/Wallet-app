import 'package:flutter/material.dart';

class AnimatedContainerApp extends StatefulWidget {
  @override
  _AnimatedContainerAppState createState() => _AnimatedContainerAppState();
}

class _AnimatedContainerAppState extends State<AnimatedContainerApp>
    with TickerProviderStateMixin {
  // Define the various properties with default values. Update these properties
  // when the user taps a FloatingActionButton.
  double _width = 0;
  double _height = 0;
  Color _color = Colors.green;
  BorderRadiusGeometry _borderRadius = BorderRadius.circular(70);
  bool opened = false;
  AnimationController _controller;

  @override
  void initState() {
    _controller = new AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: AnimatedContainer(
        child: FlatButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(Icons.compare_arrows),
          // When the user taps the button
          onPressed: () {
            if (_controller.isDismissed) {
              _controller.forward();
            } else {
              _controller.reverse();
            }
            // Use setState to rebuild the widget with new values.
            setState(() {
              if (opened) {
                _width = 70;
                _height = 70;
                _borderRadius = BorderRadius.circular(70);
                opened = false;
              } else {
                // Create a random number generator.
                _width = MediaQuery.of(context).size.width;
                _height = 200;

                // Generate a random border radius.
                _borderRadius = BorderRadius.only(
                    topLeft: Radius.circular(_width.toDouble() * 2),
                    topRight: Radius.circular(_width.toDouble()) * 2);
                opened = true;
              }
            });
          },
        ),
        // Use the properties stored in the State class.
        width: _width,
        height: _height,
        decoration: BoxDecoration(
          color: _color,
          borderRadius: _borderRadius,
        ),
        // Define how long the animation should take.
        duration: Duration(seconds: 1),
        // Provide an optional curve to make the animation feel smoother.
        curve: Curves.easeIn,
      ),
    );
  }
}
