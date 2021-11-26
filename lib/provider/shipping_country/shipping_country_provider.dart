import 'dart:async';
import 'package:dni_ecommerce/api/common/app_resource.dart';
import 'package:dni_ecommerce/api/common/app_status.dart';
import 'package:dni_ecommerce/provider/common/app_provider.dart';
import 'package:dni_ecommerce/repository/shipping_country_repository.dart';
import 'package:dni_ecommerce/utils/utils.dart';
import 'package:dni_ecommerce/viewobject/common/api_status.dart';
import 'package:dni_ecommerce/viewobject/common/app_value_holder.dart';
import 'package:dni_ecommerce/viewobject/holder/shipping_country_parameter_holder.dart';
import 'package:dni_ecommerce/viewobject/shipping_country.dart';
import 'package:flutter/material.dart';

class ShippingCountryProvider extends AppProvider {
  ShippingCountryProvider(
      {@required ShippingCountryRepository repo,
      @required this.psValueHolder,
      int limit = 0})
      : super(repo, limit) {
    _repo = repo;

    //isDispose = false;
    print('ShippingCountry Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    shippingCountryListStream =
        StreamController<AppResource<List<ShippingCountry>>>.broadcast();
    subscription = shippingCountryListStream.stream
        .listen((AppResource<List<ShippingCountry>> resource) {
      updateOffset(resource.data.length);

      _shippingCountryList = resource;

      if (resource.status != AppStatus.BLOCK_LOADING &&
          resource.status != AppStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }
  StreamController<AppResource<List<ShippingCountry>>>
      shippingCountryListStream;
  ShippingCountryRepository _repo;
  AppValueHolder psValueHolder;

  AppResource<List<ShippingCountry>> _shippingCountryList =
      AppResource<List<ShippingCountry>>(
          AppStatus.NOACTION, '', <ShippingCountry>[]);

  AppResource<List<ShippingCountry>> get shippingCountryList =>
      _shippingCountryList;
  StreamSubscription<AppResource<List<ShippingCountry>>> subscription;

  final AppResource<ApiStatus> _apiStatus =
      AppResource<ApiStatus>(AppStatus.NOACTION, '', null);
  AppResource<ApiStatus> get user => _apiStatus;
  @override
  void dispose() {
    //_repo.cate.close();
    subscription.cancel();
    isDispose = true;
    print('ShippingCountry Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadShippingCountryList(String shopId) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    await _repo.getAllShippingCountryList(
        shippingCountryListStream,
        isConnectedToInternet,
        limit,
        offset,
        ShippingCountryParameterHolder(shopId: shopId),
        AppStatus.PROGRESS_LOADING);
  }

  Future<dynamic> nextShippingCountryList(String shopId) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;
      await _repo.getNextPageShippingCountryList(
          shippingCountryListStream,
          isConnectedToInternet,
          limit,
          offset,
          ShippingCountryParameterHolder(shopId: shopId),
          AppStatus.PROGRESS_LOADING);
    }
  }

  Future<void> resetShippingCountryList(String shopId) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    await _repo.getAllShippingCountryList(
        shippingCountryListStream,
        isConnectedToInternet,
        limit,
        offset,
        ShippingCountryParameterHolder(shopId: shopId),
        AppStatus.PROGRESS_LOADING);

    isLoading = false;
  }
}
