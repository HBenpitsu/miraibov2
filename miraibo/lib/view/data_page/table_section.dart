import 'dart:async';

import 'package:flutter/material.dart';
import 'package:miraibo/skeleton/data_page/data_page.dart' as skt;
import 'package:miraibo/dto/dto.dart' as dto;
import 'package:miraibo/view/shared/receipt_log_edit_window.dart';

class TableSection extends StatefulWidget {
  final skt.DataPage skeleton;
  final ScrollController parentalScrollCtl;
  final Stream<bool>
      scrollEventStream; // handle events from buttom navigation buttons
  final StreamController<bool> scrollLockNotifier; // handle scroll lock
  const TableSection(this.skeleton,
      {required this.parentalScrollCtl,
      required this.scrollEventStream,
      required this.scrollLockNotifier,
      super.key});

  @override
  State<StatefulWidget> createState() => _TableSectionState();
}

class _TableSectionState extends State<TableSection> {
  // custom list scroll physics
  final ScrollController tableScrollCtl = ScrollController();
  bool scrollable = false;

  @override
  void initState() {
    super.initState();

    // <custom list scroll physics>
    // listen to the scroll lock notifier
    widget.scrollLockNotifier.stream.listen((isLocked) {
      if (!mounted) return;
      setState(() {
        scrollable = isLocked;
      });
    });
    // implement scroll behavior such as
    // when the part of the list is in the view, the list itself is not scrollable.
    // It is scrolled only by the parent scroll.
    // when the whole part of the list is in the view, the list itself is scrollable.
    // also, when the list hits its top, the list's scroll is disabled.
    // This enables the parent to be scrolled.
    widget.parentalScrollCtl.addListener(() {
      if (widget.parentalScrollCtl.position.pixels ==
          widget.parentalScrollCtl.position.maxScrollExtent) {
        widget.scrollLockNotifier.add(true);
      }
    });
    tableScrollCtl.addListener(() {
      // needs to be delayed when update state
      // to avoid 'setState during build' error.
      if (tableScrollCtl.position.pixels == 0) {
        widget.scrollLockNotifier.add(false);
      }
    });

    // handle events from buttom navigation buttons
    widget.scrollEventStream.listen((isUp) {
      if (!mounted) return;
      if (isUp) {
        // go up the top of the page
        widget.scrollLockNotifier.add(false);

        widget.parentalScrollCtl.jumpTo(0);
        tableScrollCtl.jumpTo(0);
      } else {
        // go down the bottom of the page
        // when on the bottom of the page, scroll down the table.
        if (widget.parentalScrollCtl.position.pixels <
            widget.parentalScrollCtl.position.maxScrollExtent) {
          widget.parentalScrollCtl.animateTo(
              widget.parentalScrollCtl.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut);
        } else {
          final screenHeight = MediaQuery.of(context).size.height;
          tableScrollCtl.animateTo(
              tableScrollCtl.position.pixels + screenHeight,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut);
        }
      }
    });
    // </custom list scroll physics>
  }

  Widget list(BuildContext context, int listLength) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        hitTestBehavior: HitTestBehavior.opaque,
        physics: scrollable
            ? const AlwaysScrollableScrollPhysics()
            : const NeverScrollableScrollPhysics(),
        child: SizedBox(
            width: _TableRow.tableWidth,
            child: ListView.builder(
                physics: scrollable
                    ? const AlwaysScrollableScrollPhysics()
                    : const NeverScrollableScrollPhysics(),
                controller: tableScrollCtl,
                itemCount: listLength + 1, // +1 for header
                padding: EdgeInsets.only(top: 150, bottom: 150),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    // header
                    return _TableRow.header;
                  }
                  return _TableRow(widget.skeleton, index: index - 1);
                })));
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final content = StreamBuilder<int>(
      stream: widget.skeleton.getTableSize(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return list(context, snapshot.data!);
      },
    );
    // the list covers entire screen
    return SizedBox(
        height: screenHeight,
        // surpress indicator to avoid 'setState during build' error.
        child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (notification) {
              // if the table is scrolled down, do nothing.
              // (returning true means this does not consume the notification)
              if (tableScrollCtl.position.pixels > 0) return true;

              // When the overscroll is upward, disallow the indicator.
              // to avoid build during setState.
              notification.disallowIndicator();
              return false;
            },
            child: content));
  }

  @override
  void dispose() {
    tableScrollCtl.dispose();
    super.dispose();
  }
}

