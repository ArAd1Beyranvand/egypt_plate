import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:plate_alphabet/plate_alphabet.dart';
import 'package:plate_core/plate_core.dart';

import 'egypt_colors.dart';
import 'egypt_country.dart';

/// Where everything sits, in plate coordinates.
///
/// **Car**: the article gives 35 × 17 cm, so the canvas is 350 × 170 although
/// the artwork is drawn at 502 × 276 (1.82, not 2.06). Each artwork plate
/// rectangle (frame outer edge x 9..511, y 5..281 on the 520 × 288 PNG) was
/// scaled by 0.697 across and 0.616 down, and the ink projected onto each
/// axis (`Egypt_-_License_Plate_-_{Private,Private_Cairo,Private_Giza,Police,
/// Diplomatic}.png`). Everything below is that table:
///
///   band fill          y   0 ..  61.6, then a black line 61.6 .. 64.7
///   strip              x 167.7 .. 178.1, line to bottom edge, 999999
///   screws             x 11.1 .. 27.1 / 325.0 .. 341.0, y 7.4 .. 23.3
///   EGYPT              x  32.0 .. 141.3   y 19.6 .. 49.1   (cap height 29.5)
///   مصر                x 212.2 .. 299.2   y 18.4 .. 49.7
///   POLICE             x  35.5 .. 158.0   y 16.6 .. 46.0   (white)
///   الشرطة             x 206.0 .. 299.2   y 15.3 .. 52.2   (white)
///   4 digits           x  10.4 .. 160.0   y 85.9 .. 138.7  (glyph centres
///                      25, 66.5, 107.5, 148.6: pitch 41)
///   3 digits           x  23.7 .. 135.7   (glyph centres 38.3, 79.7, 120.7)
///   3 letters          x 188.6 .. 336.1   (centres 206.7, 258.5, 309.6)
///   2 letters          x 213.6 .. 312.4   (centres 234.9, 286.0)
///
/// Ink per box, measured on the goldens with Noto Sans Arabic Bold: the plate
/// letters reach 0.63 of their box, so the letters' 63 takes a box of 98. The
/// digits do not follow the box: a slot fits its glyph to the cell, and at the
/// reference pitch of 41 that caps the Eastern Arabic digits at 44 tall (83%
/// of 52.8) whatever the box height. A host's own face changes both.
///
/// **Motorcycle**: the article gives no size, so the canvas is the artwork's
/// own pixels, 261 × 310 (frame x 9..270, y 5..315 on the 277 × 323 PNG):
///
///   band fill y 0 .. 80, black line 80 .. 85; strip x 241 .. 256
///   letters, 3 cells   x  12 .. 224   y  95 .. 175   (centres 38, 110.5, 186)
///   digits, 4 cells    x  18 .. 233   y 202 .. 300   (centres 39 .. 216.5)
///
/// What the engine cannot reproduce: the motorcycle's digits are 98 tall,
/// which would need a 180-unit box on a 310 plate with the letters above them.
/// The digit box is the tallest that stays on the canvas centred on the ink
/// (118, ink ~64 = 65% of the reference) and the letters' box is 100 (ink ~54
/// = 68%).
abstract final class _Layout {
  static const double carWidth = 350, carHeight = 170;
  static const double carBandEnd = 63.1, carLine = 3.1;
  static const double carStripStart = 167.7, carStripEnd = 178.1;
  static const double carDigitsHeight = 98, carDigitsCy = 110.6;
  static const double carLettersHeight = 98, carLettersCy = 108.1;
  static const double carLeftPitch = 41;
  static const double carDigits4Left = 5, carDigits3Left = 17.8;
  static const double carRightPitch = 51.5, carRightCentre = 259.5;

  static const double motoWidth = 261, motoHeight = 310;
  static const double motoBandEnd = 82.5, motoLine = 5;
  static const double motoStripStart = 241, motoStripEnd = 256;
  static const double motoLettersLeft = 5, motoLettersPitch = 74;
  static const double motoLettersTop = 64.5, motoLettersHeight = 120;
  static const double motoDigitsLeft = 9.4, motoDigitsPitch = 59.2;
  static const double motoDigitsTop = 184, motoDigitsHeight = 118;
}

/// The two words in the band: where each one's ink centres and how large to
/// set it. [EgyptPlates.car]'s are the ink of EGYPT and مصر; the police pair is
/// sized by width, since POLICE at the reference cap height would run into
/// الشرطة, and مصر by its width too: at the 72 its height asks for it is 113
/// wide against 87.
class _BandText {
  const _BandText({
    required this.latin,
    required this.arabic,
    required this.latinGlyph,
    required this.arabicGlyph,
    required this.latinCx,
    required this.latinCy,
    required this.arabicCx,
    required this.arabicCy,
    this.color,
  });

