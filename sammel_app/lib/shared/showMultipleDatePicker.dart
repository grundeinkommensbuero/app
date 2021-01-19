import 'package:easy_localization/easy_localization.dart';
import 'package:calendarro/calendarro.dart';
import 'package:calendarro/date_utils.dart';
import 'package:calendarro/default_day_tile.dart';
import 'package:calendarro/default_weekday_labels_row.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:sammel_app/shared/DweTheme.dart';

import 'ChronoHelfer.dart';

Future<List<DateTime>> showMultipleDatePicker(
    List<DateTime> initDates, BuildContext context,
    {key: Key, multiMode = true, maxTage = 0***REMOVED***) async {
  DateTime currentMonth = DateTime.now();
  List<DateTime> dates = []..addAll(initDates ?? []);
  DateTime date = initDates.isNotEmpty ? initDates[0] : null;
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
                        Flexible(child: RaisedButton(
                          key: Key('previous month button'),
                          shape: CircleBorder(),
                          child: Icon(Icons.arrow_left),
                          onPressed: () => setDialogState(() => currentMonth =
                              Jiffy(currentMonth).subtract(months: 1)),
                        )),
                        Flexible(child: Text(
                          ChronoHelfer.monthName(currentMonth.month) +
                              '\n' +
                              currentMonth.year.toString(),
                          key: Key('current month'),
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                          textWidthBasis: TextWidthBasis.parent,
                        ).tr()),
                        Flexible(child: RaisedButton(
                          key: Key('next month button'),
                          shape: CircleBorder(),
                          child: Icon(Icons.arrow_right),
                          onPressed: () => setDialogState(() => currentMonth =
                              Jiffy(currentMonth).add(months: 1)),
                        )),
                      ],
                    )),
                children: <Widget>[
                  Container(
                      height: 260.0,
                      width: 1.0,
                      child: Calendarro(
                        startDate: Jiffy(currentMonth).startOf("month"),
                        endDate: Jiffy(currentMonth).endOf("month"),
                        selectedDates: dates,
                        selectedSingleDate: date,
                        weekdayLabelsRow: GerCalendarroWeekdayLabelsView(),
                        selectionMode: multiMode
                            ? SelectionMode.MULTI
                            : SelectionMode.SINGLE,
                        displayMode: DisplayMode.MONTHS,
                        dayTileBuilder: DweDayTileBuilder(),
                      )),
                  ButtonBar(alignment: MainAxisAlignment.center, children: [
                    RaisedButton(
                      key: Key('days dialog cancel button'),
                      child: Text("Abbrechen").tr(),
                      onPressed: () => Navigator.pop(context, initDates),
                    ),
                    RaisedButton(
                      key: Key('days dialog accept button'),
                      child: Text("Auswählen").tr(),
                      onPressed: () => (maxTage > 0 && multiMode && dates.length > maxTage)
                          ? showTooManyDatesDialog(context, maxTage)
                          : Navigator.pop(context, multiMode ? dates : [date]),
                    )
                  ])
                ]);
          ***REMOVED***));
  return selectedDatesFromDialog;
***REMOVED***

class DweDayTileBuilder extends DayTileBuilder {
  @override
  Widget build(BuildContext context, DateTime date, DateTimeCallback onTap) {
    return DweCalendarroDayItem(
        date: date, calendarroState: Calendarro.of(context), onTap: onTap);
  ***REMOVED***
***REMOVED***

// Warning inherited from CalendarroItem
// ignore: must_be_immutable
class DweCalendarroDayItem extends CalendarroDayItem {
  DweCalendarroDayItem({DateTime date, CalendarroState calendarroState, onTap***REMOVED***)
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
    ***REMOVED*** else if (isToday) {
      boxDecoration = BoxDecoration(
          border: Border.all(
            color: DweTheme.purple,
            width: 1.0,
          ),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(10.0)));
    ***REMOVED***

    return Expanded(
        child: GestureDetector(
      child: Container(
          height: 40.0,
          decoration: boxDecoration,
          child: Center(
              child: Text(
            "${date.day***REMOVED***",
            textAlign: TextAlign.center,
            style: TextStyle(color: textColor, fontWeight: fontWeight),
          ))),
      onTap: handleTap,
      behavior: HitTestBehavior.translucent,
    ));
  ***REMOVED***
***REMOVED***

class GerCalendarroWeekdayLabelsView extends CalendarroWeekdayLabelsView {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: Text('Mo', textAlign: TextAlign.center).tr()),
        Expanded(child: Text('Di', textAlign: TextAlign.center).tr()),
        Expanded(child: Text('Mi', textAlign: TextAlign.center).tr()),
        Expanded(child: Text('Do', textAlign: TextAlign.center).tr()),
        Expanded(child: Text('Fr', textAlign: TextAlign.center).tr()),
        Expanded(child: Text('Sa', textAlign: TextAlign.center).tr()),
        Expanded(child: Text('So', textAlign: TextAlign.center).tr()),
      ],
    );
  ***REMOVED***
***REMOVED***

showTooManyDatesDialog(context, maxTage) {
  showDialog(
      context: context,
      child: AlertDialog(
        title: Text('Zu viele Tage'.tr()),
        content: SelectableText(
            'Bitte wähle {maxTage***REMOVED*** Tage oder weniger aus.'.tr(namedArgs: {'maxTage': maxTage.toString()***REMOVED***)),
        actions: <Widget>[
          RaisedButton(
            child: Text('Schließen').tr(),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ));
***REMOVED***
