import 'package:patrol/patrol.dart';
import 'package:simple_weather/main.dart';

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

      await $.pumpAndTrySettle();

      // Check if the floating action button exists
      //expect(await $(#search_button).exists, true);

      await $(#search_button).tap();

      await $(#search_page_scaffold).waitUntilVisible();
      await $(#search_text_field).enterText('Hillerstorp'.toUpperCase());
      await $(#search_button).tap();
      await $(#search_city_name).waitUntilVisible();
      $('Hillerstorp'.toUpperCase());

      await $.native.openNotifications();
    },
  );
}
