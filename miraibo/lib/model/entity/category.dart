import 'package:miraibo/middleware/id_provider.dart';
import 'package:miraibo/model/repository/primitive.dart';
import 'package:miraibo/model/value/collection/category_collection.dart';
import 'package:miraibo/model/value/period.dart';

class Category {
  static final CategoryRepository _repository = CategoryRepository.instance;
  static final ReceiptLogRepository _receiptLogRepository =
      ReceiptLogRepository.instance;
  static final PlanRepository _planRepository = PlanRepository.instance;
  static final EstimationSchemeRepository _estimationSchemeRepository =
      EstimationSchemeRepository.instance;
  static final MonitorSchemeRepository _monitorSchemeRepository =
      MonitorSchemeRepository.instance;

  final int id;
  String _name;
  String get name => _name;

  Category({
    required this.id,
    required String name,
  }) : _name = name;

  static Future<Category?> find(String name) {
    return _repository.find(name);
  }

  static Future<Category> findOrCreate(String name) async {
    final found = await find(name);
    return found ?? create(name);
  }

  Future<void> integrateWith(Category category) async {
    final receiptLogs = _receiptLogRepository.get(
        Period.entirePeriod, CategoryCollection.single(this));
    await for (final log in receiptLogs) {
      await log.update(category: category);
    }
    final plans = _planRepository.get(
        Period.entirePeriod, CategoryCollection.single(this));
    await for (final plan in plans) {
      await plan.update(category: category);
    }
    final estimations = _estimationSchemeRepository.get(
        Period.entirePeriod, CategoryCollection.single(this));
    await for (final estimation in estimations) {
      await estimation.update(category: category);
    }
    final monitors = _monitorSchemeRepository.get(
        Period.entirePeriod, CategoryCollection.single(this));
    await for (final monitor in monitors) {
      await monitor.update(
          categories: monitor.categories.replace(this, category));
    }
    _repository.delete(category);
  }

  static Future<Category> create(String name) async {
    final newEntity = Category(id: IdProvider().get(), name: name);
    await _repository.insert(newEntity);
    return newEntity;
  }

  Future<void> update(String name) async {
    _name = name;
    await _repository.update(this);
  }

  Future<void> delete() async {
    await _repository.delete(this);
  }

  @override
  String toString() => '$name(Category)';
}
