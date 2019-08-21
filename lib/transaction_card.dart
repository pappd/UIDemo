import 'package:flutter/material.dart';
import 'package:scrolling_ui/model/transaction.dart';

class TransactionCard extends StatelessWidget {
  final Transaction data;
  const TransactionCard(this.data, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.fromLTRB(0, 5, 10, 5),
      leading: Container(
        margin: EdgeInsets.all(0),
        height: 75,
        width: 75,
        decoration: BoxDecoration(
          color: Colors.orangeAccent,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            "${data.name.split(" ")[0][0]}${data.name.split(" ")[1][0]}",
            style: TextStyle(fontSize: 22, color: Colors.white),
          ),
        ),
      ),
      title: Text(
        "${data.name}",
        style: TextStyle(
          fontSize: 20,
        ),
      ),
      subtitle: Text("${data.date.toString().substring(0, 16)}"),
      trailing: Text(
        "${data.name == null ? "+" : "-"}${data.amount}",
        style: TextStyle(
          fontSize: 20,
        ),
      ),
    );
  }
}
