import 'dart:async';
import 'package:dni_ecommerce/api/common/app_resource.dart';
import 'package:dni_ecommerce/api/common/app_status.dart';
import 'package:dni_ecommerce/provider/common/app_provider.dart';
import 'package:dni_ecommerce/repository/history_repsitory.dart';
import 'package:dni_ecommerce/utils/utils.dart';
import 'package:dni_ecommerce/viewobject/product.dart';
import 'package:flutter/material.dart';

class HistoryProvider extends AppProvider {
  HistoryProvider({@required HistoryRepository repo, int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    print('History Provider: $hashCode');

    historyListStream =
        StreamController<AppResource<List<Product>>>.broadcast();
    subscription =
        historyListStream.stream.listen((AppResource<List<Product>> resource) {
      updateOffset(resource.data.length);

      _historyList = resource;

      if (resource.status != AppStatus.BLOCK_LOADING &&
          resource.status != AppStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  HistoryRepository _repo;

  AppResource<List<Product>> _historyList =
      AppResource<List<Product>>(AppStatus.NOACTION, '', <Product>[]);

  AppResource<List<Product>> get historyList => _historyList;
  StreamSubscription<AppResource<List<Product>>> subscription;
  StreamController<AppResource<List<Product>>> historyListStream;
  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('History Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadHistoryList() async {
    isLoading = true;
    await _repo.getAllHistoryList(
        historyListStream, AppStatus.PROGRESS_LOADING);
  }

  Future<dynamic> addHistoryList(Product product) async {
    isLoading = true;
    await _repo.addAllHistoryList(
        historyListStream, AppStatus.PROGRESS_LOADING, product);
  }

  Future<void> resetHistoryList() async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    await _repo.getAllHistoryList(
        historyListStream, AppStatus.PROGRESS_LOADING);

    isLoading = false;
  }
}
