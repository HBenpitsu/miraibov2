import 'package:flutter/material.dart';
import 'package:miraibo/dto/dto.dart' as dto;
import 'package:miraibo/view/shared/components/form_components/fixed_value_presenter.dart';
import 'package:miraibo/view/shared/components/ticket_scheme_config_section.dart';

class ReceiptLogConfigSectionWithPresets extends StatefulWidget {
  final dto.ReceiptLogScheme initial;
  final List<dto.Category> categoryOptions;
  final List<dto.Currency> currencyOptions;
  final List<dto.ReceiptLogSchemePreset> presets;
  final void Function(dto.ReceiptLogScheme) onChanged;
  static const double presetMargin = 20;
  const ReceiptLogConfigSectionWithPresets(
      {required this.initial,
      required this.categoryOptions,
      required this.currencyOptions,
      required this.presets,
      required this.onChanged,
      super.key});
  @override
  State<ReceiptLogConfigSectionWithPresets> createState() =>
      _ReceiptLogConfigSectionWithPresetsState();
}

class _ReceiptLogConfigSectionWithPresetsState
    extends State<ReceiptLogConfigSectionWithPresets> {
  late dto.ReceiptLogScheme currentScheme;

  @override
  void initState() {
    super.initState();
    currentScheme = widget.initial;
  }

  Widget? preset(BuildContext context, int index) {
    if (index >= widget.presets.length) return null;
    final preset = widget.presets[index];
    final textStyle = Theme.of(context).textTheme.bodyLarge;
    final content = Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            FixedValuePresenter(preset.category.name),
            Text(
              preset.description,
              style: textStyle,
            ),
            const Divider(),
            Text(
              '${preset.price.amount} ${preset.price.currencySymbol}',
              style: textStyle,
            )
          ],
        ));
    final container = Material(
        child: Card(
            color: Theme.of(context).colorScheme.surfaceContainer,
            clipBehavior: Clip.antiAlias,
            child: InkWell(
                onTap: () {
                  setState(() {
                    currentScheme = dto.ReceiptLogScheme(
                        category: preset.category,
                        date: currentScheme.date,
                        price: preset.price,
                        description: preset.description,
                        confirmed: currentScheme.confirmed);
                    widget.onChanged(currentScheme);
                  });
                },
                child: content)));
    return Padding(padding: const EdgeInsets.all(10), child: container);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ReceiptLogConfigSection(
          initial: currentScheme,
          categoryOptions: widget.categoryOptions,
          currencyOptions: widget.currencyOptions,
          onChanged: widget.onChanged,
          key: ValueKey(currentScheme)),
      const SizedBox(height: ReceiptLogConfigSectionWithPresets.presetMargin),
      Text('Presets', style: Theme.of(context).textTheme.headlineMedium),
      ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: preset),
    ]);
  }
}
