import 'package:sammel_app/model/ListLocation.dart';

ListLocation curry36() =>
    ListLocation(1, "Curry 36", "Mehringdamm", "36", 52.4935584, 13.3877282);

ListLocation cafeKotti() => ListLocation(
    1, "Café Kotti", "Adalbertstraße", "96", 52.5001477, 13.4181523);

ListLocation zukunft() =>
    ListLocation(1, "Zukunft", "Laskerstraße", "5", 52.5016524, 13.4655402);

List<ListLocation> sampleListLocations() => [curry36(), cafeKotti(), zukunft()];
