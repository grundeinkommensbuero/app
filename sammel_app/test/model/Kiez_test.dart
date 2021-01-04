import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:quiver/collection.dart';
import 'package:sammel_app/model/Kiez.dart';
import 'package:test/test.dart';

import '../shared/TestdatenVorrat.dart';

void main() {
  group('serialisere', () {
    test('serialisiert nur Kiez', () {
      expect(jsonEncode(Kiez('bezirk1', 'kiez1', [])), '"kiez1"');
    ***REMOVED***);
  ***REMOVED***);
  group('equals', () {
    test('returns true for equal locations', () {
      expect(ffAlleeNord().equals(ffAlleeNord()), true);
      expect(tempVorstadt().equals(tempVorstadt()), true);
      expect(plaenterwald().equals(plaenterwald()), true);
    ***REMOVED***);

    test('returns true for null locations', () {
      expect(Kiez(null, null, []).equals(Kiez(null, null, [])), true);
    ***REMOVED***);

    test('returns false for different location', () {
      expect(Kiez('Bezirk 1', 'Kiez', []).equals(Kiez('Bezirk 2', 'Kiez', [])),
          false);
    ***REMOVED***);
    test('returns false for null location', () {
      expect(Kiez(null, 'Kiez', []).equals(Kiez('Bezirk', 'Kiez', [])), false);
    ***REMOVED***);
    test('returns false for location and null', () {
      expect(Kiez('Bezirk', 'Kiez', []).equals(Kiez(null, 'Kiez', [])), false);
    ***REMOVED***);

    test('returns false for different place', () {
      expect(Kiez('Bezirk', 'Ort 1', []).equals(Kiez('Bezirk', 'Ort 2', [])),
          false);
    ***REMOVED***);
    test('returns false for null place', () {
      expect(
          Kiez('Bezirk', null, [])
              .equals(Kiez('Bezirk', 'Kiez', [])),
          false);
    ***REMOVED***);
    test('returns false for place and null', () {
      expect(
          Kiez('Bezirk', 'Kiez', [])
              .equals(Kiez('Bezirk', null, [])),
          false);
    ***REMOVED***);

    test('returns false for different coordinates', () {
      expect(
          Kiez('Bezirk', 'Kiez', [])
              .equals(Kiez('Bezirk', 'Kiez', [])),
          false);
    ***REMOVED***);
    test('returns false for null coordinates', () {
      expect(
          Kiez('Bezirk', 'Kiez', [])
              .equals(Kiez('Bezirk', 'Kiez', [])),
          false);
    ***REMOVED***);
    test('returns false for coordinates and null', () {
      expect(
          Kiez('Bezirk', 'Kiez', [])
              .equals(Kiez('Bezirk', 'Kiez', [])),
          false);
    ***REMOVED***);
  ***REMOVED***);
***REMOVED***
