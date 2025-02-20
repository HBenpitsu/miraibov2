import 'package:flutter/material.dart';
import 'package:miraibo/view/shared/components/form_components/shared_constants.dart';
import 'package:miraibo/view/shared/components/valed_container.dart';

// <DayOfWeekSelector>
/// DayOfWeekSelector is a widget to select some days of the week
class DayOfWeekSelector extends StatefulWidget {
  /// a list of bools which represents the initial selection of each day
  /// the first element (index=0) represents Sunday, the second Monday, and so on
  final List<bool> initial;
  static const dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  static const minimumSpacer = 2.0;
  static const maximumSpacer = 10.0;
  static const buttonWidth = 55.0;

  /// the callback function to be called when the selection is changed
  /// the argument is a list of bools which represents the selection of each day
  /// the first element (index=0) represents Sunday, the second Monday, and so on
  final void Function(List<bool>) onChanged;
  const DayOfWeekSelector(
      {required this.initial, required this.onChanged, super.key});

  /// the callback function to be called when the selection is changed
  /// the argument is a list of bools which represents the selection of each day
  /// the first element (index=0) represents Sunday, the second Monday, and so on
  factory DayOfWeekSelector.fromDayNames({
    bool sunday = false,
    bool monday = false,
    bool tuesday = false,
    bool wednesday = false,
    bool thursday = false,
    bool friday = false,
    bool saturday = false,
    required void Function(List<bool>) onChanged,
  }) {
    return DayOfWeekSelector(initial: [
      sunday,
      monday,
      tuesday,
      wednesday,
      thursday,
      friday,
      saturday
    ], onChanged: onChanged);
  }

  /// the callback function to be called when the selection is changed
  /// the argument is a list of bools which represents the selection of each day
  /// the first element (index=0) represents Sunday, the second Monday, and so on
  factory DayOfWeekSelector.fromIntList(List<int> list,
      {required void Function(List<bool>) onChanged}) {
    final initial = List<bool>.filled(7, false);
    for (final day in list) {
      initial[day % 7] = true;
    }
    return DayOfWeekSelector(initial: initial, onChanged: onChanged);
  }

  @override
  State<DayOfWeekSelector> createState() => _DayOfWeekSelectorState();
}

class _DayOfWeekSelectorState extends State<DayOfWeekSelector> {
  late List<bool> current;

  @override
  void initState() {
    super.initState();
    current = widget.initial;
  }

  Widget buildContent(BuildContext context, BoxConstraints constraints) {
    final screenWidth = constraints.maxWidth - 2 * formChipPadding;
    final residure = screenWidth - _DayChip.width * 7;
    final padding = (residure / 6).clamp(
        DayOfWeekSelector.minimumSpacer, DayOfWeekSelector.maximumSpacer);
    final chips = [
      for (var i = 0; i < 7; i++) ...[
        _DayChip(
            day: i,
            label: DayOfWeekSelector.dayNames[i],
            initiallySelected: current[i],
            onSelected: select,
            onUnselected: unselect),
        SizedBox(width: padding) // spacer
      ]
    ];
    chips.removeLast(); // last spacer is not needed
    final mainContent = Row(children: chips);

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: formChipPadding),
        child: Center(
            child: ScrollableLine(
          valeColor: Theme.of(context).colorScheme.surface,
          valeSize: 10,
          child: mainContent,
        )));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: buildContent);
  }

  void select(int day) {
    setState(() {
      current[day] = true;
    });
    widget.onChanged(current);
  }

  void unselect(int day) {
    setState(() {
      current[day] = false;
    });
    widget.onChanged(current);
  }
}

class _DayChip extends StatefulWidget {
  final int day;
  final String label;
  final bool initiallySelected;
  final void Function(int) onSelected;
  final void Function(int) onUnselected;
  static const width = DayOfWeekSelector.buttonWidth;

  const _DayChip(
      {required this.day,
      required this.label,
      required this.initiallySelected,
      required this.onSelected,
      required this.onUnselected});

  @override
  State<_DayChip> createState() => _DayChipState();
}

class _DayChipState extends State<_DayChip> {
  late bool isSelected;

  @override
  void initState() {
    super.initState();
    isSelected = widget.initiallySelected;
  }

  void toggleSelection() {
    if (isSelected) {
      setState(() {
        isSelected = false;
      });
      widget.onUnselected(widget.day);
    } else {
      setState(() {
        isSelected = true;
      });
      widget.onSelected(widget.day);
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = TextButton.styleFrom(
        backgroundColor: isSelected
            ? Theme.of(context).colorScheme.primaryContainer
            : Theme.of(context).colorScheme.surfaceContainer,
        minimumSize: const Size(_DayChip.width, formChipHeight));
    final label = Text(widget.label);
    return TextButton(onPressed: toggleSelection, style: style, child: label);
  }
}
// </DayOfWeekSelector>
