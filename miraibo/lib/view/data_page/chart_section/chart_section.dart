import 'dart:async';
import 'package:flutter/material.dart';
import 'package:miraibo/skeleton/data_page/data_page.dart' as skt;
import 'package:miraibo/view/data_page/shared.dart';
import 'package:miraibo/view/data_page/chart_configure_window.dart';
import 'package:miraibo/view/data_page/chart_section/accumulation_chart.dart';
import 'package:miraibo/view/data_page/chart_section/pie_chart.dart';
import 'package:miraibo/view/data_page/chart_section/subtotal_chart.dart';

class ChartSection extends StatelessWidget {
  final skt.DataPage skeleton;
  const ChartSection(this.skeleton, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _Chart(skeleton),
        _Controller(skeleton),
      ],
    );
  }
}

class _Chart extends StatefulWidget {
  final skt.DataPage skeleton;
  const _Chart(this.skeleton);

  @override
  State<StatefulWidget> createState() => _ChartState();
}

class _ChartState extends State<_Chart> {
  late skt.Chart chart;
  late final StreamSubscription<skt.Chart> chartSubscription;

  @override
  void initState() {
    super.initState();
    chart = const skt.ChartUnspecified();
    chartSubscription = widget.skeleton.getChart().listen((newChart) {
      if (!mounted) return;
      setState(() {
        chart = newChart;
      });
    });
  }

  Widget content(BuildContext context, BoxConstraints constraints) {
    return Center(
      child: switch (chart) {
        skt.AccumulationChart chart => AccumulationChart(chart),
        skt.SubtotalChart chart => SubtotalChart(chart),
        skt.PieChart chart => PieChart(chart),
        skt.ChartUnspecified _ => SizedBox(
            height: chartHeight,
            width: constraints.maxWidth,
            child: Center(child: Text('Chart Unconfigured'))),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: content);
  }

  @override
  void dispose() {
    chartSubscription.cancel();
    super.dispose();
  }
}

class _Controller extends StatelessWidget {
  final skt.DataPage skeleton;
  const _Controller(this.skeleton);

  @override
  Widget build(BuildContext context) {
    final configureButton = TextButton(
        onPressed: () {
          openChartConfigureWindow(
              context, skeleton.openChartConfigurationWindow());
        },
        style: TextButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        ),
        child: const Text('Configure Chart'));
    return Center(
        child: Row(
      children: [
        const Spacer(),
        configureButton,
        const Spacer(),
      ],
    ));
  }
}
