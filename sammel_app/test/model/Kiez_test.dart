import 'dart:convert';

import 'package:sammel_app/model/Kiez.dart';
import 'package:test/test.dart';

import '../shared/TestdatenVorrat.dart';

void main() {
  group('serialisere', () {
    test('serialisiert Ort mit id, Bezirk und Ort', () {
      expect(jsonEncode(Kiez('bezirk1', 'kiez1', 52.49653, 13.43762)),
          '{"id":1,"bezirk":"bezirk1","kiez":"kiez1","lattitude":52.49653,"longitude":13.43762***REMOVED***');
    ***REMOVED***);
  ***REMOVED***);
  group('equals', () {
    test('returns true for equal locations', () {
      expect(ffAlleeNord().equals(ffAlleeNord()), true);
      expect(tempVorstadt().equals(tempVorstadt()), true);
      expect(plaenterwald().equals(plaenterwald()), true);
    ***REMOVED***);
    test('returns true for null locations', () {
      expect(Kiez(null, null, null, null).equals(Kiez(null, null, null, null)),
          true);
    ***REMOVED***);

    test('returns false for different id', () {
      expect(
          Kiez('Bezirk', 'Kiez', 52.48993, 13.46839)
              .equals(Kiez('Bezirk', 'Kiez', 52.48993, 13.46839)),
          false);
    ***REMOVED***);
    test('returns false for null id', () {
      expect(
          Kiez('Bezirk', 'Kiez', 52.48993, 13.46839)
              .equals(Kiez('Bezirk', 'Kiez', 52.48993, 13.46839)),
          false);
    ***REMOVED***);
    test('returns false for id and null', () {
      expect(
          Kiez('Bezirk', 'Kiez', 52.48993, 13.46839)
              .equals(Kiez('Bezirk', 'Kiez', 52.48993, 13.46839)),
          false);
    ***REMOVED***);

    test('returns false for different location', () {
      expect(
          Kiez('Bezirk 1', 'Kiez', 52.48993, 13.46839)
              .equals(Kiez('Bezirk 2', 'Kiez', 52.48993, 13.46839)),
          false);
    ***REMOVED***);
    test('returns false for null location', () {
      expect(
          Kiez(null, 'Kiez', 52.48993, 13.46839)
              .equals(Kiez('Bezirk', 'Kiez', 52.48993, 13.46839)),
          false);
    ***REMOVED***);
    test('returns false for location and null', () {
      expect(
          Kiez('Bezirk', 'Kiez', 52.48993, 13.46839)
              .equals(Kiez(null, 'Kiez', 52.48993, 13.46839)),
          false);
    ***REMOVED***);

    test('returns false for different place', () {
      expect(
          Kiez('Bezirk', 'Ort 1', 52.48993, 13.46839)
              .equals(Kiez('Bezirk', 'Ort 2', 52.48993, 13.46839)),
          false);
    ***REMOVED***);
    test('returns false for null place', () {
      expect(
          Kiez('Bezirk', null, 52.48993, 13.46839)
              .equals(Kiez('Bezirk', 'Kiez', 52.48993, 13.46839)),
          false);
    ***REMOVED***);
    test('returns false for place and null', () {
      expect(
          Kiez('Bezirk', 'Kiez', 52.48993, 13.46839)
              .equals(Kiez('Bezirk', null, 52.48993, 13.46839)),
          false);
    ***REMOVED***);

    test('returns false for different coordinates', () {
      expect(
          Kiez('Bezirk', 'Kiez', 52.48993, 13.46839)
              .equals(Kiez('Bezirk', 'Kiez', 53.48993, 14.46839)),
          false);
    ***REMOVED***);
    test('returns false for null coordinates', () {
      expect(
          Kiez('Bezirk', 'Kiez', null, null)
              .equals(Kiez('Bezirk', 'Kiez', 52.48993, 13.46839)),
          false);
    ***REMOVED***);
    test('returns false for coordinates and null', () {
      expect(
          Kiez('Bezirk', 'Kiez', 52.48993, 13.46839)
              .equals(Kiez('Bezirk', 'Kiez', null, null)),
          false);
    ***REMOVED***);
  ***REMOVED***);
***REMOVED***
