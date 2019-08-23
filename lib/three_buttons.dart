import 'package:flutter/material.dart';

class ThreeButtons extends StatelessWidget {
  static const icons = [Icons.add, Icons.refresh, Icons.info];
  static const texts = ["Add Money", "Exchange", "Details"];
  const ThreeButtons({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          for (int i = 0; i < 3; i++)
            Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue[500],
                  ),
                  child: Icon(
                    icons[i],
                    color: Colors.white,
                  ),
                ),
                // SizedBox(
                //   height: 10,
                // ),
                Text(
                  texts[i],
                  style: TextStyle(color: Colors.blue[500], fontSize: 16),
                )
              ],
            )
        ],
      ),
    );
  }
}
