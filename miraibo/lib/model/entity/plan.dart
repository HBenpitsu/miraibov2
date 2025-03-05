import 'package:miraibo/middleware/id_provider.dart';
import 'package:miraibo/model/repository/primitive.dart';
import 'package:miraibo/model/value/schedule.dart';
import 'package:miraibo/model/value/price.dart';
import 'package:miraibo/model/entity/category.dart';

class Plan {
  static final PlanRepository _repository = PlanRepository.instance;
  final int id;
  Schedule _schedule;
  Schedule get schedule => _schedule;
  Price _price;
  Price get price => _price;
  String _description;
  String get description => _description;
  Category _category;
  Category get category => _category;

  Plan({
    required this.id,
    required Schedule schedule,
    required Price price,
    required String description,
    required Category category,
  })  : _schedule = schedule,
        _price = price,
        _description = description,
        _category = category;

  static Future<Plan> create(
    Schedule schedule,
    Price price,
    String description,
    Category category,
  ) async {
    final newEntity = Plan(
      id: IdProvider().get(),
      schedule: schedule,
      price: price,
      description: description,
      category: category,
    );
    _repository.insert(newEntity);
    return newEntity;
  }

  Future<void> update({
    Schedule? schedule,
    Price? price,
    String? description,
    Category? category,
  }) async {
    _schedule = schedule ?? _schedule;
    _price = price ?? _price;
    _description = description ?? _description;
    _category = category ?? _category;
    _repository.update(this);
  }

  Future<void> delete() async {
    _repository.delete(this);
  }
}
