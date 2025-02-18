import 'package:flutter/material.dart';
import 'dart:math' show min;

class ModalWindowContainer extends StatefulWidget {
  final Widget child;
  static const double windowHeightRatio = 0.8;
  static const double windowWidthRatio = 0.98;
  const ModalWindowContainer({required this.child, super.key});

  @override
  State<StatefulWidget> createState() => _ModalWindowContainerState();
}

// to relocate the window when the screen keyboard is shown
// it should be stateful
class _ModalWindowContainerState extends State<ModalWindowContainer> {
  @override
  Widget build(BuildContext context) {
    // locate the window
    final mediaQuery = MediaQuery.of(context);
    final screenSize = mediaQuery.size;

    final occupiedBottomSpace =
        mediaQuery.viewInsets.bottom + mediaQuery.viewPadding.bottom;

    final occupiedVerticalSpace =
        mediaQuery.viewInsets.vertical + mediaQuery.viewPadding.vertical;

    final windowWidth =
        screenSize.width * ModalWindowContainer.windowWidthRatio;
    final windowHeight = min(
        screenSize.height * ModalWindowContainer.windowHeightRatio,
        (screenSize.height - occupiedVerticalSpace) * 0.9);

    // make the window
    final windowStyle = BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.surface);
    final window = GestureDetector(
        onTap: () {
          // to avoid closing the window when tapping the window
          // non-null onTap consumes the tap event
          // and prevents the background GestureDetector from receiving the event
        },
        child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            height: windowHeight,
            width: windowWidth,
            decoration: windowStyle,
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: widget.child)));
    return GestureDetector(
        onTap: () {
          // when tapping the background, close the window
          Navigator.of(context).pop();
        },
        child: Scaffold(
            // scaffold is needed to avoid screen keyboard overlapping
            resizeToAvoidBottomInset:
                false, // to implement on graceful relocation
            backgroundColor: Colors.transparent,
            body: Center(
                child: Column(children: [
              const Spacer(flex: 2),
              window,
              const Spacer(flex: 1),
              // to avoid screen keyboard overlapping
              // with AnimatedContainer, the relocation becomes smooth
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                height: occupiedBottomSpace,
              )
            ]))));
  }
}
