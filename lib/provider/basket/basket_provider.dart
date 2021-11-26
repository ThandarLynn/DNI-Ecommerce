import 'dart:async';
import 'package:dni_ecommerce/api/common/app_resource.dart';
import 'package:dni_ecommerce/api/common/app_status.dart';
import 'package:dni_ecommerce/provider/common/app_provider.dart';
import 'package:dni_ecommerce/repository/basket_repository.dart';
import 'package:dni_ecommerce/utils/utils.dart';
import 'package:dni_ecommerce/viewobject/basket.dart';
import 'package:dni_ecommerce/viewobject/common/app_value_holder.dart';
import 'package:flutter/material.dart';

import 'helper/checkout_calculation_helper.dart';

class BasketProvider extends AppProvider {
  BasketProvider(
      {@required BasketRepository repo, this.psValueHolder, int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    print('Basket Provider: $hashCode');
    basketListStream = StreamController<AppResource<List<Basket>>>.broadcast();
    subscription =
        basketListStream.stream.listen((AppResource<List<Basket>> resource) {
      updateOffset(resource.data.length);

      _basketList = resource;

      if (resource.status != AppStatus.BLOCK_LOADING &&
          resource.status != AppStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }
  StreamController<AppResource<List<Basket>>> basketListStream;
  BasketRepository _repo;
  AppValueHolder psValueHolder;
  dynamic daoSubscription;

  AppResource<List<Basket>> _basketList =
      AppResource<List<Basket>>(AppStatus.NOACTION, '', <Basket>[]);

  AppResource<List<Basket>> get basketList => _basketList;
  StreamSubscription<AppResource<List<Basket>>> subscription;

  final CheckoutCalculationHelper checkoutCalculationHelper =
      CheckoutCalculationHelper();

  @override
  void dispose() {
    subscription.cancel();
    if (daoSubscription != null) {
      daoSubscription.cancel();
    }
    isDispose = true;
    print('Basket Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadBasketList() async {
    isLoading = true;
    daoSubscription = await _repo.getAllBasketList(
        basketListStream, AppStatus.PROGRESS_LOADING);
  }

  Future<dynamic> addBasket(Basket product) async {
    isLoading = true;
    await _repo.addAllBasket(
      basketListStream,
      AppStatus.PROGRESS_LOADING,
      product,
    );
  }

  Future<dynamic> updateBasket(Basket product) async {
    isLoading = true;
    await _repo.updateBasket(
      basketListStream,
      product,
    );
  }

  Future<dynamic> deleteBasketByProduct(Basket product) async {
    isLoading = true;
    await _repo.deleteBasketByProduct(basketListStream, product);
  }

  Future<dynamic> deleteWholeBasketList() async {
    isLoading = true;
    await _repo.deleteWholeBasketList(basketListStream);
  }

  Future<void> resetBasketList() async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    _repo.getAllBasketList(
      basketListStream,
      AppStatus.PROGRESS_LOADING,
    );

    isLoading = false;
  }
}
