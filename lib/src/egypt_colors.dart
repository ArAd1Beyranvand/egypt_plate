import 'package:flutter/widgets.dart';

/// Each colour is the modal pixel of the reference artwork over the region it
/// fills; they differ from the CSS colours of the same names.
abstract final class EgyptColors {
  static const Color privateBlue = Color(0xFF0377B4);

  static const Color taxiOrange = Color(0xFFF47725);

  static const Color truckRed = Color(0xFFD2232A);

  static const Color busGray = Color(0xFFC3C3C3);

  static const Color touristBeige = Color(0xFFCEB284);

  static const Color customsYellow = Color(0xFFFFC945);

  static const Color diplomaticGreen = Color(0xFF41AD48);

  static const Color policeBlue = Color(0xFF25408F);

  static const Color field = Color(0xFFFFFFFF);
  static const Color ink = Color(0xFF000000);

  /// The band lettering on a police plate.
  static const Color policeInk = Color(0xFFFFFFFF);

  /// The vertical strip between the two registers.
  static const Color strip = Color(0xFF999999);

  /// The two screw heads, the mean of their mid-grey pixels.
  static const Color screw = Color(0xFFA8A89C);

  static const Color inactive = Color(0xFFB0B0B0);
}
