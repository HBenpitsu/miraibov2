import 'package:flutter/material.dart';
import 'package:miraibo/dto/dto.dart' as dto;
import 'package:miraibo/skeleton/shared.dart' as skt;
import 'package:miraibo/view/shared/components/ticket_scheme_config_section.dart';
import 'package:miraibo/view/shared/edit_window_pre_state.dart';

void openReceiptLogEditWindow(
    BuildContext context, skt.ReceiptLogEditWindow skeleton) {
  showDialog(
    context: context,
    builder: (context) {
      return ReceiptLogEditWindow(skeleton: skeleton);
    },
  );
}

class ReceiptLogEditWindow extends StatefulWidget {
  final skt.ReceiptLogEditWindow skeleton;
  const ReceiptLogEditWindow({required this.skeleton, super.key});

  @override
  State<ReceiptLogEditWindow> createState() => _ReceiptLogEditWindowState();
}

class _ReceiptLogEditWindowState extends EditWindowState<ReceiptLogEditWindow> {
  @override
  dto.ReceiptLogScheme? currentScheme;
  @override
  String get title => 'Edit Log';

  @override
  Future<Widget> form() async {
    return ReceiptLogConfigSection(
      initial: await widget.skeleton.getOriginalReceiptLog(),
      categoryOptions: await widget.skeleton.getCategoryOptions(),
      currencyOptions: await widget.skeleton.getCurrencyOptions(),
      onChanged: (scheme) {
        currentScheme = scheme;
      },
    );
  }

  @override
  void onChanged(covariant dto.ReceiptLogScheme currentScheme) {
    widget.skeleton.updateReceiptLog(
        categoryId: currentScheme.category.id,
        description: currentScheme.description,
        amount: currentScheme.price.amount,
        currencyId: currentScheme.price.currencyId,
        date: currentScheme.date);
  }

  @override
  void onDelete() {
    widget.skeleton.deleteReceiptLog();
  }

  @override
  void dispose() {
    super.dispose();
    widget.skeleton.dispose();
  }
}
