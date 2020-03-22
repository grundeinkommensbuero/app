class ListLocation {
  int id;
  String name;
  String street;
  String number;
  double latitude;
  double longitude;

  ListLocation(this.id, this.name, this.street, this.number, this.latitude,
      this.longitude);

  ListLocation.fromJson(jsonListLocation)
      : id = jsonListLocation['id'],
        name = jsonListLocation['name'],
        street = jsonListLocation['street'],
        number = jsonListLocation['number'],
        latitude = jsonListLocation['latitude'],
        longitude = jsonListLocation['longitude'];
***REMOVED***
