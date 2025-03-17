import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'package:miraibo/dto/dto.dart' as dto;
import 'package:miraibo/view/shared/components/form_components/form_components.dart';
import 'package:miraibo/view/shared/components/valed_container.dart';
import 'package:miraibo/shared/enumeration.dart';

const sectionMargine = SizedBox(height: 10);
const lineMargine = SizedBox(height: 5);

Widget expands(Widget child) {
  return SizedBox(
    width: double.infinity,
    child: child,
  );
}

class ReceiptLogConfigSection extends StatefulWidget {
  final dto.ReceiptLogScheme initial;
  final List<dto.Category> categoryOptions;
  final List<dto.Currency> currencyOptions;
  final void Function(dto.ReceiptLogScheme) onChanged;
  const ReceiptLogConfigSection(
      {required this.initial,
      required this.categoryOptions,
      required this.currencyOptions,
      required this.onChanged,
      super.key});
  @override
  State<ReceiptLogConfigSection> createState() =>
      _ReceiptLogConfigSectionState();
}

class _ReceiptLogConfigSectionState extends State<ReceiptLogConfigSection> {
  late dto.ReceiptLogScheme _current;
  dto.ReceiptLogScheme get current => _current;
  set current(dto.ReceiptLogScheme value) {
    _current = value;
    widget.onChanged(value);
  }

  late final TextEditingController descriptionController;
  final FocusNode descriptionFocusNode = FocusNode();

  late final List<int> currencyIds;
  late final List<int> categoryIds;

  @override
  void initState() {
    super.initState();
    current = widget.initial;
    descriptionController = TextEditingController(text: current.description);
    currencyIds = widget.currencyOptions.map((e) => e.id).toList();
    categoryIds = widget.categoryOptions.map((e) => e.id).toList();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    var currencyIdx = currencyIds.indexOf(current.price.currencyId);
    if (currencyIdx == -1) currencyIdx = 0;
    var categoryIdx = categoryIds.indexOf(current.category.id);
    if (categoryIdx == -1) categoryIdx = 0;
    return Column(children: [
      sectionMargine,
      Text('Category', style: textTheme.headlineMedium),
      lineMargine,
      expands(
        SingleSelector<int>.fromTuple(
            initialIndex: categoryIdx,
            onChanged: (selected) {
              current =
                  current.copyWith(category: widget.categoryOptions[selected]);
            },
            items: widget.categoryOptions.map((e) => (e.name, e.id))),
      ),
      sectionMargine,
      Text('Description', style: textTheme.headlineMedium),
      lineMargine,
      CustomTextField(
        onEditCompleted: (text) {
          current = current.copyWith(description: text);
        },
        multiline: true,
        controller: descriptionController,
      ),
      sectionMargine,
      Text('How much', style: textTheme.headlineMedium),
      lineMargine,
      expands(MoneyPicker(
          initial: current.price.amount,
          onChanged: (amount) {
            current = current.copyWith(
                price: dto.ConfigureblePrice(
                    amount: amount,
                    currencyId: current.price.currencyId,
                    currencySymbol: current.price.currencySymbol));
          })),
      lineMargine,
      Row(
        children: [
          const Spacer(flex: 1),
          Text('In', style: textTheme.bodyLarge),
          const SizedBox(width: 10),
          Expanded(
              flex: 3,
              child: SingleSelector<int>.fromTuple(
                  initialIndex: currencyIdx,
                  onChanged: (index) {
                    final currency = widget.currencyOptions[index];
                    current = current.copyWith(
                        price: dto.ConfigureblePrice(
                            amount: current.price.amount,
                            currencyId: currency.id,
                            currencySymbol: currency.symbol));
                  },
                  items: widget.currencyOptions.indexed.map((e) => (
                        e.$2.symbol, e.$1, // this is the index
                      )))),
          const Spacer(flex: 1),
        ],
      ),
      sectionMargine,
      Text('On the date', style: textTheme.headlineMedium),
      lineMargine,
      expands(DatePicker(
          initial: current.date,
          onChanged: (date) {
            current = current.copyWith(date: date);
          })),
    ]);
  }
}

