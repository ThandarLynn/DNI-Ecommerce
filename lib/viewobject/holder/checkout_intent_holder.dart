import 'package:flutter/cupertino.dart';

import '../basket.dart';

class CheckoutIntentHolder {
  const CheckoutIntentHolder({
    @required this.basketList,
  });
  final List<Basket> basketList;
}
