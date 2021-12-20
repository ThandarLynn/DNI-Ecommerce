import 'dart:async';
import 'package:dni_ecommerce/api/app_api_service.dart';
import 'package:dni_ecommerce/api/common/app_resource.dart';
import 'package:dni_ecommerce/api/common/app_status.dart';
import 'package:dni_ecommerce/constant/app_constant.dart';
import 'package:dni_ecommerce/db/shipping_city_dao.dart';
import 'package:dni_ecommerce/viewobject/holder/shipping_city_parameter_holder.dart';
import 'package:dni_ecommerce/viewobject/shipping_city.dart';
import 'package:flutter/material.dart';
import 'package:sembast/sembast.dart';

import 'Common/app_repository.dart';

class ShippingCityRepository extends AppRepository {
  ShippingCityRepository(
      {@required AppApiService appApiService,
      @required ShippingCityDao shippingCityDao}) {
    _appApiService = appApiService;
    _shippingCityDao = shippingCityDao;
  }

  String primaryKey = 'id';
  AppApiService _appApiService;
  ShippingCityDao _shippingCityDao;

  Future<dynamic> insert(ShippingCity shippingCity) async {
    return _shippingCityDao.insert(primaryKey, shippingCity);
  }

  Future<dynamic> update(ShippingCity shippingCity) async {
    return _shippingCityDao.update(shippingCity);
  }

  Future<dynamic> delete(ShippingCity shippingCity) async {
    return _shippingCityDao.delete(shippingCity);
  }

  Future<dynamic> getAllShippingCityList(
      StreamController<AppResource<List<ShippingCity>>> shippingCityListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      ShippingCityParameterHolder holder,
      AppStatus status,
      {bool isNeedDelete = true,
      bool isLoadFromServer = true}) async {
    final Finder finder =
        Finder(filter: Filter.equals('country_id', holder.countryId));
    shippingCityListStream.sink
        .add(await _shippingCityDao.getAll(finder: finder, status: status));

    if (isConnectedToInternet) {
      final AppResource<List<ShippingCity>> _resource =
          await _appApiService.getCityList(limit, offset, holder.toMap());

      if (_resource.status == AppStatus.SUCCESS) {
        if (isNeedDelete) {
          await _shippingCityDao.deleteAll();
        }
        await _shippingCityDao.insertAll(primaryKey, _resource.data);
      } else {
        if (_resource.errorCode == AppConst.ERROR_CODE_10001) {
          if (isNeedDelete) {
            await _shippingCityDao.deleteAll();
          }
        }
      }
      shippingCityListStream.sink.add(await _shippingCityDao.getAll());
    }
  }

  Future<dynamic> getNextPageShippingCityList(
      StreamController<AppResource<List<ShippingCity>>> shippingCityListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      ShippingCityParameterHolder holder,
      AppStatus status,
      {bool isNeedDelete = true,
      bool isLoadFromServer = true}) async {
    final Finder finder =
        Finder(filter: Filter.equals('country_id', holder.countryId));
    shippingCityListStream.sink
        .add(await _shippingCityDao.getAll(finder: finder, status: status));

    if (isConnectedToInternet) {
      final AppResource<List<ShippingCity>> _resource =
          await _appApiService.getCityList(limit, offset, holder.toMap());

      if (_resource.status == AppStatus.SUCCESS) {
        await _shippingCityDao.insertAll(primaryKey, _resource.data);
      }
      shippingCityListStream.sink.add(await _shippingCityDao.getAll());
    }
  }
}
