import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/rendering.dart';
import 'package:sammel_app/shared/CampaignTheme.dart';

enum MapActionType { NewAction, NewPlacard, NewVisitedHouse ***REMOVED***

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
                      key: Key('map action dialog action button'),
                      child: Container(
                          alignment: Alignment.center,
                          child: Row(children: [
                            Image.asset('assets/images/Flyern.png', width: 25),
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
                      key: Key('map action dialog placard button'),
                      child: Container(
                          child: Row(children: [
                            Image.asset('assets/images/PlakateAufhaengen.png',
                                width: 25),
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
                      key: Key('map action dialog visited house button'),
                      child: Container(
                          child: Row(children: [
                            Image.asset('assets/images/HausBesucht.png',
                                width: 25),
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
                    key: Key('map action dialog abort button'),
                    child: Text('Abbrechen').tr(),
                    onPressed: () => Navigator.pop(context, false),
                  )
                ]));
