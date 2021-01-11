import 'dart:convert';

import 'package:sammel_app/model/Kiez.dart';
import 'package:test/test.dart';

import '../shared/TestdatenVorrat.dart';

void main() {
  group('serialisere', () {
    test('serialisiert nur Kiez', () {
      expect(jsonEncode(Kiez('kiez1', 'bezirk1', 'ortsteil1', [])), '"kiez1"');
    ***REMOVED***);
  ***REMOVED***);
  group('equals', () {
    test('returns true for equal locations', () {
      expect(ffAlleeNord().equals(ffAlleeNord()), true);
      expect(tempVorstadt().equals(tempVorstadt()), true);
      expect(plaenterwald().equals(plaenterwald()), true);
    ***REMOVED***);

    test('returns true for null locations', () {
      expect(
          Kiez(null, null, null, []).equals(Kiez(null, null, null, [])), true);
    ***REMOVED***);

    test('returns false for different location', () {
      expect(
          Kiez('Kiez', 'Region 1', 'Ortsteil', [])
              .equals(Kiez('Kiez', 'Region 2', 'Ortsteil', [])),
          false);
    ***REMOVED***);
    test('returns false for null name', () {
      expect(
          Kiez(null, 'Kiez', 'Ortsteil', [])
              .equals(Kiez('Kiez', 'Region', 'Ortsteil', [])),
          false);
    ***REMOVED***);
    test('returns false for name and null', () {
      expect(
          Kiez('Kiez', 'Region', 'Ortsteil', [])
              .equals(Kiez(null, 'Region', 'Ortsteil', [])),
          false);
    ***REMOVED***);

    test('returns false for different place', () {
      expect(
          Kiez('Kiez', 'Region 1', 'Ortsteil', [])
              .equals(Kiez('Kiez', 'Region 2', 'Ortsteil', [])),
          false);
    ***REMOVED***);
    test('returns false for null place', () {
      expect(
          Kiez(null, 'Region', 'Ortsteil', [])
              .equals(Kiez('Kiez', 'Region', 'Ortsteil', [])),
          false);
    ***REMOVED***);
    test('returns false for place and null', () {
      expect(
          Kiez('Kiez', 'Region', 'Ortsteil', [])
              .equals(Kiez(null, 'Region', 'Ortsteil', [])),
          false);
    ***REMOVED***);
  ***REMOVED***);
***REMOVED***
