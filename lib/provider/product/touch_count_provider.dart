import 'dart:async';

import 'package:dni_ecommerce/api/common/app_resource.dart';
import 'package:dni_ecommerce/api/common/app_status.dart';
import 'package:dni_ecommerce/provider/common/app_provider.dart';
import 'package:dni_ecommerce/repository/product_repository.dart';
import 'package:dni_ecommerce/utils/utils.dart';
import 'package:dni_ecommerce/viewobject/common/api_status.dart';
import 'package:dni_ecommerce/viewobject/common/app_value_holder.dart';
import 'package:flutter/cupertino.dart';

class TouchCountProvider extends AppProvider {
  TouchCountProvider(
      {@required ProductRepository repo,
      @required this.appValueHolder,
      int limit = 0})
      : super(repo, limit) {
    _repo = repo;

    print('TouchCount Product Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });
  }

  ProductRepository _repo;
  AppValueHolder appValueHolder;

  AppResource<ApiStatus> _apiStatus =
      AppResource<ApiStatus>(AppStatus.NOACTION, '', null);
  AppResource<ApiStatus> get user => _apiStatus;

  @override
  void dispose() {
    isDispose = true;
    print('TouchCount Product Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> postTouchCount(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _apiStatus = await _repo.postTouchCount(
        jsonMap, isConnectedToInternet, AppStatus.PROGRESS_LOADING);

    return _apiStatus;
  }
}
