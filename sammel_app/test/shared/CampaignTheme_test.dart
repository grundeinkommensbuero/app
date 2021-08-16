import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sammel_app/shared/CampaignTheme.dart';

void main() {
  group('actionColor', () {
    test('colors past actions', () {
      DateTime gestern = DateTime.now().subtract(Duration(days: 1));
      expect(CampaignTheme.actionColor(gestern, false, false),
          equals(CampaignTheme.primaryBright));

      DateTime vor1Stunde = DateTime.now().subtract(Duration(hours: 1));
      expect(CampaignTheme.actionColor(vor1Stunde, false, false),
          equals(CampaignTheme.primaryBright));

      DateTime vor1Minute = DateTime.now().subtract(Duration(minutes: 1));
      expect(CampaignTheme.actionColor(vor1Minute, false, false),
          equals(CampaignTheme.primaryBright));
    ***REMOVED***);

    test('colors future actions', () {
      DateTime morgen = DateTime.now().add(Duration(days: 1));
      expect(CampaignTheme.actionColor(morgen, false, false),
          equals(CampaignTheme.primaryLight));

      DateTime in1Stunde = DateTime.now().add(Duration(hours: 1));
      expect(CampaignTheme.actionColor(in1Stunde, false, false),
          equals(CampaignTheme.primaryLight));

      DateTime in1Minute = DateTime.now().add(Duration(minutes: 1));
      expect(CampaignTheme.actionColor(in1Minute, false, false),
          equals(CampaignTheme.primaryLight));
    ***REMOVED***);

    test('colors own past actions', () {
      DateTime gestern = DateTime.now().subtract(Duration(days: 1));
      expect(CampaignTheme.actionColor(gestern, true, true),
          equals(CampaignTheme.altSecondaryBright));

      DateTime vor1Stunde = DateTime.now().subtract(Duration(hours: 1));
      expect(CampaignTheme.actionColor(vor1Stunde, true, true),
          equals(CampaignTheme.altSecondaryBright));

      DateTime vor1Minute = DateTime.now().subtract(Duration(minutes: 1));
      expect(CampaignTheme.actionColor(vor1Minute, true, true),
          equals(CampaignTheme.altSecondaryBright));
    ***REMOVED***);

    test('colors own future actions', () {
      DateTime morgen = DateTime.now().add(Duration(days: 1));
      expect(CampaignTheme.actionColor(morgen, true, true),
          equals(CampaignTheme.altSecondaryLight));

      DateTime in1Stunde = DateTime.now().add(Duration(hours: 1));
      expect(CampaignTheme.actionColor(in1Stunde, true, true),
          equals(CampaignTheme.altSecondaryLight));

      DateTime in1Minute = DateTime.now().add(Duration(minutes: 1));
      expect(CampaignTheme.actionColor(in1Minute, true, true),
          equals(CampaignTheme.altSecondaryLight));
    ***REMOVED***);

    test('colors participating past actions', () {
      DateTime gestern = DateTime.now().subtract(Duration(days: 1));
      expect(CampaignTheme.actionColor(gestern, false, true),
          equals(CampaignTheme.altPrimaryLight));

      DateTime vor1Stunde = DateTime.now().subtract(Duration(hours: 1));
      expect(CampaignTheme.actionColor(vor1Stunde, false, true),
          equals(CampaignTheme.altPrimaryLight));

      DateTime vor1Minute = DateTime.now().subtract(Duration(minutes: 1));
      expect(CampaignTheme.actionColor(vor1Minute, false, true),
          equals(CampaignTheme.altPrimaryLight));
    ***REMOVED***);

    test('colors participating future actions', () {
      DateTime morgen = DateTime.now().add(Duration(days: 1));
      expect(CampaignTheme.actionColor(morgen, false, true),
          equals(CampaignTheme.altPrimary));

      DateTime in1Stunde = DateTime.now().add(Duration(hours: 1));
      expect(CampaignTheme.actionColor(in1Stunde, false, true),
          equals(CampaignTheme.altPrimary));

      DateTime in1Minute = DateTime.now().add(Duration(minutes: 1));
      expect(CampaignTheme.actionColor(in1Minute, false, true),
          equals(CampaignTheme.altPrimary));
    ***REMOVED***);
  ***REMOVED***);

  group('placardColor', () {
    test('colors own placards', () {
      var color = CampaignTheme.placardColor(true);
      expect(color, CampaignTheme.altSecondaryLight);
    ***REMOVED***);

    test('uncolors others placards', () {
      var color = CampaignTheme.placardColor(false);
      expect(color, Colors.transparent);
    ***REMOVED***);
  ***REMOVED***);
***REMOVED***
