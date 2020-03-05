import 'dart:async';
import 'dart:io';
import './constant.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

Map<String, dynamic> optHeader = {
  'accept-language': 'zh-cn',
  'content-type': 'application/json'
};

var dio = new Dio(BaseOptions(connectTimeout: 30000, headers: optHeader));

/// Created by U-Demon
/// Date: 2020/3/5
class NetUtils {
  // GET请求
  static Future get(String url, [Map<String, dynamic> params]) async {
    var response;

    // 设置代理 便于本地 charles 抓包
    // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //     (HttpClient client) {
    //   client.findProxy = (uri) {
    //     return "PROXY 30.10.24.79:8889";
    //   };
    // };

    if (Constant.PLATFORM() != WEB) {
      Directory docDir = await getApplicationDocumentsDirectory();
      String docPath = docDir.path;
      print('HTTP cookies path = $docPath');
      var dir = new Directory('$docPath/cookies');
      await dir.create();
      dio.interceptors.add(CookieManager(CookieJar()));
    }
    if (params != null) {
      response = await dio.get(url, queryParameters: params);
    }
    else {
      response = await dio.get(url);
    }
    return response.data;
  }

  // POST请求
  static Future post(String url, Map<String, dynamic> params) async {
    // // 设置代理 便于本地 charles 抓包
    // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //     (HttpClient client) {
    //   client.findProxy = (uri) {
    //     return "PROXY 30.10.24.79:8889";
    //   };
    // };
    if (Constant.PLATFORM() != WEB) {
      Directory docDir = await getApplicationDocumentsDirectory();
      String docPath = docDir.path;
      var dir = new Directory("$docPath/cookies");
      await dir.create();
      dio.interceptors.add(CookieManager(PersistCookieJar(dir: dir.path)));
    }
    var response = await dio.post(url, data: params);
    return response.data;
  }

}
