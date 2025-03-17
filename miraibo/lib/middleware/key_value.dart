import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:shared_preferences_linux/shared_preferences_linux.dart';
import 'package:shared_preferences_android/shared_preferences_android.dart';
import 'package:miraibo/core-model/value/date.dart' as model;

class KeyValueStore {
  static KeyValueStore? _instance;
  final SharedPreferencesAsync _prefs = SharedPreferencesAsync();
  KeyValueStore._();
  factory KeyValueStore() {
    if (kIsWeb) {
      throw UnimplementedError('Web is not supported');
    } else {
      if (Platform.isLinux) {
        SharedPreferencesAsyncPlatform.instance = SharedPreferencesAsyncLinux();
      } else if (Platform.isAndroid) {
        SharedPreferencesAsyncPlatform.instance =
            SharedPreferencesAsyncAndroid();
      } else {
        throw UnimplementedError('Platform is not supported');
      }
    }
    return _instance ??= KeyValueStore._();
  }

  Future<void> prune() async {
    await _prefs.clear();
  }

  Future<void> clear() async {
    await _prefs.clear();
  }

  static const int version = 1;
  // HISTORY:
  // 1: initial version (2025/3/3)

  static const _prefix = 'miraibo_';
  String key(String key) => '$_prefix$key';

  static const _startUsingApp = 'startUsingApp'; // Date
  static const _defaultCurrencyId = 'defaultCurrencyId'; // int
  static const _lastPlanInstanciation = 'lastPlanInstanciation'; // Date

  // <dump/load>
  Future<String> dump() async {
    return jsonEncode({
      _startUsingApp: await getStartUsingApp(),
      _defaultCurrencyId: await getDefaultCurrencyId(),
    });
  }

  Future<void> load(String json) async {
    final map = jsonDecode(json) as Map<String, dynamic>;
    if (_mapHasValue(map, _startUsingApp)) {
      await setStartUsingApp(model.Date.fromJson(map[_startUsingApp]));
    }
    if (_mapHasValue(map, _defaultCurrencyId)) {
      await setDefaultCurrencyId(map[_defaultCurrencyId]);
    }
    if (_mapHasValue(map, _lastPlanInstanciation)) {
      await setLastPlanInstanciation(
          model.Date.fromJson(map[_lastPlanInstanciation]));
    }
  }

  bool _mapHasValue(Map<String, dynamic> map, String key) {
    return map.containsKey(key) && map[key] != null;
  }
  // </dump/load>

  // <getter/setter>
  Future<void> setStartUsingApp(model.Date value) async {
    await _prefs.setString(key(_startUsingApp), jsonEncode(value));
  }

  Future<model.Date?> getStartUsingApp() async {
    final json = await _prefs.getString(key(_startUsingApp));
    if (json == null) return null;
    return model.Date.fromJson(jsonDecode(json));
  }

  Future<void> setDefaultCurrencyId(int value) async {
    await _prefs.setInt(key(_defaultCurrencyId), value);
  }

  Future<int?> getDefaultCurrencyId() {
    return _prefs.getInt(key(_defaultCurrencyId));
  }

  Future<void> setLastPlanInstanciation(model.Date value) async {
    await _prefs.setString(key(_lastPlanInstanciation), jsonEncode(value));
  }

  Future<model.Date?> getLastPlanInstanciation() async {
    final json = await _prefs.getString(key(_lastPlanInstanciation));
    if (json == null) return null;
    return model.Date.fromJson(jsonDecode(json));
  }
  // </getter/setter>
}
