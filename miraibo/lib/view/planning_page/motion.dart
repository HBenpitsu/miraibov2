import 'package:flutter/material.dart';

/// This page scroll physics make it possible to scroll page by page even though the page is not full of device-screen.
class FixiedWidthPageScrollPhysics extends ScrollPhysics {
  final double pageSizeInPixel;
  const FixiedWidthPageScrollPhysics(
      {super.parent, required this.pageSizeInPixel});

  @override
  FixiedWidthPageScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return FixiedWidthPageScrollPhysics(
        parent: buildParent(ancestor), pageSizeInPixel: pageSizeInPixel);
  }

  double _getPage(ScrollMetrics position) {
    return position.pixels / pageSizeInPixel;
  }

  double _getPixels(double pageIdx) {
    return pageIdx * pageSizeInPixel;
  }

  double _getTargetPixels(
      ScrollMetrics position, Tolerance tolerance, double velocity) {
    double page = _getPage(position);
    if (velocity < -tolerance.velocity) {
      page -= 0.5;
    } else if (velocity > tolerance.velocity) {
      page += 0.5;
    }
    return _getPixels(page.roundToDouble());
  }

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    // If we're out of range and not headed back in range, defer to the parent
    // ballistics, which should put us back in range at a page boundary.
    if ((velocity <= 0.0 && position.pixels <= position.minScrollExtent) ||
        (velocity >= 0.0 && position.pixels >= position.maxScrollExtent)) {
      return super.createBallisticSimulation(position, velocity);
    }
    final Tolerance tolerance = toleranceFor(position);
    final double target = _getTargetPixels(position, tolerance, velocity);
    if (target != position.pixels) {
      return ScrollSpringSimulation(spring, position.pixels, target, velocity,
          tolerance: tolerance);
    }
    return null;
  }

  @override
  bool get allowImplicitScrolling => false;
}
