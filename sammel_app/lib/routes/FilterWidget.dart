import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/model/Kiez.dart';
import 'package:sammel_app/model/TermineFilter.dart';
import 'package:sammel_app/services/StammdatenService.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/shared/ChronoHelfer.dart';
import 'package:sammel_app/shared/CampaignTheme.dart';
import 'package:sammel_app/shared/KiezPicker.dart';
import 'package:sammel_app/shared/action_types.dart';
import 'package:sammel_app/shared/showMultipleDatePicker.dart';
import 'package:sammel_app/shared/showTimeRangePicker.dart';

class FilterWidget extends StatefulWidget {
  final Future Function(TermineFilter) onApply;

  FilterWidget(this.onApply, {Key? key}) : super(key: key);

  @override
  FilterWidgetState createState() => FilterWidgetState();
}

class FilterWidgetState extends State<FilterWidget>
    with TickerProviderStateMixin {
  TermineFilter filter = TermineFilter.leererFilter();

  var _initialized = false;

  var _zeroPadding = MaterialTapTargetSize.shrinkWrap;

  var buttonText = '';
  var expanded = false;
  var loading = true;

  StorageService? storageService;
  Set<Kiez> allLocations = {};

  @override
  Widget build(BuildContext context) {
    if (!_initialized) initialize(context);

    return Stack(alignment: Alignment.topCenter, children: [
      Column(
        children: [
          !expanded
              ? Container(color: Color.fromARGB(255, 149, 48, 118))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    FilterElement(
                      key: Key('type button'),
                      child: Text(artButtonBeschriftung()),
                      selectionFunction: typeSelection,
                      resetFunction: resetType,
                    ),
                    FilterElement(
                      key: Key('days button'),
                      child: tageButtonBeschriftung(),
                      selectionFunction: daysSelection,
                      resetFunction: resetDays,
                    ),
                    FilterElement(
                        key: Key('time button'),
                        child: Text(uhrzeitButtonBeschriftung(filter)),
                        selectionFunction: timeSelection,
                        resetFunction: resetTime),
                    FilterElement(
                      key: Key('locations button'),
                      child: Text(ortButtonBeschriftung(filter)),
                      selectionFunction: locationSelection,
                      resetFunction: resetLocations,
                    ),
                  ],
                ),
          SizedBox(
              width: double.infinity,
              height: 50.0,
              child: ElevatedButton(
                key: Key('filter button'),
                style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(CampaignTheme.secondary),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.zero,
                                bottom: Radius.elliptical(15.0, 20.0)))),
                    tapTargetSize: _zeroPadding,
                    foregroundColor:
                        MaterialStateProperty.all(CampaignTheme.primary)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: 50),
                    loading
                        ? Container(
                            width: 30,
                            height: 30,
                            child: LoadingIndicator(
                                indicatorType: Indicator.ballRotateChase,
                                color: CampaignTheme.primary))
                        : Text(buttonText,
                            key: Key('filter button text'),
                            textScaleFactor: 1.2),
                    Icon(expanded ? Icons.done : Icons.filter_alt_sharp,
                        color:
                            filter.isEmpty ? CampaignTheme.primary : CampaignTheme.altPrimary),
                  ],
                ),
                onPressed: () {
                  if (expanded) {
                    setState(() => buttonText = '');
                    expanded = false;
                    onApply();
                    storageService?.saveFilter(filter);
                  } else {
                    setState(() => buttonText = 'Anwenden'.tr());
                    expanded = true;
                  }
                },
              )),
        ],
      ),
      !expanded
          ? TextButton(
              style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(CampaignTheme.secondary),
                  foregroundColor: MaterialStateProperty.all(CampaignTheme.primary)),
              onPressed: onApply,
              child: Text(loading ? '' : 'Aktualisieren', textScaleFactor: 1.2)
                  .tr())
          : SizedBox()
    ]);
  }

  // Kann nicht im Konstruktor ausgeführt werden, weil der Provider den context braucht, der ins build reingereicht wird
  void initialize(BuildContext context) {
    storageService = Provider.of<StorageService>(context);
    storageService!.loadFilter().then((filter) {
      setState(() {
        this.filter = filter != null ? filter : TermineFilter.leererFilter();
      });
      onApply();
    });
    Provider.of<StammdatenService>(context)
        .kieze
        .then((locations) => setState(() => allLocations = locations));
    _initialized = true;
  }

  Text tageButtonBeschriftung() {
    if (filter.tage.isEmpty) {
      return Text('alle Tage,').tr();
    } else {
      return Text('am {tage},').tr(namedArgs: {
        'tage': filter.tage
            .map((tag) => DateFormat("dd.MM.").format(tag))
            .join(", ")
      });
    }
  }

  String artButtonBeschriftung() {
    return filter.typen.isNotEmpty
        ? (filter.typen.join(', ') +
            ((filter.nurEigene == true) ? ', (${'eigene'.tr()})' : ','))
        : (filter.nurEigene == true)
            ? 'Eigene Aktionen'.tr() + ','
            : 'Alle Aktions-Arten,'.tr();
  }

  static String uhrzeitButtonBeschriftung(TermineFilter filter) {
    String beschriftung = '';
    if (filter.von != null)
      beschriftung += 'von '.tr() + ChronoHelfer.timeToStringHHmm(filter.von)!;
    if (filter.bis != null)
      beschriftung += ' bis ' + ChronoHelfer.timeToStringHHmm(filter.bis)!;
    if (beschriftung.isEmpty) beschriftung = 'jederzeit'.tr();
    beschriftung += ',';
    return beschriftung;
  }

  String ortButtonBeschriftung(TermineFilter filter) {
    const maxLength = 500;
    return (filter.orte.isEmpty)
        ? 'überall'.tr()
        : filter.orte.map((ort) => ort).toList().join(", ").length < maxLength
            ? 'in ${filter.orte.map((ort) => ort).toList().join(", ")}'
            : 'in ${filter.orte.length} Kiezen';
  }

  Future<void> onApply() async {
    setState(() => loading = true);
    await widget.onApply(filter);
    setState(() => loading = false);
  }

  typeSelection() async {
    List<String> ausgewTypen = []..addAll(filter.typen);
    bool nurEigene = filter.nurEigene == true;
    bool immerEigene = filter.immerEigene == true;

    await showDialog<List<String>>(
        context: context,
        builder: (context) =>
            StatefulBuilder(builder: (context, setDialogState) {
              return AlertDialog(
                  key: Key('type selection dialog'),
                  contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0.0),
                  titlePadding: EdgeInsets.zero,
                  title: AppBar(
                      leading: null,
                      automaticallyImplyLeading: false,
                      title: const Text('Wähle Aktions-Art').tr()),
                  content: Container(padding: EdgeInsets.all(0), width: double.maxFinite, child: Column(mainAxisSize: MainAxisSize.min,
                      children: [SwitchListTile(
                      activeColor: CampaignTheme.secondary,
                      inactiveThumbColor: CampaignTheme.primary,
                      value: nurEigene,
                      title: Text('Nur eigene Aktionen anzeigen').tr(),
                      onChanged: (neuerWert) {
                        setDialogState(() {
                          nurEigene = neuerWert;
                        });
                      }),
                      SwitchListTile(
                          activeColor: CampaignTheme.secondary,
                          inactiveThumbColor: CampaignTheme.primary,
                          value: immerEigene,
                          title: Text('Eigene Aktionen immer anzeigen').tr(),
                          onChanged: (neuerWert) {
                            setDialogState(() {
                              immerEigene = neuerWert;
                            });
                          }),
                      Divider(
                          indent: 16, endIndent: 16, thickness: 1, height: 8),
                  Flexible(child: ListView.builder( itemCount: moeglicheTypen.length, shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) =>
                        CheckboxListTile(
                              checkColor: Colors.black,
                              activeColor: CampaignTheme.primaryLight,
                              value: ausgewTypen.contains(moeglicheTypen[index]),
                              title: Text(moeglicheTypen[index]).tr(),
                              onChanged: (bool? neuerWert) {
                                setDialogState(() {
                                  if (neuerWert == true) {
                                    ausgewTypen.add(moeglicheTypen[index]);
                                  } else {
                                    ausgewTypen.remove(moeglicheTypen[index]);
                                  }
                                });
                              },
                            ))),
                        Divider(
                            indent: 16, endIndent: 16, thickness: 1, height: 8),
                      SizedBox(width: double.maxFinite, child: ElevatedButton(
                          child: Text('Fertig').tr(),
                          onPressed: () => Navigator.pop(context))
                      )])));
            }));

    setState(() {
      filter.typen = ausgewTypen;
      filter.nurEigene = nurEigene;
      filter.immerEigene = immerEigene;
    });
  }

  resetType() => setState(() {
        filter.typen = [];
        filter.nurEigene = false;
      });

  daysSelection() async {
    var selectedDates = await showMultipleDatePicker(filter.tage, context,
        key: Key('days selection dialog'));
    setState(() {
      if (selectedDates != null)
        filter.tage = selectedDates..sort((dt1, dt2) => dt1.compareTo(dt2));
    });
  }

  resetDays() => setState(() => filter.tage = []);

  timeSelection() async {
    TimeRange timeRange =
        await showTimeRangePicker(context, filter.von, filter.bis);
    setState(() {
      filter.von = timeRange.from;
      filter.bis = timeRange.to;
    });
  }

  resetTime() => setState(() {
        filter.von = null;
        filter.bis = null;
      });

  locationSelection() async {
    var selectedLocations = await KiezPicker(allLocations
            .where((kiez) => filter.orte.contains(kiez.name))
            .toSet())
        .showKiezPicker(context);

    if (selectedLocations == null) return;
    setState(() => filter.orte = selectedLocations.map((k) => k.name).toList());
  }

  resetLocations() => setState(() => filter.orte = []);
}

