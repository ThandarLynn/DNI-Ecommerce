import 'dart:async';

import 'package:dni_ecommerce/api/common/app_resource.dart';
import 'package:dni_ecommerce/api/common/app_status.dart';
import 'package:dni_ecommerce/provider/common/app_provider.dart';
import 'package:dni_ecommerce/repository/product_repository.dart';
import 'package:dni_ecommerce/utils/utils.dart';
import 'package:dni_ecommerce/viewobject/holder/product_parameter_holder.dart';
import 'package:dni_ecommerce/viewobject/product.dart';
import 'package:flutter/material.dart';

class SearchProductProvider extends AppProvider {
  SearchProductProvider({@required ProductRepository repo, int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    print('SearchProductProvider : $hashCode');
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

  ProductParameterHolder productParameterHolder;

  bool isSwitchedFeaturedProduct = false;
  bool isSwitchedDiscountPrice = false;

  String selectedCategoryName = '';
  String selectedSubCategoryName = '';

  String categoryId = '';
  String subCategoryId = '';

  bool isfirstRatingClicked = false;
  bool isSecondRatingClicked = false;
  bool isThirdRatingClicked = false;
  bool isfouthRatingClicked = false;
  bool isFifthRatingClicked = false;

  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('Search Product Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadProductListByKey(
      ProductParameterHolder productParameterHolder) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;
    await _repo.getProductList(productListStream, isConnectedToInternet, limit,
        offset, AppStatus.PROGRESS_LOADING, productParameterHolder);
  }

  Future<dynamic> nextProductListByKey(
      ProductParameterHolder productParameterHolder) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;
      print('*** Next Page Loading $limit $offset');
      await _repo.getNextPageProductList(
          productListStream,
          isConnectedToInternet,
          limit,
          offset,
          AppStatus.PROGRESS_LOADING,
          productParameterHolder);
    }
  }

  Future<void> resetLatestProductList(
      ProductParameterHolder productParameterHolder) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    updateOffset(0);

    isLoading = true;

    await _repo.getProductList(productListStream, isConnectedToInternet, limit,
        offset, AppStatus.PROGRESS_LOADING, productParameterHolder);
  }
}
