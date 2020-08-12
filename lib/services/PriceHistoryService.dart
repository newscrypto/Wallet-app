import 'package:dio/dio.dart';
import 'package:newscrypto_wallet/models/Price.dart';
import 'package:newscrypto_wallet/models/Statistics.dart';
import 'package:newscrypto_wallet/services/comonNetwork.dart';

Future<List<PriceHistory>> fetchPriceHistory(var startAt, type) async {
  try {
    print(startAt);
    Dio dio = getKucoinDio();
    Response response;
    response = await dio.get(
      '/market/candles?symbol=NWC-USDT&startAt=$startAt&type=$type',
    );
    final responseJson = response.data;
    return responseJson['data']
        .map<PriceHistory>((m) => new PriceHistory.fromJson(m))
        .toList();
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
    print(responseJson['data']);
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
    print(e);
    throw ("no interner");
  }
}

Future<List<PriceHistory>> fetchCoinGeckoPriceHistory(
    var candleFrame, var startAt) async {
  try {
    print(startAt);
    Dio dio = getCoinGeckoDio();
    Response response;
    response = await dio.get(
      '/coins/newscrypto-coin/market_chart?vs_currency=usd&days=$candleFrame',
    );
    final responseJson = response.data;
    return responseJson['prices']
        .map<PriceHistory>((m) => new PriceHistory.fromJson(m))
        .toList()
        .reversed
        .toList();
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
    print(e);
    throw ("no interner");
  }
}
