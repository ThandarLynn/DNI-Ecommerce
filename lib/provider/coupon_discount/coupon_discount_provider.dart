import 'dart:async';
import 'package:dni_ecommerce/api/common/app_resource.dart';
import 'package:dni_ecommerce/api/common/app_status.dart';
import 'package:dni_ecommerce/provider/common/app_provider.dart';
import 'package:dni_ecommerce/repository/coupon_discount_repository.dart';
import 'package:dni_ecommerce/utils/utils.dart';
import 'package:dni_ecommerce/viewobject/coupon_discount.dart';
import 'package:flutter/material.dart';

class CouponDiscountProvider extends AppProvider {
  CouponDiscountProvider(
      {@required CouponDiscountRepository repo, int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    print('CouponDiscount Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });
  }

  CouponDiscountRepository _repo;
  String couponDiscount = '0.0';

  AppResource<CouponDiscount> _couponDiscount =
      AppResource<CouponDiscount>(AppStatus.NOACTION, '', null);
  AppResource<CouponDiscount> get user => _couponDiscount;
  @override
  void dispose() {
    isDispose = true;
    print('CouponDiscount Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> postCouponDiscount(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _couponDiscount = await _repo.postCouponDiscount(
        jsonMap, isConnectedToInternet, AppStatus.PROGRESS_LOADING);

    return _couponDiscount;
  }
}
