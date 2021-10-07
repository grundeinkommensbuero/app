import 'package:flutter_map/flutter_map.dart';

int noRotation = InteractiveFlag.all & ~InteractiveFlag.rotate;
int noRotationNoMove = InteractiveFlag.all & ~InteractiveFlag.rotate & ~InteractiveFlag.drag;