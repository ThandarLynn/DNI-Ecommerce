import 'package:dni_ecommerce/viewobject/common/app_object.dart';

class Gallery extends AppObject<Gallery> {
  Gallery(
      {this.imgId,
      this.imgParentId,
      this.imgType,
      this.url,
      this.imgWidth,
      this.imgHeight,
      this.imgDesc});

  String imgId;
  String imgParentId;
  String imgType;
  String url;
  String imgWidth;
  String imgHeight;
  String imgDesc;

  @override
  String getPrimaryKey() {
    return imgId;
  }

  @override
  Gallery fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return Gallery(
          imgId: dynamicData['image_id'],
          imgParentId: dynamicData['product_id'],
          imgType: dynamicData['img_type'],
          url: dynamicData['url'],
          imgWidth: dynamicData['img_width'],
          imgHeight: dynamicData['img_height'],
          imgDesc: dynamicData['img_desc']);
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(dynamic object) {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (object != null) {
      data['image_id'] = object.imgId;
      data['product_id'] = object.imgParentId;
      data['img_type'] = object.imgType;
      data['url'] = object.url;
      data['img_width'] = object.imgWidth;
      data['img_height'] = object.imgHeight;
      data['img_desc'] = object.imgDesc;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<Gallery> fromMapList(List<dynamic> dynamicDataList) {
    final List<Gallery> defaultPhotoList = <Gallery>[];

    if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          defaultPhotoList.add(fromMap(dynamicData));
        }
      }
    }
    return defaultPhotoList;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<Gallery> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];

    if (objectList != null) {
      for (Gallery data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }

    return mapList;
  }
}