class PlanConfigSection extends StatefulWidget {
  final dto.PlanScheme initial;
  final List<dto.Category> categoryOptions;
  final List<dto.Currency> currencyOptions;
  final void Function(dto.PlanScheme) onChanged;
  const PlanConfigSection(
      {required this.initial,
      required this.categoryOptions,
      required this.currencyOptions,
      required this.onChanged,
      super.key});
  @override
  State<PlanConfigSection> createState() => _PlanConfigSectionState();
}

class _PlanConfigSectionState extends State<PlanConfigSection> {
  late dto.PlanScheme _current;
  dto.PlanScheme get current => _current;
  set current(dto.PlanScheme value) {
    _current = value;
    widget.onChanged(value);
  }

  late final TextEditingController descriptionController;
  final FocusNode descriptionFocusNode = FocusNode();
  late final List<int> currencyIds;
  late final List<int> categoryIds;

  @override
  void initState() {
    super.initState();
    current = widget.initial;
    descriptionController = TextEditingController(text: current.description);
    currencyIds = widget.currencyOptions.map((e) => e.id).toList();
    categoryIds = widget.categoryOptions.map((e) => e.id).toList();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    var currencyIdx = currencyIds.indexOf(current.price.currencyId);
    if (currencyIdx == -1) currencyIdx = 0;
    var categoryIdx = categoryIds.indexOf(current.category.id);
    if (categoryIdx == -1) categoryIdx = 0;
    return Column(children: [
      sectionMargine,
      Text('Category', style: textTheme.headlineMedium),
      lineMargine,
      expands(
        SingleSelector<int>.fromTuple(
            initialIndex: categoryIdx,
            onChanged: (selected) {
              current =
                  current.copyWith(category: widget.categoryOptions[selected]);
            },
            items: widget.categoryOptions.map((e) => (e.name, e.id))),
      ),
      sectionMargine,
      Text('Description', style: textTheme.headlineMedium),
      lineMargine,
      CustomTextField(
        onEditCompleted: (text) {
          current = current.copyWith(description: text);
        },
        multiline: true,
        controller: descriptionController,
      ),
      sectionMargine,
      Text('How much', style: textTheme.headlineMedium),
      lineMargine,
      expands(MoneyPicker(
          initial: current.price.amount,
          onChanged: (amount) {
            current = current.copyWith(
                price: dto.ConfigureblePrice(
                    amount: amount,
                    currencyId: current.price.currencyId,
                    currencySymbol: current.price.currencySymbol));
          })),
      lineMargine,
      Row(
        children: [
          const Spacer(flex: 1),
          Text('In', style: textTheme.bodyLarge),
          const SizedBox(width: 10),
          Expanded(
              flex: 3,
              child: SingleSelector<int>.fromTuple(
                  initialIndex: currencyIdx,
                  onChanged: (index) {
                    final currency = widget.currencyOptions[index];
                    current = current.copyWith(
                        price: dto.ConfigureblePrice(
                            amount: current.price.amount,
                            currencyId: currency.id,
                            currencySymbol: currency.symbol));
                  },
                  items: widget.currencyOptions.indexed.map((e) => (
                        e.$2.symbol, e.$1, // this is the index
                      )))),
          const Spacer(flex: 1),
        ],
      ),
      sectionMargine,
      Text('Schedule', style: textTheme.headlineMedium),
      _ScheduleSection(
          initial: current.schedule,
          onChanged: (schedule) {
            current = current.copyWith(schedule: schedule);
          })
    ]);
  }

  @override
  void dispose() {
    descriptionController.dispose();
    descriptionFocusNode.dispose();
    super.dispose();
  }
}

class _ScheduleSection extends StatefulWidget {
  final dto.Schedule initial;
  final void Function(dto.Schedule) onChanged;
  const _ScheduleSection({required this.initial, required this.onChanged});
  @override
  State<_ScheduleSection> createState() => _ScheduleSectionState();
}

class _ScheduleSectionState extends State<_ScheduleSection> {
  late dto.Schedule _current;
  dto.Schedule get current => _current;
  set current(dto.Schedule value) {
    _current = value;
    widget.onChanged(value);
  }

