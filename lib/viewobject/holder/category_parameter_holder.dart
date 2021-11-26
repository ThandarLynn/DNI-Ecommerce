import 'package:dni_ecommerce/constant/app_constant.dart';
import 'package:dni_ecommerce/viewobject/common/app_holder.dart';

class CategoryParameterHolder extends AppHolder<dynamic> {
  CategoryParameterHolder() {
    orderBy = AppConst.FILTERING__ADDED_DATE;
  }

  String orderBy;

  CategoryParameterHolder getTrendingParameterHolder() {
    orderBy = AppConst.FILTERING__TRENDING;

    return this;
  }

  CategoryParameterHolder getLatestParameterHolder() {
    orderBy = AppConst.FILTERING__ADDED_DATE;

    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['order_by'] = orderBy;

    return map;
  }

  @override
  dynamic fromMap(dynamic dynamicData) {
    orderBy = AppConst.FILTERING__ADDED_DATE;

    return this;
  }

  @override
  String getParamKey() {
    String result = '';

    if (orderBy != '') {
      result += orderBy + ':';
    }

    return result;
  }
}
