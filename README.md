FREE PALESTINE 🇮🇷🇵🇸 پاینده ایران

GO VEGAN 🌱

==================================

From the mighty people of Iran to the ancient people of Egypt to view examples:

https://platexample.ir/#/discover/egypt

# egypt_plate

Egypt's licence plates for the `plate_core` library. The 2008 series: one design in nine liveries, a Cairo and a Giza register, diplomatic and police variants and a two-line motorcycle plate, with their theme, alphabets and advisory validator.

## Install

```yaml
dependencies:
  plate_core: ^0.12.0
  egypt_plate: ^0.1.0
```

## Use

```dart
import 'package:plate_core/plate_core.dart';
import 'package:egypt_plate/egypt_plate.dart';

PlateCanvas(
  spec: EgyptPlates.car,
  theme: EgyptThemes.standard,
  validator: const EgyptValidator(),
  autoValidate: true,
  onChooseCharacter: noCharacterChooser,
);
```

## Contains

- `EgyptCountry` — country panels: `private`, `taxi`, `truck`, `bus`, `tourist`, `customs`, `diplomatic`, `police` and 1 more.
- `EgyptPlates` — 6 plate specs: `car`, `cairo`, `giza`, `diplomatic`, `police`, `motorcycle`.
- `EgyptThemes` — 1 theme: `standard`.
- `EgyptValidator` — advisory validator; flags the frame, never blocks a keystroke.

## Plates

The 2008 series. The band colour is the category, so `car` serves private,
taxi, truck, bus, tourist and customs alike: pair it with the matching
`EgyptCountry` and `EgyptThemes.standard`. Registers are stored in the
order they read left to right on the plate.

Not implemented: the pre-2008 all-numeric plates and a police motorcycle
plate (no artwork shows its lettering).

## Part of plate

Painted by [`plate_core`](https://pub.dev/packages/plate_core); alphabets shared through [`plate_alphabet`](https://pub.dev/packages/plate_alphabet); optional character picker in [`plate_keypad`](https://pub.dev/packages/plate_keypad).

