import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:miraibo/dto/dto.dart' as dto;
import 'package:miraibo/skeleton/data_page/data_page.dart' as skt;
import 'package:miraibo/view/data_page/shared.dart';

class AccumulationChart extends StatefulWidget {
  final skt.AccumulationChart chart;
  const AccumulationChart(this.chart, {super.key});

  @override
  State<AccumulationChart> createState() => _AccumulationChartState();
}

class _AccumulationChartState extends State<AccumulationChart> {
  @override
  void initState() {
    super.initState();
    // this is a field for dragEventConsumer
    speedQueueForInertialAnimation = List.filled(sizeOfAnimationQueue, 0.0);
  }

  // <chart configuration>
  final TransformationController transformationController =
      TransformationController();
  final GlobalKey rendererKey = GlobalKey();

  /// maxX is set to the conut of bars for spots to avoid the right edge of the chart.
  /// but, avoiding the left edge shifts the x-axis by 1, so the maxX is also shifted by 1 additionally.
  double get maxX => widget.chart.maxXIndex + 1.0;
  Color get actualDataColor => Theme.of(context).colorScheme.primary;
  Color get predictionDataColor => Theme.of(context).colorScheme.tertiary;

  // <lines>
  LineChartBarData getActualLine() {
    return LineChartBarData(color: actualDataColor, spots: [
      for (var i = 0; i < widget.chart.bars.length; i++)
        if (i < widget.chart.todaysIndex)
          // shift x by 1 to avoid the left edge of the chart
          FlSpot(i.toDouble() + 1, widget.chart.bars[i].amount),
    ]);
  }

  LineChartBarData getPredictionLine() {
    return LineChartBarData(color: predictionDataColor, spots: [
      for (var i = 0; i < widget.chart.bars.length; i++)
        if (i >= widget.chart.todaysIndex)
          // shift x by 1 to avoid the left edge of the chart
          FlSpot(i.toDouble() + 1, widget.chart.bars[i].amount),
    ]);
  }

  LineChartBarData getAllSpotsLine() {
    return LineChartBarData(color: Colors.transparent, spots: [
      for (var i = 0; i < widget.chart.bars.length; i++)
        // shift x by 1 to avoid the left edge of the chart
        FlSpot(i.toDouble() + 1, widget.chart.bars[i].amount),
    ]);
  }
  // </lines>

