import 'package:flutter/material.dart';
import 'package:miraibo/dto/dto.dart' as dto;
import 'package:miraibo/view/form_components/shared_constants.dart';

// <DatePicker>
/// A button to call the date picker dialog
class DatePicker extends StatefulWidget {
  final dto.Date initial;
  final void Function(dto.Date) onChanged;
  const DatePicker({required this.initial, required this.onChanged, super.key});

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  late dto.Date current;
  @override
  void initState() {
    super.initState();
    current = widget.initial;
  }

  @override
  Widget build(BuildContext context) {
    final label = Text('${current.year}-${current.month}-${current.day}');
    final style = TextButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        minimumSize: const Size.fromHeight(formChipHeight));
    final mainContent =
        TextButton(onPressed: pickupDate, style: style, child: label);
    return Padding(
        padding: const EdgeInsets.all(formChipPadding), child: mainContent);
  }

  void pickupDate() {
    final selected = DateTime(current.year, current.month, current.day);
    // There is no specific reason why the firstDate and lastDate are set to
    // 20 years before and 200 years after the [selectedDate]
    // I just think it is enough for the user to select the date
    final firstDate =
        DateTime(selected.year - 20, selected.month, selected.day);
    final lastDate =
        DateTime(selected.year + 200, selected.month, selected.day);
    showDatePicker(
            context: context,
            initialDate: selected,
            firstDate: firstDate,
            lastDate: lastDate)
        .then(
      (value) {
        if (value == null) return;
        setState(() {
          current = dto.Date(value.year, value.month, value.day);
          widget.onChanged(current);
        });
      },
    );
  }
}
// </DatePicker>
