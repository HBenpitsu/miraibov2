import 'package:flutter/material.dart';
import 'package:miraibo/skeleton/data_page/temporary_ticket_config_window.dart'
    as skt;
import 'package:miraibo/dto/dto.dart' as dto;
import 'package:miraibo/view/shared/components/modal_window.dart';
import 'package:miraibo/view/shared/constants.dart';
import 'package:miraibo/view/shared/components/ticket_scheme_config_section.dart';

const sectorMargin = SizedBox(height: 20);

void openTemporaryTicketConfigWindow(
    BuildContext context, skt.TemporaryTicketConfigWindow skeleton) {
  showDialog(
      context: context,
      builder: (context) {
        return TemporaryTicketConfigWindow(skeleton);
      });
}

class TemporaryTicketConfigWindow extends StatefulWidget {
  final skt.TemporaryTicketConfigWindow skeleton;
  static const double widthOfHorizontalPadding = 20;
  const TemporaryTicketConfigWindow(this.skeleton, {super.key});

  @override
  State<StatefulWidget> createState() => _TemporaryTicketConfigWindowState();
}

class _TemporaryTicketConfigWindowState
    extends State<TemporaryTicketConfigWindow> with TickerProviderStateMixin {
  late final TabController tabCtl;

  final GlobalKey<_MonitorSchemeSectionState> monitorSectionKey =
      GlobalKey<_MonitorSchemeSectionState>();
  final GlobalKey<_EstimationSchemeSectionState> estimationSectionKey =
      GlobalKey<_EstimationSchemeSectionState>();

  late final Widget monitorTab;
  late final Widget estimationTab;

  @override
  void initState() {
    super.initState();
    tabCtl = TabController(length: 2, vsync: this);
    monitorTab = _MonitorSchemeSection(widget.skeleton.monitorSchemeSection,
        key: monitorSectionKey);
    estimationTab = _EstimationSchemeSection(
        widget.skeleton.estimationSchemeSection,
        key: estimationSectionKey);
  }

  void apply() {
    String? result;
    switch (tabCtl.index) {
      case 0:
        result = monitorSectionKey.currentState!.applyScheme();
      case 1:
        result = estimationSectionKey.currentState!.applyScheme();
      default:
        throw Exception('Invalid tab index');
    }
    if (result != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(result)));
      return;
    }
    Navigator.of(context).pop();
  }

  Widget actionButtons() {
    return Padding(
        padding: const EdgeInsets.all(actionButtonPadding),
        child: Row(
          children: [
            Expanded(
                child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'))),
            Expanded(
                child: TextButton(onPressed: apply, child: const Text('OK'))),
          ],
        ));
  }

  Widget content(
      BuildContext context, skt.TemporaryTicketScheme initialScheme) {
    final initialIndex = switch (initialScheme) {
      skt.TemporaryMonitorScheme _ => 0,
      skt.TemporaryEstimationScheme _ => 1,
      skt.TemporaryTicketSchemeUnspecified _ => 0,
    };
    tabCtl.index = initialIndex;
    return Scaffold(
        appBar: TabBar(controller: tabCtl, tabs: const [
          Tab(icon: Icon(Icons.monitor), child: Text('Monitor')),
          Tab(icon: Icon(Icons.equalizer), child: Text('Estimation')),
        ]),
        body: TabBarView(
          controller: tabCtl,
          children: [
            monitorTab,
            estimationTab,
          ],
        ),
        bottomNavigationBar: SizedBox(
            height: bottomNavigationBarHeight, child: actionButtons()));
  }

  @override
  Widget build(BuildContext context) {
    return ModalWindowContainer(
        child: FutureBuilder(
            future: widget.skeleton.getInitialScheme(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return content(context, snapshot.data!);
              }
              if (snapshot.hasError) {
                return const Center(child: Text('Error'));
              }
              return const Center(child: CircularProgressIndicator());
            }));
  }

  @override
  void dispose() {
    tabCtl.dispose();
    widget.skeleton.dispose();
    super.dispose();
  }
}

abstract class _SectionPreState<T extends StatefulWidget> extends State<T> {
  Widget section(Object data);
  Future data();

  /// return null when applying is successful
  /// return error message when applying is failed
  String? applyScheme();

  String get sectionTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: TemporaryTicketConfigWindow.widthOfHorizontalPadding),
        child: FutureBuilder(
            future: data(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  shrinkWrap: true,
                  children: [
                    Center(
                        child: Text(sectionTitle,
                            style: Theme.of(context).textTheme.headlineLarge)),
                    sectorMargin,
                    section(snapshot.data!)
                  ],
                );
              }
              if (snapshot.hasError) {
                return const Center(child: Text('Error'));
              }
              return const Center(child: CircularProgressIndicator());
            }));
  }
}