  // <decorations>
  List<LineTooltipItem?> tooltipBuilder(
      List<LineBarSpot> spots, int indexOfAllSpotsLine) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return spots.map((spot) {
      // return null when the spot is not one of the allSpotsLine
      if (spot.barIndex != indexOfAllSpotsLine) {
        return null;
      }
      // spotIndex is shifted by 1.
      final dataIndex = spot.x.toInt() - 1;
      // do not show tooltip for the left edge and right edge (dummy spots)
      if (dataIndex < 0 || dataIndex >= widget.chart.bars.length) {
        return null;
      } else {
        final date = widget.chart.bars[dataIndex].date;
        final dateLabel = TextSpan(
            text: '\n(${date.year}-${date.month}-${date.day})',
            style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 12,
                fontWeight: FontWeight.bold));
        final dateLabelStyle = TextStyle(
            color: dataIndex < widget.chart.todaysIndex
                ? actualDataColor
                : predictionDataColor,
            fontWeight: FontWeight.bold);
        final amountLabel =
            widget.chart.bars[dataIndex].amount.toStringAsFixed(2) +
                widget.chart.currencySymbol;
        return LineTooltipItem(
          amountLabel,
          dateLabelStyle,
          children: [dateLabel],
        );
      }
    }).toList();
  }

  List<TouchedSpotIndicatorData?> touchedSpotIndicatorBuilder(
      LineChartBarData barData, List<int> spotIndexes) {
    return spotIndexes.map((spotIndex) {
      // if the spot is not one of the allSpotsLine, return null
      if (barData.color != Colors.transparent) {
        return null;
      }
      final spot = barData.spots[spotIndex];
      return TouchedSpotIndicatorData(
          FlLine(
            color: spot.x <= widget.chart.todaysIndex
                ? actualDataColor
                : predictionDataColor,
          ),
          FlDotData(show: true));
    }).toList();
  }

  LineTouchData getLineTouchConfiguration(int indexOfAllSpotsLine) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return LineTouchData(
        touchSpotThreshold: double.infinity,
        getTouchedSpotIndicator: touchedSpotIndicatorBuilder,
        touchTooltipData: LineTouchTooltipData(
          fitInsideHorizontally: true,
          fitInsideVertically: true,
          getTooltipColor: (touchedSpot) => colorScheme.surfaceContainer,
          getTooltipItems: (arg) => tooltipBuilder(arg, indexOfAllSpotsLine),
        ));
  }

  FlTitlesData get titleConfiguration {
    return FlTitlesData(
      topTitles: const AxisTitles(),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            // return empty widget for
            // - index out of range
            // - non-integer value
            if (value < 1 || value >= maxX || value.toInt() - value != 0) {
              return const SizedBox();
            }
            final dateIndex = (value - 1).toInt(); // see [get mainLine]
            final date = widget.chart.bars[dateIndex].date;
            return SideTitleWidget(
              meta: meta,
              child: Transform.rotate(
                  angle: -20 * 3.14 / 180, //rad
                  child: Text('${date.year}-${date.month}-${date.day}',
                      style: Theme.of(context).textTheme.bodySmall)),
            );
          },
        ),
      ),
    );
  }
  // </decorations>

  // <drag event imitation>
  void shiftChart(double dx) {
    // get rendered chart rect
    final renderer = rendererKey.currentContext!.findRenderObject();
    if (renderer == null) return;

    // based on the chart rect, calculate the translation
    final transformMatrix = transformationController.value.clone();
    // first, translate the matrix
    transformMatrix.leftTranslate(dx);
    // then validate the translation
    final hidenAreaRatio = (transformMatrix.getMaxScaleOnAxis() - 1);
    final hidenAreaWidth = hidenAreaRatio * renderer.paintBounds.width;
    final translation = transformMatrix.getTranslation();
    // 0: shows the left edge of the chart
    // -hidenAreaWidth: shows the right edge of the chart
    translation.x = translation.x.clamp(-hidenAreaWidth, 0);
    transformMatrix.setTranslation(translation);

    // apply the translation
    transformationController.value = transformMatrix;
  }

  // <fields for inertial animation>
  // animation is implemented in [dragEventConsumer]
  static const sizeOfAnimationQueue = 3;
  late final List<double> speedQueueForInertialAnimation;
  int _queueIndexForInertialAnimation = 0;
  Timer? inertialAnimation;

  /// is index of [speedQueueForInertialAnimation].
  int get queue => _queueIndexForInertialAnimation;
  set queue(int value) {
    _queueIndexForInertialAnimation = value % sizeOfAnimationQueue;
  }
  // </fields for inertial animation>

  /// Event consumer should 'emulate' the method of LineChart for handling drag event
  /// so that the chart can be dragged.
  /// Better solution does not emulate something, but I could not find the way.
  void horizontalDragEventConsumer(DragUpdateDetails details) {
    inertialAnimation?.cancel();
    inertialAnimation = null;

    // push to the queue
    speedQueueForInertialAnimation[queue] = details.delta.dx;
    queue++;

    // take the average of the queue
    // so that the motion is unsusceptible to the fluctuation of the speed
    double speed = 0.0;
    for (var i = 0; i < sizeOfAnimationQueue; i++) {
      speed += speedQueueForInertialAnimation[i];
    }
    speed /= sizeOfAnimationQueue;

    // shift the chart once for sure
    // otherwise, the motion is not smooth
    shiftChart(speed);

    // dispatch the inertial animation
    // inertialAnimation is memorized to cancel it when the user drag again.
    // otherwise, the motion will be acselerated too much.
    inertialAnimation =
        Timer.periodic(Duration(milliseconds: (1000 / 30).toInt()), (timer) {
      speed *= 0.9;
      shiftChart(speed);
      if (speed.abs() < 1) {
        timer.cancel();
      }
    });
  }

  // </drag event imitation>

  Widget get chart {
    final actualLine = getActualLine();
    final predictionLine = getPredictionLine();
    final allSpotsLine = getAllSpotsLine();
    final data = LineChartData(
        // <set viewport>
        minX: 0,
        maxX: maxX,
        minY: 0,
        maxY: widget.chart.yAxisExtent.toDouble() *
            1.2, // to make room for the tooltip
        // </set viewport>
        lineBarsData: [
          allSpotsLine,
          actualLine,
          predictionLine,
        ],
        lineTouchData: getLineTouchConfiguration(0), // index of allSpotsLine
        titlesData: titleConfiguration);
    // LineChart have not a priority to handle horizontal drag event
    // When the user drag horizontally, tab-switching is invoked.
    // However, it is inconvenient that the user cannnot drag the chart.
    //
    // To solve this problem, I added GestureDetector to consume the drag event
    // and prevent tab-switching.

    // return LineChart(data,
    //         chartRendererKey: rendererKey,
    //         transformationConfig: FlTransformationConfig(
    //             transformationController: transformationController,
    //             maxScale: widget.chart.maxScale,
    //             scaleAxis: FlScaleAxis.horizontal));
    return GestureDetector(
        onHorizontalDragUpdate: horizontalDragEventConsumer,
        child: LineChart(data,
            chartRendererKey: rendererKey,
            transformationConfig: FlTransformationConfig(
                transformationController: transformationController,
                maxScale: widget.chart.maxScale,
                scaleAxis: FlScaleAxis.horizontal)));
  }
  // </chart configuration>

  static const Widget operationExplanation = Padding(
      padding: explanationPadding,
      child: Column(
        children: [
          Row(children: [
            Icon(Icons.pinch),
            Icon(Icons.zoom_in),
            Text(': Pan/Pitch vertically to Zoom')
          ]),
          Row(children: [
            Icon(Icons.swipe),
            Icon(Icons.compare_arrows),
            Text(': Swipe horizontally to Shift')
          ]),
          Row(children: [
            Icon(Icons.touch_app),
            Icon(Icons.comment),
            Text(': Long tap/Drag to Show spot information')
          ])
        ],
      ));

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final titleOfChart = Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.end,
        children: [
          Text('Accumulation Chart', style: textTheme.headlineMedium),
          const SizedBox(width: 5),
          Text('(${widget.chart.currencySymbol})', style: textTheme.bodyLarge),
        ]);
    final countedCategories = Text(
        widget.chart.categoryNames.isEmpty
            ? 'All categories are counted'
            : widget.chart.categoryNames.join(', '),
        style: textTheme.bodySmall);
    final analysisRange = Text(
        'Counted range: ${widget.chart.analysisRange.asString()}',
        style: textTheme.bodySmall);
    return Column(children: [
      titleOfChart,
      countedCategories,
      analysisRange,
      SizedBox(height: chartHeight, child: chart),
      operationExplanation,
    ]);
  }

  @override
  void dispose() {
    inertialAnimation?.cancel();
    inertialAnimation = null;
    transformationController.dispose();
    super.dispose();
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
        return 'All';
      case (null, dto.Date end):
        return 'Until ${end.asString()}';
      case (dto.Date begin, null):
        return 'From ${begin.asString()}';
      case (dto.Date begin, dto.Date end):
        return 'From ${begin.asString()} to ${end.asString()}';
    }
    throw Exception('Bad state');
  }
}
