import 'package:flutter/foundation.dart';

class ProfileUpdateNotifier {
  static final ValueNotifier<int> version = ValueNotifier<int>(0);

  static void notifyUpdate() {
    version.value++;
  }
}
