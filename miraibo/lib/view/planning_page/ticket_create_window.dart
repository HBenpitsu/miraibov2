import 'dart:async';
import 'package:flutter/material.dart';
import 'package:miraibo/dto/dto.dart' as dto;
import 'package:miraibo/view/shared/components/modal_window.dart';
import 'package:miraibo/skeleton/planning_page/daily_screen.dart' as skt;
import 'package:miraibo/view/shared/components/receipt_log_config_section_with_presets.dart';
import 'package:miraibo/view/shared/components/ticket_scheme_config_section.dart';
import 'package:miraibo/view/shared/constants.dart';

void openTicketCreateWindow(
    BuildContext context, skt.TicketCreateWindow skeleton) {
  showDialog(
    context: context,
    builder: (context) {
      return TicketCreateWindow(skeleton: skeleton);
    },
  );
}

class TicketCreateWindow extends StatefulWidget {
  final skt.TicketCreateWindow skeleton;
  static const double windowHorizontalPadding = 30;
  const TicketCreateWindow({required this.skeleton, super.key});

  @override
  State<TicketCreateWindow> createState() => _TicketCreateWindowState();
}

class _TicketCreateWindowState extends State<TicketCreateWindow>
    with TickerProviderStateMixin {
  GlobalKey<_MonitorConfigTabState> monitorSectionKey = GlobalKey();
  GlobalKey<_PlanConfigTabState> planSectionKey = GlobalKey();
  GlobalKey<_EstimationConfigTabState> estimationSectionkey = GlobalKey();
  GlobalKey<_LogConfigTabState> logSectionKey = GlobalKey();

  late TabController tabController;

  late final Widget monitorConfigTab;
  late final Widget planConfigTab;
  late final Widget estimationConfigTab;
  late final Widget logConfigTab;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, initialIndex: 0, vsync: this);

    monitorConfigTab = Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: TicketCreateWindow.windowHorizontalPadding),
        child: MonitorConfigTab(
            skeleton: widget.skeleton.monitorSchemeSection,
            key: monitorSectionKey));
    planConfigTab = Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: TicketCreateWindow.windowHorizontalPadding),
        child: PlanConfigTab(
            skeleton: widget.skeleton.planSection, key: planSectionKey));
    estimationConfigTab = Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: TicketCreateWindow.windowHorizontalPadding),
        child: EstimationConfigTab(
            skeleton: widget.skeleton.estimationSchemeSection,
            key: estimationSectionkey));
    logConfigTab = Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: TicketCreateWindow.windowHorizontalPadding),
        child: LogConfigTab(
            skeleton: widget.skeleton.receiptLogSection, key: logSectionKey));
  }

  @override
  Widget build(BuildContext context) {
    return ModalWindowContainer(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: TabBar(
          controller: tabController,
          tabs: const [
            Tab(icon: Icon(Icons.monitor), child: Text('Monitor')),
            Tab(icon: Icon(Icons.calendar_today), child: Text('Plan')),
            Tab(icon: Icon(Icons.equalizer), child: Text('Est')),
            Tab(icon: Icon(Icons.edit), child: Text('Log')),
          ],
        ),
        body: TabBarView(
          controller: tabController,
          children: [
            monitorConfigTab,
            planConfigTab,
            estimationConfigTab,
            logConfigTab,
          ],
        ),
        bottomNavigationBar: SizedBox(
            height: bottomNavigationBarHeight,
            child: Row(
              children: [
                const Spacer(),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('cancel')),
                const Spacer(),
                TextButton(
                    onPressed: () {
                      bool? sucseeded;
                      switch (tabController.index) {
                        case 0:
                          sucseeded =
                              monitorSectionKey.currentState?.createTicket();
                        case 1:
                          sucseeded =
                              planSectionKey.currentState?.createTicket();
                        case 2:
                          sucseeded =
                              estimationSectionkey.currentState?.createTicket();
                        case 3:
                          sucseeded =
                              logSectionKey.currentState?.createTicket();
                        default:
                          throw Exception('Invalid tab index');
                      }
                      if (sucseeded == true) Navigator.of(context).pop();
                    },
                    child: const Text('create')),
                const Spacer(),
              ],
            )),
      ),
    );
  }

  @override
  void dispose() {
    widget.skeleton.dispose();
    tabController.dispose();
    super.dispose();
  }
}

