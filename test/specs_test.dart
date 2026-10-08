import 'package:egypt_plate/egypt_plate.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plate_core/plate_core.dart';

/// Nothing in the article is specific to Israel, so there is no
/// `PlateRestriction` to pin; these tests cover the specs and the validators.
void main() {
  List<String?> v(String s) => s.split(' ');

  test('every spec is well formed', () {
    for (final PlateSpec spec in EgyptPlates.all) {
      expect(debugValidateSpec(spec), isTrue);
    }
  });

  test('car plates: four digits and three letters', () {
    bool ok(PlateSpec s, EgyptValidator val, String x) =>
        val.validate(PlateEntry(spec: s, values: v(x))).isValid;
    expect(ok(EgyptPlates.car, EgyptValidator.car, '2 5 9 4 T G S'), isTrue);
    expect(ok(EgyptPlates.cairo, EgyptValidator.cairo, '2 5 9 T G S'), isTrue);
    expect(ok(EgyptPlates.giza, EgyptValidator.giza, '2 5 9 4 G S'), isTrue);
  });

  test('a letter outside the alphabet is reported', () {
    final PlateEntry entry = PlateEntry(
      spec: EgyptPlates.car,
      values: v('2 5 9 4 T G Z'),
    );
    expect(EgyptValidator.car.validate(entry).isValid, isFalse);
  });
}
