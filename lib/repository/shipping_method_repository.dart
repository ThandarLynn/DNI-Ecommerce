import 'dart:async';
import 'package:dni_ecommerce/constant/app_constant.dart';
import 'package:dni_ecommerce/db/shipping_method_dao.dart';
import 'package:flutter/material.dart';
import 'package:dni_ecommerce/api/common/app_resource.dart';
import 'package:dni_ecommerce/api/common/app_status.dart';
import 'package:dni_ecommerce/api/app_api_service.dart';
import 'package:dni_ecommerce/viewobject/shipping_method.dart';

import 'Common/app_repository.dart';

class ShippingMethodRepository extends AppRepository {
  ShippingMethodRepository(
      {@required AppApiService appApiService,
      @required ShippingMethodDao shippingMethodDao}) {
    _appApiService = appApiService;
    _shippingMethodDao = shippingMethodDao;
  }

  String primaryKey = 'id';
  AppApiService _appApiService;
  ShippingMethodDao _shippingMethodDao;

  Future<dynamic> insert(ShippingMethod shippingMethod) async {
    return _shippingMethodDao.insert(primaryKey, shippingMethod);
  }

  Future<dynamic> update(ShippingMethod shippingMethod) async {
    return _shippingMethodDao.update(shippingMethod);
  }

  Future<dynamic> delete(ShippingMethod shippingMethod) async {
    return _shippingMethodDao.delete(shippingMethod);
  }

  Future<dynamic> getAllShippingMethod(
      StreamController<AppResource<List<ShippingMethod>>> shippingMethodStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      AppStatus status,
      {bool isLoadFromServer = true}) async {
    shippingMethodStream.sink
        .add(await _shippingMethodDao.getAll(status: status));

    if (isConnectedToInternet) {
      final AppResource<List<ShippingMethod>> _resource =
          await _appApiService.getShippingMethod();

      if (_resource.status == AppStatus.SUCCESS) {
        await _shippingMethodDao.deleteAll();
        await _shippingMethodDao.insertAll(primaryKey, _resource.data);
      } else {
        if (_resource.errorCode == AppConst.ERROR_CODE_10001) {
          await _shippingMethodDao.deleteAll();
        }
      }
      shippingMethodStream.sink.add(await _shippingMethodDao.getAll());
    }
  }
}
