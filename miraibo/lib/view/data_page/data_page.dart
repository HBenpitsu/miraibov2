import 'package:flutter/material.dart';
import 'package:miraibo/skeleton/data_page/data_page.dart' as skt;
import 'package:miraibo/view/shared/constants.dart';
import 'package:miraibo/view/data_page/temporary_ticket_section.dart';
import 'package:miraibo/view/data_page/chart_section/chart_section.dart';

const sectorMargin = SizedBox(
  height: 20,
);

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

  bool scrollLock = false;

  late final ScrollController scrollCtl;
  late final _DataPageContent content;

  @override
  void initState() {
    super.initState();
    scrollCtl = ScrollController();
    content = _DataPageContent(widget.skeleton);
  }

  Widget get bottomBar {
    final screenHeight = MediaQuery.of(context).size.height;
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
        height: bottomNavigationBarHeight,
        child: Row(
          children: [
            Expanded(
                child: IconButton(
                    onPressed: () {
                      scrollCtl.animateTo(
                          scrollCtl.position.pixels - screenHeight,
                          duration: const Duration(seconds: 1),
                          curve: Curves.easeInOut);
                    },
                    icon: const Icon(Icons.arrow_upward))),
            Expanded(
                child: TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: scrollLock
                            ? colorScheme.primaryContainer
                            : colorScheme.surfaceContainer),
                    onPressed: () {
                      setState(() {
                        scrollLock = !scrollLock;
                        if (scrollLock) {
                          widget.scrollLock();
                        } else {
                          widget.scrollUnlock();
                        }
                      });
                    },
                    child: const Text('Scroll Lock'))),
            Expanded(
                child: IconButton(
                    onPressed: () {
                      scrollCtl.animateTo(
                          scrollCtl.position.pixels + screenHeight,
                          duration: const Duration(seconds: 1),
                          curve: Curves.easeInOut);
                    },
                    icon: const Icon(Icons.arrow_downward))),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SingleChildScrollView(
          physics: scrollLock ? const NeverScrollableScrollPhysics() : null,
          controller: scrollCtl,
          child: content),
      bottomNavigationBar: bottomBar,
    );
  }

  @override
  void dispose() {
    widget.skeleton.dispose();
    scrollCtl.dispose();
    super.dispose();
  }
}

class _DataPageContent extends StatefulWidget {
  final skt.DataPage skeleton;
  const _DataPageContent(this.skeleton);

  @override
  State<_DataPageContent> createState() => _DataPageContentState();
}

class _DataPageContentState extends State<_DataPageContent> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Chart', style: textTheme.headlineLarge),
        ChartSection(widget.skeleton),
        sectorMargin,
        Text('Temporary Ticket', style: textTheme.headlineLarge),
        TemporaryTicketSection(widget.skeleton),
        sectorMargin,
        Text('Operation Section'),
        sectorMargin,
        Text('Table Section'),
      ],
    );
  }
}
