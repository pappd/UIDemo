import 'package:flutter/material.dart';

class AnimatedColumn extends StatelessWidget {
  final Widget top;
  final Widget main;
  final Widget bottom;
  final double scale;
  const AnimatedColumn(this.top, this.main, this.bottom,
      {Key key, this.scale = 1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Visibility(
          child: Opacity(
            child: top,
            opacity: scale,
          ),
          visible: scale > 0.5,
        ),
        Spacer(),
        main,
        ClipRect(
          child: Align(
            alignment: Alignment.topCenter,
            heightFactor: -(scale - 1),
            child: bottom,
          ),
        )
      ],
    );
  }
}
