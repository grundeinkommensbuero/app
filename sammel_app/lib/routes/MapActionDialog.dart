import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/rendering.dart';
import 'package:sammel_app/shared/CampaignTheme.dart';

enum MapActionType { NewAction, NewPlacard, NewVisitedHouse, Cancel ***REMOVED***

Future<MapActionType> showMapActionDialog(BuildContext context) async =>
    await showDialog(
        context: context,
        builder: (_) => AlertDialog(
                key: Key('delete placard dialog'),
                title: Text('Eintragen').tr(),
                content: Column(mainAxisSize: MainAxisSize.min, children: [
                  Text('Was möchtest du an dieser Stelle eintragen?').tr(),
                  SizedBox(height: 10),
                  TextButton(
                      child: Container(
                          alignment: Alignment.center,
                          child: Row(children: [
                            Image.asset('assets/images/Sammeln.png', width: 20),
                            SizedBox(width: 5),
                            Expanded(
                                child: Text('Zu einer Aktion aufrufen').tr())
                          ]),
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: CampaignTheme.secondary),
                              borderRadius: BorderRadius.circular(10.0),
                              color: CampaignTheme.primary,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(1.0, 1.0),
                                    blurRadius: 3.0,
                                    spreadRadius: 1.0)
                              ])),
                      onPressed: () =>
                          Navigator.pop(context, MapActionType.NewAction)),
                  SizedBox(height: 5),
                  TextButton(
                      child: Container(
                          child: Row(children: [
                            Icon(Icons.assistant_sharp),
                            SizedBox(width: 5),
                            Expanded(child: Text('Ein Plakat eintragen').tr())
                          ]),
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: CampaignTheme.secondary),
                              borderRadius: BorderRadius.circular(10.0),
                              color: CampaignTheme.primary,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(1.0, 1.0),
                                    blurRadius: 3.0,
                                    spreadRadius: 1.0)
                              ])),
                      onPressed: () =>
                          Navigator.pop(context, MapActionType.NewPlacard)),
                  SizedBox(height: 5),
                  TextButton(
                      child: Container(
                          child: Row(children: [
                            Icon(Icons.house),
                            SizedBox(width: 5),
                            Expanded(
                                child:
                                    Text('Ein besuchtes Haus markieren').tr())
                          ]),
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: CampaignTheme.secondary),
                              borderRadius: BorderRadius.circular(10.0),
                              color: CampaignTheme.primary,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(1.0, 1.0),
                                    blurRadius: 3.0,
                                    spreadRadius: 1.0)
                              ])),
                      onPressed: () => Navigator.pop(
                          context, MapActionType.NewVisitedHouse)),
                ]),
                actions: <Widget>[
                  TextButton(
                    key: Key('delete placard dialog abort button'),
                    child: Text('Abbrechen').tr(),
                    onPressed: () => Navigator.pop(context, MapActionType.Cancel),
                  )
                ]));
