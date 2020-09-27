import 'package:ayo/moor/db.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:location/location.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  //moor db
  locator.registerSingleton(DB());

  //location object
  locator.registerSingleton(Location());

  //dio
  locator.registerSingleton(DioInstance());

  //repository
  // locator.registerSingleton(Repository());
}

class DioInstance {
  Dio dio;
  BaseOptions baseOptions;

  DioInstance({this.baseOptions}) {
    var option = baseOptions ??
        BaseOptions(
          baseUrl: 'https://b05c45fcf5b7.ngrok.io/api/',
          connectTimeout: 30000,
          receiveTimeout: 30000,
        );

    this.dio = Dio(option);
  }

  Dio copyWith({BaseOptions baseOptions}) {
    return Dio(baseOptions);
  }
}
