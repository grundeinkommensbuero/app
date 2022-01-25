import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sammel_app/shared/CampaignTheme.dart';

enum PlacardDialogAction { DELETE, TAKE_DOWN, CANCEL }

Future<PlacardDialogAction> showPlacardDialog(
        BuildContext context, bool mine) async =>
    await showDialog(
        context: context,
        builder: (_) => AlertDialog(
              key: Key('placard dialog'),
              title: Text('Plakat löschen').tr(),
              content: mine
                  ? Text('Dieses Plakat hast du eingetragen. Du kannst es wieder löschen oder als abgehangen markieren.')
                      .tr()
                  : Text('Dieses Plakat wurde von jemand anderem eingetragen. Du kannst es als abgehangen markieren.')
                      .tr(),
              actions: <Widget>[
                ElevatedButton(
                  key: Key('delete placard dialog abort button'),
                  child: Text('Abbrechen').tr(),
                  onPressed: () =>
                      Navigator.pop(context, PlacardDialogAction.CANCEL),
                ),
                mine
                    ? ElevatedButton(
                        style: ButtonStyle(backgroundColor: CampaignTheme.red),
                        key: Key('delete placard button'),
                        child: Text('Löschen').tr(),
                        onPressed: () =>
                            Navigator.pop(context, PlacardDialogAction.DELETE),
                      )
                    : SizedBox(),
                ElevatedButton(
                  style: ButtonStyle(backgroundColor: CampaignTheme.red),
                  key: Key('take down placard button'),
                  child: Text('Abhängen').tr(),
                  onPressed: () =>
                      Navigator.pop(context, PlacardDialogAction.TAKE_DOWN),
                )
              ],
            ));
