import 'package:dni_ecommerce/viewobject/common/app_holder.dart';
import 'package:flutter/cupertino.dart';

class ShippingCountryParameterHolder
    extends AppHolder<ShippingCountryParameterHolder> {
  ShippingCountryParameterHolder({
    @required this.shopId,
  });

  final String shopId;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['shop_id'] = shopId;

    return map;
  }

  @override
  ShippingCountryParameterHolder fromMap(dynamic dynamicData) {
    return ShippingCountryParameterHolder(
      shopId: dynamicData['shop_id'],
    );
  }

  @override
  String getParamKey() {
    String key = '';

    if (shopId != '') {
      key += shopId;
    }
    return key;
  }
}
