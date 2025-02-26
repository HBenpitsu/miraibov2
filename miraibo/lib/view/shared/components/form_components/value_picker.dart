import 'package:flutter/scheduler.dart';
import 'package:function_tree/function_tree.dart';
import 'package:flutter/material.dart';
import 'package:miraibo/view/shared/components/form_components/custom_text_field.dart';
import 'package:miraibo/view/shared/components/form_components/shared_constants.dart';

// <NumberPicker>
/// A widget to select a number from min to max
/// It provides numberfield and a row of buttons to increase and decrease the number by given steps
class NumberPicker extends StatefulWidget {
  final int initial;
  final int min;
  final int max;
  final List<int> steps;
  final void Function(int) onChanged;
  const NumberPicker(
      {required this.initial,
      required this.min,
      required this.max,
      required this.steps,
      required this.onChanged,
      super.key});

  @override
  State<NumberPicker> createState() => _NumberPickerState();
}

class _NumberPickerState extends State<NumberPicker> {
  late int _current;
  int get current => _current;
  set current(int number) {
    _current = number;
    textCtl.text = _current.toString();
    widget.onChanged(_current);
  }

  late final TextEditingController textCtl;

  @override
  void initState() {
    super.initState();
    _current = widget.initial;
    textCtl = TextEditingController(text: _current.toString());
  }

  List<Widget> incrementButtons() {
    final style = TextButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        minimumSize: const Size(formChipHeight, formChipHeight));
    return [
      for (final step in widget.steps) ...[
        const SizedBox(width: 2), // padding
        TextButton(
            onPressed: () {
              current = (current + step).clamp(widget.min, widget.max);
            },
            style: style,
            child: Text('+$step'))
      ]
    ];
  }

  List<Widget> decrementButtons() {
    final style = TextButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        minimumSize: const Size(formChipHeight, formChipHeight));
    return [
      for (final step in widget.steps.reversed) ...[
        TextButton(
            onPressed: () {
              current = (current - step).clamp(widget.min, widget.max);
            },
            style: style,
            child: Text('-$step')),
        const SizedBox(width: 2) // padding
      ]
    ];
  }

  Widget numberField() {
    return CustomTextField(
        controller: textCtl,
        keyboardType: TextInputType.number,
        onEditCompleted: (text) {
          final number = int.tryParse(text);
          if (number == null) {
            textCtl.text = current.toString();
            return;
          }
          current = number.clamp(widget.min, widget.max);
        });
  }

  @override
  Widget build(BuildContext context) {
    final mainContent = Row(
      children: [
        ...decrementButtons(),
        Expanded(child: numberField()),
        ...incrementButtons(),
      ],
    );
    return Padding(
        padding: const EdgeInsets.all(formChipPadding), child: mainContent);
  }

  @override
  void dispose() {
    textCtl.dispose();
    super.dispose();
  }
}
// </NumberPicker>

// <MoneyPicker>
/// A widget to input a number as a money
/// nagative number is allowed. It will be interpreted as income
class MoneyPicker extends StatefulWidget {
  final int initial;
  final List<int>? memos;
  final void Function(int) onChanged;
  static const ioLabelWidth = 90.0;
  const MoneyPicker(
      {required this.initial, this.memos, required this.onChanged, super.key});

  @override
  State<MoneyPicker> createState() => _MoneyPickerState();
}

class _MoneyPickerState extends State<MoneyPicker> {
  late int _current;
  int get current => _current;
  set current(int value) {
    setState(() {
      _current = value;
      textCtl.text = _current.abs().toString();
      widget.onChanged(_current);
    });
  }

  late final TextEditingController textCtl;
  final FocusNode fieldFocus = FocusNode();
  @override
  void initState() {
    super.initState();
    _current = widget.initial;
    textCtl = TextEditingController(text: widget.initial.toString());
  }

  int get sign => _current < 0 ? -1 : 1;

