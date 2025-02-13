import 'dart:math' show min;

import 'package:flutter/material.dart';
import 'package:miraibo/skeleton/planning_page/planning_page.dart' as skt;
import 'package:miraibo/dto/dto.dart' as dto;
import 'package:miraibo/view/components/bidirectional_infinite_list.dart';
import 'package:miraibo/view/components/tickets.dart';

/// DailyScreen has an infinite horizontal list of TicketContainer widgets, container label and ticket creation button.
/// DailyScreen implement list-function. It updates label content. It instanciate the button as a floating button.

class DailyScreen extends StatelessWidget {
  final skt.DailyScreen skeleton;
  final void Function(skt.MonthlyScreen) navigateToMonthlyScreen;
  const DailyScreen(this.skeleton,
      {required this.navigateToMonthlyScreen, super.key});

  double widthOfTicketContainer(BuildContext context) =>
      min(MediaQuery.of(context).size.width * 0.8, TicketContainer.maxWidth);

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

  TextButton label(BuildContext context) {
    final labelContent = StreamBuilder(
        stream: skeleton.getLabel(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            final date = DateTime(data.year, data.month, data.day);
            return Text(
                "${date.year}-${date.month}-${date.day} (${getWeekdayString(date.weekday)})",
                style: Theme.of(context).textTheme.headlineSmall);
          }
          return Text('------',
              style: Theme.of(context).textTheme.headlineSmall);
        });
    return TextButton(
        onPressed: () {
          navigateToMonthlyScreen(skeleton.navigateToMonthlyScreen());
          skeleton.dispose();
        },
        child: labelContent);
  }

  BiInfiniteFixedSizePageList ticketContainers(BuildContext context) {
    final widthOfTicketContainer = this.widthOfTicketContainer(context);
    return BiInfiniteFixedSizePageList(
        pageBuilder: (index) {
          return TicketContainer(skeleton.getTicketsOn(index),
              width: widthOfTicketContainer);
        },
        pageSizeInPixel: widthOfTicketContainer,
        onPageChanged: (index) => skeleton.setOffset(index),
        direction: AxisDirection.right);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        label(context),
        Expanded(child: ticketContainers(context)),
      ],
    );
  }
}

class TicketContainer extends StatelessWidget {
  final Stream<List<dto.Ticket>> ticketsStream;
  static const double maxWidth = 350;
  final double width;

  const TicketContainer(this.ticketsStream, {required this.width, super.key});

  StreamBuilder ticketsColumn(BuildContext context) {
    return StreamBuilder<List<dto.Ticket>>(
        stream: ticketsStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error: failed to load tickets'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.isEmpty) {
            return const Center(child: Text('No tickets'));
          }
          final tickets = snapshot.data!;
          return ListView.builder(
              itemCount: tickets.length,
              itemBuilder: (context, index) {
                return Ticket(data: tickets[index]);
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: double.infinity, width: width, child: ticketsColumn(context));
  }
}
