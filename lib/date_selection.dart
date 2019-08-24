import 'package:flutter/material.dart';
import 'package:scrolling_ui/model/transaction.dart';

class DateSelection extends StatelessWidget {
  final List<Transaction> list;
  final ValueChanged<int> onChanged;
  final int selectedIndex;
  static const monthName = [
    "January",
    "February",
    "Marc",
    "April",
    "May",
    "Jun",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];
  const DateSelection(
      {Key key, this.list, this.onChanged, this.selectedIndex = 1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dates = [list[0].date];
    final datesIndex = [0];
    for (var element in list) {
      if (element.date.month > dates.last.month) {
        dates.add(element.date);
        datesIndex.add(list.indexOf(element));
      }
    }

    return Container(
      color: Colors.white,
      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          for (int i = 0; i < datesIndex.length; i++)
            InkWell(
              onTap: () => onChanged(datesIndex[i]),
              child: Container(
                padding: EdgeInsets.all(7),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: list[selectedIndex].date.month == dates[i].month
                          ? Colors.blueAccent
                          : Colors.transparent,
                      width: 4,
                    ),
                  ),
                ),
                child: Text(
                  "${dates[i].year} ${DateSelection.monthName[dates[i].month - 1]}",
                  style: TextStyle(fontSize: 22),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
