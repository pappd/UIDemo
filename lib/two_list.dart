import 'package:flutter/material.dart';

class TwoList extends StatefulWidget {
  final controller;
  const TwoList({Key key, this.controller}) : super(key: key);

  @override
  _TwoListState createState() => _TwoListState();
}

class _TwoListState extends State<TwoList> {
  //var controller = ScrollController();
  var controller2 = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 100,
          child: ListView.builder(
            itemCount: 10,
            controller: widget.controller,
            itemBuilder: (context, index) {
              return Text(
                "Proba1: $index",
                style: TextStyle(fontSize: 32),
              );
            },
          ),
        ),
        // Container(
        //   height: 100,
        //   child: ListView.builder(
        //     itemCount: 10,
        //     controller: controller2,
        //     itemBuilder: (context, index) {
        //       return Text(
        //         "Nagy Proba2: $index",
        //         style: TextStyle(fontSize: 32),
        //       );
        //     },
        //   ),
        // ),
      ],
    );
  }
}