class _TableRow extends StatefulWidget {
  final int index;
  final skt.DataPage skeleton;

  static const double rowHeight = 30;

  static const double idFieldWidth = 100;
  static const double dateFieldWidth = 150;
  static const double categoryFieldWidth = 200;
  static const double descriptionFieldWidth = 400;
  static const double amountFieldWidth = 200;
  static const double currencyFieldWidth = 100;
  static const double confirmedFieldWidth = 100;

  static const headerContent = Row(children: [
    SizedBox(width: idFieldWidth, child: Center(child: Text('id'))),
    VerticalDivider(),
    SizedBox(width: dateFieldWidth, child: Center(child: Text('date'))),
    VerticalDivider(),
    SizedBox(width: categoryFieldWidth, child: Center(child: Text('category'))),
    VerticalDivider(),
    SizedBox(
        width: descriptionFieldWidth,
        child: Center(child: Text('description'))),
    VerticalDivider(),
    SizedBox(width: amountFieldWidth, child: Center(child: Text('amount'))),
    VerticalDivider(),
    SizedBox(width: currencyFieldWidth, child: Center(child: Text('currency'))),
    VerticalDivider(),
    SizedBox(
        width: confirmedFieldWidth, child: Center(child: Text('confirmed'))),
  ]);

  static const header = Column(children: [
    Divider(),
    SizedBox(height: rowHeight, child: headerContent),
    Divider(),
  ]);

  static double get tableWidth =>
      idFieldWidth +
      dateFieldWidth +
      categoryFieldWidth +
      descriptionFieldWidth +
      amountFieldWidth +
      currencyFieldWidth +
      confirmedFieldWidth +
      100;

  const _TableRow(this.skeleton, {required this.index});

  @override
  State<StatefulWidget> createState() => _TableRowState();
}

class _TableRowState extends State<_TableRow> {
  late final Stream receiptLogStream;
  late final StreamSubscription receiptLogSubscription;
  dto.ReceiptLogSchemeInstance? receiptLogSchemeInstance;

  @override
  void initState() {
    super.initState();
    receiptLogStream = widget.skeleton.getReceiptLog(widget.index);
    receiptLogSubscription = receiptLogStream.listen((receiptLog) {
      if (!mounted) return;
      setState(() {
        receiptLogSchemeInstance = receiptLog;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (receiptLogSchemeInstance == null) {
      return const Column(
          children: [SizedBox(height: _TableRow.rowHeight), Divider()]);
    }
    final date = receiptLogSchemeInstance!.date;
    final content = Row(children: [
      SizedBox(
          width: _TableRow.idFieldWidth,
          child: Center(child: Text(receiptLogSchemeInstance!.id.toString()))),
      const VerticalDivider(),
      SizedBox(
          width: _TableRow.dateFieldWidth,
          child: Center(child: Text('${date.year}-${date.month}-${date.day}'))),
      const VerticalDivider(),
      SizedBox(
          width: _TableRow.categoryFieldWidth,
          child: Center(child: Text(receiptLogSchemeInstance!.category.name))),
      const VerticalDivider(),
      SizedBox(
          width: _TableRow.descriptionFieldWidth,
          child: Center(child: Text(receiptLogSchemeInstance!.description))),
      const VerticalDivider(),
      SizedBox(
          width: _TableRow.amountFieldWidth,
          child: Center(
              child: Text(receiptLogSchemeInstance!.price.amount.toString()))),
      const VerticalDivider(),
      SizedBox(
          width: _TableRow.currencyFieldWidth,
          child: Center(
              child: Text(receiptLogSchemeInstance!.price.currencySymbol))),
      const VerticalDivider(),
      SizedBox(
          width: _TableRow.confirmedFieldWidth,
          child: Center(
              child: Text(receiptLogSchemeInstance!.confirmed.toString()))),
    ]);
    return Column(children: [
      GestureDetector(
          onTap: () {
            openReceiptLogEditWindow(
                context,
                widget.skeleton
                    .openReceiptLogEditWindow(receiptLogSchemeInstance!.id));
          },
          behavior: HitTestBehavior.opaque,
          child: SizedBox(height: _TableRow.rowHeight, child: content)),
      const Divider()
    ]);
  }

  @override
  void dispose() {
    receiptLogSubscription.cancel();
    super.dispose();
  }
}
