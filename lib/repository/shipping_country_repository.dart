import 'dart:async';
import 'package:dni_ecommerce/api/app_api_service.dart';
import 'package:dni_ecommerce/api/common/app_resource.dart';
import 'package:dni_ecommerce/api/common/app_status.dart';
import 'package:dni_ecommerce/constant/app_constant.dart';
import 'package:dni_ecommerce/db/shipping_country_dao.dart';
import 'package:dni_ecommerce/viewobject/holder/shipping_country_parameter_holder.dart';
import 'package:dni_ecommerce/viewobject/shipping_country.dart';
import 'package:flutter/material.dart';

import 'Common/app_repository.dart';

class ShippingCountryRepository extends AppRepository {
  ShippingCountryRepository(
      {@required AppApiService psApiService,
      @required ShippingCountryDao shippingCountryDao}) {
    _psApiService = psApiService;
    _shippingCountryDao = shippingCountryDao;
  }

  String primaryKey = 'id';
  AppApiService _psApiService;
  ShippingCountryDao _shippingCountryDao;

  Future<dynamic> insert(ShippingCountry shippingCountry) async {
    return _shippingCountryDao.insert(primaryKey, shippingCountry);
  }

  Future<dynamic> update(ShippingCountry shippingCountry) async {
    return _shippingCountryDao.update(shippingCountry);
  }

  Future<dynamic> delete(ShippingCountry shippingCountry) async {
    return _shippingCountryDao.delete(shippingCountry);
  }

  Future<dynamic> getAllShippingCountryList(
      StreamController<AppResource<List<ShippingCountry>>>
          shippingCountryListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      ShippingCountryParameterHolder holder,
      AppStatus status,
      {bool isNeedDelete = true,
      bool isLoadFromServer = true}) async {
    shippingCountryListStream.sink
        .add(await _shippingCountryDao.getAll(status: status));

    if (isConnectedToInternet) {
      final AppResource<List<ShippingCountry>> _resource =
          await _psApiService.getCountryList(limit, offset, holder.toMap());

      if (_resource.status == AppStatus.SUCCESS) {
        if (isNeedDelete) {
          await _shippingCountryDao.deleteAll();
        }
        await _shippingCountryDao.insertAll(primaryKey, _resource.data);
      } else {
        if (_resource.errorCode == AppConst.ERROR_CODE_10001) {
          if (isNeedDelete) {
            await _shippingCountryDao.deleteAll();
          }
        }
      }
      shippingCountryListStream.sink.add(await _shippingCountryDao.getAll());
    }
  }

  Future<dynamic> getNextPageShippingCountryList(
      StreamController<AppResource<List<ShippingCountry>>>
          shippingCountryListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      ShippingCountryParameterHolder holder,
      AppStatus status,
      {bool isNeedDelete = true,
      bool isLoadFromServer = true}) async {
    shippingCountryListStream.sink
        .add(await _shippingCountryDao.getAll(status: status));

    if (isConnectedToInternet) {
      final AppResource<List<ShippingCountry>> _resource =
          await _psApiService.getCountryList(limit, offset, holder.toMap());

      if (_resource.status == AppStatus.SUCCESS) {
        await _shippingCountryDao.insertAll(primaryKey, _resource.data);
      }
      shippingCountryListStream.sink.add(await _shippingCountryDao.getAll());
    }
  }
}
