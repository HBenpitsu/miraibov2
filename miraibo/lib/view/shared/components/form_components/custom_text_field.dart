import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final InputDecoration? decoration;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final void Function(String)? onEditCompleted;
  final bool? multiline;
  final String? initialText;

  /// return null when it is valid
  final String? Function(String)? invalidMessageBuilder;
  final bool rollback;

  const CustomTextField(
      {this.decoration,
      this.controller,
      this.focusNode,
      this.keyboardType,
      this.onEditCompleted,
      this.multiline,
      this.invalidMessageBuilder,
      this.initialText,
      this.rollback = true,
      super.key});

  @override
  Widget build(BuildContext context) {
    final focusNode = this.focusNode ?? FocusNode();
    final controller =
        this.controller ?? TextEditingController(text: initialText);
    return Focus(
        onFocusChange: (hasFocus) {
          if (hasFocus) return;
          if (onEditCompleted == null) return;
          final invalidMessage =
              this.invalidMessageBuilder?.call(controller.text);
          if (invalidMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(invalidMessage),
              ),
            );
            if (rollback) {
              controller.text = initialText ?? '';
            }
            return;
          }
          onEditCompleted!(controller.text);
        },
        child: TextField(
          maxLines: multiline == true ? null : 1,
          decoration: decoration ?? const InputDecoration(),
          textAlign: switch (keyboardType) {
            TextInputType.number => TextAlign.center,
            _ => TextAlign.start,
          },
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          onTapOutside: (_) {
            focusNode.unfocus();
          },
        ));
  }
}
