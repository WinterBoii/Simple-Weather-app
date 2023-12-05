import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:simple_weather/main.dart';
//Pixel Pro (38081FDJG00Q3A)
//(5E01F4BB-6921-41CF-B8E0-19C57BC2D94C)

void main() {
  patrolTest( 
    'Test weather app',
    (PatrolIntegrationTester $) async {
      await $.pumpWidget(const MyApp());
      await $.pumpAndTrySettle();

      // handle native location permission request dialog
      if (await $.native.isPermissionDialogVisible()) {
        await $.native.grantPermissionWhenInUse();
      }

      await $.pumpAndTrySettle(timeout: const Duration(seconds: 15));

      // Check if the floating action button exists
      //expect(await $(#search_button).exists, true);

      await $(#search_button).tap();

      await $(#search_page_scaffold).waitUntilVisible();
      await $(#search_text_field).enterText('Hillerstorp');
      await $(#search_city_name).waitUntilVisible();

      await $.native.openNotifications();
    },
  );
}
