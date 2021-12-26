import 'package:dni_ecommerce/viewobject/common/app_object.dart';
import 'default_icon.dart';

class SubCategory extends AppObject<SubCategory> {
  SubCategory(
      {this.id,
      this.name,
      this.status,
      this.addedDate,
      this.addedUserId,
      this.updatedDate,
      this.catId,
      this.updatedUserId,
      this.updatedFlag,
      this.addedDateStreet,
      this.defaultIcon});

  String id;
  String name;
  String status;
  String addedDate;
  String addedUserId;
  String updatedDate;
  String catId;
  String updatedUserId;
  String updatedFlag;
  String addedDateStreet;
  DefaultIcon defaultIcon;

  @override
  String getPrimaryKey() {
    return id;
  }

  @override
  SubCategory fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return SubCategory(
          id: dynamicData['subcategory_id'],
          name: dynamicData['subcategory_name'],
          status: dynamicData['status'],
          addedDate: dynamicData['added_date'],
          addedUserId: dynamicData['added_user_id'],
          updatedDate: dynamicData['updated_date'],
          catId: dynamicData['category_id'],
          updatedUserId: dynamicData['updated_user_id'],
          updatedFlag: dynamicData['updated_flag'],
          addedDateStreet: dynamicData['added_date_str'],
          defaultIcon: DefaultIcon().fromMap(dynamicData['default_icon']));
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(SubCategory object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['subcategory_id'] = object.id;
      data['subcategory_name'] = object.name;
      data['status'] = object.status;
      data['added_date'] = object.addedDate;
      data['added_user_id'] = object.addedUserId;
      data['updated_date'] = object.updatedDate;
      data['category_id'] = object.catId;
      data['updated_user_id'] = object.updatedUserId;
      data['updated_flag'] = object.updatedFlag;
      data['added_date_str'] = object.addedDateStreet;
      data['default_icon'] = DefaultIcon().toMap(object.defaultIcon);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<SubCategory> fromMapList(List<dynamic> dynamicDataList) {
    final List<SubCategory> subSubCategoryList = <SubCategory>[];
    if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          subSubCategoryList.add(fromMap(dynamicData));
        }
      }
    }
    return subSubCategoryList;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<SubCategory> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (mapList != null) {
      for (SubCategory data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }

    return mapList;
  }
}
