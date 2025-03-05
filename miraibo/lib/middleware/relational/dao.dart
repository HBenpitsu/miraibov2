import 'package:drift/drift.dart';
import 'package:miraibo/middleware/relational/database.dart';

part 'dao.g.dart';

@DriftAccessor(include: {'primary_tables.drift'})
class Plans extends DatabaseAccessor<AppDatabase> with _$PlansMixin {
  Plans(super.db);

  Future<DateTime> createdAtOf(int id) async {
    DateTime? result;
    result ??= (await (select(oneshotPlans)..where((row) => row.id.equals(id)))
            .getSingleOrNull())
        ?.createdAt;
    result ??= (await (select(intervalPlans)..where((row) => row.id.equals(id)))
            .getSingleOrNull())
        ?.createdAt;
    result ??= (await (select(weeklyPlans)..where((row) => row.id.equals(id)))
            .getSingleOrNull())
        ?.createdAt;
    result ??= (await (select(monthlyPlans)..where((row) => row.id.equals(id)))
            .getSingleOrNull())
        ?.createdAt;
    result ??= (await (select(annualPlans)..where((row) => row.id.equals(id)))
            .getSingleOrNull())
        ?.createdAt;
    if (result == null) {
      throw Exception('No record found for id: $id');
    }
    return result;
  }

  Future<DateTime> updatedAtOf(int id) async {
    DateTime? result;
    result ??= (await (select(oneshotPlans)..where((row) => row.id.equals(id)))
            .getSingleOrNull())
        ?.updatedAt;
    result ??= (await (select(intervalPlans)..where((row) => row.id.equals(id)))
            .getSingleOrNull())
        ?.updatedAt;
    result ??= (await (select(weeklyPlans)..where((row) => row.id.equals(id)))
            .getSingleOrNull())
        ?.updatedAt;
    result ??= (await (select(monthlyPlans)..where((row) => row.id.equals(id)))
            .getSingleOrNull())
        ?.updatedAt;
    result ??= (await (select(annualPlans)..where((row) => row.id.equals(id)))
            .getSingleOrNull())
        ?.updatedAt;
    if (result == null) {
      throw Exception('No record found for id: $id');
    }
    return result;
  }

  Future<void> deleteWithId(int id) async {
    await (delete(oneshotPlans)..where((row) => row.id.equals(id))).go();
    await (delete(intervalPlans)..where((row) => row.id.equals(id))).go();
    await (delete(weeklyPlans)..where((row) => row.id.equals(id))).go();
    await (delete(monthlyPlans)..where((row) => row.id.equals(id))).go();
    await (delete(annualPlans)..where((row) => row.id.equals(id))).go();
  }
}
