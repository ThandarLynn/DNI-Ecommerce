import 'dart:async';
import 'package:dni_ecommerce/api/common/app_resource.dart';
import 'package:dni_ecommerce/api/common/app_status.dart';
import 'package:dni_ecommerce/db/history_dao.dart';
import 'package:dni_ecommerce/viewobject/product.dart';
import 'package:flutter/material.dart';

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

  Future<dynamic> addAllHistoryList(
      StreamController<AppResource<List<Product>>> historyListStream,
      AppStatus status,
      Product product) async {
    await _historyDao.insert(primaryKey, product);
    historyListStream.sink.add(await _historyDao.getAll(status: status));
  }
}
