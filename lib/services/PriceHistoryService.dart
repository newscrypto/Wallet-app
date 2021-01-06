import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:newscrypto_wallet/models/Price.dart';
import 'package:newscrypto_wallet/models/Statistics.dart';
import 'package:newscrypto_wallet/services/comonNetwork.dart';

List<PriceHistory> _parsePriceHistory(dynamic data) {
  return data.map<PriceHistory>((m) => new PriceHistory.fromJson(m)).toList();
}

List<PriceHistory> _parsePriceHistoryCoingecko(dynamic data) {
  return data
      .map<PriceHistory>((m) => new PriceHistory.fromJson(m))
      .toList()
      .reversed
      .toList();
}

class PriceApi {
  Future<List<PriceHistory>> fetchPriceHistory(var startAt, type) async {
    try {
      Dio dio = getKucoinDio();
      Response response;
      response = await dio.get(
        '/market/candles?symbol=NWC-USDT&startAt=$startAt&type=$type',
      );
      final responseJson = response.data;
      return compute(_parsePriceHistory, responseJson['data']);
    } on DioError catch (e) {
      if (e.response != null) {
        if (e.response.statusCode == 404) {
          return [];
        }
        throw ("no ");
      } else {
        throw ("no inte");
      }
    } catch (e) {
      throw ("no interner");
    }
  }

  Future<Statistics> fetchStats() async {
    try {
      Dio dio = getKucoinDio();
      Response response;
      response = await dio.get(
        '/market/stats?symbol=NWC-USDT',
      );

      final responseJson = response.data;
      return new Statistics.fromJson(responseJson['data']);
    } on DioError catch (e) {
      if (e.response != null) {
        if (e.response.statusCode == 404) {
          return new Statistics();
        }
        throw ("no ");
      } else {
        throw ("no inte");
      }
    } catch (e) {
      throw ("no interner");
    }
  }

  Future<List<PriceHistory>> fetchCoinGeckoPriceHistory(
      var candleFrame, var startAt) async {
    try {
      Dio dio = getCoinGeckoDio();
      Response response;
      response = await dio.get(
        '/coins/newscrypto-coin/market_chart?vs_currency=usd&days=$candleFrame',
      );
      final responseJson = response.data;
      return compute(_parsePriceHistoryCoingecko, responseJson['prices']);
    } on DioError catch (e) {
      if (e.response != null) {
        if (e.response.statusCode == 404) {
          return [];
        }
        throw ("no ");
      } else {
        throw ("no inte");
      }
    } catch (e) {
      throw ("no interner");
    }
  }
}
