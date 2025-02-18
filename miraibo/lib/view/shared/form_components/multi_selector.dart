import 'dart:async';

import 'package:flutter/material.dart';
import 'package:miraibo/view/shared/form_components/shared_constants.dart';

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
  static const double heightOfItemMargin = 2;
  static const double heightOfItemDisplay = 200;
  static const double heightOfUpperVale = 10;
  static const double widthOfHorizontalPadding = 30;
  static const double ratioOfPickUpWindowHeight = 0.5;
  static const double ratioOfPickUpWindowWidth = 0.9;

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
  // <init>
  late List<bool> _currentlySelected;
  List<bool> get currentlySelected => _currentlySelected;
  set currentlySelected(List<bool> value) {
    _currentlySelected = value;
    selectionNotifier.add(value);
    widget.onChanged(getSelectedValues());
  }

  late bool expanded;
  late StreamController<List<bool>> selectionNotifier;
  late Widget itemDisplayCache;

  @override
  void initState() {
    super.initState();
    expanded = false;
    _currentlySelected = widget.initial;
    selectionNotifier = StreamController<List<bool>>();
    itemDisplayCache = _NotifiableItemList(
        heightOfTopDummy: MultiSelector.heightOfUpperVale,
        heightOfBottomDummy: MultiSelector.heightOfItem,
        heightOfItem: MultiSelector.heightOfItem,
        heightOfItemMargin: MultiSelector.heightOfItemMargin,
        initiallyVisible: _currentlySelected,
        labels: widget.labels,
        visiblityNotifier: selectionNotifier.stream,
        overlap: const Color.fromARGB(10, 255, 0, 0),
        onTap: (index) {
          _currentlySelected[index] = false;
          selectionNotifier.add(_currentlySelected);
          widget.onChanged(getSelectedValues());
        });
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
    final colorScheme = Theme.of(context).colorScheme;
    final headerContent = Padding(
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
                  currentlySelected = List.filled(widget.initial.length, false);
                },
                child: const Icon(Icons.autorenew)),
          ],
        ));
    final header = Container(
        width: double.infinity,
        height: formChipHeight,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainer,
          borderRadius: const BorderRadius.vertical(
              top: Radius.circular(formChipHeight / 2), bottom: Radius.zero),
        ),
        child: headerContent);
    return header;
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

  Widget listHolder(Widget list) {
    final colorScheme = Theme.of(context).colorScheme;

    // vale
    final upperVale = Container(
        width: double.infinity,
        height: MultiSelector.heightOfUpperVale,
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
        list,
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
        height: expanded ? MultiSelector.heightOfItemDisplay : 0,
        curve: Curves.easeInOut,
        child: layoutedContent);

    return animatedContent;
  }

  Widget footer() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final label = Row(children: [
      const Spacer(),
      Text(expanded ? 'Tap to fold' : 'Tap to expand',
          style: textTheme.labelSmall),
      Icon(expanded ? Icons.arrow_drop_up : Icons.arrow_drop_down),
      const Spacer(),
    ]);
    final footer = Container(
        width: double.infinity,
        height: formChipHeight,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainer,
          borderRadius: const BorderRadius.vertical(
              top: Radius.zero, bottom: Radius.circular(formChipHeight / 2)),
        ),
        child: label);
    final footerBottunized = GestureDetector(
        onTap: () {
          setState(() {
            expanded = !expanded;
          });
        },
        child: footer);
    return footerBottunized;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(2.0),
        child: Column(
          children: [
            header(),
            listHolder(itemDisplayCache),
            footer(),
          ],
        ));
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
  late final TextEditingController searchController;
  late final FocusNode searchFocusNode;
  late final StreamController<List<bool>> visibilityNotifier;
  late final StreamController<List<bool>> highliteNotifier;
  late final Widget itemListCache;

  @override
  void initState() {
    super.initState();
    currentlySelected = widget.initial;
    currentlyVisible =
        List.filled(currentlySelected.length, true); // all visible
    searchController = TextEditingController();
    searchFocusNode = FocusNode();
    visibilityNotifier = StreamController<List<bool>>();
    highliteNotifier = StreamController<List<bool>>();
    itemListCache = _NotifiableItemList(
        heightOfTopDummy: MultiSelector.heightOfItem,
        heightOfBottomDummy: MultiSelector.heightOfItem,
        heightOfItem: MultiSelector.heightOfItem,
        heightOfItemMargin: MultiSelector.heightOfItemMargin,
        initiallyVisible: currentlyVisible,
        initiallyHighlited: currentlySelected,
        labels: widget.labels,
        visiblityNotifier: visibilityNotifier.stream,
        highliteNotifier: highliteNotifier.stream,
        overlap: const Color.fromARGB(10, 0, 0, 0),
        onTap: (index) {
          currentlySelected[index] = !currentlySelected[index];
          highliteNotifier.add(currentlySelected);
          widget.onChange(currentlySelected);
        });
  }

  Widget searchBar() {
    final inputField = TextField(
        controller: searchController,
        focusNode: searchFocusNode,
        decoration: InputDecoration(
            hintText: 'Search',
            hintStyle:
                TextStyle(color: Theme.of(context).colorScheme.surfaceDim),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(formChipHeight))),
        onSubmitted: (value) {
          final search = value.toLowerCase();
          currentlyVisible = List.generate(widget.labels.length,
              (index) => widget.labels[index].toLowerCase().contains(search));
          visibilityNotifier.add(currentlyVisible);
        });
    final resetButton = IconButton(
      onPressed: () {
        searchController.clear();
        currentlyVisible = List.filled(currentlyVisible.length, true);
        visibilityNotifier.add(currentlyVisible);
      },
      style: TextButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
          minimumSize: const Size(formChipHeight, formChipHeight)),
      icon: const Icon(Icons.backspace),
    );
    final bar = SizedBox(
        height: formChipHeight,
        child: Row(
          children: [
            Expanded(child: inputField),
            const SizedBox(width: 5), // spacer
            resetButton,
          ],
        ));
    return bar;
  }

  Widget actionButtons() {
    return Row(
      children: [
        const Spacer(),
        TextButton(
            onPressed: () {
              currentlySelected = List.filled(currentlySelected.length, true);
              highliteNotifier.add(currentlySelected);
              widget.onChange(currentlySelected);
            },
            child: const Text('Select All')),
        const Spacer(),
        TextButton(
            onPressed: () {
              currentlySelected = List.filled(currentlySelected.length, false);
              highliteNotifier.add(currentlySelected);
              widget.onChange(currentlySelected);
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

  Widget itemListHolder() {
    // vale
    final upperVale = Container(
        width: double.infinity,
        height: MultiSelector.heightOfItem,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).colorScheme.surface,
                Theme.of(context).colorScheme.surface.withOpacity(0)
              ]),
        ));
    final lowerVale = Container(
        width: double.infinity,
        height: MultiSelector.heightOfItem,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Theme.of(context).colorScheme.surface,
                Theme.of(context).colorScheme.surface.withOpacity(0)
              ]),
        ));
    final stack = Stack(children: [
      itemListCache,
      Positioned(top: 0, left: 0, right: 0, child: upperVale),
      Positioned(bottom: 0, left: 0, right: 0, child: lowerVale)
    ]);
    return stack;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final windowStyle = BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.surface);
    final mainContent = Column(children: [
      Expanded(child: itemListHolder()),
      const SizedBox(height: 10),
      searchBar(),
      actionButtons(),
    ]);
    final window = Container(
        height: screenSize.height * MultiSelector.ratioOfPickUpWindowHeight,
        width: screenSize.width * MultiSelector.ratioOfPickUpWindowWidth,
        decoration: windowStyle,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: mainContent));
    return Scaffold(
        // scaffold is needed to avoid screen keyboard overlapping
        backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
        body: Center(
            child: Column(children: [
          const Spacer(flex: 2),
          window,
          const Spacer(),
        ])));
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
  final double heightOfTopDummy;
  final double heightOfBottomDummy;
  final double heightOfItem;
  final double heightOfItemMargin;
  const _NotifiableItemList({
    required this.initiallyVisible,
    this.initiallyHighlited,
    required this.labels,
    required this.visiblityNotifier,
    this.highliteNotifier,
    required this.onTap,
    required this.overlap,
    required this.heightOfTopDummy,
    required this.heightOfBottomDummy,
    required this.heightOfItem,
    required this.heightOfItemMargin,
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

  Widget? item(
      BuildContext context, int viewIndex, List<int> effectiveIndexes) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (viewIndex == 0) {
      return SizedBox(height: widget.heightOfTopDummy);
    }
    // shift down by 1 to add a dummy item at the top
    viewIndex -= 1;

    // the last item is a dummy item
    if (viewIndex == effectiveIndexes.length) {
      return SizedBox(height: widget.heightOfItem - widget.heightOfItemMargin);
    }
    // if the index is out of range return null
    if (viewIndex > effectiveIndexes.length) {
      return null;
    }

    // now we are not curious about the viewIndex (the index of the shown list)
    // but we have to know the index of the list that holds data of all items
    final modelIndex = effectiveIndexes[viewIndex];

    // making real item below
    final itemLabel = SizedBox(
        height: widget.heightOfItem,
        width: double.infinity,
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
      padding: EdgeInsets.only(bottom: widget.heightOfItemMargin),
      key: ValueKey(modelIndex),
      child: item,
    );
  }

  @override
  Widget build(BuildContext context) {
    var effectiveIndexes = getEffectiveIndexes();

    return ListView.builder(
        itemCount: effectiveIndexes.length + 2, // add dummy items
        itemBuilder: (context, index) =>
            item(context, index, effectiveIndexes));
  }
}