  late dto.OneshotSchedule oneshot;
  late dto.IntervalSchedule interval;
  late dto.WeeklySchedule weekly;
  late dto.MonthlySchedule monthly;
  late dto.AnnualSchedule annual;

  @override
  void initState() {
    super.initState();
    current = widget.initial;
    final dto.Date axis;
    switch (current) {
      case dto.OneshotSchedule(date: final date):
        axis = date;
      case dto.IntervalSchedule(originDate: final date):
        axis = date;
      case dto.WeeklySchedule(period: final period):
        axis = period.begins ?? period.ends ?? DateTime.now().cutOffTime();
      case dto.MonthlySchedule(period: final period):
        axis = period.begins ?? period.ends ?? DateTime.now().cutOffTime();
      case dto.AnnualSchedule(originDate: final date):
        axis = date;
    }
    oneshot = dto.OneshotSchedule(date: axis);
    interval = dto.IntervalSchedule(
        originDate: axis,
        period: const dto.OpenPeriod(begins: null, ends: null),
        interval: 1);
    weekly = const dto.WeeklySchedule(
        period: dto.OpenPeriod(begins: null, ends: null),
        sunday: false,
        monday: false,
        tuesday: false,
        wednesday: false,
        thursday: false,
        friday: false,
        saturday: false);
    monthly = const dto.MonthlySchedule(
        period: dto.OpenPeriod(begins: null, ends: null), offset: 0);
    annual = dto.AnnualSchedule(
        originDate: axis,
        period: const dto.OpenPeriod(begins: null, ends: null));
    switch (current) {
      case dto.OneshotSchedule current:
        oneshot = current;
      case dto.IntervalSchedule current:
        interval = current;
      case dto.WeeklySchedule current:
        weekly = current;
      case dto.MonthlySchedule current:
        monthly = current;
      case dto.AnnualSchedule current:
        annual = current;
    }
  }

  Widget buttons() {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        TextButton(
            onPressed: () {
              setState(() {
                current = oneshot;
              });
            },
            style: TextButton.styleFrom(
                backgroundColor: current is dto.OneshotSchedule
                    ? colorScheme.primaryContainer
                    : colorScheme.surfaceContainer),
            child: const Text('Oneshot')),
        const SizedBox(width: 5),
        TextButton(
            onPressed: () {
              setState(() {
                current = interval;
              });
            },
            style: TextButton.styleFrom(
                backgroundColor: current is dto.IntervalSchedule
                    ? colorScheme.primaryContainer
                    : colorScheme.surfaceContainer),
            child: const Text('Interval')),
        const SizedBox(width: 5),
        TextButton(
            onPressed: () {
              setState(() {
                current = weekly;
              });
            },
            style: TextButton.styleFrom(
                backgroundColor: current is dto.WeeklySchedule
                    ? colorScheme.primaryContainer
                    : colorScheme.surfaceContainer),
            child: const Text('Weekly')),
        const SizedBox(width: 5),
        TextButton(
            onPressed: () {
              setState(() {
                current = monthly;
              });
            },
            style: TextButton.styleFrom(
                backgroundColor: current is dto.MonthlySchedule
                    ? colorScheme.primaryContainer
                    : colorScheme.surfaceContainer),
            child: const Text('Monthly')),
        const SizedBox(width: 5),
        TextButton(
            onPressed: () {
              setState(() {
                current = annual;
              });
            },
            style: TextButton.styleFrom(
                backgroundColor: current is dto.AnnualSchedule
                    ? colorScheme.primaryContainer
                    : colorScheme.surfaceContainer),
            child: const Text('Annual')),
      ],
    );
  }

  Widget scheduler() {
    switch (current) {
      case dto.OneshotSchedule current:
        return _OneshotSchedule(
            initial: current,
            onChanged: (schedule) {
              oneshot = schedule;
              this.current = schedule;
            });
      case dto.IntervalSchedule current:
        return _IntervalSchedule(
            initial: current,
            onChanged: (schedule) {
              interval = schedule;
              this.current = schedule;
            });
      case dto.WeeklySchedule current:
        return _WeeklySchedule(
            initial: current,
            onChanged: (schedule) {
              weekly = schedule;
              this.current = schedule;
            });
      case dto.MonthlySchedule current:
        return _MonthlySchedule(
            initial: current,
            onChanged: (schedule) {
              monthly = schedule;
              this.current = schedule;
            });
      case dto.AnnualSchedule current:
        return _AnnualSchedule(
            initial: current,
            onChanged: (schedule) {
              annual = schedule;
              this.current = schedule;
            });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ScrollableLine(
            valeSize: 10,
            valeColor: Theme.of(context).colorScheme.surface,
            child: buttons()),
        lineMargine,
        AnimatedSwitcher(
            duration: const Duration(milliseconds: 300), child: scheduler())
      ],
    );
  }
}

