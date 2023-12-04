import 'package:patrol/patrol.dart';
import 'package:simple_weather/main.dart';
import 'package:simple_weather/pages/weather_page.dart';

void main() {
  patrolTest(
    'Test weather app',
    (PatrolIntegrationTester $) async {
      await $.pumpWidgetAndSettle(const MyApp());
      print("11111111111111111");

      //await $.native.selectFineLocation();
      if (await $.native
          .isPermissionDialogVisible(timeout: const Duration(seconds: 15))) {
        //await $.native.grantPermissionWhenInUse();
        await $.native.selectFineLocation();
      }
      print("222222222222222222");

      await $(#city_name).waitUntilVisible();
      print("3333333333333333333");

      await $(#search_button).tap();

      await $(#search_page_scaffold).waitUntilVisible();
      await $(#search_text_field).enterText('Hillerstorp');
      await $(#search_city_name).waitUntilVisible();

      await $.native.openNotifications();
    },
  );
}
