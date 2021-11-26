import 'dart:async';
import 'package:dni_ecommerce/api/common/app_resource.dart';
import 'package:dni_ecommerce/api/common/app_status.dart';
import 'package:dni_ecommerce/db/basket_dao.dart';
import 'package:dni_ecommerce/viewobject/basket.dart';
import 'package:flutter/material.dart';

import 'Common/app_repository.dart';

class BasketRepository extends AppRepository {
  BasketRepository({@required BasketDao basketDao}) {
    _basketDao = basketDao;
  }

  String primaryKey = 'id';
  BasketDao _basketDao;

  Future<dynamic> insert(Basket basket) async {
    return _basketDao.insert(primaryKey, basket);
  }

  Future<dynamic> update(Basket basket) async {
    return _basketDao.update(basket);
  }

  Future<dynamic> delete(Basket basket) async {
    return _basketDao.delete(basket);
  }

  Future<dynamic> getAllBasketList(
      StreamController<AppResource<List<Basket>>> basketListStream,
      AppStatus status) async {
    final dynamic subscription = _basketDao.getAllWithSubscription(
        status: AppStatus.SUCCESS,
        onDataUpdated: (List<Basket> productList) {
          if (status != null && status != AppStatus.NOACTION) {
            print(status);
            basketListStream.sink
                .add(AppResource<List<Basket>>(status, '', productList));
          } else {
            print('No Action');
          }
        });

    return subscription;
  }

  Future<dynamic> addAllBasket(
      StreamController<AppResource<List<Basket>>> basketListStream,
      AppStatus status,
      Basket product) async {
    await _basketDao.insert(primaryKey, product);
    basketListStream.sink.add(await _basketDao.getAll(status: status));
  }

  Future<dynamic> updateBasket(
      StreamController<AppResource<List<Basket>>> basketListStream,
      Basket product) async {
    await _basketDao.update(product);
    basketListStream.sink
        .add(await _basketDao.getAll(status: AppStatus.SUCCESS));
  }

  Future<dynamic> deleteBasketByProduct(
      StreamController<AppResource<List<Basket>>> basketListStream,
      Basket product) async {
    await _basketDao.delete(product);
    basketListStream.sink
        .add(await _basketDao.getAll(status: AppStatus.SUCCESS));
  }

  Future<dynamic> deleteWholeBasketList(
      StreamController<AppResource<List<Basket>>> basketListStream) async {
    await _basketDao.deleteAll();
  }
}
