import 'package:flutter/material.dart';
import 'dart:math' show min;
import 'package:async/async.dart';

class ModalWindowContainer extends StatefulWidget {
  final Widget child;
  final bool shrink;
  static const double windowHeightRatio = 0.8;
  static const double windowWidthRatio = 0.98;
  static const double maxWindowWidth = 600;
  const ModalWindowContainer(
      {required this.child, this.shrink = false, super.key});

  @override
  State<StatefulWidget> createState() => _ModalWindowContainerState();
}

// to relocate the window when the screen keyboard is shown
// it should be stateful
class _ModalWindowContainerState extends State<ModalWindowContainer> {
  double? occupiedBottomSpace;
  CancelableOperation<void>? taskForBottomSpaceUpdate;
  double? occupiedVerticalSpace;
  CancelableOperation<void>? taskForVerticalSpaceUpdate;

  void setLastOccupiedBottomSpace(double value) {
    // inject delay to avoid sequential setState
    taskForBottomSpaceUpdate?.cancel();
    taskForBottomSpaceUpdate = CancelableOperation.fromFuture(
        Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          occupiedBottomSpace = value;
        });
      }
    }));
  }

  void setLastOccupiedVerticalSpace(double value) {
    // inject delay to avoid sequential setState
    taskForVerticalSpaceUpdate?.cancel();
    taskForVerticalSpaceUpdate = CancelableOperation.fromFuture(
        Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          occupiedVerticalSpace = value;
        });
      }
    }));
  }

  @override
  Widget build(BuildContext context) {
    // locate the window
    final mediaQuery = MediaQuery.of(context);
    final screenSize = mediaQuery.size;

    final occupiedBottomSpace =
        mediaQuery.viewInsets.bottom + mediaQuery.viewPadding.bottom;
    // needs to be initialized
    this.occupiedBottomSpace ??= occupiedBottomSpace;
    setLastOccupiedBottomSpace(occupiedBottomSpace);

    final occupiedVerticalSpace =
        mediaQuery.viewInsets.vertical + mediaQuery.viewPadding.vertical;
    // needs to be initialized
    this.occupiedVerticalSpace ??= occupiedVerticalSpace;
    setLastOccupiedVerticalSpace(occupiedVerticalSpace);

    final windowWidth = min(ModalWindowContainer.maxWindowWidth,
        screenSize.width * ModalWindowContainer.windowWidthRatio);
    final windowHeight = min(
        screenSize.height * ModalWindowContainer.windowHeightRatio,
        (screenSize.height - this.occupiedVerticalSpace!) * 0.9);

    // make the window
    final windowStyle = BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.surface);
    final Widget window;
    if (widget.shrink) {
      window = Container(
          clipBehavior: Clip.antiAlias,
          width: windowWidth,
          decoration: windowStyle,
          child: widget.child);
    } else {
      window = AnimatedContainer(
          clipBehavior: Clip.antiAlias,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          height: windowHeight,
          width: windowWidth,
          decoration: windowStyle,
          child: widget.child);
    }
    final eventConsumingWindow = GestureDetector(
        onTap: () {
          // to avoid closing the window when tapping the window
          // non-null onTap consumes the tap event
          // and prevents the background GestureDetector from receiving the event
        },
        child: window);
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
              eventConsumingWindow,
              const Spacer(flex: 1),
              // to avoid screen keyboard overlapping
              // with AnimatedContainer, the relocation becomes smooth
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                height: this.occupiedBottomSpace,
              )
            ]))));
  }
}
