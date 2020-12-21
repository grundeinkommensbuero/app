import 'dart:convert';
import 'dart:io';

Map<String, String> bezirke = {
  "01": "Mitte",
  "02": "Friedrichshain-Kreuzberg",
  "03": "Pankow",
  "04": "Charlottenburg-Wilmersdorf",
  "05": "Spandau",
  "06": "Steglitz-Zehlendorf",
  "07": "Tempelhof-Schöneberg",
  "08": "Neukölln",
  "09": "Treptow-Köpenick",
  "10": "Marzahn",
  "11": "Lichtenberg",
  "12": "Reinickendorf",
};

Future<void> main() async {
  File centroidsFile = new File('./assets/geodata/lor_berlin_centroids.json');
  File polygonsFile = new File('./assets/geodata/lor_berlin_polygons.json');
  File outputFile = new File('./assets/geodata/lor_berlin.json');
  String centroidString = await centroidsFile.readAsString();
  String polygonsString = await polygonsFile.readAsString();
  Map<String, dynamic> centroidsMap = (jsonDecode(centroidString) as List)
      .asMap()
      .map((_, c) => MapEntry(c['properties']['SCHLUESSEL'], c));
  Map<String, dynamic> polygonsMap = (jsonDecode(polygonsString) as List)
      .asMap()
      .map((_, c) => MapEntry(c['properties']['SCHLUESSEL'], c));
  List<Map<String, dynamic>> kieze = centroidsMap.keys.map((schluessel) {
    var bezirksId = polygonsMap[schluessel]['properties']['BEZIRK'];
    return {
      "kiez": polygonsMap[schluessel]['properties']['BEZIRKSREG'],
      "bezirk": bezirke[bezirksId],
      "latitude": centroidsMap[schluessel]['geometry']['coordinates'][0],
      "longitude": centroidsMap[schluessel]['geometry']['coordinates'][1],
      "polygon": polygonsMap[schluessel]['geometry']['coordinates']
    };
  }).toList();
  outputFile.writeAsString(jsonEncode(kieze));
}
