import 'package:flutter/material.dart';
import 'package:miraibo/dto/dto.dart' as dto;
import 'package:miraibo/view/shared/components/form_components/shared_constants.dart';

// <OpenPeriodPicker>
/// A OpenPeriodSelector which combines some widgets to select a period
/// begging and ending can be null
class OpenPeriodPicker extends StatefulWidget {
  final dto.OpenPeriod initial;
  final void Function(dto.OpenPeriod) onChanged;
  static const edgeButtonFlex = 1;
  static const pickUpSectionFlex = 3;
  static const borderRadius = Radius.circular(formChipHeight / 2);
  const OpenPeriodPicker(
      {required this.initial, required this.onChanged, super.key});

  @override
  State<OpenPeriodPicker> createState() => _OpenPeriodPickerState();
}

class _OpenPeriodPickerState extends State<OpenPeriodPicker> {
  late dto.Date begins;
  late bool isBeginningOpen;
  late dto.Date ends;
  late bool isEndingOpen;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final today = now.cutOffTime();
    begins = widget.initial.begins ?? today;
    isBeginningOpen = widget.initial.begins == null;
    ends = widget.initial.ends ?? today;
    isEndingOpen = widget.initial.ends == null;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final mainContent = Row(
      children: [
        Expanded(
            flex: OpenPeriodPicker.edgeButtonFlex,
            child: leftEdgeButton(colorScheme)),
        Expanded(
            flex: OpenPeriodPicker.pickUpSectionFlex, child: pickUpSection()),
        Expanded(
            flex: OpenPeriodPicker.edgeButtonFlex,
            child: rightEdgeButton(colorScheme))
      ],
    );
    return Padding(
        padding: const EdgeInsets.all(formChipPadding), child: mainContent);
  }

  void apply() {
    switch ((isBeginningOpen, isEndingOpen)) {
      case (true, true):
        widget.onChanged(const dto.OpenPeriod(begins: null, ends: null));
      case (true, false):
        widget.onChanged(dto.OpenPeriod(begins: null, ends: ends));
      case (false, true):
        widget.onChanged(dto.OpenPeriod(begins: begins, ends: null));
      case (false, false):
        widget.onChanged(dto.OpenPeriod(begins: begins, ends: ends));
    }
  }

  TextButton leftEdgeButton(ColorScheme colorScheme) {
    final style = TextButton.styleFrom(
        backgroundColor: isBeginningOpen
            ? colorScheme.primaryContainer
            : colorScheme.surfaceContainer,
        minimumSize: const Size.fromHeight(formChipHeight),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.horizontal(
                right: Radius.zero, left: OpenPeriodPicker.borderRadius)));
    return TextButton(
        onPressed: () {
          setState(() {
            isBeginningOpen = !isBeginningOpen;
            apply();
          });
        },
        style: style,
        child: const Text(''));
  }

  TextButton rightEdgeButton(ColorScheme colorScheme) {
    final style = TextButton.styleFrom(
        backgroundColor: isEndingOpen
            ? colorScheme.primaryContainer
            : colorScheme.surfaceContainer,
        minimumSize: const Size.fromHeight(formChipHeight),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.horizontal(
                right: OpenPeriodPicker.borderRadius, left: Radius.zero)));
    return TextButton(
        onPressed: () {
          setState(() {
            isEndingOpen = !isEndingOpen;
            apply();
          });
        },
        style: style,
        child: const Text(''));
  }

  Widget pickUpSection() {
    final label = Text(this.label());
    final style = TextButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        minimumSize: const Size.fromHeight(formChipHeight),
        shape: const RoundedRectangleBorder());
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: formChipPadding),
        child: TextButton(onPressed: showSelector, style: style, child: label));
  }

  void showSelector() {
    switch ((isBeginningOpen, isEndingOpen)) {
      case (true, true):
        showSnackBar();
      case (true, false):
        showDataPickerForEnding();
      case (false, true):
        showDatePickerForBeginning();
      case (false, false):
        showPeriodPicker();
    }
  }

  String label() {
    switch ((isBeginningOpen, isEndingOpen)) {
      case (true, true):
        return 'all the time';
      case (true, false):
        return 'until ${ends.year}-${ends.month}-${ends.day}';
      case (false, true):
        return 'from ${begins.year}-${begins.month}-${begins.day}';
      case (false, false):
        return '${begins.year}-${begins.month}-${begins.day} to ${ends.year}-${ends.month}-${ends.day}';
    }
  }

  void showDatePickerForBeginning() {
    // There is no specific reason why the firstDate and lastDate are set to
    // 20 years before and 200 years after the [selectedDate]
    // I just think it is enough for the user to select the date
    final firstDate = DateTime(begins.year - 20, begins.month, begins.day);
    final lastDate = DateTime(begins.year + 200, begins.month, begins.day);
    showDatePicker(context: context, firstDate: firstDate, lastDate: lastDate)
        .then((value) {
      if (value == null) return;
      setState(() {
        begins = dto.Date(value.year, value.month, value.day);
        // keep the consistency of the period
        if (value.isAfter(ends.asDateTime())) {
          ends = begins;
        }
        apply();
      });
    });
  }

  void showDataPickerForEnding() {
    // There is no specific reason why the firstDate and lastDate are set to
    // 20 years before and 200 years after the [selectedDate]
    // I just think it is enough for the user to select the date
    final firstDate = DateTime(ends.year - 20, ends.month, ends.day);
    final lastDate = DateTime(ends.year + 200, ends.month, ends.day);
    showDatePicker(context: context, firstDate: firstDate, lastDate: lastDate)
        .then((value) {
      if (value == null) return;
      setState(() {
        ends = dto.Date(value.year, value.month, value.day);
        // keep the consistency of the period
        if (value.isBefore(begins.asDateTime())) {
          begins = ends;
        }
        apply();
      });
    });
  }

  void showPeriodPicker() {
    // There is no specific reason why the firstDate and lastDate are set to
    // 20 years before and 200 years after the [selectedDate]
    // I just think it is enough for the user to select the date
    final firstDate = DateTime(begins.year - 20, begins.month, begins.day);
    final lastDate = DateTime(ends.year + 200, ends.month, ends.day);
    showDateRangePicker(
            context: context,
            initialDateRange: DateTimeRange(
                start: begins.asDateTime(), end: ends.asDateTime()),
            firstDate: firstDate,
            lastDate: lastDate)
        .then((value) {
      if (value == null) return;
      setState(() {
        begins = value.start.cutOffTime();
        ends = value.end.cutOffTime();
        apply();
      });
    });
  }

  void showSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Wrap(children: [Text('Tap a side button first.')])));
  }
}

