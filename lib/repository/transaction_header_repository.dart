import 'dart:async';
import 'package:dni_ecommerce/api/app_api_service.dart';
import 'package:dni_ecommerce/api/common/app_resource.dart';
import 'package:dni_ecommerce/api/common/app_status.dart';
// import 'package:dni_ecommerce/constant/app_constant.dart';
import 'package:dni_ecommerce/db/transaction_header_dao.dart';
import 'package:dni_ecommerce/viewobject/transaction_header.dart';
import 'package:flutter/material.dart';
import 'package:sembast/sembast.dart';

import 'Common/app_repository.dart';

class TransactionHeaderRepository extends AppRepository {
  TransactionHeaderRepository(
      {@required AppApiService appApiService,
      @required TransactionHeaderDao transactionHeaderDao}) {
    _appApiService = appApiService;
    _transactionHeaderDao = transactionHeaderDao;
  }

  String primaryKey = 'order_id';
  AppApiService _appApiService;
  TransactionHeaderDao _transactionHeaderDao;

  Future<dynamic> insert(TransactionHeader transaction) async {
    return _transactionHeaderDao.insert(primaryKey, transaction);
  }

  Future<dynamic> update(TransactionHeader transaction) async {
    return _transactionHeaderDao.update(transaction);
  }

  Future<dynamic> delete(TransactionHeader transaction) async {
    return _transactionHeaderDao.delete(transaction);
  }

  Future<dynamic> addTransaction(
      StreamController<AppResource<List<TransactionHeader>>>
          transactionHeaderStream,
      AppStatus status,
      TransactionHeader transactionHeader) async {
    final Finder finder =
        Finder(filter: Filter.equals('id', transactionHeader.id));
    await _transactionHeaderDao.insert(primaryKey, transactionHeader);
    transactionHeaderStream.sink.add(
        await _transactionHeaderDao.getAll(finder: finder, status: status));
  }

  Future<dynamic> getAllTransactionList(
      StreamController<AppResource<List<TransactionHeader>>>
          transactionListStream,
      bool isConnectedToInternet,
      String loginUserId,
      String userToken,
      int limit,
      int offset,
      AppStatus status,
      {bool isNeedDelete = true,
      bool isLoadFromServer = true}) async {
    final Finder finder = Finder(filter: Filter.equals('user_id', loginUserId));
    transactionListStream.sink.add(
        await _transactionHeaderDao.getAll(finder: finder, status: status));

    if (isConnectedToInternet) {
      // final AppResource<List<TransactionHeader>> _resource =
      //     await _appApiService.getTransactionList(
      //         loginUserId, userToken, limit, offset);

      // if (_resource.status == AppStatus.SUCCESS) {
      //   if (isNeedDelete) {
      //     await _transactionHeaderDao.deleteWithFinder(finder);
      //   }
      //   await _transactionHeaderDao.insertAll(primaryKey, _resource.data);
      // } else {
      //   if (_resource.errorCode == AppConst.ERROR_CODE_10001) {
      //     if (isNeedDelete) {
      //       await _transactionHeaderDao.deleteWithFinder(finder);
      //     }
      //   }
      // }
      transactionListStream.sink
          .add(await _transactionHeaderDao.getAll(finder: finder));
    }
  }

  Future<dynamic> getNextPageTransactionList(
      StreamController<AppResource<List<TransactionHeader>>>
          transactionListStream,
      bool isConnectedToInternet,
      String loginUserId,
      String userToken,
      int limit,
      int offset,
      AppStatus status,
      {bool isNeedDelete = true,
      bool isLoadFromServer = true}) async {
    final Finder finder = Finder(filter: Filter.equals('user_id', loginUserId));
    transactionListStream.sink.add(
        await _transactionHeaderDao.getAll(finder: finder, status: status));

    if (isConnectedToInternet) {
      // final AppResource<List<TransactionHeader>> _resource =
      //     await _appApiService.getTransactionList(
      //         loginUserId, userToken, limit, offset);

      // if (_resource.status == AppStatus.SUCCESS) {
      //   await _transactionHeaderDao.insertAll(primaryKey, _resource.data);
      // }
      transactionListStream.sink.add(await _transactionHeaderDao.getAll());
    }
  }

  Future<AppResource<TransactionHeader>> postTransactionSubmit(
      Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet,
      AppStatus status,
      {bool isLoadFromServer = true}) async {
    final String jsonMapData = jsonMap.toString();
    print(jsonMapData);

    final AppResource<TransactionHeader> _resource =
        await _appApiService.postTransactionSubmit(jsonMap);
    if (_resource.status == AppStatus.SUCCESS) {
      return _resource;
    } else {
      final Completer<AppResource<TransactionHeader>> completer =
          Completer<AppResource<TransactionHeader>>();
      completer.complete(_resource);
      return completer.future;
    }
  }
}
