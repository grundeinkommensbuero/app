import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sammel_app/shared/CampaignTheme.dart';

Future<bool> showPlacardDeleteDialog(BuildContext context) async =>
    await showDialog(
        context: context,
        builder: (_) => AlertDialog(
              key: Key('delete placard dialog'),
              title: Text('Plakat löschen').tr(),
              content: Text(
                  'Dieses Plakat hast du eingetragen. Möchtest du es wieder löschen?'),
              actions: <Widget>[
                ElevatedButton(
                  key: Key('delete placard dialog abort button'),
                  child: Text('Abbrechen').tr(),
                  onPressed: () => Navigator.pop(context, false),
                ),
                ElevatedButton(
                  style: ButtonStyle(backgroundColor: CampaignTheme.red),
                  key: Key('delete placard dialog confirm button'),
                  child: Text('Löschen').tr(),
                  onPressed: () => Navigator.pop(context, true),
                )
              ],
            ));
