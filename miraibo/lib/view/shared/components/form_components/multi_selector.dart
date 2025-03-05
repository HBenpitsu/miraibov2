import 'dart:async';

import 'package:flutter/material.dart';
import 'package:miraibo/view/shared/components/form_components/shared_constants.dart';
import 'package:miraibo/view/shared/components/modal_window.dart';
import 'package:miraibo/view/shared/components/form_components/custom_search_bar.dart';
import 'package:miraibo/view/shared/components/valed_container.dart';
import 'package:miraibo/view/shared/constants.dart';
import 'package:miraibo/view/shared/components/foldable_section.dart';

// <multi_selector>
/// A widget that allows multiple selections from dropdowns
class MultiSelector<T> extends StatefulWidget {
  final List<String> labels;
  final List<T> values;

  /// the initial selection of each item
  /// true for initially selected
  final List<bool> initial;

  /// callback function that takes selected items
  /// and a boolean that indicates whether all items are selected or not
  final void Function(List<T>, bool) onChanged;

  static const double _heightOfItem = 40;
  static const double _heightOfItemMargin = 2;
  static const double _heightOfItemDisplay = 200;
  static const double _heightOfUpperVale = 10;
  static const double _widthOfHorizontalPadding = 30;

  const MultiSelector(
      {required this.labels,
      required this.values,
      required this.initial,
      required this.onChanged,
      super.key});
  factory MultiSelector.fromTuple(
      {required Iterable<(String, T, bool)> items,
      required void Function(List<T>, bool) onChanged}) {
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
  // <init>
  bool _isAllSelected = false;
  bool get isAllSelected => _isAllSelected;
  set isAllSelected(bool value) {
    _isAllSelected = value;
    widget.onChanged(getSelectedValues(), _isAllSelected);
  }

  late List<bool> _currentlySelected;
  List<bool> get currentlySelected => _currentlySelected;
  set currentlySelected(List<bool> value) {
    _currentlySelected = value;
    selectionNotifier?.add(value);
    widget.onChanged(getSelectedValues(), _isAllSelected);
  }

  late bool expanded;
  StreamController<List<bool>>? selectionNotifier;

  @override
  void initState() {
    super.initState();
    expanded = false;
    _currentlySelected = widget.initial;
  }
  // </init>

  List<T> getSelectedValues() {
    final result = <T>[];
    for (var i = 0; i < currentlySelected.length; i++) {
      if (currentlySelected[i]) {
        result.add(widget.values[i]);
      }
    }
    return result;
  }

  Widget header() {
    final showPickItemButton = ElevatedButton(
        onPressed: showItemPickWindow, child: const Icon(Icons.add));
    final unselectAllButton = ElevatedButton(
        onPressed: () {
          currentlySelected = List.filled(widget.initial.length, false);
        },
        child: const Icon(Icons.autorenew));
    final headerContent = Row(
      children: [
        Expanded(child: showPickItemButton),
        const SizedBox(
          width: 5,
        ),
        unselectAllButton,
      ],
    );
    return headerContent;
  }

  void showItemPickWindow() {
    showDialog(
        context: context,
        useSafeArea: true,
        builder: (context) {
          return _ItemPickerWindow<T>(
              labels: widget.labels,
              initial: currentlySelected,
              onChange: (selection) {
                currentlySelected = selection;
              });
        });
  }

  Widget body() {
    selectionNotifier?.close();
    selectionNotifier = StreamController<List<bool>>();
    final list = _NotifiableItemList(
        initiallyVisible: currentlySelected,
        labels: widget.labels,
        visiblityNotifier: selectionNotifier!.stream,
        heightOfTopDummy: MultiSelector._heightOfUpperVale,
        overlap: const Color.fromARGB(10, 255, 0, 0),
        vale: Theme.of(context).colorScheme.surfaceContainer,
        onTap: (index) {
          currentlySelected[index] = false;
        });
    return Container(
        width: double.infinity,
        color: Theme.of(context).colorScheme.surfaceContainer,
        child: list);
  }

  Widget selectAllButton() {
    final colorScheme = Theme.of(context).colorScheme;
    final style = TextButton.styleFrom(
      backgroundColor: isAllSelected
          ? colorScheme.primaryContainer
          : colorScheme.surfaceContainer,
      fixedSize: const Size.fromHeight(formChipHeight),
    );
    final label = Text(isAllSelected ? 'All' : 'Specified');
    return Padding(
        padding: const EdgeInsets.symmetric(
            vertical: formChipPadding, horizontal: 0),
        child: TextButton(
          onPressed: () {
            setState(() {
              isAllSelected = !isAllSelected;
            });
          },
          style: style,
          child: SizedBox(width: double.infinity, child: Center(child: label)),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(formChipPadding),
        child: Column(
          children: [
            selectAllButton(),
            if (!isAllSelected)
              FoldableSection(
                  header: header(),
                  bodyHeight: MultiSelector._heightOfItemDisplay,
                  body: body())
          ],
        ));
  }

  @override
  void dispose() {
    selectionNotifier?.close();
    selectionNotifier = null;
    super.dispose();
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
  late List<bool> currentlySelected;
  late List<bool> currentlyVisible;
  StreamController<List<bool>>? visibilityNotifier;
  StreamController<List<bool>>? highliteNotifier;

  @override
  void initState() {
    super.initState();
    currentlySelected = widget.initial;
    currentlyVisible =
        List.filled(currentlySelected.length, true); // all visible
  }

  Widget actionButtons() {
    final selectAllButton = TextButton(
        onPressed: () {
          currentlySelected = List.filled(currentlySelected.length, true);
          highliteNotifier?.add(currentlySelected);
          widget.onChange(currentlySelected);
        },
        child: const Text('Select All'));
    final releaseAllButton = TextButton(
        onPressed: () {
          currentlySelected = List.filled(currentlySelected.length, false);
          highliteNotifier?.add(currentlySelected);
          widget.onChange(currentlySelected);
        },
        child: const Text('Release All'));
    final okButton = TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text('OK'));
    return Padding(
        padding: const EdgeInsets.all(actionButtonPadding),
        child: Row(
          children: [
            const Spacer(),
            Expanded(flex: 3, child: selectAllButton),
            const SizedBox(width: 5),
            Expanded(flex: 3, child: releaseAllButton),
            const SizedBox(width: 5),
            Expanded(flex: 3, child: okButton),
            const Spacer(),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    visibilityNotifier?.close();
    visibilityNotifier = StreamController<List<bool>>();
    highliteNotifier?.close();
    highliteNotifier = StreamController<List<bool>>();

    final serachBar = Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: MultiSelector._widthOfHorizontalPadding),
        child: CustomSearchBar(onSearchWordChanged: (text) {
          final search = text.toLowerCase();
          currentlyVisible = widget.labels
              .map((elem) => elem.toLowerCase().contains(search))
              .toList();
          visibilityNotifier?.add(currentlyVisible);
        }));
    final list = _NotifiableItemList(
        initiallyVisible: currentlyVisible,
        initiallyHighlited: currentlySelected,
        labels: widget.labels,
        visiblityNotifier: visibilityNotifier!.stream,
        highliteNotifier: highliteNotifier!.stream,
        overlap: const Color.fromARGB(10, 0, 0, 0),
        heightOfTopDummy: MultiSelector._heightOfItem,
        vale: Theme.of(context).colorScheme.surface,
        onTap: (index) {
          currentlySelected[index] = !currentlySelected[index];
          highliteNotifier?.add(currentlySelected);
          widget.onChange(currentlySelected);
        });
    return ModalWindowContainer(
        child: Column(children: [
      Expanded(
          child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: MultiSelector._widthOfHorizontalPadding,
                  vertical: 10),
              child: list)),
      const SizedBox(height: 10),
      serachBar,
      actionButtons(),
    ]));
  }

  @override
  void dispose() {
    visibilityNotifier?.close();
    visibilityNotifier = null;
    highliteNotifier?.close();
    highliteNotifier = null;
    super.dispose();
  }
}

class _NotifiableItemList extends StatefulWidget {
  final List<bool> initiallyVisible;
  final List<bool>? initiallyHighlited;
  final List<String> labels;
  final Stream<List<bool>> visiblityNotifier;
  final Stream<List<bool>>? highliteNotifier;
  final void Function(int) onTap;
  final Color overlap;
  final Color vale;
  final double heightOfTopDummy;
  static const double heightOfBottomDummy = MultiSelector._heightOfItem;
  static const double heightOfItem = MultiSelector._heightOfItem;
  static const double heightOfItemMargin = MultiSelector._heightOfItemMargin;

