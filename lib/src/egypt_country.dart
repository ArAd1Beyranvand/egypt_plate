import 'package:flutter/widgets.dart';
import 'package:plate_core/plate_core.dart';

import 'egypt_colors.dart';

/// One country per livery. The band colour is the category, so it rides on
/// [PlateCountry.panelColor] and the spec paints it as `PlateFill.panel`.
/// All share the code `eg` and compare equal: tell plates apart by
/// [PlateSpec.id].
abstract final class EgyptCountry {
  static final PlateCountry private = _band(EgyptColors.privateBlue);
  static final PlateCountry taxi = _band(EgyptColors.taxiOrange);
  static final PlateCountry truck = _band(EgyptColors.truckRed);
  static final PlateCountry bus = _band(EgyptColors.busGray);
  static final PlateCountry tourist = _band(EgyptColors.touristBeige);
  static final PlateCountry customs = _band(EgyptColors.customsYellow);
  static final PlateCountry diplomatic = _band(EgyptColors.diplomaticGreen);
  static final PlateCountry police = _band(EgyptColors.policeBlue, text: EgyptColors.policeInk);

  static final PlateCountry motorcycle = private;
}

PlateCountry _band(Color color, {Color text = EgyptColors.ink}) =>
    PlateCountry(code: 'eg', captionLines: <String>[], panelColor: color, panelTextColor: text);
