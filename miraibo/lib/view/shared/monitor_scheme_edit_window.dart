import 'package:flutter/material.dart';
import 'package:miraibo/skeleton/shared.dart' as skt;
import 'package:miraibo/dto/dto.dart' as dto;
import 'package:miraibo/view/shared/edit_window_pre_state.dart';
import 'package:miraibo/view/shared/components/ticket_scheme_config_section.dart';

void openMonitorSchemeEditWindow(
    BuildContext context, skt.MonitorSchemeEditWindow skeleton) {
  showDialog(
    context: context,
    builder: (context) {
      return MonitorSchemeEditWindow(skeleton: skeleton);
    },
  );
}

class MonitorSchemeEditWindow extends StatefulWidget {
  final skt.MonitorSchemeEditWindow skeleton;
  const MonitorSchemeEditWindow({required this.skeleton, super.key});

  @override
  State<MonitorSchemeEditWindow> createState() =>
      _MonitorSchemeEditWindowState();
}

class _MonitorSchemeEditWindowState
    extends EditWindowState<MonitorSchemeEditWindow> {
  @override
  dto.MonitorScheme? currentScheme;

  @override
  String get title => 'Edit Monitor';

  @override
  Future<Widget> form() async {
    return MonitorConfigSection(
      initial: await widget.skeleton.getOriginalMonitorScheme(),
      categoryOptions: await widget.skeleton.getCategoryOptions(),
      currencyOptions: await widget.skeleton.getCurrencyOptions(),
      onChanged: (scheme) {
        currentScheme = scheme;
      },
    );
  }

  @override
  String? invalidMessage() {
    if (currentScheme == null) {
      return 'It is not initialized. Try again.';
    }
    if (!currentScheme!.isAllCategoriesIncluded &&
        currentScheme!.categories.isEmpty) {
      return 'At least one category must be selected.';
    }
    return null;
  }

  @override
  void onChanged(covariant dto.MonitorScheme currentScheme) {
    widget.skeleton.updateMonitorScheme(
        categoryIds: currentScheme.categories.map((e) => e.id).toList(),
        isAllCategoriesIncluded: currentScheme.isAllCategoriesIncluded,
        period: currentScheme.period,
        displayOption: currentScheme.displayOption,
        currencyId: currentScheme.currency.id);
  }

  @override
  void onDelete() {
    widget.skeleton.deleteMonitorScheme();
  }

  @override
  void dispose() {
    widget.skeleton.dispose();
    super.dispose();
  }
}