  const _NotifiableItemList({
    required this.initiallyVisible,
    this.initiallyHighlited,
    required this.labels,
    required this.visiblityNotifier,
    this.highliteNotifier,
    required this.heightOfTopDummy,
    required this.onTap,
    required this.overlap,
    required this.vale,
  });
  @override
  State<_NotifiableItemList> createState() => _NotifiableItemListState();
}

class _NotifiableItemListState extends State<_NotifiableItemList> {
  late List<bool> currentlyVisible;
  late List<bool> currentlyHighlited;

  @override
  void initState() {
    super.initState();
    currentlyVisible = widget.initiallyVisible;

    // if not provided, all items are highlited
    // because this is the private class that is used only by the MultiSelector and _ItemPickerWindow
    // MultiSelector does not provide the highliteNotifier and _ItemPickerWindow provides it
    // MultiSelector needs to highlite all items
    currentlyHighlited =
        widget.initiallyHighlited ?? List.filled(widget.labels.length, true);

    widget.visiblityNotifier.listen((visiblity) {
      setState(() {
        currentlyVisible = visiblity;
      });
    });

    widget.highliteNotifier?.listen((highlite) {
      setState(() {
        currentlyHighlited = highlite;
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
        color: currentlyHighlited[modelIndex]
            ? colorScheme.primaryContainer
            : colorScheme.surfaceContainer,
        // delete on tap
        child: InkWell(
          highlightColor: widget.overlap,
          onTapUp: (_) {
            widget.onTap(modelIndex);
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
        upperValeHeight: widget.heightOfTopDummy,
        lowerValeHeight: _NotifiableItemList.heightOfBottomDummy,
        valeColor: widget.vale,
        itemCount: effectiveIndexes.length,
        builder: (context, index) => item(context, index, effectiveIndexes));
  }
}
