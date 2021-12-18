import 'package:dni_ecommerce/viewobject/common/app_object.dart';

class ApiStatus extends AppObject<ApiStatus> {
  ApiStatus({
    this.status,
    this.message,
    this.token
  });

  String status;
  String message;
  String token;

  @override
  String getPrimaryKey() {
    return status;
  }

  @override
  List<ApiStatus> fromMapList(List<dynamic> dynamicDataList) {
    final List<ApiStatus> subCategoryList = <ApiStatus>[];

    if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          subCategoryList.add(fromMap(dynamicData));
        }
      }
    }
    return subCategoryList;
  }

  @override
  ApiStatus fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return ApiStatus(
        status: dynamicData['status'],
        message: dynamicData['message'],
        token: dynamicData['token'],
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(ApiStatus object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['status'] = object.status;
      data['message'] = object.message;
      data['token'] = object.token;

      return data;
    } else {
      return null;
    }
  }

  @override
  List<Map<String, dynamic>> toMapList(List<ApiStatus> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (ApiStatus data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }
    return mapList;
  }
}