class FilterElement extends StatelessWidget {
  final _zeroPadding = MaterialTapTargetSize.shrinkWrap;
  final Widget child;
  final Function()? selectionFunction;
  final Function()? resetFunction;

  static emptyFunction() => null;

  FilterElement(
      {key, required this.child, this.selectionFunction, this.resetFunction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(CampaignTheme.secondaryLight),
              foregroundColor: MaterialStateProperty.all(CampaignTheme.primary),
              tapTargetSize: _zeroPadding,
              padding: MaterialStateProperty.all(EdgeInsetsDirectional.zero),
            ),
            onPressed: selectionFunction,
            child: Container(
              color: CampaignTheme.secondaryLight,
              child: IntrinsicHeight(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                    Expanded(
                        child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(child: child),
                                  Icon(
                                    Icons.create,
                                    size: 18.0,
                                  )
                                ]))),
                    VerticalDivider(thickness: 2, width: 2),
                    TextButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(CampaignTheme.secondaryLight),
                          foregroundColor:
                              MaterialStateProperty.all(CampaignTheme.primary),
                          tapTargetSize: _zeroPadding,
                          padding: MaterialStateProperty.all(
                              EdgeInsetsDirectional.zero)),
                      onPressed: resetFunction,
                      child: Icon(
                        Icons.clear,
                        size: 18.0,
                      ),
                    )
                  ])),
            )));
  }
}