  Widget ioLabel() {
    final isIncome = current < 0;

    // calc style
    final colorScheme = Theme.of(context).colorScheme;
    final style = TextButton.styleFrom(
        backgroundColor: isIncome
            ? colorScheme.primaryContainer
            : colorScheme.surfaceContainer,
        minimumSize: const Size(MoneyPicker.ioLabelWidth, formChipHeight));

    // calc label
    final String labelString;
    if (current == 0) {
      labelString = '';
    } else {
      labelString = isIncome ? 'income' : 'outcome';
    }

    return TextButton(
        onPressed: () {
          current = -current;
        },
        style: style,
        child: Text(labelString));
  }

  Widget numberField() {
    return CustomTextField(
        focusNode: fieldFocus,
        controller: textCtl,
        keyboardType: TextInputType.number,
        onEditCompleted: (text) {
          final number = int.tryParse(text);
          if (number == null) {
            textCtl.text = current.abs().toString();
            return;
          }
          // if [current] express income (=current is negative) now, the negative number expresses outcome
          // if [current] express outcome (=current is positive) now, the nagative number expresses income
          current = number * sign;
          fieldFocus.unfocus();
        });
  }

  Widget overwriteButton() {
    final style = TextButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        minimumSize: const Size(formChipHeight, formChipHeight));
    return TextButton(
        onPressed: () {
          textCtl.selection =
              TextSelection(baseOffset: 0, extentOffset: textCtl.text.length);
          fieldFocus.requestFocus();
        },
        style: style,
        child: const Icon(Icons.edit));
  }

  Widget openCalculatorButton() {
    final style = TextButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        minimumSize: const Size(formChipHeight, formChipHeight));
    return TextButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return _InAppCalculatorWindow(
                    initial: current.toString(),
                    memos: [current, ...widget.memos ?? []],
                    onApply: (value) {
                      current = value;
                    });
              });
        },
        style: style,
        child: const Icon(Icons.calculate));
  }

  @override
  Widget build(BuildContext context) {
    final mainContent = Row(
      children: [
        ioLabel(),
        Expanded(child: numberField()),
        overwriteButton(),
        const SizedBox(width: 2), //padding
        openCalculatorButton()
      ],
    );
    return Padding(
        padding: const EdgeInsets.all(formChipPadding), child: mainContent);
  }

  @override
  void dispose() {
    textCtl.dispose();
    super.dispose();
  }
}

class _InAppCalculatorWindow extends StatefulWidget {
  final String initial;
  final List<int> memos;
  final void Function(int) onApply;
  const _InAppCalculatorWindow(
      {required this.initial, required this.memos, required this.onApply});

  @override
  State<_InAppCalculatorWindow> createState() => _InAppCalculatorWindowState();
}

class _InAppCalculatorWindowState extends State<_InAppCalculatorWindow> {
  late String _expression;
  String get expression => _expression;
  set expression(String value) {
    setState(() {
      _expression = value;
      expressionFieldTextCtl.text = _expression;
    });
  }

  /// the maximum number that can be interpreted correctly
  static const maximumNumber = 10000000000000000;

  int? getResult() {
    try {
      final result = expression.interpret().toInt();
      if (result.isNaN || result >= maximumNumber) return null;
      return result;
    } catch (e) {
      return null;
    }
  }