class _OneshotSchedule extends StatefulWidget {
  final dto.OneshotSchedule initial;
  final void Function(dto.OneshotSchedule) onChanged;
  const _OneshotSchedule({required this.initial, required this.onChanged});
  @override
  State<_OneshotSchedule> createState() => _OneshotScheduleState();
}

class _OneshotScheduleState extends State<_OneshotSchedule> {
  late dto.OneshotSchedule current;
  @override
  void initState() {
    super.initState();
    current = widget.initial;
  }

  @override
  Widget build(BuildContext context) {
    return DatePicker(
        initial: current.date,
        onChanged: (date) {
          current = dto.OneshotSchedule(date: date);
          widget.onChanged(current);
        });
  }
}

class _IntervalSchedule extends StatefulWidget {
  final dto.IntervalSchedule initial;
  final void Function(dto.IntervalSchedule) onChanged;
  const _IntervalSchedule({required this.initial, required this.onChanged});
  @override
  State<_IntervalSchedule> createState() => _IntervalScheduleState();
}

class _IntervalScheduleState extends State<_IntervalSchedule> {
  late dto.IntervalSchedule _current;
  dto.IntervalSchedule get current => _current;
  set current(dto.IntervalSchedule value) {
    _current = value;
    widget.onChanged(value);
  }

  @override
  void initState() {
    super.initState();
    current = widget.initial;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Interval (in days)',
            style: Theme.of(context).textTheme.bodyLarge),
        lineMargine,
        expands(NumberPicker(
            initial: current.interval,
            min: 1,
            max: 365 * 200, // 200 years: virtually infinite
            steps: const [1, 10],
            onChanged: (interval) {
              current = current.copyWith(interval: interval);
            })),
        lineMargine,
        Text('Includes', style: Theme.of(context).textTheme.bodyLarge),
        lineMargine,
        expands(DatePicker(
          initial: current.originDate,
          onChanged: (date) {
            current = current.copyWith(originDate: date);
          },
        )),
        lineMargine,
        Text('Within', style: Theme.of(context).textTheme.bodyLarge),
        lineMargine,
        expands(OpenPeriodPicker(
            initial: current.period,
            onChanged: (period) {
              current = current.copyWith(period: period);
            })),
      ],
    );
  }
}

class _WeeklySchedule extends StatefulWidget {
  final dto.WeeklySchedule initial;
  final void Function(dto.WeeklySchedule) onChanged;
  const _WeeklySchedule({required this.initial, required this.onChanged});
  @override
  State<_WeeklySchedule> createState() => _WeeklyScheduleState();
}

class _WeeklyScheduleState extends State<_WeeklySchedule> {
  late dto.WeeklySchedule _current;
  dto.WeeklySchedule get current => _current;
  set current(dto.WeeklySchedule value) {
    _current = value;
    widget.onChanged(value);
  }

  @override
  void initState() {
    super.initState();
    current = widget.initial;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DayOfWeekSelector.fromDayNames(
            sunday: current.sunday,
            monday: current.monday,
            tuesday: current.tuesday,
            wednesday: current.wednesday,
            thursday: current.thursday,
            friday: current.friday,
            saturday: current.saturday,
            onChanged: (day) {
              current = current.copyWith(
                  sunday: day[0],
                  monday: day[1],
                  tuesday: day[2],
                  wednesday: day[3],
                  thursday: day[4],
                  friday: day[5],
                  saturday: day[6]);
            }),
        lineMargine,
        Text('Within', style: Theme.of(context).textTheme.bodyLarge),
        lineMargine,
        expands(OpenPeriodPicker(
            initial: current.period,
            onChanged: (period) {
              current = current.copyWith(period: period);
            })),
      ],
    );
  }
}

