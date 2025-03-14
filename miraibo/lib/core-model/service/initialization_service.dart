import 'package:miraibo/core-model/value/collection/category_collection.dart';
import 'package:miraibo/repository/core.dart';

class InitializationService {
  static final InitializationRepository _repository =
      InitializationRepository.instance;

  static Future<void> initialize() async {
    await CategoryCollection.prepareDefaultCategories();
    await _repository.initializeAppDate();
  }
}
