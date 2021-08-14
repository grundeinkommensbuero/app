import 'dart:math';

import 'package:latlong2/latlong.dart';


class DistanceHelper
{
  
  static double getLongDiffFromM(LatLng position, double m)
  {
    var m_per_long = pi/180*earthRadius;
    return m/m_per_long;
  ***REMOVED***

  static double getLatDiffFromM(LatLng position, double m)
  {
    var m_per_lat = pi/180*earthRadius*cos(position.latitude*pi/180).abs();
    return m/m_per_lat;
    ;
  ***REMOVED***

***REMOVED***