class _MonthlySchedule extends StatefulWidget {
  final dto.MonthlySchedule initial;
  final void Function(dto.MonthlySchedule) onChanged;
  const _MonthlySchedule({required this.initial, required this.onChanged});
  @override
  State<_MonthlySchedule> createState() => _MonthlyScheduleState();
}

class _MonthlyScheduleState extends State<_MonthlySchedule> {
  late dto.MonthlySchedule _current;
  dto.MonthlySchedule get current => _current;
  set current(dto.MonthlySchedule value) {
    _current = value;
    widget.onChanged(value);
  }

  @override
  void initState() {
    super.initState();
    current = widget.initial;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Offset from 1st day of month',
            style: Theme.of(context).textTheme.bodyLarge),
        lineMargine,
        expands(
          NumberPicker(
              initial: current.offset,
              min: -31,
              max: 31,
              steps: const [1, 5],
              onChanged: (offset) {
                current = current.copyWith(offset: offset);
              }),
        ),
        lineMargine,
        Text('Within', style: Theme.of(context).textTheme.bodyLarge),
        lineMargine,
        expands(OpenPeriodPicker(
            initial: current.period,
            onChanged: (period) {
              current = current.copyWith(period: period);
            })),
      ],
    );
  }
}

class _AnnualSchedule extends StatefulWidget {
  final dto.AnnualSchedule initial;
  final void Function(dto.AnnualSchedule) onChanged;
  const _AnnualSchedule({required this.initial, required this.onChanged});
  @override
  State<_AnnualSchedule> createState() => _AnnualScheduleState();
}

class _AnnualScheduleState extends State<_AnnualSchedule> {
  late dto.AnnualSchedule _current;
  dto.AnnualSchedule get current => _current;
  set current(dto.AnnualSchedule value) {
    _current = value;
    widget.onChanged(value);
  }

  @override
  void initState() {
    super.initState();
    current = widget.initial;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Within', style: Theme.of(context).textTheme.bodyLarge),
        lineMargine,
        expands(OpenPeriodPicker(
            initial: current.period,
            onChanged: (period) {
              current = current.copyWith(period: period);
            })),
        lineMargine,
        Text('Includes', style: Theme.of(context).textTheme.bodyLarge),
        lineMargine,
        expands(DatePicker(
            initial: current.originDate,
            onChanged: (date) {
              current = current.copyWith(originDate: date);
            })),
      ],
    );
  }
}

class EstimationConfigSection extends StatefulWidget {
  final dto.EstimationScheme initial;
  final List<dto.Category> categoryOptions;
  final List<dto.Currency> currencyOptions;
  final void Function(dto.EstimationScheme) onChanged;
  const EstimationConfigSection(
      {required this.initial,
      required this.categoryOptions,
      required this.currencyOptions,
      required this.onChanged,
      super.key});
  @override
  State<EstimationConfigSection> createState() =>
      _EstimationConfigSectionState();
}

class _EstimationConfigSectionState extends State<EstimationConfigSection> {
  late dto.EstimationScheme _current;
  dto.EstimationScheme get current => _current;
  set current(dto.EstimationScheme value) {
    _current = value;
    widget.onChanged(value);
  }

