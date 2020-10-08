import 'package:ayo/dataprovider/data_provider.dart';
import 'package:ayo/model/cart/cart.dart';
import 'package:ayo/model/cart/cart_item.dart';
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

  Future<dynamic> fetchBanner({@required String target, String id, @required UserData user}) async {
    return await providers.fetchBanner(target: target, user: user, id: id);
  }

  Future<dynamic> fetchMainCategory({@required UserData user}) async {
    return await providers.fetchMainCategory(user: user);
  }

  Future<dynamic> fetchProduct({@required UserData user, @required QueryModel query, int page}) async {
    return await providers.fetchProduct(user: user, query: query, page: page);
  }

  Future<dynamic> fetchProductDetail({@required UserData user, @required String productId}) async {
    return await providers.fetchProductDetail(user: user, productId: productId);
  }

  Future<dynamic> fetchSubCategory({@required UserData user, @required String mainCategoryId}) async {
    return await providers.fetchSubCategory(user: user, mainCategoryId: mainCategoryId);
  }

  Future<dynamic> fetchCart({@required UserData user}) async {
    return await providers.fetchCart(user: user);
  }

  Future<dynamic> addCart({@required UserData user, @required Cart cartData}) async {
    return await providers.addCart(user: user, cartData: cartData);
  }

  Future<dynamic> removeCart({@required UserData user, @required String productId}) async {
    return await providers.removeCart(user: user, productId: productId);
  }

  Future<dynamic> updateCart({@required UserData user, @required Map<String, CartItemModel> cartItem}) async {
    return await providers.updateCart(user: user, cartItem: cartItem);
  }
}
