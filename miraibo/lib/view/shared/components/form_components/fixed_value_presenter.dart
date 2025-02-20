import 'package:flutter/material.dart';
import 'package:miraibo/view/shared/components/form_components/shared_constants.dart';

class FixedValuePresenter extends StatelessWidget {
  final String value;

  const FixedValuePresenter(this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final style = BoxDecoration(
        border: Border.all(
          color: colorScheme.primary,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(formChipHeight / 2));

    return Container(
        decoration: style,
        height: formChipHeight,
        child: Center(
            child: Text(value, style: TextStyle(color: colorScheme.primary))));
  }
}
