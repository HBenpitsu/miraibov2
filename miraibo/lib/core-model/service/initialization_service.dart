import 'package:miraibo/core-model/value/collection/category_collection.dart';
import 'package:miraibo/core-model/entity/currency.dart';
import 'package:miraibo/core-model/value/collection/currency_collection.dart';
import 'package:miraibo/repository/core.dart';

class InitializationService {
  static final InitializationRepository _repository =
      InitializationRepository.instance;

  static Future<void> initialize() async {
    await CategoryCollection.prepareDefaultCategories();
    if ((await CurrencyCollection.getAll()).isEmpty) {
      await Currency.create('CUR', 1.0);
    }
    await _repository.initializeAppDate();
  }
}
