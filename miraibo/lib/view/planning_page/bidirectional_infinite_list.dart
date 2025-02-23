import 'package:flutter/material.dart';
import 'package:miraibo/view/planning_page/motion.dart';

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

class BiInfiniteFixedSizePageList extends StatefulWidget {
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

  @override
  State<BiInfiniteFixedSizePageList> createState() =>
      _BiInfiniteFixedSizePageListState();
}

class _BiInfiniteFixedSizePageListState
    extends State<BiInfiniteFixedSizePageList> {
  late final ScrollController controller =
      widget.controller ?? ScrollController();
  int currentPage = 0;
  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      if (widget.onPageChanged == null) return;
      final page = (controller.offset / widget.pageSizeInPixel).round();
      if (currentPage == page) return;
      currentPage = page;
      widget.onPageChanged!(page);
    });
  }

  @override
  Widget build(BuildContext context) {
    // infinite list
    return BiInifiniteList(
      itemBuilder: (index) {
        return widget.pageBuilder(index);
      },
      physics:
          FixiedWidthPageScrollPhysics(pageSizeInPixel: widget.pageSizeInPixel),
      anchor: (1 - widthFraction()) / 2,
      axisDirection: widget.direction,
      controller: controller,
    );
  }

  double widthFraction() {
    switch (widget.direction) {
      case AxisDirection.down:
      case AxisDirection.up:
        return widget.pageSizeInPixel / MediaQuery.of(context).size.height;
      case AxisDirection.left:
      case AxisDirection.right:
        return widget.pageSizeInPixel / MediaQuery.of(context).size.width;
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
