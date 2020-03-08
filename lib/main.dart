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
//import 'package:provider/provider.dart';
import 'dart:math';

import 'animated_column.dart';

void main() {
  //debugPaintSizeEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Scrolling List Demo by David Papp')),
        body: CollapsingList(),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    this.data,
    this.minHeight = 280,
    this.maxHeight = 370,
    this.children,
  });
  final double minHeight;
  final double maxHeight;
  final List<Widget> children;
  final MainModel data;
  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
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
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  width: 350,
                  child: CurrencyBalance(
                    visibility: max(
                        (maxHeight - minHeight - shrinkOffset) /
                            (maxHeight - minHeight),
                        0.0),
                  ),
                ),
                AnimatedColumn(
                  ThreeButtons(),
                  children[0],
                  children[1],
                  maxHeight: 255,
                  scale: max(
                      (maxHeight - minHeight - shrinkOffset) /
                          (maxHeight - minHeight),
                      0.0),
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
        children != oldDelegate.children;
  }
}

class CollapsingList extends StatefulWidget {
  static const transactionItemHeight = 60.0;
  static const minSliverAppBarHeight = 280.0;
  static const maxSliverAppBarHeight = 370.0;

  static int index(double globalPosition) =>
      globalPosition * transactionItemHeight ~/ transactionItemHeight;

  static double toMyPositon(double globalPosition) =>
      globalPosition * transactionItemHeight +
      (maxSliverAppBarHeight - minSliverAppBarHeight);

  static double toGlobalPositon(double myPosition) =>
      max(myPosition - (maxSliverAppBarHeight - minSliverAppBarHeight), 0) /
      transactionItemHeight;

  @override
  _CollapsingListState createState() => _CollapsingListState();
}

enum ScrollingAnimation {
  //notAllowed,
  mainViewHasTo,
  charHasTo,
  bothHasTo
}

class _CollapsingListState extends State<CollapsingList> {
  final ScrollController _mainScrollController = ScrollController();

  final ScrollController _chartScrollController = ScrollController();

  double globalPosition = 0;
  double previousGlobalPosition = 0;
  int selectedIndex = 0;
  var scrollingAnimation = ScrollingAnimation.charHasTo;
  var isScrollingAnimationAllowed = true;
  var data = MainModel();

  @override
  void initState() {
    super.initState();
    data.createRandomTransactions();
    Timer.periodic(Duration(milliseconds: 16), (timer) {
      if ((previousGlobalPosition - globalPosition).abs() > 5 / 60) {
        previousGlobalPosition = globalPosition;
        if (scrollingAnimation == ScrollingAnimation.mainViewHasTo &&
            isScrollingAnimationAllowed) {
          isScrollingAnimationAllowed = false;
          _mainScrollController
              .jumpTo(CollapsingList.toMyPositon(globalPosition));
          isScrollingAnimationAllowed = true;
        } else if (scrollingAnimation == ScrollingAnimation.charHasTo &&
            isScrollingAnimationAllowed) {
          isScrollingAnimationAllowed = false;
          _chartScrollController.jumpTo(Chart.toMyPositon(globalPosition));
          isScrollingAnimationAllowed = true;
        }
      } else if (scrollingAnimation == ScrollingAnimation.bothHasTo &&
          isScrollingAnimationAllowed) {
        isScrollingAnimationAllowed = false;
        globalPosition = selectedIndex.toDouble();
        _chartScrollController.jumpTo(Chart.toMyPositon(globalPosition));
        // _mainScrollController
        //     .jumpTo(CollapsingList.toMyPositon(globalPosition));

        // _chartScrollController.animateTo(Chart.toMyPositon(globalPosition),
        //     duration: Duration(milliseconds: 2000), curve: ElasticOutCurve());
        _mainScrollController.animateTo(
            CollapsingList.toMyPositon(globalPosition),
            duration: Duration(milliseconds: 1000),
            curve: ElasticOutCurve());
        Future.delayed(Duration(milliseconds: 1010)).then((_) {
          scrollingAnimation = ScrollingAnimation.charHasTo;
          return isScrollingAnimationAllowed = true;
        });
      }
    });
  }

  void chartCallback(double newGlobalPosition, {bool isVertical = false}) {
    globalPosition = newGlobalPosition;
    if ((previousGlobalPosition - newGlobalPosition).abs() > 5 / 60 &&
        scrollingAnimation != ScrollingAnimation.bothHasTo) {
      if (selectedIndex != CollapsingList.index(newGlobalPosition)) {
        setState(() {
          selectedIndex = CollapsingList.index(newGlobalPosition);
        });
      }

      if (isVertical) {
        //Main List moving
        scrollingAnimation = ScrollingAnimation.charHasTo;
      } else {
        // Chart moving
        scrollingAnimation = ScrollingAnimation.mainViewHasTo;
      }
    }
  }

  SliverPersistentHeader makeHeader() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverAppBarDelegate(
          maxHeight: CollapsingList.maxSliverAppBarHeight,
          minHeight: CollapsingList.minSliverAppBarHeight,
          data: data,
          children: [
            Chart(
              elements: [
                for (int i = 0; i < data.transactions.length; i++)
                  data.transactions[i].amount
              ],
              controller: _chartScrollController,
              selectedIndex: selectedIndex,
              onChanged: chartCallback,
            ),
            DateSelection(
              list: data.transactions,
              selectedIndex: selectedIndex,
              onChanged: (index) {
                setState(() {
                  scrollingAnimation = ScrollingAnimation.bothHasTo;
                  selectedIndex = index;
                });
              },
            ),
          ]),
    );
  }

  bool _onNotification(Notification notification) {
    if (notification is ScrollNotification) {
      if (notification.metrics.axis == Axis.vertical) {
        chartCallback(
            CollapsingList.toGlobalPositon(notification.metrics.pixels),
            isVertical: true);
        if (_userStoppedScrolling(notification, _mainScrollController)) {
          if (notification.metrics.pixels < 40) {
            _mainScrollController.animateTo(0,
                duration: Duration(milliseconds: 1000),
                curve: ElasticOutCurve());
          } else if (notification.metrics.pixels < 100) {
            _mainScrollController.animateTo(130,
                duration: Duration(milliseconds: 1000),
                curve: ElasticOutCurve());
          }
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
        controller: _mainScrollController,
        slivers: <Widget>[
          makeHeader(),
          SliverFixedExtentList(
            itemExtent: CollapsingList.transactionItemHeight,
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