  @override
  void initState() {
    super.initState();
    current = widget.initial;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(children: [
      Text('Target Categories', style: textTheme.headlineMedium),
      lineMargine,
      expands(SingleSelector<dto.Category>.fromTuple(
          initialIndex: 0,
          items: widget.categoryOptions.map((cat) => (cat.name, cat)),
          onChanged: (selected) {
            current = current.copyWith(category: selected);
          })),
      sectionMargine,
      Text('Vaild during', style: textTheme.headlineMedium),
      lineMargine,
      expands(
        OpenPeriodPicker(
            initial: current.period,
            onChanged: (period) {
              current = current.copyWith(period: period);
            }),
      ),
      sectionMargine,
      Text('Display Currency', style: textTheme.headlineMedium),
      lineMargine,
      expands(
        SingleSelector<dto.Currency>.fromTuple(
            initialIndex: widget.currencyOptions.indexOf(current.currency),
            items: widget.currencyOptions.map((e) => (e.symbol, e)),
            onChanged: (selected) {
              current = current.copyWith(currency: selected);
            }),
      ),
      sectionMargine,
      Text('Display Option', style: textTheme.headlineMedium),
      lineMargine,
      expands(
        SingleSelector<EstimationDisplayOption>.fromTuple(
            initialIndex: current.displayOption.index,
            items: EstimationDisplayOption.values.map((e) => (
                  switch (e) {
                    EstimationDisplayOption.perDay => 'Average in days',
                    EstimationDisplayOption.perWeek => 'Average in weeks',
                    EstimationDisplayOption.perMonth => 'Average in months',
                    EstimationDisplayOption.perYear => 'Average in years',
                  },
                  e
                )),
            onChanged: (selected) {
              current = current.copyWith(displayOption: selected);
            }),
      ),
    ]);
  }
}

class MonitorConfigSection extends StatefulWidget {
  final dto.MonitorScheme initial;
  final List<dto.Category> categoryOptions;
  final List<dto.Currency> currencyOptions;
  final void Function(dto.MonitorScheme) onChanged;
  const MonitorConfigSection(
      {required this.initial,
      required this.categoryOptions,
      required this.currencyOptions,
      required this.onChanged,
      super.key});
  @override
  State<MonitorConfigSection> createState() => _MonitorConfigSectionState();
}

class _MonitorConfigSectionState extends State<MonitorConfigSection> {
  late dto.MonitorScheme _current;
  dto.MonitorScheme get current => _current;
  set current(dto.MonitorScheme value) {
    _current = value;
    widget.onChanged(value);
  }

  @override
  void initState() {
    super.initState();
    current = widget.initial;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(children: [
      Text('Target Categories', style: textTheme.headlineMedium),
      lineMargine,
      expands(
        MultiSelector<dto.Category>.fromTuple(
          items: widget.categoryOptions.map(
            (e) {
              final selected = current.categories.contains(e);
              return (e.name, e, selected);
            },
          ),
          onChanged: (selected, isAll) {
            current = current.copyWith(
                categories: selected, isAllCategoriesIncluded: isAll);
          },
          initiallyAllSelected: current.isAllCategoriesIncluded,
        ),
      ),
      sectionMargine,
      Text('Display Currency', style: textTheme.headlineMedium),
      lineMargine,
      expands(
        SingleSelector<dto.Currency>.fromTuple(
            initialIndex: widget.currencyOptions.indexOf(current.currency),
            items: widget.currencyOptions.map((e) => (e.symbol, e)),
            onChanged: (selected) {
              current = current.copyWith(currency: selected);
            }),
      ),
      sectionMargine,
      Text('Count', style: textTheme.headlineMedium),
      lineMargine,
      expands(
        OpenPeriodPicker(
            initial: current.period,
            onChanged: (period) {
              current = current.copyWith(period: period);
            }),
      ),
      sectionMargine,
      Text('Display Option', style: textTheme.headlineMedium),
      lineMargine,
      expands(
        SingleSelector<MonitorDisplayOption>.fromTuple(
            initialIndex: current.displayOption.index,
            items: MonitorDisplayOption.values.map((e) => (
                  switch (e) {
                    MonitorDisplayOption.meanInDays => 'Mean in days',
                    MonitorDisplayOption.meanInWeeks => 'Mean in weeks',
                    MonitorDisplayOption.meanInMonths => 'Mean in months',
                    MonitorDisplayOption.meanInYears => 'Mean in years',
                    MonitorDisplayOption.summation => 'Sum up all'
                  },
                  e
                )),
            onChanged: (selected) {
              current = current.copyWith(displayOption: selected);
            }),
      ),
    ]);
  }
}
