import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/model/Arguments.dart';
import 'package:sammel_app/model/Kiez.dart';
import 'package:sammel_app/services/StammdatenService.dart';
import 'package:sammel_app/shared/ChronoHelfer.dart';

Future<Arguments?> showArgumentsDialog(
        {required BuildContext context, required LatLng coordinates***REMOVED***) =>
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
  ***REMOVED***
***REMOVED***

class ArgumentsDialogState extends State<ArgumentsDialog> {
  final LatLng coordinates;
  Kiez? kiez = null;
  final DateTime date = DateTime.now();
  String arguments = '';

  ArgumentsDialogState(this.coordinates) {***REMOVED***

  @override
  Widget build(BuildContext context) {
    if (kiez == null)
      Provider.of<StammdatenService>(context)
          .getKiezAtLocation(coordinates)
          .then((kiez) => setState(() => this.kiez = kiez));

    return AlertDialog(
      title: Text('Vorbehalte').tr(),
      content: SingleChildScrollView(
          child: ListBody(children: [
        Text(
          'In ${kiez != null ? kiez!.name : 'Berlin'***REMOVED*** am ${ChronoHelfer.formatDateOfDateTime(date)***REMOVED***',
          textScaleFactor: 0.9,
        ).tr(),
        SizedBox(
          height: 5.0,
        ),
        Text('Hilf der Kampagne, indem du in ein paar Schlagworten aufschreibst, was Vorbehalte und Gegenargumente deiner Gesprächspartner*innen waren.\n'
                'Wenn ein Thema in mehreren Gesprächen wichtig war schreibe die Anzahl in Klammern dahinter.\n'
                '\n'
                'Aus Datenschutzgründen werden diese Daten nicht mit einer Adresse, sondern nur mit dem Kiez (${kiez?.name***REMOVED***) verknüpft, in dem du unterwegs bist.\n')
            .tr(),
        SizedBox(
          height: 10.0,
        ),
        TextFormField(
          key: Key('arguments input'),
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
          onChanged: (input) => arguments = input,
        ),
      ])),
      actions: [
        TextButton(
            key: Key('arguments cancel button'),
            child: Text("Nein danke").tr(),
            onPressed: () => Navigator.pop(context)),
        TextButton(
          key: Key('arguments dialog finish button'),
          child: Text("Absenden").tr(),
          onPressed: () async =>
              Navigator.pop(context, Arguments(arguments, date, kiez)),
        ),
      ],
    );
  ***REMOVED***
***REMOVED***
