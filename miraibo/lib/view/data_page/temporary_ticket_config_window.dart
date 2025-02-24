import 'package:flutter/material.dart';
import 'package:miraibo/skeleton/data_page/temporary_ticket_config_window/temporary_ticket_config_window.dart'
    as skt;
import 'package:miraibo/view/shared/components/modal_window.dart';

void openTemporaryTicketConfigWindow(
    BuildContext context, skt.TemporaryTicketConfigWindow skeleton) {
  showDialog(
      context: context,
      builder: (context) {
        return TemporaryTicketConfigWindow(skeleton);
      });
}

class TemporaryTicketConfigWindow extends StatefulWidget {
  final skt.TemporaryTicketConfigWindow skeleton;
  const TemporaryTicketConfigWindow(this.skeleton, {super.key});

  @override
  State<StatefulWidget> createState() => _TemporaryTicketConfigWindowState();
}

class _TemporaryTicketConfigWindowState
    extends State<TemporaryTicketConfigWindow> {
  @override
  Widget build(BuildContext context) {
    return ModalWindowContainer(child: Container());
  }
}