class MonitorConfigTab extends StatefulWidget {
  final skt.MonitorSchemeSection skeleton;
  const MonitorConfigTab({required this.skeleton, super.key});

  @override
  State<MonitorConfigTab> createState() => _MonitorConfigTabState();
}

class _MonitorConfigTabState extends State<MonitorConfigTab> {
  dto.MonitorScheme? currentScheme;

  Future<(List<dto.Category>, List<dto.Currency>, dto.MonitorScheme)>
      data() async {
    return (
      await widget.skeleton.getCategoryOptions(),
      await widget.skeleton.getCurrencyOptions(),
      await widget.skeleton.getInitialScheme()
    );
  }

  /// return false if it is not initialized
  /// return true if instanciation is successful
  bool createTicket() {
    if (currentScheme == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('It is not initialized. Try again.'),
        ),
      );
      return false;
    }
    if (currentScheme!.categories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('At least one category must be selected.'),
        ),
      );
      return false;
    }
    widget.skeleton.createMonitorScheme(
        categoryIds: currentScheme!.categories.map((e) => e.id).toList(),
        period: currentScheme!.period,
        displayOption: currentScheme!.displayOption,
        currencyId: currentScheme!.currency.id);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: data(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return const Text('Error');
          }
          final categoryOptions = snapshot.data!.$1;
          final currencyOptions = snapshot.data!.$2;
          final initialScheme = snapshot.data!.$3;

          currentScheme ??= initialScheme;

          return ListView(
            shrinkWrap: true,
            children: [
              Center(
                  child: Text('Monitor',
                      style: Theme.of(context).textTheme.displaySmall)),
              MonitorConfigSection(
                  categoryOptions: categoryOptions,
                  currencyOptions: currencyOptions,
                  initial: initialScheme,
                  onChanged: (scheme) {
                    currentScheme = scheme;
                  }),
            ],
          );
        });
  }

  @override
  void dispose() {
    widget.skeleton.dispose();
    super.dispose();
  }
}

class PlanConfigTab extends StatefulWidget {
  final skt.PlanSection skeleton;
  const PlanConfigTab({required this.skeleton, super.key});

  @override
  State<PlanConfigTab> createState() => _PlanConfigTabState();
}

class _PlanConfigTabState extends State<PlanConfigTab> {
  dto.PlanScheme? currentScheme;

  Future<(List<dto.Category>, List<dto.Currency>, dto.PlanScheme)>
      data() async {
    return (
      await widget.skeleton.getCategoryOptions(),
      await widget.skeleton.getCurrencyOptions(),
      await widget.skeleton.getInitialScheme()
    );
  }

  /// return false if it is not initialized
  /// return true if instanciation is successful
  bool createTicket() {
    if (currentScheme == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('It is not initialized. Try again.'),
        ),
      );
      return false;
    }
    if (currentScheme!.schedule is dto.WeeklySchedule) {
      final weeklySchedule = currentScheme!.schedule as dto.WeeklySchedule;
      if (!(weeklySchedule.sunday ||
          weeklySchedule.monday ||
          weeklySchedule.tuesday ||
          weeklySchedule.wednesday ||
          weeklySchedule.thursday ||
          weeklySchedule.friday ||
          weeklySchedule.saturday)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('At least one day must be selected.'),
          ),
        );
        return false;
      }
    }
    widget.skeleton.createPlan(
        categoryId: currentScheme!.category.id,
        description: currentScheme!.description,
        amount: currentScheme!.price.amount,
        currencyId: currentScheme!.price.currencyId,
        schedule: currentScheme!.schedule);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: data(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return const Text('Error');
          }
          final categoryOptions = snapshot.data!.$1;
          final currencyOptions = snapshot.data!.$2;
          final initialScheme = snapshot.data!.$3;

          currentScheme ??= initialScheme;

          return ListView(shrinkWrap: true, children: [
            Center(
                child: Text('Plan',
                    style: Theme.of(context).textTheme.displaySmall)),
            PlanConfigSection(
                categoryOptions: categoryOptions,
                currencyOptions: currencyOptions,
                initial: initialScheme,
                onChanged: (scheme) {
                  currentScheme = scheme;
                })
          ]);
        });
  }

  @override
  void dispose() {
    widget.skeleton.dispose();
    super.dispose();
  }
}

