import 'package:plate_core/plate_core.dart';

import 'egypt_colors.dart';

/// Every Egyptian plate is black on white in a thin black frame; the category
/// is the band, which is the country block, not the theme.
///
/// Border 5 px on a 276 px plate (0.018 of the height) and corner arc ~15 px
/// (0.055), both read off the artwork.
abstract final class EgyptThemes {
  static const PlateTheme standard = PlateTheme.monochrome(
    field: EgyptColors.field,
    ink: EgyptColors.ink,
    inactive: EgyptColors.inactive,
    borderWidthRatio: 0.018,
    plateRadiusRatio: 0.055,
  );
}
