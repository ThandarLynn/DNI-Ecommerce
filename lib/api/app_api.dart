import 'dart:convert';
import 'dart:io';
import 'package:dni_ecommerce/api/common/app_api_reponse.dart';
import 'package:dni_ecommerce/config/app_config.dart';
import 'package:dni_ecommerce/viewobject/common/app_object.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'common/app_resource.dart';
import 'common/app_status.dart';

void main(){
  String dateTime = '2020-02-03T08:30:00.000Z';
  int year = 2020;
  int month = 2;
  int day = 3;
  int hour = 8;
  int minute = 30;

  var dt = DateTime(year,month,day,hour,minute);
  print(dt);

  print(DateTime.parse(dateTime).isAtSameMomentAs(dt));

  // 2020-02-03 08:30:00.000Z
  // 2020-02-03 08:30:00.000Z
  // true
}

abstract class AppApi {
  AppResource<T> appObjectConvert<T>(dynamic dataList, T data) {
    return AppResource<T>(dataList.status, dataList.message, data);
  }

  Future<List<dynamic>> getList(String url) async {
    final Client client = http.Client();
    try {
      final Response response =
          await client.get(Uri.parse('${AppConfig.app_url}$url'));

      if (response.statusCode == 200 &&
          response.body != null &&
          response.body != '') {
        // parse into List
        final List<dynamic> parsed = json.decode(response.body);

        return parsed;
      } else {
        throw Exception('Error in loading...');
      }
    } finally {
      client.close();
    }
  }

  Future<AppResource<R>> getJsonServerCall<T extends AppObject<dynamic>, R>(
      T obj, String url,
      {String token}) async {
    final Client client = http.Client();
    try {
      final dynamic jsonText = await rootBundle.loadString(url);

      final dynamic hashMap = json.decode(jsonText);

      if (!(hashMap is Map)) {
        // final List<T> tList = <T>[];
        // hashMap.forEach((dynamic data) {
        //   tList.add(obj.fromMap(data as dynamic));
        // });
        return AppResource<R>(
            AppStatus.SUCCESS, '', obj.fromMapList(hashMap) ?? R);
      } else {
        return AppResource<R>(AppStatus.SUCCESS, '', obj.fromMap(hashMap));
      }
    } finally {
      client.close();
    }
  }

  Future<AppResource<R>> postJsonData<T extends AppObject<dynamic>, R>(
      T obj, String url, Map<dynamic, dynamic> jsonMap,
      {String token}) async {
    final Client client = http.Client();
    try {
      final dynamic jsonText = await rootBundle.loadString(url);

      final dynamic hashMap = json.decode(jsonText);

      if (!(hashMap is Map)) {
        final List<T> tList = <T>[];
        hashMap.forEach((dynamic data) {
          tList.add(obj.fromMap(data));
        });
        return AppResource<R>(AppStatus.SUCCESS, '', tList ?? R);
      } else {
        return AppResource<R>(AppStatus.SUCCESS, '', obj.fromMap(hashMap));
      }
    } finally {
      client.close();
    }
  }

  Future<AppResource<R>> getServerCall<T extends AppObject<dynamic>, R>(
      T obj, String url,
      {String token = ''}) async {
    final Client client = http.Client();
    try {
      final Response response = await client.get(
        Uri.parse('${AppConfig.app_url}$url'),
        headers: <String, String>{
          'content-type': 'application/json',
          'Accept': 'application/json',
          HttpHeaders.authorizationHeader: token,
          'Authorization': 'Bearer $token',
        },
      );
      print('${AppConfig.app_url}$url');
      final AppApiResponse appApiService = AppApiResponse(response);
      print(appApiService.toString());

      if (appApiService.isSuccessful()) {
        final dynamic hashMap = json.decode(response.body);

        if (!(hashMap is Map)) {
          final List<T> tList = <T>[];
          hashMap.forEach((dynamic data) {
            tList.add(obj.fromMap(data as dynamic));
          });
          return AppResource<R>(AppStatus.SUCCESS, '', tList ?? R);
        } else {
          return AppResource<R>(AppStatus.SUCCESS, '', obj.fromMap(hashMap));
        }
      } else {
        return AppResource<R>(
            AppStatus.ERROR, appApiService.errorMessage, null);
      }
    } finally {
      client.close();
    }
  }

  Future<AppResource<R>> postData<T extends AppObject<dynamic>, R>(
      T obj, String url, Map<dynamic, dynamic> jsonMap,
      {String token}) async {
    final Client client = http.Client();
    try {
      final Response response = await client
          .post(Uri.parse('${AppConfig.app_url}$url'),
              headers: <String, String>{
                'content-type': 'application/json',
                'Accept': 'application/json',
                HttpHeaders.authorizationHeader: token,
                'Authorization': 'Bearer $token',
              },
              body: const JsonEncoder().convert(jsonMap))
          .catchError((dynamic e) {
        print('** Error Post Data');
        print(e.error);
      });

      final AppApiResponse appApiService = AppApiResponse(response);

      if (appApiService.isSuccessful()) {
        final dynamic hashMap = json.decode(response.body);

        if (!(hashMap is Map)) {
          final List<T> tList = <T>[];
          hashMap.forEach((dynamic data) {
            tList.add(obj.fromMap(data));
          });
          return AppResource<R>(AppStatus.SUCCESS, '', tList ?? R);
        } else {
          return AppResource<R>(AppStatus.SUCCESS, '', obj.fromMap(hashMap));
        }
      } else {
        return AppResource<R>(
            AppStatus.ERROR, appApiService.errorMessage, null);
      }
    } finally {
      client.close();
    }
  }

  Future<AppResource<R>> postUploadImage<T extends AppObject<dynamic>, R>(T obj,
      String url, String userId, String platformName, File imageFile) async {
    final Client client = http.Client();
    try {
      final ByteStream stream =
          http.ByteStream(Stream.castFrom(imageFile.openRead()));
      final int length = await imageFile.length();

      final Uri uri = Uri.parse('${AppConfig.app_url}$url');

      final MultipartRequest request = http.MultipartRequest('POST', uri);
      final MultipartFile multipartFile = http.MultipartFile(
          'file', stream, length,
          filename: basename(imageFile.path));

      request.fields['user_id'] = userId;
      request.fields['platform_name'] = platformName;
      request.files.add(multipartFile);
      final StreamedResponse response = await request.send();

      final AppApiResponse appApiService =
          AppApiResponse(await http.Response.fromStream(response));

      if (appApiService.isSuccessful()) {
        final dynamic hashMap = json.decode(appApiService.body);

        if (!(hashMap is Map)) {
          final List<T> tList = <T>[];
          hashMap.forEach((dynamic data) {
            tList.add(obj.fromMap(data));
          });
          return AppResource<R>(AppStatus.SUCCESS, '', tList ?? R);
        } else {
          return AppResource<R>(AppStatus.SUCCESS, '', obj.fromMap(hashMap));
        }
      } else {
        return AppResource<R>(
            AppStatus.ERROR, appApiService.errorMessage, null);
      }
    } finally {
      client.close();
    }
  }
}
