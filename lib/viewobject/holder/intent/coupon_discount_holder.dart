import 'package:dni_ecommerce/viewobject/common/app_holder.dart';
import 'package:flutter/cupertino.dart';

class CouponDiscountParameterHolder
    extends AppHolder<CouponDiscountParameterHolder> {
  CouponDiscountParameterHolder({
    @required this.couponCode,
  });

  final String couponCode;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['coupon_code'] = couponCode;
    return map;
  }

  @override
  CouponDiscountParameterHolder fromMap(dynamic dynamicData) {
    return CouponDiscountParameterHolder(
      couponCode: dynamicData['coupon_code'],
    );
  }

  @override
  String getParamKey() {
    String key = '';

    if (couponCode != '') {
      key += couponCode;
    }

    return key;
  }
}
