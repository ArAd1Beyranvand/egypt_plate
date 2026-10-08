import 'package:flutter/widgets.dart';

/// The colours of Egypt's plates, each the modal pixel of the Wikipedia
/// artwork (`Egypt_-_License_Plate_-_*.png`) over the region it fills.
///
/// The article names the band colours in prose; the artwork's are not the
/// CSS ones — "orange" is `F47725`, "beige" a tan `CEB284`.
abstract final class EgyptColors {
  /// Private cars and motorcycles. The article says "light blue".
  static const Color privateBlue = Color(0xFF0377B4);

  /// Taxis. "Orange".
  static const Color taxiOrange = Color(0xFFF47725);

  /// Trucks. "Red". Filed in the artwork as `Public_Transport`.
  static const Color truckRed = Color(0xFFD2232A);

  /// Buses and some government vehicles. "Gray".
  static const Color busGray = Color(0xFFC3C3C3);

  /// Limousines and tourist buses. "Beige". Filed as `Commercial`.
  static const Color touristBeige = Color(0xFFCEB284);

  /// Vehicles with unpaid customs. "Yellow".
  static const Color customsYellow = Color(0xFFFFC945);

  /// Diplomatic. "Green".
  static const Color diplomaticGreen = Color(0xFF41AD48);

  /// Police. "Dark blue".
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
