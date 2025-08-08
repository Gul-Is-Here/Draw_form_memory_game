import 'package:flutter/foundation.dart';

extension ListEqualityExt on List {
  bool equals(List other) => listEquals(this, other);
}