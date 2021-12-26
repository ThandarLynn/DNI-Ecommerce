import 'dart:async';
import 'package:dni_ecommerce/api/app_api_service.dart';
import 'package:dni_ecommerce/api/common/app_resource.dart';
import 'package:dni_ecommerce/api/common/app_status.dart';
import 'package:dni_ecommerce/db/transaction_detail_dao.dart';
import 'package:dni_ecommerce/viewobject/transaction_detail.dart';
import 'package:dni_ecommerce/viewobject/transaction_header.dart';
import 'package:flutter/material.dart';
import 'package:sembast/sembast.dart';

import 'Common/app_repository.dart';

class TransactionDetailRepository extends AppRepository {
  TransactionDetailRepository(
      {@required AppApiService appApiService,
      @required TransactionDetailDao transactionDetailDao}) {
    _appApiService = appApiService;
    _transactionDetailDao = transactionDetailDao;
  }

  String primaryKey = 'id';
  AppApiService _appApiService;
  TransactionDetailDao _transactionDetailDao;

  Future<dynamic> insert(TransactionDetail transaction) async {
    return _transactionDetailDao.insert(primaryKey, transaction);
  }

  Future<dynamic> update(TransactionDetail transaction) async {
    return _transactionDetailDao.update(transaction);
  }

  Future<dynamic> delete(TransactionDetail transaction) async {
    return _transactionDetailDao.delete(transaction);
  }

  Future<dynamic> addTransactionDetail(
      StreamController<AppResource<List<TransactionDetail>>>
          transactionHeaderStream,
      AppStatus status,
      TransactionDetail transactionDetail) async {
    final Finder finder =
        Finder(filter: Filter.equals('id', transactionDetail.id));
    await _transactionDetailDao.insert(primaryKey, transactionDetail);
    transactionHeaderStream.sink.add(
        await _transactionDetailDao.getAll(finder: finder, status: status));
  }

  Future<dynamic> getAllTransactionDetailList(
      StreamController<AppResource<List<TransactionDetail>>>
          transactionDetailListStream,
      TransactionHeader transaction,
      bool isConnectedToInternet,
      int limit,
      int offset,
      AppStatus status,
      {bool isLoadFromServer = true}) async {
    final Finder finder =
        Finder(filter: Filter.equals('transactions_header_id', transaction.id));
    transactionDetailListStream.sink.add(
        await _transactionDetailDao.getAll(finder: finder, status: status));

    if (isConnectedToInternet) {
      print(_appApiService.toString());
      // final AppResource<List<TransactionDetail>> _resource =
      //     await _appApiService.getTransactionDetail(
      //         transaction.id, limit, offset);

      // if (_resource.status == AppStatus.SUCCESS) {
      //   await _transactionDetailDao.deleteWithFinder(finder);
      //   await _transactionDetailDao.insertAll(primaryKey, _resource.data);
      // } else {
      //   if (_resource.errorCode == AppConst.ERROR_CODE_10001) {
      //     await _transactionDetailDao.deleteWithFinder(finder);
      //   }
      // }
      transactionDetailListStream.sink
          .add(await _transactionDetailDao.getAll(finder: finder));
    }
  }

  Future<dynamic> getNextPageTransactionDetailList(
      StreamController<AppResource<List<TransactionDetail>>>
          transactionDetailListStream,
      TransactionHeader transaction,
      bool isConnectedToInternet,
      int limit,
      int offset,
      AppStatus status,
      {bool isLoadFromServer = true}) async {
    final Finder finder =
        Finder(filter: Filter.equals('transactions_header_id', transaction.id));
    transactionDetailListStream.sink.add(
        await _transactionDetailDao.getAll(finder: finder, status: status));

    if (isConnectedToInternet) {
      // final AppResource<List<TransactionDetail>> _resource =
      //     await _appApiService.getTransactionDetail(
      //         transaction.id, limit, offset);

      // if (_resource.status == AppStatus.SUCCESS) {
      //   await _transactionDetailDao.insertAll(primaryKey, _resource.data);
      // }
      transactionDetailListStream.sink
          .add(await _transactionDetailDao.getAll(finder: finder));
    }
  }
}
