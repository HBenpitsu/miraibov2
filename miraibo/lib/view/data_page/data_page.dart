import 'dart:async';

import 'package:flutter/material.dart';
import 'package:miraibo/skeleton/data_page/data_page.dart' as skt;
import 'package:miraibo/view/shared/constants.dart';
import 'package:miraibo/view/data_page/temporary_ticket_section.dart';
import 'package:miraibo/view/data_page/chart_section/chart_section.dart';
import 'package:miraibo/view/data_page/operation_section.dart';
import 'package:miraibo/view/data_page/table_section.dart';

const sectorMargin = SizedBox(height: 20);

class DataPage extends StatefulWidget {
  final skt.DataPage skeleton;
  final void Function() scrollLock;
  final void Function() scrollUnlock;
  static const pagePadding = EdgeInsets.symmetric(horizontal: 20);
  const DataPage(this.skeleton,
      {required this.scrollLock, required this.scrollUnlock, super.key});

  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool isScrollLocked = false;

  late final ScrollController scrollCtl;
  late final Widget content;

  /// add true when the user wants to scroll up.
  /// add false when the user wants to scroll down.
  late final Sink<bool> scrollEventSink;

  late final StreamController<bool> scrollLockEventNotifier;

  @override
  void initState() {
    super.initState();
    scrollCtl = ScrollController();
    final scrollEventNotifier = StreamController<bool>();
    scrollEventSink = scrollEventNotifier.sink;
    scrollLockEventNotifier = StreamController<bool>.broadcast();
    scrollLockEventNotifier.stream.listen((isLocked) {
      if (isLocked) {
        widget.scrollLock();
      } else {
        widget.scrollUnlock();
      }
      if (!mounted) return;
      setState(() {
        isScrollLocked = isLocked;
      });
    });
    content = _DataPageContent(
      widget.skeleton,
      // scrolling physics is heavily depends on the table section, so it is passed here.
      pageScrollCtl: scrollCtl,
      scrollEventStream: scrollEventNotifier.stream,
      scrollLockNotifier: scrollLockEventNotifier,
    );
  }

  void goUp() => scrollEventSink.add(true);

  void goDown() => scrollEventSink.add(false);

  Widget get bottomBar {
    return SizedBox(
        height: bottomNavigationBarHeight,
        child: Row(
          children: [
            Expanded(
                child: IconButton(
                    onPressed: goUp, icon: const Icon(Icons.autorenew))),
            Expanded(
                child: _ScrollLockButton(
                    scrollLockNotifier: scrollLockEventNotifier)),
            Expanded(
                child: IconButton(
                    onPressed: goDown, icon: const Icon(Icons.arrow_downward))),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (notification) {
            // if the page is scrolled up, do nothing.
            if (scrollCtl.position.pixels <= 0) return false;
            // otherwise, disallow the indicator.
            // to avoid 'setState during build' error.
            notification.disallowIndicator();
            return false;
          },
          child: SingleChildScrollView(
              physics:
                  isScrollLocked ? const NeverScrollableScrollPhysics() : null,
              controller: scrollCtl,
              child: content)),
      bottomNavigationBar: bottomBar,
    );
  }

  @override
  void dispose() {
    widget.skeleton.dispose();
    scrollCtl.dispose();
    scrollEventSink.close();
    super.dispose();
  }
}

class _ScrollLockButton extends StatefulWidget {
  final StreamController<bool> scrollLockNotifier;
  const _ScrollLockButton({required this.scrollLockNotifier});

  @override
  State<StatefulWidget> createState() => _ScrollLockButtonState();
}

class _ScrollLockButtonState extends State<_ScrollLockButton> {
  bool isLocked = false;

  @override
  void initState() {
    super.initState();
    widget.scrollLockNotifier.stream.listen((isLocked) {
      if (!mounted) return;
      setState(() {
        this.isLocked = isLocked;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final text = SizedBox(
        width: 100,
        child: Center(child: Text(isLocked ? 'Unlock Scroll' : 'Lock Scroll')));
    final themeColor = Theme.of(context).colorScheme;
    final button = TextButton(
        onPressed: () {
          widget.scrollLockNotifier.add(!isLocked);
        },
        style: TextButton.styleFrom(
          backgroundColor: isLocked
              ? themeColor.primaryContainer
              : themeColor.surfaceContainer,
        ),
        child: text);
    return Padding(padding: EdgeInsets.all(actionButtonPadding), child: button);
  }
}

class _DataPageContent extends StatelessWidget {
  final skt.DataPage skeleton;
  final ScrollController pageScrollCtl;
  final Stream<bool> scrollEventStream;
  final StreamController<bool> scrollLockNotifier;
  const _DataPageContent(this.skeleton,
      {required this.scrollEventStream,
      required this.pageScrollCtl,
      required this.scrollLockNotifier});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Chart', style: textTheme.headlineLarge),
        ChartSection(skeleton),
        sectorMargin,
        Text('Temporary Ticket', style: textTheme.headlineLarge),
        TemporaryTicketSection(skeleton),
        sectorMargin,
        Text('Data Operations', style: textTheme.headlineLarge),
        OperationSection(skeleton),
        sectorMargin,
        Text('Table Section', style: textTheme.headlineLarge),
        TableSection(
          skeleton,
          parentalScrollCtl: pageScrollCtl,
          scrollEventStream: scrollEventStream,
          scrollLockNotifier: scrollLockNotifier,
        ),
      ],
    );
  }
}
