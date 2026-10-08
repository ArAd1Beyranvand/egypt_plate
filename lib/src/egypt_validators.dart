import 'package:plate_alphabet/plate_alphabet.dart';
import 'package:plate_core/plate_core.dart';

/// Judges an Egyptian plate by the length of each of its registers. Reports,
/// never bars a keystroke.
///
/// The article fixes the counts: three digits for Cairo and four for every
/// other governorate, two letters for Giza and three for the rest. It also
/// says the numbers run 1 to 9 "chosen randomly", which is too loose to
/// enforce. [digits] and [code] are numeral groups, any other group is
/// letters from [EgyptAlphabets.letters].
class EgyptValidator extends GatedPlateValidator {
  const EgyptValidator(this.lengths);

  /// Group key to the number of cells it must hold.
  final Map<String, int> lengths;

  static const EgyptValidator car = EgyptValidator(<String, int>{
    'digits': 4,
    'letters': 3,
  });
  static const EgyptValidator cairo = EgyptValidator(<String, int>{
    'digits': 3,
    'letters': 3,
  });
  static const EgyptValidator giza = EgyptValidator(<String, int>{
    'digits': 4,
    'letters': 2,
  });
  static const EgyptValidator diplomatic = EgyptValidator(<String, int>{
    'digits': 3,
    'code': 2,
  });
  static const EgyptValidator police = EgyptValidator(<String, int>{
    'digits': 4,
    'code': 2,
    'letters': 1,
  });
  static const EgyptValidator motorcycle = EgyptValidator(<String, int>{
    'letters': 3,
    'digits': 4,
  });

  @override
  String get gateGroup => 'digits';

  static String reasonFor(String group, int length) => group == 'letters'
      ? 'The letters are $length of the 17 plate letters.'
      : 'The $group is $length digits.';

  @override
  PlateValidation judge(PlateEntry entry) {
    for (final MapEntry<String, int> g in lengths.entries) {
      final String value = entry.group(g.key);
      final bool ok = g.key == 'letters'
          ? value.length == g.value &&
                value
                    .split('')
                    .every(EgyptAlphabets.letters.characters.contains)
          : isDigitsOfLength(value, g.value);
      if (!ok) return PlateValidation.invalid(reasonFor(g.key, g.value));
    }
    return const PlateValidation.valid();
  }
}
