import 'package:ayo/dataprovider/data_provider.dart';
import 'package:ayo/model/query/query.dart';
import 'package:ayo/moor/db.dart';
import 'package:ayo/provider/provider.dart';
import 'package:flutter/material.dart';

class Repository {
  final DataProvider providers = locator<DataProvider>();

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
      {@required String target, String id, @required UserData user}) async {
    return await providers.fetchBanner(target: target, user: user, id: id);
  }

  Future<dynamic> fetchMainCategory({@required UserData user}) async {
    return await providers.fetchMainCategory(user: user);
  }

  Future<dynamic> fetchProduct(
      {@required UserData user, @required QueryModel query, int page}) async {
    return await providers.fetchProduct(user: user, query: query, page: page);
  }

  Future<dynamic> fetchSubCategory(
      {@required UserData user, @required String mainCategoryId}) async {
    return await providers.fetchSubCategory(
        user: user, mainCategoryId: mainCategoryId);
  }
}
