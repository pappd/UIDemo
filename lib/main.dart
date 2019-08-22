import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:scrolling_ui/currency_balance.dart';
import 'package:scrolling_ui/model/transaction.dart';
import 'package:scrolling_ui/transaction_card.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Collapsing List Demo')),
        body: CollapsingList(),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;
  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(
      child: Stack(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Icon(Icons.arrow_upward),
              Icon(Icons.arrow_drop_down_circle),
            ],
          ),
          SizedBox.expand(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                //Text("${shrinkOffset}"),
                Container(
                  width: 350,
                  height: 70,
                  child: CurrencyBalance(
                    visibility:
                        max((200 - 100 - shrinkOffset) / (200 - 100), 0.0),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

class CollapsingList extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();
  SliverPersistentHeader makeHeader(String headerText) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverAppBarDelegate(
        minHeight: 70.0,
        maxHeight: 200.0,
        child: Container(
            color: Colors.lightBlue, child: Center(child: Text(headerText))),
      ),
    );
  }

  bool _onNotification(Notification notification) {
    if (notification is ScrollNotification) {
      print(notification.metrics.pixels.toString());

      if (_userStoppedScrolling(notification, _scrollController)) {
        if (notification.metrics.pixels < 40) {
          _scrollController.animateTo(0,
              duration: Duration(milliseconds: 1000), curve: ElasticOutCurve());
        } else if (notification.metrics.pixels < 100) {
          _scrollController.animateTo(130,
              duration: Duration(milliseconds: 1000), curve: ElasticOutCurve());
        }
      }
    }
    return true;
  }

  ///indicates if user has stopped scrolling so we can center value in the middle
  bool _userStoppedScrolling(
      Notification notification, ScrollController scrollController) {
    return notification is UserScrollNotification &&
        notification.direction == ScrollDirection.idle &&
        scrollController.position.activity is! HoldScrollActivity;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: _onNotification,
      child: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          makeHeader('Header Section 1'),
          SliverGrid.count(
            crossAxisCount: 3,
            children: [
              Container(color: Colors.red, height: 150.0),
              Container(color: Colors.purple, height: 150.0),
              Container(color: Colors.green, height: 150.0),
              Container(color: Colors.orange, height: 150.0),
              Container(color: Colors.yellow, height: 150.0),
              Container(color: Colors.pink, height: 150.0),
              Container(color: Colors.cyan, height: 150.0),
              Container(color: Colors.indigo, height: 150.0),
              Container(color: Colors.blue, height: 150.0),
            ],
          ),
          makeHeader('Header Section 2'),
          SliverFixedExtentList(
            itemExtent: 150.0,
            delegate: SliverChildListDelegate(
              [
                // CurrencyPicker(
                //   onChanged: (num) {},
                //   initialValue: 1,
                // ),
                // Container(
                //   child: Row(
                //     children: <Widget>[
                //       CurrencyBalance(),
                //     ],
                //   ),
                //   //color: Colors.blueAccent,
                // ),
                Container(
                  color: Colors.red,
                  height: 50,
                  child: FittedBox(
                    child: Text(
                      "hosszi fngremlk neirmfe  pvrsadd vege",
                      softWrap: true,
                      style: TextStyle(fontSize: 40),
                      maxLines: 3,
                    ),
                  ),
                ),
                Container(color: Colors.purple),
                Container(color: Colors.green),
                Container(color: Colors.orange),
                Container(color: Colors.yellow),
              ],
            ),
          ),
          //makeHeader('Header Section 3'),
          SliverGrid(
            gridDelegate: new SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200.0,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: 4.0,
            ),
            delegate: new SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return new Container(
                  alignment: Alignment.center,
                  color: Colors.teal[100 * (index % 9)],
                  child: new Text('grid item $index'),
                );
              },
              childCount: 20,
            ),
          ),
          //makeHeader('Header Section 4'),
          // Yes, this could also be a SliverFixedExtentList. Writing
          // this way just for an example of SliverList construction.
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(color: Colors.pink, height: 150.0),
                Container(color: Colors.cyan, height: 150.0),
                Container(color: Colors.indigo, height: 150.0),
                Container(color: Colors.blue, height: 150.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
