import 'package:flutter/material.dart';
import 'package:miraibo/view/shared/components/form_components/custom_text_field.dart';
import 'package:miraibo/view/shared/components/form_components/shared_constants.dart';

class CustomSearchBar extends StatefulWidget {
  final TextEditingController? controller;
  final void Function(String) onSearchWordChanged;

  const CustomSearchBar(
      {this.controller, required this.onSearchWordChanged, super.key});

  @override
  State<StatefulWidget> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  late final TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = widget.controller ?? TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final inputField = CustomTextField(
      controller: searchController,
      decoration: InputDecoration(
          hintText: 'Search',
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.surfaceDim),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(formChipHeight))),
      onEditCompleted: (text) {
        widget.onSearchWordChanged(text);
      },
    );
    final resetButton = IconButton(
      onPressed: () {
        searchController.clear();
        widget.onSearchWordChanged('');
      },
      style: TextButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
          minimumSize: const Size(formChipHeight, formChipHeight)),
      icon: const Icon(Icons.backspace),
    );
    return SizedBox(
        height: formChipHeight,
        child: Row(
          children: [
            Expanded(child: inputField),
            const SizedBox(width: 5), // spacer
            resetButton,
          ],
        ));
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      searchController.dispose();
    }
    super.dispose();
  }
}
