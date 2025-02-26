import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart' as flc show PieChart;
import 'package:fl_chart/fl_chart.dart' hide PieChart;
import 'package:miraibo/skeleton/data_page/data_page.dart' as skt;
import 'package:miraibo/dto/dto.dart' as dto;
import 'package:miraibo/view/data_page/shared.dart';

class PieChart extends StatefulWidget {
  final skt.PieChart chart;
  const PieChart(this.chart, {super.key});

  @override
  State<PieChart> createState() => _PieChartState();
}

class _PieChartState extends State<PieChart> {
  static const double chipRadius = 100;
  static const double centerSpaceRadius = 70;
  List<PieChartSectionData>? data;
  dto.RatioValue? selected;

  Widget get chart {
    final colorScheme = Theme.of(context).colorScheme;
    final List<Color> backGroundcolors = [
      colorScheme.primaryContainer,
      colorScheme.secondaryContainer,
      colorScheme.tertiaryContainer,
    ];
    final List<Color> frontColors = [
      colorScheme.primary,
      colorScheme.secondary,
      colorScheme.tertiary,
    ];
    data = widget.chart.chips.indexed.map((param) {
      final index = param.$1;
      final chip = param.$2;
      return PieChartSectionData(
        color: backGroundcolors[index % backGroundcolors.length],
        value: chip.amount,
        showTitle: chip.ratio > 0.09,
        title: chip.categoryName,
        titleStyle: TextStyle(color: frontColors[index % frontColors.length]),
        radius: chipRadius,
      );
    }).toList(growable: false);
    final touchConfig = PieTouchData(
      touchCallback: (event, response) {
        setState(() {
          if (event is FlLongPressEnd ||
              response?.touchedSection?.touchedSectionIndex == null ||
              response!.touchedSection!.touchedSectionIndex >=
                  widget.chart.chips.length ||
              response.touchedSection!.touchedSectionIndex < 0) {
            selected = null;
            return;
          } else {
            selected = widget
                .chart.chips[response.touchedSection!.touchedSectionIndex];
          }
        });
      },
    );

    return flc.PieChart(
      PieChartData(
          centerSpaceRadius: centerSpaceRadius,
          // rotate chart so that the first section is at the top
          startDegreeOffset: -90,
          sectionsSpace: 1,
          sections: data,
          pieTouchData: touchConfig),
    );
  }

  Widget get centralLabel {
    final text = Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            widget.chart.gross.toStringAsFixed(2),
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 20,
            ),
          ),
          Text(
            widget.chart.currencySymbol,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 16,
            ),
          )
        ]);
    return SizedBox(
        height: chartHeight,
        child: Center(
            child: SizedBox.square(
                dimension: centerSpaceRadius * 1.2, child: text)));
  }

  static const double categoryDetailHeight = 50;

  Widget get categoryDetail {
    return SizedBox(
      height: categoryDetailHeight,
      child: Center(
        child: Wrap(alignment: WrapAlignment.center, children: [
          Text(
            selected == null ? '' : '${selected!.categoryName}:',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            selected == null ? '' : '${selected!.amount} ',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            selected == null
                ? ''
                : '(${(selected!.ratio * 100).toStringAsFixed(1)}%)',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ]),
      ),
    );
  }

  static const Widget explanation = Padding(
      padding: explanationPadding,
      child: Row(
        children: [
          Spacer(),
          Icon(Icons.touch_app),
          Text('Touch a section to see a detail'),
          Spacer(),
        ],
      ));

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final titleOfChart = Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.end,
        children: [
          Text('Pie Chart', style: textTheme.headlineMedium),
          const SizedBox(width: 5),
          Text('(${widget.chart.currencySymbol})', style: textTheme.bodyLarge),
        ]);
    final chart = SizedBox(height: chartHeight, child: this.chart);
    final chartWithCentralLabel = Stack(
      children: [
        chart,
        centralLabel,
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: categoryDetail,
        )
      ],
    );
    final analysisRange = Text(
        'Counted range: ${widget.chart.analysisRange.asString()}',
        style: textTheme.bodySmall);

    return Column(
      children: [
        titleOfChart,
        analysisRange,
        chartWithCentralLabel,
        explanation
      ],
    );
  }
}

extension DateStringify on dto.Date {
  String asString() {
    return '$year-$month-$day';
  }
}

extension OpenPeriodStringify on dto.OpenPeriod {
  String asString() {
    switch ((begins, ends)) {
      case (null, null):
        return 'Entire Period';
      case (null, dto.Date end):
        return 'Until ${end.asString()}';
      case (dto.Date begin, null):
        return 'From ${begin.asString()}';
      case (dto.Date begin, dto.Date end):
        return 'From ${begin.asString()} To ${end.asString()}';
    }
    throw Exception('Bad state');
  }
}
