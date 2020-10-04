import 'package:ayo/constant/constant.dart';
import 'package:ayo/dataprovider/data_provider.dart';
import 'package:ayo/moor/db.dart';
import 'package:ayo/repository/repository.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:location/location.dart';

GetIt locator = GetIt.instance;

void serviceLocator() {
  //moor db
  locator.registerSingleton(DB());

  //location object
  locator.registerSingleton(Location());

  //dio
  locator.registerSingleton(DioInstance());

  //data provider
  locator.registerSingleton(DataProvider());

  //repository
  locator.registerSingleton(Repository());
}

class DioInstance {
  Dio dio;

  DioInstance({BaseOptions baseOptions}) {
    var option = baseOptions ??
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: 30000,
          receiveTimeout: 30000,
        );

    this.dio = Dio(option);

    //add logging
    dio.interceptors.add(LogInterceptor(responseBody: false));
  }

  Dio copyWith({BaseOptions baseOptions}) {
    return Dio(baseOptions);
  }
}