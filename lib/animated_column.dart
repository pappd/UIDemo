import 'package:flutter/material.dart';

class AnimatedColumn extends StatelessWidget {
  final Widget top;
  final Widget main;
  final Widget bottom;
  final double scale;
  final double maxHeight;
  const AnimatedColumn(this.top, this.main, this.bottom,
      {Key key, this.scale = 1, this.maxHeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
      height: scale > 0.5 ? maxHeight : maxHeight + (scale + 0.5 - 1) * 70,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          scale > 0.5
              ? Opacity(
                  child: top,
                  opacity: scale,
                )
              : SizedBox(),
          //Spacer(),
          main,
          ClipRect(
            child: Align(
              alignment: Alignment.topCenter,
              heightFactor: scale > 0.5 ? 0 : -2 * (scale - 1 + 0.5),
              child: bottom,
            ),
          )
        ],
      ),
    );
  }
}
