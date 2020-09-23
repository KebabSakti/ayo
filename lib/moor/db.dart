import 'package:moor_flutter/moor_flutter.dart';

part 'db.g.dart';

@DataClassName('UserData')
class User extends Table {
  TextColumn get id => text()();
  TextColumn get token => text()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('IntroData')
class Intro extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().nullable()();
  TextColumn get url => text()();
  TextColumn get path => text().nullable()();
  TextColumn get title => text().nullable()();
  TextColumn get caption => text().nullable()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@UseMoor(tables: [User, Intro], daos: [UserDao, IntroDao])
class DB extends _$DB {
  // we tell the database where to store the data with this constructor
  DB()
      : super((FlutterQueryExecutor.inDatabaseFolder(
          path: 'ayo.sqlite',
          // Good for debugging - prints SQL in the console
          logStatements: true,
        )));

  @override
  int get schemaVersion => 1;
}

@UseDao(tables: [User])
class UserDao extends DatabaseAccessor<DB> with _$UserDaoMixin {
  final DB db;
  UserDao(this.db) : super(db);

  Future<UserData> fetchUser() => select(user).getSingle();
  Future insertUser(Insertable<UserData> userData) =>
      into(user).insert(userData);
  Future updateUser(Insertable<UserData> userData) =>
      update(user).replace(userData);
}

@UseDao(tables: [Intro])
class IntroDao extends DatabaseAccessor<DB> with _$IntroDaoMixin {
  final DB db;
  IntroDao(this.db) : super(db);

  Future<List<IntroData>> fetchIntro(String userId) =>
      (select(intro)..where((tbl) => tbl.userId.equals(userId))).get();
  Future insertIntro(Insertable<IntroData> introData) =>
      into(intro).insert(introData);
}
