// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class Categories extends Table with TableInfo<Categories, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Categories(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      '_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'PRIMARY KEY');
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      '_name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      '_createdAt', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      '_updatedAt', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  @override
  List<GeneratedColumn> get $columns => [id, name, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(Insertable<Category> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('_id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['_id']!, _idMeta));
    }
    if (data.containsKey('_name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['_name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('_createdAt')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['_createdAt']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('_updatedAt')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['_updatedAt']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}_name'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}_createdAt'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}_updatedAt'])!,
    );
  }

  @override
  Categories createAlias(String alias) {
    return Categories(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class Category extends DataClass implements Insertable<Category> {
  final int id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Category(
      {required this.id,
      required this.name,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['_id'] = Variable<int>(id);
    map['_name'] = Variable<String>(name);
    map['_createdAt'] = Variable<DateTime>(createdAt);
    map['_updatedAt'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Category.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<int>(json['_id']),
      name: serializer.fromJson<String>(json['_name']),
      createdAt: serializer.fromJson<DateTime>(json['_createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['_updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      '_id': serializer.toJson<int>(id),
      '_name': serializer.toJson<String>(name),
      '_createdAt': serializer.toJson<DateTime>(createdAt),
      '_updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Category copyWith(
          {int? id, String? name, DateTime? createdAt, DateTime? updatedAt}) =>
      Category(
        id: id ?? this.id,
        name: name ?? this.name,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.name == this.name &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<int> id;
  final Value<String> name;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required DateTime createdAt,
    required DateTime updatedAt,
  })  : name = Value(name),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Category> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) '_id': id,
      if (name != null) '_name': name,
      if (createdAt != null) '_createdAt': createdAt,
      if (updatedAt != null) '_updatedAt': updatedAt,
    });
  }

  CategoriesCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['_id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['_name'] = Variable<String>(name.value);
    }
    if (createdAt.present) {
      map['_createdAt'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['_updatedAt'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class Currencies extends Table with TableInfo<Currencies, Currency> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Currencies(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      '_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'PRIMARY KEY');
  static const VerificationMeta _symbolMeta = const VerificationMeta('symbol');
  late final GeneratedColumn<String> symbol = GeneratedColumn<String>(
      '_symbol', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _ratioMeta = const VerificationMeta('ratio');
  late final GeneratedColumn<double> ratio = GeneratedColumn<double>(
      '_ratio', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      '_createdAt', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      '_updatedAt', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  @override
  List<GeneratedColumn> get $columns =>
      [id, symbol, ratio, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'currencies';
  @override
  VerificationContext validateIntegrity(Insertable<Currency> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('_id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['_id']!, _idMeta));
    }
    if (data.containsKey('_symbol')) {
      context.handle(_symbolMeta,
          symbol.isAcceptableOrUnknown(data['_symbol']!, _symbolMeta));
    } else if (isInserting) {
      context.missing(_symbolMeta);
    }
    if (data.containsKey('_ratio')) {
      context.handle(
          _ratioMeta, ratio.isAcceptableOrUnknown(data['_ratio']!, _ratioMeta));
    } else if (isInserting) {
      context.missing(_ratioMeta);
    }
    if (data.containsKey('_createdAt')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['_createdAt']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('_updatedAt')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['_updatedAt']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Currency map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Currency(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}_id'])!,
      symbol: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}_symbol'])!,
      ratio: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}_ratio'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}_createdAt'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}_updatedAt'])!,
    );
  }

  @override
  Currencies createAlias(String alias) {
    return Currencies(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class Currency extends DataClass implements Insertable<Currency> {
  final int id;
  final String symbol;
  final double ratio;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Currency(
      {required this.id,
      required this.symbol,
      required this.ratio,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['_id'] = Variable<int>(id);
    map['_symbol'] = Variable<String>(symbol);
    map['_ratio'] = Variable<double>(ratio);
    map['_createdAt'] = Variable<DateTime>(createdAt);
    map['_updatedAt'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CurrenciesCompanion toCompanion(bool nullToAbsent) {
    return CurrenciesCompanion(
      id: Value(id),
      symbol: Value(symbol),
      ratio: Value(ratio),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Currency.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Currency(
      id: serializer.fromJson<int>(json['_id']),
      symbol: serializer.fromJson<String>(json['_symbol']),
      ratio: serializer.fromJson<double>(json['_ratio']),
      createdAt: serializer.fromJson<DateTime>(json['_createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['_updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      '_id': serializer.toJson<int>(id),
      '_symbol': serializer.toJson<String>(symbol),
      '_ratio': serializer.toJson<double>(ratio),
      '_createdAt': serializer.toJson<DateTime>(createdAt),
      '_updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Currency copyWith(
          {int? id,
          String? symbol,
          double? ratio,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Currency(
        id: id ?? this.id,
        symbol: symbol ?? this.symbol,
        ratio: ratio ?? this.ratio,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Currency copyWithCompanion(CurrenciesCompanion data) {
    return Currency(
      id: data.id.present ? data.id.value : this.id,
      symbol: data.symbol.present ? data.symbol.value : this.symbol,
      ratio: data.ratio.present ? data.ratio.value : this.ratio,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Currency(')
          ..write('id: $id, ')
          ..write('symbol: $symbol, ')
          ..write('ratio: $ratio, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, symbol, ratio, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Currency &&
          other.id == this.id &&
          other.symbol == this.symbol &&
          other.ratio == this.ratio &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CurrenciesCompanion extends UpdateCompanion<Currency> {
  final Value<int> id;
  final Value<String> symbol;
  final Value<double> ratio;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const CurrenciesCompanion({
    this.id = const Value.absent(),
    this.symbol = const Value.absent(),
    this.ratio = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  CurrenciesCompanion.insert({
    this.id = const Value.absent(),
    required String symbol,
    required double ratio,
    required DateTime createdAt,
    required DateTime updatedAt,
  })  : symbol = Value(symbol),
        ratio = Value(ratio),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Currency> custom({
    Expression<int>? id,
    Expression<String>? symbol,
    Expression<double>? ratio,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) '_id': id,
      if (symbol != null) '_symbol': symbol,
      if (ratio != null) '_ratio': ratio,
      if (createdAt != null) '_createdAt': createdAt,
      if (updatedAt != null) '_updatedAt': updatedAt,
    });
  }

  CurrenciesCompanion copyWith(
      {Value<int>? id,
      Value<String>? symbol,
      Value<double>? ratio,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return CurrenciesCompanion(
      id: id ?? this.id,
      symbol: symbol ?? this.symbol,
      ratio: ratio ?? this.ratio,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['_id'] = Variable<int>(id.value);
    }
    if (symbol.present) {
      map['_symbol'] = Variable<String>(symbol.value);
    }
    if (ratio.present) {
      map['_ratio'] = Variable<double>(ratio.value);
    }
    if (createdAt.present) {
      map['_createdAt'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['_updatedAt'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CurrenciesCompanion(')
          ..write('id: $id, ')
          ..write('symbol: $symbol, ')
          ..write('ratio: $ratio, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class ReceiptLogs extends Table with TableInfo<ReceiptLogs, ReceiptLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  ReceiptLogs(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      '_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'PRIMARY KEY');
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      '_date', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      '_amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _currencyIdMeta =
      const VerificationMeta('currencyId');
  late final GeneratedColumn<int> currencyId = GeneratedColumn<int>(
      '_currencyId', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL REFERENCES currencies(_id)');
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      '_description', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
      '_categoryId', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL REFERENCES categories(_id)');
  static const VerificationMeta _confirmedMeta =
      const VerificationMeta('confirmed');
  late final GeneratedColumn<bool> confirmed = GeneratedColumn<bool>(
      '_confirmed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      '_createdAt', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      '_updatedAt', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  @override
  List<GeneratedColumn> get $columns => [
        id,
        date,
        amount,
        currencyId,
        description,
        categoryId,
        confirmed,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'receiptLogs';
  @override
  VerificationContext validateIntegrity(Insertable<ReceiptLog> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('_id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['_id']!, _idMeta));
    }
    if (data.containsKey('_date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['_date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('_amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['_amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('_currencyId')) {
      context.handle(
          _currencyIdMeta,
          currencyId.isAcceptableOrUnknown(
              data['_currencyId']!, _currencyIdMeta));
    } else if (isInserting) {
      context.missing(_currencyIdMeta);
    }
    if (data.containsKey('_description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['_description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('_categoryId')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['_categoryId']!, _categoryIdMeta));
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('_confirmed')) {
      context.handle(_confirmedMeta,
          confirmed.isAcceptableOrUnknown(data['_confirmed']!, _confirmedMeta));
    } else if (isInserting) {
      context.missing(_confirmedMeta);
    }
    if (data.containsKey('_createdAt')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['_createdAt']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('_updatedAt')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['_updatedAt']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReceiptLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReceiptLog(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}_id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}_date'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}_amount'])!,
      currencyId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}_currencyId'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}_description'])!,
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}_categoryId'])!,
      confirmed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}_confirmed'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}_createdAt'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}_updatedAt'])!,
    );
  }

  @override
  ReceiptLogs createAlias(String alias) {
    return ReceiptLogs(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class ReceiptLog extends DataClass implements Insertable<ReceiptLog> {
  final int id;
  final DateTime date;
  final double amount;
  final int currencyId;
  final String description;
  final int categoryId;
  final bool confirmed;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ReceiptLog(
      {required this.id,
      required this.date,
      required this.amount,
      required this.currencyId,
      required this.description,
      required this.categoryId,
      required this.confirmed,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['_id'] = Variable<int>(id);
    map['_date'] = Variable<DateTime>(date);
    map['_amount'] = Variable<double>(amount);
    map['_currencyId'] = Variable<int>(currencyId);
    map['_description'] = Variable<String>(description);
    map['_categoryId'] = Variable<int>(categoryId);
    map['_confirmed'] = Variable<bool>(confirmed);
    map['_createdAt'] = Variable<DateTime>(createdAt);
    map['_updatedAt'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ReceiptLogsCompanion toCompanion(bool nullToAbsent) {
    return ReceiptLogsCompanion(
      id: Value(id),
      date: Value(date),
      amount: Value(amount),
      currencyId: Value(currencyId),
      description: Value(description),
      categoryId: Value(categoryId),
      confirmed: Value(confirmed),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ReceiptLog.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReceiptLog(
      id: serializer.fromJson<int>(json['_id']),
      date: serializer.fromJson<DateTime>(json['_date']),
      amount: serializer.fromJson<double>(json['_amount']),
      currencyId: serializer.fromJson<int>(json['_currencyId']),
      description: serializer.fromJson<String>(json['_description']),
      categoryId: serializer.fromJson<int>(json['_categoryId']),
      confirmed: serializer.fromJson<bool>(json['_confirmed']),
      createdAt: serializer.fromJson<DateTime>(json['_createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['_updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      '_id': serializer.toJson<int>(id),
      '_date': serializer.toJson<DateTime>(date),
      '_amount': serializer.toJson<double>(amount),
      '_currencyId': serializer.toJson<int>(currencyId),
      '_description': serializer.toJson<String>(description),
      '_categoryId': serializer.toJson<int>(categoryId),
      '_confirmed': serializer.toJson<bool>(confirmed),
      '_createdAt': serializer.toJson<DateTime>(createdAt),
      '_updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ReceiptLog copyWith(
          {int? id,
          DateTime? date,
          double? amount,
          int? currencyId,
          String? description,
          int? categoryId,
          bool? confirmed,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      ReceiptLog(
        id: id ?? this.id,
        date: date ?? this.date,
        amount: amount ?? this.amount,
        currencyId: currencyId ?? this.currencyId,
        description: description ?? this.description,
        categoryId: categoryId ?? this.categoryId,
        confirmed: confirmed ?? this.confirmed,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  ReceiptLog copyWithCompanion(ReceiptLogsCompanion data) {
    return ReceiptLog(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      amount: data.amount.present ? data.amount.value : this.amount,
      currencyId:
          data.currencyId.present ? data.currencyId.value : this.currencyId,
      description:
          data.description.present ? data.description.value : this.description,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      confirmed: data.confirmed.present ? data.confirmed.value : this.confirmed,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReceiptLog(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('amount: $amount, ')
          ..write('currencyId: $currencyId, ')
          ..write('description: $description, ')
          ..write('categoryId: $categoryId, ')
          ..write('confirmed: $confirmed, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, amount, currencyId, description,
      categoryId, confirmed, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReceiptLog &&
          other.id == this.id &&
          other.date == this.date &&
          other.amount == this.amount &&
          other.currencyId == this.currencyId &&
          other.description == this.description &&
          other.categoryId == this.categoryId &&
          other.confirmed == this.confirmed &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ReceiptLogsCompanion extends UpdateCompanion<ReceiptLog> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<double> amount;
  final Value<int> currencyId;
  final Value<String> description;
  final Value<int> categoryId;
  final Value<bool> confirmed;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ReceiptLogsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.amount = const Value.absent(),
    this.currencyId = const Value.absent(),
    this.description = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.confirmed = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ReceiptLogsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required double amount,
    required int currencyId,
    required String description,
    required int categoryId,
    required bool confirmed,
    required DateTime createdAt,
    required DateTime updatedAt,
  })  : date = Value(date),
        amount = Value(amount),
        currencyId = Value(currencyId),
        description = Value(description),
        categoryId = Value(categoryId),
        confirmed = Value(confirmed),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<ReceiptLog> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<double>? amount,
    Expression<int>? currencyId,
    Expression<String>? description,
    Expression<int>? categoryId,
    Expression<bool>? confirmed,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) '_id': id,
      if (date != null) '_date': date,
      if (amount != null) '_amount': amount,
      if (currencyId != null) '_currencyId': currencyId,
      if (description != null) '_description': description,
      if (categoryId != null) '_categoryId': categoryId,
      if (confirmed != null) '_confirmed': confirmed,
      if (createdAt != null) '_createdAt': createdAt,
      if (updatedAt != null) '_updatedAt': updatedAt,
    });
  }

  ReceiptLogsCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? date,
      Value<double>? amount,
      Value<int>? currencyId,
      Value<String>? description,
      Value<int>? categoryId,
      Value<bool>? confirmed,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return ReceiptLogsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      currencyId: currencyId ?? this.currencyId,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      confirmed: confirmed ?? this.confirmed,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['_id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['_date'] = Variable<DateTime>(date.value);
    }
    if (amount.present) {
      map['_amount'] = Variable<double>(amount.value);
    }
    if (currencyId.present) {
      map['_currencyId'] = Variable<int>(currencyId.value);
    }
    if (description.present) {
      map['_description'] = Variable<String>(description.value);
    }
    if (categoryId.present) {
      map['_categoryId'] = Variable<int>(categoryId.value);
    }
    if (confirmed.present) {
      map['_confirmed'] = Variable<bool>(confirmed.value);
    }
    if (createdAt.present) {
      map['_createdAt'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['_updatedAt'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReceiptLogsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('amount: $amount, ')
          ..write('currencyId: $currencyId, ')
          ..write('description: $description, ')
          ..write('categoryId: $categoryId, ')
          ..write('confirmed: $confirmed, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class OneshotPlans extends Table with TableInfo<OneshotPlans, OneshotPlan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  OneshotPlans(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      '_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'PRIMARY KEY');
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      '_amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _currencyIdMeta =
      const VerificationMeta('currencyId');
  late final GeneratedColumn<int> currencyId = GeneratedColumn<int>(
      '_currencyId', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL REFERENCES currencies(_id)');
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      '_description', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
      '_categoryId', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL REFERENCES categories(_id)');
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      '_date', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      '_createdAt', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      '_updatedAt', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  @override
  List<GeneratedColumn> get $columns => [
        id,
        amount,
        currencyId,
        description,
        categoryId,
        date,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'oneshotPlans';
  @override
  VerificationContext validateIntegrity(Insertable<OneshotPlan> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('_id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['_id']!, _idMeta));
    }
    if (data.containsKey('_amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['_amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('_currencyId')) {
      context.handle(
          _currencyIdMeta,
          currencyId.isAcceptableOrUnknown(
              data['_currencyId']!, _currencyIdMeta));
    } else if (isInserting) {
      context.missing(_currencyIdMeta);
    }
    if (data.containsKey('_description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['_description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('_categoryId')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['_categoryId']!, _categoryIdMeta));
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('_date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['_date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('_createdAt')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['_createdAt']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('_updatedAt')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['_updatedAt']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OneshotPlan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OneshotPlan(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}_id'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}_amount'])!,
      currencyId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}_currencyId'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}_description'])!,
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}_categoryId'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}_date'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}_createdAt'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}_updatedAt'])!,
    );
  }

  @override
  OneshotPlans createAlias(String alias) {
    return OneshotPlans(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class OneshotPlan extends DataClass implements Insertable<OneshotPlan> {
  final int id;
  final double amount;
  final int currencyId;
  final String description;
  final int categoryId;
  final DateTime date;
  final DateTime createdAt;
  final DateTime updatedAt;
  const OneshotPlan(
      {required this.id,
      required this.amount,
      required this.currencyId,
      required this.description,
      required this.categoryId,
      required this.date,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['_id'] = Variable<int>(id);
    map['_amount'] = Variable<double>(amount);
    map['_currencyId'] = Variable<int>(currencyId);
    map['_description'] = Variable<String>(description);
    map['_categoryId'] = Variable<int>(categoryId);
    map['_date'] = Variable<DateTime>(date);
    map['_createdAt'] = Variable<DateTime>(createdAt);
    map['_updatedAt'] = Variable<DateTime>(updatedAt);
    return map;
  }

  OneshotPlansCompanion toCompanion(bool nullToAbsent) {
    return OneshotPlansCompanion(
      id: Value(id),
      amount: Value(amount),
      currencyId: Value(currencyId),
      description: Value(description),
      categoryId: Value(categoryId),
      date: Value(date),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory OneshotPlan.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OneshotPlan(
      id: serializer.fromJson<int>(json['_id']),
      amount: serializer.fromJson<double>(json['_amount']),
      currencyId: serializer.fromJson<int>(json['_currencyId']),
      description: serializer.fromJson<String>(json['_description']),
      categoryId: serializer.fromJson<int>(json['_categoryId']),
      date: serializer.fromJson<DateTime>(json['_date']),
      createdAt: serializer.fromJson<DateTime>(json['_createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['_updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      '_id': serializer.toJson<int>(id),
      '_amount': serializer.toJson<double>(amount),
      '_currencyId': serializer.toJson<int>(currencyId),
      '_description': serializer.toJson<String>(description),
      '_categoryId': serializer.toJson<int>(categoryId),
      '_date': serializer.toJson<DateTime>(date),
      '_createdAt': serializer.toJson<DateTime>(createdAt),
      '_updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  OneshotPlan copyWith(
          {int? id,
          double? amount,
          int? currencyId,
          String? description,
          int? categoryId,
          DateTime? date,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      OneshotPlan(
        id: id ?? this.id,
        amount: amount ?? this.amount,
        currencyId: currencyId ?? this.currencyId,
        description: description ?? this.description,
        categoryId: categoryId ?? this.categoryId,
        date: date ?? this.date,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  OneshotPlan copyWithCompanion(OneshotPlansCompanion data) {
    return OneshotPlan(
      id: data.id.present ? data.id.value : this.id,
      amount: data.amount.present ? data.amount.value : this.amount,
      currencyId:
          data.currencyId.present ? data.currencyId.value : this.currencyId,
      description:
          data.description.present ? data.description.value : this.description,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      date: data.date.present ? data.date.value : this.date,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OneshotPlan(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('currencyId: $currencyId, ')
          ..write('description: $description, ')
          ..write('categoryId: $categoryId, ')
          ..write('date: $date, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, amount, currencyId, description,
      categoryId, date, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OneshotPlan &&
          other.id == this.id &&
          other.amount == this.amount &&
          other.currencyId == this.currencyId &&
          other.description == this.description &&
          other.categoryId == this.categoryId &&
          other.date == this.date &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class OneshotPlansCompanion extends UpdateCompanion<OneshotPlan> {
  final Value<int> id;
  final Value<double> amount;
  final Value<int> currencyId;
  final Value<String> description;
  final Value<int> categoryId;
  final Value<DateTime> date;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const OneshotPlansCompanion({
    this.id = const Value.absent(),
    this.amount = const Value.absent(),
    this.currencyId = const Value.absent(),
    this.description = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.date = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  OneshotPlansCompanion.insert({
    this.id = const Value.absent(),
    required double amount,
    required int currencyId,
    required String description,
    required int categoryId,
    required DateTime date,
    required DateTime createdAt,
    required DateTime updatedAt,
  })  : amount = Value(amount),
        currencyId = Value(currencyId),
        description = Value(description),
        categoryId = Value(categoryId),
        date = Value(date),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<OneshotPlan> custom({
    Expression<int>? id,
    Expression<double>? amount,
    Expression<int>? currencyId,
    Expression<String>? description,
    Expression<int>? categoryId,
    Expression<DateTime>? date,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) '_id': id,
      if (amount != null) '_amount': amount,
      if (currencyId != null) '_currencyId': currencyId,
      if (description != null) '_description': description,
      if (categoryId != null) '_categoryId': categoryId,
      if (date != null) '_date': date,
      if (createdAt != null) '_createdAt': createdAt,
      if (updatedAt != null) '_updatedAt': updatedAt,
    });
  }

  OneshotPlansCompanion copyWith(
      {Value<int>? id,
      Value<double>? amount,
      Value<int>? currencyId,
      Value<String>? description,
      Value<int>? categoryId,
      Value<DateTime>? date,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return OneshotPlansCompanion(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      currencyId: currencyId ?? this.currencyId,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['_id'] = Variable<int>(id.value);
    }
    if (amount.present) {
      map['_amount'] = Variable<double>(amount.value);
    }
    if (currencyId.present) {
      map['_currencyId'] = Variable<int>(currencyId.value);
    }
    if (description.present) {
      map['_description'] = Variable<String>(description.value);
    }
    if (categoryId.present) {
      map['_categoryId'] = Variable<int>(categoryId.value);
    }
    if (date.present) {
      map['_date'] = Variable<DateTime>(date.value);
    }
    if (createdAt.present) {
      map['_createdAt'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['_updatedAt'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OneshotPlansCompanion(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('currencyId: $currencyId, ')
          ..write('description: $description, ')
          ..write('categoryId: $categoryId, ')
          ..write('date: $date, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class IntervalPlans extends Table with TableInfo<IntervalPlans, IntervalPlan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  IntervalPlans(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      '_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'PRIMARY KEY');
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      '_amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _currencyIdMeta =
      const VerificationMeta('currencyId');
  late final GeneratedColumn<int> currencyId = GeneratedColumn<int>(
      '_currencyId', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL REFERENCES currencies(_id)');
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      '_description', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
      '_categoryId', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL REFERENCES categories(_id)');
  static const VerificationMeta _intervalMeta =
      const VerificationMeta('interval');
  late final GeneratedColumn<int> interval = GeneratedColumn<int>(
      '_interval', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _originMeta = const VerificationMeta('origin');
  late final GeneratedColumn<DateTime> origin = GeneratedColumn<DateTime>(
      '_origin', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _periodBeginsMeta =
      const VerificationMeta('periodBegins');
  late final GeneratedColumn<DateTime> periodBegins = GeneratedColumn<DateTime>(
      '_periodBegins', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _periodEndsMeta =
      const VerificationMeta('periodEnds');
  late final GeneratedColumn<DateTime> periodEnds = GeneratedColumn<DateTime>(
      '_periodEnds', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      '_createdAt', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      '_updatedAt', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  @override
  List<GeneratedColumn> get $columns => [
        id,
        amount,
        currencyId,
        description,
        categoryId,
        interval,
        origin,
        periodBegins,
        periodEnds,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'intervalPlans';
  @override
  VerificationContext validateIntegrity(Insertable<IntervalPlan> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('_id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['_id']!, _idMeta));
    }
    if (data.containsKey('_amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['_amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('_currencyId')) {
      context.handle(
          _currencyIdMeta,
          currencyId.isAcceptableOrUnknown(
              data['_currencyId']!, _currencyIdMeta));
    } else if (isInserting) {
      context.missing(_currencyIdMeta);
    }
    if (data.containsKey('_description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['_description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('_categoryId')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['_categoryId']!, _categoryIdMeta));
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('_interval')) {
      context.handle(_intervalMeta,
          interval.isAcceptableOrUnknown(data['_interval']!, _intervalMeta));
    } else if (isInserting) {
      context.missing(_intervalMeta);
    }
    if (data.containsKey('_origin')) {
      context.handle(_originMeta,
          origin.isAcceptableOrUnknown(data['_origin']!, _originMeta));
    } else if (isInserting) {
      context.missing(_originMeta);
    }
    if (data.containsKey('_periodBegins')) {
      context.handle(
          _periodBeginsMeta,
          periodBegins.isAcceptableOrUnknown(
              data['_periodBegins']!, _periodBeginsMeta));
    } else if (isInserting) {
      context.missing(_periodBeginsMeta);
    }
    if (data.containsKey('_periodEnds')) {
      context.handle(
          _periodEndsMeta,
          periodEnds.isAcceptableOrUnknown(
              data['_periodEnds']!, _periodEndsMeta));
    } else if (isInserting) {
      context.missing(_periodEndsMeta);
    }
    if (data.containsKey('_createdAt')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['_createdAt']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('_updatedAt')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['_updatedAt']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  IntervalPlan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IntervalPlan(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}_id'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}_amount'])!,
      currencyId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}_currencyId'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}_description'])!,
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}_categoryId'])!,
      interval: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}_interval'])!,
      origin: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}_origin'])!,
      periodBegins: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}_periodBegins'])!,
      periodEnds: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}_periodEnds'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}_createdAt'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}_updatedAt'])!,
    );
  }

  @override
  IntervalPlans createAlias(String alias) {
    return IntervalPlans(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class IntervalPlan extends DataClass implements Insertable<IntervalPlan> {
  final int id;
  final double amount;
  final int currencyId;
  final String description;
  final int categoryId;
  final int interval;
  final DateTime origin;
  final DateTime periodBegins;
  final DateTime periodEnds;
  final DateTime createdAt;
  final DateTime updatedAt;
  const IntervalPlan(
      {required this.id,
      required this.amount,
      required this.currencyId,
      required this.description,
      required this.categoryId,
      required this.interval,
      required this.origin,
      required this.periodBegins,
      required this.periodEnds,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['_id'] = Variable<int>(id);
    map['_amount'] = Variable<double>(amount);
    map['_currencyId'] = Variable<int>(currencyId);
    map['_description'] = Variable<String>(description);
    map['_categoryId'] = Variable<int>(categoryId);
    map['_interval'] = Variable<int>(interval);
    map['_origin'] = Variable<DateTime>(origin);
    map['_periodBegins'] = Variable<DateTime>(periodBegins);
    map['_periodEnds'] = Variable<DateTime>(periodEnds);
    map['_createdAt'] = Variable<DateTime>(createdAt);
    map['_updatedAt'] = Variable<DateTime>(updatedAt);
    return map;
  }

  IntervalPlansCompanion toCompanion(bool nullToAbsent) {
    return IntervalPlansCompanion(
      id: Value(id),
      amount: Value(amount),
      currencyId: Value(currencyId),
      description: Value(description),
      categoryId: Value(categoryId),
      interval: Value(interval),
      origin: Value(origin),
      periodBegins: Value(periodBegins),
      periodEnds: Value(periodEnds),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory IntervalPlan.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IntervalPlan(
      id: serializer.fromJson<int>(json['_id']),
      amount: serializer.fromJson<double>(json['_amount']),
      currencyId: serializer.fromJson<int>(json['_currencyId']),
      description: serializer.fromJson<String>(json['_description']),
      categoryId: serializer.fromJson<int>(json['_categoryId']),
      interval: serializer.fromJson<int>(json['_interval']),
      origin: serializer.fromJson<DateTime>(json['_origin']),
      periodBegins: serializer.fromJson<DateTime>(json['_periodBegins']),
      periodEnds: serializer.fromJson<DateTime>(json['_periodEnds']),
      createdAt: serializer.fromJson<DateTime>(json['_createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['_updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      '_id': serializer.toJson<int>(id),
      '_amount': serializer.toJson<double>(amount),
      '_currencyId': serializer.toJson<int>(currencyId),
      '_description': serializer.toJson<String>(description),
      '_categoryId': serializer.toJson<int>(categoryId),
      '_interval': serializer.toJson<int>(interval),
      '_origin': serializer.toJson<DateTime>(origin),
      '_periodBegins': serializer.toJson<DateTime>(periodBegins),
      '_periodEnds': serializer.toJson<DateTime>(periodEnds),
      '_createdAt': serializer.toJson<DateTime>(createdAt),
      '_updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  IntervalPlan copyWith(
          {int? id,
          double? amount,
          int? currencyId,
          String? description,
          int? categoryId,
          int? interval,
          DateTime? origin,
          DateTime? periodBegins,
          DateTime? periodEnds,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      IntervalPlan(
        id: id ?? this.id,
        amount: amount ?? this.amount,
        currencyId: currencyId ?? this.currencyId,
        description: description ?? this.description,
        categoryId: categoryId ?? this.categoryId,
        interval: interval ?? this.interval,
        origin: origin ?? this.origin,
        periodBegins: periodBegins ?? this.periodBegins,
        periodEnds: periodEnds ?? this.periodEnds,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  IntervalPlan copyWithCompanion(IntervalPlansCompanion data) {
    return IntervalPlan(
      id: data.id.present ? data.id.value : this.id,
      amount: data.amount.present ? data.amount.value : this.amount,
      currencyId:
          data.currencyId.present ? data.currencyId.value : this.currencyId,
      description:
          data.description.present ? data.description.value : this.description,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      interval: data.interval.present ? data.interval.value : this.interval,
      origin: data.origin.present ? data.origin.value : this.origin,
      periodBegins: data.periodBegins.present
          ? data.periodBegins.value
          : this.periodBegins,
      periodEnds:
          data.periodEnds.present ? data.periodEnds.value : this.periodEnds,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IntervalPlan(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('currencyId: $currencyId, ')
          ..write('description: $description, ')
          ..write('categoryId: $categoryId, ')
          ..write('interval: $interval, ')
          ..write('origin: $origin, ')
          ..write('periodBegins: $periodBegins, ')
          ..write('periodEnds: $periodEnds, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      amount,
      currencyId,
      description,
      categoryId,
      interval,
      origin,
      periodBegins,
      periodEnds,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IntervalPlan &&
          other.id == this.id &&
          other.amount == this.amount &&
          other.currencyId == this.currencyId &&
          other.description == this.description &&
          other.categoryId == this.categoryId &&
          other.interval == this.interval &&
          other.origin == this.origin &&
          other.periodBegins == this.periodBegins &&
          other.periodEnds == this.periodEnds &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class IntervalPlansCompanion extends UpdateCompanion<IntervalPlan> {
  final Value<int> id;
  final Value<double> amount;
  final Value<int> currencyId;
  final Value<String> description;
  final Value<int> categoryId;
  final Value<int> interval;
  final Value<DateTime> origin;
  final Value<DateTime> periodBegins;
  final Value<DateTime> periodEnds;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const IntervalPlansCompanion({
    this.id = const Value.absent(),
    this.amount = const Value.absent(),
    this.currencyId = const Value.absent(),
    this.description = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.interval = const Value.absent(),
    this.origin = const Value.absent(),
    this.periodBegins = const Value.absent(),
    this.periodEnds = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  IntervalPlansCompanion.insert({
    this.id = const Value.absent(),
    required double amount,
    required int currencyId,
    required String description,
    required int categoryId,
    required int interval,
    required DateTime origin,
    required DateTime periodBegins,
    required DateTime periodEnds,
    required DateTime createdAt,
    required DateTime updatedAt,
  })  : amount = Value(amount),
        currencyId = Value(currencyId),
        description = Value(description),
        categoryId = Value(categoryId),
        interval = Value(interval),
        origin = Value(origin),
        periodBegins = Value(periodBegins),
        periodEnds = Value(periodEnds),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<IntervalPlan> custom({
    Expression<int>? id,
    Expression<double>? amount,
    Expression<int>? currencyId,
    Expression<String>? description,
    Expression<int>? categoryId,
    Expression<int>? interval,
    Expression<DateTime>? origin,
    Expression<DateTime>? periodBegins,
    Expression<DateTime>? periodEnds,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) '_id': id,
      if (amount != null) '_amount': amount,
      if (currencyId != null) '_currencyId': currencyId,
      if (description != null) '_description': description,
      if (categoryId != null) '_categoryId': categoryId,
      if (interval != null) '_interval': interval,
      if (origin != null) '_origin': origin,
      if (periodBegins != null) '_periodBegins': periodBegins,
      if (periodEnds != null) '_periodEnds': periodEnds,
      if (createdAt != null) '_createdAt': createdAt,
      if (updatedAt != null) '_updatedAt': updatedAt,
    });
  }

  IntervalPlansCompanion copyWith(
      {Value<int>? id,
      Value<double>? amount,
      Value<int>? currencyId,
      Value<String>? description,
      Value<int>? categoryId,
      Value<int>? interval,
      Value<DateTime>? origin,
      Value<DateTime>? periodBegins,
      Value<DateTime>? periodEnds,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return IntervalPlansCompanion(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      currencyId: currencyId ?? this.currencyId,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      interval: interval ?? this.interval,
      origin: origin ?? this.origin,
      periodBegins: periodBegins ?? this.periodBegins,
      periodEnds: periodEnds ?? this.periodEnds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['_id'] = Variable<int>(id.value);
    }
    if (amount.present) {
      map['_amount'] = Variable<double>(amount.value);
    }
    if (currencyId.present) {
      map['_currencyId'] = Variable<int>(currencyId.value);
    }
    if (description.present) {
      map['_description'] = Variable<String>(description.value);
    }
    if (categoryId.present) {
      map['_categoryId'] = Variable<int>(categoryId.value);
    }
    if (interval.present) {
      map['_interval'] = Variable<int>(interval.value);
    }
    if (origin.present) {
      map['_origin'] = Variable<DateTime>(origin.value);
    }
    if (periodBegins.present) {
      map['_periodBegins'] = Variable<DateTime>(periodBegins.value);
    }
    if (periodEnds.present) {
      map['_periodEnds'] = Variable<DateTime>(periodEnds.value);
    }
    if (createdAt.present) {
      map['_createdAt'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['_updatedAt'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IntervalPlansCompanion(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('currencyId: $currencyId, ')
          ..write('description: $description, ')
          ..write('categoryId: $categoryId, ')
          ..write('interval: $interval, ')
          ..write('origin: $origin, ')
          ..write('periodBegins: $periodBegins, ')
          ..write('periodEnds: $periodEnds, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class WeeklyPlans extends Table with TableInfo<WeeklyPlans, WeeklyPlan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  WeeklyPlans(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      '_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'PRIMARY KEY');
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      '_amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _currencyIdMeta =
      const VerificationMeta('currencyId');
  late final GeneratedColumn<int> currencyId = GeneratedColumn<int>(
      '_currencyId', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL REFERENCES currencies(_id)');
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      '_description', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
      '_categoryId', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL REFERENCES categories(_id)');
  static const VerificationMeta _sundayMeta = const VerificationMeta('sunday');
  late final GeneratedColumn<bool> sunday = GeneratedColumn<bool>(
      '_sunday', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _mondayMeta = const VerificationMeta('monday');
  late final GeneratedColumn<bool> monday = GeneratedColumn<bool>(
      '_monday', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _tuesdayMeta =
      const VerificationMeta('tuesday');
  late final GeneratedColumn<bool> tuesday = GeneratedColumn<bool>(
      '_tuesday', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _wednesdayMeta =
      const VerificationMeta('wednesday');
  late final GeneratedColumn<bool> wednesday = GeneratedColumn<bool>(
      '_wednesday', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _thursdayMeta =
      const VerificationMeta('thursday');
  late final GeneratedColumn<bool> thursday = GeneratedColumn<bool>(
      '_thursday', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _fridayMeta = const VerificationMeta('friday');
  late final GeneratedColumn<bool> friday = GeneratedColumn<bool>(
      '_friday', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _saturdayMeta =
      const VerificationMeta('saturday');
  late final GeneratedColumn<bool> saturday = GeneratedColumn<bool>(
      '_saturday', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _periodBeginsMeta =
      const VerificationMeta('periodBegins');
  late final GeneratedColumn<DateTime> periodBegins = GeneratedColumn<DateTime>(
      '_periodBegins', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _periodEndsMeta =
      const VerificationMeta('periodEnds');
  late final GeneratedColumn<DateTime> periodEnds = GeneratedColumn<DateTime>(
      '_periodEnds', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      '_createdAt', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      '_updatedAt', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  @override
  List<GeneratedColumn> get $columns => [
        id,
        amount,
        currencyId,
        description,
        categoryId,
        sunday,
        monday,
        tuesday,
        wednesday,
        thursday,
        friday,
        saturday,
        periodBegins,
        periodEnds,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weeklyPlans';
  @override
  VerificationContext validateIntegrity(Insertable<WeeklyPlan> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('_id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['_id']!, _idMeta));
    }
    if (data.containsKey('_amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['_amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('_currencyId')) {
      context.handle(
          _currencyIdMeta,
          currencyId.isAcceptableOrUnknown(
              data['_currencyId']!, _currencyIdMeta));
    } else if (isInserting) {
      context.missing(_currencyIdMeta);
    }
    if (data.containsKey('_description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['_description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('_categoryId')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['_categoryId']!, _categoryIdMeta));
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('_sunday')) {
      context.handle(_sundayMeta,
          sunday.isAcceptableOrUnknown(data['_sunday']!, _sundayMeta));
    } else if (isInserting) {
      context.missing(_sundayMeta);
    }
    if (data.containsKey('_monday')) {
      context.handle(_mondayMeta,
          monday.isAcceptableOrUnknown(data['_monday']!, _mondayMeta));
    } else if (isInserting) {
      context.missing(_mondayMeta);
    }
    if (data.containsKey('_tuesday')) {
      context.handle(_tuesdayMeta,
          tuesday.isAcceptableOrUnknown(data['_tuesday']!, _tuesdayMeta));
    } else if (isInserting) {
      context.missing(_tuesdayMeta);
    }
    if (data.containsKey('_wednesday')) {
      context.handle(_wednesdayMeta,
          wednesday.isAcceptableOrUnknown(data['_wednesday']!, _wednesdayMeta));
    } else if (isInserting) {
      context.missing(_wednesdayMeta);
    }
    if (data.containsKey('_thursday')) {
      context.handle(_thursdayMeta,
          thursday.isAcceptableOrUnknown(data['_thursday']!, _thursdayMeta));
    } else if (isInserting) {
      context.missing(_thursdayMeta);
    }
    if (data.containsKey('_friday')) {
      context.handle(_fridayMeta,
          friday.isAcceptableOrUnknown(data['_friday']!, _fridayMeta));
    } else if (isInserting) {
      context.missing(_fridayMeta);
    }
    if (data.containsKey('_saturday')) {
      context.handle(_saturdayMeta,
          saturday.isAcceptableOrUnknown(data['_saturday']!, _saturdayMeta));
    } else if (isInserting) {
      context.missing(_saturdayMeta);
    }
    if (data.containsKey('_periodBegins')) {
      context.handle(
          _periodBeginsMeta,
          periodBegins.isAcceptableOrUnknown(
              data['_periodBegins']!, _periodBeginsMeta));
    } else if (isInserting) {
      context.missing(_periodBeginsMeta);
    }
    if (data.containsKey('_periodEnds')) {
      context.handle(
          _periodEndsMeta,
          periodEnds.isAcceptableOrUnknown(
              data['_periodEnds']!, _periodEndsMeta));
    } else if (isInserting) {
      context.missing(_periodEndsMeta);
    }
    if (data.containsKey('_createdAt')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['_createdAt']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('_updatedAt')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['_updatedAt']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WeeklyPlan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeeklyPlan(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}_id'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}_amount'])!,
      currencyId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}_currencyId'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}_description'])!,
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}_categoryId'])!,
      sunday: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}_sunday'])!,
      monday: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}_monday'])!,
      tuesday: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}_tuesday'])!,
      wednesday: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}_wednesday'])!,
      thursday: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}_thursday'])!,
      friday: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}_friday'])!,
      saturday: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}_saturday'])!,
      periodBegins: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}_periodBegins'])!,
      periodEnds: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}_periodEnds'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}_createdAt'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}_updatedAt'])!,
    );
  }

  @override
  WeeklyPlans createAlias(String alias) {
    return WeeklyPlans(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class WeeklyPlan extends DataClass implements Insertable<WeeklyPlan> {
  final int id;
  final double amount;
  final int currencyId;
  final String description;
  final int categoryId;
  final bool sunday;
  final bool monday;
  final bool tuesday;
  final bool wednesday;
  final bool thursday;
  final bool friday;
  final bool saturday;
  final DateTime periodBegins;
  final DateTime periodEnds;
  final DateTime createdAt;
  final DateTime updatedAt;
  const WeeklyPlan(
      {required this.id,
      required this.amount,
      required this.currencyId,
      required this.description,
      required this.categoryId,
      required this.sunday,
      required this.monday,
      required this.tuesday,
      required this.wednesday,
      required this.thursday,
      required this.friday,
      required this.saturday,
      required this.periodBegins,
      required this.periodEnds,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['_id'] = Variable<int>(id);
    map['_amount'] = Variable<double>(amount);
    map['_currencyId'] = Variable<int>(currencyId);
    map['_description'] = Variable<String>(description);
    map['_categoryId'] = Variable<int>(categoryId);
    map['_sunday'] = Variable<bool>(sunday);
    map['_monday'] = Variable<bool>(monday);
    map['_tuesday'] = Variable<bool>(tuesday);
    map['_wednesday'] = Variable<bool>(wednesday);
    map['_thursday'] = Variable<bool>(thursday);
    map['_friday'] = Variable<bool>(friday);
    map['_saturday'] = Variable<bool>(saturday);
    map['_periodBegins'] = Variable<DateTime>(periodBegins);
    map['_periodEnds'] = Variable<DateTime>(periodEnds);
    map['_createdAt'] = Variable<DateTime>(createdAt);
    map['_updatedAt'] = Variable<DateTime>(updatedAt);
    return map;
  }

  WeeklyPlansCompanion toCompanion(bool nullToAbsent) {
    return WeeklyPlansCompanion(
      id: Value(id),
      amount: Value(amount),
      currencyId: Value(currencyId),
      description: Value(description),
      categoryId: Value(categoryId),
      sunday: Value(sunday),
      monday: Value(monday),
      tuesday: Value(tuesday),
      wednesday: Value(wednesday),
      thursday: Value(thursday),
      friday: Value(friday),
      saturday: Value(saturday),
      periodBegins: Value(periodBegins),
      periodEnds: Value(periodEnds),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory WeeklyPlan.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeeklyPlan(
      id: serializer.fromJson<int>(json['_id']),
      amount: serializer.fromJson<double>(json['_amount']),
      currencyId: serializer.fromJson<int>(json['_currencyId']),
      description: serializer.fromJson<String>(json['_description']),
      categoryId: serializer.fromJson<int>(json['_categoryId']),
      sunday: serializer.fromJson<bool>(json['_sunday']),
      monday: serializer.fromJson<bool>(json['_monday']),
      tuesday: serializer.fromJson<bool>(json['_tuesday']),
      wednesday: serializer.fromJson<bool>(json['_wednesday']),
      thursday: serializer.fromJson<bool>(json['_thursday']),
      friday: serializer.fromJson<bool>(json['_friday']),
      saturday: serializer.fromJson<bool>(json['_saturday']),
      periodBegins: serializer.fromJson<DateTime>(json['_periodBegins']),
      periodEnds: serializer.fromJson<DateTime>(json['_periodEnds']),
      createdAt: serializer.fromJson<DateTime>(json['_createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['_updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      '_id': serializer.toJson<int>(id),
      '_amount': serializer.toJson<double>(amount),
      '_currencyId': serializer.toJson<int>(currencyId),
      '_description': serializer.toJson<String>(description),
      '_categoryId': serializer.toJson<int>(categoryId),
      '_sunday': serializer.toJson<bool>(sunday),
      '_monday': serializer.toJson<bool>(monday),
      '_tuesday': serializer.toJson<bool>(tuesday),
      '_wednesday': serializer.toJson<bool>(wednesday),
      '_thursday': serializer.toJson<bool>(thursday),
      '_friday': serializer.toJson<bool>(friday),
      '_saturday': serializer.toJson<bool>(saturday),
      '_periodBegins': serializer.toJson<DateTime>(periodBegins),
      '_periodEnds': serializer.toJson<DateTime>(periodEnds),
      '_createdAt': serializer.toJson<DateTime>(createdAt),
      '_updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  WeeklyPlan copyWith(
          {int? id,
          double? amount,
          int? currencyId,
          String? description,
          int? categoryId,
          bool? sunday,
          bool? monday,
          bool? tuesday,
          bool? wednesday,
          bool? thursday,
          bool? friday,
          bool? saturday,
          DateTime? periodBegins,
          DateTime? periodEnds,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      WeeklyPlan(
        id: id ?? this.id,
        amount: amount ?? this.amount,
        currencyId: currencyId ?? this.currencyId,
        description: description ?? this.description,
        categoryId: categoryId ?? this.categoryId,
        sunday: sunday ?? this.sunday,
        monday: monday ?? this.monday,
        tuesday: tuesday ?? this.tuesday,
        wednesday: wednesday ?? this.wednesday,
        thursday: thursday ?? this.thursday,
        friday: friday ?? this.friday,
        saturday: saturday ?? this.saturday,
        periodBegins: periodBegins ?? this.periodBegins,
        periodEnds: periodEnds ?? this.periodEnds,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  WeeklyPlan copyWithCompanion(WeeklyPlansCompanion data) {
    return WeeklyPlan(
      id: data.id.present ? data.id.value : this.id,
      amount: data.amount.present ? data.amount.value : this.amount,
      currencyId:
          data.currencyId.present ? data.currencyId.value : this.currencyId,
      description:
          data.description.present ? data.description.value : this.description,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      sunday: data.sunday.present ? data.sunday.value : this.sunday,
      monday: data.monday.present ? data.monday.value : this.monday,
      tuesday: data.tuesday.present ? data.tuesday.value : this.tuesday,
      wednesday: data.wednesday.present ? data.wednesday.value : this.wednesday,
      thursday: data.thursday.present ? data.thursday.value : this.thursday,
      friday: data.friday.present ? data.friday.value : this.friday,
      saturday: data.saturday.present ? data.saturday.value : this.saturday,
      periodBegins: data.periodBegins.present
          ? data.periodBegins.value
          : this.periodBegins,
      periodEnds:
          data.periodEnds.present ? data.periodEnds.value : this.periodEnds,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeeklyPlan(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('currencyId: $currencyId, ')
          ..write('description: $description, ')
          ..write('categoryId: $categoryId, ')
          ..write('sunday: $sunday, ')
          ..write('monday: $monday, ')
          ..write('tuesday: $tuesday, ')
          ..write('wednesday: $wednesday, ')
          ..write('thursday: $thursday, ')
          ..write('friday: $friday, ')
          ..write('saturday: $saturday, ')
          ..write('periodBegins: $periodBegins, ')
          ..write('periodEnds: $periodEnds, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      amount,
      currencyId,
      description,
      categoryId,
      sunday,
      monday,
      tuesday,
      wednesday,
      thursday,
      friday,
      saturday,
      periodBegins,
      periodEnds,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeeklyPlan &&
          other.id == this.id &&
          other.amount == this.amount &&
          other.currencyId == this.currencyId &&
          other.description == this.description &&
          other.categoryId == this.categoryId &&
          other.sunday == this.sunday &&
          other.monday == this.monday &&
          other.tuesday == this.tuesday &&
          other.wednesday == this.wednesday &&
          other.thursday == this.thursday &&
          other.friday == this.friday &&
          other.saturday == this.saturday &&
          other.periodBegins == this.periodBegins &&
          other.periodEnds == this.periodEnds &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class WeeklyPlansCompanion extends UpdateCompanion<WeeklyPlan> {
  final Value<int> id;
  final Value<double> amount;
  final Value<int> currencyId;
  final Value<String> description;
  final Value<int> categoryId;
  final Value<bool> sunday;
  final Value<bool> monday;
  final Value<bool> tuesday;
  final Value<bool> wednesday;
  final Value<bool> thursday;
  final Value<bool> friday;
  final Value<bool> saturday;
  final Value<DateTime> periodBegins;
  final Value<DateTime> periodEnds;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const WeeklyPlansCompanion({
    this.id = const Value.absent(),
    this.amount = const Value.absent(),
    this.currencyId = const Value.absent(),
    this.description = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.sunday = const Value.absent(),
    this.monday = const Value.absent(),
    this.tuesday = const Value.absent(),
    this.wednesday = const Value.absent(),
    this.thursday = const Value.absent(),
    this.friday = const Value.absent(),
    this.saturday = const Value.absent(),
    this.periodBegins = const Value.absent(),
    this.periodEnds = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  WeeklyPlansCompanion.insert({
    this.id = const Value.absent(),
    required double amount,
    required int currencyId,
    required String description,
    required int categoryId,
    required bool sunday,
    required bool monday,
    required bool tuesday,
    required bool wednesday,
    required bool thursday,
    required bool friday,
    required bool saturday,
    required DateTime periodBegins,
    required DateTime periodEnds,
    required DateTime createdAt,
    required DateTime updatedAt,
  })  : amount = Value(amount),
        currencyId = Value(currencyId),
        description = Value(description),
        categoryId = Value(categoryId),
        sunday = Value(sunday),
        monday = Value(monday),
        tuesday = Value(tuesday),
        wednesday = Value(wednesday),
        thursday = Value(thursday),
        friday = Value(friday),
        saturday = Value(saturday),
        periodBegins = Value(periodBegins),
        periodEnds = Value(periodEnds),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<WeeklyPlan> custom({
    Expression<int>? id,
    Expression<double>? amount,
    Expression<int>? currencyId,
    Expression<String>? description,
    Expression<int>? categoryId,
    Expression<bool>? sunday,
    Expression<bool>? monday,
    Expression<bool>? tuesday,
    Expression<bool>? wednesday,
    Expression<bool>? thursday,
    Expression<bool>? friday,
    Expression<bool>? saturday,
    Expression<DateTime>? periodBegins,
    Expression<DateTime>? periodEnds,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) '_id': id,
      if (amount != null) '_amount': amount,
      if (currencyId != null) '_currencyId': currencyId,
      if (description != null) '_description': description,
      if (categoryId != null) '_categoryId': categoryId,
      if (sunday != null) '_sunday': sunday,
      if (monday != null) '_monday': monday,
      if (tuesday != null) '_tuesday': tuesday,
      if (wednesday != null) '_wednesday': wednesday,
      if (thursday != null) '_thursday': thursday,
      if (friday != null) '_friday': friday,
      if (saturday != null) '_saturday': saturday,
      if (periodBegins != null) '_periodBegins': periodBegins,
      if (periodEnds != null) '_periodEnds': periodEnds,
      if (createdAt != null) '_createdAt': createdAt,
      if (updatedAt != null) '_updatedAt': updatedAt,
    });
  }

  WeeklyPlansCompanion copyWith(
      {Value<int>? id,
      Value<double>? amount,
      Value<int>? currencyId,
      Value<String>? description,
      Value<int>? categoryId,
      Value<bool>? sunday,
      Value<bool>? monday,
      Value<bool>? tuesday,
      Value<bool>? wednesday,
      Value<bool>? thursday,
      Value<bool>? friday,
      Value<bool>? saturday,
      Value<DateTime>? periodBegins,
      Value<DateTime>? periodEnds,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return WeeklyPlansCompanion(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      currencyId: currencyId ?? this.currencyId,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      sunday: sunday ?? this.sunday,
      monday: monday ?? this.monday,
      tuesday: tuesday ?? this.tuesday,
      wednesday: wednesday ?? this.wednesday,
      thursday: thursday ?? this.thursday,
      friday: friday ?? this.friday,
      saturday: saturday ?? this.saturday,
      periodBegins: periodBegins ?? this.periodBegins,
      periodEnds: periodEnds ?? this.periodEnds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['_id'] = Variable<int>(id.value);
    }
    if (amount.present) {
      map['_amount'] = Variable<double>(amount.value);
    }
    if (currencyId.present) {
      map['_currencyId'] = Variable<int>(currencyId.value);
    }
    if (description.present) {
      map['_description'] = Variable<String>(description.value);
    }
    if (categoryId.present) {
      map['_categoryId'] = Variable<int>(categoryId.value);
    }
    if (sunday.present) {
      map['_sunday'] = Variable<bool>(sunday.value);
    }
    if (monday.present) {
      map['_monday'] = Variable<bool>(monday.value);
    }
    if (tuesday.present) {
      map['_tuesday'] = Variable<bool>(tuesday.value);
    }
    if (wednesday.present) {
      map['_wednesday'] = Variable<bool>(wednesday.value);
    }
    if (thursday.present) {
      map['_thursday'] = Variable<bool>(thursday.value);
    }
    if (friday.present) {
      map['_friday'] = Variable<bool>(friday.value);
    }
    if (saturday.present) {
      map['_saturday'] = Variable<bool>(saturday.value);
    }
    if (periodBegins.present) {
      map['_periodBegins'] = Variable<DateTime>(periodBegins.value);
    }
    if (periodEnds.present) {
      map['_periodEnds'] = Variable<DateTime>(periodEnds.value);
    }
    if (createdAt.present) {
      map['_createdAt'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['_updatedAt'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeeklyPlansCompanion(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('currencyId: $currencyId, ')
          ..write('description: $description, ')
          ..write('categoryId: $categoryId, ')
          ..write('sunday: $sunday, ')
          ..write('monday: $monday, ')
          ..write('tuesday: $tuesday, ')
          ..write('wednesday: $wednesday, ')
          ..write('thursday: $thursday, ')
          ..write('friday: $friday, ')
          ..write('saturday: $saturday, ')
          ..write('periodBegins: $periodBegins, ')
          ..write('periodEnds: $periodEnds, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class MonthlyPlans extends Table with TableInfo<MonthlyPlans, MonthlyPlan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  MonthlyPlans(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      '_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'PRIMARY KEY');
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      '_amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _currencyIdMeta =
      const VerificationMeta('currencyId');
  late final GeneratedColumn<int> currencyId = GeneratedColumn<int>(
      '_currencyId', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL REFERENCES currencies(_id)');
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      '_description', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
      '_categoryId', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL REFERENCES categories(_id)');
  static const VerificationMeta _offsetMeta = const VerificationMeta('offset');
  late final GeneratedColumn<int> offset = GeneratedColumn<int>(
      '_offset', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _periodBeginsMeta =
      const VerificationMeta('periodBegins');
  late final GeneratedColumn<DateTime> periodBegins = GeneratedColumn<DateTime>(
      '_periodBegins', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _periodEndsMeta =
      const VerificationMeta('periodEnds');
  late final GeneratedColumn<DateTime> periodEnds = GeneratedColumn<DateTime>(
      '_periodEnds', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      '_createdAt', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      '_updatedAt', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  @override
  List<GeneratedColumn> get $columns => [
        id,
        amount,
        currencyId,
        description,
        categoryId,
        offset,
        periodBegins,
        periodEnds,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'monthlyPlans';
  @override
  VerificationContext validateIntegrity(Insertable<MonthlyPlan> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('_id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['_id']!, _idMeta));
    }
    if (data.containsKey('_amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['_amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('_currencyId')) {
      context.handle(
          _currencyIdMeta,
          currencyId.isAcceptableOrUnknown(
              data['_currencyId']!, _currencyIdMeta));
    } else if (isInserting) {
      context.missing(_currencyIdMeta);
    }
    if (data.containsKey('_description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['_description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('_categoryId')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['_categoryId']!, _categoryIdMeta));
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('_offset')) {
      context.handle(_offsetMeta,
          offset.isAcceptableOrUnknown(data['_offset']!, _offsetMeta));
    } else if (isInserting) {
      context.missing(_offsetMeta);
    }
    if (data.containsKey('_periodBegins')) {
      context.handle(
          _periodBeginsMeta,
          periodBegins.isAcceptableOrUnknown(
              data['_periodBegins']!, _periodBeginsMeta));
    } else if (isInserting) {
      context.missing(_periodBeginsMeta);
    }
    if (data.containsKey('_periodEnds')) {
      context.handle(
          _periodEndsMeta,
          periodEnds.isAcceptableOrUnknown(
              data['_periodEnds']!, _periodEndsMeta));
    } else if (isInserting) {
      context.missing(_periodEndsMeta);
    }
    if (data.containsKey('_createdAt')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['_createdAt']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('_updatedAt')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['_updatedAt']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MonthlyPlan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MonthlyPlan(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}_id'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}_amount'])!,
      currencyId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}_currencyId'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}_description'])!,
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}_categoryId'])!,
      offset: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}_offset'])!,
      periodBegins: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}_periodBegins'])!,
      periodEnds: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}_periodEnds'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}_createdAt'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}_updatedAt'])!,
    );
  }

  @override
  MonthlyPlans createAlias(String alias) {
    return MonthlyPlans(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class MonthlyPlan extends DataClass implements Insertable<MonthlyPlan> {
  final int id;
  final double amount;
  final int currencyId;
  final String description;
  final int categoryId;
  final int offset;
  final DateTime periodBegins;
  final DateTime periodEnds;
  final DateTime createdAt;
  final DateTime updatedAt;
  const MonthlyPlan(
      {required this.id,
      required this.amount,
      required this.currencyId,
      required this.description,
      required this.categoryId,
      required this.offset,
      required this.periodBegins,
      required this.periodEnds,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['_id'] = Variable<int>(id);
    map['_amount'] = Variable<double>(amount);
    map['_currencyId'] = Variable<int>(currencyId);
    map['_description'] = Variable<String>(description);
    map['_categoryId'] = Variable<int>(categoryId);
    map['_offset'] = Variable<int>(offset);
    map['_periodBegins'] = Variable<DateTime>(periodBegins);
    map['_periodEnds'] = Variable<DateTime>(periodEnds);
    map['_createdAt'] = Variable<DateTime>(createdAt);
    map['_updatedAt'] = Variable<DateTime>(updatedAt);
    return map;
  }

  MonthlyPlansCompanion toCompanion(bool nullToAbsent) {
    return MonthlyPlansCompanion(
      id: Value(id),
      amount: Value(amount),
      currencyId: Value(currencyId),
      description: Value(description),
      categoryId: Value(categoryId),
      offset: Value(offset),
      periodBegins: Value(periodBegins),
      periodEnds: Value(periodEnds),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory MonthlyPlan.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MonthlyPlan(
      id: serializer.fromJson<int>(json['_id']),
      amount: serializer.fromJson<double>(json['_amount']),
      currencyId: serializer.fromJson<int>(json['_currencyId']),
      description: serializer.fromJson<String>(json['_description']),
      categoryId: serializer.fromJson<int>(json['_categoryId']),
      offset: serializer.fromJson<int>(json['_offset']),
      periodBegins: serializer.fromJson<DateTime>(json['_periodBegins']),
      periodEnds: serializer.fromJson<DateTime>(json['_periodEnds']),
      createdAt: serializer.fromJson<DateTime>(json['_createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['_updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      '_id': serializer.toJson<int>(id),
      '_amount': serializer.toJson<double>(amount),
      '_currencyId': serializer.toJson<int>(currencyId),
      '_description': serializer.toJson<String>(description),
      '_categoryId': serializer.toJson<int>(categoryId),
      '_offset': serializer.toJson<int>(offset),
      '_periodBegins': serializer.toJson<DateTime>(periodBegins),
      '_periodEnds': serializer.toJson<DateTime>(periodEnds),
      '_createdAt': serializer.toJson<DateTime>(createdAt),
      '_updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  MonthlyPlan copyWith(
          {int? id,
          double? amount,
          int? currencyId,
          String? description,
          int? categoryId,
          int? offset,
          DateTime? periodBegins,
          DateTime? periodEnds,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      MonthlyPlan(
        id: id ?? this.id,
        amount: amount ?? this.amount,
        currencyId: currencyId ?? this.currencyId,
        description: description ?? this.description,
        categoryId: categoryId ?? this.categoryId,
        offset: offset ?? this.offset,
        periodBegins: periodBegins ?? this.periodBegins,
        periodEnds: periodEnds ?? this.periodEnds,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  MonthlyPlan copyWithCompanion(MonthlyPlansCompanion data) {
    return MonthlyPlan(
      id: data.id.present ? data.id.value : this.id,
      amount: data.amount.present ? data.amount.value : this.amount,
      currencyId:
          data.currencyId.present ? data.currencyId.value : this.currencyId,
      description:
          data.description.present ? data.description.value : this.description,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      offset: data.offset.present ? data.offset.value : this.offset,
      periodBegins: data.periodBegins.present
          ? data.periodBegins.value
          : this.periodBegins,
      periodEnds:
          data.periodEnds.present ? data.periodEnds.value : this.periodEnds,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MonthlyPlan(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('currencyId: $currencyId, ')
          ..write('description: $description, ')
          ..write('categoryId: $categoryId, ')
          ..write('offset: $offset, ')
          ..write('periodBegins: $periodBegins, ')
          ..write('periodEnds: $periodEnds, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, amount, currencyId, description,
      categoryId, offset, periodBegins, periodEnds, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MonthlyPlan &&
          other.id == this.id &&
          other.amount == this.amount &&
          other.currencyId == this.currencyId &&
          other.description == this.description &&
          other.categoryId == this.categoryId &&
          other.offset == this.offset &&
          other.periodBegins == this.periodBegins &&
          other.periodEnds == this.periodEnds &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MonthlyPlansCompanion extends UpdateCompanion<MonthlyPlan> {
  final Value<int> id;
  final Value<double> amount;
  final Value<int> currencyId;
  final Value<String> description;
  final Value<int> categoryId;
  final Value<int> offset;
  final Value<DateTime> periodBegins;
  final Value<DateTime> periodEnds;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const MonthlyPlansCompanion({
    this.id = const Value.absent(),
    this.amount = const Value.absent(),
    this.currencyId = const Value.absent(),
    this.description = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.offset = const Value.absent(),
    this.periodBegins = const Value.absent(),
    this.periodEnds = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  MonthlyPlansCompanion.insert({
    this.id = const Value.absent(),
    required double amount,
    required int currencyId,
    required String description,
    required int categoryId,
    required int offset,
    required DateTime periodBegins,
    required DateTime periodEnds,
    required DateTime createdAt,
    required DateTime updatedAt,
  })  : amount = Value(amount),
        currencyId = Value(currencyId),
        description = Value(description),
        categoryId = Value(categoryId),
        offset = Value(offset),
        periodBegins = Value(periodBegins),
        periodEnds = Value(periodEnds),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<MonthlyPlan> custom({
    Expression<int>? id,
    Expression<double>? amount,
    Expression<int>? currencyId,
    Expression<String>? description,
    Expression<int>? categoryId,
    Expression<int>? offset,
    Expression<DateTime>? periodBegins,
    Expression<DateTime>? periodEnds,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) '_id': id,
      if (amount != null) '_amount': amount,
      if (currencyId != null) '_currencyId': currencyId,
      if (description != null) '_description': description,
      if (categoryId != null) '_categoryId': categoryId,
      if (offset != null) '_offset': offset,
      if (periodBegins != null) '_periodBegins': periodBegins,
      if (periodEnds != null) '_periodEnds': periodEnds,
      if (createdAt != null) '_createdAt': createdAt,
      if (updatedAt != null) '_updatedAt': updatedAt,
    });
  }

  MonthlyPlansCompanion copyWith(
      {Value<int>? id,
      Value<double>? amount,
      Value<int>? currencyId,
      Value<String>? description,
      Value<int>? categoryId,
      Value<int>? offset,
      Value<DateTime>? periodBegins,
      Value<DateTime>? periodEnds,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return MonthlyPlansCompanion(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      currencyId: currencyId ?? this.currencyId,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      offset: offset ?? this.offset,
      periodBegins: periodBegins ?? this.periodBegins,
      periodEnds: periodEnds ?? this.periodEnds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['_id'] = Variable<int>(id.value);
    }
    if (amount.present) {
      map['_amount'] = Variable<double>(amount.value);
    }
    if (currencyId.present) {
      map['_currencyId'] = Variable<int>(currencyId.value);
    }
    if (description.present) {
      map['_description'] = Variable<String>(description.value);
    }
    if (categoryId.present) {
      map['_categoryId'] = Variable<int>(categoryId.value);
    }
    if (offset.present) {
      map['_offset'] = Variable<int>(offset.value);
    }
    if (periodBegins.present) {
      map['_periodBegins'] = Variable<DateTime>(periodBegins.value);
    }
    if (periodEnds.present) {
      map['_periodEnds'] = Variable<DateTime>(periodEnds.value);
    }
    if (createdAt.present) {
      map['_createdAt'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['_updatedAt'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MonthlyPlansCompanion(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('currencyId: $currencyId, ')
          ..write('description: $description, ')
          ..write('categoryId: $categoryId, ')
          ..write('offset: $offset, ')
          ..write('periodBegins: $periodBegins, ')
          ..write('periodEnds: $periodEnds, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class AnnualPlans extends Table with TableInfo<AnnualPlans, AnnualPlan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  AnnualPlans(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      '_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'PRIMARY KEY');
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      '_amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _currencyIdMeta =
      const VerificationMeta('currencyId');
  late final GeneratedColumn<int> currencyId = GeneratedColumn<int>(
      '_currencyId', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL REFERENCES currencies(_id)');
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      '_description', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
      '_categoryId', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL REFERENCES categories(_id)');
  static const VerificationMeta _originMeta = const VerificationMeta('origin');
  late final GeneratedColumn<DateTime> origin = GeneratedColumn<DateTime>(
      '_origin', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _periodBeginsMeta =
      const VerificationMeta('periodBegins');
  late final GeneratedColumn<DateTime> periodBegins = GeneratedColumn<DateTime>(
      '_periodBegins', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _periodEndsMeta =
      const VerificationMeta('periodEnds');
  late final GeneratedColumn<DateTime> periodEnds = GeneratedColumn<DateTime>(
      '_periodEnds', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      '_createdAt', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      '_updatedAt', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  @override
  List<GeneratedColumn> get $columns => [
        id,
        amount,
        currencyId,
        description,
        categoryId,
        origin,
        periodBegins,
        periodEnds,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'annualPlans';
  @override
  VerificationContext validateIntegrity(Insertable<AnnualPlan> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('_id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['_id']!, _idMeta));
    }
    if (data.containsKey('_amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['_amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('_currencyId')) {
      context.handle(
          _currencyIdMeta,
          currencyId.isAcceptableOrUnknown(
              data['_currencyId']!, _currencyIdMeta));
    } else if (isInserting) {
      context.missing(_currencyIdMeta);
    }
    if (data.containsKey('_description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['_description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('_categoryId')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['_categoryId']!, _categoryIdMeta));
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('_origin')) {
      context.handle(_originMeta,
          origin.isAcceptableOrUnknown(data['_origin']!, _originMeta));
    } else if (isInserting) {
      context.missing(_originMeta);
    }
    if (data.containsKey('_periodBegins')) {
      context.handle(
          _periodBeginsMeta,
          periodBegins.isAcceptableOrUnknown(
              data['_periodBegins']!, _periodBeginsMeta));
    } else if (isInserting) {
      context.missing(_periodBeginsMeta);
    }
    if (data.containsKey('_periodEnds')) {
      context.handle(
          _periodEndsMeta,
          periodEnds.isAcceptableOrUnknown(
              data['_periodEnds']!, _periodEndsMeta));
    } else if (isInserting) {
      context.missing(_periodEndsMeta);
    }
    if (data.containsKey('_createdAt')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['_createdAt']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('_updatedAt')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['_updatedAt']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AnnualPlan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AnnualPlan(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}_id'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}_amount'])!,
      currencyId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}_currencyId'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}_description'])!,
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}_categoryId'])!,
      origin: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}_origin'])!,
      periodBegins: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}_periodBegins'])!,
      periodEnds: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}_periodEnds'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}_createdAt'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}_updatedAt'])!,
    );
  }

  @override
  AnnualPlans createAlias(String alias) {
    return AnnualPlans(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class AnnualPlan extends DataClass implements Insertable<AnnualPlan> {
  final int id;
  final double amount;
  final int currencyId;
  final String description;
  final int categoryId;
  final DateTime origin;
  final DateTime periodBegins;
  final DateTime periodEnds;
  final DateTime createdAt;
  final DateTime updatedAt;
  const AnnualPlan(
      {required this.id,
      required this.amount,
      required this.currencyId,
      required this.description,
      required this.categoryId,
      required this.origin,
      required this.periodBegins,
      required this.periodEnds,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['_id'] = Variable<int>(id);
    map['_amount'] = Variable<double>(amount);
    map['_currencyId'] = Variable<int>(currencyId);
    map['_description'] = Variable<String>(description);
    map['_categoryId'] = Variable<int>(categoryId);
    map['_origin'] = Variable<DateTime>(origin);
    map['_periodBegins'] = Variable<DateTime>(periodBegins);
    map['_periodEnds'] = Variable<DateTime>(periodEnds);
    map['_createdAt'] = Variable<DateTime>(createdAt);
    map['_updatedAt'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AnnualPlansCompanion toCompanion(bool nullToAbsent) {
    return AnnualPlansCompanion(
      id: Value(id),
      amount: Value(amount),
      currencyId: Value(currencyId),
      description: Value(description),
      categoryId: Value(categoryId),
      origin: Value(origin),
      periodBegins: Value(periodBegins),
      periodEnds: Value(periodEnds),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory AnnualPlan.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AnnualPlan(
      id: serializer.fromJson<int>(json['_id']),
      amount: serializer.fromJson<double>(json['_amount']),
      currencyId: serializer.fromJson<int>(json['_currencyId']),
      description: serializer.fromJson<String>(json['_description']),
      categoryId: serializer.fromJson<int>(json['_categoryId']),
      origin: serializer.fromJson<DateTime>(json['_origin']),
      periodBegins: serializer.fromJson<DateTime>(json['_periodBegins']),
      periodEnds: serializer.fromJson<DateTime>(json['_periodEnds']),
      createdAt: serializer.fromJson<DateTime>(json['_createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['_updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      '_id': serializer.toJson<int>(id),
      '_amount': serializer.toJson<double>(amount),
      '_currencyId': serializer.toJson<int>(currencyId),
      '_description': serializer.toJson<String>(description),
      '_categoryId': serializer.toJson<int>(categoryId),
      '_origin': serializer.toJson<DateTime>(origin),
      '_periodBegins': serializer.toJson<DateTime>(periodBegins),
      '_periodEnds': serializer.toJson<DateTime>(periodEnds),
      '_createdAt': serializer.toJson<DateTime>(createdAt),
      '_updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AnnualPlan copyWith(
          {int? id,
          double? amount,
          int? currencyId,
          String? description,
          int? categoryId,
          DateTime? origin,
          DateTime? periodBegins,
          DateTime? periodEnds,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      AnnualPlan(
        id: id ?? this.id,
        amount: amount ?? this.amount,
        currencyId: currencyId ?? this.currencyId,
        description: description ?? this.description,
        categoryId: categoryId ?? this.categoryId,
        origin: origin ?? this.origin,
        periodBegins: periodBegins ?? this.periodBegins,
        periodEnds: periodEnds ?? this.periodEnds,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  AnnualPlan copyWithCompanion(AnnualPlansCompanion data) {
    return AnnualPlan(
      id: data.id.present ? data.id.value : this.id,
      amount: data.amount.present ? data.amount.value : this.amount,
      currencyId:
          data.currencyId.present ? data.currencyId.value : this.currencyId,
      description:
          data.description.present ? data.description.value : this.description,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      origin: data.origin.present ? data.origin.value : this.origin,
      periodBegins: data.periodBegins.present
          ? data.periodBegins.value
          : this.periodBegins,
      periodEnds:
          data.periodEnds.present ? data.periodEnds.value : this.periodEnds,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AnnualPlan(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('currencyId: $currencyId, ')
          ..write('description: $description, ')
          ..write('categoryId: $categoryId, ')
          ..write('origin: $origin, ')
          ..write('periodBegins: $periodBegins, ')
          ..write('periodEnds: $periodEnds, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, amount, currencyId, description,
      categoryId, origin, periodBegins, periodEnds, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AnnualPlan &&
          other.id == this.id &&
          other.amount == this.amount &&
          other.currencyId == this.currencyId &&
          other.description == this.description &&
          other.categoryId == this.categoryId &&
          other.origin == this.origin &&
          other.periodBegins == this.periodBegins &&
          other.periodEnds == this.periodEnds &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class AnnualPlansCompanion extends UpdateCompanion<AnnualPlan> {
  final Value<int> id;
  final Value<double> amount;
  final Value<int> currencyId;
  final Value<String> description;
  final Value<int> categoryId;
  final Value<DateTime> origin;
  final Value<DateTime> periodBegins;
  final Value<DateTime> periodEnds;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const AnnualPlansCompanion({
    this.id = const Value.absent(),
    this.amount = const Value.absent(),
    this.currencyId = const Value.absent(),
    this.description = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.origin = const Value.absent(),
    this.periodBegins = const Value.absent(),
    this.periodEnds = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  AnnualPlansCompanion.insert({
    this.id = const Value.absent(),
    required double amount,
    required int currencyId,
    required String description,
    required int categoryId,
    required DateTime origin,
    required DateTime periodBegins,
    required DateTime periodEnds,
    required DateTime createdAt,
    required DateTime updatedAt,
  })  : amount = Value(amount),
        currencyId = Value(currencyId),
        description = Value(description),
        categoryId = Value(categoryId),
        origin = Value(origin),
        periodBegins = Value(periodBegins),
        periodEnds = Value(periodEnds),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<AnnualPlan> custom({
    Expression<int>? id,
    Expression<double>? amount,
    Expression<int>? currencyId,
    Expression<String>? description,
    Expression<int>? categoryId,
    Expression<DateTime>? origin,
    Expression<DateTime>? periodBegins,
    Expression<DateTime>? periodEnds,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) '_id': id,
      if (amount != null) '_amount': amount,
      if (currencyId != null) '_currencyId': currencyId,
      if (description != null) '_description': description,
      if (categoryId != null) '_categoryId': categoryId,
      if (origin != null) '_origin': origin,
      if (periodBegins != null) '_periodBegins': periodBegins,
      if (periodEnds != null) '_periodEnds': periodEnds,
      if (createdAt != null) '_createdAt': createdAt,
      if (updatedAt != null) '_updatedAt': updatedAt,
    });
  }

  AnnualPlansCompanion copyWith(
      {Value<int>? id,
      Value<double>? amount,
      Value<int>? currencyId,
      Value<String>? description,
      Value<int>? categoryId,
      Value<DateTime>? origin,
      Value<DateTime>? periodBegins,
      Value<DateTime>? periodEnds,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return AnnualPlansCompanion(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      currencyId: currencyId ?? this.currencyId,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      origin: origin ?? this.origin,
      periodBegins: periodBegins ?? this.periodBegins,
      periodEnds: periodEnds ?? this.periodEnds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['_id'] = Variable<int>(id.value);
    }
    if (amount.present) {
      map['_amount'] = Variable<double>(amount.value);
    }
    if (currencyId.present) {
      map['_currencyId'] = Variable<int>(currencyId.value);
    }
    if (description.present) {
      map['_description'] = Variable<String>(description.value);
    }
    if (categoryId.present) {
      map['_categoryId'] = Variable<int>(categoryId.value);
    }
    if (origin.present) {
      map['_origin'] = Variable<DateTime>(origin.value);
    }
    if (periodBegins.present) {
      map['_periodBegins'] = Variable<DateTime>(periodBegins.value);
    }
    if (periodEnds.present) {
      map['_periodEnds'] = Variable<DateTime>(periodEnds.value);
    }
    if (createdAt.present) {
      map['_createdAt'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['_updatedAt'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AnnualPlansCompanion(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('currencyId: $currencyId, ')
          ..write('description: $description, ')
          ..write('categoryId: $categoryId, ')
          ..write('origin: $origin, ')
          ..write('periodBegins: $periodBegins, ')
          ..write('periodEnds: $periodEnds, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class EstimationSchemes extends Table
    with TableInfo<EstimationSchemes, EstimationScheme> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  EstimationSchemes(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      '_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'PRIMARY KEY');
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
      '_categoryId', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL REFERENCES categories(_id)');
  static const VerificationMeta _periodBeginsMeta =
      const VerificationMeta('periodBegins');
  late final GeneratedColumn<DateTime> periodBegins = GeneratedColumn<DateTime>(
      '_periodBegins', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _periodEndsMeta =
      const VerificationMeta('periodEnds');
  late final GeneratedColumn<DateTime> periodEnds = GeneratedColumn<DateTime>(
      '_periodEnds', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _displayOptionMeta =
      const VerificationMeta('displayOption');
  late final GeneratedColumnWithTypeConverter<EstimationDisplayOption, int>
      displayOption = GeneratedColumn<int>('_displayOption', aliasedName, false,
              type: DriftSqlType.int,
              requiredDuringInsert: true,
              $customConstraints: 'NOT NULL')
          .withConverter<EstimationDisplayOption>(
              EstimationSchemes.$converterdisplayOption);
  static const VerificationMeta _currencyIdMeta =
      const VerificationMeta('currencyId');
  late final GeneratedColumn<int> currencyId = GeneratedColumn<int>(
      '_currencyId', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL REFERENCES currencies(_id)');
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      '_createdAt', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      '_updatedAt', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  @override
  List<GeneratedColumn> get $columns => [
        id,
        categoryId,
        periodBegins,
        periodEnds,
        displayOption,
        currencyId,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'estimationSchemes';
  @override
  VerificationContext validateIntegrity(Insertable<EstimationScheme> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('_id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['_id']!, _idMeta));
    }
    if (data.containsKey('_categoryId')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['_categoryId']!, _categoryIdMeta));
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('_periodBegins')) {
      context.handle(
          _periodBeginsMeta,
          periodBegins.isAcceptableOrUnknown(
              data['_periodBegins']!, _periodBeginsMeta));
    } else if (isInserting) {
      context.missing(_periodBeginsMeta);
    }
    if (data.containsKey('_periodEnds')) {
      context.handle(
          _periodEndsMeta,
          periodEnds.isAcceptableOrUnknown(
              data['_periodEnds']!, _periodEndsMeta));
    } else if (isInserting) {
      context.missing(_periodEndsMeta);
    }
    context.handle(_displayOptionMeta, const VerificationResult.success());
    if (data.containsKey('_currencyId')) {
      context.handle(
          _currencyIdMeta,
          currencyId.isAcceptableOrUnknown(
              data['_currencyId']!, _currencyIdMeta));
    } else if (isInserting) {
      context.missing(_currencyIdMeta);
    }
    if (data.containsKey('_createdAt')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['_createdAt']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('_updatedAt')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['_updatedAt']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EstimationScheme map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EstimationScheme(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}_id'])!,
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}_categoryId'])!,
      periodBegins: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}_periodBegins'])!,
      periodEnds: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}_periodEnds'])!,
      displayOption: EstimationSchemes.$converterdisplayOption.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.int, data['${effectivePrefix}_displayOption'])!),
      currencyId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}_currencyId'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}_createdAt'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}_updatedAt'])!,
    );
  }

  @override
  EstimationSchemes createAlias(String alias) {
    return EstimationSchemes(attachedDatabase, alias);
  }

  static JsonTypeConverter2<EstimationDisplayOption, int, int>
      $converterdisplayOption =
      const EnumIndexConverter<EstimationDisplayOption>(
          EstimationDisplayOption.values);
  @override
  bool get dontWriteConstraints => true;
}

class EstimationScheme extends DataClass
    implements Insertable<EstimationScheme> {
  final int id;
  final int categoryId;
  final DateTime periodBegins;
  final DateTime periodEnds;
  final EstimationDisplayOption displayOption;
  final int currencyId;
  final DateTime createdAt;
  final DateTime updatedAt;
  const EstimationScheme(
      {required this.id,
      required this.categoryId,
      required this.periodBegins,
      required this.periodEnds,
      required this.displayOption,
      required this.currencyId,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['_id'] = Variable<int>(id);
    map['_categoryId'] = Variable<int>(categoryId);
    map['_periodBegins'] = Variable<DateTime>(periodBegins);
    map['_periodEnds'] = Variable<DateTime>(periodEnds);
    {
      map['_displayOption'] = Variable<int>(
          EstimationSchemes.$converterdisplayOption.toSql(displayOption));
    }
    map['_currencyId'] = Variable<int>(currencyId);
    map['_createdAt'] = Variable<DateTime>(createdAt);
    map['_updatedAt'] = Variable<DateTime>(updatedAt);
    return map;
  }

  EstimationSchemesCompanion toCompanion(bool nullToAbsent) {
    return EstimationSchemesCompanion(
      id: Value(id),
      categoryId: Value(categoryId),
      periodBegins: Value(periodBegins),
      periodEnds: Value(periodEnds),
      displayOption: Value(displayOption),
      currencyId: Value(currencyId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory EstimationScheme.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EstimationScheme(
      id: serializer.fromJson<int>(json['_id']),
      categoryId: serializer.fromJson<int>(json['_categoryId']),
      periodBegins: serializer.fromJson<DateTime>(json['_periodBegins']),
      periodEnds: serializer.fromJson<DateTime>(json['_periodEnds']),
      displayOption: EstimationSchemes.$converterdisplayOption
          .fromJson(serializer.fromJson<int>(json['_displayOption'])),
      currencyId: serializer.fromJson<int>(json['_currencyId']),
      createdAt: serializer.fromJson<DateTime>(json['_createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['_updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      '_id': serializer.toJson<int>(id),
      '_categoryId': serializer.toJson<int>(categoryId),
      '_periodBegins': serializer.toJson<DateTime>(periodBegins),
      '_periodEnds': serializer.toJson<DateTime>(periodEnds),
      '_displayOption': serializer.toJson<int>(
          EstimationSchemes.$converterdisplayOption.toJson(displayOption)),
      '_currencyId': serializer.toJson<int>(currencyId),
      '_createdAt': serializer.toJson<DateTime>(createdAt),
      '_updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  EstimationScheme copyWith(
          {int? id,
          int? categoryId,
          DateTime? periodBegins,
          DateTime? periodEnds,
          EstimationDisplayOption? displayOption,
          int? currencyId,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      EstimationScheme(
        id: id ?? this.id,
        categoryId: categoryId ?? this.categoryId,
        periodBegins: periodBegins ?? this.periodBegins,
        periodEnds: periodEnds ?? this.periodEnds,
        displayOption: displayOption ?? this.displayOption,
        currencyId: currencyId ?? this.currencyId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  EstimationScheme copyWithCompanion(EstimationSchemesCompanion data) {
    return EstimationScheme(
      id: data.id.present ? data.id.value : this.id,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      periodBegins: data.periodBegins.present
          ? data.periodBegins.value
          : this.periodBegins,
      periodEnds:
          data.periodEnds.present ? data.periodEnds.value : this.periodEnds,
      displayOption: data.displayOption.present
          ? data.displayOption.value
          : this.displayOption,
      currencyId:
          data.currencyId.present ? data.currencyId.value : this.currencyId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EstimationScheme(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('periodBegins: $periodBegins, ')
          ..write('periodEnds: $periodEnds, ')
          ..write('displayOption: $displayOption, ')
          ..write('currencyId: $currencyId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, categoryId, periodBegins, periodEnds,
      displayOption, currencyId, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EstimationScheme &&
          other.id == this.id &&
          other.categoryId == this.categoryId &&
          other.periodBegins == this.periodBegins &&
          other.periodEnds == this.periodEnds &&
          other.displayOption == this.displayOption &&
          other.currencyId == this.currencyId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class EstimationSchemesCompanion extends UpdateCompanion<EstimationScheme> {
  final Value<int> id;
  final Value<int> categoryId;
  final Value<DateTime> periodBegins;
  final Value<DateTime> periodEnds;
  final Value<EstimationDisplayOption> displayOption;
  final Value<int> currencyId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const EstimationSchemesCompanion({
    this.id = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.periodBegins = const Value.absent(),
    this.periodEnds = const Value.absent(),
    this.displayOption = const Value.absent(),
    this.currencyId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  EstimationSchemesCompanion.insert({
    this.id = const Value.absent(),
    required int categoryId,
    required DateTime periodBegins,
    required DateTime periodEnds,
    required EstimationDisplayOption displayOption,
    required int currencyId,
    required DateTime createdAt,
    required DateTime updatedAt,
  })  : categoryId = Value(categoryId),
        periodBegins = Value(periodBegins),
        periodEnds = Value(periodEnds),
        displayOption = Value(displayOption),
        currencyId = Value(currencyId),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<EstimationScheme> custom({
    Expression<int>? id,
    Expression<int>? categoryId,
    Expression<DateTime>? periodBegins,
    Expression<DateTime>? periodEnds,
    Expression<int>? displayOption,
    Expression<int>? currencyId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) '_id': id,
      if (categoryId != null) '_categoryId': categoryId,
      if (periodBegins != null) '_periodBegins': periodBegins,
      if (periodEnds != null) '_periodEnds': periodEnds,
      if (displayOption != null) '_displayOption': displayOption,
      if (currencyId != null) '_currencyId': currencyId,
      if (createdAt != null) '_createdAt': createdAt,
      if (updatedAt != null) '_updatedAt': updatedAt,
    });
  }

  EstimationSchemesCompanion copyWith(
      {Value<int>? id,
      Value<int>? categoryId,
      Value<DateTime>? periodBegins,
      Value<DateTime>? periodEnds,
      Value<EstimationDisplayOption>? displayOption,
      Value<int>? currencyId,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return EstimationSchemesCompanion(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      periodBegins: periodBegins ?? this.periodBegins,
      periodEnds: periodEnds ?? this.periodEnds,
      displayOption: displayOption ?? this.displayOption,
      currencyId: currencyId ?? this.currencyId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['_id'] = Variable<int>(id.value);
    }
    if (categoryId.present) {
      map['_categoryId'] = Variable<int>(categoryId.value);
    }
    if (periodBegins.present) {
      map['_periodBegins'] = Variable<DateTime>(periodBegins.value);
    }
    if (periodEnds.present) {
      map['_periodEnds'] = Variable<DateTime>(periodEnds.value);
    }
    if (displayOption.present) {
      map['_displayOption'] = Variable<int>(
          EstimationSchemes.$converterdisplayOption.toSql(displayOption.value));
    }
    if (currencyId.present) {
      map['_currencyId'] = Variable<int>(currencyId.value);
    }
    if (createdAt.present) {
      map['_createdAt'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['_updatedAt'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EstimationSchemesCompanion(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('periodBegins: $periodBegins, ')
          ..write('periodEnds: $periodEnds, ')
          ..write('displayOption: $displayOption, ')
          ..write('currencyId: $currencyId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class MonitorSchemes extends Table
    with TableInfo<MonitorSchemes, MonitorScheme> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  MonitorSchemes(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      '_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'PRIMARY KEY');
  static const VerificationMeta _periodBeginsMeta =
      const VerificationMeta('periodBegins');
  late final GeneratedColumn<DateTime> periodBegins = GeneratedColumn<DateTime>(
      '_periodBegins', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _periodEndsMeta =
      const VerificationMeta('periodEnds');
  late final GeneratedColumn<DateTime> periodEnds = GeneratedColumn<DateTime>(
      '_periodEnds', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _displayOptionMeta =
      const VerificationMeta('displayOption');
  late final GeneratedColumnWithTypeConverter<MonitorDisplayOption, int>
      displayOption = GeneratedColumn<int>('_displayOption', aliasedName, false,
              type: DriftSqlType.int,
              requiredDuringInsert: true,
              $customConstraints: 'NOT NULL')
          .withConverter<MonitorDisplayOption>(
              MonitorSchemes.$converterdisplayOption);
  static const VerificationMeta _currencyIdMeta =
      const VerificationMeta('currencyId');
  late final GeneratedColumn<int> currencyId = GeneratedColumn<int>(
      '_currencyId', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL REFERENCES currencies(_id)');
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      '_createdAt', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      '_updatedAt', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  @override
  List<GeneratedColumn> get $columns => [
        id,
        periodBegins,
        periodEnds,
        displayOption,
        currencyId,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'monitorSchemes';
  @override
  VerificationContext validateIntegrity(Insertable<MonitorScheme> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('_id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['_id']!, _idMeta));
    }
    if (data.containsKey('_periodBegins')) {
      context.handle(
          _periodBeginsMeta,
          periodBegins.isAcceptableOrUnknown(
              data['_periodBegins']!, _periodBeginsMeta));
    } else if (isInserting) {
      context.missing(_periodBeginsMeta);
    }
    if (data.containsKey('_periodEnds')) {
      context.handle(
          _periodEndsMeta,
          periodEnds.isAcceptableOrUnknown(
              data['_periodEnds']!, _periodEndsMeta));
    } else if (isInserting) {
      context.missing(_periodEndsMeta);
    }
    context.handle(_displayOptionMeta, const VerificationResult.success());
    if (data.containsKey('_currencyId')) {
      context.handle(
          _currencyIdMeta,
          currencyId.isAcceptableOrUnknown(
              data['_currencyId']!, _currencyIdMeta));
    } else if (isInserting) {
      context.missing(_currencyIdMeta);
    }
    if (data.containsKey('_createdAt')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['_createdAt']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('_updatedAt')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['_updatedAt']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MonitorScheme map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MonitorScheme(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}_id'])!,
      periodBegins: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}_periodBegins'])!,
      periodEnds: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}_periodEnds'])!,
      displayOption: MonitorSchemes.$converterdisplayOption.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.int, data['${effectivePrefix}_displayOption'])!),
      currencyId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}_currencyId'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}_createdAt'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}_updatedAt'])!,
    );
  }

  @override
  MonitorSchemes createAlias(String alias) {
    return MonitorSchemes(attachedDatabase, alias);
  }

  static JsonTypeConverter2<MonitorDisplayOption, int, int>
      $converterdisplayOption = const EnumIndexConverter<MonitorDisplayOption>(
          MonitorDisplayOption.values);
  @override
  bool get dontWriteConstraints => true;
}

class MonitorScheme extends DataClass implements Insertable<MonitorScheme> {
  final int id;
  final DateTime periodBegins;
  final DateTime periodEnds;
  final MonitorDisplayOption displayOption;
  final int currencyId;
  final DateTime createdAt;
  final DateTime updatedAt;
  const MonitorScheme(
      {required this.id,
      required this.periodBegins,
      required this.periodEnds,
      required this.displayOption,
      required this.currencyId,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['_id'] = Variable<int>(id);
    map['_periodBegins'] = Variable<DateTime>(periodBegins);
    map['_periodEnds'] = Variable<DateTime>(periodEnds);
    {
      map['_displayOption'] = Variable<int>(
          MonitorSchemes.$converterdisplayOption.toSql(displayOption));
    }
    map['_currencyId'] = Variable<int>(currencyId);
    map['_createdAt'] = Variable<DateTime>(createdAt);
    map['_updatedAt'] = Variable<DateTime>(updatedAt);
    return map;
  }

  MonitorSchemesCompanion toCompanion(bool nullToAbsent) {
    return MonitorSchemesCompanion(
      id: Value(id),
      periodBegins: Value(periodBegins),
      periodEnds: Value(periodEnds),
      displayOption: Value(displayOption),
      currencyId: Value(currencyId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory MonitorScheme.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MonitorScheme(
      id: serializer.fromJson<int>(json['_id']),
      periodBegins: serializer.fromJson<DateTime>(json['_periodBegins']),
      periodEnds: serializer.fromJson<DateTime>(json['_periodEnds']),
      displayOption: MonitorSchemes.$converterdisplayOption
          .fromJson(serializer.fromJson<int>(json['_displayOption'])),
      currencyId: serializer.fromJson<int>(json['_currencyId']),
      createdAt: serializer.fromJson<DateTime>(json['_createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['_updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      '_id': serializer.toJson<int>(id),
      '_periodBegins': serializer.toJson<DateTime>(periodBegins),
      '_periodEnds': serializer.toJson<DateTime>(periodEnds),
      '_displayOption': serializer.toJson<int>(
          MonitorSchemes.$converterdisplayOption.toJson(displayOption)),
      '_currencyId': serializer.toJson<int>(currencyId),
      '_createdAt': serializer.toJson<DateTime>(createdAt),
      '_updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  MonitorScheme copyWith(
          {int? id,
          DateTime? periodBegins,
          DateTime? periodEnds,
          MonitorDisplayOption? displayOption,
          int? currencyId,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      MonitorScheme(
        id: id ?? this.id,
        periodBegins: periodBegins ?? this.periodBegins,
        periodEnds: periodEnds ?? this.periodEnds,
        displayOption: displayOption ?? this.displayOption,
        currencyId: currencyId ?? this.currencyId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  MonitorScheme copyWithCompanion(MonitorSchemesCompanion data) {
    return MonitorScheme(
      id: data.id.present ? data.id.value : this.id,
      periodBegins: data.periodBegins.present
          ? data.periodBegins.value
          : this.periodBegins,
      periodEnds:
          data.periodEnds.present ? data.periodEnds.value : this.periodEnds,
      displayOption: data.displayOption.present
          ? data.displayOption.value
          : this.displayOption,
      currencyId:
          data.currencyId.present ? data.currencyId.value : this.currencyId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MonitorScheme(')
          ..write('id: $id, ')
          ..write('periodBegins: $periodBegins, ')
          ..write('periodEnds: $periodEnds, ')
          ..write('displayOption: $displayOption, ')
          ..write('currencyId: $currencyId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, periodBegins, periodEnds, displayOption,
      currencyId, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MonitorScheme &&
          other.id == this.id &&
          other.periodBegins == this.periodBegins &&
          other.periodEnds == this.periodEnds &&
          other.displayOption == this.displayOption &&
          other.currencyId == this.currencyId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MonitorSchemesCompanion extends UpdateCompanion<MonitorScheme> {
  final Value<int> id;
  final Value<DateTime> periodBegins;
  final Value<DateTime> periodEnds;
  final Value<MonitorDisplayOption> displayOption;
  final Value<int> currencyId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const MonitorSchemesCompanion({
    this.id = const Value.absent(),
    this.periodBegins = const Value.absent(),
    this.periodEnds = const Value.absent(),
    this.displayOption = const Value.absent(),
    this.currencyId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  MonitorSchemesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime periodBegins,
    required DateTime periodEnds,
    required MonitorDisplayOption displayOption,
    required int currencyId,
    required DateTime createdAt,
    required DateTime updatedAt,
  })  : periodBegins = Value(periodBegins),
        periodEnds = Value(periodEnds),
        displayOption = Value(displayOption),
        currencyId = Value(currencyId),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<MonitorScheme> custom({
    Expression<int>? id,
    Expression<DateTime>? periodBegins,
    Expression<DateTime>? periodEnds,
    Expression<int>? displayOption,
    Expression<int>? currencyId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) '_id': id,
      if (periodBegins != null) '_periodBegins': periodBegins,
      if (periodEnds != null) '_periodEnds': periodEnds,
      if (displayOption != null) '_displayOption': displayOption,
      if (currencyId != null) '_currencyId': currencyId,
      if (createdAt != null) '_createdAt': createdAt,
      if (updatedAt != null) '_updatedAt': updatedAt,
    });
  }

  MonitorSchemesCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? periodBegins,
      Value<DateTime>? periodEnds,
      Value<MonitorDisplayOption>? displayOption,
      Value<int>? currencyId,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return MonitorSchemesCompanion(
      id: id ?? this.id,
      periodBegins: periodBegins ?? this.periodBegins,
      periodEnds: periodEnds ?? this.periodEnds,
      displayOption: displayOption ?? this.displayOption,
      currencyId: currencyId ?? this.currencyId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['_id'] = Variable<int>(id.value);
    }
    if (periodBegins.present) {
      map['_periodBegins'] = Variable<DateTime>(periodBegins.value);
    }
    if (periodEnds.present) {
      map['_periodEnds'] = Variable<DateTime>(periodEnds.value);
    }
    if (displayOption.present) {
      map['_displayOption'] = Variable<int>(
          MonitorSchemes.$converterdisplayOption.toSql(displayOption.value));
    }
    if (currencyId.present) {
      map['_currencyId'] = Variable<int>(currencyId.value);
    }
    if (createdAt.present) {
      map['_createdAt'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['_updatedAt'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MonitorSchemesCompanion(')
          ..write('id: $id, ')
          ..write('periodBegins: $periodBegins, ')
          ..write('periodEnds: $periodEnds, ')
          ..write('displayOption: $displayOption, ')
          ..write('currencyId: $currencyId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class MonitorSchemeCategoryLinkers extends Table
    with TableInfo<MonitorSchemeCategoryLinkers, MonitorSchemeCategoryLinker> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  MonitorSchemeCategoryLinkers(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _schemeMeta = const VerificationMeta('scheme');
  late final GeneratedColumn<int> scheme = GeneratedColumn<int>(
      '_scheme', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL REFERENCES monitorSchemes(_id)');
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  late final GeneratedColumn<int> category = GeneratedColumn<int>(
      '_category', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL REFERENCES categories(_id)');
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      '_createdAt', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  @override
  List<GeneratedColumn> get $columns => [scheme, category, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'monitorSchemeCategoryLinkers';
  @override
  VerificationContext validateIntegrity(
      Insertable<MonitorSchemeCategoryLinker> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('_scheme')) {
      context.handle(_schemeMeta,
          scheme.isAcceptableOrUnknown(data['_scheme']!, _schemeMeta));
    } else if (isInserting) {
      context.missing(_schemeMeta);
    }
    if (data.containsKey('_category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['_category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('_createdAt')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['_createdAt']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {scheme, category};
  @override
  MonitorSchemeCategoryLinker map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MonitorSchemeCategoryLinker(
      scheme: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}_scheme'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}_category'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}_createdAt'])!,
    );
  }

  @override
  MonitorSchemeCategoryLinkers createAlias(String alias) {
    return MonitorSchemeCategoryLinkers(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints =>
      const ['PRIMARY KEY(_scheme, _category)'];
  @override
  bool get dontWriteConstraints => true;
}

class MonitorSchemeCategoryLinker extends DataClass
    implements Insertable<MonitorSchemeCategoryLinker> {
  final int scheme;
  final int category;
  final DateTime createdAt;
  const MonitorSchemeCategoryLinker(
      {required this.scheme, required this.category, required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['_scheme'] = Variable<int>(scheme);
    map['_category'] = Variable<int>(category);
    map['_createdAt'] = Variable<DateTime>(createdAt);
    return map;
  }

  MonitorSchemeCategoryLinkersCompanion toCompanion(bool nullToAbsent) {
    return MonitorSchemeCategoryLinkersCompanion(
      scheme: Value(scheme),
      category: Value(category),
      createdAt: Value(createdAt),
    );
  }

  factory MonitorSchemeCategoryLinker.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MonitorSchemeCategoryLinker(
      scheme: serializer.fromJson<int>(json['_scheme']),
      category: serializer.fromJson<int>(json['_category']),
      createdAt: serializer.fromJson<DateTime>(json['_createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      '_scheme': serializer.toJson<int>(scheme),
      '_category': serializer.toJson<int>(category),
      '_createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  MonitorSchemeCategoryLinker copyWith(
          {int? scheme, int? category, DateTime? createdAt}) =>
      MonitorSchemeCategoryLinker(
        scheme: scheme ?? this.scheme,
        category: category ?? this.category,
        createdAt: createdAt ?? this.createdAt,
      );
  MonitorSchemeCategoryLinker copyWithCompanion(
      MonitorSchemeCategoryLinkersCompanion data) {
    return MonitorSchemeCategoryLinker(
      scheme: data.scheme.present ? data.scheme.value : this.scheme,
      category: data.category.present ? data.category.value : this.category,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MonitorSchemeCategoryLinker(')
          ..write('scheme: $scheme, ')
          ..write('category: $category, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(scheme, category, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MonitorSchemeCategoryLinker &&
          other.scheme == this.scheme &&
          other.category == this.category &&
          other.createdAt == this.createdAt);
}

class MonitorSchemeCategoryLinkersCompanion
    extends UpdateCompanion<MonitorSchemeCategoryLinker> {
  final Value<int> scheme;
  final Value<int> category;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const MonitorSchemeCategoryLinkersCompanion({
    this.scheme = const Value.absent(),
    this.category = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MonitorSchemeCategoryLinkersCompanion.insert({
    required int scheme,
    required int category,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : scheme = Value(scheme),
        category = Value(category),
        createdAt = Value(createdAt);
  static Insertable<MonitorSchemeCategoryLinker> custom({
    Expression<int>? scheme,
    Expression<int>? category,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (scheme != null) '_scheme': scheme,
      if (category != null) '_category': category,
      if (createdAt != null) '_createdAt': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MonitorSchemeCategoryLinkersCompanion copyWith(
      {Value<int>? scheme,
      Value<int>? category,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return MonitorSchemeCategoryLinkersCompanion(
      scheme: scheme ?? this.scheme,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (scheme.present) {
      map['_scheme'] = Variable<int>(scheme.value);
    }
    if (category.present) {
      map['_category'] = Variable<int>(category.value);
    }
    if (createdAt.present) {
      map['_createdAt'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MonitorSchemeCategoryLinkersCompanion(')
          ..write('scheme: $scheme, ')
          ..write('category: $category, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final Categories categories = Categories(this);
  late final Currencies currencies = Currencies(this);
  late final ReceiptLogs receiptLogs = ReceiptLogs(this);
  late final Index receiptLogsDate = Index('receiptLogs_date',
      'CREATE INDEX receiptLogs_date ON receiptLogs (_date)');
  late final OneshotPlans oneshotPlans = OneshotPlans(this);
  late final Index oneshotPlansDate = Index('oneshotPlans_date',
      'CREATE INDEX oneshotPlans_date ON oneshotPlans (_date)');
  late final IntervalPlans intervalPlans = IntervalPlans(this);
  late final Index intervalPlansOrigin = Index('intervalPlans_origin',
      'CREATE INDEX intervalPlans_origin ON intervalPlans (_origin)');
  late final Index intervalPlansPeriodBegins = Index(
      'intervalPlans_periodBegins',
      'CREATE INDEX intervalPlans_periodBegins ON intervalPlans (_periodBegins)');
  late final Index intervalPlansPeriodEnds = Index('intervalPlans_periodEnds',
      'CREATE INDEX intervalPlans_periodEnds ON intervalPlans (_periodEnds)');
  late final WeeklyPlans weeklyPlans = WeeklyPlans(this);
  late final Index weeklyPlansPeriodBegins = Index('weeklyPlans_periodBegins',
      'CREATE INDEX weeklyPlans_periodBegins ON weeklyPlans (_periodBegins)');
  late final Index weeklyPlansPeriodEnds = Index('weeklyPlans_periodEnds',
      'CREATE INDEX weeklyPlans_periodEnds ON weeklyPlans (_periodEnds)');
  late final MonthlyPlans monthlyPlans = MonthlyPlans(this);
  late final Index monthlyPlansPeriodBegins = Index('monthlyPlans_periodBegins',
      'CREATE INDEX monthlyPlans_periodBegins ON monthlyPlans (_periodBegins)');
  late final Index monthlyPlansPeriodEnds = Index('monthlyPlans_periodEnds',
      'CREATE INDEX monthlyPlans_periodEnds ON monthlyPlans (_periodEnds)');
  late final AnnualPlans annualPlans = AnnualPlans(this);
  late final Index annualPlansOrigin = Index('annualPlans_origin',
      'CREATE INDEX annualPlans_origin ON annualPlans (_origin)');
  late final Index annualPlansPeriodBegins = Index('annualPlans_periodBegins',
      'CREATE INDEX annualPlans_periodBegins ON annualPlans (_periodBegins)');
  late final EstimationSchemes estimationSchemes = EstimationSchemes(this);
  late final Index estimationSchemesPeriodBegins = Index(
      'estimationSchemes_periodBegins',
      'CREATE INDEX estimationSchemes_periodBegins ON estimationSchemes (_periodBegins)');
  late final Index estimationSchemesPeriodEnds = Index(
      'estimationSchemes_periodEnds',
      'CREATE INDEX estimationSchemes_periodEnds ON estimationSchemes (_periodEnds)');
  late final MonitorSchemes monitorSchemes = MonitorSchemes(this);
  late final Index monitorSchemesPeriodBegins = Index(
      'monitorSchemes_periodBegins',
      'CREATE INDEX monitorSchemes_periodBegins ON monitorSchemes (_periodBegins)');
  late final Index monitorSchemesPeriodEnds = Index('monitorSchemes_periodEnds',
      'CREATE INDEX monitorSchemes_periodEnds ON monitorSchemes (_periodEnds)');
  late final MonitorSchemeCategoryLinkers monitorSchemeCategoryLinkers =
      MonitorSchemeCategoryLinkers(this);
  late final Index monitorSchemeCategoryLinkersScheme = Index(
      'monitorSchemeCategoryLinkers_scheme',
      'CREATE INDEX monitorSchemeCategoryLinkers_scheme ON monitorSchemeCategoryLinkers (_scheme)');
  late final Plans plans = Plans(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        categories,
        currencies,
        receiptLogs,
        receiptLogsDate,
        oneshotPlans,
        oneshotPlansDate,
        intervalPlans,
        intervalPlansOrigin,
        intervalPlansPeriodBegins,
        intervalPlansPeriodEnds,
        weeklyPlans,
        weeklyPlansPeriodBegins,
        weeklyPlansPeriodEnds,
        monthlyPlans,
        monthlyPlansPeriodBegins,
        monthlyPlansPeriodEnds,
        annualPlans,
        annualPlansOrigin,
        annualPlansPeriodBegins,
        estimationSchemes,
        estimationSchemesPeriodBegins,
        estimationSchemesPeriodEnds,
        monitorSchemes,
        monitorSchemesPeriodBegins,
        monitorSchemesPeriodEnds,
        monitorSchemeCategoryLinkers,
        monitorSchemeCategoryLinkersScheme
      ];
}

typedef $CategoriesCreateCompanionBuilder = CategoriesCompanion Function({
  Value<int> id,
  required String name,
  required DateTime createdAt,
  required DateTime updatedAt,
});
typedef $CategoriesUpdateCompanionBuilder = CategoriesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $CategoriesReferences
    extends BaseReferences<_$AppDatabase, Categories, Category> {
  $CategoriesReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<ReceiptLogs, List<ReceiptLog>>
      _receiptLogsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.receiptLogs,
              aliasName: $_aliasNameGenerator(
                  db.categories.id, db.receiptLogs.categoryId));

  $ReceiptLogsProcessedTableManager get receiptLogsRefs {
    final manager = $ReceiptLogsTableManager($_db, $_db.receiptLogs)
        .filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('_id')!));

    final cache = $_typedResult.readTableOrNull(_receiptLogsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<OneshotPlans, List<OneshotPlan>>
      _oneshotPlansRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.oneshotPlans,
              aliasName: $_aliasNameGenerator(
                  db.categories.id, db.oneshotPlans.categoryId));

  $OneshotPlansProcessedTableManager get oneshotPlansRefs {
    final manager = $OneshotPlansTableManager($_db, $_db.oneshotPlans)
        .filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('_id')!));

    final cache = $_typedResult.readTableOrNull(_oneshotPlansRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<IntervalPlans, List<IntervalPlan>>
      _intervalPlansRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.intervalPlans,
              aliasName: $_aliasNameGenerator(
                  db.categories.id, db.intervalPlans.categoryId));

  $IntervalPlansProcessedTableManager get intervalPlansRefs {
    final manager = $IntervalPlansTableManager($_db, $_db.intervalPlans)
        .filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('_id')!));

    final cache = $_typedResult.readTableOrNull(_intervalPlansRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<WeeklyPlans, List<WeeklyPlan>>
      _weeklyPlansRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.weeklyPlans,
              aliasName: $_aliasNameGenerator(
                  db.categories.id, db.weeklyPlans.categoryId));

  $WeeklyPlansProcessedTableManager get weeklyPlansRefs {
    final manager = $WeeklyPlansTableManager($_db, $_db.weeklyPlans)
        .filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('_id')!));

    final cache = $_typedResult.readTableOrNull(_weeklyPlansRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<MonthlyPlans, List<MonthlyPlan>>
      _monthlyPlansRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.monthlyPlans,
              aliasName: $_aliasNameGenerator(
                  db.categories.id, db.monthlyPlans.categoryId));

  $MonthlyPlansProcessedTableManager get monthlyPlansRefs {
    final manager = $MonthlyPlansTableManager($_db, $_db.monthlyPlans)
        .filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('_id')!));

    final cache = $_typedResult.readTableOrNull(_monthlyPlansRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<AnnualPlans, List<AnnualPlan>>
      _annualPlansRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.annualPlans,
              aliasName: $_aliasNameGenerator(
                  db.categories.id, db.annualPlans.categoryId));

  $AnnualPlansProcessedTableManager get annualPlansRefs {
    final manager = $AnnualPlansTableManager($_db, $_db.annualPlans)
        .filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('_id')!));

    final cache = $_typedResult.readTableOrNull(_annualPlansRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<EstimationSchemes, List<EstimationScheme>>
      _estimationSchemesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.estimationSchemes,
              aliasName: $_aliasNameGenerator(
                  db.categories.id, db.estimationSchemes.categoryId));

  $EstimationSchemesProcessedTableManager get estimationSchemesRefs {
    final manager = $EstimationSchemesTableManager($_db, $_db.estimationSchemes)
        .filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('_id')!));

    final cache =
        $_typedResult.readTableOrNull(_estimationSchemesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<MonitorSchemeCategoryLinkers,
      List<MonitorSchemeCategoryLinker>> _monitorSchemeCategoryLinkersRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.monitorSchemeCategoryLinkers,
          aliasName: $_aliasNameGenerator(
              db.categories.id, db.monitorSchemeCategoryLinkers.category));

  $MonitorSchemeCategoryLinkersProcessedTableManager
      get monitorSchemeCategoryLinkersRefs {
    final manager = $MonitorSchemeCategoryLinkersTableManager(
            $_db, $_db.monitorSchemeCategoryLinkers)
        .filter((f) => f.category.id.sqlEquals($_itemColumn<int>('_id')!));

    final cache = $_typedResult
        .readTableOrNull(_monitorSchemeCategoryLinkersRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $CategoriesFilterComposer extends Composer<_$AppDatabase, Categories> {
  $CategoriesFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> receiptLogsRefs(
      Expression<bool> Function($ReceiptLogsFilterComposer f) f) {
    final $ReceiptLogsFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.receiptLogs,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $ReceiptLogsFilterComposer(
              $db: $db,
              $table: $db.receiptLogs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> oneshotPlansRefs(
      Expression<bool> Function($OneshotPlansFilterComposer f) f) {
    final $OneshotPlansFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.oneshotPlans,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $OneshotPlansFilterComposer(
              $db: $db,
              $table: $db.oneshotPlans,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> intervalPlansRefs(
      Expression<bool> Function($IntervalPlansFilterComposer f) f) {
    final $IntervalPlansFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.intervalPlans,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $IntervalPlansFilterComposer(
              $db: $db,
              $table: $db.intervalPlans,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> weeklyPlansRefs(
      Expression<bool> Function($WeeklyPlansFilterComposer f) f) {
    final $WeeklyPlansFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.weeklyPlans,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $WeeklyPlansFilterComposer(
              $db: $db,
              $table: $db.weeklyPlans,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> monthlyPlansRefs(
      Expression<bool> Function($MonthlyPlansFilterComposer f) f) {
    final $MonthlyPlansFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.monthlyPlans,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $MonthlyPlansFilterComposer(
              $db: $db,
              $table: $db.monthlyPlans,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> annualPlansRefs(
      Expression<bool> Function($AnnualPlansFilterComposer f) f) {
    final $AnnualPlansFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.annualPlans,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $AnnualPlansFilterComposer(
              $db: $db,
              $table: $db.annualPlans,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> estimationSchemesRefs(
      Expression<bool> Function($EstimationSchemesFilterComposer f) f) {
    final $EstimationSchemesFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.estimationSchemes,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $EstimationSchemesFilterComposer(
              $db: $db,
              $table: $db.estimationSchemes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> monitorSchemeCategoryLinkersRefs(
      Expression<bool> Function($MonitorSchemeCategoryLinkersFilterComposer f)
          f) {
    final $MonitorSchemeCategoryLinkersFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.monitorSchemeCategoryLinkers,
            getReferencedColumn: (t) => t.category,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $MonitorSchemeCategoryLinkersFilterComposer(
                  $db: $db,
                  $table: $db.monitorSchemeCategoryLinkers,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $CategoriesOrderingComposer extends Composer<_$AppDatabase, Categories> {
  $CategoriesOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $CategoriesAnnotationComposer
    extends Composer<_$AppDatabase, Categories> {
  $CategoriesAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> receiptLogsRefs<T extends Object>(
      Expression<T> Function($ReceiptLogsAnnotationComposer a) f) {
    final $ReceiptLogsAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.receiptLogs,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $ReceiptLogsAnnotationComposer(
              $db: $db,
              $table: $db.receiptLogs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> oneshotPlansRefs<T extends Object>(
      Expression<T> Function($OneshotPlansAnnotationComposer a) f) {
    final $OneshotPlansAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.oneshotPlans,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $OneshotPlansAnnotationComposer(
              $db: $db,
              $table: $db.oneshotPlans,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> intervalPlansRefs<T extends Object>(
      Expression<T> Function($IntervalPlansAnnotationComposer a) f) {
    final $IntervalPlansAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.intervalPlans,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $IntervalPlansAnnotationComposer(
              $db: $db,
              $table: $db.intervalPlans,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> weeklyPlansRefs<T extends Object>(
      Expression<T> Function($WeeklyPlansAnnotationComposer a) f) {
    final $WeeklyPlansAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.weeklyPlans,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $WeeklyPlansAnnotationComposer(
              $db: $db,
              $table: $db.weeklyPlans,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> monthlyPlansRefs<T extends Object>(
      Expression<T> Function($MonthlyPlansAnnotationComposer a) f) {
    final $MonthlyPlansAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.monthlyPlans,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $MonthlyPlansAnnotationComposer(
              $db: $db,
              $table: $db.monthlyPlans,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> annualPlansRefs<T extends Object>(
      Expression<T> Function($AnnualPlansAnnotationComposer a) f) {
    final $AnnualPlansAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.annualPlans,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $AnnualPlansAnnotationComposer(
              $db: $db,
              $table: $db.annualPlans,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> estimationSchemesRefs<T extends Object>(
      Expression<T> Function($EstimationSchemesAnnotationComposer a) f) {
    final $EstimationSchemesAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.estimationSchemes,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $EstimationSchemesAnnotationComposer(
              $db: $db,
              $table: $db.estimationSchemes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> monitorSchemeCategoryLinkersRefs<T extends Object>(
      Expression<T> Function($MonitorSchemeCategoryLinkersAnnotationComposer a)
          f) {
    final $MonitorSchemeCategoryLinkersAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.monitorSchemeCategoryLinkers,
            getReferencedColumn: (t) => t.category,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $MonitorSchemeCategoryLinkersAnnotationComposer(
                  $db: $db,
                  $table: $db.monitorSchemeCategoryLinkers,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $CategoriesTableManager extends RootTableManager<
    _$AppDatabase,
    Categories,
    Category,
    $CategoriesFilterComposer,
    $CategoriesOrderingComposer,
    $CategoriesAnnotationComposer,
    $CategoriesCreateCompanionBuilder,
    $CategoriesUpdateCompanionBuilder,
    (Category, $CategoriesReferences),
    Category,
    PrefetchHooks Function(
        {bool receiptLogsRefs,
        bool oneshotPlansRefs,
        bool intervalPlansRefs,
        bool weeklyPlansRefs,
        bool monthlyPlansRefs,
        bool annualPlansRefs,
        bool estimationSchemesRefs,
        bool monitorSchemeCategoryLinkersRefs})> {
  $CategoriesTableManager(_$AppDatabase db, Categories table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $CategoriesFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $CategoriesOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $CategoriesAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              CategoriesCompanion(
            id: id,
            name: name,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required DateTime createdAt,
            required DateTime updatedAt,
          }) =>
              CategoriesCompanion.insert(
            id: id,
            name: name,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $CategoriesReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {receiptLogsRefs = false,
              oneshotPlansRefs = false,
              intervalPlansRefs = false,
              weeklyPlansRefs = false,
              monthlyPlansRefs = false,
              annualPlansRefs = false,
              estimationSchemesRefs = false,
              monitorSchemeCategoryLinkersRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (receiptLogsRefs) db.receiptLogs,
                if (oneshotPlansRefs) db.oneshotPlans,
                if (intervalPlansRefs) db.intervalPlans,
                if (weeklyPlansRefs) db.weeklyPlans,
                if (monthlyPlansRefs) db.monthlyPlans,
                if (annualPlansRefs) db.annualPlans,
                if (estimationSchemesRefs) db.estimationSchemes,
                if (monitorSchemeCategoryLinkersRefs)
                  db.monitorSchemeCategoryLinkers
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (receiptLogsRefs)
                    await $_getPrefetchedData<Category, Categories, ReceiptLog>(
                        currentTable: table,
                        referencedTable:
                            $CategoriesReferences._receiptLogsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $CategoriesReferences(db, table, p0)
                                .receiptLogsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.categoryId == item.id),
                        typedResults: items),
                  if (oneshotPlansRefs)
                    await $_getPrefetchedData<Category, Categories,
                            OneshotPlan>(
                        currentTable: table,
                        referencedTable:
                            $CategoriesReferences._oneshotPlansRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $CategoriesReferences(db, table, p0)
                                .oneshotPlansRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.categoryId == item.id),
                        typedResults: items),
                  if (intervalPlansRefs)
                    await $_getPrefetchedData<Category, Categories,
                            IntervalPlan>(
                        currentTable: table,
                        referencedTable:
                            $CategoriesReferences._intervalPlansRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $CategoriesReferences(db, table, p0)
                                .intervalPlansRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.categoryId == item.id),
                        typedResults: items),
                  if (weeklyPlansRefs)
                    await $_getPrefetchedData<Category, Categories, WeeklyPlan>(
                        currentTable: table,
                        referencedTable:
                            $CategoriesReferences._weeklyPlansRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $CategoriesReferences(db, table, p0)
                                .weeklyPlansRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.categoryId == item.id),
                        typedResults: items),
                  if (monthlyPlansRefs)
                    await $_getPrefetchedData<Category, Categories,
                            MonthlyPlan>(
                        currentTable: table,
                        referencedTable:
                            $CategoriesReferences._monthlyPlansRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $CategoriesReferences(db, table, p0)
                                .monthlyPlansRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.categoryId == item.id),
                        typedResults: items),
                  if (annualPlansRefs)
                    await $_getPrefetchedData<Category, Categories, AnnualPlan>(
                        currentTable: table,
                        referencedTable:
                            $CategoriesReferences._annualPlansRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $CategoriesReferences(db, table, p0)
                                .annualPlansRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.categoryId == item.id),
                        typedResults: items),
                  if (estimationSchemesRefs)
                    await $_getPrefetchedData<Category, Categories,
                            EstimationScheme>(
                        currentTable: table,
                        referencedTable: $CategoriesReferences
                            ._estimationSchemesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $CategoriesReferences(db, table, p0)
                                .estimationSchemesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.categoryId == item.id),
                        typedResults: items),
                  if (monitorSchemeCategoryLinkersRefs)
                    await $_getPrefetchedData<Category, Categories, MonitorSchemeCategoryLinker>(
                        currentTable: table,
                        referencedTable: $CategoriesReferences
                            ._monitorSchemeCategoryLinkersRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $CategoriesReferences(db, table, p0)
                                .monitorSchemeCategoryLinkersRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.category == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $CategoriesProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    Categories,
    Category,
    $CategoriesFilterComposer,
    $CategoriesOrderingComposer,
    $CategoriesAnnotationComposer,
    $CategoriesCreateCompanionBuilder,
    $CategoriesUpdateCompanionBuilder,
    (Category, $CategoriesReferences),
    Category,
    PrefetchHooks Function(
        {bool receiptLogsRefs,
        bool oneshotPlansRefs,
        bool intervalPlansRefs,
        bool weeklyPlansRefs,
        bool monthlyPlansRefs,
        bool annualPlansRefs,
        bool estimationSchemesRefs,
        bool monitorSchemeCategoryLinkersRefs})>;
typedef $CurrenciesCreateCompanionBuilder = CurrenciesCompanion Function({
  Value<int> id,
  required String symbol,
  required double ratio,
  required DateTime createdAt,
  required DateTime updatedAt,
});
typedef $CurrenciesUpdateCompanionBuilder = CurrenciesCompanion Function({
  Value<int> id,
  Value<String> symbol,
  Value<double> ratio,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $CurrenciesReferences
    extends BaseReferences<_$AppDatabase, Currencies, Currency> {
  $CurrenciesReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<ReceiptLogs, List<ReceiptLog>>
      _receiptLogsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.receiptLogs,
              aliasName: $_aliasNameGenerator(
                  db.currencies.id, db.receiptLogs.currencyId));

  $ReceiptLogsProcessedTableManager get receiptLogsRefs {
    final manager = $ReceiptLogsTableManager($_db, $_db.receiptLogs)
        .filter((f) => f.currencyId.id.sqlEquals($_itemColumn<int>('_id')!));

    final cache = $_typedResult.readTableOrNull(_receiptLogsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<OneshotPlans, List<OneshotPlan>>
      _oneshotPlansRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.oneshotPlans,
              aliasName: $_aliasNameGenerator(
                  db.currencies.id, db.oneshotPlans.currencyId));

  $OneshotPlansProcessedTableManager get oneshotPlansRefs {
    final manager = $OneshotPlansTableManager($_db, $_db.oneshotPlans)
        .filter((f) => f.currencyId.id.sqlEquals($_itemColumn<int>('_id')!));

    final cache = $_typedResult.readTableOrNull(_oneshotPlansRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<IntervalPlans, List<IntervalPlan>>
      _intervalPlansRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.intervalPlans,
              aliasName: $_aliasNameGenerator(
                  db.currencies.id, db.intervalPlans.currencyId));

  $IntervalPlansProcessedTableManager get intervalPlansRefs {
    final manager = $IntervalPlansTableManager($_db, $_db.intervalPlans)
        .filter((f) => f.currencyId.id.sqlEquals($_itemColumn<int>('_id')!));

    final cache = $_typedResult.readTableOrNull(_intervalPlansRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<WeeklyPlans, List<WeeklyPlan>>
      _weeklyPlansRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.weeklyPlans,
              aliasName: $_aliasNameGenerator(
                  db.currencies.id, db.weeklyPlans.currencyId));

  $WeeklyPlansProcessedTableManager get weeklyPlansRefs {
    final manager = $WeeklyPlansTableManager($_db, $_db.weeklyPlans)
        .filter((f) => f.currencyId.id.sqlEquals($_itemColumn<int>('_id')!));

    final cache = $_typedResult.readTableOrNull(_weeklyPlansRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<MonthlyPlans, List<MonthlyPlan>>
      _monthlyPlansRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.monthlyPlans,
              aliasName: $_aliasNameGenerator(
                  db.currencies.id, db.monthlyPlans.currencyId));

  $MonthlyPlansProcessedTableManager get monthlyPlansRefs {
    final manager = $MonthlyPlansTableManager($_db, $_db.monthlyPlans)
        .filter((f) => f.currencyId.id.sqlEquals($_itemColumn<int>('_id')!));

    final cache = $_typedResult.readTableOrNull(_monthlyPlansRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<AnnualPlans, List<AnnualPlan>>
      _annualPlansRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.annualPlans,
              aliasName: $_aliasNameGenerator(
                  db.currencies.id, db.annualPlans.currencyId));

  $AnnualPlansProcessedTableManager get annualPlansRefs {
    final manager = $AnnualPlansTableManager($_db, $_db.annualPlans)
        .filter((f) => f.currencyId.id.sqlEquals($_itemColumn<int>('_id')!));

    final cache = $_typedResult.readTableOrNull(_annualPlansRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<EstimationSchemes, List<EstimationScheme>>
      _estimationSchemesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.estimationSchemes,
              aliasName: $_aliasNameGenerator(
                  db.currencies.id, db.estimationSchemes.currencyId));

  $EstimationSchemesProcessedTableManager get estimationSchemesRefs {
    final manager = $EstimationSchemesTableManager($_db, $_db.estimationSchemes)
        .filter((f) => f.currencyId.id.sqlEquals($_itemColumn<int>('_id')!));

    final cache =
        $_typedResult.readTableOrNull(_estimationSchemesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<MonitorSchemes, List<MonitorScheme>>
      _monitorSchemesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.monitorSchemes,
              aliasName: $_aliasNameGenerator(
                  db.currencies.id, db.monitorSchemes.currencyId));

  $MonitorSchemesProcessedTableManager get monitorSchemesRefs {
    final manager = $MonitorSchemesTableManager($_db, $_db.monitorSchemes)
        .filter((f) => f.currencyId.id.sqlEquals($_itemColumn<int>('_id')!));

    final cache = $_typedResult.readTableOrNull(_monitorSchemesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $CurrenciesFilterComposer extends Composer<_$AppDatabase, Currencies> {
  $CurrenciesFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get symbol => $composableBuilder(
      column: $table.symbol, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get ratio => $composableBuilder(
      column: $table.ratio, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> receiptLogsRefs(
      Expression<bool> Function($ReceiptLogsFilterComposer f) f) {
    final $ReceiptLogsFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.receiptLogs,
        getReferencedColumn: (t) => t.currencyId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $ReceiptLogsFilterComposer(
              $db: $db,
              $table: $db.receiptLogs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> oneshotPlansRefs(
      Expression<bool> Function($OneshotPlansFilterComposer f) f) {
    final $OneshotPlansFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.oneshotPlans,
        getReferencedColumn: (t) => t.currencyId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $OneshotPlansFilterComposer(
              $db: $db,
              $table: $db.oneshotPlans,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> intervalPlansRefs(
      Expression<bool> Function($IntervalPlansFilterComposer f) f) {
    final $IntervalPlansFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.intervalPlans,
        getReferencedColumn: (t) => t.currencyId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $IntervalPlansFilterComposer(
              $db: $db,
              $table: $db.intervalPlans,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> weeklyPlansRefs(
      Expression<bool> Function($WeeklyPlansFilterComposer f) f) {
    final $WeeklyPlansFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.weeklyPlans,
        getReferencedColumn: (t) => t.currencyId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $WeeklyPlansFilterComposer(
              $db: $db,
              $table: $db.weeklyPlans,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> monthlyPlansRefs(
      Expression<bool> Function($MonthlyPlansFilterComposer f) f) {
    final $MonthlyPlansFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.monthlyPlans,
        getReferencedColumn: (t) => t.currencyId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $MonthlyPlansFilterComposer(
              $db: $db,
              $table: $db.monthlyPlans,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> annualPlansRefs(
      Expression<bool> Function($AnnualPlansFilterComposer f) f) {
    final $AnnualPlansFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.annualPlans,
        getReferencedColumn: (t) => t.currencyId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $AnnualPlansFilterComposer(
              $db: $db,
              $table: $db.annualPlans,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> estimationSchemesRefs(
      Expression<bool> Function($EstimationSchemesFilterComposer f) f) {
    final $EstimationSchemesFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.estimationSchemes,
        getReferencedColumn: (t) => t.currencyId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $EstimationSchemesFilterComposer(
              $db: $db,
              $table: $db.estimationSchemes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> monitorSchemesRefs(
      Expression<bool> Function($MonitorSchemesFilterComposer f) f) {
    final $MonitorSchemesFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.monitorSchemes,
        getReferencedColumn: (t) => t.currencyId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $MonitorSchemesFilterComposer(
              $db: $db,
              $table: $db.monitorSchemes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $CurrenciesOrderingComposer extends Composer<_$AppDatabase, Currencies> {
  $CurrenciesOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get symbol => $composableBuilder(
      column: $table.symbol, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get ratio => $composableBuilder(
      column: $table.ratio, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $CurrenciesAnnotationComposer
    extends Composer<_$AppDatabase, Currencies> {
  $CurrenciesAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get symbol =>
      $composableBuilder(column: $table.symbol, builder: (column) => column);

  GeneratedColumn<double> get ratio =>
      $composableBuilder(column: $table.ratio, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> receiptLogsRefs<T extends Object>(
      Expression<T> Function($ReceiptLogsAnnotationComposer a) f) {
    final $ReceiptLogsAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.receiptLogs,
        getReferencedColumn: (t) => t.currencyId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $ReceiptLogsAnnotationComposer(
              $db: $db,
              $table: $db.receiptLogs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> oneshotPlansRefs<T extends Object>(
      Expression<T> Function($OneshotPlansAnnotationComposer a) f) {
    final $OneshotPlansAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.oneshotPlans,
        getReferencedColumn: (t) => t.currencyId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $OneshotPlansAnnotationComposer(
              $db: $db,
              $table: $db.oneshotPlans,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> intervalPlansRefs<T extends Object>(
      Expression<T> Function($IntervalPlansAnnotationComposer a) f) {
    final $IntervalPlansAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.intervalPlans,
        getReferencedColumn: (t) => t.currencyId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $IntervalPlansAnnotationComposer(
              $db: $db,
              $table: $db.intervalPlans,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> weeklyPlansRefs<T extends Object>(
      Expression<T> Function($WeeklyPlansAnnotationComposer a) f) {
    final $WeeklyPlansAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.weeklyPlans,
        getReferencedColumn: (t) => t.currencyId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $WeeklyPlansAnnotationComposer(
              $db: $db,
              $table: $db.weeklyPlans,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> monthlyPlansRefs<T extends Object>(
      Expression<T> Function($MonthlyPlansAnnotationComposer a) f) {
    final $MonthlyPlansAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.monthlyPlans,
        getReferencedColumn: (t) => t.currencyId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $MonthlyPlansAnnotationComposer(
              $db: $db,
              $table: $db.monthlyPlans,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> annualPlansRefs<T extends Object>(
      Expression<T> Function($AnnualPlansAnnotationComposer a) f) {
    final $AnnualPlansAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.annualPlans,
        getReferencedColumn: (t) => t.currencyId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $AnnualPlansAnnotationComposer(
              $db: $db,
              $table: $db.annualPlans,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> estimationSchemesRefs<T extends Object>(
      Expression<T> Function($EstimationSchemesAnnotationComposer a) f) {
    final $EstimationSchemesAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.estimationSchemes,
        getReferencedColumn: (t) => t.currencyId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $EstimationSchemesAnnotationComposer(
              $db: $db,
              $table: $db.estimationSchemes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> monitorSchemesRefs<T extends Object>(
      Expression<T> Function($MonitorSchemesAnnotationComposer a) f) {
    final $MonitorSchemesAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.monitorSchemes,
        getReferencedColumn: (t) => t.currencyId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $MonitorSchemesAnnotationComposer(
              $db: $db,
              $table: $db.monitorSchemes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $CurrenciesTableManager extends RootTableManager<
    _$AppDatabase,
    Currencies,
    Currency,
    $CurrenciesFilterComposer,
    $CurrenciesOrderingComposer,
    $CurrenciesAnnotationComposer,
    $CurrenciesCreateCompanionBuilder,
    $CurrenciesUpdateCompanionBuilder,
    (Currency, $CurrenciesReferences),
    Currency,
    PrefetchHooks Function(
        {bool receiptLogsRefs,
        bool oneshotPlansRefs,
        bool intervalPlansRefs,
        bool weeklyPlansRefs,
        bool monthlyPlansRefs,
        bool annualPlansRefs,
        bool estimationSchemesRefs,
        bool monitorSchemesRefs})> {
  $CurrenciesTableManager(_$AppDatabase db, Currencies table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $CurrenciesFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $CurrenciesOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $CurrenciesAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> symbol = const Value.absent(),
            Value<double> ratio = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              CurrenciesCompanion(
            id: id,
            symbol: symbol,
            ratio: ratio,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String symbol,
            required double ratio,
            required DateTime createdAt,
            required DateTime updatedAt,
          }) =>
              CurrenciesCompanion.insert(
            id: id,
            symbol: symbol,
            ratio: ratio,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $CurrenciesReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {receiptLogsRefs = false,
              oneshotPlansRefs = false,
              intervalPlansRefs = false,
              weeklyPlansRefs = false,
              monthlyPlansRefs = false,
              annualPlansRefs = false,
              estimationSchemesRefs = false,
              monitorSchemesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (receiptLogsRefs) db.receiptLogs,
                if (oneshotPlansRefs) db.oneshotPlans,
                if (intervalPlansRefs) db.intervalPlans,
                if (weeklyPlansRefs) db.weeklyPlans,
                if (monthlyPlansRefs) db.monthlyPlans,
                if (annualPlansRefs) db.annualPlans,
                if (estimationSchemesRefs) db.estimationSchemes,
                if (monitorSchemesRefs) db.monitorSchemes
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (receiptLogsRefs)
                    await $_getPrefetchedData<Currency, Currencies, ReceiptLog>(
                        currentTable: table,
                        referencedTable:
                            $CurrenciesReferences._receiptLogsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $CurrenciesReferences(db, table, p0)
                                .receiptLogsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.currencyId == item.id),
                        typedResults: items),
                  if (oneshotPlansRefs)
                    await $_getPrefetchedData<Currency, Currencies,
                            OneshotPlan>(
                        currentTable: table,
                        referencedTable:
                            $CurrenciesReferences._oneshotPlansRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $CurrenciesReferences(db, table, p0)
                                .oneshotPlansRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.currencyId == item.id),
                        typedResults: items),
                  if (intervalPlansRefs)
                    await $_getPrefetchedData<Currency, Currencies,
                            IntervalPlan>(
                        currentTable: table,
                        referencedTable:
                            $CurrenciesReferences._intervalPlansRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $CurrenciesReferences(db, table, p0)
                                .intervalPlansRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.currencyId == item.id),
                        typedResults: items),
                  if (weeklyPlansRefs)
                    await $_getPrefetchedData<Currency, Currencies, WeeklyPlan>(
                        currentTable: table,
                        referencedTable:
                            $CurrenciesReferences._weeklyPlansRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $CurrenciesReferences(db, table, p0)
                                .weeklyPlansRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.currencyId == item.id),
                        typedResults: items),
                  if (monthlyPlansRefs)
                    await $_getPrefetchedData<Currency, Currencies,
                            MonthlyPlan>(
                        currentTable: table,
                        referencedTable:
                            $CurrenciesReferences._monthlyPlansRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $CurrenciesReferences(db, table, p0)
                                .monthlyPlansRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.currencyId == item.id),
                        typedResults: items),
                  if (annualPlansRefs)
                    await $_getPrefetchedData<Currency, Currencies, AnnualPlan>(
                        currentTable: table,
                        referencedTable:
                            $CurrenciesReferences._annualPlansRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $CurrenciesReferences(db, table, p0)
                                .annualPlansRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.currencyId == item.id),
                        typedResults: items),
                  if (estimationSchemesRefs)
                    await $_getPrefetchedData<Currency, Currencies,
                            EstimationScheme>(
                        currentTable: table,
                        referencedTable: $CurrenciesReferences
                            ._estimationSchemesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $CurrenciesReferences(db, table, p0)
                                .estimationSchemesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.currencyId == item.id),
                        typedResults: items),
                  if (monitorSchemesRefs)
                    await $_getPrefetchedData<Currency, Currencies,
                            MonitorScheme>(
                        currentTable: table,
                        referencedTable:
                            $CurrenciesReferences._monitorSchemesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $CurrenciesReferences(db, table, p0)
                                .monitorSchemesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.currencyId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $CurrenciesProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    Currencies,
    Currency,
    $CurrenciesFilterComposer,
    $CurrenciesOrderingComposer,
    $CurrenciesAnnotationComposer,
    $CurrenciesCreateCompanionBuilder,
    $CurrenciesUpdateCompanionBuilder,
    (Currency, $CurrenciesReferences),
    Currency,
    PrefetchHooks Function(
        {bool receiptLogsRefs,
        bool oneshotPlansRefs,
        bool intervalPlansRefs,
        bool weeklyPlansRefs,
        bool monthlyPlansRefs,
        bool annualPlansRefs,
        bool estimationSchemesRefs,
        bool monitorSchemesRefs})>;
typedef $ReceiptLogsCreateCompanionBuilder = ReceiptLogsCompanion Function({
  Value<int> id,
  required DateTime date,
  required double amount,
  required int currencyId,
  required String description,
  required int categoryId,
  required bool confirmed,
  required DateTime createdAt,
  required DateTime updatedAt,
});
typedef $ReceiptLogsUpdateCompanionBuilder = ReceiptLogsCompanion Function({
  Value<int> id,
  Value<DateTime> date,
  Value<double> amount,
  Value<int> currencyId,
  Value<String> description,
  Value<int> categoryId,
  Value<bool> confirmed,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $ReceiptLogsReferences
    extends BaseReferences<_$AppDatabase, ReceiptLogs, ReceiptLog> {
  $ReceiptLogsReferences(super.$_db, super.$_table, super.$_typedResult);

  static Currencies _currencyIdTable(_$AppDatabase db) =>
      db.currencies.createAlias(
          $_aliasNameGenerator(db.receiptLogs.currencyId, db.currencies.id));

  $CurrenciesProcessedTableManager get currencyId {
    final $_column = $_itemColumn<int>('_currencyId')!;

    final manager = $CurrenciesTableManager($_db, $_db.currencies)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_currencyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static Categories _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias(
          $_aliasNameGenerator(db.receiptLogs.categoryId, db.categories.id));

  $CategoriesProcessedTableManager get categoryId {
    final $_column = $_itemColumn<int>('_categoryId')!;

    final manager = $CategoriesTableManager($_db, $_db.categories)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $ReceiptLogsFilterComposer extends Composer<_$AppDatabase, ReceiptLogs> {
  $ReceiptLogsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get confirmed => $composableBuilder(
      column: $table.confirmed, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $CurrenciesFilterComposer get currencyId {
    final $CurrenciesFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.currencyId,
        referencedTable: $db.currencies,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $CurrenciesFilterComposer(
              $db: $db,
              $table: $db.currencies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $CategoriesFilterComposer get categoryId {
    final $CategoriesFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $CategoriesFilterComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $ReceiptLogsOrderingComposer
    extends Composer<_$AppDatabase, ReceiptLogs> {
  $ReceiptLogsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get confirmed => $composableBuilder(
      column: $table.confirmed, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $CurrenciesOrderingComposer get currencyId {
    final $CurrenciesOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.currencyId,
        referencedTable: $db.currencies,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $CurrenciesOrderingComposer(
              $db: $db,
              $table: $db.currencies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $CategoriesOrderingComposer get categoryId {
    final $CategoriesOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $CategoriesOrderingComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $ReceiptLogsAnnotationComposer
    extends Composer<_$AppDatabase, ReceiptLogs> {
  $ReceiptLogsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<bool> get confirmed =>
      $composableBuilder(column: $table.confirmed, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $CurrenciesAnnotationComposer get currencyId {
    final $CurrenciesAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.currencyId,
        referencedTable: $db.currencies,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $CurrenciesAnnotationComposer(
              $db: $db,
              $table: $db.currencies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $CategoriesAnnotationComposer get categoryId {
    final $CategoriesAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $CategoriesAnnotationComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $ReceiptLogsTableManager extends RootTableManager<
    _$AppDatabase,
    ReceiptLogs,
    ReceiptLog,
    $ReceiptLogsFilterComposer,
    $ReceiptLogsOrderingComposer,
    $ReceiptLogsAnnotationComposer,
    $ReceiptLogsCreateCompanionBuilder,
    $ReceiptLogsUpdateCompanionBuilder,
    (ReceiptLog, $ReceiptLogsReferences),
    ReceiptLog,
    PrefetchHooks Function({bool currencyId, bool categoryId})> {
  $ReceiptLogsTableManager(_$AppDatabase db, ReceiptLogs table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $ReceiptLogsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $ReceiptLogsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $ReceiptLogsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<int> currencyId = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<int> categoryId = const Value.absent(),
            Value<bool> confirmed = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              ReceiptLogsCompanion(
            id: id,
            date: date,
            amount: amount,
            currencyId: currencyId,
            description: description,
            categoryId: categoryId,
            confirmed: confirmed,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required DateTime date,
            required double amount,
            required int currencyId,
            required String description,
            required int categoryId,
            required bool confirmed,
            required DateTime createdAt,
            required DateTime updatedAt,
          }) =>
              ReceiptLogsCompanion.insert(
            id: id,
            date: date,
            amount: amount,
            currencyId: currencyId,
            description: description,
            categoryId: categoryId,
            confirmed: confirmed,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $ReceiptLogsReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({currencyId = false, categoryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (currencyId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.currencyId,
                    referencedTable:
                        $ReceiptLogsReferences._currencyIdTable(db),
                    referencedColumn:
                        $ReceiptLogsReferences._currencyIdTable(db).id,
                  ) as T;
                }
                if (categoryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.categoryId,
                    referencedTable:
                        $ReceiptLogsReferences._categoryIdTable(db),
                    referencedColumn:
                        $ReceiptLogsReferences._categoryIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $ReceiptLogsProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    ReceiptLogs,
    ReceiptLog,
    $ReceiptLogsFilterComposer,
    $ReceiptLogsOrderingComposer,
    $ReceiptLogsAnnotationComposer,
    $ReceiptLogsCreateCompanionBuilder,
    $ReceiptLogsUpdateCompanionBuilder,
    (ReceiptLog, $ReceiptLogsReferences),
    ReceiptLog,
    PrefetchHooks Function({bool currencyId, bool categoryId})>;
typedef $OneshotPlansCreateCompanionBuilder = OneshotPlansCompanion Function({
  Value<int> id,
  required double amount,
  required int currencyId,
  required String description,
  required int categoryId,
  required DateTime date,
  required DateTime createdAt,
  required DateTime updatedAt,
});
typedef $OneshotPlansUpdateCompanionBuilder = OneshotPlansCompanion Function({
  Value<int> id,
  Value<double> amount,
  Value<int> currencyId,
  Value<String> description,
  Value<int> categoryId,
  Value<DateTime> date,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $OneshotPlansReferences
    extends BaseReferences<_$AppDatabase, OneshotPlans, OneshotPlan> {
  $OneshotPlansReferences(super.$_db, super.$_table, super.$_typedResult);

  static Currencies _currencyIdTable(_$AppDatabase db) =>
      db.currencies.createAlias(
          $_aliasNameGenerator(db.oneshotPlans.currencyId, db.currencies.id));

  $CurrenciesProcessedTableManager get currencyId {
    final $_column = $_itemColumn<int>('_currencyId')!;

    final manager = $CurrenciesTableManager($_db, $_db.currencies)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_currencyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static Categories _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias(
          $_aliasNameGenerator(db.oneshotPlans.categoryId, db.categories.id));

  $CategoriesProcessedTableManager get categoryId {
    final $_column = $_itemColumn<int>('_categoryId')!;

    final manager = $CategoriesTableManager($_db, $_db.categories)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $OneshotPlansFilterComposer
    extends Composer<_$AppDatabase, OneshotPlans> {
  $OneshotPlansFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $CurrenciesFilterComposer get currencyId {
    final $CurrenciesFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.currencyId,
        referencedTable: $db.currencies,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $CurrenciesFilterComposer(
              $db: $db,
              $table: $db.currencies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $CategoriesFilterComposer get categoryId {
    final $CategoriesFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $CategoriesFilterComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $OneshotPlansOrderingComposer
    extends Composer<_$AppDatabase, OneshotPlans> {
  $OneshotPlansOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $CurrenciesOrderingComposer get currencyId {
    final $CurrenciesOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.currencyId,
        referencedTable: $db.currencies,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $CurrenciesOrderingComposer(
              $db: $db,
              $table: $db.currencies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $CategoriesOrderingComposer get categoryId {
    final $CategoriesOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $CategoriesOrderingComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $OneshotPlansAnnotationComposer
    extends Composer<_$AppDatabase, OneshotPlans> {
  $OneshotPlansAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $CurrenciesAnnotationComposer get currencyId {
    final $CurrenciesAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.currencyId,
        referencedTable: $db.currencies,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $CurrenciesAnnotationComposer(
              $db: $db,
              $table: $db.currencies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $CategoriesAnnotationComposer get categoryId {
    final $CategoriesAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $CategoriesAnnotationComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $OneshotPlansTableManager extends RootTableManager<
    _$AppDatabase,
    OneshotPlans,
    OneshotPlan,
    $OneshotPlansFilterComposer,
    $OneshotPlansOrderingComposer,
    $OneshotPlansAnnotationComposer,
    $OneshotPlansCreateCompanionBuilder,
    $OneshotPlansUpdateCompanionBuilder,
    (OneshotPlan, $OneshotPlansReferences),
    OneshotPlan,
    PrefetchHooks Function({bool currencyId, bool categoryId})> {
  $OneshotPlansTableManager(_$AppDatabase db, OneshotPlans table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $OneshotPlansFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $OneshotPlansOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $OneshotPlansAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<int> currencyId = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<int> categoryId = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              OneshotPlansCompanion(
            id: id,
            amount: amount,
            currencyId: currencyId,
            description: description,
            categoryId: categoryId,
            date: date,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required double amount,
            required int currencyId,
            required String description,
            required int categoryId,
            required DateTime date,
            required DateTime createdAt,
            required DateTime updatedAt,
          }) =>
              OneshotPlansCompanion.insert(
            id: id,
            amount: amount,
            currencyId: currencyId,
            description: description,
            categoryId: categoryId,
            date: date,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $OneshotPlansReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({currencyId = false, categoryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (currencyId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.currencyId,
                    referencedTable:
                        $OneshotPlansReferences._currencyIdTable(db),
                    referencedColumn:
                        $OneshotPlansReferences._currencyIdTable(db).id,
                  ) as T;
                }
                if (categoryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.categoryId,
                    referencedTable:
                        $OneshotPlansReferences._categoryIdTable(db),
                    referencedColumn:
                        $OneshotPlansReferences._categoryIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $OneshotPlansProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    OneshotPlans,
    OneshotPlan,
    $OneshotPlansFilterComposer,
    $OneshotPlansOrderingComposer,
    $OneshotPlansAnnotationComposer,
    $OneshotPlansCreateCompanionBuilder,
    $OneshotPlansUpdateCompanionBuilder,
    (OneshotPlan, $OneshotPlansReferences),
    OneshotPlan,
    PrefetchHooks Function({bool currencyId, bool categoryId})>;
typedef $IntervalPlansCreateCompanionBuilder = IntervalPlansCompanion Function({
  Value<int> id,
  required double amount,
  required int currencyId,
  required String description,
  required int categoryId,
  required int interval,
  required DateTime origin,
  required DateTime periodBegins,
  required DateTime periodEnds,
  required DateTime createdAt,
  required DateTime updatedAt,
});
typedef $IntervalPlansUpdateCompanionBuilder = IntervalPlansCompanion Function({
  Value<int> id,
  Value<double> amount,
  Value<int> currencyId,
  Value<String> description,
  Value<int> categoryId,
  Value<int> interval,
  Value<DateTime> origin,
  Value<DateTime> periodBegins,
  Value<DateTime> periodEnds,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $IntervalPlansReferences
    extends BaseReferences<_$AppDatabase, IntervalPlans, IntervalPlan> {
  $IntervalPlansReferences(super.$_db, super.$_table, super.$_typedResult);

  static Currencies _currencyIdTable(_$AppDatabase db) =>
      db.currencies.createAlias(
          $_aliasNameGenerator(db.intervalPlans.currencyId, db.currencies.id));

  $CurrenciesProcessedTableManager get currencyId {
    final $_column = $_itemColumn<int>('_currencyId')!;

    final manager = $CurrenciesTableManager($_db, $_db.currencies)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_currencyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static Categories _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias(
          $_aliasNameGenerator(db.intervalPlans.categoryId, db.categories.id));

  $CategoriesProcessedTableManager get categoryId {
    final $_column = $_itemColumn<int>('_categoryId')!;

    final manager = $CategoriesTableManager($_db, $_db.categories)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $IntervalPlansFilterComposer
    extends Composer<_$AppDatabase, IntervalPlans> {
  $IntervalPlansFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get interval => $composableBuilder(
      column: $table.interval, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get origin => $composableBuilder(
      column: $table.origin, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get periodBegins => $composableBuilder(
      column: $table.periodBegins, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get periodEnds => $composableBuilder(
      column: $table.periodEnds, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $CurrenciesFilterComposer get currencyId {
    final $CurrenciesFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.currencyId,
        referencedTable: $db.currencies,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $CurrenciesFilterComposer(
              $db: $db,
              $table: $db.currencies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $CategoriesFilterComposer get categoryId {
    final $CategoriesFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $CategoriesFilterComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $IntervalPlansOrderingComposer
    extends Composer<_$AppDatabase, IntervalPlans> {
  $IntervalPlansOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get interval => $composableBuilder(
      column: $table.interval, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get origin => $composableBuilder(
      column: $table.origin, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get periodBegins => $composableBuilder(
      column: $table.periodBegins,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get periodEnds => $composableBuilder(
      column: $table.periodEnds, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $CurrenciesOrderingComposer get currencyId {
    final $CurrenciesOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.currencyId,
        referencedTable: $db.currencies,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $CurrenciesOrderingComposer(
              $db: $db,
              $table: $db.currencies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $CategoriesOrderingComposer get categoryId {
    final $CategoriesOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $CategoriesOrderingComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $IntervalPlansAnnotationComposer
    extends Composer<_$AppDatabase, IntervalPlans> {
  $IntervalPlansAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<int> get interval =>
      $composableBuilder(column: $table.interval, builder: (column) => column);

  GeneratedColumn<DateTime> get origin =>
      $composableBuilder(column: $table.origin, builder: (column) => column);

  GeneratedColumn<DateTime> get periodBegins => $composableBuilder(
      column: $table.periodBegins, builder: (column) => column);

  GeneratedColumn<DateTime> get periodEnds => $composableBuilder(
      column: $table.periodEnds, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $CurrenciesAnnotationComposer get currencyId {
    final $CurrenciesAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.currencyId,
        referencedTable: $db.currencies,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $CurrenciesAnnotationComposer(
              $db: $db,
              $table: $db.currencies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $CategoriesAnnotationComposer get categoryId {
    final $CategoriesAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $CategoriesAnnotationComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $IntervalPlansTableManager extends RootTableManager<
    _$AppDatabase,
    IntervalPlans,
    IntervalPlan,
    $IntervalPlansFilterComposer,
    $IntervalPlansOrderingComposer,
    $IntervalPlansAnnotationComposer,
    $IntervalPlansCreateCompanionBuilder,
    $IntervalPlansUpdateCompanionBuilder,
    (IntervalPlan, $IntervalPlansReferences),
    IntervalPlan,
    PrefetchHooks Function({bool currencyId, bool categoryId})> {
  $IntervalPlansTableManager(_$AppDatabase db, IntervalPlans table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $IntervalPlansFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $IntervalPlansOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $IntervalPlansAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<int> currencyId = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<int> categoryId = const Value.absent(),
            Value<int> interval = const Value.absent(),
            Value<DateTime> origin = const Value.absent(),
            Value<DateTime> periodBegins = const Value.absent(),
            Value<DateTime> periodEnds = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              IntervalPlansCompanion(
            id: id,
            amount: amount,
            currencyId: currencyId,
            description: description,
            categoryId: categoryId,
            interval: interval,
            origin: origin,
            periodBegins: periodBegins,
            periodEnds: periodEnds,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required double amount,
            required int currencyId,
            required String description,
            required int categoryId,
            required int interval,
            required DateTime origin,
            required DateTime periodBegins,
            required DateTime periodEnds,
            required DateTime createdAt,
            required DateTime updatedAt,
          }) =>
              IntervalPlansCompanion.insert(
            id: id,
            amount: amount,
            currencyId: currencyId,
            description: description,
            categoryId: categoryId,
            interval: interval,
            origin: origin,
            periodBegins: periodBegins,
            periodEnds: periodEnds,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $IntervalPlansReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({currencyId = false, categoryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (currencyId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.currencyId,
                    referencedTable:
                        $IntervalPlansReferences._currencyIdTable(db),
                    referencedColumn:
                        $IntervalPlansReferences._currencyIdTable(db).id,
                  ) as T;
                }
                if (categoryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.categoryId,
                    referencedTable:
                        $IntervalPlansReferences._categoryIdTable(db),
                    referencedColumn:
                        $IntervalPlansReferences._categoryIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $IntervalPlansProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    IntervalPlans,
    IntervalPlan,
    $IntervalPlansFilterComposer,
    $IntervalPlansOrderingComposer,
    $IntervalPlansAnnotationComposer,
    $IntervalPlansCreateCompanionBuilder,
    $IntervalPlansUpdateCompanionBuilder,
    (IntervalPlan, $IntervalPlansReferences),
    IntervalPlan,
    PrefetchHooks Function({bool currencyId, bool categoryId})>;
typedef $WeeklyPlansCreateCompanionBuilder = WeeklyPlansCompanion Function({
  Value<int> id,
  required double amount,
  required int currencyId,
  required String description,
  required int categoryId,
  required bool sunday,
  required bool monday,
  required bool tuesday,
  required bool wednesday,
  required bool thursday,
  required bool friday,
  required bool saturday,
  required DateTime periodBegins,
  required DateTime periodEnds,
  required DateTime createdAt,
  required DateTime updatedAt,
});
typedef $WeeklyPlansUpdateCompanionBuilder = WeeklyPlansCompanion Function({
  Value<int> id,
  Value<double> amount,
  Value<int> currencyId,
  Value<String> description,
  Value<int> categoryId,
  Value<bool> sunday,
  Value<bool> monday,
  Value<bool> tuesday,
  Value<bool> wednesday,
  Value<bool> thursday,
  Value<bool> friday,
  Value<bool> saturday,
  Value<DateTime> periodBegins,
  Value<DateTime> periodEnds,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $WeeklyPlansReferences
    extends BaseReferences<_$AppDatabase, WeeklyPlans, WeeklyPlan> {
  $WeeklyPlansReferences(super.$_db, super.$_table, super.$_typedResult);

  static Currencies _currencyIdTable(_$AppDatabase db) =>
      db.currencies.createAlias(
          $_aliasNameGenerator(db.weeklyPlans.currencyId, db.currencies.id));

  $CurrenciesProcessedTableManager get currencyId {
    final $_column = $_itemColumn<int>('_currencyId')!;

    final manager = $CurrenciesTableManager($_db, $_db.currencies)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_currencyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static Categories _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias(
          $_aliasNameGenerator(db.weeklyPlans.categoryId, db.categories.id));

  $CategoriesProcessedTableManager get categoryId {
    final $_column = $_itemColumn<int>('_categoryId')!;

    final manager = $CategoriesTableManager($_db, $_db.categories)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $WeeklyPlansFilterComposer extends Composer<_$AppDatabase, WeeklyPlans> {
  $WeeklyPlansFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get sunday => $composableBuilder(
      column: $table.sunday, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get monday => $composableBuilder(
      column: $table.monday, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get tuesday => $composableBuilder(
      column: $table.tuesday, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get wednesday => $composableBuilder(
      column: $table.wednesday, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get thursday => $composableBuilder(
      column: $table.thursday, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get friday => $composableBuilder(
      column: $table.friday, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get saturday => $composableBuilder(
      column: $table.saturday, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get periodBegins => $composableBuilder(
      column: $table.periodBegins, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get periodEnds => $composableBuilder(
      column: $table.periodEnds, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $CurrenciesFilterComposer get currencyId {
    final $CurrenciesFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.currencyId,
        referencedTable: $db.currencies,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $CurrenciesFilterComposer(
              $db: $db,
              $table: $db.currencies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $CategoriesFilterComposer get categoryId {
    final $CategoriesFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $CategoriesFilterComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $WeeklyPlansOrderingComposer
    extends Composer<_$AppDatabase, WeeklyPlans> {
  $WeeklyPlansOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get sunday => $composableBuilder(
      column: $table.sunday, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get monday => $composableBuilder(
      column: $table.monday, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get tuesday => $composableBuilder(
      column: $table.tuesday, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get wednesday => $composableBuilder(
      column: $table.wednesday, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get thursday => $composableBuilder(
      column: $table.thursday, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get friday => $composableBuilder(
      column: $table.friday, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get saturday => $composableBuilder(
      column: $table.saturday, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get periodBegins => $composableBuilder(
      column: $table.periodBegins,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get periodEnds => $composableBuilder(
      column: $table.periodEnds, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $CurrenciesOrderingComposer get currencyId {
    final $CurrenciesOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.currencyId,
        referencedTable: $db.currencies,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $CurrenciesOrderingComposer(
              $db: $db,
              $table: $db.currencies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $CategoriesOrderingComposer get categoryId {
    final $CategoriesOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $CategoriesOrderingComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $WeeklyPlansAnnotationComposer
    extends Composer<_$AppDatabase, WeeklyPlans> {
  $WeeklyPlansAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<bool> get sunday =>
      $composableBuilder(column: $table.sunday, builder: (column) => column);

  GeneratedColumn<bool> get monday =>
      $composableBuilder(column: $table.monday, builder: (column) => column);

  GeneratedColumn<bool> get tuesday =>
      $composableBuilder(column: $table.tuesday, builder: (column) => column);

  GeneratedColumn<bool> get wednesday =>
      $composableBuilder(column: $table.wednesday, builder: (column) => column);

  GeneratedColumn<bool> get thursday =>
      $composableBuilder(column: $table.thursday, builder: (column) => column);

  GeneratedColumn<bool> get friday =>
      $composableBuilder(column: $table.friday, builder: (column) => column);

  GeneratedColumn<bool> get saturday =>
      $composableBuilder(column: $table.saturday, builder: (column) => column);

  GeneratedColumn<DateTime> get periodBegins => $composableBuilder(
      column: $table.periodBegins, builder: (column) => column);

  GeneratedColumn<DateTime> get periodEnds => $composableBuilder(
      column: $table.periodEnds, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $CurrenciesAnnotationComposer get currencyId {
    final $CurrenciesAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.currencyId,
        referencedTable: $db.currencies,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $CurrenciesAnnotationComposer(
              $db: $db,
              $table: $db.currencies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $CategoriesAnnotationComposer get categoryId {
    final $CategoriesAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $CategoriesAnnotationComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $WeeklyPlansTableManager extends RootTableManager<
    _$AppDatabase,
    WeeklyPlans,
    WeeklyPlan,
    $WeeklyPlansFilterComposer,
    $WeeklyPlansOrderingComposer,
    $WeeklyPlansAnnotationComposer,
    $WeeklyPlansCreateCompanionBuilder,
    $WeeklyPlansUpdateCompanionBuilder,
    (WeeklyPlan, $WeeklyPlansReferences),
    WeeklyPlan,
    PrefetchHooks Function({bool currencyId, bool categoryId})> {
  $WeeklyPlansTableManager(_$AppDatabase db, WeeklyPlans table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $WeeklyPlansFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $WeeklyPlansOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $WeeklyPlansAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<int> currencyId = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<int> categoryId = const Value.absent(),
            Value<bool> sunday = const Value.absent(),
            Value<bool> monday = const Value.absent(),
            Value<bool> tuesday = const Value.absent(),
            Value<bool> wednesday = const Value.absent(),
            Value<bool> thursday = const Value.absent(),
            Value<bool> friday = const Value.absent(),
            Value<bool> saturday = const Value.absent(),
            Value<DateTime> periodBegins = const Value.absent(),
            Value<DateTime> periodEnds = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              WeeklyPlansCompanion(
            id: id,
            amount: amount,
            currencyId: currencyId,
            description: description,
            categoryId: categoryId,
            sunday: sunday,
            monday: monday,
            tuesday: tuesday,
            wednesday: wednesday,
            thursday: thursday,
            friday: friday,
            saturday: saturday,
            periodBegins: periodBegins,
            periodEnds: periodEnds,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required double amount,
            required int currencyId,
            required String description,
            required int categoryId,
            required bool sunday,
            required bool monday,
            required bool tuesday,
            required bool wednesday,
            required bool thursday,
            required bool friday,
            required bool saturday,
            required DateTime periodBegins,
            required DateTime periodEnds,
            required DateTime createdAt,
            required DateTime updatedAt,
          }) =>
              WeeklyPlansCompanion.insert(
            id: id,
            amount: amount,
            currencyId: currencyId,
            description: description,
            categoryId: categoryId,
            sunday: sunday,
            monday: monday,
            tuesday: tuesday,
            wednesday: wednesday,
            thursday: thursday,
            friday: friday,
            saturday: saturday,
            periodBegins: periodBegins,
            periodEnds: periodEnds,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $WeeklyPlansReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({currencyId = false, categoryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (currencyId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.currencyId,
                    referencedTable:
                        $WeeklyPlansReferences._currencyIdTable(db),
                    referencedColumn:
                        $WeeklyPlansReferences._currencyIdTable(db).id,
                  ) as T;
                }
                if (categoryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.categoryId,
                    referencedTable:
                        $WeeklyPlansReferences._categoryIdTable(db),
                    referencedColumn:
                        $WeeklyPlansReferences._categoryIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $WeeklyPlansProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    WeeklyPlans,
    WeeklyPlan,
    $WeeklyPlansFilterComposer,
    $WeeklyPlansOrderingComposer,
    $WeeklyPlansAnnotationComposer,
    $WeeklyPlansCreateCompanionBuilder,
    $WeeklyPlansUpdateCompanionBuilder,
    (WeeklyPlan, $WeeklyPlansReferences),
    WeeklyPlan,
    PrefetchHooks Function({bool currencyId, bool categoryId})>;
typedef $MonthlyPlansCreateCompanionBuilder = MonthlyPlansCompanion Function({
  Value<int> id,
  required double amount,
  required int currencyId,
  required String description,
  required int categoryId,
  required int offset,
  required DateTime periodBegins,
  required DateTime periodEnds,
  required DateTime createdAt,
  required DateTime updatedAt,
});
typedef $MonthlyPlansUpdateCompanionBuilder = MonthlyPlansCompanion Function({
  Value<int> id,
  Value<double> amount,
  Value<int> currencyId,
  Value<String> description,
  Value<int> categoryId,
  Value<int> offset,
  Value<DateTime> periodBegins,
  Value<DateTime> periodEnds,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $MonthlyPlansReferences
    extends BaseReferences<_$AppDatabase, MonthlyPlans, MonthlyPlan> {
  $MonthlyPlansReferences(super.$_db, super.$_table, super.$_typedResult);

  static Currencies _currencyIdTable(_$AppDatabase db) =>
      db.currencies.createAlias(
          $_aliasNameGenerator(db.monthlyPlans.currencyId, db.currencies.id));

  $CurrenciesProcessedTableManager get currencyId {
    final $_column = $_itemColumn<int>('_currencyId')!;

    final manager = $CurrenciesTableManager($_db, $_db.currencies)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_currencyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static Categories _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias(
          $_aliasNameGenerator(db.monthlyPlans.categoryId, db.categories.id));

  $CategoriesProcessedTableManager get categoryId {
    final $_column = $_itemColumn<int>('_categoryId')!;

    final manager = $CategoriesTableManager($_db, $_db.categories)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $MonthlyPlansFilterComposer
    extends Composer<_$AppDatabase, MonthlyPlans> {
  $MonthlyPlansFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get offset => $composableBuilder(
      column: $table.offset, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get periodBegins => $composableBuilder(
      column: $table.periodBegins, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get periodEnds => $composableBuilder(
      column: $table.periodEnds, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $CurrenciesFilterComposer get currencyId {
    final $CurrenciesFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.currencyId,
        referencedTable: $db.currencies,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $CurrenciesFilterComposer(
              $db: $db,
              $table: $db.currencies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $CategoriesFilterComposer get categoryId {
    final $CategoriesFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $CategoriesFilterComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $MonthlyPlansOrderingComposer
    extends Composer<_$AppDatabase, MonthlyPlans> {
  $MonthlyPlansOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get offset => $composableBuilder(
      column: $table.offset, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get periodBegins => $composableBuilder(
      column: $table.periodBegins,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get periodEnds => $composableBuilder(
      column: $table.periodEnds, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $CurrenciesOrderingComposer get currencyId {
    final $CurrenciesOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.currencyId,
        referencedTable: $db.currencies,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $CurrenciesOrderingComposer(
              $db: $db,
              $table: $db.currencies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $CategoriesOrderingComposer get categoryId {
    final $CategoriesOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $CategoriesOrderingComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $MonthlyPlansAnnotationComposer
    extends Composer<_$AppDatabase, MonthlyPlans> {
  $MonthlyPlansAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<int> get offset =>
      $composableBuilder(column: $table.offset, builder: (column) => column);

  GeneratedColumn<DateTime> get periodBegins => $composableBuilder(
      column: $table.periodBegins, builder: (column) => column);

  GeneratedColumn<DateTime> get periodEnds => $composableBuilder(
      column: $table.periodEnds, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $CurrenciesAnnotationComposer get currencyId {
    final $CurrenciesAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.currencyId,
        referencedTable: $db.currencies,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $CurrenciesAnnotationComposer(
              $db: $db,
              $table: $db.currencies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $CategoriesAnnotationComposer get categoryId {
    final $CategoriesAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $CategoriesAnnotationComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $MonthlyPlansTableManager extends RootTableManager<
    _$AppDatabase,
    MonthlyPlans,
    MonthlyPlan,
    $MonthlyPlansFilterComposer,
    $MonthlyPlansOrderingComposer,
    $MonthlyPlansAnnotationComposer,
    $MonthlyPlansCreateCompanionBuilder,
    $MonthlyPlansUpdateCompanionBuilder,
    (MonthlyPlan, $MonthlyPlansReferences),
    MonthlyPlan,
    PrefetchHooks Function({bool currencyId, bool categoryId})> {
  $MonthlyPlansTableManager(_$AppDatabase db, MonthlyPlans table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $MonthlyPlansFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $MonthlyPlansOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $MonthlyPlansAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<int> currencyId = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<int> categoryId = const Value.absent(),
            Value<int> offset = const Value.absent(),
            Value<DateTime> periodBegins = const Value.absent(),
            Value<DateTime> periodEnds = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              MonthlyPlansCompanion(
            id: id,
            amount: amount,
            currencyId: currencyId,
            description: description,
            categoryId: categoryId,
            offset: offset,
            periodBegins: periodBegins,
            periodEnds: periodEnds,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required double amount,
            required int currencyId,
            required String description,
            required int categoryId,
            required int offset,
            required DateTime periodBegins,
            required DateTime periodEnds,
            required DateTime createdAt,
            required DateTime updatedAt,
          }) =>
              MonthlyPlansCompanion.insert(
            id: id,
            amount: amount,
            currencyId: currencyId,
            description: description,
            categoryId: categoryId,
            offset: offset,
            periodBegins: periodBegins,
            periodEnds: periodEnds,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $MonthlyPlansReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({currencyId = false, categoryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (currencyId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.currencyId,
                    referencedTable:
                        $MonthlyPlansReferences._currencyIdTable(db),
                    referencedColumn:
                        $MonthlyPlansReferences._currencyIdTable(db).id,
                  ) as T;
                }
                if (categoryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.categoryId,
                    referencedTable:
                        $MonthlyPlansReferences._categoryIdTable(db),
                    referencedColumn:
                        $MonthlyPlansReferences._categoryIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $MonthlyPlansProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    MonthlyPlans,
    MonthlyPlan,
    $MonthlyPlansFilterComposer,
    $MonthlyPlansOrderingComposer,
    $MonthlyPlansAnnotationComposer,
    $MonthlyPlansCreateCompanionBuilder,
    $MonthlyPlansUpdateCompanionBuilder,
    (MonthlyPlan, $MonthlyPlansReferences),
    MonthlyPlan,
    PrefetchHooks Function({bool currencyId, bool categoryId})>;
typedef $AnnualPlansCreateCompanionBuilder = AnnualPlansCompanion Function({
  Value<int> id,
  required double amount,
  required int currencyId,
  required String description,
  required int categoryId,
  required DateTime origin,
  required DateTime periodBegins,
  required DateTime periodEnds,
  required DateTime createdAt,
  required DateTime updatedAt,
});
typedef $AnnualPlansUpdateCompanionBuilder = AnnualPlansCompanion Function({
  Value<int> id,
  Value<double> amount,
  Value<int> currencyId,
  Value<String> description,
  Value<int> categoryId,
  Value<DateTime> origin,
  Value<DateTime> periodBegins,
  Value<DateTime> periodEnds,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $AnnualPlansReferences
    extends BaseReferences<_$AppDatabase, AnnualPlans, AnnualPlan> {
  $AnnualPlansReferences(super.$_db, super.$_table, super.$_typedResult);

  static Currencies _currencyIdTable(_$AppDatabase db) =>
      db.currencies.createAlias(
          $_aliasNameGenerator(db.annualPlans.currencyId, db.currencies.id));

  $CurrenciesProcessedTableManager get currencyId {
    final $_column = $_itemColumn<int>('_currencyId')!;

    final manager = $CurrenciesTableManager($_db, $_db.currencies)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_currencyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static Categories _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias(
          $_aliasNameGenerator(db.annualPlans.categoryId, db.categories.id));

  $CategoriesProcessedTableManager get categoryId {
    final $_column = $_itemColumn<int>('_categoryId')!;

    final manager = $CategoriesTableManager($_db, $_db.categories)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $AnnualPlansFilterComposer extends Composer<_$AppDatabase, AnnualPlans> {
  $AnnualPlansFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get origin => $composableBuilder(
      column: $table.origin, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get periodBegins => $composableBuilder(
      column: $table.periodBegins, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get periodEnds => $composableBuilder(
      column: $table.periodEnds, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $CurrenciesFilterComposer get currencyId {
    final $CurrenciesFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.currencyId,
        referencedTable: $db.currencies,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $CurrenciesFilterComposer(
              $db: $db,
              $table: $db.currencies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $CategoriesFilterComposer get categoryId {
    final $CategoriesFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $CategoriesFilterComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $AnnualPlansOrderingComposer
    extends Composer<_$AppDatabase, AnnualPlans> {
  $AnnualPlansOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get origin => $composableBuilder(
      column: $table.origin, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get periodBegins => $composableBuilder(
      column: $table.periodBegins,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get periodEnds => $composableBuilder(
      column: $table.periodEnds, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $CurrenciesOrderingComposer get currencyId {
    final $CurrenciesOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.currencyId,
        referencedTable: $db.currencies,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $CurrenciesOrderingComposer(
              $db: $db,
              $table: $db.currencies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $CategoriesOrderingComposer get categoryId {
    final $CategoriesOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $CategoriesOrderingComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $AnnualPlansAnnotationComposer
    extends Composer<_$AppDatabase, AnnualPlans> {
  $AnnualPlansAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<DateTime> get origin =>
      $composableBuilder(column: $table.origin, builder: (column) => column);

  GeneratedColumn<DateTime> get periodBegins => $composableBuilder(
      column: $table.periodBegins, builder: (column) => column);

  GeneratedColumn<DateTime> get periodEnds => $composableBuilder(
      column: $table.periodEnds, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $CurrenciesAnnotationComposer get currencyId {
    final $CurrenciesAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.currencyId,
        referencedTable: $db.currencies,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $CurrenciesAnnotationComposer(
              $db: $db,
              $table: $db.currencies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $CategoriesAnnotationComposer get categoryId {
    final $CategoriesAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $CategoriesAnnotationComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $AnnualPlansTableManager extends RootTableManager<
    _$AppDatabase,
    AnnualPlans,
    AnnualPlan,
    $AnnualPlansFilterComposer,
    $AnnualPlansOrderingComposer,
    $AnnualPlansAnnotationComposer,
    $AnnualPlansCreateCompanionBuilder,
    $AnnualPlansUpdateCompanionBuilder,
    (AnnualPlan, $AnnualPlansReferences),
    AnnualPlan,
    PrefetchHooks Function({bool currencyId, bool categoryId})> {
  $AnnualPlansTableManager(_$AppDatabase db, AnnualPlans table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $AnnualPlansFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $AnnualPlansOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $AnnualPlansAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<int> currencyId = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<int> categoryId = const Value.absent(),
            Value<DateTime> origin = const Value.absent(),
            Value<DateTime> periodBegins = const Value.absent(),
            Value<DateTime> periodEnds = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              AnnualPlansCompanion(
            id: id,
            amount: amount,
            currencyId: currencyId,
            description: description,
            categoryId: categoryId,
            origin: origin,
            periodBegins: periodBegins,
            periodEnds: periodEnds,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required double amount,
            required int currencyId,
            required String description,
            required int categoryId,
            required DateTime origin,
            required DateTime periodBegins,
            required DateTime periodEnds,
            required DateTime createdAt,
            required DateTime updatedAt,
          }) =>
              AnnualPlansCompanion.insert(
            id: id,
            amount: amount,
            currencyId: currencyId,
            description: description,
            categoryId: categoryId,
            origin: origin,
            periodBegins: periodBegins,
            periodEnds: periodEnds,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $AnnualPlansReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({currencyId = false, categoryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (currencyId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.currencyId,
                    referencedTable:
                        $AnnualPlansReferences._currencyIdTable(db),
                    referencedColumn:
                        $AnnualPlansReferences._currencyIdTable(db).id,
                  ) as T;
                }
                if (categoryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.categoryId,
                    referencedTable:
                        $AnnualPlansReferences._categoryIdTable(db),
                    referencedColumn:
                        $AnnualPlansReferences._categoryIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $AnnualPlansProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    AnnualPlans,
    AnnualPlan,
    $AnnualPlansFilterComposer,
    $AnnualPlansOrderingComposer,
    $AnnualPlansAnnotationComposer,
    $AnnualPlansCreateCompanionBuilder,
    $AnnualPlansUpdateCompanionBuilder,
    (AnnualPlan, $AnnualPlansReferences),
    AnnualPlan,
    PrefetchHooks Function({bool currencyId, bool categoryId})>;
typedef $EstimationSchemesCreateCompanionBuilder = EstimationSchemesCompanion
    Function({
  Value<int> id,
  required int categoryId,
  required DateTime periodBegins,
  required DateTime periodEnds,
  required EstimationDisplayOption displayOption,
  required int currencyId,
  required DateTime createdAt,
  required DateTime updatedAt,
});
typedef $EstimationSchemesUpdateCompanionBuilder = EstimationSchemesCompanion
    Function({
  Value<int> id,
  Value<int> categoryId,
  Value<DateTime> periodBegins,
  Value<DateTime> periodEnds,
  Value<EstimationDisplayOption> displayOption,
  Value<int> currencyId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $EstimationSchemesReferences
    extends BaseReferences<_$AppDatabase, EstimationSchemes, EstimationScheme> {
  $EstimationSchemesReferences(super.$_db, super.$_table, super.$_typedResult);

  static Categories _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias($_aliasNameGenerator(
          db.estimationSchemes.categoryId, db.categories.id));

  $CategoriesProcessedTableManager get categoryId {
    final $_column = $_itemColumn<int>('_categoryId')!;

    final manager = $CategoriesTableManager($_db, $_db.categories)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static Currencies _currencyIdTable(_$AppDatabase db) =>
      db.currencies.createAlias($_aliasNameGenerator(
          db.estimationSchemes.currencyId, db.currencies.id));

  $CurrenciesProcessedTableManager get currencyId {
    final $_column = $_itemColumn<int>('_currencyId')!;

    final manager = $CurrenciesTableManager($_db, $_db.currencies)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_currencyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $EstimationSchemesFilterComposer
    extends Composer<_$AppDatabase, EstimationSchemes> {
  $EstimationSchemesFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get periodBegins => $composableBuilder(
      column: $table.periodBegins, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get periodEnds => $composableBuilder(
      column: $table.periodEnds, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<EstimationDisplayOption,
          EstimationDisplayOption, int>
      get displayOption => $composableBuilder(
          column: $table.displayOption,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $CategoriesFilterComposer get categoryId {
    final $CategoriesFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $CategoriesFilterComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $CurrenciesFilterComposer get currencyId {
    final $CurrenciesFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.currencyId,
        referencedTable: $db.currencies,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $CurrenciesFilterComposer(
              $db: $db,
              $table: $db.currencies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $EstimationSchemesOrderingComposer
    extends Composer<_$AppDatabase, EstimationSchemes> {
  $EstimationSchemesOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get periodBegins => $composableBuilder(
      column: $table.periodBegins,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get periodEnds => $composableBuilder(
      column: $table.periodEnds, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get displayOption => $composableBuilder(
      column: $table.displayOption,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $CategoriesOrderingComposer get categoryId {
    final $CategoriesOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $CategoriesOrderingComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $CurrenciesOrderingComposer get currencyId {
    final $CurrenciesOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.currencyId,
        referencedTable: $db.currencies,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $CurrenciesOrderingComposer(
              $db: $db,
              $table: $db.currencies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $EstimationSchemesAnnotationComposer
    extends Composer<_$AppDatabase, EstimationSchemes> {
  $EstimationSchemesAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get periodBegins => $composableBuilder(
      column: $table.periodBegins, builder: (column) => column);

  GeneratedColumn<DateTime> get periodEnds => $composableBuilder(
      column: $table.periodEnds, builder: (column) => column);

  GeneratedColumnWithTypeConverter<EstimationDisplayOption, int>
      get displayOption => $composableBuilder(
          column: $table.displayOption, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $CategoriesAnnotationComposer get categoryId {
    final $CategoriesAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $CategoriesAnnotationComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $CurrenciesAnnotationComposer get currencyId {
    final $CurrenciesAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.currencyId,
        referencedTable: $db.currencies,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $CurrenciesAnnotationComposer(
              $db: $db,
              $table: $db.currencies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $EstimationSchemesTableManager extends RootTableManager<
    _$AppDatabase,
    EstimationSchemes,
    EstimationScheme,
    $EstimationSchemesFilterComposer,
    $EstimationSchemesOrderingComposer,
    $EstimationSchemesAnnotationComposer,
    $EstimationSchemesCreateCompanionBuilder,
    $EstimationSchemesUpdateCompanionBuilder,
    (EstimationScheme, $EstimationSchemesReferences),
    EstimationScheme,
    PrefetchHooks Function({bool categoryId, bool currencyId})> {
  $EstimationSchemesTableManager(_$AppDatabase db, EstimationSchemes table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $EstimationSchemesFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $EstimationSchemesOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $EstimationSchemesAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> categoryId = const Value.absent(),
            Value<DateTime> periodBegins = const Value.absent(),
            Value<DateTime> periodEnds = const Value.absent(),
            Value<EstimationDisplayOption> displayOption = const Value.absent(),
            Value<int> currencyId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              EstimationSchemesCompanion(
            id: id,
            categoryId: categoryId,
            periodBegins: periodBegins,
            periodEnds: periodEnds,
            displayOption: displayOption,
            currencyId: currencyId,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int categoryId,
            required DateTime periodBegins,
            required DateTime periodEnds,
            required EstimationDisplayOption displayOption,
            required int currencyId,
            required DateTime createdAt,
            required DateTime updatedAt,
          }) =>
              EstimationSchemesCompanion.insert(
            id: id,
            categoryId: categoryId,
            periodBegins: periodBegins,
            periodEnds: periodEnds,
            displayOption: displayOption,
            currencyId: currencyId,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $EstimationSchemesReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({categoryId = false, currencyId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (categoryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.categoryId,
                    referencedTable:
                        $EstimationSchemesReferences._categoryIdTable(db),
                    referencedColumn:
                        $EstimationSchemesReferences._categoryIdTable(db).id,
                  ) as T;
                }
                if (currencyId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.currencyId,
                    referencedTable:
                        $EstimationSchemesReferences._currencyIdTable(db),
                    referencedColumn:
                        $EstimationSchemesReferences._currencyIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $EstimationSchemesProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    EstimationSchemes,
    EstimationScheme,
    $EstimationSchemesFilterComposer,
    $EstimationSchemesOrderingComposer,
    $EstimationSchemesAnnotationComposer,
    $EstimationSchemesCreateCompanionBuilder,
    $EstimationSchemesUpdateCompanionBuilder,
    (EstimationScheme, $EstimationSchemesReferences),
    EstimationScheme,
    PrefetchHooks Function({bool categoryId, bool currencyId})>;
typedef $MonitorSchemesCreateCompanionBuilder = MonitorSchemesCompanion
    Function({
  Value<int> id,
  required DateTime periodBegins,
  required DateTime periodEnds,
  required MonitorDisplayOption displayOption,
  required int currencyId,
  required DateTime createdAt,
  required DateTime updatedAt,
});
typedef $MonitorSchemesUpdateCompanionBuilder = MonitorSchemesCompanion
    Function({
  Value<int> id,
  Value<DateTime> periodBegins,
  Value<DateTime> periodEnds,
  Value<MonitorDisplayOption> displayOption,
  Value<int> currencyId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $MonitorSchemesReferences
    extends BaseReferences<_$AppDatabase, MonitorSchemes, MonitorScheme> {
  $MonitorSchemesReferences(super.$_db, super.$_table, super.$_typedResult);

  static Currencies _currencyIdTable(_$AppDatabase db) =>
      db.currencies.createAlias(
          $_aliasNameGenerator(db.monitorSchemes.currencyId, db.currencies.id));

  $CurrenciesProcessedTableManager get currencyId {
    final $_column = $_itemColumn<int>('_currencyId')!;

    final manager = $CurrenciesTableManager($_db, $_db.currencies)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_currencyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<MonitorSchemeCategoryLinkers,
      List<MonitorSchemeCategoryLinker>> _monitorSchemeCategoryLinkersRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.monitorSchemeCategoryLinkers,
          aliasName: $_aliasNameGenerator(
              db.monitorSchemes.id, db.monitorSchemeCategoryLinkers.scheme));

  $MonitorSchemeCategoryLinkersProcessedTableManager
      get monitorSchemeCategoryLinkersRefs {
    final manager = $MonitorSchemeCategoryLinkersTableManager(
            $_db, $_db.monitorSchemeCategoryLinkers)
        .filter((f) => f.scheme.id.sqlEquals($_itemColumn<int>('_id')!));

    final cache = $_typedResult
        .readTableOrNull(_monitorSchemeCategoryLinkersRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $MonitorSchemesFilterComposer
    extends Composer<_$AppDatabase, MonitorSchemes> {
  $MonitorSchemesFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get periodBegins => $composableBuilder(
      column: $table.periodBegins, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get periodEnds => $composableBuilder(
      column: $table.periodEnds, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<MonitorDisplayOption, MonitorDisplayOption,
          int>
      get displayOption => $composableBuilder(
          column: $table.displayOption,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $CurrenciesFilterComposer get currencyId {
    final $CurrenciesFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.currencyId,
        referencedTable: $db.currencies,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $CurrenciesFilterComposer(
              $db: $db,
              $table: $db.currencies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> monitorSchemeCategoryLinkersRefs(
      Expression<bool> Function($MonitorSchemeCategoryLinkersFilterComposer f)
          f) {
    final $MonitorSchemeCategoryLinkersFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.monitorSchemeCategoryLinkers,
            getReferencedColumn: (t) => t.scheme,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $MonitorSchemeCategoryLinkersFilterComposer(
                  $db: $db,
                  $table: $db.monitorSchemeCategoryLinkers,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $MonitorSchemesOrderingComposer
    extends Composer<_$AppDatabase, MonitorSchemes> {
  $MonitorSchemesOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get periodBegins => $composableBuilder(
      column: $table.periodBegins,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get periodEnds => $composableBuilder(
      column: $table.periodEnds, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get displayOption => $composableBuilder(
      column: $table.displayOption,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $CurrenciesOrderingComposer get currencyId {
    final $CurrenciesOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.currencyId,
        referencedTable: $db.currencies,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $CurrenciesOrderingComposer(
              $db: $db,
              $table: $db.currencies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $MonitorSchemesAnnotationComposer
    extends Composer<_$AppDatabase, MonitorSchemes> {
  $MonitorSchemesAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get periodBegins => $composableBuilder(
      column: $table.periodBegins, builder: (column) => column);

  GeneratedColumn<DateTime> get periodEnds => $composableBuilder(
      column: $table.periodEnds, builder: (column) => column);

  GeneratedColumnWithTypeConverter<MonitorDisplayOption, int>
      get displayOption => $composableBuilder(
          column: $table.displayOption, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $CurrenciesAnnotationComposer get currencyId {
    final $CurrenciesAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.currencyId,
        referencedTable: $db.currencies,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $CurrenciesAnnotationComposer(
              $db: $db,
              $table: $db.currencies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> monitorSchemeCategoryLinkersRefs<T extends Object>(
      Expression<T> Function($MonitorSchemeCategoryLinkersAnnotationComposer a)
          f) {
    final $MonitorSchemeCategoryLinkersAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.monitorSchemeCategoryLinkers,
            getReferencedColumn: (t) => t.scheme,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $MonitorSchemeCategoryLinkersAnnotationComposer(
                  $db: $db,
                  $table: $db.monitorSchemeCategoryLinkers,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $MonitorSchemesTableManager extends RootTableManager<
    _$AppDatabase,
    MonitorSchemes,
    MonitorScheme,
    $MonitorSchemesFilterComposer,
    $MonitorSchemesOrderingComposer,
    $MonitorSchemesAnnotationComposer,
    $MonitorSchemesCreateCompanionBuilder,
    $MonitorSchemesUpdateCompanionBuilder,
    (MonitorScheme, $MonitorSchemesReferences),
    MonitorScheme,
    PrefetchHooks Function(
        {bool currencyId, bool monitorSchemeCategoryLinkersRefs})> {
  $MonitorSchemesTableManager(_$AppDatabase db, MonitorSchemes table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $MonitorSchemesFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $MonitorSchemesOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $MonitorSchemesAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> periodBegins = const Value.absent(),
            Value<DateTime> periodEnds = const Value.absent(),
            Value<MonitorDisplayOption> displayOption = const Value.absent(),
            Value<int> currencyId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              MonitorSchemesCompanion(
            id: id,
            periodBegins: periodBegins,
            periodEnds: periodEnds,
            displayOption: displayOption,
            currencyId: currencyId,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required DateTime periodBegins,
            required DateTime periodEnds,
            required MonitorDisplayOption displayOption,
            required int currencyId,
            required DateTime createdAt,
            required DateTime updatedAt,
          }) =>
              MonitorSchemesCompanion.insert(
            id: id,
            periodBegins: periodBegins,
            periodEnds: periodEnds,
            displayOption: displayOption,
            currencyId: currencyId,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $MonitorSchemesReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {currencyId = false, monitorSchemeCategoryLinkersRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (monitorSchemeCategoryLinkersRefs)
                  db.monitorSchemeCategoryLinkers
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (currencyId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.currencyId,
                    referencedTable:
                        $MonitorSchemesReferences._currencyIdTable(db),
                    referencedColumn:
                        $MonitorSchemesReferences._currencyIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (monitorSchemeCategoryLinkersRefs)
                    await $_getPrefetchedData<MonitorScheme, MonitorSchemes,
                            MonitorSchemeCategoryLinker>(
                        currentTable: table,
                        referencedTable: $MonitorSchemesReferences
                            ._monitorSchemeCategoryLinkersRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $MonitorSchemesReferences(db, table, p0)
                                .monitorSchemeCategoryLinkersRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.scheme == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $MonitorSchemesProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    MonitorSchemes,
    MonitorScheme,
    $MonitorSchemesFilterComposer,
    $MonitorSchemesOrderingComposer,
    $MonitorSchemesAnnotationComposer,
    $MonitorSchemesCreateCompanionBuilder,
    $MonitorSchemesUpdateCompanionBuilder,
    (MonitorScheme, $MonitorSchemesReferences),
    MonitorScheme,
    PrefetchHooks Function(
        {bool currencyId, bool monitorSchemeCategoryLinkersRefs})>;
typedef $MonitorSchemeCategoryLinkersCreateCompanionBuilder
    = MonitorSchemeCategoryLinkersCompanion Function({
  required int scheme,
  required int category,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $MonitorSchemeCategoryLinkersUpdateCompanionBuilder
    = MonitorSchemeCategoryLinkersCompanion Function({
  Value<int> scheme,
  Value<int> category,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $MonitorSchemeCategoryLinkersReferences extends BaseReferences<
    _$AppDatabase, MonitorSchemeCategoryLinkers, MonitorSchemeCategoryLinker> {
  $MonitorSchemeCategoryLinkersReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MonitorSchemes _schemeTable(_$AppDatabase db) =>
      db.monitorSchemes.createAlias($_aliasNameGenerator(
          db.monitorSchemeCategoryLinkers.scheme, db.monitorSchemes.id));

  $MonitorSchemesProcessedTableManager get scheme {
    final $_column = $_itemColumn<int>('_scheme')!;

    final manager = $MonitorSchemesTableManager($_db, $_db.monitorSchemes)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_schemeTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static Categories _categoryTable(_$AppDatabase db) =>
      db.categories.createAlias($_aliasNameGenerator(
          db.monitorSchemeCategoryLinkers.category, db.categories.id));

  $CategoriesProcessedTableManager get category {
    final $_column = $_itemColumn<int>('_category')!;

    final manager = $CategoriesTableManager($_db, $_db.categories)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $MonitorSchemeCategoryLinkersFilterComposer
    extends Composer<_$AppDatabase, MonitorSchemeCategoryLinkers> {
  $MonitorSchemeCategoryLinkersFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $MonitorSchemesFilterComposer get scheme {
    final $MonitorSchemesFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.scheme,
        referencedTable: $db.monitorSchemes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $MonitorSchemesFilterComposer(
              $db: $db,
              $table: $db.monitorSchemes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $CategoriesFilterComposer get category {
    final $CategoriesFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.category,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $CategoriesFilterComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $MonitorSchemeCategoryLinkersOrderingComposer
    extends Composer<_$AppDatabase, MonitorSchemeCategoryLinkers> {
  $MonitorSchemeCategoryLinkersOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $MonitorSchemesOrderingComposer get scheme {
    final $MonitorSchemesOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.scheme,
        referencedTable: $db.monitorSchemes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $MonitorSchemesOrderingComposer(
              $db: $db,
              $table: $db.monitorSchemes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $CategoriesOrderingComposer get category {
    final $CategoriesOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.category,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $CategoriesOrderingComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $MonitorSchemeCategoryLinkersAnnotationComposer
    extends Composer<_$AppDatabase, MonitorSchemeCategoryLinkers> {
  $MonitorSchemeCategoryLinkersAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $MonitorSchemesAnnotationComposer get scheme {
    final $MonitorSchemesAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.scheme,
        referencedTable: $db.monitorSchemes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $MonitorSchemesAnnotationComposer(
              $db: $db,
              $table: $db.monitorSchemes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $CategoriesAnnotationComposer get category {
    final $CategoriesAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.category,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $CategoriesAnnotationComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $MonitorSchemeCategoryLinkersTableManager extends RootTableManager<
    _$AppDatabase,
    MonitorSchemeCategoryLinkers,
    MonitorSchemeCategoryLinker,
    $MonitorSchemeCategoryLinkersFilterComposer,
    $MonitorSchemeCategoryLinkersOrderingComposer,
    $MonitorSchemeCategoryLinkersAnnotationComposer,
    $MonitorSchemeCategoryLinkersCreateCompanionBuilder,
    $MonitorSchemeCategoryLinkersUpdateCompanionBuilder,
    (MonitorSchemeCategoryLinker, $MonitorSchemeCategoryLinkersReferences),
    MonitorSchemeCategoryLinker,
    PrefetchHooks Function({bool scheme, bool category})> {
  $MonitorSchemeCategoryLinkersTableManager(
      _$AppDatabase db, MonitorSchemeCategoryLinkers table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $MonitorSchemeCategoryLinkersFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $MonitorSchemeCategoryLinkersOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $MonitorSchemeCategoryLinkersAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> scheme = const Value.absent(),
            Value<int> category = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MonitorSchemeCategoryLinkersCompanion(
            scheme: scheme,
            category: category,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int scheme,
            required int category,
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              MonitorSchemeCategoryLinkersCompanion.insert(
            scheme: scheme,
            category: category,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $MonitorSchemeCategoryLinkersReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({scheme = false, category = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (scheme) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.scheme,
                    referencedTable: $MonitorSchemeCategoryLinkersReferences
                        ._schemeTable(db),
                    referencedColumn: $MonitorSchemeCategoryLinkersReferences
                        ._schemeTable(db)
                        .id,
                  ) as T;
                }
                if (category) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.category,
                    referencedTable: $MonitorSchemeCategoryLinkersReferences
                        ._categoryTable(db),
                    referencedColumn: $MonitorSchemeCategoryLinkersReferences
                        ._categoryTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $MonitorSchemeCategoryLinkersProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        MonitorSchemeCategoryLinkers,
        MonitorSchemeCategoryLinker,
        $MonitorSchemeCategoryLinkersFilterComposer,
        $MonitorSchemeCategoryLinkersOrderingComposer,
        $MonitorSchemeCategoryLinkersAnnotationComposer,
        $MonitorSchemeCategoryLinkersCreateCompanionBuilder,
        $MonitorSchemeCategoryLinkersUpdateCompanionBuilder,
        (MonitorSchemeCategoryLinker, $MonitorSchemeCategoryLinkersReferences),
        MonitorSchemeCategoryLinker,
        PrefetchHooks Function({bool scheme, bool category})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $CategoriesTableManager get categories =>
      $CategoriesTableManager(_db, _db.categories);
  $CurrenciesTableManager get currencies =>
      $CurrenciesTableManager(_db, _db.currencies);
  $ReceiptLogsTableManager get receiptLogs =>
      $ReceiptLogsTableManager(_db, _db.receiptLogs);
  $OneshotPlansTableManager get oneshotPlans =>
      $OneshotPlansTableManager(_db, _db.oneshotPlans);
  $IntervalPlansTableManager get intervalPlans =>
      $IntervalPlansTableManager(_db, _db.intervalPlans);
  $WeeklyPlansTableManager get weeklyPlans =>
      $WeeklyPlansTableManager(_db, _db.weeklyPlans);
  $MonthlyPlansTableManager get monthlyPlans =>
      $MonthlyPlansTableManager(_db, _db.monthlyPlans);
  $AnnualPlansTableManager get annualPlans =>
      $AnnualPlansTableManager(_db, _db.annualPlans);
  $EstimationSchemesTableManager get estimationSchemes =>
      $EstimationSchemesTableManager(_db, _db.estimationSchemes);
  $MonitorSchemesTableManager get monitorSchemes =>
      $MonitorSchemesTableManager(_db, _db.monitorSchemes);
  $MonitorSchemeCategoryLinkersTableManager get monitorSchemeCategoryLinkers =>
      $MonitorSchemeCategoryLinkersTableManager(
          _db, _db.monitorSchemeCategoryLinkers);
}