  late final TextEditingController expressionFieldTextCtl;
  late final Widget keyBoardCache;
  late final Widget memosCache;
  final GlobalKey expressionFieldKey = GlobalKey();
  final FocusNode expressionFieldFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _expression = widget.initial;
    expressionFieldTextCtl = TextEditingController(text: widget.initial);
    keyBoardCache = keyboard();
    memosCache =
        _Memos(memos: widget.memos, onTap: (memo) => insert(memo.toString()));
  }

  void insert(String value) async {
    // insertion
    final selection = expressionFieldTextCtl.selection;
    if (!selection.isValid) {
      expression += value;
      return;
    }
    final before = expression.substring(0, selection.start);
    final after = expression.substring(selection.end);
    final cursor = before.length + value.length;
    expression = before + value + after;

    // scroll
    // we should wait a little to get 'expression' reflacted to the text field
    // otherwise, scroll offset will be outdated just after scrolling
    SchedulerBinding.instance.addPostFrameCallback((_) {
      expressionFieldFocusNode.requestFocus();
      expressionFieldTextCtl.selection =
          TextSelection.collapsed(offset: cursor);

      if (expressionFieldKey.currentState == null) return;

      final state = expressionFieldKey.currentState as EditableTextState;
      state.bringIntoView(TextPosition(offset: cursor));
    });
  }

  void delete() async {
    // deletion
    if (expression.isEmpty) return;
    final selection = expressionFieldTextCtl.selection;
    if (!selection.isValid) {
      final cursor = expression.length - 1;
      expression = expression.substring(0, expression.length - 1);
      expressionFieldTextCtl.selection =
          TextSelection.collapsed(offset: cursor);
      return;
    }
    if (selection.start != selection.end) {
      final cursor = selection.start;
      expression = expression.replaceRange(selection.start, selection.end, '');
      expressionFieldTextCtl.selection =
          TextSelection.collapsed(offset: cursor);
      return;
    }
    if (selection.start == 0) {
      const cursor = 0;
      expression = expression.substring(1);
      expressionFieldTextCtl.selection =
          const TextSelection.collapsed(offset: cursor);
      return;
    }
    final cursor = selection.start - 1;
    expression = expression.replaceRange(cursor, cursor + 1, '');
    expressionFieldTextCtl.selection = TextSelection.collapsed(offset: cursor);

    // scroll
    // we should wait a little to get 'expression' reflacted to the text field
    // otherwise, scroll offset will be outdated just after scrolling
    SchedulerBinding.instance.addPostFrameCallback((_) {
      expressionFieldFocusNode.requestFocus();
      expressionFieldTextCtl.selection =
          TextSelection.collapsed(offset: cursor);

      if (expressionFieldKey.currentState == null) return;

      final state = expressionFieldKey.currentState as EditableTextState;
      state.bringIntoView(TextPosition(offset: cursor));
    });
  }

  Widget keyboard() {
    return _KeyBoard(
      onApply: () {
        final result = getResult();
        if (result == null) return;
        widget.onApply(result);
        Navigator.of(context).pop();
      },
      onClear: () => expression = '',
      onDel: delete,
      onKey: insert,
    );
  }

  Widget expressionField() {
    final colorScheme = Theme.of(context).colorScheme;
    final mainContent = EditableText(
      textAlign: TextAlign.end,
      showCursor: true,
      readOnly: true,
      autofocus: true,
      controller: expressionFieldTextCtl,
      focusNode: expressionFieldFocusNode,
      style: TextStyle(fontSize: 40, color: colorScheme.primary),
      cursorColor: colorScheme.primary,
      backgroundCursorColor: colorScheme.primary,
      key: expressionFieldKey,
    );
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: mainContent);
  }

  Widget resultMonitor() {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        const Spacer(),
        Text(getResult()?.toString() ?? '---',
            style: TextStyle(fontSize: 30, color: colorScheme.primaryFixedDim)),
        const SizedBox(width: 10) // padding
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // because upper part of bottom sheet is rounded,
        // we need to add some space to avoid the overlap
        const Spacer(),
        resultMonitor(),
        expressionField(),
        const Spacer(),
        memosCache,
        keyBoardCache
      ],
    );
  }

  @override
  void dispose() {
    expressionFieldTextCtl.dispose();
    expressionFieldFocusNode.dispose();
    super.dispose();
  }
}

class _Memos extends StatelessWidget {
  final List<int> memos;
  final void Function(int) onTap;
  const _Memos({required this.memos, required this.onTap});

  Widget memoButton(int memo, BuildContext context) {
    final style = TextButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer);
    final mainContent = TextButton(
        onPressed: () {
          onTap(memo);
        },
        style: style,
        child: Text(memo.toString()));
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2), child: mainContent);
  }

  @override
  Widget build(BuildContext context) {
    final mainContent = Row(
      children: [
        for (final memo in memos) ...[
          memoButton(memo, context),
        ]
      ],
    );
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal, child: mainContent);
  }
}

