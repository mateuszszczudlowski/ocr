import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ocr/src/config/routes.dart';

@RoutePage()
class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: const [
        OCRRoute(),
        ScannerRoute(),
        AllergenFormRoute(),
      ],
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);
        return Scaffold(
          body: child,
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: const Color(0x26000000),
                  blurRadius: 12,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: NavigationBar(
              height: 72,
              destinations: [
                NavigationDestination(
                  icon: const Icon(Icons.home_outlined, size: 28),
                  selectedIcon: const Icon(Icons.home, size: 28),
                  label: AppLocalizations.of(context)!.home,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.camera_alt_outlined, size: 28),
                  selectedIcon: const Icon(Icons.camera_alt, size: 28),
                  label: AppLocalizations.of(context)!.camera,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.add_box_outlined, size: 28),
                  selectedIcon: const Icon(Icons.add_box, size: 28),
                  label: AppLocalizations.of(context)!.add,
                ),
              ],
              selectedIndex: tabsRouter.activeIndex,
              onDestinationSelected: tabsRouter.setActiveIndex,
              indicatorColor: Colors.black26,
              surfaceTintColor: Colors.transparent,
            ),
          ),
        );
      },
    );
  }
}
