import 'package:miraibo/core-model/value/collection/plan_collection.dart';
import 'package:miraibo/core-model/value/collection/receipt_log_collection.dart';

Future<void> instanciateScheduleUntilToday() async {
  await PlanCollection.instanciate();
}

Future<void> autoConfirmIgnoredReceiptLogs() async {
  final ignored = await ReceiptLogCollection.ignoredUnconfirmedLogs();
  for (final log in ignored.logs) {
    log.update(confirmed: true);
  }
}
