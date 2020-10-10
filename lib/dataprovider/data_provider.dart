import 'dart:convert';

import 'package:ayo/model/banner/slide_banner.dart';
import 'package:ayo/model/cart/cart.dart';
import 'package:ayo/model/main_category/main_category_model.dart';
import 'package:ayo/model/pagination/pagination.dart';
import 'package:ayo/model/product/product.dart';
import 'package:ayo/model/product/product_paginate.dart';
import 'package:ayo/model/query/query.dart';
import 'package:ayo/model/sub_category/sub_category.dart';
import 'package:ayo/moor/db.dart';
import 'package:ayo/provider/provider.dart';
import 'package:ayo/util/helper.dart';
import 'package:dio/dio.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:path_provider/path_provider.dart';

class DataProvider {
  final DB db = locator<DB>();
  final DioInstance dioInstance = locator<DioInstance>();

  Future<UserData> validateUser() async {
    var user = await db.userDao.fetchUser();
    if (user != null) {
      return user;
    } else {
      return null;
    }
  }

  Future<dynamic> fetchGuestUser() async {
    try {
      var response = await dioInstance.dio.get("auth/customer/guest_access/",
          options: Options(headers: {
            "Accept": "application/json",
          }));
      var parsed = await jsonDecode(response.toString());
      var user = UserData(
        id: parsed['user_id'],
        token: parsed['token'],
        createdAt: parsed['created_at'],
        updatedAt: parsed['updated_at'],
      );

      return user;
    } on DioError catch (error) {
      return error;
    }
  }

  Future insertUser(UserData userData) async {
    await db.userDao.insertUser(UserCompanion.insert(
      id: userData.id,
      token: userData.token,
      createdAt: userData.createdAt,
      updatedAt: userData.updatedAt,
    ));
  }

  Future<dynamic> downloadIntroData(UserData user) async {
    try {
      List<IntroData> intros = await db.introDao.fetchIntro(user.id);

      var response = await dioInstance.dio.post("intro_slider",
          options: Options(headers: {
            "Accept": "application/json",
            "Authorization": "Bearer ${user.token}",
            "User-Id": user.id,
          }),
          data: FormData.fromMap({
            "items": intros.map((item) => {"intro_id": item.id}).toList(),
          }));

      var parsed = await response.data;

      List<IntroData> data = [];
      if (parsed.length > 0) {
        for (var item in parsed) {
          var path = (await getTemporaryDirectory()).path + "${Helper().generateRandomId()}.jpg";

          IntroData intro = IntroData(
            id: item['intro_id'],
            userId: user.id,
            url: item['url'],
            path: path,
            title: item['title'],
            caption: item['caption'],
            createdAt: item['created_at'],
            updatedAt: item['updated_at'],
          );

          await insertIntroData(intro, path: path);
          data.add(intro);
        }
      }

      return data;
    } on DioError catch (error) {
      return error;
    }
  }

  Future<dynamic> insertIntroData(IntroData introData, {String path}) async {
    try {
      //download image
      await dioInstance.dio.download(introData.url, path);

      //insert to local database
      await db.introDao.insertIntro(IntroCompanion.insert(
        id: introData.id,
        userId: Value(introData.userId),
        url: introData.url,
        path: Value(path),
        title: Value(introData.title),
        caption: Value(introData.caption),
        createdAt: introData.createdAt,
        updatedAt: introData.updatedAt,
      ));

      return true;
    } on DioError catch (error) {
      return error;
    }
  }

  Future<dynamic> fetchBanner({@required String target, String id, @required UserData user}) async {
    try {
      var response = await dioInstance.dio.post("banner_slide",
          options: Options(headers: {
            "Accept": "application/json",
            "Authorization": "Bearer ${user.token}",
            "User-Id": user.id,
          }),
          data: {
            'target': target,
            'id': id,
          });

      List<dynamic> parsed = await response.data;

      List<SlideBanner> banners = List<SlideBanner>.from(parsed.map((item) => SlideBanner.fromJson(item)).toList());

      return banners;
    } on DioError catch (error) {
      return error;
    }
  }

  Future<dynamic> fetchMainCategory({@required UserData user}) async {
    try {
      var response = await dioInstance.dio.get("main_category",
          options: Options(headers: {
            "Accept": "application/json",
            "Authorization": "Bearer ${user.token}",
            "User-Id": user.id,
          }));
      List<dynamic> parsed = await response.data;
      List<MainCategoryModel> mainCategories = [];
      parsed.forEach((item) async {
        mainCategories.add(MainCategoryModel.fromJson(item));
      });

      return mainCategories;
    } on DioError catch (error) {
      return error;
    }
  }

