import 'package:flutter/material.dart';
import 'package:miraibo/dto/dto.dart' as dto;
import 'package:miraibo/view/shared/form_components/form_components.dart';
import 'package:miraibo/view/shared/form_components/multi_selector.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Future<ListView> ticketList() async {
    final today = DateTime.now();
    final aYearAgo = DateTime(today.year - 1, today.month, today.day);
    final aYearLater = DateTime(today.year + 1, today.month, today.day);
    return ListView(
      children: [
        DatePicker(
          initial: dto.Date(today.year, today.month, today.day),
          onChanged: (date) {
            print('${date.year}-${date.month}-${date.day}');
          },
        ),
        OpenPeriodPicker(
            initial: const dto.OpenPeriod(begins: null, ends: null),
            onChanged: (period) {
              switch ((period.begins, period.ends)) {
                case (dto.Date begins, dto.Date ends):
                  print(
                      '${begins.year}-${begins.month}-${begins.day} to ${ends.year}-${ends.month}-${ends.day}');
                case (dto.Date begins, null):
                  print('from ${begins.year}-${begins.month}-${begins.day}');
                case (null, dto.Date ends):
                  print('until ${ends.year}-${ends.month}-${ends.day}');
                case (null, null):
                  print('all the time');
              }
            }),
        DayOfWeekSelector.fromDayNames(
          sunday: true,
          monday: true,
          tuesday: true,
          wednesday: true,
          thursday: true,
          friday: true,
          saturday: true,
          onChanged: (selection) {
            print(selection);
          },
        ),
        ClosedPeriodPicker(
            initial: dto.ClosedPeriod(
                begins: dto.Date(aYearAgo.year, aYearAgo.month, aYearAgo.day),
                ends: dto.Date(
                    aYearLater.year, aYearLater.month, aYearLater.day)),
            onChanged: (period) {
              print(
                  '${period.begins.year}-${period.begins.month}-${period.begins.day} to ${period.ends.year}-${period.ends.month}-${period.ends.day}');
            }),
        NumberPicker(
            initial: 0,
            min: -31,
            max: 31,
            steps: const [1, 5],
            onChanged: (number) {
              print(number);
            }),
        MoneyPicker(
            initial: 0,
            memos: const [100, 1000, 1230],
            onChanged: (value) {
              print(value);
            }),
        MultiSelector.fromTuple(
            items: [for (var i = 0; i < 200; i++) ('item あ $i', i, i.isEven)],
            onChanged: (value) {
              print(value);
            })
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: ticketList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data!;
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
