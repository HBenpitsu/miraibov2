import 'package:flutter/material.dart';
import 'package:miraibo/view/shared/components/modal_window.dart';
import 'package:miraibo/view/shared/constants.dart';

const double modalContentMaxWidth = 600;

abstract class EditWindowState<T extends StatefulWidget> extends State<T> {
  Future<Widget> form();
  Object? get currentScheme;
  void onChanged(Object currentScheme);
  String get title;

  /// return null if valid
  String? invalidMessage() {
    if (currentScheme == null) {
      return 'It is not initialized. Try again.';
    }
    return null;
  }

  void _cancel() {
    Navigator.of(context).pop();
  }

  void _save() {
    final message = invalidMessage();
    if (message != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
      return;
    }
    onChanged(currentScheme!);
    Navigator.of(context).pop();
  }

  Widget actionButtons() {
    return Padding(
        padding: const EdgeInsets.all(actionButtonPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Spacer(flex: 1),
            Expanded(
                flex: 2,
                child: TextButton(
                  onPressed: _cancel,
                  child: const Text('Cancel'),
                )),
            Expanded(
                flex: 2,
                child: TextButton(
                  onPressed: _save,
                  child: const Text('Save'),
                )),
            const Spacer(
              flex: 1,
            ),
          ],
        ));
  }

  Widget content() {
    return SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: FutureBuilder(
              future: form(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data!;
                }
                return const CircularProgressIndicator();
              },
            )));
  }

  @override
  Widget build(BuildContext context) {
    return ModalWindowContainer(
        child: Column(
      children: [
        Text(title, style: Theme.of(context).textTheme.displaySmall),
        const Divider(),
        Expanded(child: content()),
        actionButtons(),
      ],
    ));
  }
}
