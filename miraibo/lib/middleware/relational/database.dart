import 'dart:async';
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart' show NativeDatabase;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart' show WidgetsFlutterBinding;
import 'package:logger/logger.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart'
    show getApplicationSupportDirectory, getTemporaryDirectory;
import 'package:miraibo/middleware/relational/dao.dart';
import 'package:miraibo/shared/enumeration.dart';

part 'database.g.dart';

@DriftDatabase(include: {'primary_tables.drift'}, daos: [Plans])
class AppDatabase extends _$AppDatabase {
  static bool connectable = true;
  static StreamController<void> reconnectionNotifier =
      StreamController<void>.broadcast();
  disconnect() {
    connectable = false;
  }

  reconnect() {
    connectable = true;
    reconnectionNotifier.add(null);
  }

  static late final LazyDatabase lazyDatabase;
  static QueryExecutor _openConnection() {
    WidgetsFlutterBinding.ensureInitialized();
    return lazyDatabase = LazyDatabase(() async {
      if (!connectable) {
        await reconnectionNotifier.stream.first;
      }
      return NativeDatabase(await getDatabaseFile());
    });
  }

  AppDatabase._() : super(_openConnection());
  static AppDatabase? _instance;
  factory AppDatabase() => _instance ??= AppDatabase._();

  @override
  int get schemaVersion => 1;
  // HISTORY:
  // 1: Initial version (2025/3/3)

  static Future<void> prune() async {
    final String directory;
    if (kIsWeb) {
      throw UnimplementedError('Database for Web is not supported');
    } else {
      directory = (await getApplicationSupportDirectory()).path;
    }
    Logger().i('Using databse file at $directory');
    final file = File(join(directory, 'miraibo-db.sqlite'));
    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<void> clear() async {
    await batch((batch) {
      for (final table in allTables) {
        batch.deleteAll(table);
      }
    });
  }

  static int chunkSize = 1024;

  Stream<List<int>> dump() async* {
    final tempDir = await getTemporaryDirectory();
    final file = await getDatabaseFile();
    // take a snapshot
    final snapshot =
        await file.copy(join(tempDir.path, 'miraibo-db.sqlite.dump'));
    final fd = await snapshot.open();
    while (true) {
      final chunk = await fd.read(chunkSize);
      if (chunk.isEmpty) break;
      yield chunk;
    }
    await fd.close();
    await snapshot.delete();
  }

  Future<void> load(Stream<List<int>> chunks) async {
    disconnect();
    final file = await getDatabaseFile();
    final fd = await file.open(mode: FileMode.write);
    await for (final chunk in chunks) {
      await fd.writeFrom(chunk);
    }
    await fd.flush();
    await fd.close();
    reconnect();
  }

  static File? _databaseFile;
  static Future<File> getDatabaseFile() async {
    if (_databaseFile != null) return _databaseFile!;
    final String directory;
    if (kIsWeb) {
      throw UnimplementedError('Database for Web is not supported');
    } else {
      directory = (await getApplicationSupportDirectory()).path;
    }
    Logger().i('Using databse file at $directory');
    return File(join(directory, 'miraibo-db.sqlite'));
  }
}