class _MonitorSchemeSection extends StatefulWidget {
  final skt.TemporaryMonitorSchemeSection skeleton;
  const _MonitorSchemeSection(this.skeleton, {super.key});

  @override
  State<StatefulWidget> createState() => _MonitorSchemeSectionState();
}

class _MonitorSchemeSectionState
    extends _SectionPreState<_MonitorSchemeSection> {
  skt.TemporaryMonitorScheme? currentScheme;

  @override
  String get sectionTitle => 'Monitor';

  @override
  Future<(skt.TemporaryMonitorScheme, List<dto.Category>, List<dto.Currency>)>
      data() async {
    return (
      await widget.skeleton.getInitialScheme(),
      await widget.skeleton.getCategoryOptions(),
      await widget.skeleton.getCurrencyOptions(),
    );
  }

  @override
  Widget section(
      covariant (
        skt.TemporaryMonitorScheme,
        List<dto.Category>,
        List<dto.Currency>
      ) data) {
    final initialScheme = data.$1;
    currentScheme ??= initialScheme;
    final categoryOptions = data.$2;
    final currencyOptions = data.$3;

    return MonitorConfigSection(
      initial: dto.MonitorScheme(
          period: currentScheme!.period,
          currency: currentScheme!.currency,
          displayOption: currentScheme!.displayOption,
          categories: currentScheme!.categories,
          isAllCategoriesIncluded: currentScheme!.isAllCategoriesIncluded),
      categoryOptions: categoryOptions,
      currencyOptions: currencyOptions,
      onChanged: (scheme) {
        currentScheme = skt.TemporaryMonitorScheme(
          period: scheme.period,
          currency: scheme.currency,
          displayOption: scheme.displayOption,
          categories: scheme.categories,
          isAllCategoriesIncluded: scheme.isAllCategoriesIncluded,
        );
      },
    );
  }

  @override
  String? applyScheme() {
    if (currentScheme == null) {
      return 'It is not initialized yet. Try again.';
    }
    if (!currentScheme!.isAllCategoriesIncluded &&
        currentScheme!.categories.isEmpty) {
      return 'select at least one category';
    }
    widget.skeleton.applyMonitorScheme(
      currentScheme!.categories.map((cat) => cat.id).toList(),
      currentScheme!.period,
      currentScheme!.displayOption,
      currentScheme!.currency.id,
      currentScheme!.isAllCategoriesIncluded,
    );
    return null;
  }
}

class _EstimationSchemeSection extends StatefulWidget {
  final skt.TemporaryEstimationSchemeSection skeleton;
  const _EstimationSchemeSection(this.skeleton, {super.key});

  @override
  State<StatefulWidget> createState() => _EstimationSchemeSectionState();
}

class _EstimationSchemeSectionState
    extends _SectionPreState<_EstimationSchemeSection> {
  @override
  String get sectionTitle => 'Estimation';

  skt.TemporaryEstimationScheme? currentScheme;

  @override
  Future<
      (
        skt.TemporaryEstimationScheme,
        List<dto.Category>,
        List<dto.Currency>
      )> data() async {
    return (
      await widget.skeleton.getInitialScheme(),
      await widget.skeleton.getCategoryOptions(),
      await widget.skeleton.getCurrencyOptions(),
    );
  }

  @override
  Widget section(
      covariant (
        skt.TemporaryEstimationScheme,
        List<dto.Category>,
        List<dto.Currency>
      ) data) {
    final initialScheme = data.$1;
    currentScheme ??= initialScheme;
    final categoryOptions = data.$2;
    final currencyOptions = data.$3;

    return EstimationConfigSection(
      initial: dto.EstimationScheme(
          period: currentScheme!.period,
          currency: currentScheme!.currency,
          displayOption: currentScheme!.displayOption,
          category: currentScheme!.category),
      categoryOptions: categoryOptions,
      currencyOptions: currencyOptions,
      onChanged: (scheme) {
        currentScheme = skt.TemporaryEstimationScheme(
            period: scheme.period,
            currency: scheme.currency,
            displayOption: scheme.displayOption,
            category: scheme.category);
      },
    );
  }

  @override
  String? applyScheme() {
    if (currentScheme == null) {
      return 'It is not initialized yet. Try again.';
    }
    widget.skeleton.applyMonitorScheme(
        currentScheme!.category.id,
        currentScheme!.period,
        currentScheme!.displayOption,
        currentScheme!.currency.id);
    return null;
  }
}
