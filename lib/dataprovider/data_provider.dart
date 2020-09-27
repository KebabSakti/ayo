import 'dart:convert';

import 'package:ayo/model/banner/slide_banner.dart';
import 'package:ayo/model/main_category/main_category_model.dart';
import 'package:ayo/model/pagination/pagination.dart';
import 'package:ayo/model/product/product.dart';
import 'package:ayo/model/product/product_paginate.dart';
import 'package:ayo/model/query/query.dart' as model;
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
          var path = (await getTemporaryDirectory()).path +
              "${Helper().generateRandomId()}.jpg";

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

  Future<dynamic> fetchBanner(
      {@required String target, @required UserData user}) async {
    try {
      var response = await dioInstance.dio.get("banner_slide/target/$target",
          options: Options(headers: {
            "Accept": "application/json",
            "Authorization": "Bearer ${user.token}",
            "User-Id": user.id,
          }));
      List<dynamic> parsed = await response.data;
      List<SlideBanner> banners = [];
      parsed.forEach((item) async {
        banners.add(SlideBanner.fromJson(item));
      });

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

  Future<dynamic> fetchProduct(
      {@required UserData user, @required model.Query query}) async {
    try {
      var response = await dioInstance.dio.post(
        "product/terbaru",
        options: Options(headers: {
          "Accept": "application/json",
          "Authorization": "Bearer ${user.token}",
          "User-Id": user.id,
        }),
        data: {
          'keyword': query.keyword,
          'kategori_id': query.filter.kategoriId,
          'price_min': query.filter.priceMin,
          'price_max': query.filter.priceMax,
          'instant': query.filter.instant,
          'rating': query.filter.rating,
          'price': query.sorting.price,
          'date': query.sorting.date,
        },
      );

      var parsed = json.decode(response.toString());
      var pagination = Pagination.fromJson(parsed);
      List<Product> products = List<Product>.from(
          parsed['data'].map((item) => Product.fromJson(item)).toList());

      return ProductPaginate(pagination: pagination, products: products);
    } on DioError catch (error) {
      return error;
    }
  }
}
