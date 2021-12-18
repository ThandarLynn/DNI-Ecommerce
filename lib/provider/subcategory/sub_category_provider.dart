import 'dart:async';

import 'package:dni_ecommerce/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:dni_ecommerce/api/common/app_resource.dart';
import 'package:dni_ecommerce/api/common/app_status.dart';
import 'package:dni_ecommerce/provider/common/app_provider.dart';
import 'package:dni_ecommerce/repository/sub_category_repository.dart';
import 'package:dni_ecommerce/viewobject/common/app_value_holder.dart';
import 'package:dni_ecommerce/viewobject/holder/product_parameter_holder.dart';
import 'package:dni_ecommerce/viewobject/sub_category.dart';

class SubCategoryProvider extends AppProvider {
  SubCategoryProvider(
      {@required SubCategoryRepository repo, this.psValueHolder, int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    print('SubCategory Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    subCategoryListStream =
        StreamController<AppResource<List<SubCategory>>>.broadcast();
    subscription = subCategoryListStream.stream.listen((dynamic resource) {
      updateOffset(resource.data.length);

      _subCategoryList = resource;

      if (resource.status != AppStatus.BLOCK_LOADING &&
          resource.status != AppStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  StreamController<AppResource<List<SubCategory>>> subCategoryListStream;
  SubCategoryRepository _repo;
  AppValueHolder psValueHolder;

  AppResource<List<SubCategory>> _subCategoryList =
      AppResource<List<SubCategory>>(AppStatus.NOACTION, '', <SubCategory>[]);

  AppResource<List<SubCategory>> get subCategoryList => _subCategoryList;
  StreamSubscription<AppResource<List<SubCategory>>> subscription;

  String categoryId = '';
  ProductParameterHolder subCategoryByCatIdParamenterHolder =
      ProductParameterHolder().getSubCategoryByCatIdParameterHolder();

  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('SubCategory Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadSubCategoryList(String categoryId) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo.getSubCategoryListByCategoryId(
        subCategoryListStream,
        isConnectedToInternet,
        limit,
        offset,
        AppStatus.PROGRESS_LOADING,
        categoryId);
  }

  Future<dynamic> loadAllSubCategoryList(String categoryId) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo.getAllSubCategoryListByCategoryId(subCategoryListStream,
        isConnectedToInternet, AppStatus.PROGRESS_LOADING, categoryId);
  }

  Future<dynamic> nextSubCategoryList(String categoryId) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;

      await _repo.getNextPageSubCategoryList(
          subCategoryListStream,
          isConnectedToInternet,
          limit,
          offset,
          AppStatus.PROGRESS_LOADING,
          categoryId);
    }
  }

  Future<void> resetSubCategoryList(String categoryId) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    isLoading = true;

    updateOffset(0);

    await _repo.getSubCategoryListByCategoryId(
        subCategoryListStream,
        isConnectedToInternet,
        limit,
        offset,
        AppStatus.PROGRESS_LOADING,
        categoryId);

    isLoading = false;
  }
}
