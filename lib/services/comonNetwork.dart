
import 'package:dio/dio.dart';

Dio getKucoinDio() {
  BaseOptions options = new BaseOptions(
    baseUrl: "https://api.kucoin.com/api/v1/",
    connectTimeout: 15000,
    receiveTimeout: 10000,
  );
  Dio dio = new Dio(options);
  return dio;
}
Dio getCoinGeckoDio() {
  BaseOptions options = new BaseOptions(
    baseUrl: "https://api.coingecko.com/api/v3/",
    connectTimeout: 15000,
    receiveTimeout: 10000,
  );
  Dio dio = new Dio(options);
  return dio;
}