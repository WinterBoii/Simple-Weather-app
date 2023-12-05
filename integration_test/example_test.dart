import 'package:flutter/material.dart';
import 'package:patrol/patrol.dart';
import 'package:simple_weather/main.dart';
//Pixel 8 Pro (38081FDJG00Q3A)
//(5E01F4BB-6921-41CF-B8E0-19C57BC2D94C)

void main() {
  patrolTest(
    'Test weather app',
    (PatrolIntegrationTester $) async {
      await $.pumpWidget(MyApp());
      await $.pumpAndTrySettle(duration: const Duration(seconds: 5));

      // handle native location permission request dialog
      if (await $.native.isPermissionDialogVisible()) {
        //await $.native.selectFineLocation();
        await $.native.grantPermissionWhenInUse();
      }
      // toggle system theme
      //await $.native.enableDarkMode();

      await $.pumpAndTrySettle(timeout: const Duration(seconds: 15));

      //await $(FloatingActionButton).tap();

      /* await $(#search_button).tap();

      await $(#search_page_scaffold).waitUntilVisible();
      await $(#search_text_field).enterText('Hillerstorp');
      await $(#search_city_name).waitUntilVisible();

      await $.native.openNotifications(); */
    },
  );
}
