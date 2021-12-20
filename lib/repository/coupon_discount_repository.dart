import 'dart:async';
import 'package:dni_ecommerce/api/app_api_service.dart';
import 'package:dni_ecommerce/api/common/app_resource.dart';
import 'package:dni_ecommerce/api/common/app_status.dart';
import 'package:dni_ecommerce/viewobject/coupon_discount.dart';
import 'package:flutter/material.dart';

import 'Common/app_repository.dart';

class CouponDiscountRepository extends AppRepository {
  CouponDiscountRepository({
    @required AppApiService appApiService,
  }) {
    _appApiService = appApiService;
  }
  String primaryKey = 'id';
  AppApiService _appApiService;

  Future<AppResource<CouponDiscount>> postCouponDiscount(
      Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet,
      AppStatus status,
      {bool isLoadFromServer = true}) async {
    final AppResource<CouponDiscount> _resource =
        await _appApiService.postCouponDiscount(jsonMap);
    if (_resource.status == AppStatus.SUCCESS) {
      return _resource;
    } else {
      final Completer<AppResource<CouponDiscount>> completer =
          Completer<AppResource<CouponDiscount>>();
      completer.complete(_resource);
      return completer.future;
    }
  }
}
