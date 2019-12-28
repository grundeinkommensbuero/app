import 'package:calendarro/calendarro.dart';
import 'package:calendarro/date_utils.dart';
import 'package:calendarro/default_day_tile.dart';
import 'package:calendarro/default_weekday_labels_row.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:sammel_app/shared/DweTheme.dart';

import 'ChronoHelfer.dart';

Future<List<DateTime>> showMultipleDatePicker(
    List<DateTime> previousSelectedDates, BuildContext context,
    {key: Key}) async {
  DateTime currentMonth = DateTime.now();
  List<DateTime> selectedDatesFromFilter = []..addAll(previousSelectedDates);
  if (selectedDatesFromFilter == null) selectedDatesFromFilter = [];
  var selectedDatesFromDialog = await showDialog<List<DateTime>>(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setDialogState) {
            return SimpleDialog(
                key: key,
                titlePadding: EdgeInsets.zero,
                title: AppBar(
                    titleSpacing: 0.0,
                    leading: null,
                    automaticallyImplyLeading: false,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RaisedButton(
                          key: Key('previous month button'),
                          shape: CircleBorder(),
                          child: Icon(Icons.arrow_left),
                          onPressed: () => setDialogState(() => currentMonth =
                              Jiffy(currentMonth).subtract(months: 1)),
                        ),
                        Text(
                          ChronoHelfer.monthName(currentMonth.month) +
                              '\n' +
                              currentMonth.year.toString(),
                          key: Key('current month'),
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                          textWidthBasis: TextWidthBasis.parent,
                        ),
                        RaisedButton(
                          key: Key('next month button'),
                          shape: CircleBorder(),
                          child: Icon(Icons.arrow_right),
                          onPressed: () => setDialogState(() => currentMonth =
                              Jiffy(currentMonth).add(months: 1)),
                        ),
                      ],
                    )),
                children: <Widget>[
                  Container(
                      height: 260.0,
                      width: 1.0,
                      child: Calendarro(
                        startDate: Jiffy(currentMonth).startOf("month"),
                        endDate: Jiffy(currentMonth).endOf("month"),
                        selectedDates: selectedDatesFromFilter,
                        weekdayLabelsRow: GerCalendarroWeekdayLabelsView(),
                        selectionMode: SelectionMode.MULTI,
                        displayMode: DisplayMode.MONTHS,
                        dayTileBuilder: DweDayTileBuilder(),
                      )),
                  ButtonBar(alignment: MainAxisAlignment.center, children: [
                    RaisedButton(
                      key: Key('days dialog none button'),
                      child: Text("Keine"),
                      onPressed: () => Navigator.pop(context, <DateTime>[]),
                    ),
                    RaisedButton(
                      key: Key('days dialog accept button'),
                      child: Text("Auswählen"),
                      onPressed: () =>
                          Navigator.pop(context, selectedDatesFromFilter),
                    )
                  ])
                ]);
          }));
  return selectedDatesFromDialog;
}

class DweDayTileBuilder extends DayTileBuilder {
  @override
  Widget build(BuildContext context, DateTime date, DateTimeCallback onTap) {
    return DweCalendarroDayItem(
        date: date, calendarroState: Calendarro.of(context), onTap: onTap);
  }
}

// Warning inherited from CalendarroItem
// ignore: must_be_immutable
class DweCalendarroDayItem extends CalendarroDayItem {
  DweCalendarroDayItem({DateTime date, CalendarroState calendarroState, onTap})
      : super(date: date, calendarroState: calendarroState, onTap: onTap);

  @override
  Widget build(BuildContext context) {
    bool isWeekend = DateUtils.isWeekend(date);
    bool dayBeforeSelected =
        calendarroState.isDateSelected(date.subtract(Duration(days: 1)));
    bool daySelected = calendarroState.isDateSelected(date);
    bool dayAfterSelected =
        calendarroState.isDateSelected(date.add(Duration(days: 1)));
    var textColor = isWeekend ? DweTheme.purple : Colors.black;
    if (daySelected) textColor = DweTheme.yellow;
    var fontWeight = isWeekend ? FontWeight.bold : FontWeight.normal;
    bool isToday = DateUtils.isToday(date);
    calendarroState = Calendarro.of(context);

    BoxDecoration boxDecoration;
    if (daySelected) {
      var leftborder = dayBeforeSelected ? Radius.zero : Radius.circular(20.0);
      var rightborder = dayAfterSelected ? Radius.zero : Radius.circular(20.0);
      boxDecoration = BoxDecoration(
          color: DweTheme.purple,
          shape: BoxShape.rectangle,
          borderRadius:
              BorderRadius.horizontal(left: leftborder, right: rightborder));
    } else if (isToday) {
      boxDecoration = BoxDecoration(
          border: Border.all(
            color: DweTheme.purple,
            width: 1.0,
          ),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(10.0)));
    }

    return Expanded(
        child: GestureDetector(
      child: Container(
          height: 40.0,
          decoration: boxDecoration,
          child: Center(
              child: Text(
            "${date.day}",
            textAlign: TextAlign.center,
            style: TextStyle(color: textColor, fontWeight: fontWeight),
          ))),
      onTap: handleTap,
      behavior: HitTestBehavior.translucent,
    ));
  }
}

class GerCalendarroWeekdayLabelsView extends CalendarroWeekdayLabelsView {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: Text("Mo", textAlign: TextAlign.center)),
        Expanded(child: Text("Di", textAlign: TextAlign.center)),
        Expanded(child: Text("Mi", textAlign: TextAlign.center)),
        Expanded(child: Text("Do", textAlign: TextAlign.center)),
        Expanded(child: Text("Fr", textAlign: TextAlign.center)),
        Expanded(child: Text("Sa", textAlign: TextAlign.center)),
        Expanded(child: Text("So", textAlign: TextAlign.center)),
      ],
    );
  }
}
