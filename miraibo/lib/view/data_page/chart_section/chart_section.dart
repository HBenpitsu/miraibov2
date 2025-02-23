import 'dart:async';
import 'package:flutter/material.dart';
import 'package:miraibo/skeleton/data_page/data_page.dart' as skt;
import 'package:miraibo/view/data_page/shared.dart';
import 'package:miraibo/view/data_page/chart_configure_window.dart';
import 'package:miraibo/view/data_page/chart_section/accumulation_chart.dart';
import 'package:miraibo/view/data_page/chart_section/pie_chart.dart';
import 'package:miraibo/view/data_page/chart_section/subtotal_chart.dart';

class ChartSection extends StatefulWidget {
  final skt.DataPage skeleton;
  const ChartSection(this.skeleton, {super.key});

  @override
  State<ChartSection> createState() => _ChartSectionState();
}

class _ChartSectionState extends State<ChartSection> {
  late skt.Chart chart;
  late final StreamSubscription<skt.Chart> chartSubscription;

  @override
  void initState() {
    super.initState();
    chart = skt.ChartUnspecified();
    chartSubscription = widget.skeleton.getChart().listen((chart) {
      setState(() {
        this.chart = chart;
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
    final buttonStyle = TextButton.styleFrom(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
    );
    final controller = Center(
        child: Row(
      children: [
        const Spacer(),
        Expanded(
            child: TextButton(
                onPressed: () {
                  openChartConfigureWindow(
                      context, widget.skeleton.openChartConfigurationWindow());
                },
                style: buttonStyle,
                child: const Text('Configure Chart'))),
        const Spacer(),
      ],
    ));
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LayoutBuilder(builder: content),
        controller,
      ],
    );
  }

  @override
  void dispose() {
    chartSubscription.cancel();
    super.dispose();
  }
}
