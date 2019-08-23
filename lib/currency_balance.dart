import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CurrencyBalance extends StatefulWidget {
  final double visibility;
  const CurrencyBalance({Key key, this.visibility = 1}) : super(key: key);

  @override
  _CurrencyBalanceState createState() {
    return _CurrencyBalanceState();
  }
}

class _CurrencyBalanceState extends State<CurrencyBalance> {
  int selectedValue = 1;

  @override
  Widget build(BuildContext context) {
    //print(visibility.toString());
    return CurrencyPicker(
      onChanged: (value) => setState(() => selectedValue = value),
      listViewWidth: 350,
      selectedValue: selectedValue,
      visibilityFactor: widget.visibility,
    );
  }
}

class CurrencyPicker extends StatelessWidget {
  final List<double> balances = [125, 59875, 687, 741, 22];
  final List<String> longCurrencyNames = [
    "Euro",
    "Hungarian Forint",
    "American Dollar",
    "Vmi mas",
    "Megin mas"
  ];
  final List<String> shortCurrencyNames = ["€", "Ft", "\$", "Vm", 'Mm'];
  final double maxFontSize;
  final double minFontSize;

  final double visibilityFactor;

  ///called when selected value changes
  final ValueChanged<num> onChanged;

  ///Width of list view
  final double listViewWidth;

  ///Currently selected index of the value
  final int selectedValue;

  final ScrollController _scrollController;

  CurrencyPicker(
      /* this.balances, this.longCurrencyNames, this.shortCurrencyNames, */
      {Key key,
      this.maxFontSize = 24,
      this.minFontSize = 18,
      this.visibilityFactor = 1,
      this.onChanged,
      this.listViewWidth,
      this.selectedValue})
      : _scrollController = ScrollController(
          initialScrollOffset: (selectedValue) * listViewWidth / 3,
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final fontSize =
        maxFontSize + (visibilityFactor - 1) * (maxFontSize - minFontSize);
    final defaultStyle = TextStyle(
        fontSize: fontSize, color: Colors.grey.withOpacity(visibilityFactor));
    final selectedStyle = TextStyle(fontSize: fontSize, color: Colors.black);

    int itemCount = balances.length + 2;
    return NotificationListener(
      child: Container(
        width: listViewWidth,
        height: 35 + visibilityFactor * 15,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          controller: _scrollController,
          itemExtent: listViewWidth / 3,
          itemCount: itemCount,
          itemBuilder: (BuildContext context, int index) {
            final value = index - 1;

            //define special style for selected (middle) element
            final itemStyle =
                value == selectedValue ? selectedStyle : defaultStyle;

            bool isExtra = index == 0 || index == itemCount - 1;

            return isExtra
                ? Container() //empty first and last element
                : Center(
                    child: Column(
                      children: <Widget>[
                        Text("${balances[value]} ${shortCurrencyNames[value]}",
                            style: itemStyle),
                        if (visibilityFactor > 0.3)
                          Text("${longCurrencyNames[value]}",
                              style:
                                  defaultStyle.merge(TextStyle(fontSize: 14))),
                      ],
                    ),
                  );
          },
        ),
      ),
      onNotification: _onNotification,
    );
  }

  bool _onNotification(Notification notification) {
    if (notification is ScrollNotification) {
      //calculate
      int intIndexOfMiddleElement =
          (notification.metrics.pixels + listViewWidth / 2) ~/
              (listViewWidth / 3);
      int intValueInTheMiddle = intIndexOfMiddleElement - 1;

      if (_userStoppedScrolling(notification, _scrollController)) {
        //center selected value
        _scrollController.animateTo(intValueInTheMiddle * (listViewWidth / 3),
            duration: Duration(milliseconds: 1000), curve: ElasticOutCurve());
      }

      //update selection
      if (intValueInTheMiddle != selectedValue) {
        num newValue;

        //return integer value
        newValue = (intValueInTheMiddle);

        onChanged(newValue);
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
