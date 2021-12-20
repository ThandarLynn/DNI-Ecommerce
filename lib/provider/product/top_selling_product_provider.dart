import 'dart:async';

import 'package:dni_ecommerce/api/common/app_resource.dart';
import 'package:dni_ecommerce/api/common/app_status.dart';
import 'package:dni_ecommerce/provider/common/app_provider.dart';
import 'package:dni_ecommerce/repository/product_repository.dart';
import 'package:dni_ecommerce/utils/utils.dart';
import 'package:dni_ecommerce/viewobject/common/app_value_holder.dart';
import 'package:dni_ecommerce/viewobject/product.dart';
import 'package:flutter/cupertino.dart';

class TopSellingProductProvider extends AppProvider {
  TopSellingProductProvider(
      {@required ProductRepository repo,
      @required this.appValueHolder,
      int limit = 0})
      : super(repo, limit) {
    _repo = repo;

    print('Top Selling Product Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    topSellingListStream =
        StreamController<AppResource<List<Product>>>.broadcast();
    subscription = topSellingListStream.stream
        .listen((AppResource<List<Product>> resource) {
      updateOffset(resource.data.length);

      _topSellingProductList = Utils.removeDuplicateObj<Product>(resource);

      if (resource.status != AppStatus.BLOCK_LOADING &&
          resource.status != AppStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  StreamController<AppResource<List<Product>>> topSellingListStream;

  ProductRepository _repo;
  AppValueHolder appValueHolder;

  AppResource<List<Product>> _topSellingProductList =
      AppResource<List<Product>>(AppStatus.NOACTION, '', <Product>[]);

  AppResource<List<Product>> get topSellingProductList =>
      _topSellingProductList;
  StreamSubscription<AppResource<List<Product>>> subscription;

  @override
  void dispose() {
    //_repo.cate.close();
    subscription.cancel();
    // topSellingListStream.close();
    isDispose = true;
    print('Favourite Product Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadTopSellingProductList() async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo.getTopSellingProductList(topSellingListStream,
        isConnectedToInternet, limit, offset, AppStatus.PROGRESS_LOADING);
  }

  Future<dynamic> nextTopSellingProductList() async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;
      await _repo.getNextPageTopSellingProductList(topSellingListStream,
          isConnectedToInternet, limit, offset, AppStatus.PROGRESS_LOADING);
    }
  }

  Future<void> resetTopSellingProductList() async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    await _repo.getTopSellingProductList(topSellingListStream,
        isConnectedToInternet, limit, offset, AppStatus.PROGRESS_LOADING);

    isLoading = false;
  }
}