class EstimationConfigTab extends StatefulWidget {
  final skt.EstimationSchemeSection skeleton;
  const EstimationConfigTab({required this.skeleton, super.key});

  @override
  State<EstimationConfigTab> createState() => _EstimationConfigTabState();
}

class _EstimationConfigTabState extends State<EstimationConfigTab> {
  dto.EstimationScheme? currentScheme;

  Future<(List<dto.Category>, List<dto.Currency>, dto.EstimationScheme)>
      data() async {
    return (
      await widget.skeleton.getCategoryOptions(),
      await widget.skeleton.getCurrencyOptions(),
      await widget.skeleton.getInitialScheme()
    );
  }

  /// return false if it is not initialized
  /// return true if instanciation is successful
  bool createTicket() {
    if (currentScheme == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('It is not initialized. Try again.'),
        ),
      );
      return false;
    }
    if (currentScheme!.categories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('At least one category must be selected.'),
        ),
      );
      return false;
    }
    widget.skeleton.createEstimationScheme(
        categoryIds: currentScheme!.categories.map((e) => e.id).toList(),
        period: currentScheme!.period,
        displayOption: currentScheme!.displayOption,
        currencyId: currentScheme!.currency.id);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: data(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return const Text('Error');
          }
          final categoryOptions = snapshot.data!.$1;
          final currencyOptions = snapshot.data!.$2;
          final initialScheme = snapshot.data!.$3;

          currentScheme ??= initialScheme;

          return ListView(
            shrinkWrap: true,
            children: [
              Center(
                  child: Text('Estimation',
                      style: Theme.of(context).textTheme.displaySmall)),
              EstimationConfigSection(
                  categoryOptions: categoryOptions,
                  currencyOptions: currencyOptions,
                  initial: initialScheme,
                  onChanged: (scheme) {
                    currentScheme = scheme;
                  })
            ],
          );
        });
  }

  @override
  void dispose() {
    widget.skeleton.dispose();
    super.dispose();
  }
}

class LogConfigTab extends StatefulWidget {
  final skt.ReceiptLogSection skeleton;
  const LogConfigTab({required this.skeleton, super.key});

  @override
  State<LogConfigTab> createState() => _LogConfigTabState();
}

class _LogConfigTabState extends State<LogConfigTab> {
  dto.ReceiptLogScheme? currentScheme;

  Future<
      (
        List<dto.ReceiptLogSchemePreset>,
        List<dto.Category>,
        List<dto.Currency>,
        dto.ReceiptLogScheme
      )> data() async {
    return (
      await widget.skeleton.getPresets(),
      await widget.skeleton.getCategoryOptions(),
      await widget.skeleton.getCurrencyOptions(),
      await widget.skeleton.getInitialScheme()
    );
  }

  /// return false if it is not initialized
  /// return true if instanciation is successful
  bool createTicket() {
    if (currentScheme == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('It is not initialized. Try again.'),
        ),
      );
      return false;
    }
    widget.skeleton.createReceiptLog(
      categoryId: currentScheme!.category.id,
      description: currentScheme!.description,
      amount: currentScheme!.price.amount,
      currencyId: currentScheme!.price.currencyId,
      date: currentScheme!.date,
    );
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: data(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return const Text('Error');
          }

          final presets = snapshot.data!.$1;
          final categoryOptions = snapshot.data!.$2;
          final currencyOptions = snapshot.data!.$3;
          final initialScheme = snapshot.data!.$4;

          currentScheme ??= initialScheme;

          return ListView(
            shrinkWrap: true,
            children: [
              Center(
                  child: Text('Log',
                      style: Theme.of(context).textTheme.displaySmall)),
              ReceiptLogConfigSectionWithPresets(
                  presets: presets,
                  categoryOptions: categoryOptions,
                  currencyOptions: currencyOptions,
                  initial: initialScheme,
                  onChanged: (scheme) {
                    currentScheme = scheme;
                  })
            ],
          );
        });
  }

  @override
  void dispose() {
    widget.skeleton.dispose();
    super.dispose();
  }
}