  final String latin, arabic;
  final double latinGlyph, arabicGlyph;
  final double latinCx, latinCy, arabicCx, arabicCy;
  final Color? color;

  static const _BandText egypt = _BandText(
    latin: 'EGYPT',
    arabic: 'مصر',
    latinGlyph: 46,
    arabicGlyph: 54,
    latinCx: 86.7,
    latinCy: 34.4,
    arabicCx: 255.7,
    arabicCy: 22.7,
  );

  static const _BandText police = _BandText(
    latin: 'POLICE',
    arabic: 'الشرطة',
    latinGlyph: 42,
    arabicGlyph: 35,
    latinCx: 96.75,
    latinCy: 31.9,
    arabicCx: 252.6,
    arabicCy: 31.7,
    color: EgyptColors.policeInk,
  );

  /// A label whose box is centred on ([cx], [cy]) and is just taller than the
  /// text's line (0.72 of the glyph height), so the text is centred in it
  /// rather than top-aligned and spilling.
  PlateLabel label(String text, double cx, double cy, double glyph) =>
      PlateLabel(
        text: text,
        box: PlateBox(cx - 70, cy - 20, 140, 40),
        glyphHeight: glyph,
        color: color,
      );
}

class _Run {
  const _Run(this.key, this.alphabet, this.count);
  final String key;
  final PlateAlphabet alphabet;
  final int count;
}

/// The 2008 series. The band colour is the category, so [car] serves private,
/// taxi, truck, bus, tourist and customs alike: pair it with the matching
/// `EgyptCountry` and `EgyptThemes.standard`. Registers are stored in the
/// order they read left to right on the plate.
///
/// Not implemented: the pre-2008 all-numeric plates and a police motorcycle
/// plate (no artwork shows its lettering).
abstract final class EgyptPlates {
  /// `٢٥٩٤ ط ج س`: four digits, three letters. Every governorate but Cairo
  /// and Giza.
  static final PlateSpec car = _car(
    'eg.car',
    digitsLeft: _Layout.carDigits4Left,
    digits: 4,
    right: const <_Run>[_Run('letters', EgyptAlphabets.letters, 3)],
  );

  /// `٢٥٩ ط ج س`: Cairo has three digits.
  static final PlateSpec cairo = _car(
    'eg.cairo',
    digitsLeft: _Layout.carDigits3Left,
    digits: 3,
    right: const <_Run>[_Run('letters', EgyptAlphabets.letters, 3)],
  );

  /// `٢٥٩٤ ج س`: Giza has two letters.
  static final PlateSpec giza = _car(
    'eg.giza',
    digitsLeft: _Layout.carDigits4Left,
    digits: 4,
    right: const <_Run>[_Run('letters', EgyptAlphabets.letters, 2)],
  );

  /// `٢٥٩ ٦٣`: three digits and a two-digit code, in the green band.
  static final PlateSpec diplomatic = _car(
    'eg.diplomatic',
    digitsLeft: _Layout.carDigits3Left,
    digits: 3,
    right: const <_Run>[_Run('code', EgyptAlphabets.digits, 2)],
  );

  /// `٢٥٩٤ ٦٣ س`: the artwork shows four digits, a two-digit number and one
  /// letter, under POLICE / الشرطة in white on dark blue.
  static final PlateSpec police = _car(
    'eg.police',
    digitsLeft: _Layout.carDigits4Left,
    digits: 4,
    right: const <_Run>[
      _Run('code', EgyptAlphabets.digits, 2),
      _Run('letters', EgyptAlphabets.letters, 1),
    ],
    text: _BandText.police,
  );

  /// Letters over digits, `ط ج س` / `٢٥٩٤`, on a near-square plate.
  static final PlateSpec motorcycle = _motorcycle();

  static List<PlateSpec> get all => <PlateSpec>[
    car,
    cairo,
    giza,
    diplomatic,
    police,
    motorcycle,
  ];

  static PlateSlot _field(
    PlateAlphabet alphabet,
    int count,
    double left,
    double top,
    double pitch,
    double height,
  ) => PlateSlot(
    alphabet: alphabet,
    box: PlateBox(left, top, count * pitch, height),
    length: count,
    spacing: max(0, pitch - 0.6 * 0.72 * height),
  );

