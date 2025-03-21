import 'dart:async';
import 'dart:math' show min;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:miraibo/dto/dto.dart';
import 'package:miraibo/skeleton/planning_page/planning_page.dart' as skt;
import 'package:miraibo/view/planning_page/bidirectional_infinite_list.dart';
import 'package:miraibo/view/shared/constants.dart';
import 'package:miraibo/shared/enumeration.dart';

/// MonthlyScreen has infinite list of MonthlyCalendar widgets
/// Main function of MonthlyScreen is to show a list of MonthlyCalendar widgets
class MonthlyScreen extends StatefulWidget {
  final skt.MonthlyScreen skeleton;
  final void Function(skt.DailyScreen) navigateToDailyScreen;
  static const scrollDuration = Duration(milliseconds: 500);
  const MonthlyScreen(this.skeleton,
      {required this.navigateToDailyScreen, super.key});

  @override
  State<MonthlyScreen> createState() => _MonthlyScreenState();
}

class _MonthlyScreenState extends State<MonthlyScreen> {
  final ScrollController scrollController = ScrollController();
  bool currentEventFetchingAllowance = true;
  final StreamController<bool> eventFetchingAllowanceNotifier =
      StreamController<bool>.broadcast();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: BiInifiniteList(
          controller: scrollController,
          itemBuilder: (index) {
            final calenderData = widget.skeleton.getCalender(index);
            return Calender(calenderData, onTap: (date) {
              widget.navigateToDailyScreen(widget.skeleton
                  .navigateToDailyScreen(date.year, date.month, date.day));
            },
                initialAllowance: currentEventFetchingAllowance,
                eventFetchingAllowanceNotifier: eventFetchingAllowanceNotifier,
                key: ValueKey(index));
          }),
      bottomNavigationBar: SizedBox(
          height: bottomNavigationBarHeight,
          child: Row(
            children: [
              const Spacer(),
              IconButton(
                onPressed: () async {
                  currentEventFetchingAllowance = false;
                  eventFetchingAllowanceNotifier.add(false);
                  await scrollController.animateTo(
                      scrollController.position.pixels - screenHeight * 12,
                      duration: MonthlyScreen.scrollDuration,
                      curve: Curves.easeOut);
                  currentEventFetchingAllowance = true;
                  eventFetchingAllowanceNotifier.add(true);
                },
                icon: const Icon(Icons.arrow_upward),
              ),
              const Spacer(),
              IconButton(
                onPressed: () async {
                  currentEventFetchingAllowance = false;
                  eventFetchingAllowanceNotifier.add(false);
                  await scrollController.animateTo(0,
                      duration: MonthlyScreen.scrollDuration,
                      curve: Curves.easeOut);
                  currentEventFetchingAllowance = true;
                  eventFetchingAllowanceNotifier.add(true);
                },
                icon: const Icon(Icons.autorenew),
              ),
              const Spacer(),
              IconButton(
                onPressed: () async {
                  currentEventFetchingAllowance = false;
                  eventFetchingAllowanceNotifier.add(false);
                  scrollController.animateTo(
                      scrollController.position.pixels + screenHeight * 12,
                      duration: MonthlyScreen.scrollDuration,
                      curve: Curves.easeOut);
                  currentEventFetchingAllowance = true;
                  eventFetchingAllowanceNotifier.add(true);
                },
                icon: const Icon(Icons.arrow_downward),
              ),
              const Spacer(),
            ],
          )),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    widget.skeleton.dispose();
    super.dispose();
  }
}

class Calender extends StatefulWidget {
  final skt.Calender viewModel;

  /// onTap is called when a date is tapped
  /// the argument is the date that is tapped
  final void Function(Date) onTap;
  final bool initialAllowance;
  final StreamController<bool> eventFetchingAllowanceNotifier;
  const Calender(this.viewModel,
      {required this.onTap,
      required this.initialAllowance,
      required this.eventFetchingAllowanceNotifier,
      super.key});
  static const double maxWidth = 350;

