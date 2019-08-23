import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Chart extends StatelessWidget {
  static const double itemWidth = 60;
  final ScrollController controller;
  final int selectedIndex;
  final ValueChanged<double> onChanged;
  final List<double> elements;
  final double width;
  const Chart({
    Key key,
    this.controller,
    this.onChanged,
    this.selectedIndex,
    this.elements,
    this.width = 360,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      child: Container(
        color: Colors.white,
        height: 100,
        width: width,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: elements.length,
          itemExtent: Chart.itemWidth,
          controller: controller,
          itemBuilder: (context, index) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  width: 40,
                  height: 100 / elements.reduce(max) * elements[index],
                  color: index == selectedIndex
                      ? Colors.blue[900]
                      : Colors.blueAccent,
                ),
              ],
            );
          },
        ),
      ),
      onNotification: _onNotification,
    );
  }

  bool _onNotification(Notification notification) {
    if (notification is ScrollNotification) {
      if (_userStoppedScrolling(notification, controller) &&
          notification.metrics.axis == Axis.horizontal) {
        onChanged(min(notification.metrics.pixels, 960));
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
}
