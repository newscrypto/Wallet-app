import 'package:dio/dio.dart';
import 'package:newscrypto_wallet/models/Activation.dart';

import 'comonNetwork.dart';


class ActivationApi{

Future<ActivationInfo> fetchActivationInfo(String address) async {
    try {
      Dio dio = getMainDio();
      Response response = await dio.get(
        '/wallets/$address',
      );
      final responseJson = response.data;
      print(responseJson['data']);
      return new ActivationInfo.fromJson(responseJson['data']);
    } on DioError catch (e) {
      print(e);
      if (e.response != null) {
        throw ("no ");
      } else {
        throw ("no inte");
      }
    } catch (e) {
      print(e);
      throw ("no interner");
    }
  }

  Future<bool> getChange(String address) async {
    try {
      Dio dio = getMainDio();
      Response response = await dio.get(
        '/wallets/$address/change',
      );
      final responseJson = response.data;
      print(responseJson['data']);
      return true;
    } on DioError catch (e) {
      print(e);
      if (e.response != null) {
        throw ("no ");
      } else {
        throw ("no inte");
      }
    } catch (e) {
      print(e);
      throw ("no interner");
    }
  }
}
