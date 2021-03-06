import 'package:calendarro/calendarro.dart';
import 'package:calendarro/date_utils.dart' as cal;
import 'package:calendarro/default_day_tile.dart';
import 'package:calendarro/default_weekday_labels_row.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:sammel_app/shared/CampaignTheme.dart';

Future<List<DateTime>?> showMultipleDatePicker(
    List<DateTime> initDates, BuildContext context,
    {key: Key, multiMode = true, maxTage = 0}) async {
  DateTime displayedMonth =
      initDates.isNotEmpty ? initDates.first : DateTime.now();
  List<DateTime> dates = []..addAll(initDates);

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
                        Flexible(
                            child: ElevatedButton(
                          key: Key('previous month button'),
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all(CircleBorder())),
                          child: Icon(Icons.arrow_left),
                          onPressed: () => setDialogState(() => displayedMonth =
                              (Jiffy(displayedMonth)..subtract(months: 1))
                                  .dateTime),
                        )),
                        Flexible(
                          child: Column(children: [
                            Text(
                                DateFormat.MMMM(Localizations.localeOf(context)
                                        .languageCode)
                                    .format(displayedMonth),
                                key: Key('current month'),
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(displayedMonth.year.toString(),
                                style: TextStyle(fontWeight: FontWeight.bold))
                          ]),
                        ),
                        Flexible(
                            child: ElevatedButton(
                          key: Key('next month button'),
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all(CircleBorder())),
                          child: Icon(Icons.arrow_right),
                          onPressed: () => setDialogState(() => displayedMonth =
                              (Jiffy(displayedMonth)..add(months: 1)).dateTime),
                        )),
                      ],
                    )),
                children: <Widget>[
                  Container(
                      height: 260.0,
                      width: 1.0,
                      child: Calendarro(
                        startDate: (Jiffy(displayedMonth)..startOf(Units.MONTH))
                            .dateTime,
                        endDate: (Jiffy(displayedMonth)..endOf(Units.MONTH))
                            .dateTime,
                        selectedDates: dates,
                        selectedSingleDate:
                            initDates.isNotEmpty ? initDates[0] : null,
                        weekdayLabelsRow: GerCalendarroWeekdayLabelsView(),
                        selectionMode: multiMode
                            ? SelectionMode.MULTI
                            : SelectionMode.SINGLE,
                        displayMode: DisplayMode.MONTHS,
                        dayTileBuilder: DweDayTileBuilder(),
                        onTap: (DateTime date) {
                          // bei Multi-Select manipuliert Calendarro die Liste selbst
                          if (!multiMode) dates = [date];
                        },
                      )),
                  ButtonBar(alignment: MainAxisAlignment.center, children: [
                    ElevatedButton(
                      key: Key('days dialog cancel button'),
                      child: Text("Abbrechen").tr(),
                      onPressed: () => Navigator.pop(context, initDates),
                    ),
                    ElevatedButton(
                      key: Key('days dialog accept button'),
                      child: Text("Ausw??hlen").tr(),
                      onPressed: () {
                        if (maxTage > 0 &&
                            multiMode &&
                            dates.length > maxTage) {
                          showTooManyDatesDialog(context, maxTage);
                          return;
                        }
                        Navigator.pop(context, dates);
                      },
                    )
                  ])
                ]);
          }));
  return selectedDatesFromDialog;
}

class DweDayTileBuilder extends DayTileBuilder {
  @override
  Widget build(BuildContext context, DateTime date, DateTimeCallback? onTap) {
    return DweCalendarroDayItem(
        date: date, calendarroState: Calendarro.of(context)!, onTap: onTap);
  }
}

// Warning inherited from CalendarroItem
// ignore: must_be_immutable
class DweCalendarroDayItem extends CalendarroDayItem {
  DweCalendarroDayItem(
      {required DateTime date, required CalendarroState calendarroState, onTap})
      : super(date: date, calendarroState: calendarroState, onTap: onTap);

  @override
  Widget build(BuildContext context) {
    bool isWeekend = cal.DateUtils.isWeekend(date);
    bool dayBeforeSelected =
        calendarroState.isDateSelected(date.subtract(Duration(days: 1)));
    bool daySelected = calendarroState.isDateSelected(date);
    bool dayAfterSelected =
        calendarroState.isDateSelected(date.add(Duration(days: 1)));
    var textColor = isWeekend ? CampaignTheme.secondary : Colors.black;
    if (daySelected) textColor = CampaignTheme.primary;
    var fontWeight = isWeekend ? FontWeight.bold : FontWeight.normal;
    bool isToday = cal.DateUtils.isToday(date);
    calendarroState = Calendarro.of(context)!;

    BoxDecoration? boxDecoration;
    if (daySelected) {
      var leftborder = dayBeforeSelected ? Radius.zero : Radius.circular(20.0);
      var rightborder = dayAfterSelected ? Radius.zero : Radius.circular(20.0);
      boxDecoration = BoxDecoration(
          color: CampaignTheme.secondary,
          shape: BoxShape.rectangle,
          borderRadius:
              BorderRadius.horizontal(left: leftborder, right: rightborder));
    } else if (isToday) {
      boxDecoration = BoxDecoration(
          border: Border.all(
            color: CampaignTheme.secondary,
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
        Expanded(child: Text('Mo', textAlign: TextAlign.center).tr()),
        Expanded(child: Text('Di', textAlign: TextAlign.center).tr()),
        Expanded(child: Text('Mi', textAlign: TextAlign.center).tr()),
        Expanded(child: Text('Do', textAlign: TextAlign.center).tr()),
        Expanded(child: Text('Fr', textAlign: TextAlign.center).tr()),
        Expanded(child: Text('Sa', textAlign: TextAlign.center).tr()),
        Expanded(child: Text('So', textAlign: TextAlign.center).tr()),
      ],
    );
  }
}

showTooManyDatesDialog(context, maxTage) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text('Zu viele Tage'.tr()),
            content: SelectableText(
                'Bitte w??hle {maxTage} Tage oder weniger aus.'
                    .tr(namedArgs: {'maxTage': maxTage.toString()})),
            actions: <Widget>[
              TextButton(
                child: Text('Na gut').tr(),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ));
}
