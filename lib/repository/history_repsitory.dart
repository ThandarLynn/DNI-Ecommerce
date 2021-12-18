import 'dart:async';
import 'package:dni_ecommerce/api/common/app_resource.dart';
import 'package:dni_ecommerce/api/common/app_status.dart';
import 'package:dni_ecommerce/db/history_dao.dart';
import 'package:dni_ecommerce/viewobject/product.dart';
import 'package:flutter/material.dart';
import 'package:sembast/sembast.dart';

import 'Common/app_repository.dart';

class HistoryRepository extends AppRepository {
  HistoryRepository({@required HistoryDao historyDao}) {
    _historyDao = historyDao;
  }

  String primaryKey = 'id';
  HistoryDao _historyDao;

  Future<dynamic> insert(Product history) async {
    return _historyDao.insert(primaryKey, history);
  }

  Future<dynamic> update(Product history) async {
    return _historyDao.update(history);
  }

  Future<dynamic> delete(Product history) async {
    return _historyDao.delete(history);
  }

  Future<dynamic> getAllHistoryList(
      StreamController<AppResource<List<Product>>> historyListStream,
      AppStatus status) async {
    historyListStream.sink.add(await _historyDao.getAll(status: status));
  }

  Future<dynamic> loadHistoryById(
      StreamController<AppResource<Product>> historyStream,
      AppStatus status,
      String productId) async {
    final Finder finder = Finder(filter: Filter.equals('id', productId));
    historyStream.sink
        .add(await _historyDao.getOne(finder: finder, status: status));
  }

  Future<dynamic> addAllHistoryList(
      StreamController<AppResource<Product>> historyStream,
      AppStatus status,
      Product product) async {
        final Finder finder = Finder(filter: Filter.equals('id', product.id));
    await _historyDao.insert(primaryKey, product);
    historyStream.sink.add(await _historyDao.getOne(finder: finder,status: status));
  }

  Future<dynamic> removeHistoryList(
      StreamController<AppResource<Product>> historyStream,
      AppStatus status,
      Product product) async {
        final Finder finder = Finder(filter: Filter.equals('id', product.id));
    await _historyDao.delete(product);
    historyStream.sink.add(await _historyDao.getOne(finder: finder,status: status));
  }

  Future<dynamic> removeHistoryFromList(
      StreamController<AppResource<List<Product>>> historyListStream,
      AppStatus status,
      Product product) async {
    await _historyDao.delete(product);
    historyListStream.sink.add(await _historyDao.getAll(status: status));
  }
}
