import 'package:flutter/material.dart';
import 'package:miraibo/skeleton/root.dart' as skt;
import 'package:miraibo/view/motion.dart';
import 'package:miraibo/view/data_page/data_page.dart';
import 'package:miraibo/view/main_page/main_page.dart';
import 'package:miraibo/view/planning_page/planning_page.dart';
import 'package:miraibo/view/utils_page/utils_page.dart';

/* 
This widget is the root of the application.
It defines app-wide properties, colorThemes and behaviors.
and home page of the application. home page is the most outer widget of the MaterialApp.
In this case, the home page is a TabView with 4 tabs.
*/
class AppRoot extends StatelessWidget {
  final skt.Root skeleton;
  const AppRoot(this.skeleton, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      scrollBehavior: const MouseScrollBehavior(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 255, 203, 91)),
        useMaterial3: true,
      ),
      home: AppViewRoot(skeleton),
    );
  }
}

/* 
This widget is the main content of the application.
The most important part of TabView is 'Page's, which are displayed when the corresponding tab is selected.
This widget manages the TabBar and TabBarView, and displays each page.
*/
class AppViewRoot extends StatefulWidget {
  final skt.Root skeleton;
  const AppViewRoot(this.skeleton, {super.key});

  @override
  State<AppViewRoot> createState() => _AppViewRootState();
}

class _AppViewRootState extends State<AppViewRoot> {
  late final AppBar appBar;
  late final PlanningPage planningPage;
  late final MainPage mainPage;
  late final DataPage dataPage;
  late final UtilsPage utilsPage;
  late bool scrollLock;

  @override
  void initState() {
    super.initState();
    appBar = AppBar(
      title: const TabBar(
        tabs: [
          Tab(icon: Icon(Icons.calendar_today)),
          Tab(icon: Icon(Icons.home)),
          Tab(icon: Icon(Icons.data_usage)),
          Tab(icon: Icon(Icons.settings)),
        ],
      ),
    );
    planningPage = PlanningPage(widget.skeleton.planningPage);
    mainPage = MainPage(widget.skeleton.mainPage);
    dataPage = DataPage(
      widget.skeleton.dataPage,
      scrollLock: () {
        if (!mounted) return;
        setState(() {
          scrollLock = true;
        });
      },
      scrollUnlock: () {
        if (!mounted) return;
        setState(() {
          scrollLock = false;
        });
      },
    );
    utilsPage = UtilsPage(widget.skeleton.utilsPage);
    scrollLock = false;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      initialIndex: 1,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: appBar,
        body: TabBarView(
          physics: scrollLock ? const NeverScrollableScrollPhysics() : null,
          children: [
            planningPage,
            mainPage,
            dataPage,
            utilsPage,
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget.skeleton.dispose();
  }
}
