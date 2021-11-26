import 'dart:async';

import 'package:dni_ecommerce/api/common/app_resource.dart';
import 'package:dni_ecommerce/api/common/app_status.dart';
import 'package:dni_ecommerce/provider/common/app_provider.dart';
import 'package:dni_ecommerce/repository/product_repository.dart';
import 'package:dni_ecommerce/utils/utils.dart';
import 'package:dni_ecommerce/viewobject/holder/product_parameter_holder.dart';
import 'package:dni_ecommerce/viewobject/product.dart';
import 'package:flutter/material.dart';

class DiscountProductProvider extends AppProvider {
  DiscountProductProvider({@required ProductRepository repo, int limit = 0})
      : super(repo, limit) {
    _repo = repo;

    print('DiscountProductProvider : $hashCode');
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    productListStream =
        StreamController<AppResource<List<Product>>>.broadcast();
    subscription =
        productListStream.stream.listen((AppResource<List<Product>> resource) {
      updateOffset(resource.data.length);

      _productList = Utils.removeDuplicateObj<Product>(resource);

      if (resource.status != AppStatus.BLOCK_LOADING &&
          resource.status != AppStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }
  ProductRepository _repo;
  AppResource<List<Product>> _productList =
      AppResource<List<Product>>(AppStatus.NOACTION, '', <Product>[]);

  AppResource<List<Product>> get productList => _productList;
  StreamSubscription<AppResource<List<Product>>> subscription;
  StreamController<AppResource<List<Product>>> productListStream;
  @override
  void dispose() {
    //_repo.cate.close();
    subscription.cancel();
    isDispose = true;
    print('Discount Product Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadProductList() async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    await _repo.getProductList(
        productListStream,
        isConnectedToInternet,
        limit,
        offset,
        AppStatus.PROGRESS_LOADING,
        ProductParameterHolder().getDiscountParameterHolder());
  }

  Future<dynamic> resetProductList() async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();
    updateOffset(0);
    await _repo.getProductList(
        productListStream,
        isConnectedToInternet,
        limit,
        offset,
        AppStatus.PROGRESS_LOADING,
        ProductParameterHolder().getDiscountParameterHolder());
  }

  Future<dynamic> nextProductList() async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;

      await _repo.getProductList(
          productListStream,
          isConnectedToInternet,
          limit,
          offset,
          AppStatus.PROGRESS_LOADING,
          ProductParameterHolder().getDiscountParameterHolder());
    }
  }
}
