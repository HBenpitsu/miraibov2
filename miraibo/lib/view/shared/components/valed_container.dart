import 'package:flutter/material.dart';

class ValedContainer extends StatelessWidget {
  /// child should have a fixed size
  final Widget child;
  final EdgeInsets valeSize;
  final Color valeColor;

  const ValedContainer(
      {required this.child,
      required this.valeSize,
      required this.valeColor,
      super.key});

  @override
  Widget build(BuildContext context) {
    final upperVale = Container(
      height: valeSize.top,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [valeColor, valeColor.withOpacity(0)]),
      ),
    );
    final lowerVale = Container(
      height: valeSize.bottom,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [valeColor, valeColor.withOpacity(0)]),
      ),
    );
    final rightVale = Container(
      width: valeSize.right,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            colors: [valeColor, valeColor.withOpacity(0)]),
      ),
    );
    final leftVale = Container(
      width: valeSize.left,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [valeColor, valeColor.withOpacity(0)]),
      ),
    );
    final valedContent = Stack(children: [
      child,
      Positioned(top: 0, left: 0, right: 0, child: upperVale),
      Positioned(bottom: 0, left: 0, right: 0, child: lowerVale),
      Positioned(left: 0, top: 0, bottom: 0, child: leftVale),
      Positioned(right: 0, top: 0, bottom: 0, child: rightVale)
    ]);
    return Center(child: valedContent);
  }
}

class ValedList extends StatelessWidget {
  final double upperValeHeight;
  final double lowerValeHeight;
  final Color valeColor;
  final int itemCount;
  final Widget Function(BuildContext, int) builder;

  const ValedList(
      {required this.upperValeHeight,
      required this.lowerValeHeight,
      required this.valeColor,
      required this.itemCount,
      required this.builder,
      super.key});

  @override
  Widget build(BuildContext context) {
    return ValedContainer(
      valeSize: EdgeInsets.only(top: upperValeHeight, bottom: lowerValeHeight),
      valeColor: valeColor,
      child: ListView.builder(
        itemBuilder: (context, index) {
          // the first item is a dummy to avoid vale at the top
          if (index == 0) {
            return SizedBox(height: upperValeHeight);
          }
          // omit the dummy item from the index
          index -= 1;

          // the last item is a dummy to avoid vale at the bottom
          if (index == itemCount) {
            return SizedBox(height: lowerValeHeight);
          }

          // return null when the index is out of range
          if (index > itemCount) {
            return null;
          }

          return builder(context, index);
        },
      ),
    );
  }
}

class ScrollableLine extends StatelessWidget {
  final Widget child;
  final double valeSize;
  final Color valeColor;

  const ScrollableLine(
      {required this.child,
      required this.valeSize,
      required this.valeColor,
      super.key});

  @override
  Widget build(BuildContext context) {
    return ValedContainer(
      valeSize: EdgeInsets.symmetric(horizontal: valeSize),
      valeColor: valeColor,
      child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: valeSize),
              child: child)),
    );
  }
}
