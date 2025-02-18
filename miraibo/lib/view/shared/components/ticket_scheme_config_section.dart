import 'package:flutter/material.dart';
import 'package:miraibo/dto/dto.dart' as dto;
import 'package:miraibo/view/shared/components/form_components/form_components.dart';

const sectionMargine = SizedBox(height: 20);
const lineMargine = SizedBox(height: 10);

class ReceiptLogConfigSection extends StatefulWidget {
  final dto.ReceiptLogScheme initial;
  final List<dto.Category> categoryOptions;
  final List<dto.Currency> currencyOptions;
  final void Function(dto.ReceiptLogScheme) onChanged;
  const ReceiptLogConfigSection(
      {required this.initial,
      required this.categoryOptions,
      required this.currencyOptions,
      required this.onChanged,
      super.key});
  @override
  State<ReceiptLogConfigSection> createState() =>
      _ReceiptLogConfigSectionState();
}

class _ReceiptLogConfigSectionState extends State<ReceiptLogConfigSection> {
  late dto.ReceiptLogScheme _current;
  dto.ReceiptLogScheme get current => _current;
  set current(dto.ReceiptLogScheme value) {
    _current = value;
    widget.onChanged(value);
  }

  @override
  void initState() {
    super.initState();
    current = widget.initial;
  }

  Widget expands(Widget child) {
    return SizedBox(
      width: double.infinity,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(children: [
      Text('Receipt Log', style: textTheme.headlineLarge),
      sectionMargine,
      Text('Category', style: textTheme.headlineMedium),
      lineMargine,
      // Category
      expands(
        SingleSelector<int>.fromTaple(
            initialIndex: current.category.id,
            onChanged: (selected) {
              current =
                  current.copyWith(category: widget.categoryOptions[selected]);
            },
            items: widget.categoryOptions.map((e) => (e.name, e.id))),
      ),
      sectionMargine,
      Text('Description', style: textTheme.headlineMedium),
    ]);
  }
}
