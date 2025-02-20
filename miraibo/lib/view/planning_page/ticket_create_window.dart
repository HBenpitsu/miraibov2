import 'dart:async';
import 'package:flutter/material.dart';
import 'package:miraibo/dto/dto.dart' as dto;
import 'package:miraibo/view/shared/components/modal_window.dart';
import 'package:miraibo/skeleton/planning_page/daily_screen/ticket_create_window/ticket_create_window.dart'
    as skt;
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

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, initialIndex: 0, vsync: this);
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
            MonitorConfigTab(
                skeleton: widget.skeleton.monitorSchemeSection,
                key: monitorSectionKey),
            PlanConfigTab(
                skeleton: widget.skeleton.planSection, key: planSectionKey),
            EstimationConfigTab(
                skeleton: widget.skeleton.estimationSchemeSection,
                key: estimationSectionkey),
            LogConfigTab(
                skeleton: widget.skeleton.receiptLogSection,
                key: logSectionKey),
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
}

class MonitorConfigTab extends StatefulWidget {
  final skt.MonitorSchemeSection skeleton;
  const MonitorConfigTab({required this.skeleton, super.key});

  @override
  State<MonitorConfigTab> createState() => _MonitorConfigTabState();
}

class _MonitorConfigTabState extends State<MonitorConfigTab> {
  dto.MonitorScheme? currentScheme;

  Future<(List<dto.Category>, List<dto.Currency>, dto.Currency)> data() async {
    return (
      await widget.skeleton.getCategoryOptions(),
      await widget.skeleton.getCurrencyOptions(),
      await widget.skeleton.getDefaultCurrency()
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
          final defaultCurrency = snapshot.data!.$3;

          final initialScheme = dto.MonitorScheme(
              period: const dto.OpenPeriod(begins: null, ends: null),
              currency: defaultCurrency,
              displayOption: dto.MonitorDisplayOption.summation,
              categories: []);

          currentScheme ??= initialScheme;

          return SingleChildScrollView(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Monitor', style: Theme.of(context).textTheme.displaySmall),
              MonitorConfigSection(
                  categoryOptions: categoryOptions,
                  currencyOptions: currencyOptions,
                  initial: initialScheme,
                  onChanged: (scheme) {
                    currentScheme = scheme;
                  }),
            ],
          ));
        });
  }

  @override
  void dispose() {
    super.dispose();
    widget.skeleton.dispose();
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

  Future<(List<dto.Category>, List<dto.Currency>, dto.Currency)> data() async {
    return (
      await widget.skeleton.getCategoryOptions(),
      await widget.skeleton.getCurrencyOptions(),
      await widget.skeleton.getDefaultCurrency()
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
          final defaultCurrency = snapshot.data!.$3;

          final initialScheme = dto.PlanScheme(
              category: categoryOptions.first,
              description: '',
              price: dto.ConfigureblePrice(
                  amount: 0,
                  currencyId: defaultCurrency.id,
                  currencySymbol: defaultCurrency.symbol),
              schedule: dto.OneshotSchedule(date: DateTime.now().cutOffTime()));

          currentScheme ??= initialScheme;

          return SingleChildScrollView(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Plan', style: Theme.of(context).textTheme.displaySmall),
              PlanConfigSection(
                  categoryOptions: categoryOptions,
                  currencyOptions: currencyOptions,
                  initial: initialScheme,
                  onChanged: (scheme) {
                    currentScheme = scheme;
                  })
            ],
          ));
        });
  }

  @override
  void dispose() {
    super.dispose();
    widget.skeleton.dispose();
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

  Future<(List<dto.Category>, List<dto.Currency>, dto.Currency)> data() async {
    return (
      await widget.skeleton.getCategoryOptions(),
      await widget.skeleton.getCurrencyOptions(),
      await widget.skeleton.getDefaultCurrency()
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
          final defaultCurrency = snapshot.data!.$3;

          final initialScheme = dto.EstimationScheme(
              period: const dto.OpenPeriod(begins: null, ends: null),
              currency: defaultCurrency,
              displayOption: dto.EstimationDisplayOption.perDay,
              categories: []);

          currentScheme ??= initialScheme;

          return SingleChildScrollView(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Estimation',
                  style: Theme.of(context).textTheme.displaySmall),
              EstimationConfigSection(
                  categoryOptions: categoryOptions,
                  currencyOptions: currencyOptions,
                  initial: initialScheme,
                  onChanged: (scheme) {
                    currentScheme = scheme;
                  })
            ],
          ));
        });
  }

  @override
  void dispose() {
    super.dispose();
    widget.skeleton.dispose();
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

  Future<(List<dto.Category>, List<dto.Currency>, dto.Currency)> data() async {
    return (
      await widget.skeleton.getCategoryOptions(),
      await widget.skeleton.getCurrencyOptions(),
      await widget.skeleton.getDefaultCurrency()
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
          final categoryOptions = snapshot.data!.$1;
          final currencyOptions = snapshot.data!.$2;
          final defaultCurrency = snapshot.data!.$3;

          final initialScheme = dto.ReceiptLogScheme(
              category: categoryOptions.first,
              description: '',
              price: dto.ConfigureblePrice(
                  amount: 0,
                  currencyId: defaultCurrency.id,
                  currencySymbol: defaultCurrency.symbol),
              date: DateTime.now().cutOffTime(),
              confirmed: true);

          currentScheme ??= initialScheme;

          return SingleChildScrollView(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Log', style: Theme.of(context).textTheme.displaySmall),
              ReceiptLogConfigSection(
                  categoryOptions: categoryOptions,
                  currencyOptions: currencyOptions,
                  initial: initialScheme,
                  onChanged: (scheme) {
                    currentScheme = scheme;
                  })
            ],
          ));
        });
  }

  @override
  void dispose() {
    super.dispose();
    widget.skeleton.dispose();
  }
}
