import 'package:miraibo/middleware/id_provider.dart';
import 'package:miraibo/repository/core.dart';

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
    await _receiptLogRepository.replaceCategory(this, category);
    await _planRepository.replaceCategory(this, category);
    await _estimationSchemeRepository.replaceCategory(this, category);
    await _monitorSchemeRepository.replaceCategory(this, category);
    await _repository.delete(this);
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

  @override
  String toString() => '$name(Category)';
}