  static PlateSection _background(
    double bandEnd,
    double line,
    double stripStart,
    double stripEnd,
  ) => PlateSection.rows(<PlatePart>[
    PlatePart(PlateSection.fill(PlateFill.panel), end: bandEnd, divider: line),
    PlatePart(
      PlateSection.columns(<PlatePart>[
        PlatePart(PlateSection.plain, end: stripStart),
        PlatePart(
          PlateSection.fill(PlateFill.color(EgyptColors.strip)),
          end: stripEnd,
        ),
        PlatePart(PlateSection.plain),
      ]),
    ),
  ]);

  static PlateBand _screw(double left, double top, double size) => PlateBand(
    box: PlateBox(left, top, size, size),
    color: EgyptColors.screw,
    topCornerRadius: size / 2,
    bottomCornerRadius: size / 2,
  );

  static PlateSpec _car(
    String id, {
    required double digitsLeft,
    required int digits,
    required List<_Run> right,
    _BandText text = _BandText.egypt,
  }) {
    final int cells = right.fold(0, (int n, _Run r) => n + r.count);
    final double rightLeft =
        _Layout.carRightCentre - cells * _Layout.carRightPitch / 2;
    final List<PlateSlot> slots = <PlateSlot>[
      _field(
        EgyptAlphabets.digits,
        digits,
        digitsLeft,
        _Layout.carDigitsCy - _Layout.carDigitsHeight / 2,
        _Layout.carLeftPitch,
        _Layout.carDigitsHeight,
      ),
    ];
    final List<PlateTextGroup> groups = <PlateTextGroup>[
      const PlateTextGroup(<int>[0], key: 'digits'),
    ];
    var cell = 0;
    for (final _Run run in right) {
      final bool numeric = run.alphabet == EgyptAlphabets.digits;
      final double height = numeric
          ? _Layout.carDigitsHeight
          : _Layout.carLettersHeight;
      groups.add(PlateTextGroup(<int>[slots.length], key: run.key));
      slots.add(
        _field(
          run.alphabet,
          run.count,
          rightLeft + cell * _Layout.carRightPitch,
          (numeric ? _Layout.carDigitsCy : _Layout.carLettersCy) - height / 2,
          _Layout.carRightPitch,
          height,
        ),
      );
      cell += run.count;
    }
    return PlateSpec(
      id: id,
      country: EgyptCountry.private,
      canvasWidth: _Layout.carWidth,
      canvasHeight: _Layout.carHeight,
      panel: const PlatePanel(box: PlateBox(0, 0, 0, 0)),
      noPanel: true,
      background: _background(
        _Layout.carBandEnd,
        _Layout.carLine,
        _Layout.carStripStart,
        _Layout.carStripEnd,
      ),
      bands: <PlateBand>[_screw(11.2, 7.4, 15.6), _screw(325.2, 7.8, 15.6)],
      labels: <PlateLabel>[
        text.label(text.latin, text.latinCx, text.latinCy, text.latinGlyph),
        text.label(text.arabic, text.arabicCx, text.arabicCy, text.arabicGlyph),
      ],
      slots: slots,
      textGroups: groups,
    );
  }

  static PlateSpec _motorcycle() {
    return PlateSpec(
      id: 'eg.motorcycle',
      country: EgyptCountry.motorcycle,
      canvasWidth: _Layout.motoWidth,
      canvasHeight: _Layout.motoHeight,
      panel: const PlatePanel(box: PlateBox(0, 0, 0, 0)),
      noPanel: true,
      borderWidthRatioOverride: 0.016,
      background: _background(
        _Layout.motoBandEnd,
        _Layout.motoLine,
        _Layout.motoStripStart,
        _Layout.motoStripEnd,
      ),
      bands: <PlateBand>[_screw(16, 12, 24), _screw(219, 12, 24)],
      labels: const <PlateLabel>[
        PlateLabel(
          text: 'EGYPT',
          box: PlateBox(0, 40, 110, 38),
          glyphHeight: 32,
        ),
        PlateLabel(
          text: 'مصر',
          box: PlateBox(147.5, 24, 110, 40),
          glyphHeight: 62,
        ),
      ],
      slots: <PlateSlot>[
        _field(
          EgyptAlphabets.letters,
          3,
          _Layout.motoLettersLeft,
          _Layout.motoLettersTop,
          _Layout.motoLettersPitch,
          _Layout.motoLettersHeight,
        ),
        _field(
          EgyptAlphabets.digits,
          4,
          _Layout.motoDigitsLeft,
          _Layout.motoDigitsTop,
          _Layout.motoDigitsPitch,
          _Layout.motoDigitsHeight,
        ),
      ],
      textGroups: const <PlateTextGroup>[
        PlateTextGroup(<int>[0], key: 'letters'),
        PlateTextGroup(<int>[1], key: 'digits'),
      ],
    );
  }
}
