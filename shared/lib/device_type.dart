import 'dart:math';
import 'package:flutter/cupertino.dart';

class DeviceType {
  static bool isTablet(BuildContext context) {
    // Getting the smallest width of the screen
    var smallestWidth = min(
      MediaQuery.of(context).size.width,
      MediaQuery.of(context).size.height,
    );

    // Considering a smallest width of more than 600 as a tablet
    var tabletThreshold = 600;

    // TODO: Revisit this. Enabling line below disabled two-pane on tablet.
    // Converting the smallest width to dp (density-independent pixels)
    // var smallestWidthDp = smallestWidth / MediaQuery.of(context).devicePixelRatio;

    return smallestWidth > tabletThreshold;
  }
}
