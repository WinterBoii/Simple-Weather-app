import 'package:patrol/patrol.dart';
import 'package:simple_weather/main.dart';

void main() {
  patrolTest(
    'Test weather permission',
    ($) async {
      await $.pumpWidgetAndSettle(const MyApp());

      if (await $.nativeAutomator
          .isPermissionDialogVisible(timeout: const Duration(seconds: 15))) {
      await $.nativeAutomator.grantPermissionOnlyThisTime();
      }

      await $(#city_name).waitUntilVisible();

      /* await $(#search_button).tap();

      await $(#search_page_scaffold).waitUntilVisible();
      await $(#search_text_field).enterText('Hillerstorp');
      await $(#search_city_name).waitUntilVisible();

      await $.native.openNotifications(); */
    },
  );
}
