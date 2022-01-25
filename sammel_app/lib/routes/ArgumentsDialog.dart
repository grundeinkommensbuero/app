import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/model/Arguments.dart';
import 'package:sammel_app/services/GeoService.dart';
import 'package:sammel_app/shared/CampaignTheme.dart';
import 'package:sammel_app/shared/ChronoHelfer.dart';

Future<Arguments?> showArgumentsDialog(
        {required BuildContext context, required LatLng coordinates}) =>
    showDialog(
      context: context,
      builder: (context) => ArgumentsDialog(coordinates),
    );

class ArgumentsDialog extends StatefulWidget {
  final LatLng coordinates;

  ArgumentsDialog(this.coordinates) : super(key: Key('arguments dialog'));

  @override
  State<StatefulWidget> createState() {
    return ArgumentsDialogState(coordinates);
  }
}

class ArgumentsDialogState extends State<ArgumentsDialog> {
  final LatLng coordinates;
  String? plz;
  final DateTime date = DateTime.now();
  String arguments = '';

  ArgumentsDialogState(this.coordinates);

  @override
  Widget build(BuildContext context) {
    if (plz == null)
      Provider.of<GeoService>(context)
          .getDescriptionToPoint(coordinates)
          .then((geoData) => setState(() => this.plz = geoData.postcode));

    return AlertDialog(
      title: Text('Vorbehalte').tr(),
      content: SingleChildScrollView(
          child: ListBody(children: [
        Text(
          '${plz != null ? plz : 'Berlin'}, ${ChronoHelfer.formatDateOfDateTime(date)}',
          textScaleFactor: 0.9,
          style: TextStyle(color: CampaignTheme.secondary),
        ),
        SizedBox(height: 5.0),
        Text('Hilf der Kampagne, indem du im Wortlaut aufschreibst, was die Bedenken der Unentschlossenen waren. Und: Mit was hast du sie überzeugen können? Wenn ein Argument in mehreren Gesprächen wichtig war, schreibe die Häufigkeit in Klammern dahinter.',
                style: TextStyle(fontSize: 12))
            .tr(),
        SizedBox(height: 10.0),
        TextFormField(
          maxLines: 3,
          key: Key('arguments input'),
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
          onChanged: (input) => arguments = input,
        ),
        SizedBox(height: 10.0),
        Text(
            'Aus Datenschutzgründen werden diese Daten nicht mit einer Adresse verknüpft.',
            style: TextStyle(fontSize: 12)).tr()
      ])),
      actions: [
        TextButton(
            key: Key('arguments dialog cancel button'),
            child: Text("Nein danke").tr(),
            onPressed: () => Navigator.pop(context)),
        TextButton(
          key: Key('arguments dialog submit button'),
          child: Text("Absenden").tr(),
          onPressed: () async =>
              Navigator.pop(context, Arguments(arguments, date, plz)),
        ),
      ],
    );
  }
}
