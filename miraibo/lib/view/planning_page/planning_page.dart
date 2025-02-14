import 'package:flutter/material.dart';

import 'package:miraibo/skeleton/planning_page/planning_page.dart' as skt;
import 'package:miraibo/view/planning_page/daily_screen.dart';
import 'package:miraibo/view/planning_page/monthly_screen.dart';

/// SchedulingPage has two screens: MonthlyScreen and DailyScreen
/// The main function of PlanningPage is to switch between these two screens

class PlanningPage extends StatefulWidget {
  final skt.PlanningPage skeleton;
  static const Duration screenSwitchingDuration = Duration(milliseconds: 300);
  const PlanningPage(this.skeleton, {super.key});

  @override
  State<PlanningPage> createState() => _PlanningPageState();
}

class _PlanningPageState extends State<PlanningPage> {
  late Widget screen;
  late final void Function() onPageDisposed;

  void navigateToDailyScreen(skt.DailyScreen skeleton) {
    setState(() {
      screen = DailyScreen(skeleton,
          navigateToMonthlyScreen: navigateToMonthlyScreen);
    });
  }

  void navigateToMonthlyScreen(skt.MonthlyScreen skeleton) {
    setState(() {
      screen =
          MonthlyScreen(skeleton, navigateToDailyScreen: navigateToDailyScreen);
    });
  }

  @override
  void initState() {
    super.initState();
    screen = MonthlyScreen(widget.skeleton.showInitialScreen(),
        navigateToDailyScreen: navigateToDailyScreen);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
        duration: PlanningPage.screenSwitchingDuration, child: screen);
  }

  @override
  void dispose() {
    super.dispose();
    widget.skeleton.dispose();
  }
}
