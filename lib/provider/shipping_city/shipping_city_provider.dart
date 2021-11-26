import 'dart:async';
import 'package:dni_ecommerce/api/common/app_resource.dart';
import 'package:dni_ecommerce/api/common/app_status.dart';
import 'package:dni_ecommerce/provider/common/app_provider.dart';
import 'package:dni_ecommerce/repository/shipping_city_repository.dart';
import 'package:dni_ecommerce/utils/utils.dart';
import 'package:dni_ecommerce/viewobject/common/api_status.dart';
import 'package:dni_ecommerce/viewobject/common/app_value_holder.dart';
import 'package:dni_ecommerce/viewobject/holder/shipping_city_parameter_holder.dart';
import 'package:dni_ecommerce/viewobject/shipping_city.dart';
import 'package:flutter/material.dart';

class ShippingCityProvider extends AppProvider {
  ShippingCityProvider(
      {@required ShippingCityRepository repo,
      @required this.psValueHolder,
      int limit = 0})
      : super(repo, limit) {
    _repo = repo;

    print('City Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    shippingCityListStream =
        StreamController<AppResource<List<ShippingCity>>>.broadcast();
    subscription = shippingCityListStream.stream
        .listen((AppResource<List<ShippingCity>> resource) {
      updateOffset(resource.data.length);

      _shippingCityList = resource;

      if (resource.status != AppStatus.BLOCK_LOADING &&
          resource.status != AppStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }
  StreamController<AppResource<List<ShippingCity>>> shippingCityListStream;
  ShippingCityRepository _repo;
  AppValueHolder psValueHolder;

  AppResource<List<ShippingCity>> _shippingCityList =
      AppResource<List<ShippingCity>>(AppStatus.NOACTION, '', <ShippingCity>[]);

  AppResource<List<ShippingCity>> get shippingCityList => _shippingCityList;
  StreamSubscription<AppResource<List<ShippingCity>>> subscription;

  final AppResource<ApiStatus> _apiStatus =
      AppResource<ApiStatus>(AppStatus.NOACTION, '', null);
  AppResource<ApiStatus> get user => _apiStatus;
  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('City Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadShippingCityList(String shopId, String countryId) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    await _repo.getAllShippingCityList(
        shippingCityListStream,
        isConnectedToInternet,
        limit,
        offset,
        ShippingCityParameterHolder(shopId: shopId, countryId: countryId),
        AppStatus.PROGRESS_LOADING);
  }

  Future<dynamic> nextShippingCityList(String shopId, String countryId) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;
      await _repo.getNextPageShippingCityList(
          shippingCityListStream,
          isConnectedToInternet,
          limit,
          offset,
          ShippingCityParameterHolder(shopId: shopId, countryId: countryId),
          AppStatus.PROGRESS_LOADING);
    }
  }

  Future<void> resetShippingCityList(String shopId, String countryId) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    await _repo.getAllShippingCityList(
        shippingCityListStream,
        isConnectedToInternet,
        limit,
        offset,
        ShippingCityParameterHolder(shopId: shopId, countryId: countryId),
        AppStatus.PROGRESS_LOADING);

    isLoading = false;
  }
}
