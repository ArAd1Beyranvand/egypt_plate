import 'package:flutter/widgets.dart';
import 'package:plate_core/plate_core.dart';

import 'egypt_colors.dart';

/// Egypt as a `PlateCountry`, one per livery. The band colour is the
/// category, so it rides on [PlateCountry.panelColor] and the spec paints it
/// as `PlateFill.panel`; every const has the code `eg` and they compare equal,
/// so tell plates apart by [PlateSpec.id] and pass the livery to the view.
abstract final class EgyptCountry {
  static final PlateCountry private = _band(EgyptColors.privateBlue);
  static final PlateCountry taxi = _band(EgyptColors.taxiOrange);
  static final PlateCountry truck = _band(EgyptColors.truckRed);
  static final PlateCountry bus = _band(EgyptColors.busGray);
  static final PlateCountry tourist = _band(EgyptColors.touristBeige);
  static final PlateCountry customs = _band(EgyptColors.customsYellow);
  static final PlateCountry diplomatic = _band(EgyptColors.diplomaticGreen);
  static final PlateCountry police = _band(
    EgyptColors.policeBlue,
    text: EgyptColors.policeInk,
  );

  /// Private motorcycles share the private car's light blue.
  static final PlateCountry motorcycle = private;
}

/// A country block with no caption or flag: only the band colour.
PlateCountry _band(Color color, {Color text = EgyptColors.ink}) => PlateCountry(
  code: 'eg',
  captionLines: <String>[],
  panelColor: color,
  panelTextColor: text,
);
