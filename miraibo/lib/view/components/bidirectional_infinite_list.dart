import 'package:flutter/material.dart';
import 'package:miraibo/view/components/motion.dart';

class BiInifiniteList extends StatelessWidget {
  final Widget Function(int index) itemBuilder;
  final double? anchor;
  final AxisDirection? axisDirection;
  final ScrollController? controller;
  final ScrollPhysics? physics;
  const BiInifiniteList(
      {required this.itemBuilder,
      this.anchor,
      this.axisDirection,
      this.controller,
      this.physics,
      super.key});

  @override
  Widget build(BuildContext context) {
    // dual-directional infinite vertically scrollable list
    Key center = UniqueKey(); // this key is to center the list
    SliverList forwardList = SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        return itemBuilder(index);
      }),
      key: center,
    );

    SliverList reverseList = SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        return itemBuilder(-index - 1);
      }),
    );

    return Scrollable(
      axisDirection: axisDirection ?? AxisDirection.down,
      controller: controller,
      physics: physics,
      viewportBuilder: (context, offset) {
        return Viewport(
          anchor: anchor ?? 0,
          axisDirection: axisDirection ?? AxisDirection.down,
          offset: offset,
          center: center,
          slivers: [
            reverseList,
            forwardList,
          ],
        );
      },
    );
  }
}

class BiInfiniteFixedSizePageList extends StatelessWidget {
  final Widget Function(int index) pageBuilder;

  /// The size of the page in pixel in main (scroll) axis.
  final double pageSizeInPixel;
  final AxisDirection direction;
  final ScrollController? controller;
  final void Function(int)? onPageChanged;
  const BiInfiniteFixedSizePageList(
      {required this.pageBuilder,
      required this.pageSizeInPixel,
      this.direction = AxisDirection.down,
      this.controller,
      this.onPageChanged,
      super.key});

  double widthFraction(BuildContext context) {
    switch (direction) {
      case AxisDirection.down:
      case AxisDirection.up:
        return pageSizeInPixel / MediaQuery.of(context).size.height;
      case AxisDirection.left:
      case AxisDirection.right:
        return pageSizeInPixel / MediaQuery.of(context).size.width;
    }
  }

  @override
  Widget build(BuildContext context) {
    // bind onPageChanged event to the controller
    final controller = this.controller ?? ScrollController();
    controller.addListener(() {
      if (onPageChanged != null) {
        onPageChanged!((controller.offset / pageSizeInPixel).round());
      }
    });
    // infinite list
    return BiInifiniteList(
      itemBuilder: (index) {
        return pageBuilder(index);
      },
      physics: FixiedWidthPageScrollPhysics(pageSizeInPixel: pageSizeInPixel),
      anchor: (1 - widthFraction(context)) / 2,
      axisDirection: direction,
      controller: controller,
    );
  }
}
