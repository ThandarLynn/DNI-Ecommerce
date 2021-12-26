import 'dart:async';
import 'package:dni_ecommerce/repository/shipping_method_repository.dart';
import 'package:dni_ecommerce/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:dni_ecommerce/api/common/app_resource.dart';
import 'package:dni_ecommerce/api/common/app_status.dart';
import 'package:dni_ecommerce/provider/common/app_provider.dart';
import 'package:dni_ecommerce/viewobject/common/app_value_holder.dart';
import 'package:dni_ecommerce/viewobject/shipping_method.dart';

class ShippingMethodProvider extends AppProvider {
  ShippingMethodProvider(
      {@required ShippingMethodRepository repo,
      this.psValueHolder,
      this.defaultShippingId,
      int limit = 0})
      : super(repo, limit) {
    _repo = repo;

    print('ShippingMethod Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });
    shippingMethodListStream =
        StreamController<AppResource<List<ShippingMethod>>>.broadcast();
    subscription = shippingMethodListStream.stream
        .listen((AppResource<List<ShippingMethod>> resource) {
      updateOffset(resource.data.length);

      _shippingMethodList = resource;

      if (resource.status != AppStatus.BLOCK_LOADING &&
          resource.status != AppStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  ShippingMethod selectedShippingMethod;
  String selectedPrice = '0.0';
  String selectedShippingName;
  String defaultShippingId;
  String defaultShippingPrice = '0.0';
  String defaultShippingName;

  ShippingMethodRepository _repo;
  AppValueHolder psValueHolder;

  AppResource<List<ShippingMethod>> _shippingMethodList =
      AppResource<List<ShippingMethod>>(
          AppStatus.NOACTION, '', <ShippingMethod>[]);

  AppResource<List<ShippingMethod>> get shippingMethodList =>
      _shippingMethodList;
  StreamSubscription<AppResource<List<ShippingMethod>>> subscription;
  StreamController<AppResource<List<ShippingMethod>>> shippingMethodListStream;

  @override
  void dispose() {
    subscription.cancel();
    shippingMethodListStream.close();
    isDispose = true;
    print('ShippingMethod Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadShippingMethodList() async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo.getAllShippingMethod(shippingMethodListStream,
        isConnectedToInternet, limit, offset, AppStatus.PROGRESS_LOADING);
  }

  Future<void> resetShippingMethodList() async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    await _repo.getAllShippingMethod(shippingMethodListStream,
        isConnectedToInternet, limit, offset, AppStatus.PROGRESS_LOADING);

    isLoading = false;
  }
}
