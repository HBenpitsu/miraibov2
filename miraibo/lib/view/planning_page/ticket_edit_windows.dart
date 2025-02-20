import 'package:flutter/material.dart';
import 'package:miraibo/dto/dto.dart' as dto;
import 'package:miraibo/skeleton/planning_page/planning_page.dart' as skt;
import 'package:miraibo/view/shared/components/ticket_scheme_config_section.dart';
import 'package:miraibo/view/shared/prestates/edit_window_pre_state.dart';

void openPlanEditWindow(BuildContext context, skt.PlanEditWindow skeleton) {
  showDialog(
    context: context,
    builder: (context) {
      return PlanEditWindow(skeleton: skeleton);
    },
  );
}

class PlanEditWindow extends StatefulWidget {
  final skt.PlanEditWindow skeleton;
  const PlanEditWindow({required this.skeleton, super.key});

  @override
  State<PlanEditWindow> createState() => _PlanEditWindowState();
}

class _PlanEditWindowState extends EditWindowState<PlanEditWindow> {
  @override
  dto.PlanScheme? currentScheme;

  @override
  String get title => 'Edit Plan';

  @override
  String? invalidMessage() {
    if (currentScheme == null) {
      return 'It is not initialized. Try again.';
    }
    if (currentScheme!.schedule is dto.WeeklySchedule) {
      final weeklySchedule = currentScheme!.schedule as dto.WeeklySchedule;
      if (!(weeklySchedule.sunday ||
          weeklySchedule.monday ||
          weeklySchedule.tuesday ||
          weeklySchedule.wednesday ||
          weeklySchedule.thursday ||
          weeklySchedule.friday ||
          weeklySchedule.saturday)) {
        // If none of the days are selected, return an error message.
        return 'At least one day must be selected.';
      }
    }
    return null;
  }

  @override
  Future<Widget> form() async {
    return PlanConfigSection(
      initial: await widget.skeleton.getOriginalPlan(),
      categoryOptions: await widget.skeleton.getCategoryOptions(),
      currencyOptions: await widget.skeleton.getCurrencyOptions(),
      onChanged: (scheme) {
        currentScheme = scheme;
      },
    );
  }

  @override
  void onChanged(covariant dto.PlanScheme currentScheme) {
    widget.skeleton.updatePlan(
        categoryId: currentScheme.category.id,
        description: currentScheme.description,
        amount: currentScheme.price.amount,
        currencyId: currentScheme.price.currencyId,
        schedule: currentScheme.schedule);
  }

  @override
  void dispose() {
    super.dispose();
    widget.skeleton.dispose();
  }
}

void openEstimationSchemeEditWindow(
    BuildContext context, skt.EstimationSchemeEditWindow skeleton) {
  showDialog(
    context: context,
    builder: (context) {
      return EstimationSchemeEditWindow(skeleton: skeleton);
    },
  );
}

class EstimationSchemeEditWindow extends StatefulWidget {
  final skt.EstimationSchemeEditWindow skeleton;
  const EstimationSchemeEditWindow({required this.skeleton, super.key});

  @override
  State<EstimationSchemeEditWindow> createState() =>
      _EstimationSchemeEditWindowState();
}

class _EstimationSchemeEditWindowState
    extends EditWindowState<EstimationSchemeEditWindow> {
  @override
  dto.EstimationScheme? currentScheme;

  @override
  String get title => 'Edit Estimation';

  @override
  Future<Widget> form() async {
    return EstimationConfigSection(
      initial: await widget.skeleton.getOriginalEstimationScheme(),
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
    if (currentScheme!.categories.isEmpty) {
      return 'At least one category must be selected.';
    }
    return null;
  }

  @override
  void onChanged(covariant dto.EstimationScheme currentScheme) {
    widget.skeleton.updateEstimationScheme(
        categoryIds: currentScheme.categories.map((e) => e.id).toList(),
        period: currentScheme.period,
        displayOption: currentScheme.displayOption,
        currencyId: currentScheme.currency.id);
  }

  @override
  void dispose() {
    widget.skeleton.dispose();
    super.dispose();
  }
}
