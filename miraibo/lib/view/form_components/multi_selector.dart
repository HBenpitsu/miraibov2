import 'package:flutter/material.dart';
import 'package:miraibo/view/form_components/shared_constants.dart';

// <multi_selector>
/// A widget that allows multiple selections from dropdowns
class MultiSelector<T> extends StatefulWidget {
  final List<String> labels;
  final List<T> values;

  /// the initial selection of each item
  /// true for initially selected
  final List<bool> initial;
  final void Function(List<T>) onChanged;

  static const double heightOfItem = 40;
  static const double sizeOfItemMargin = 2;
  static const double heightOfItemWindow = 200;
  static const double widthOfHorizontalPadding = 30;

  const MultiSelector(
      {required this.labels,
      required this.values,
      required this.initial,
      required this.onChanged,
      super.key});
  factory MultiSelector.fromTuple(
      {required Iterable<(String, T, bool)> items,
      required void Function(List<T>) onChanged}) {
    final labels = <String>[];
    final values = <T>[];
    final initial = <bool>[];
    for (final item in items) {
      labels.add(item.$1);
      values.add(item.$2);
      initial.add(item.$3);
    }
    return MultiSelector(
        labels: labels, values: values, initial: initial, onChanged: onChanged);
  }

  @override
  State<MultiSelector<T>> createState() => _MultiSelectorState<T>();
}

class _MultiSelectorState<T> extends State<MultiSelector<T>> {
  late List<bool> current;
  late bool expanded;

  @override
  void initState() {
    super.initState();
    current = widget.initial;
    expanded = false;
  }

  List<T> getSelectedValues() {
    final result = <T>[];
    for (var i = 0; i < current.length; i++) {
      if (current[i]) {
        result.add(widget.values[i]);
      }
    }
    return result;
  }

