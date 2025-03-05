import 'dart:async';

import 'package:miraibo/model/entity/receipt_log.dart';
import 'package:miraibo/model/repository/primitive.dart';
import 'package:miraibo/model/value/period.dart';
import 'package:miraibo/model/value/collection/category_collection.dart';

class ReceiptLogCollection {
  static final ReceiptLogRepository _repository = ReceiptLogRepository.instance;

  static const int _cacheSize = 200;
  static _Cache _cache = _Cache.empty();

  static Stream<ReceiptLog?> watchFor(int index) {
    final logStream = _cache.get(index);
    if (logStream != null) {
      return logStream;
    }

    var firstIndex = index - _cacheSize ~/ 2;
    firstIndex = firstIndex < 0 ? 0 : firstIndex;
    final lastIndex = firstIndex + _cacheSize - 1;
    _cache = _Cache(
      firstIndex: firstIndex,
      lastIndex: lastIndex,
      logs: _repository.observeRows(firstIndex, _cacheSize),
    );
    return _cache.get(index)!;
  }

  final List<ReceiptLog> logs;
  ReceiptLogCollection({required this.logs});

  static Future<ReceiptLogCollection> unconfirmedLogs({Period? within}) async {
    within ??= Period.entirePeriod;
    final logs = await _repository
        .get(within, CategoryCollection.phantomAll, confirmed: false)
        .toList();
    return ReceiptLogCollection(logs: logs);
  }

  static Future<ReceiptLogCollection> ignoredUnconfirmedLogs() async {
    final logs = await _repository
        .get(Period.oldDays(), CategoryCollection.phantomAll, confirmed: false)
        .toList();
    return ReceiptLogCollection(logs: logs);
  }
}

class _Cache {
  final int firstIndex;
  final int lastIndex;
  List<ReceiptLog>? currentLogs;

  Future<List<ReceiptLog>> waitForCurrentLogs() async {
    if (currentLogs != null) {
      return currentLogs!;
    }
    final firstLogs = await logListStream.first;
    currentLogs = firstLogs;
    return firstLogs;
  }

  late final Stream<List<ReceiptLog>> logListStream;

  _Cache({
    required this.firstIndex,
    required this.lastIndex,
    required Stream<List<ReceiptLog>> logs,
  }) {
    logListStream = logs.asBroadcastStream();
    logListStream.listen((logs) {
      currentLogs = logs;
    });
  }

  _Cache.empty()
      : firstIndex = 1,
        lastIndex = 0,
        // first is more than last, that means "index < firstIndex || lastIndex < index" is always true
        currentLogs = [],
        logListStream = Stream.value([]);

  ReceiptLog? _pick(List<ReceiptLog> logs, int index) {
    if (index < firstIndex || lastIndex < index || logs.length <= index) {
      return null;
    }
    return logs[index - firstIndex];
  }

  Stream<ReceiptLog?>? get(int index) {
    if (index < firstIndex || lastIndex < index) {
      return null;
    }

    final returnStream = StreamController<ReceiptLog?>();
    // Because logListStream is broadcast, the first value should be passed again.
    // A broadcast stream does not hold the passed value.
    waitForCurrentLogs().then((logs) {
      returnStream.add(_pick(logs, index));
    });
    returnStream.addStream(logListStream.map((logs) => _pick(logs, index)));

    return returnStream.stream;
  }
}
