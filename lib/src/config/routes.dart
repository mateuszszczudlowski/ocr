import 'package:auto_route/auto_route.dart';

import 'package:ocr/src/modules/main_screen/view/main_view.dart';
import 'package:ocr/src/modules/login_screen/view/login_view.dart';
import 'package:ocr/src/modules/settings_screen/view/settings_view.dart';
import 'package:ocr/src/modules/main_screen/widget/pages/ocr_view.dart';
import 'package:ocr/src/modules/main_screen/widget/pages/scanner_view.dart';
import 'package:ocr/src/modules/main_screen/widget/pages/allergens_view.dart';

part 'routes.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'View,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.adaptive();
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: LoginRoute.page,
          path: '/',
          initial: true,
        ),
        CustomRoute(
          page: MainRoute.page,
          transitionsBuilder: TransitionsBuilders.fadeIn,
          children: [
            AutoRoute(page: OCRRoute.page, initial: true),
            AutoRoute(page: ScannerRoute.page),
            AutoRoute(page: AllergenFormRoute.page),
          ],
        ),
        AutoRoute(
          page: SettingsRoute.page,
          path: '/settings',
        ),
      ];
}
