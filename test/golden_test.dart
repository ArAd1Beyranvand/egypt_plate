import 'dart:io';

import 'package:egypt_plate/egypt_plate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plate_core/plate_core.dart';

/// One golden per category, drawn with real bold faces so the ink can be
/// measured against the references.
///
/// Regenerate with `flutter test --update-goldens` after a deliberate change.
void main() {
  setUpAll(() async {
    final FontLoader loader = FontLoader('Roboto');
    for (final String path in const <String>[
      '/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf',
      '/usr/share/fonts/truetype/noto/NotoSansArabic-Bold.ttf',
    ]) {
      final File face = File(path);
      if (!face.existsSync()) continue;
      loader.addFont(face.readAsBytes().then((b) => ByteData.view(b.buffer)));
    }
    await loader.load();
  });

  /// category id -> (spec, livery, space-separated sample value)
  final Map<String, (PlateSpec, PlateCountry, String)>
  cases = <String, (PlateSpec, PlateCountry, String)>{
    'private': (EgyptPlates.car, EgyptCountry.private, '2594 TGS'),
    'private_cairo': (EgyptPlates.cairo, EgyptCountry.private, '259 TGS'),
    'private_giza': (EgyptPlates.giza, EgyptCountry.private, '2594 GS'),
    'taxi': (EgyptPlates.car, EgyptCountry.taxi, '2594 TGS'),
    'truck': (EgyptPlates.car, EgyptCountry.truck, '2594 TGS'),
    'bus': (EgyptPlates.car, EgyptCountry.bus, '2594 TGS'),
    'tourist': (EgyptPlates.car, EgyptCountry.tourist, '2594 TGS'),
    'customs': (EgyptPlates.car, EgyptCountry.customs, '2594 TGS'),
    'diplomatic': (EgyptPlates.diplomatic, EgyptCountry.diplomatic, '259 63'),
    'police': (EgyptPlates.police, EgyptCountry.police, '2594 63 S'),
    'motorcycle': (EgyptPlates.motorcycle, EgyptCountry.motorcycle, 'TGS 2594'),
  };

  for (final MapEntry<String, (PlateSpec, PlateCountry, String)> c
      in cases.entries) {
    testWidgets(c.key, (tester) async {
      final (PlateSpec spec, PlateCountry country, String values) = c.value;
      final PlateController controller = PlateController.fromValues(
        spec,
        values.split(' '),
      );
      final double width = spec.canvasWidth > spec.canvasHeight ? 700 : 400;
      final double height = width * spec.canvasHeight / spec.canvasWidth;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: width,
                height: height,
                child: PlateThemeScope(
                  theme: EgyptThemes.standard,
                  child: PlateView(
                    controller: controller,
                    theme: EgyptThemes.standard,
                    country: country,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(PlateView),
        matchesGoldenFile('goldens/eg_${c.key}.png'),
      );
      await tester.pumpWidget(const SizedBox.shrink());
      controller.dispose();
    });
  }
}
