import 'package:flutter/material.dart';
import 'package:miraibo/skeleton/data_page/chart_configuration_window.dart'
    as skt;
import 'package:miraibo/dto/dto.dart' as dto;
import 'package:miraibo/view/shared/components/modal_window.dart';
import 'package:miraibo/view/shared/constants.dart';
import 'package:miraibo/view/shared/components/form_components/form_components.dart';

const sectorMargin = SizedBox(height: 20);

void openChartConfigureWindow(
    BuildContext context, skt.ChartConfigurationWindow skeleton) {
  showDialog(
      context: context, builder: (context) => ChartConfigureWindow(skeleton));
}

class ChartConfigureWindow extends StatefulWidget {
  final skt.ChartConfigurationWindow skeleton;
  static const widthOfHorizontalPadding = 30.0;
  const ChartConfigureWindow(this.skeleton, {super.key});

  @override
  State<ChartConfigureWindow> createState() => _ChartConfigureWindowState();
}

class _ChartConfigureWindowState extends State<ChartConfigureWindow>
    with TickerProviderStateMixin {
  late final TabController tabCtl;
  final GlobalKey<_AccumulationChartSectionState> accumulationChartKey =
      GlobalKey();
  final GlobalKey<_SubtotalChartSectionState> subtotalChartKey = GlobalKey();
  final GlobalKey<_PieChartSectionState> pieChartKey = GlobalKey();

  late final Widget accumulationChartTab;
  late final Widget subtotalChartTab;
  late final Widget pieChartTab;

  @override
  void initState() {
    super.initState();
    tabCtl = TabController(length: 3, vsync: this);

    accumulationChartTab = _AccumulationChartSection(
        widget.skeleton.accumulationChartSection,
        key: accumulationChartKey);
    subtotalChartTab = _SubtotalChartSection(
        widget.skeleton.subtotalChartSection,
        key: subtotalChartKey);
    pieChartTab =
        _PieChartSection(widget.skeleton.pieChartSection, key: pieChartKey);
  }

  void apply() {
    String? result;
    switch (tabCtl.index) {
      case 0:
        result = accumulationChartKey.currentState!.applyScheme();
      case 1:
        result = subtotalChartKey.currentState!.applyScheme();
      case 2:
        result = pieChartKey.currentState!.applyScheme();
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

  Widget content(BuildContext context, skt.ChartScheme initialScheme) {
    final initialIndex = switch (initialScheme) {
      skt.AccumulationChartScheme _ => 0,
      skt.SubtotalChartScheme _ => 1,
      skt.PieChartScheme _ => 2,
      skt.ChartSchemeUnspecified _ => 0,
    };
    tabCtl.index = initialIndex;
    return Scaffold(
        appBar: TabBar(controller: tabCtl, tabs: const [
          Tab(icon: Icon(Icons.line_axis)),
          Tab(icon: Icon(Icons.bar_chart)),
          Tab(icon: Icon(Icons.pie_chart)),
        ]),
        body: TabBarView(
          controller: tabCtl,
          children: [
            accumulationChartTab,
            subtotalChartTab,
            pieChartTab,
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
  List<Widget> section(Object data);
  Future data();

  /// return null when applying is successful
  /// return error message when applying is failed
  String? applyScheme();

  Widget sectionTitle(String value) {
    return Center(
        child: Text(value, style: Theme.of(context).textTheme.displaySmall));
  }

  Widget sectorTitle(String value) {
    return Center(
        child: Text(value, style: Theme.of(context).textTheme.headlineMedium));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: ChartConfigureWindow.widthOfHorizontalPadding),
        child: FutureBuilder(
            future: data(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(
                    shrinkWrap: true, children: section(snapshot.data!));
              }
              if (snapshot.hasError) {
                return const Center(child: Text('Error'));
              }
              return const Center(child: CircularProgressIndicator());
            }));
  }
}

class _AccumulationChartSection extends StatefulWidget {
  final skt.AccumulationChartSection skeleton;
  const _AccumulationChartSection(this.skeleton, {super.key});

  @override
  State<_AccumulationChartSection> createState() =>
      _AccumulationChartSectionState();
}

class _AccumulationChartSectionState
    extends _SectionPreState<_AccumulationChartSection> {
  skt.AccumulationChartScheme? currentScheme;
  @override
  Future<(skt.AccumulationChartScheme, List<dto.Category>, List<dto.Currency>)>
      data() async {
    return (
      await widget.skeleton.getInitialScheme(),
      await widget.skeleton.getCategoryOptions(),
      await widget.skeleton.getCurrencyOptions()
    );
  }

  @override
  String? applyScheme() {
    if (currentScheme == null) return "It is not initialized yet. Try again.";
    if (!currentScheme!.isAllCategoriesIncluded &&
        currentScheme!.categories.isEmpty) {
      return "Select at least one category.";
    }
    widget.skeleton.applyScheme(
      currentScheme!.currency.id,
      currentScheme!.analysisRange,
      currentScheme!.viewportRange,
      currentScheme!.categories.map((cat) => cat.id).toList(),
      currentScheme!.isAllCategoriesIncluded,
      currentScheme!.intervalInDays,
    );
    return null;
  }

  @override
  List<Widget> section(
      covariant (
        skt.AccumulationChartScheme,
        List<dto.Category>,
        List<dto.Currency>
      ) data) {
    final initialScheme = data.$1;
    currentScheme ??= initialScheme;
    final categories = data.$2;
    final currencies = data.$3;
    return [
      sectionTitle('Accumulation Chart'),
      sectorMargin,
      sectorTitle('Category'),
      MultiSelector<dto.Category>.fromTuple(
        items: categories.map((category) => (
              category.name,
              category,
              currentScheme!.categories.contains(category)
            )),
        onChanged: (selection, isAll) {
          currentScheme =
              currentScheme!.copyWith(categories: isAll ? [] : selection);
        },
        initiallyAllSelected: currentScheme!.categories.isEmpty,
      ),
      sectorMargin,
      sectorTitle('Currency'),
      SingleSelector<dto.Currency>.fromTuple(
          initialIndex: currencies.indexOf(currentScheme!.currency),
          items: currencies.map((currency) => (currency.symbol, currency)),
          onChanged: (selection) {
            currentScheme = currentScheme!.copyWith(currency: selection);
          }),
      sectorMargin,
      sectorTitle('Analysis Range'),
      OpenPeriodPicker(
          initial: currentScheme!.analysisRange,
          onChanged: (range) {
            currentScheme = currentScheme!.copyWith(analysisRange: range);
          }),
      sectorMargin,
      sectorTitle('Viewport Range'),
      ClosedPeriodPicker(
          initial: currentScheme!.viewportRange,
          onChanged: (range) {
            currentScheme = currentScheme!.copyWith(viewportRange: range);
          }),
      sectorMargin,
      sectorTitle('Interval of accumulation (days)'),
      NumberPicker(
          initial: currentScheme!.intervalInDays,
          min: 1,
          max: 365 * 200, // virtually unlimited
          steps: const [1, 7],
          onChanged: (value) {
            currentScheme = currentScheme!.copyWith(intervalInDays: value);
          })
    ];
  }

  @override
  void dispose() {
    widget.skeleton.dispose();
    super.dispose();
  }
}

class _SubtotalChartSection extends StatefulWidget {
  final skt.SubtotalChartSection skeleton;
  const _SubtotalChartSection(this.skeleton, {super.key});

  @override
  State<_SubtotalChartSection> createState() => _SubtotalChartSectionState();
}

class _SubtotalChartSectionState
    extends _SectionPreState<_SubtotalChartSection> {
  skt.SubtotalChartScheme? currentScheme;

  @override
  Future<(skt.SubtotalChartScheme, List<dto.Category>, List<dto.Currency>)>
      data() async {
    return (
      await widget.skeleton.getInitialScheme(),
      await widget.skeleton.getCategoryOptions(),
      await widget.skeleton.getCurrencyOptions()
    );
  }

  @override
  String? applyScheme() {
    if (currentScheme == null) return 'It is not initialized yet. Try again.';
    if (!currentScheme!.isAllCategoriesIncluded &&
        currentScheme!.categories.isEmpty) {
      return 'Select at least one category.';
    }
    widget.skeleton.applyScheme(
      currentScheme!.categories.map((cat) => cat.id).toList(),
      currentScheme!.isAllCategoriesIncluded,
      currentScheme!.currency.id,
      currentScheme!.viewportRange,
      currentScheme!.intervalInDays,
    );
    return null;
  }

  @override
  List<Widget> section(
      covariant (
        skt.SubtotalChartScheme,
        List<dto.Category>,
        List<dto.Currency>
      ) data) {
    final initialScheme = data.$1;
    currentScheme ??= initialScheme;
    final categories = data.$2;
    final currencies = data.$3;
    return [
      sectionTitle('Subtotal Chart'),
      sectorMargin,
      sectorTitle('Category'),
      MultiSelector<dto.Category>.fromTuple(
          items: categories.map((category) => (
                category.name,
                category,
                currentScheme!.categories.contains(category)
              )),
          onChanged: (selection, isAll) {
            currentScheme = currentScheme!.copyWith(
                categories: selection, isAllCategoriesIncluded: isAll);
          },
          initiallyAllSelected: currentScheme!.categories.isEmpty),
      sectorMargin,
      sectorTitle('Currency'),
      SingleSelector<dto.Currency>.fromTuple(
          initialIndex: currencies.indexOf(currentScheme!.currency),
          items: currencies.map((currency) => (currency.symbol, currency)),
          onChanged: (selection) {
            currentScheme = currentScheme!.copyWith(currency: selection);
          }),
      sectorMargin,
      sectorTitle('Viewport Range'),
      ClosedPeriodPicker(
          initial: currentScheme!.viewportRange,
          onChanged: (range) {
            currentScheme = currentScheme!.copyWith(viewportRange: range);
          }),
      sectorMargin,
      sectorTitle('Range of subtotal (days)'),
      NumberPicker(
          initial: currentScheme!.intervalInDays,
          min: 1,
          max: 365 * 200, // virtually unlimited
          steps: const [1, 7],
          onChanged: (value) {
            currentScheme = currentScheme!.copyWith(intervalInDays: value);
          })
    ];
  }

  @override
  void dispose() {
    widget.skeleton.dispose();
    super.dispose();
  }
}

class _PieChartSection extends StatefulWidget {
  final skt.PieChartSection skeleton;
  const _PieChartSection(this.skeleton, {super.key});

  @override
  State<_PieChartSection> createState() => _PieChartSectionState();
}

class _PieChartSectionState extends _SectionPreState<_PieChartSection> {
  skt.PieChartScheme? currentScheme;

  @override
  Future<(skt.PieChartScheme, List<dto.Category>, List<dto.Currency>)>
      data() async {
    return (
      await widget.skeleton.getInitialScheme(),
      await widget.skeleton.getCategoryOptions(),
      await widget.skeleton.getCurrencyOptions()
    );
  }

  @override
  String? applyScheme() {
    if (currentScheme == null) return 'It is not initialized yet. Try again.';
    if (!currentScheme!.isAllCategoriesIncluded &&
        currentScheme!.categories.isEmpty) {
      return 'Select at least one category.';
    }
    widget.skeleton.applyScheme(
      currentScheme!.currency.id,
      currentScheme!.analysisRange,
      currentScheme!.categories.map((cat) => cat.id).toList(),
      currentScheme!.isAllCategoriesIncluded,
    );
    return null;
  }

  @override
  List<Widget> section(
      covariant (
        skt.PieChartScheme,
        List<dto.Category>,
        List<dto.Currency>
      ) data) {
    final initialScheme = data.$1;
    currentScheme ??= initialScheme;
    final categories = data.$2;
    final currencies = data.$3;
    return [
      sectionTitle('Pie Chart'),
      sectorMargin,
      sectorTitle('Category'),
      MultiSelector<dto.Category>.fromTuple(
          items: categories.map((category) => (
                category.name,
                category,
                currentScheme!.categories.contains(category)
              )),
          onChanged: (selection, isAll) {
            currentScheme = currentScheme!.copyWith(
                categories: selection, isAllCategoriesIncluded: isAll);
          },
          initiallyAllSelected: currentScheme!.categories.isEmpty),
      sectorMargin,
      sectorTitle('Currency'),
      SingleSelector<dto.Currency>.fromTuple(
          initialIndex: currencies.indexOf(currentScheme!.currency),
          items: currencies.map((currency) => (currency.symbol, currency)),
          onChanged: (selection) {
            currentScheme = currentScheme!.copyWith(currency: selection);
          }),
      sectorMargin,
      sectorTitle('Analysis Range'),
      OpenPeriodPicker(
          initial: currentScheme!.analysisRange,
          onChanged: (range) {
            currentScheme = currentScheme!.copyWith(analysisRange: range);
          }),
    ];
  }

  @override
  void dispose() {
    widget.skeleton.dispose();
    super.dispose();
  }
}
