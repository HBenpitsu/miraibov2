import 'dart:math' show min;

import 'package:flutter/material.dart';
import 'package:miraibo/dto/dto.dart' as dto;
import 'package:miraibo/view/shared/components/ticket.dart';

class TicketContainer extends StatelessWidget {
  final Stream<List<dto.Ticket>> ticketsStream;
  static const double maxWidth = 350;
  final double width;
  final void Function(dto.Ticket) onTap;

  const TicketContainer(this.ticketsStream,
      {required this.onTap, required this.width, super.key});

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
                return InteractiveTicket(data: tickets[index], onTap: onTap);
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: double.infinity,
        width: min(width, maxWidth),
        child: ticketsColumn(context));
  }
}