// </OpenPeriodPicker>

// <ClosedPeriodPicker>
/// A Button to call the date range picker dialog
/// The selected period is closed, which means the period is inclusive and both ends are specified
class ClosedPeriodPicker extends StatefulWidget {
  final dto.ClosedPeriod initial;
  final void Function(dto.ClosedPeriod) onChanged;
  const ClosedPeriodPicker(
      {required this.initial, required this.onChanged, super.key});

  @override
  State<ClosedPeriodPicker> createState() => _ClosedPeriodPickerState();
}

class _ClosedPeriodPickerState extends State<ClosedPeriodPicker> {
  late dto.ClosedPeriod current;

  @override
  void initState() {
    super.initState();
    current = widget.initial;
  }

  @override
  Widget build(BuildContext context) {
    final label = Text(
        '${current.begins.year}-${current.begins.month}-${current.begins.day}'
        ' to '
        '${current.ends.year}-${current.ends.month}-${current.ends.day}');
    final style = TextButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        minimumSize: const Size.fromHeight(formChipHeight));
    final mainContent =
        TextButton(onPressed: showPicker, style: style, child: label);
    return Padding(
        padding: const EdgeInsets.all(formChipPadding), child: mainContent);
  }

  void showPicker() {
    // There is no specific reason why the firstDate and lastDate are set to
    // 20 years before and 200 years after the [selected] period.
    // I just think it is enough for the user to select the period
    final firstDate = DateTime(
        current.begins.year - 20, current.begins.month, current.begins.day);
    final lastDate =
        DateTime(current.ends.year + 200, current.ends.month, current.ends.day);
    showDateRangePicker(
            context: context,
            initialDateRange: current.asDateTimeRange(),
            firstDate: firstDate,
            lastDate: lastDate)
        .then((value) {
      if (value == null) return;
      setState(() {
        current = value.cutOffTime();
        widget.onChanged(current);
      });
    });
  }
}
// </ClosedPeriodPicker>
