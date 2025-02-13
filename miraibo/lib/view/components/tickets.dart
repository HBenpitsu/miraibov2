import 'dart:math' show min;

import 'package:flutter/material.dart';
import 'package:miraibo/dto/dto.dart' as dto;

class Ticket extends StatelessWidget {
  final dto.Ticket data;
  const Ticket({required this.data, Key? key}) : super(key: key);

  static const double maxTicketWidth = 330;
  static const double minTicketHeight = 180;

  double width(BuildContext context) {
    return min(maxTicketWidth, MediaQuery.of(context).size.width);
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
        child: SizedBox(
            width: width(context),
            height: minTicketHeight,
            child: Card(
              color: Theme.of(context).colorScheme.primaryContainer,
            )));
  }
}