  Future<dynamic> fetchProduct({
    @required UserData user,
    @required QueryModel query,
    int page,
  }) async {
    try {
      var response = await dioInstance.dio.post(
        "product?page=${page ?? 1}",
        options: Options(headers: {
          "Accept": "application/json",
          "Authorization": "Bearer ${user.token}",
          "User-Id": user.id,
        }),
        data: {
          'sub_category_id': query.filter.subCategoryId,
          'main_category_id': query.filter.mainCategoryId,
          'keyword': query.filter.keyword,
          'terlaris': query.filter.terlaris,
          'diskon': query.filter.diskon,
          'search': query.filter.search,
          'view': query.filter.view,
          'rating': query.filter.rating,
          'pengiriman': query.filter.pengiriman,
          'harga_min': query.filter.hargaMin,
          'harga_max': query.filter.hargaMax,
          'sorting': query.sorting.sorting,
        },
      );

      var parsed = json.decode(response.toString());
      var pagination = Pagination.fromJson(parsed);
      List<Product> products = List<Product>.from(parsed['data'].map((item) => Product.fromJson(item)).toList());

      return ProductPaginate(pagination: pagination, products: products);
    } on DioError catch (error) {
      return error;
    }
  }

  Future<dynamic> fetchProductDetail({
    @required UserData user,
    @required String productId,
  }) async {
    try {
      var response = await dioInstance.dio.post(
        "product/detail",
        options: Options(headers: {
          "Accept": "application/json",
          "Authorization": "Bearer ${user.token}",
          "User-Id": user.id,
        }),
        data: {'product_id': productId},
      );

      var parsed = json.decode(response.toString());
      var data = Product.fromJson(parsed);

      return data;
    } on DioError catch (error) {
      return error;
    }
  }

  Future<dynamic> fetchSubCategory({@required UserData user, @required String mainCategoryId}) async {
    try {
      var response = await dioInstance.dio.get("sub_category/id/$mainCategoryId",
          options: Options(headers: {
            "Accept": "application/json",
            "Authorization": "Bearer ${user.token}",
            "User-Id": user.id,
          }));

      List<dynamic> parsed = await response.data;
      List<SubCategory> datas = List<SubCategory>.from(parsed.map((item) => SubCategory.fromJson(item)).toList());

      return datas;
    } on DioError catch (error) {
      return error;
    }
  }

  Future<dynamic> fetchCart({@required UserData user}) async {
    try {
      var response = await dioInstance.dio.get("cart",
          options: Options(headers: {
            "Accept": "application/json",
            "Authorization": "Bearer ${user.token}",
            "User-Id": user.id,
          }));

      List<dynamic> parsed = await response.data;
      List<Cart> datas = List<Cart>.from(parsed.map((item) => Cart.fromJson(item)).toList());

      return datas;
    } on DioError catch (error) {
      return error;
    }
  }

  Future<dynamic> addCart({@required UserData user, @required Cart cartData}) async {
    try {
      var response = await dioInstance.dio.post("cart",
          options: Options(headers: {
            "Accept": "application/json",
            "Authorization": "Bearer ${user.token}",
            "User-Id": user.id,
          }),
          data: {
            'product_id': cartData.productId,
            'price': cartData.price,
          });

      List<dynamic> parsed = await response.data;
      List<Cart> datas = List<Cart>.from(parsed.map((item) => Cart.fromJson(item)).toList());

      return datas;
    } on DioError catch (error) {
      return error;
    }
  }

  Future<dynamic> removeCart({@required UserData user, @required String productId}) async {
    try {
      var response = await dioInstance.dio.delete(
        "cart/$productId/delete",
        options: Options(headers: {
          "Accept": "application/json",
          "Authorization": "Bearer ${user.token}",
          "User-Id": user.id,
        }),
      );

      List<dynamic> parsed = await response.data;
      List<Cart> datas = List<Cart>.from(parsed.map((item) => Cart.fromJson(item)).toList());

      return datas;
    } on DioError catch (error) {
      return error;
    }
  }

  Future<dynamic> uploadCart({@required UserData user, @required List<Cart> carts}) async {
    try {
      var response = await dioInstance.dio.post(
        "cart/update",
        options: Options(headers: {
          "Accept": "application/json",
          "Authorization": "Bearer ${user.token}",
          "User-Id": user.id,
        }),
        data: FormData.fromMap({
          "item": carts
              .map((e) => {
                    'cart_id': e.cartId,
                    'user_id': e.userId,
                    'product_id': e.product.productId,
                    'checked': e.checked,
                    'price': e.price,
                    'qty': e.qty,
                    'total': e.total,
                  })
              .toList(),
        }),
      );

      List<dynamic> parsed = await response.data;
      List<Cart> datas = List<Cart>.from(parsed.map((item) => Cart.fromJson(item)).toList());

      return datas;
    } on DioError catch (error) {
      return error;
    }
  }
}
