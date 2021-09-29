import 'package:flutter/material.dart';
import 'package:newscrypto_wallet/utils/Palete.dart';

class ZAnimatedToggle extends StatefulWidget {
  final List<String> values;
  final bool value;
  final ValueChanged onToggleCallback;
  final bool isOffSame;

  ZAnimatedToggle({
    Key key,
    @required this.values,
    @required this.value,
    @required this.onToggleCallback,
    this.isOffSame = true,
  }) : super(key: key);

  @override
  _ZAnimatedToggleState createState() => _ZAnimatedToggleState();
}

class _ZAnimatedToggleState extends State<ZAnimatedToggle> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width * 0.8,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              widget.onToggleCallback(false);
            },
            child: Container(
              width: width * .8,
              height: width * .14,
              decoration: BoxDecoration(
                  color: Palette.input,
                  borderRadius: BorderRadius.circular(8)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                  widget.values.length,
                  (index) => Text(
                    widget.values[index],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color:  Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          AnimatedAlign(
            alignment:
                widget.value ? Alignment.centerLeft : Alignment.centerRight,
            duration: Duration(milliseconds: 350),
            curve: Curves.ease,
            child: Container(
              alignment: Alignment.center,
              width: width * .4,
              height: width * .14,
              decoration: ShapeDecoration(
                  gradient: getColor(),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
              child: Text(
                widget.value ? widget.values[0] : widget.values[1],
                style: TextStyle(
                    color: Colors.white,
                    fontSize:16,
                    fontWeight: FontWeight.w400),
              ),
            ),
          )
        ],
      ),
    );
  }

  getColor() {
    if (widget.isOffSame) {
      return kDarkToggleActiveColor;
    }
    return !widget.value ? kDarkToggleActiveColor : kDarkToggleColor;
  }
  var kDarkToggleActiveColor = LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      stops: [0, 1],
      colors: [Color(0xff3262af), Color(0xFF35aae1)]);

  var kDarkToggleColor = LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      stops: [1],
      colors: [Color(0xFF414141)]);
}
