import 'package:flutter/material.dart';
import 'package:miraibo/view/main_page/receipt_log_create_window.dart';
import 'package:miraibo/view/shared/components/ticket_container.dart';
import 'package:miraibo/skeleton/main_page/main_page.dart' as skt;
import 'package:miraibo/dto/dto.dart' as dto;
import 'package:miraibo/view/shared/constants.dart';
import 'package:miraibo/view/shared/receipt_log_confirmation_window.dart';
import 'package:miraibo/view/shared/receipt_log_edit_window.dart';
import 'package:miraibo/view/shared/monitor_scheme_edit_window.dart';

class MainPage extends StatefulWidget {
  final skt.MainPage skeleton;
  const MainPage(this.skeleton, {super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Future<Widget> ticketList() async {
    final width = MediaQuery.of(context).size.width * 0.9;
    return TicketContainer(
      widget.skeleton.getTickets(),
      onTap: (ticket) {
        switch (ticket) {
          case dto.ReceiptLogTicket ticket:
            if (ticket.confirmed) {
              openReceiptLogEditWindow(
                  context, widget.skeleton.openReceiptLogEditWindow(ticket.id));
            } else {
              openReceiptLogConfirmationWindow(context,
                  widget.skeleton.openReceiptLogConfirmationWindow(ticket.id));
            }
          case dto.MonitorTicket ticket:
            openMonitorSchemeEditWindow(context,
                widget.skeleton.openMonitorSchemeEditWindow(ticket.id));
          case dto.PlanTicket _:
          case dto.EstimationTicket _:
            throw Exception('those tickets should not be shown here');
        }
      },
      width: width,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: FutureBuilder(
              future: ticketList(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data!;
                } else {
                  return const CircularProgressIndicator();
                }
              })),
      bottomNavigationBar: SizedBox(
        height: bottomNavigationBarHeight,
        child: Row(
          children: [
            const Spacer(),
            IconButton(
              onPressed: () {
                openReceiptLogCreateWindow(
                    context, widget.skeleton.openReceiptLogCreateWindow());
              },
              icon: const Icon(Icons.add),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget.skeleton.dispose();
    super.dispose();
  }
}
