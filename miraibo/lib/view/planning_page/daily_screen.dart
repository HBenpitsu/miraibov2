import 'dart:math' show min;

import 'package:flutter/material.dart';
import 'package:miraibo/skeleton/planning_page/planning_page.dart' as skt;
import 'package:miraibo/dto/dto.dart' as dto;
import 'package:miraibo/view/planning_page/bidirectional_infinite_list.dart';
import 'package:miraibo/view/planning_page/ticket_create_window.dart';
import 'package:miraibo/view/planning_page/ticket_edit_windows.dart';
import 'package:miraibo/view/shared/components/ticket_container.dart';
import 'package:miraibo/view/shared/constants.dart';
import 'package:miraibo/view/shared/receipt_log_edit_window.dart';
import 'package:miraibo/view/shared/receipt_log_confirmation_window.dart';
import 'package:miraibo/view/shared/monitor_scheme_edit_window.dart';

/// DailyScreen has an infinite horizontal list of TicketContainer widgets, container label and ticket creation button.
/// DailyScreen implement list-function. It updates label content. It instanciate the button as a floating button.

class DailyScreen extends StatefulWidget {
  final skt.DailyScreen skeleton;
  final void Function(skt.MonthlyScreen) navigateToMonthlyScreen;
  const DailyScreen(this.skeleton,
      {required this.navigateToMonthlyScreen, super.key});

  static const containerWidthRatio = 0.8;

  @override
  State<DailyScreen> createState() => _DailyScreenState();

  String getWeekdayString(int weekday) {
    switch (weekday) {
      case 1:
        return 'Mon.';
      case 2:
        return 'Tue.';
      case 3:
        return 'Wed.';
      case 4:
        return 'Thu.';
      case 5:
        return 'Fri.';
      case 6:
        return 'Sat.';
      case 7:
        return 'Sun.';
      default:
        return '---';
    }
  }
}

class _DailyScreenState extends State<DailyScreen> {
  double widthOfTicketContainer() => min(
      MediaQuery.of(context).size.width * DailyScreen.containerWidthRatio,
      TicketContainer.maxWidth);

  TextButton get label {
    final textTheme = Theme.of(context).textTheme;
    final labelContent = StreamBuilder(
        stream: widget.skeleton.getLabel(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            final date = data.asDateTime();
            return Text(
                "${date.year}-${date.month}-${date.day} (${widget.getWeekdayString(date.weekday)})",
                style: textTheme.displaySmall);
          }
          return Text('------', style: textTheme.displaySmall);
        });
    return TextButton(
        onPressed: () {
          widget.navigateToMonthlyScreen(
              widget.skeleton.navigateToMonthlyScreen());
        },
        child: labelContent);
  }

  BiInfiniteFixedSizePageList get ticketContainers {
    final widthOfTicketContainer = this.widthOfTicketContainer();
    return BiInfiniteFixedSizePageList(
        pageBuilder: (index) {
          return TicketContainer(widget.skeleton.getTicketsOn(index),
              width: widthOfTicketContainer,
              onTap: onTap,
              key: ValueKey(index));
        },
        pageSizeInPixel: widthOfTicketContainer,
        onPageChanged: (index) => widget.skeleton.setOffset(index),
        direction: AxisDirection.right);
  }

  void onTap(dto.Ticket ticket) {
    switch (ticket) {
      case dto.MonitorTicket ticket:
        openMonitorSchemeEditWindow(
            context, widget.skeleton.openMonitorSchemeEditWindow(ticket.id));
      case dto.EstimationTicket ticket:
        openEstimationSchemeEditWindow(
            context, widget.skeleton.openEstimationSchemeEditWindow(ticket.id));
      case dto.PlanTicket ticket:
        openPlanEditWindow(
            context, widget.skeleton.openPlanEditWindow(ticket.id));
      case dto.ReceiptLogTicket ticket:
        if (ticket.confirmed) {
          openReceiptLogEditWindow(
              context, widget.skeleton.openReceiptLogEditWindow(ticket.id));
        } else {
          openReceiptLogConfirmationWindow(context,
              widget.skeleton.openReceiptLogConfirmationWindow(ticket.id));
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          label,
          Expanded(child: ticketContainers),
        ],
      ),
      bottomNavigationBar: SizedBox(
          height: bottomNavigationBarHeight,
          child: Row(
            children: [
              const Spacer(),
              IconButton(
                  onPressed: () {
                    widget.navigateToMonthlyScreen(
                        widget.skeleton.navigateToMonthlyScreen());
                  },
                  icon: const Icon(Icons.arrow_circle_left)),
              const Spacer(),
              IconButton(
                  onPressed: () {
                    openTicketCreateWindow(
                        context, widget.skeleton.openTicketCreateWindow());
                  },
                  icon: const Icon(Icons.add)),
              const Spacer(),
            ],
          )),
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget.skeleton.dispose();
  }
}
