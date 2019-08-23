import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:scrolling_ui/chart.dart';
import 'package:scrolling_ui/currency_balance.dart';
import 'package:scrolling_ui/date_selection.dart';
import 'package:scrolling_ui/model/main_model.dart';
import 'package:scrolling_ui/model/transaction.dart';
import 'package:scrolling_ui/three_buttons.dart';
import 'package:scrolling_ui/transaction_card.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import 'animated_column.dart';

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
    this.data,
    this.minHeight = 270,
    this.maxHeight = 500,
    this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;
  final MainModel data;
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
          Container(
            margin: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Icon(Icons.account_balance),
                Icon(Icons.search),
              ],
            ),
          ),
          SizedBox.expand(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 350,
                  height: 70,
                  child: CurrencyBalance(
                    visibility:
                        max((200 - 100 - shrinkOffset) / (200 - 100), 0.0),
                  ),
                ),
                Container(
                  height: 130,
                  child: AnimatedColumn(
                    ThreeButtons(),
                    child,
                    DateSelection(
                      list: data.transactions,
                      selectedIndex: 1,
                    ),
                    scale: max((300 - 200 - shrinkOffset) / (300 - 200), 0.0),
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

class CollapsingList extends StatefulWidget {
  @override
  _CollapsingListState createState() => _CollapsingListState();
}

class _CollapsingListState extends State<CollapsingList> {
  final ScrollController _scrollController = ScrollController();

  final ScrollController _scrollController2 = ScrollController();

  //bool mutex = true;
  double scrollPosition = 0;
  double previousScrollPosition = 0;
  int selectedIndex = 0;
  var data = MainModel();

  @override
  void initState() {
    super.initState();
    data.createRandomTransactions();
    Timer.periodic(Duration(milliseconds: 16), (timer) {
      chartCallback(scrollPosition, isVertical: true);
    });
  }

  void chartCallback(double position, {bool isVertical = false}) {
    if ((previousScrollPosition - position).abs() > 5) {
      setState(() {
        selectedIndex = (position + 0) ~/ (360 / 8);
        print(selectedIndex.toString());
      });
      if (isVertical) {
        _scrollController2.jumpTo(position);
        previousScrollPosition = position;
      } else {
        // TODO
        _scrollController.animateTo(position,
            duration: Duration(milliseconds: 1000), curve: ElasticOutCurve());
      }
    }
  }

  SliverPersistentHeader makeHeader(String headerText) {
    return SliverPersistentHeader(
      pinned: true,
      floating: true,
      delegate: _SliverAppBarDelegate(
        data: data,
        child: Chart(
          elements: [
            for (int i = 0; i < data.transactions.length; i++)
              data.transactions[i].amount
          ],
          controller: _scrollController2,
          selectedIndex: selectedIndex,
          onChanged: chartCallback,
        ),
      ),
    );
  }

  bool _onNotification(Notification notification) {
    if (notification is ScrollNotification) {
      //print(notification.metrics.pixels.toString());
      if (notification.metrics.axis == Axis.vertical) {
        scrollPosition = min(notification.metrics.pixels, 960);
      }

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
          makeHeader('Header Section 2'),
          SliverFixedExtentList(
            itemExtent: 60.0,
            delegate: SliverChildListDelegate(
              [
                for (int i = 0; i < data.transactions.length; i++)
                  TransactionCard(
                    data.transactions[i],
                    colorIndex:
                        data.contacts.indexOf(data.transactions[i].name),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