class _KeyBoard extends StatelessWidget {
  final void Function(String) onKey;
  final void Function() onClear;
  final void Function() onApply;
  final void Function() onDel;
  static const buttonhHeight = 45.0;
  static const buttonPadding = EdgeInsets.all(2);
  const _KeyBoard(
      {required this.onKey,
      required this.onClear,
      required this.onApply,
      required this.onDel});

  Widget delButton(ColorScheme colorScheme) {
    final style = TextButton.styleFrom(
        backgroundColor: colorScheme.surfaceContainer,
        fixedSize: const Size.fromHeight(buttonhHeight));
    final mainContent = TextButton(
        onPressed: onDel, style: style, child: const Icon(Icons.backspace));
    return Padding(padding: buttonPadding, child: mainContent);
  }

  Widget operatorButton(String operator, ColorScheme colorScheme) {
    final buttonStyle = TextButton.styleFrom(
        backgroundColor: colorScheme.primaryContainer,
        fixedSize: const Size.fromHeight(buttonhHeight));
    final mainContent = TextButton(
        onPressed: () => onKey(operator),
        style: buttonStyle,
        child: Text(operator,
            style: const TextStyle(fontSize: buttonhHeight / 2)));
    return Padding(padding: buttonPadding, child: mainContent);
  }

  Widget numberButton(String number, ColorScheme colorScheme) {
    final buttonStyle = TextButton.styleFrom(
        backgroundColor: colorScheme.surfaceContainer,
        fixedSize: const Size.fromHeight(buttonhHeight));
    final mainContent = TextButton(
        onPressed: () => onKey(number),
        style: buttonStyle,
        child:
            Text(number, style: const TextStyle(fontSize: buttonhHeight / 2)));
    return Padding(padding: buttonPadding, child: mainContent);
  }

  Widget clearButton(ColorScheme colorScheme) {
    final buttonStyle = TextButton.styleFrom(
        backgroundColor: colorScheme.tertiaryContainer,
        fixedSize: const Size.fromHeight(buttonhHeight));
    final mainContent = TextButton(
        onPressed: onClear,
        style: buttonStyle,
        child: Text('AC',
            style: TextStyle(
                fontSize: buttonhHeight / 2, color: colorScheme.tertiary)));
    return Padding(padding: buttonPadding, child: mainContent);
  }

  Widget applyButton(ColorScheme colorScheme) {
    final buttonStyle = TextButton.styleFrom(
        backgroundColor: colorScheme.secondaryContainer,
        fixedSize: const Size.fromHeight(buttonhHeight));
    final mainContent = TextButton(
        onPressed: onApply,
        style: buttonStyle,
        child: Icon(Icons.check, color: colorScheme.secondary));
    return Padding(padding: buttonPadding, child: mainContent);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Row(children: [
          Expanded(child: clearButton(colorScheme)),
          Expanded(child: operatorButton('(', colorScheme)),
          Expanded(child: operatorButton(')', colorScheme)),
          Expanded(child: operatorButton('/', colorScheme))
        ]),
        Row(children: [
          Expanded(child: numberButton('7', colorScheme)),
          Expanded(child: numberButton('8', colorScheme)),
          Expanded(child: numberButton('9', colorScheme)),
          Expanded(child: operatorButton('*', colorScheme))
        ]),
        Row(children: [
          Expanded(child: numberButton('4', colorScheme)),
          Expanded(child: numberButton('5', colorScheme)),
          Expanded(child: numberButton('6', colorScheme)),
          Expanded(child: operatorButton('-', colorScheme))
        ]),
        Row(children: [
          Expanded(child: numberButton('1', colorScheme)),
          Expanded(child: numberButton('2', colorScheme)),
          Expanded(child: numberButton('3', colorScheme)),
          Expanded(child: operatorButton('+', colorScheme))
        ]),
        Row(children: [
          Expanded(child: numberButton('0', colorScheme)),
          Expanded(child: numberButton('.', colorScheme)),
          Expanded(child: delButton(colorScheme)),
          Expanded(child: applyButton(colorScheme))
        ]),
      ],
    );
  }
}
// </MoneyPicker>
