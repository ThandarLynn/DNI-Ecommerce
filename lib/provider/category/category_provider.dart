import 'dart:async';
import 'package:dni_ecommerce/api/common/app_resource.dart';
import 'package:dni_ecommerce/api/common/app_status.dart';
import 'package:dni_ecommerce/utils/utils.dart';
import 'package:dni_ecommerce/viewobject/common/app_value_holder.dart';
import 'package:dni_ecommerce/viewobject/holder/category_parameter_holder.dart';
import 'package:flutter/material.dart';
import 'package:dni_ecommerce/provider/common/app_provider.dart';
import 'package:dni_ecommerce/repository/category_repository.dart';
import 'package:dni_ecommerce/viewobject/category.dart';

class CategoryProvider extends AppProvider {
  CategoryProvider(
      {@required CategoryRepository repo,
      @required this.psValueHolder,
      int limit = 0})
      : super(repo, limit) {
    _repo = repo;

    print('Category Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    categoryListStream =
        StreamController<AppResource<List<Category>>>.broadcast();
    subscription = categoryListStream.stream
        .listen((AppResource<List<Category>> resource) {
      updateOffset(resource.data.length);

      _categoryList = resource;

      if (resource.status != AppStatus.BLOCK_LOADING &&
          resource.status != AppStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }
  StreamController<AppResource<List<Category>>> categoryListStream;
  final CategoryParameterHolder category = CategoryParameterHolder();

  CategoryRepository _repo;
  AppValueHolder psValueHolder;

  AppResource<List<Category>> _categoryList =
      AppResource<List<Category>>(AppStatus.NOACTION, '', <Category>[]);

  AppResource<List<Category>> get categoryList => _categoryList;
  StreamSubscription<AppResource<List<Category>>> subscription;

  final AppResource<AppStatus> _apiStatus =
      AppResource<AppStatus>(AppStatus.NOACTION, '', null);
  AppResource<AppStatus> get user => _apiStatus;
  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('Category Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadCategoryList() async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();
    if (isConnectedToInternet) {
      await _repo.getCategoryList(
          categoryListStream,
          isConnectedToInternet,
          limit,
          offset,
          CategoryParameterHolder().getLatestParameterHolder(),
          AppStatus.PROGRESS_LOADING);
    }
    return isConnectedToInternet;
  }

  // Future<dynamic> loadAllCategoryList(Map<dynamic, dynamic> jsonMap) async {
  //   isLoading = true;

  //   isConnectedToInternet = await Utils.checkInternetConnectivity();
  //   if (isConnectedToInternet) {
  //     await _repo.getAllCategoryList(
  //         categoryListStream,
  //         isConnectedToInternet,
  //         CategoryParameterHolder().getLatestParameterHolder(),
  //         AppStatus.PROGRESS_LOADING);
  //   }
  //   return isConnectedToInternet;
  // }

  Future<dynamic> nextCategoryList(Map<dynamic, dynamic> jsonMap) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;
      await _repo.getNextPageCategoryList(
          categoryListStream,
          isConnectedToInternet,
          limit,
          offset,
          CategoryParameterHolder().getLatestParameterHolder(),
          AppStatus.PROGRESS_LOADING);
    }
  }

  Future<void> resetCategoryList(Map<dynamic, dynamic> jsonMap) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);
    if (isConnectedToInternet) {
      await _repo.getCategoryList(
          categoryListStream,
          isConnectedToInternet,
          limit,
          offset,
          CategoryParameterHolder().getLatestParameterHolder(),
          AppStatus.PROGRESS_LOADING);
    }
    isLoading = false;
    return isConnectedToInternet;
  }

  // Future<dynamic> postTouchCount(
  //   Map<dynamic, dynamic> jsonMap,
  // ) async {
  //   isLoading = true;

  //   isConnectedToInternet = await Utils.checkInternetConnectivity();

  //   _apiStatus = await _repo.postTouchCount(
  //       jsonMap, isConnectedToInternet, AppStatus.PROGRESS_LOADING);

  //   return _apiStatus;
  // }
}
