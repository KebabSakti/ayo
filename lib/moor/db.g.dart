// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class UserData extends DataClass implements Insertable<UserData> {
  final String id;
  final String token;
  final String createdAt;
  final String updatedAt;
  UserData(
      {@required this.id,
      @required this.token,
      @required this.createdAt,
      @required this.updatedAt});
  factory UserData.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    return UserData(
      id: stringType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      token:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}token']),
      createdAt: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at']),
      updatedAt: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}updated_at']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<String>(id);
    }
    if (!nullToAbsent || token != null) {
      map['token'] = Variable<String>(token);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<String>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<String>(updatedAt);
    }
    return map;
  }

  UserCompanion toCompanion(bool nullToAbsent) {
    return UserCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      token:
          token == null && nullToAbsent ? const Value.absent() : Value(token),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory UserData.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return UserData(
      id: serializer.fromJson<String>(json['id']),
      token: serializer.fromJson<String>(json['token']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'token': serializer.toJson<String>(token),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  UserData copyWith(
          {String id, String token, String createdAt, String updatedAt}) =>
      UserData(
        id: id ?? this.id,
        token: token ?? this.token,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('UserData(')
          ..write('id: $id, ')
          ..write('token: $token, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode,
      $mrjc(token.hashCode, $mrjc(createdAt.hashCode, updatedAt.hashCode))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is UserData &&
          other.id == this.id &&
          other.token == this.token &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UserCompanion extends UpdateCompanion<UserData> {
  final Value<String> id;
  final Value<String> token;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  const UserCompanion({
    this.id = const Value.absent(),
    this.token = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  UserCompanion.insert({
    @required String id,
    @required String token,
    @required String createdAt,
    @required String updatedAt,
  })  : id = Value(id),
        token = Value(token),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<UserData> custom({
    Expression<String> id,
    Expression<String> token,
    Expression<String> createdAt,
    Expression<String> updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (token != null) 'token': token,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  UserCompanion copyWith(
      {Value<String> id,
      Value<String> token,
      Value<String> createdAt,
      Value<String> updatedAt}) {
    return UserCompanion(
      id: id ?? this.id,
      token: token ?? this.token,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (token.present) {
      map['token'] = Variable<String>(token.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserCompanion(')
          ..write('id: $id, ')
          ..write('token: $token, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $UserTable extends User with TableInfo<$UserTable, UserData> {
  final GeneratedDatabase _db;
  final String _alias;
  $UserTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedTextColumn _id;
  @override
  GeneratedTextColumn get id => _id ??= _constructId();
  GeneratedTextColumn _constructId() {
    return GeneratedTextColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _tokenMeta = const VerificationMeta('token');
  GeneratedTextColumn _token;
  @override
  GeneratedTextColumn get token => _token ??= _constructToken();
  GeneratedTextColumn _constructToken() {
    return GeneratedTextColumn(
      'token',
      $tableName,
      false,
    );
  }

  final VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  GeneratedTextColumn _createdAt;
  @override
  GeneratedTextColumn get createdAt => _createdAt ??= _constructCreatedAt();
  GeneratedTextColumn _constructCreatedAt() {
    return GeneratedTextColumn(
      'created_at',
      $tableName,
      false,
    );
  }

  final VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  GeneratedTextColumn _updatedAt;
  @override
  GeneratedTextColumn get updatedAt => _updatedAt ??= _constructUpdatedAt();
  GeneratedTextColumn _constructUpdatedAt() {
    return GeneratedTextColumn(
      'updated_at',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, token, createdAt, updatedAt];
  @override
  $UserTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'user';
  @override
  final String actualTableName = 'user';
  @override
  VerificationContext validateIntegrity(Insertable<UserData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('token')) {
      context.handle(
          _tokenMeta, token.isAcceptableOrUnknown(data['token'], _tokenMeta));
    } else if (isInserting) {
      context.missing(_tokenMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at'], _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at'], _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserData map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return UserData.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $UserTable createAlias(String alias) {
    return $UserTable(_db, alias);
  }
}

class IntroData extends DataClass implements Insertable<IntroData> {
  final String id;
  final String userId;
  final String url;
  final String path;
  final String title;
  final String caption;
  final String createdAt;
  final String updatedAt;
  IntroData(
      {@required this.id,
      this.userId,
      @required this.url,
      this.path,
      this.title,
      this.caption,
      @required this.createdAt,
      @required this.updatedAt});
  factory IntroData.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    return IntroData(
      id: stringType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      userId:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}user_id']),
      url: stringType.mapFromDatabaseResponse(data['${effectivePrefix}url']),
      path: stringType.mapFromDatabaseResponse(data['${effectivePrefix}path']),
      title:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}title']),
      caption:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}caption']),
      createdAt: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at']),
      updatedAt: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}updated_at']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<String>(id);
    }
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    if (!nullToAbsent || url != null) {
      map['url'] = Variable<String>(url);
    }
    if (!nullToAbsent || path != null) {
      map['path'] = Variable<String>(path);
    }
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || caption != null) {
      map['caption'] = Variable<String>(caption);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<String>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<String>(updatedAt);
    }
    return map;
  }

  IntroCompanion toCompanion(bool nullToAbsent) {
    return IntroCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
      url: url == null && nullToAbsent ? const Value.absent() : Value(url),
      path: path == null && nullToAbsent ? const Value.absent() : Value(path),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
      caption: caption == null && nullToAbsent
          ? const Value.absent()
          : Value(caption),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory IntroData.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return IntroData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      url: serializer.fromJson<String>(json['url']),
      path: serializer.fromJson<String>(json['path']),
      title: serializer.fromJson<String>(json['title']),
      caption: serializer.fromJson<String>(json['caption']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'url': serializer.toJson<String>(url),
      'path': serializer.toJson<String>(path),
      'title': serializer.toJson<String>(title),
      'caption': serializer.toJson<String>(caption),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  IntroData copyWith(
          {String id,
          String userId,
          String url,
          String path,
          String title,
          String caption,
          String createdAt,
          String updatedAt}) =>
      IntroData(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        url: url ?? this.url,
        path: path ?? this.path,
        title: title ?? this.title,
        caption: caption ?? this.caption,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('IntroData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('url: $url, ')
          ..write('path: $path, ')
          ..write('title: $title, ')
          ..write('caption: $caption, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          userId.hashCode,
          $mrjc(
              url.hashCode,
              $mrjc(
                  path.hashCode,
                  $mrjc(
                      title.hashCode,
                      $mrjc(caption.hashCode,
                          $mrjc(createdAt.hashCode, updatedAt.hashCode))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is IntroData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.url == this.url &&
          other.path == this.path &&
          other.title == this.title &&
          other.caption == this.caption &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class IntroCompanion extends UpdateCompanion<IntroData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> url;
  final Value<String> path;
  final Value<String> title;
  final Value<String> caption;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  const IntroCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.url = const Value.absent(),
    this.path = const Value.absent(),
    this.title = const Value.absent(),
    this.caption = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  IntroCompanion.insert({
    @required String id,
    this.userId = const Value.absent(),
    @required String url,
    this.path = const Value.absent(),
    this.title = const Value.absent(),
    this.caption = const Value.absent(),
    @required String createdAt,
    @required String updatedAt,
  })  : id = Value(id),
        url = Value(url),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<IntroData> custom({
    Expression<String> id,
    Expression<String> userId,
    Expression<String> url,
    Expression<String> path,
    Expression<String> title,
    Expression<String> caption,
    Expression<String> createdAt,
    Expression<String> updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (url != null) 'url': url,
      if (path != null) 'path': path,
      if (title != null) 'title': title,
      if (caption != null) 'caption': caption,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  IntroCompanion copyWith(
      {Value<String> id,
      Value<String> userId,
      Value<String> url,
      Value<String> path,
      Value<String> title,
      Value<String> caption,
      Value<String> createdAt,
      Value<String> updatedAt}) {
    return IntroCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      url: url ?? this.url,
      path: path ?? this.path,
      title: title ?? this.title,
      caption: caption ?? this.caption,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (caption.present) {
      map['caption'] = Variable<String>(caption.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IntroCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('url: $url, ')
          ..write('path: $path, ')
          ..write('title: $title, ')
          ..write('caption: $caption, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $IntroTable extends Intro with TableInfo<$IntroTable, IntroData> {
  final GeneratedDatabase _db;
  final String _alias;
  $IntroTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedTextColumn _id;
  @override
  GeneratedTextColumn get id => _id ??= _constructId();
  GeneratedTextColumn _constructId() {
    return GeneratedTextColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _userIdMeta = const VerificationMeta('userId');
  GeneratedTextColumn _userId;
  @override
  GeneratedTextColumn get userId => _userId ??= _constructUserId();
  GeneratedTextColumn _constructUserId() {
    return GeneratedTextColumn(
      'user_id',
      $tableName,
      true,
    );
  }

  final VerificationMeta _urlMeta = const VerificationMeta('url');
  GeneratedTextColumn _url;
  @override
  GeneratedTextColumn get url => _url ??= _constructUrl();
  GeneratedTextColumn _constructUrl() {
    return GeneratedTextColumn(
      'url',
      $tableName,
      false,
    );
  }

  final VerificationMeta _pathMeta = const VerificationMeta('path');
  GeneratedTextColumn _path;
  @override
  GeneratedTextColumn get path => _path ??= _constructPath();
  GeneratedTextColumn _constructPath() {
    return GeneratedTextColumn(
      'path',
      $tableName,
      true,
    );
  }

  final VerificationMeta _titleMeta = const VerificationMeta('title');
  GeneratedTextColumn _title;
  @override
  GeneratedTextColumn get title => _title ??= _constructTitle();
  GeneratedTextColumn _constructTitle() {
    return GeneratedTextColumn(
      'title',
      $tableName,
      true,
    );
  }

  final VerificationMeta _captionMeta = const VerificationMeta('caption');
  GeneratedTextColumn _caption;
  @override
  GeneratedTextColumn get caption => _caption ??= _constructCaption();
  GeneratedTextColumn _constructCaption() {
    return GeneratedTextColumn(
      'caption',
      $tableName,
      true,
    );
  }

  final VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  GeneratedTextColumn _createdAt;
  @override
  GeneratedTextColumn get createdAt => _createdAt ??= _constructCreatedAt();
  GeneratedTextColumn _constructCreatedAt() {
    return GeneratedTextColumn(
      'created_at',
      $tableName,
      false,
    );
  }

  final VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  GeneratedTextColumn _updatedAt;
  @override
  GeneratedTextColumn get updatedAt => _updatedAt ??= _constructUpdatedAt();
  GeneratedTextColumn _constructUpdatedAt() {
    return GeneratedTextColumn(
      'updated_at',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, userId, url, path, title, caption, createdAt, updatedAt];
  @override
  $IntroTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'intro';
  @override
  final String actualTableName = 'intro';
  @override
  VerificationContext validateIntegrity(Insertable<IntroData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id'], _userIdMeta));
    }
    if (data.containsKey('url')) {
      context.handle(
          _urlMeta, url.isAcceptableOrUnknown(data['url'], _urlMeta));
    } else if (isInserting) {
      context.missing(_urlMeta);
    }
    if (data.containsKey('path')) {
      context.handle(
          _pathMeta, path.isAcceptableOrUnknown(data['path'], _pathMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title'], _titleMeta));
    }
    if (data.containsKey('caption')) {
      context.handle(_captionMeta,
          caption.isAcceptableOrUnknown(data['caption'], _captionMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at'], _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at'], _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  IntroData map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return IntroData.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $IntroTable createAlias(String alias) {
    return $IntroTable(_db, alias);
  }
}

abstract class _$DB extends GeneratedDatabase {
  _$DB(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $UserTable _user;
  $UserTable get user => _user ??= $UserTable(this);
  $IntroTable _intro;
  $IntroTable get intro => _intro ??= $IntroTable(this);
  UserDao _userDao;
  UserDao get userDao => _userDao ??= UserDao(this as DB);
  IntroDao _introDao;
  IntroDao get introDao => _introDao ??= IntroDao(this as DB);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [user, intro];
}

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$UserDaoMixin on DatabaseAccessor<DB> {
  $UserTable get user => attachedDatabase.user;
}
mixin _$IntroDaoMixin on DatabaseAccessor<DB> {
  $IntroTable get intro => attachedDatabase.intro;
}
