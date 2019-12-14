import 'package:calendarro/calendarro.dart';
import 'package:calendarro/default_weekday_labels_row.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

import 'ChronoHelfer.dart';

Future<List<DateTime>> showMultipleDatePicker(
    List<DateTime> previousSelectedDates, BuildContext context,
    {key: Key***REMOVED***) async {
  DateTime currentMonth = DateTime.now();
  List<DateTime> selectedDatesFromFilter = []..addAll(previousSelectedDates);
  if (selectedDatesFromFilter == null) selectedDatesFromFilter = [];
  var selectedDatesFromDialog = await showDialog<List<DateTime>>(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setDialogState) {
            return SimpleDialog(
                key: key,
                titlePadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
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
                      onPressed: () => setDialogState(() =>
                          currentMonth = Jiffy(currentMonth).add(months: 1)),
                    ),
                  ],
                ),
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
                      )),
                  ButtonBar(alignment: MainAxisAlignment.center, children: [
                    RaisedButton(
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
          ***REMOVED***));
  return selectedDatesFromDialog;
***REMOVED***

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
  ***REMOVED***
***REMOVED***