  Widget content() {
    const double sizeOfUpperVale = 10;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    // content
    final items = <Widget>[];
    // dummy item (to avoid vale)
    items.add(const SizedBox(height: sizeOfUpperVale));
    // real items
    for (var i = 0; i < widget.labels.length; i++) {
      if (current[i]) {
        final itemLabel = Padding(
            padding:
                const EdgeInsets.only(bottom: MultiSelector.sizeOfItemMargin),
            child: Container(
                color: colorScheme.primaryContainer,
                height: MultiSelector.heightOfItem,
                key: ValueKey(i),
                child: Center(
                    child:
                        Text(widget.labels[i], style: textTheme.labelLarge))));
        // delete on tap
        final item = GestureDetector(
            onTap: () {
              setState(() {
                current[i] = false;
                widget.onChanged(getSelectedValues());
              });
            },
            child: itemLabel);
        items.add(item);
      }
    }
    // dummy item (to avoid vale)
    items.add(const SizedBox(
        height: MultiSelector.heightOfItem - MultiSelector.sizeOfItemMargin));

    final mainContent =
        ListView(padding: const EdgeInsets.all(0), children: items);

    // vale
    final upperVale = Container(
        width: double.infinity,
        height: sizeOfUpperVale,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                colorScheme.surfaceContainer,
                colorScheme.surfaceContainer.withOpacity(0)
              ]),
        ));
    final lowerVale = Container(
        width: double.infinity,
        height: MultiSelector.heightOfItem,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                colorScheme.surfaceContainer.withOpacity(0),
                colorScheme.surfaceContainer
              ]),
        ));

    final fadedOutContent = Stack(
      children: [
        mainContent,
        Positioned(top: 0, left: 0, right: 0, child: upperVale),
        Positioned(bottom: 0, left: 0, right: 0, child: lowerVale)
      ],
    );

    // layout
    final layoutedContent = Container(
        width: double.infinity,
        color: colorScheme.surfaceContainer, // set background color
        child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: MultiSelector.widthOfHorizontalPadding),
            child: fadedOutContent));

    // animation
    final animatedContent = AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: expanded ? MultiSelector.heightOfItemWindow : 0,
        curve: Curves.easeInOut,
        child: layoutedContent);

    return animatedContent;
  }

  Widget holder(Widget content) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final topHandleContent = Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: MultiSelector.widthOfHorizontalPadding),
        child: Row(
          children: [
            Expanded(
                child: ElevatedButton(
                    onPressed: showItemPickWindow,
                    child: const Icon(Icons.add))),
            const SizedBox(
              width: 5,
            ),
            // deselect all
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    current = List.filled(current.length, false);
                    widget.onChanged(getSelectedValues());
                  });
                },
                child: const Icon(Icons.delete)),
          ],
        ));
    final topHandle = Container(
        width: double.infinity,
        height: formChipHeight,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainer,
          borderRadius: const BorderRadius.vertical(
              top: Radius.circular(formChipHeight / 2), bottom: Radius.zero),
        ),
        child: topHandleContent);
    final bottomHandleLabel = Row(children: [
      const Spacer(),
      Text(expanded ? 'Tap to fold' : 'Tap to expand',
          style: textTheme.labelSmall),
      Icon(expanded ? Icons.arrow_drop_up : Icons.arrow_drop_down),
      const Spacer(),
    ]);
    final bottomHandle = Container(
        width: double.infinity,
        height: formChipHeight / 2,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainer,
          borderRadius: const BorderRadius.vertical(
              top: Radius.zero, bottom: Radius.circular(formChipHeight / 2)),
        ),
        child: bottomHandleLabel);
    final expandionButton = GestureDetector(
        onTap: () {
          setState(() {
            expanded = !expanded;
          });
        },
        child: bottomHandle);
    return Column(
      children: [
        topHandle,
        content,
        expandionButton,
      ],
    );
  }

  void showItemPickWindow() {
    final windowHeight = MediaQuery.of(context).size.height;
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        constraints: BoxConstraints.loose(Size.fromHeight(windowHeight / 2)),
        builder: (context) {
          return _ItemPickerWindow<T>(
              labels: widget.labels,
              initial: current,
              onChange: (selection) {
                setState(() {
                  current = selection;
                  final result = <T>[];
                  for (var i = 0; i < current.length; i++) {
                    if (current[i]) {
                      result.add(widget.values[i]);
                    }
                  }
                  widget.onChanged(result);
                });
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(2.0), child: holder(content()));
  }
}

class _ItemPickerWindow<T> extends StatefulWidget {
  final List<String> labels;
  final List<bool> initial;
  final void Function(List<bool>) onChange;
  const _ItemPickerWindow(
      {required this.labels,
      required this.initial,
      required this.onChange,
      super.key});
  @override
  State<_ItemPickerWindow<T>> createState() => _ItemPickerWindowState<T>();
}

class _ItemPickerWindowState<T> extends State<_ItemPickerWindow<T>> {
  late List<bool> current;

  @override
  void initState() {
    super.initState();
    current = widget.initial;
  }

  Widget item(BuildContext context, int index) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isSelected = current[index];
    final label = Container(
        color: isSelected
            ? colorScheme.primaryContainer
            : colorScheme.surfaceContainer,
        height: MultiSelector.heightOfItem,
        child: Center(
            child: Text(widget.labels[index], style: textTheme.labelLarge)));
    return Padding(
        padding: const EdgeInsets.symmetric(
            vertical: MultiSelector.sizeOfItemMargin / 2),
        child: GestureDetector(
            onTap: () {
              setState(() {
                current[index] = !current[index];
                widget.onChange(current);
              });
            },
            child: label));
  }

  Widget handle() {
    return Row(
      children: [
        const Spacer(),
        TextButton(
            onPressed: () {
              setState(() {
                current = List.filled(current.length, true);
                widget.onChange(current);
              });
            },
            child: const Text('Select All')),
        const Spacer(),
        TextButton(
            onPressed: () {
              setState(() {
                current = List.filled(current.length, false);
                widget.onChange(current);
              });
            },
            child: const Text('Release All')),
        const Spacer(),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK')),
        const Spacer(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
          child:
              ListView.builder(itemBuilder: item, itemCount: current.length)),
      handle(),
    ]);
  }
}
