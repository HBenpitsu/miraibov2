import 'package:flutter/material.dart';
import 'package:miraibo/skeleton/data_page/data_page.dart' as skt;
import 'package:miraibo/view/shared/constants.dart';
import 'package:miraibo/view/data_page/temporary_ticket_section.dart';
import 'package:miraibo/view/data_page/chart_section/chart_section.dart';

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
                child: _ScrollLockButton(
              scrollLock: () {
                widget.scrollLock();
                if (!mounted) return;
                setState(() {
                  scrollLock = true;
                });
              },
              scrollUnlock: () {
                widget.scrollUnlock();
                if (!mounted) return;
                setState(() {
                  scrollLock = false;
                });
              },
            )),
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

class _ScrollLockButton extends StatefulWidget {
  final void Function() scrollLock;
  final void Function() scrollUnlock;
  const _ScrollLockButton(
      {required this.scrollLock, required this.scrollUnlock});

  @override
  State<StatefulWidget> createState() => _ScrollLockButtonState();
}

class _ScrollLockButtonState extends State<_ScrollLockButton> {
  bool isLocked = false;

  @override
  Widget build(BuildContext context) {
    final text = SizedBox(
        width: 100,
        child: Center(child: Text(isLocked ? 'Unlock Scroll' : 'Lock Scroll')));
    final themeColor = Theme.of(context).colorScheme;
    final button = TextButton(
        onPressed: () {
          setState(() {
            isLocked = !isLocked;
            if (isLocked) {
              widget.scrollLock();
            } else {
              widget.scrollUnlock();
            }
          });
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
  const _DataPageContent(this.skeleton);

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
        Text('Operation Section'),
        sectorMargin,
        Text('Table Section'),
      ],
    );
  }
}
