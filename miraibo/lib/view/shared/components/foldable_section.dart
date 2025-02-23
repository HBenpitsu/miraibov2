import 'package:flutter/material.dart';
import 'package:miraibo/view/shared/components/form_components/shared_constants.dart';

class FoldingController {
  bool _folded;
  bool get folded => _folded;
  void Function()? _actionListener;
  FoldingController({bool initiallyFolded = true}) : _folded = initiallyFolded;

  void toggle() {
    _folded = !_folded;
    _actionListener?.call();
  }

  void fold() {
    _folded = true;
    _actionListener?.call();
  }

  void expand() {
    _folded = false;
    _actionListener?.call();
  }

  void dispose() {
    _actionListener = null;
  }
}

class FoldableSection extends StatefulWidget {
  final Widget header;
  final Widget body;
  final double bodyHeight;
  final Widget? footer;
  final FoldingController? controller;
  final Color? color;
  static const radius = Radius.circular(30);
  static const animationDuration = 500;

  const FoldableSection({
    required this.header,
    required this.body,
    required this.bodyHeight,
    this.footer,
    this.controller,
    this.color,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _FoldableSectionState();
}

class _FoldableSectionState extends State<FoldableSection> {
  late final FoldingController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? FoldingController();
    controller._actionListener = () {
      setState(() {}); // just invoke rebuild
    };
  }

  Widget headerContainer(Widget header) {
    final container = ConstrainedBox(
        constraints: const BoxConstraints(minHeight: formChipHeight),
        child: Container(
            decoration: BoxDecoration(
              color: widget.color ??
                  Theme.of(context).colorScheme.surfaceContainer,
              borderRadius:
                  const BorderRadius.vertical(top: FoldableSection.radius),
            ),
            child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: FoldableSection.radius.x / 2, vertical: 5),
                child: header)));
    return container;
  }

  Widget footerContainer(Widget footer) {
    final container = Container(
        height: formChipHeight,
        width: double.infinity,
        decoration: BoxDecoration(
            color:
                widget.color ?? Theme.of(context).colorScheme.surfaceContainer,
            borderRadius:
                const BorderRadius.vertical(bottom: FoldableSection.radius)),
        child: footer);
    return GestureDetector(
        onTap: () {
          controller.toggle();
        },
        child: container);
  }

  Widget defaultFooter() {
    return Center(
        child: Row(children: [
      const Spacer(),
      Text(
        controller.folded ? 'Tap to expand' : 'Tap to fold',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      Icon(controller.folded ? Icons.arrow_drop_down : Icons.arrow_drop_up),
      const Spacer(),
    ]));
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      headerContainer(widget.header),
      AnimatedContainer(
        duration:
            const Duration(milliseconds: FoldableSection.animationDuration),
        curve: Curves.easeOut,
        color: widget.color ?? Theme.of(context).colorScheme.surfaceContainer,
        height: controller.folded ? 0 : widget.bodyHeight,
        child: widget.body,
      ),
      footerContainer(widget.footer ?? defaultFooter())
    ]);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      controller.dispose();
    }
    super.dispose();
  }
}
