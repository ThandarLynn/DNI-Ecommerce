import 'common/app_map_object.dart';

class TopRatedProduct extends AppMapObject<TopRatedProduct> {
  TopRatedProduct({this.id, int sorting}) {
    super.sorting = sorting;
  }
  String id;

  @override
  String getPrimaryKey() {
    return id;
  }

  @override
  TopRatedProduct fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return TopRatedProduct(
          id: dynamicData['id'], sorting: dynamicData['sorting']);
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(dynamic object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['id'] = object.id;
      data['sorting'] = object.sorting;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<TopRatedProduct> fromMapList(List<dynamic> dynamicDataList) {
    final List<TopRatedProduct> favouriteProductMapList = <TopRatedProduct>[];

    if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          favouriteProductMapList.add(fromMap(dynamicData));
        }
      }
    }
    return favouriteProductMapList;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<dynamic> objectList) {
    final List<Map<String, dynamic>> dynamicList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (dynamic data in objectList) {
        if (data != null) {
          dynamicList.add(toMap(data));
        }
      }
    }

    return dynamicList;
  }

  @override
  List<String> getIdList(List<dynamic> mapList) {
    final List<String> idList = <String>[];
    if (mapList != null) {
      for (dynamic product in mapList) {
        if (product != null) {
          idList.add(product.id);
        }
      }
    }
    return idList;
  }
}
