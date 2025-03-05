import 'package:miraibo/model/repository/primitive.dart';
import 'package:miraibo/model/entity/category.dart';
import 'package:miraibo/model/value/date.dart';
import 'package:miraibo/model/value/price.dart';
import 'package:miraibo/middleware/id_provider.dart';

class ReceiptLog {
  static final ReceiptLogRepository repository = ReceiptLogRepository.instance;
  final int id;
  Date _date;
  Date get date => _date;
  Price _price;
  Price get price => _price;
  String _description;
  String get description => _description;
  Category _category;
  Category get category => _category;
  bool _confirmed;
  bool get confirmed => _confirmed;
  ReceiptLog({
    required this.id,
    required Date date,
    required Price price,
    required String description,
    required Category category,
    required bool confirmed,
  })  : _date = date,
        _price = price,
        _description = description,
        _category = category,
        _confirmed = confirmed;

  static Future<ReceiptLog> create(
    Date date,
    Price price,
    String description,
    Category category,
    bool confirmed,
  ) async {
    final newEntity = ReceiptLog(
      id: IdProvider().get(),
      date: date,
      price: price,
      description: description,
      category: category,
      confirmed: confirmed,
    );
    await repository.insert(newEntity);
    return newEntity;
  }

  Future<void> update({
    Date? date,
    Price? price,
    String? description,
    Category? category,
    bool? confirmed,
  }) async {
    _date = date ?? _date;
    _price = price ?? _price;
    _description = description ?? _description;
    _category = category ?? _category;
    _confirmed = confirmed ?? _confirmed;
    repository.update(this);
  }

  Future<void> delete() async {
    repository.delete(this);
  }
}