  @override
  State<Calender> createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  late bool eventFetchingAllowed;
  late StreamSubscription<bool> eventFetchingAllowanceSubscription;
  @override
  void initState() {
    super.initState();
    eventFetchingAllowed = widget.initialAllowance;
    eventFetchingAllowanceSubscription =
        widget.eventFetchingAllowanceNotifier.stream.listen((event) {
      eventFetchingAllowed = event;
      if (!mounted || !eventFetchingAllowed) return;
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    eventFetchingAllowanceSubscription.cancel();
  }

  double width(BuildContext context) =>
      min(Calender.maxWidth, MediaQuery.of(context).size.width);
  double sizeOfCell(BuildContext context) => width(context) / 7;

  @override
  Widget build(BuildContext context) {
    return Column(children: [label(context), calenderBox(context)]);
  }

  Text label(BuildContext context) {
    return Text(
      '${widget.viewModel.year} - ${widget.viewModel.month}',
      style: Theme.of(context).textTheme.headlineLarge,
    );
  }

  Future<List<EventExistence>> events() async {
    if (eventFetchingAllowed) {
      return await widget.viewModel.events();
    } else {
      return List.filled(widget.viewModel.daysInMonth, EventExistence.none);
    }
  }

  SizedBox calenderBox(BuildContext context) {
    final loadingEvents = FutureBuilder(
        future: events(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            Logger().e(snapshot.error);
            return const Center(child: Text('Error: failed to load events'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return calender(context, snapshot.data!);
        });
    return SizedBox(
        width: width(context),
        height: sizeOfCell(context) * widget.viewModel.numberOfRow,
        child: eventFetchingAllowed ? loadingEvents : Container());
  }

  Widget calender(BuildContext context, List<EventExistence> events) {
    // to wrap the onTap event with GestureDetector, this place holder is needed.
    Date? dateToGo;
    // CustomPaint is used to draw a calender
    // this is the most important part of this method
    // using CustomPaint is much more efficient than using a lot of widgets
    final paint = CustomPaint(
      painter: CalenderPainter(
          cellSize: sizeOfCell(context),
          colorScheme: Theme.of(context).colorScheme,
          firstDayOfWeek: widget.viewModel.firstDayOfWeek,
          events: events,
          onTap: (day) {
            dateToGo = Date(widget.viewModel.year, widget.viewModel.month, day);
          }),
    );
    // Because bere hitTest of CustomPaint (onTap of CalenderPainter) is to sensitive,
    // tap detection is wrapped by GestureDetector.
    // without this, it so stressful to scroll the screen.
    return GestureDetector(
      child: paint,
      onTap: () {
        if (dateToGo != null) {
          widget.onTap(dateToGo!);
        }
      },
    );
  }
}

class CalenderPainter extends CustomPainter {
  final double cellSize;
  final int firstDayOfWeek;
  final ColorScheme colorScheme;
  final List<EventExistence> events;

  static const double cellMargin = 2;

  /// onTap is called when a cell is tapped
  /// corresponding date is passed as an argument
  /// that means it is always more than or equal to 1
  /// watch out that is not the index of the list
  final void Function(int) onTap;
  CalenderPainter({
    required this.cellSize,
    required this.colorScheme,
    required this.firstDayOfWeek,
    required this.events,
    required this.onTap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < events.length; i++) {
      drawCellOn(i + firstDayOfWeek, i + 1, canvas, events[i]);
    }
  }

  void drawCellOn(int index, int day, Canvas canvas, EventExistence kind) {
    // <calculate values to draw a cell>
    final int column = index % 7;
    final int row = index ~/ 7;
    final double x = column * cellSize;
    final double y = row * cellSize;

    // </calculate values to draw a cell>
    // <draw>
    // draw a circle
    final paint = calcPaint(kind);
    final radius = cellSize / 2 - cellMargin;
    final toTheCenter = cellSize / 2;
    canvas.drawCircle(Offset(x + toTheCenter, y + toTheCenter), radius, paint);

    // put text in the center of the cell
    final paragraph = calcLabel(kind, day);
    final heightResidure = cellSize - paragraph.height;
    final xShift = (cellSize - paragraph.width);
    canvas.drawParagraph(paragraph, Offset(x - xShift, y + heightResidure / 2));
    // </draw>
  }

  Paint calcPaint(EventExistence kind) {
    switch (kind) {
      case EventExistence.none:
        return Paint()
          ..color = colorScheme.surfaceContainer
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0;
      case EventExistence.trivial:
        return Paint()
          ..color = colorScheme.secondaryContainer
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;
      case EventExistence.important:
        return Paint()
          ..color = colorScheme.primaryContainer
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;
    }
  }

  ui.Paragraph calcLabel(EventExistence kind, int day) {
    final builder = ui.ParagraphBuilder(ui.ParagraphStyle(
        textAlign: TextAlign.center,
        fontSize: cellSize * 0.62,
        fontWeight: ui.FontWeight.w300));
    builder.pushStyle(ui.TextStyle(textBaseline: ui.TextBaseline.ideographic));
    switch (kind) {
      case EventExistence.none:
        builder.pushStyle(ui.TextStyle(color: colorScheme.onSurface));
      case EventExistence.trivial:
        builder.pushStyle(ui.TextStyle(color: colorScheme.onSurface));
      case EventExistence.important:
        builder.pushStyle(ui.TextStyle(color: colorScheme.primary));
    }
    builder.addText(day.toString());
    final paragraph = builder.build();
    paragraph.layout(ui.ParagraphConstraints(width: cellSize));
    return paragraph;
  }

  @override
  bool shouldRepaint(CalenderPainter oldDelegate) {
    final noChange = oldDelegate.cellSize == cellSize &&
        oldDelegate.firstDayOfWeek == firstDayOfWeek &&
        oldDelegate.events == events;
    return !noChange;
  }

  @override
  bool? hitTest(Offset position) {
    final int column = position.dx ~/ cellSize;
    final int row = position.dy ~/ cellSize;
    final int index = row * 7 + column;
    if (index < firstDayOfWeek || index >= firstDayOfWeek + events.length) {
      return null;
    }
    onTap(index - firstDayOfWeek + 1);
    return true;
  }
}
