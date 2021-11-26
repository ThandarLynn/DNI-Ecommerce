import 'package:dni_ecommerce/provider/basket/basket_provider.dart';
import 'package:dni_ecommerce/provider/transaction/transaction_header_provider.dart';
import 'package:dni_ecommerce/provider/user/user_provider.dart';
import 'package:dni_ecommerce/viewobject/common/app_value_holder.dart';
import 'package:flutter/cupertino.dart';

import '../../basket.dart';

class CreditCardIntentHolder {
  const CreditCardIntentHolder({
    @required this.basketList,
    @required this.couponDiscount,
    @required this.psValueHolder,
    @required this.transactionSubmitProvider,
    @required this.userProvider,
    @required this.basketProvider,
    @required this.memoText,
    @required this.publishKey,
    @required this.payStackKey,
  });

  final List<Basket> basketList;
  final String couponDiscount;
  final AppValueHolder psValueHolder;
  final TransactionHeaderProvider transactionSubmitProvider;
  final UserProvider userProvider;
  final BasketProvider basketProvider;
  final String memoText;
  final String publishKey;
  final String payStackKey;
}
