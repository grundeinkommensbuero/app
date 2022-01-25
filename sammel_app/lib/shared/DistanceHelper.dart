import 'dart:math';

import 'package:latlong2/latlong.dart';


class DistanceHelper
{
  
  static double getLongDiffFromM(LatLng position, double m)
  {
    var meterPerLong = pi/180*earthRadius*cos(position.latitude*pi/180).abs();
    return m/meterPerLong;
  }

  static double getLatDiffFromM(LatLng position, double m)
  {
    var meterPerLat = pi/180*earthRadius;
    return m/meterPerLat;
  }

}