import 'package:ayo/dataprovider/data_provider.dart';
import 'package:ayo/dependency/dependency.dart';
import 'package:ayo/model/query/query.dart';
import 'package:ayo/moor/db.dart';
import 'package:flutter/material.dart';

class Repository {
  final Dependency dependency;
  DataProvider providers;

  Repository(this.dependency) {
    providers = DataProvider(dependency);
  }

  Future<UserData> validateUser() async {
    return await providers.validateUser();
  }

  Future<dynamic> fetchGuestUser() async {
    return await providers.fetchGuestUser();
  }

  Future insertUser(UserData userData) async {
    await providers.insertUser(userData);
  }

  Future<dynamic> downloadIntroData(UserData user) async {
    return await providers.downloadIntroData(user);
  }

  Future<dynamic> insertIntroData(IntroData introData) async {
    return await providers.insertIntroData(introData);
  }

  Future<dynamic> fetchBanner(
      {@required String target, @required UserData user}) async {
    return await providers.fetchBanner(target: target, user: user);
  }

  Future<dynamic> fetchMainCategory({@required UserData user}) async {
    return await providers.fetchMainCategory(user: user);
  }

  Future<dynamic> fetchProductTerlarisKategori(
      {@required UserData user, @required Query query}) async {
    return await providers.fetchProduct(user: user, query: query);
  }
}
