import 'package:sammel_app/model/ListLocation.dart';

curry36() =>
    ListLocation(1, "Curry 36", "Mehringdamm", "36", 52.4935584, 13.3877282);

cafeKotti() => ListLocation(
    1, "Café Kotti", "Adalbertstraße", "96", 52.5001477, 13.4181523);

zukunft() =>
    ListLocation(1, "Zukunft", "Laskerstraße", "5", 52.5016524, 13.4655402);

sampleListLocations() => [curry36(), cafeKotti(), zukunft()];
