import 'package:flutter/material.dart';
import 'package:scrolling_ui/model/transaction.dart';

class TransactionCard extends StatelessWidget {
  final Transaction data;
  final int colorIndex;
  static const myColors = [
    Colors.indigo,
    Colors.indigoAccent,
    Colors.black,
    Colors.blue,
    Colors.orange,
    Colors.deepOrange,
    Colors.purple,
    Colors.deepPurple,
    Colors.red,
    Colors.amberAccent,
    Colors.pink,
    Colors.pinkAccent,
    Colors.green,
    Colors.greenAccent,
    Colors.redAccent,
    Colors.purpleAccent,
    Colors.amber,
    Colors.cyan,
    Colors.blueGrey,
    Colors.brown,
  ];
  const TransactionCard(this.data, {Key key, this.colorIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: colorIndex != null && colorIndex < 20
                  ? myColors[colorIndex]
                  : (data.name == null ? Colors.green : Colors.orangeAccent),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: data.name == null
                  ? Icon(Icons.arrow_upward, size: 28, color: Colors.white)
                  : Text(
                      "${data.name.split(" ")[0][0]}${data.name.split(" ")[1][0]}",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  "${data.name ?? "Top-Up"}",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Text(
                  "${data.date.toString().substring(0, 16)}",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          Text(
            "${data.name == null ? "+" : "-"}${data.amount.round()}€",
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
