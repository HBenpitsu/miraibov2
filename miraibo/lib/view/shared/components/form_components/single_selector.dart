import 'dart:async';

import 'package:flutter/material.dart';
import 'package:miraibo/view/shared/components/form_components/custom_search_bar.dart';
import 'package:miraibo/view/shared/components/form_components/shared_constants.dart';
import 'package:miraibo/view/shared/components/modal_window.dart';
import 'package:miraibo/view/shared/components/valed_container.dart';

class SingleSelector<T> extends StatefulWidget {
  final int initialIndex;
  final List<String> labels;
  final List<T> values;
  final void Function(T) onChanged;

  static const double heightOfItem = 40;
  static const double heightOfItemMargin = 2;
  static const double heightOfItemDisplay = 200;
  static const double heightOfUpperVale = 10;
  static const double widthOfHorizontalPadding = 30;

  const SingleSelector({
    required this.initialIndex,
    required this.labels,
    required this.values,
    required this.onChanged,
    super.key,
  });

  factory SingleSelector.fromTaple(
      {required int initialIndex,
      required void Function(T) onChanged,
      required Iterable<(String, T)> items}) {
    final labels = <String>[];
    final values = <T>[];
    for (final e in items) {
      labels.add(e.$1);
      values.add(e.$2);
    }
    return SingleSelector(
        initialIndex: initialIndex,
        labels: labels,
        onChanged: onChanged,
        values: values);
  }

  @override
  State<StatefulWidget> createState() => _SingleSelectorState<T>();
}

class _SingleSelectorState<T> extends State<SingleSelector<T>> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
  }

  void openItemPickupWindow() {
    showDialog(
        context: context,
        builder: (context) {
          return _ItemPickerWindow(
              labels: widget.labels,
              initial: widget.initialIndex,
              onChange: (selected) {
                setState(() {
                  selectedIndex = selected;
                  widget.onChanged(widget.values[selectedIndex]);
                });
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    final style = TextButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        fixedSize: const Size.fromHeight(formChipHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(formChipHeight / 2),
        ));
    return Padding(
        padding: const EdgeInsets.all(formChipPadding),
        child: TextButton(
          style: style,
          onPressed: openItemPickupWindow,
          child: Text(widget.labels[selectedIndex]),
        ));
  }
}

class _ItemPickerWindow<T> extends StatefulWidget {
  final List<String> labels;
  final int initial;
  final void Function(int) onChange;
  const _ItemPickerWindow(
      {required this.labels,
      required this.initial,
      required this.onChange,
      super.key});
  @override
  State<_ItemPickerWindow<T>> createState() => _ItemPickerWindowState<T>();
}

class _ItemPickerWindowState<T> extends State<_ItemPickerWindow<T>> {
  late List<bool> currentlyVisible;
  late final TextEditingController searchController;
  late final FocusNode searchFocusNode;
  late final StreamController<List<bool>> visibilityNotifier;

  @override
  void initState() {
    super.initState();
    currentlyVisible = List.filled(widget.labels.length, true); // all visible
    searchController = TextEditingController();
    searchFocusNode = FocusNode();
    visibilityNotifier = StreamController<List<bool>>();
  }

  @override
  Widget build(BuildContext context) {
    final list = Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: _NotifiableItemList(
            initiallyHighlited: widget.initial,
            labels: widget.labels,
            initiallyVisible: currentlyVisible,
            visiblityNotifier: visibilityNotifier.stream,
            overlap: const Color.fromARGB(10, 0, 0, 0),
            onChanged: widget.onChange));
    final searchBar = CustomSearchBar(onSearchWordChanged: (text) {
      final search = text.toLowerCase();
      currentlyVisible = widget.labels
          .map((elem) => elem.toLowerCase().contains(search))
          .toList();
      visibilityNotifier.add(currentlyVisible);
    });
    final actionButton = Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            const Spacer(flex: 1),
            Expanded(
                flex: 3,
                child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'))),
            const Spacer(flex: 1),
          ],
        ));

    return ModalWindowContainer(
        child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: SingleSelector.widthOfHorizontalPadding),
            child: Column(children: [
              Expanded(child: list),
              const SizedBox(height: 10),
              searchBar,
              actionButton
            ])));
  }
}

class _NotifiableItemList extends StatefulWidget {
  final List<bool> initiallyVisible;
  final int initiallyHighlited;
  final List<String> labels;
  final Stream<List<bool>> visiblityNotifier;
  final void Function(int) onChanged;
  final Color overlap;
  static const double heightOfTopDummy = SingleSelector.heightOfItem;
  static const double heightOfBottomDummy = SingleSelector.heightOfItem;
  static const double heightOfItem = SingleSelector.heightOfItem;
  static const double heightOfItemMargin = SingleSelector.heightOfItemMargin;

  const _NotifiableItemList({
    required this.initiallyVisible,
    required this.initiallyHighlited,
    required this.labels,
    required this.visiblityNotifier,
    required this.onChanged,
    required this.overlap,
  });
  @override
  State<_NotifiableItemList> createState() => _NotifiableItemListState();
}

class _NotifiableItemListState extends State<_NotifiableItemList> {
  late List<bool> currentlyVisible;
  late int currentlyHighlited;

  @override
  void initState() {
    super.initState();
    currentlyVisible = widget.initiallyVisible;
    currentlyHighlited = widget.initiallyHighlited;

    widget.visiblityNotifier.listen((visiblity) {
      setState(() {
        currentlyVisible = visiblity;
      });
    });
  }

  List<int> getEffectiveIndexes() {
    final result = <int>[];
    for (var i = 0; i < currentlyVisible.length; i++) {
      if (currentlyVisible[i]) {
        result.add(i);
      }
    }
    return result;
  }

  Widget item(BuildContext context, int viewIndex, List<int> effectiveIndexes) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // now we are not curious about the viewIndex (the index of the shown list)
    // but we have to know the index of the list that holds data of all items
    final modelIndex = effectiveIndexes[viewIndex];

    // making real item below
    final itemLabel = SizedBox(
        height: _NotifiableItemList.heightOfItem,
        child: Center(
            child:
                Text(widget.labels[modelIndex], style: textTheme.labelLarge)));

    final item = Material(
        color: currentlyHighlited == modelIndex
            ? colorScheme.primaryContainer
            : colorScheme.surfaceContainer,
        // delete on tap
        child: InkWell(
          highlightColor: widget.overlap,
          onTapUp: (_) {
            setState(() {
              currentlyHighlited = modelIndex;
              widget.onChanged(modelIndex);
            });
          },
          child: itemLabel,
        ));

    return Padding(
      padding:
          const EdgeInsets.only(bottom: _NotifiableItemList.heightOfItemMargin),
      key: ValueKey(modelIndex),
      child: item,
    );
  }

  @override
  Widget build(BuildContext context) {
    var effectiveIndexes = getEffectiveIndexes();

    return ValedList(
        builder: (context, index) => item(context, index, effectiveIndexes),
        upperValeHeight: _NotifiableItemList.heightOfTopDummy,
        lowerValeHeight: _NotifiableItemList.heightOfBottomDummy,
        valeColor: Theme.of(context).colorScheme.surface,
        itemCount: effectiveIndexes.length);
  }
}
