import 'package:flutter/material.dart';
import 'package:miraibo/skeleton/root.dart' as skt;
import 'package:miraibo/view/components/motion.dart';
import 'package:miraibo/view/pages/pages.dart';

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
      scrollBehavior: const MyCustomScrollBehavior(),
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
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      initialIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Miraibo'),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(icon: Icon(Icons.home)),
              Tab(icon: Icon(Icons.data_usage)),
              Tab(icon: Icon(Icons.calendar_today)),
              Tab(icon: Icon(Icons.settings)),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            PlanningPage(widget.skeleton.planningPage),
            MainPage(),
            DataPage(),
            UtilsPage(),
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
