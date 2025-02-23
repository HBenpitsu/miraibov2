import 'dart:async';
import 'package:flutter/material.dart';
import 'package:miraibo/skeleton/data_page/data_page.dart' as skt;
import 'package:miraibo/dto/dto.dart' as dto;
import 'package:miraibo/view/shared/components/ticket.dart';

class TemporaryTicketSection extends StatefulWidget {
  final skt.DataPage skeleton;
  const TemporaryTicketSection(this.skeleton, {super.key});

  @override
  State<TemporaryTicketSection> createState() => _TemporaryTicketSectionState();
}

class _TemporaryTicketSectionState extends State<TemporaryTicketSection> {
  late final StreamSubscription<skt.TemporaryTicket> ticketSubscription;
  late skt.TemporaryTicket ticket;

  @override
  void initState() {
    super.initState();
    ticket = skt.TemporaryTicketUnspecified();
    ticketSubscription = widget.skeleton.getTemporaryTicket().listen((ticket) {
      setState(() {
        this.ticket = ticket;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: switch (ticket) {
        skt.TemporaryTicketUnspecified _ => TicketAppearanceTemplate(
            ticketType: 'unconfigured',
            categories: [''],
            amount: 0,
            currencySymbol: '',
            description: 'Tap to configure',
            timeInfo: ''),
        skt.TemporaryMonitorTicket ticket => Text('Temporary Ticket: $ticket'),
        skt.TemporaryEstimationTicket ticket =>
          Text('Temporary Ticket: $ticket'),
      },
    );
  }

  @override
  void dispose() {
    ticketSubscription.cancel();
    super.dispose();
  }
}

class Ticket extends StatelessWidget {
  final dto.Ticket data;
  final void Function(dto.Ticket) onTap;
  const Ticket({required this.data, required this.onTap, super.key});

  static const double maxTicketWidth = 330;

  Widget content(BuildContext context) {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(data),
      child: content(context),
    );
  }
}
