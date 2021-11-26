import 'dart:async';
import 'package:dni_ecommerce/api/common/app_resource.dart';
import 'package:dni_ecommerce/api/common/app_status.dart';
import 'package:dni_ecommerce/provider/common/app_provider.dart';
import 'package:dni_ecommerce/repository/tansaction_detail_repository.dart';
import 'package:dni_ecommerce/utils/utils.dart';
import 'package:dni_ecommerce/viewobject/common/app_value_holder.dart';
import 'package:dni_ecommerce/viewobject/transaction_detail.dart';
import 'package:dni_ecommerce/viewobject/transaction_header.dart';
import 'package:flutter/material.dart';

class TransactionDetailProvider extends AppProvider {
  TransactionDetailProvider(
      {@required TransactionDetailRepository repo,
      this.psValueHolder,
      int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    print('Transaction Detail Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    transactionDetailListStream =
        StreamController<AppResource<List<TransactionDetail>>>.broadcast();
    subscription = transactionDetailListStream.stream
        .listen((AppResource<List<TransactionDetail>> resource) {
      updateOffset(resource.data.length);

      _transactionDetailList = resource;

      if (resource.status != AppStatus.BLOCK_LOADING &&
          resource.status != AppStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  TransactionDetailRepository _repo;
  AppValueHolder psValueHolder;

  AppResource<List<TransactionDetail>> _transactionDetailList =
      AppResource<List<TransactionDetail>>(
          AppStatus.NOACTION, '', <TransactionDetail>[]);

  AppResource<List<TransactionDetail>> get transactionDetailList =>
      _transactionDetailList;
  StreamSubscription<AppResource<List<TransactionDetail>>> subscription;
  StreamController<AppResource<List<TransactionDetail>>>
      transactionDetailListStream;
  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('Transaction Detail Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadTransactionDetailList(
      TransactionHeader transaction) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo.getAllTransactionDetailList(
        transactionDetailListStream,
        transaction,
        isConnectedToInternet,
        limit,
        offset,
        AppStatus.PROGRESS_LOADING);
  }

  Future<dynamic> nextTransactionDetailList(
      TransactionHeader transaction) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;
      await _repo.getNextPageTransactionDetailList(
          transactionDetailListStream,
          transaction,
          isConnectedToInternet,
          limit,
          offset,
          AppStatus.PROGRESS_LOADING);
    }
  }

  Future<void> resetTransactionDetailList(TransactionHeader transaction) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    await _repo.getAllTransactionDetailList(
        transactionDetailListStream,
        transaction,
        isConnectedToInternet,
        limit,
        offset,
        AppStatus.PROGRESS_LOADING);

    isLoading = false;
  }
}
