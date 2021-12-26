// import 'package:dni_ecommerce/api/common/app_resource.dart';
import 'package:dni_ecommerce/config/app_colors.dart';
import 'package:dni_ecommerce/constant/app_constant.dart';
import 'package:dni_ecommerce/constant/app_dimens.dart';
// import 'package:dni_ecommerce/constant/route_paths.dart';
import 'package:dni_ecommerce/provider/basket/basket_provider.dart';
import 'package:dni_ecommerce/provider/coupon_discount/coupon_discount_provider.dart';
import 'package:dni_ecommerce/provider/token/token_provider.dart';
import 'package:dni_ecommerce/provider/transaction/transaction_detail_provider.dart';
import 'package:dni_ecommerce/provider/transaction/transaction_header_provider.dart';
import 'package:dni_ecommerce/provider/user/user_provider.dart';
// import 'package:dni_ecommerce/ui/common/dialog/error_dialog.dart';
// import 'package:dni_ecommerce/utils/app_progress_dialog.dart';
import 'package:dni_ecommerce/utils/utils.dart';
import 'package:dni_ecommerce/viewobject/basket.dart';
import 'package:dni_ecommerce/viewobject/common/app_value_holder.dart';
// import 'package:dni_ecommerce/viewobject/holder/intent/checkout_status_intent_holder.dart';
// import 'package:dni_ecommerce/viewobject/transaction_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

class Checkout3View extends StatefulWidget {
  const Checkout3View(this.updateCheckout3ViewState, this.basketList);

  final Function updateCheckout3ViewState;

  final List<Basket> basketList;

  @override
  _Checkout3ViewState createState() {
    final _Checkout3ViewState _state = _Checkout3ViewState();
    updateCheckout3ViewState(_state);
    return _state;
  }
}

class _Checkout3ViewState extends State<Checkout3View> {
  bool isCheckBoxSelect = false;
  bool isCashClicked = false;
  bool isPaypalClicked = false;
  bool isStripeClicked = false;
  bool isBankClicked = false;
  bool isRazorClicked = false;
  bool isPayStackClicked = false;

  AppValueHolder valueHolder;
  CouponDiscountProvider couponDiscountProvider;
  BasketProvider basketProvider;
  final TextEditingController memoController = TextEditingController();
  TransactionDetailProvider transactionDetailProvider;

  void checkStatus() {
    print('Checking Status ... $isCheckBoxSelect');
  }

  dynamic callBankNow(
    BasketProvider basketProvider,
    UserProvider userLoginProvider,
    TransactionHeaderProvider transactionSubmitProvider,
  ) async {
    await transactionSubmitProvider.addTransaction(
        userLoginProvider.user.data,
        widget.basketList,
        '',
        couponDiscountProvider.couponDiscount.toString(),
        basketProvider.checkoutCalculationHelper.tax.toString(),
        basketProvider.checkoutCalculationHelper.totalDiscount.toString(),
        basketProvider.checkoutCalculationHelper.subTotalPrice.toString(),
        basketProvider.checkoutCalculationHelper.shippingTax.toString(),
        basketProvider.checkoutCalculationHelper.totalPrice.toString(),
        basketProvider.checkoutCalculationHelper.totalOriginalPrice.toString(),
        AppConst.ONE,
        AppConst.ZERO,
        AppConst.ZERO,
        AppConst.ZERO,
        AppConst.ZERO,
        AppConst.ZERO,
        '',
        // basketProvider.checkoutCalculationHelper.shippingCost.toString(),
        basketProvider.selectedDays,
        memoController.text);
    await transactionDetailProvider.addTransactionDetail(
        userLoginProvider.user.data,
        widget.basketList,
        '',
        couponDiscountProvider.couponDiscount.toString(),
        basketProvider.checkoutCalculationHelper.tax.toString(),
        basketProvider.checkoutCalculationHelper.totalDiscount.toString(),
        basketProvider.checkoutCalculationHelper.subTotalPrice.toString(),
        basketProvider.checkoutCalculationHelper.shippingTax.toString(),
        basketProvider.checkoutCalculationHelper.totalPrice.toString(),
        basketProvider.checkoutCalculationHelper.totalOriginalPrice.toString(),
        AppConst.ONE,
        AppConst.ZERO,
        AppConst.ZERO,
        AppConst.ZERO,
        AppConst.ZERO,
        AppConst.ZERO,
        '',
        // basketProvider.checkoutCalculationHelper.shippingCost.toString(),
        basketProvider.selectedDays,
        memoController.text);

    // //     if (_apiStatus.data != null) {
    // // AppProgressDialog.dismissDialog();

    await basketProvider.deleteWholeBasketList();
    Navigator.pop(context, true);
    // if (await Utils.checkInternetConnectivity()) {
    //   if (userLoginProvider.user != null &&
    //       userLoginProvider.user.data != null) {
    //     await AppProgressDialog.showDialog(context);
    //     final AppResource<TransactionHeader> _apiStatus =
    //         await transactionSubmitProvider.postTransactionSubmit(
    //             userLoginProvider.user.data,
    //             widget.basketList,
    //             '',
    //             couponDiscountProvider.couponDiscount.toString(),
    //             basketProvider.checkoutCalculationHelper.tax.toString(),
    //             basketProvider.checkoutCalculationHelper.totalDiscount
    //                 .toString(),
    //             basketProvider.checkoutCalculationHelper.subTotalPrice
    //                 .toString(),
    //             basketProvider.checkoutCalculationHelper.shippingTax.toString(),
    //             basketProvider.checkoutCalculationHelper.totalPrice.toString(),
    //             basketProvider.checkoutCalculationHelper.totalOriginalPrice
    //                 .toString(),
    //             AppConst.ZERO,
    //             AppConst.ZERO,
    //             AppConst.ZERO,
    //             AppConst.ONE,
    //             AppConst.ZERO,
    //             AppConst.ZERO,
    //             '',
    //             basketProvider.checkoutCalculationHelper.shippingCost
    //                 .toString(),
    //             'Free',
    //             memoController.text);

    //     if (_apiStatus.data != null) {
    //       AppProgressDialog.dismissDialog();

    //       await basketProvider.deleteWholeBasketList();
    //       Navigator.pop(context, true);
    //       await Navigator.pushNamed(context, RoutePaths.checkoutSuccess,
    //           arguments: CheckoutStatusIntentHolder(
    //             transactionHeader: _apiStatus.data,
    //           ));
    //     } else {
    //       AppProgressDialog.dismissDialog();

    //       return showDialog<dynamic>(
    //           context: context,
    //           builder: (BuildContext context) {
    //             return ErrorDialog(
    //               message: _apiStatus.message,
    //             );
    //           });
    //     }
    //   }
    // } else {
    //   showDialog<dynamic>(
    //       context: context,
    //       builder: (BuildContext context) {
    //         return ErrorDialog(
    //           message: Utils.getString('error_dialog__no_internet'),
    //         );
    //       });
    // }
  }

  dynamic callCardNow(
    BasketProvider basketProvider,
    UserProvider userLoginProvider,
    TransactionHeaderProvider transactionSubmitProvider,
  ) async {
    // transactionDetailProvider = Provider.of<TransactionDetailProvider>(context);
    // if (await Utils.checkInternetConnectivity()) {
    //   if (userLoginProvider.user != null &&
    //       userLoginProvider.user.data != null) {
    //     await AppProgressDialog.showDialog(context);
    //     print(basketProvider
    //         .checkoutCalculationHelper.subTotalPriceFormattedString);
    //     final AppResource<TransactionHeader> _apiStatus =
    await transactionSubmitProvider.addTransaction(
        userLoginProvider.user.data,
        widget.basketList,
        '',
        couponDiscountProvider.couponDiscount.toString(),
        basketProvider.checkoutCalculationHelper.tax.toString(),
        basketProvider.checkoutCalculationHelper.totalDiscount.toString(),
        basketProvider.checkoutCalculationHelper.subTotalPrice.toString(),
        basketProvider.checkoutCalculationHelper.shippingTax.toString(),
        basketProvider.checkoutCalculationHelper.totalPrice.toString(),
        basketProvider.checkoutCalculationHelper.totalOriginalPrice.toString(),
        AppConst.ONE,
        AppConst.ZERO,
        AppConst.ZERO,
        AppConst.ZERO,
        AppConst.ZERO,
        AppConst.ZERO,
        '',
        // basketProvider.checkoutCalculationHelper.shippingCost.toString(),
        basketProvider.selectedDays,
        memoController.text);
    await transactionDetailProvider.addTransactionDetail(
        userLoginProvider.user.data,
        widget.basketList,
        '',
        couponDiscountProvider.couponDiscount.toString(),
        basketProvider.checkoutCalculationHelper.tax.toString(),
        basketProvider.checkoutCalculationHelper.totalDiscount.toString(),
        basketProvider.checkoutCalculationHelper.subTotalPrice.toString(),
        basketProvider.checkoutCalculationHelper.shippingTax.toString(),
        basketProvider.checkoutCalculationHelper.totalPrice.toString(),
        basketProvider.checkoutCalculationHelper.totalOriginalPrice.toString(),
        AppConst.ONE,
        AppConst.ZERO,
        AppConst.ZERO,
        AppConst.ZERO,
        AppConst.ZERO,
        AppConst.ZERO,
        '',
        // basketProvider.checkoutCalculationHelper.shippingCost.toString(),
        basketProvider.selectedDays,
        memoController.text);

    // //     if (_apiStatus.data != null) {
    // // AppProgressDialog.dismissDialog();

    await basketProvider.deleteWholeBasketList();
    Navigator.pop(context, true);
    // await Navigator.pushNamed(context, RoutePaths.checkoutSuccess,
    //     arguments: CheckoutStatusIntentHolder(
    //       transactionHeader: _apiStatus.data,
    //     ));
    //     } else {
    //       AppProgressDialog.dismissDialog();

    //       return showDialog<dynamic>(
    //           context: context,
    //           builder: (BuildContext context) {
    //             return ErrorDialog(
    //               message: _apiStatus.message,
    //             );
    //           });
    //     }
    //   }
    // } else {
    //   showDialog<dynamic>(
    //       context: context,
    //       builder: (BuildContext context) {
    //         return ErrorDialog(
    //           message: Utils.getString('error_dialog__no_internet'),
    //         );
    //       });
    // }
  }

  // Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
  //   // Do something when payment succeeds
  //   print('success');

  //   print(response);

  //   await AppProgressDialog.showDialog(context);
  //   final UserProvider userProvider =
  //       Provider.of<UserProvider>(context, listen: false);
  //   final TransactionHeaderProvider transactionSubmitProvider =
  //       Provider.of<TransactionHeaderProvider>(context, listen: false);
  //   final BasketProvider basketProvider =
  //       Provider.of<BasketProvider>(context, listen: false);
  //   if (userProvider.user != null && userProvider.user.data != null) {
  //     final AppResource<TransactionHeader> _apiStatus =
  //         await transactionSubmitProvider.postTransactionSubmit(
  //             userProvider.user.data,
  //             widget.basketList,
  //             '',
  //             couponDiscountProvider.couponDiscount.toString(),
  //             basketProvider.checkoutCalculationHelper.tax.toString(),
  //             basketProvider.checkoutCalculationHelper.totalDiscount.toString(),
  //             basketProvider.checkoutCalculationHelper.subTotalPrice.toString(),
  //             basketProvider.checkoutCalculationHelper.shippingTax.toString(),
  //             basketProvider.checkoutCalculationHelper.totalPrice.toString(),
  //             basketProvider.checkoutCalculationHelper.totalOriginalPrice
  //                 .toString(),
  //             AppConst.ZERO,
  //             AppConst.ZERO,
  //             AppConst.ZERO,
  //             AppConst.ZERO,
  //             AppConst.ZERO,
  //             AppConst.ONE,
  //             response.paymentId.toString(),
  //             basketProvider.checkoutCalculationHelper.shippingCost.toString(),
  //             'Free',
  //             memoController.text);

  //     if (_apiStatus.data != null) {
  //       AppProgressDialog.dismissDialog();

  //       if (_apiStatus.status == AppStatus.SUCCESS) {
  //         await basketProvider.deleteWholeBasketList();

  //         Navigator.pop(context, true);
  //         await Navigator.pushNamed(context, RoutePaths.checkoutSuccess,
  //             arguments: CheckoutStatusIntentHolder(
  //               transactionHeader: _apiStatus.data,
  //             ));
  //       } else {
  //         AppProgressDialog.dismissDialog();

  //         return showDialog<dynamic>(
  //             context: context,
  //             builder: (BuildContext context) {
  //               return ErrorDialog(
  //                 message: _apiStatus.message,
  //               );
  //             });
  //       }
  //     } else {
  //       AppProgressDialog.dismissDialog();

  //       return showDialog<dynamic>(
  //           context: context,
  //           builder: (BuildContext context) {
  //             return ErrorDialog(
  //               message: _apiStatus.message,
  //             );
  //           });
  //     }
  //   }
  // }

  // void _handlePaymentError(PaymentFailureResponse response) {
  //   // Do something when payment fails
  //   print('error');
  //   showDialog<dynamic>(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return ErrorDialog(
  //           message: Utils.getString('checkout3__payment_fail'),
  //         );
  //       });
  // }

  // void _handleExternalWallet(ExternalWalletResponse response) {
  //   // Do something when an external wallet is selected
  //   print('external wallet');
  //   showDialog<dynamic>(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return ErrorDialog(
  //           message: Utils.getString('checkout3__payment_not_supported'),
  //         );
  //       });
  // }

  dynamic payNow(
      String clientNonce,
      UserProvider userProvider,
      TransactionHeaderProvider transactionSubmitProvider,
      CouponDiscountProvider couponDiscountProvider,
      AppValueHolder appValueHolder,
      BasketProvider basketProvider) async {
    basketProvider.checkoutCalculationHelper.calculate(
        basketList: widget.basketList,
        couponDiscountString: couponDiscountProvider.couponDiscount,
        appValueHolder: appValueHolder,
        shippingPriceStringFormatting: '0.0');

    // final BraintreePayment braintreePayment = BraintreePayment();
    // final dynamic data = await braintreePayment.showDropIn(
    //     nonce: clientNonce,
    //     amount:
    //         basketProvider.checkoutCalculationHelper.totalPriceFormattedString,
    //     enableGooglePay: true);
    // print('${Utils.getString('checkout__payment_response')} $data');

    // if (await Utils.checkInternetConnectivity()) {
    //   if (data != null && data != 'error' && data != 'cancelled') {
    //     print(data);

    //     await AppProgressDialog.showDialog(context);

    //     if (userProvider.user != null && userProvider.user.data != null) {
    //       final AppResource<TransactionHeader> _apiStatus =
    //           await transactionSubmitProvider.postTransactionSubmit(
    //               userProvider.user.data,
    //               widget.basketList,
    //               Platform.isIOS ? data : data['paymentNonce'],
    //               couponDiscountProvider.couponDiscount.toString(),
    //               basketProvider.checkoutCalculationHelper.tax.toString(),
    //               basketProvider.checkoutCalculationHelper.totalDiscount
    //                   .toString(),
    //               basketProvider.checkoutCalculationHelper.subTotalPrice
    //                   .toString(),
    //               basketProvider.checkoutCalculationHelper.shippingTax
    //                   .toString(),
    //               basketProvider.checkoutCalculationHelper.totalPrice
    //                   .toString(),
    //               basketProvider.checkoutCalculationHelper.totalOriginalPrice
    //                   .toString(),
    //               AppConst.ZERO,
    //               AppConst.ONE,
    //               AppConst.ZERO,
    //               AppConst.ZERO,
    //               AppConst.ZERO,
    //               AppConst.ZERO,
    //               '',
    //               basketProvider.checkoutCalculationHelper.shippingCost
    //                   .toString(),
    //               'Free',
    //               memoController.text);

    //       if (_apiStatus.data != null) {
    //         AppProgressDialog.dismissDialog();

    //         if (_apiStatus.status == AppStatus.SUCCESS) {
    //           await basketProvider.deleteWholeBasketList();

    //           Navigator.pop(context, true);
    //           await Navigator.pushNamed(context, RoutePaths.checkoutSuccess,
    //               arguments: CheckoutStatusIntentHolder(
    //                 transactionHeader: _apiStatus.data,
    //               ));
    //         } else {
    //           AppProgressDialog.dismissDialog();

    //           return showDialog<dynamic>(
    //               context: context,
    //               builder: (BuildContext context) {
    //                 return ErrorDialog(
    //                   message: _apiStatus.message,
    //                 );
    //               });
    //         }
    //       } else {
    //         AppProgressDialog.dismissDialog();

    //         return showDialog<dynamic>(
    //             context: context,
    //             builder: (BuildContext context) {
    //               return ErrorDialog(
    //                 message: _apiStatus.message,
    //               );
    //             });
    //       }
    //     }
    //   }
    // } else {
    //   showDialog<dynamic>(
    //       context: context,
    //       builder: (BuildContext context) {
    //         return ErrorDialog(
    //           message: Utils.getString('error_dialog__no_internet'),
    //         );
    //       });
    // }
  }

  @override
  Widget build(BuildContext context) {
    valueHolder = Provider.of<AppValueHolder>(context);
    return Consumer<TransactionHeaderProvider>(builder: (BuildContext context,
        TransactionHeaderProvider transactionHeaderProvider, Widget child) {
      return Consumer<BasketProvider>(builder:
          (BuildContext context, BasketProvider basketProvider, Widget child) {
        return Consumer<UserProvider>(builder:
            (BuildContext context, UserProvider userProvider, Widget child) {
          return Consumer<TokenProvider>(builder: (BuildContext context,
              TokenProvider tokenProvider, Widget child) {
            // if (tokenProvider.tokenData != null &&
            //     tokenProvider.tokenData.data != null &&
            //     tokenProvider.tokenData.data.message != null) {
            couponDiscountProvider = Provider.of<CouponDiscountProvider>(
                context,
                listen: false); // Listen : False is important.
            basketProvider = Provider.of<BasketProvider>(context,
                listen: false); // Listen : False is important.
            transactionDetailProvider =
                Provider.of<TransactionDetailProvider>(context, listen: false);

            return SingleChildScrollView(
              child: Container(
                color: AppColors.backgroundColor,
                padding: const EdgeInsets.only(
                  left: AppDimens.space12,
                  right: AppDimens.space12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(
                      height: AppDimens.space16,
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          left: AppDimens.space16, right: AppDimens.space16),
                      child: Text(
                        Utils.getString('checkout3__payment_method_offline'),
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ),
                    const SizedBox(
                      height: AppDimens.space16,
                    ),
                    const Divider(
                      height: 2,
                    ),
                    const SizedBox(
                      height: AppDimens.space8,
                    ),
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: AppDimens.space140,
                              height: AppDimens.space140,
                              padding: const EdgeInsets.all(AppDimens.space8),
                              child: InkWell(
                                onTap: () {
                                  if (!isCashClicked) {
                                    isCashClicked = true;
                                    isPaypalClicked = false;
                                    isStripeClicked = false;
                                    isBankClicked = false;
                                    isRazorClicked = false;
                                    isPayStackClicked = false;
                                  }

                                  setState(() {});
                                },
                                child: checkIsCashSelected(),
                              ),
                            ),
                            Container(
                              width: AppDimens.space140,
                              height: AppDimens.space140,
                              padding: const EdgeInsets.all(AppDimens.space8),
                              child: InkWell(
                                onTap: () {
                                  if (!isBankClicked) {
                                    isCashClicked = false;
                                    isPaypalClicked = false;
                                    isStripeClicked = false;
                                    isBankClicked = true;
                                    isRazorClicked = false;
                                    isPayStackClicked = false;
                                  }

                                  setState(() {});
                                },
                                child: checkIsBankSelected(),
                              ),
                            ),
                          ],
                        )),
                    const SizedBox(
                      height: AppDimens.space12,
                    ),
                    // Container(
                    //   margin: const EdgeInsets.only(
                    //       left: AppDimens.space16, right: AppDimens.space16),
                    //   child: Text(
                    //     Utils.getString('checkout3__payment_method_online'),
                    //     style: Theme.of(context).textTheme.subtitle1,
                    //   ),
                    // ),
                    // const SizedBox(
                    //   height: AppDimens.space16,
                    // ),
                    // const Divider(
                    //   height: 2,
                    // ),
                    // const SizedBox(
                    //   height: AppDimens.space8,
                    // ),
                    // SingleChildScrollView(
                    //   scrollDirection: Axis.horizontal,
                    //   child: Row(
                    //     children: <Widget>[
                    //       Container(
                    //         width: AppDimens.space140,
                    //         height: AppDimens.space140,
                    //         padding: const EdgeInsets.all(AppDimens.space8),
                    //         child: InkWell(
                    //           onTap: () {
                    //             if (!isPaypalClicked) {
                    //               isCashClicked = false;
                    //               isPaypalClicked = true;
                    //               isStripeClicked = false;
                    //               isBankClicked = false;
                    //               isRazorClicked = false;
                    //               isPayStackClicked = false;
                    //             }

                    //             setState(() {});
                    //           },
                    //           child: checkIsPaypalSelected(),
                    //         ),
                    //       ),
                    //       Container(
                    //         width: AppDimens.space140,
                    //         height: AppDimens.space140,
                    //         padding: const EdgeInsets.all(AppDimens.space8),
                    //         child: InkWell(
                    //           onTap: () async {
                    //             if (!isStripeClicked) {
                    //               isCashClicked = false;
                    //               isPaypalClicked = false;
                    //               isStripeClicked = true;
                    //               isBankClicked = false;
                    //               isRazorClicked = false;
                    //               isPayStackClicked = false;
                    //             }

                    //             setState(() {});
                    //           },
                    //           child: checkIsStripeSelected(),
                    //         ),
                    //       ),

                    //     ],
                    //   ),
                    // ),
                    Container(
                      margin: const EdgeInsets.only(
                          left: AppDimens.space16, right: AppDimens.space16),
                      child: showOrHideCashText(),
                    ),
                    const SizedBox(
                      height: AppDimens.space8,
                    ),
                    const SizedBox(
                      height: AppDimens.space60,
                    ),
                  ],
                ),
              ),
            );
            // } else {
            //   return Container();
            // }
          });
        });
      });
    });
  }

  void updateCheckBox() {
    if (isCheckBoxSelect) {
      isCheckBoxSelect = false;
    } else {
      isCheckBoxSelect = true;
    }
  }

  Widget checkIsCashSelected() {
    if (!isCashClicked) {
      return changeCashCardToWhite();
    } else {
      return changeCashCardToOrange();
    }
  }

  Widget changeCashCardToWhite() {
    return Container(
        width: AppDimens.space140,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.coreBackgroundColor,
            borderRadius:
                const BorderRadius.all(Radius.circular(AppDimens.space8)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(
                height: AppDimens.space4,
              ),
              Container(
                  width: 50, height: 50, child: const Icon(Ionicons.md_cash)),
              Container(
                margin: const EdgeInsets.only(
                  left: AppDimens.space16,
                  right: AppDimens.space16,
                ),
                child: Text(Utils.getString('checkout3__cod'),
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        .copyWith(height: 1.3)),
              ),
            ],
          ),
        ));
  }

  Widget changeCashCardToOrange() {
    return Container(
      width: AppDimens.space140,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.mainColor,
          borderRadius:
              const BorderRadius.all(Radius.circular(AppDimens.space8)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(
              height: AppDimens.space4,
            ),
            Container(
                width: 50,
                height: 50,
                child: Icon(
                  Ionicons.md_cash,
                  color: AppColors.white,
                )),
            Container(
              margin: const EdgeInsets.only(
                left: AppDimens.space16,
                right: AppDimens.space16,
              ),
              child: Text(Utils.getString('checkout3__cod'),
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2
                      .copyWith(color: AppColors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget checkIsPaypalSelected() {
    if (!isPaypalClicked) {
      return changePaypalCardToWhite();
    } else {
      return changePaypalCardToOrange();
    }
  }

  Widget changePaypalCardToOrange() {
    return Container(
      width: AppDimens.space140,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.mainColor,
          borderRadius:
              const BorderRadius.all(Radius.circular(AppDimens.space8)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(
              height: AppDimens.space4,
            ),
            Container(
                width: 50,
                height: 50,
                child: Icon(Foundation.paypal, color: AppColors.white)),
            Container(
              margin: const EdgeInsets.only(
                left: AppDimens.space16,
                right: AppDimens.space16,
              ),
              child: Text(Utils.getString('checkout3__paypal'),
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2
                      .copyWith(height: 1.3, color: AppColors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget changePaypalCardToWhite() {
    return Container(
        width: AppDimens.space140,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.coreBackgroundColor,
            borderRadius:
                const BorderRadius.all(Radius.circular(AppDimens.space8)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(
                height: AppDimens.space4,
              ),
              Container(
                  width: 50, height: 50, child: const Icon(Foundation.paypal)),
              Container(
                margin: const EdgeInsets.only(
                  left: AppDimens.space16,
                  right: AppDimens.space16,
                ),
                child: Text(Utils.getString('checkout3__paypal'),
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        .copyWith(height: 1.3)),
              ),
            ],
          ),
        ));
  }

  Widget checkIsStripeSelected() {
    if (!isStripeClicked) {
      return changeStripeCardToWhite();
    } else {
      return changeStripeCardToOrange();
    }
  }

  Widget changeStripeCardToWhite() {
    return Container(
      width: AppDimens.space140,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.coreBackgroundColor,
          borderRadius:
              const BorderRadius.all(Radius.circular(AppDimens.space8)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(
              height: AppDimens.space4,
            ),
            Container(width: 50, height: 50, child: const Icon(Icons.payment)),
            Container(
              margin: const EdgeInsets.only(
                left: AppDimens.space16,
                right: AppDimens.space16,
              ),
              child: Text(Utils.getString('checkout3__stripe'),
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2
                      .copyWith(height: 1.3)),
            ),
          ],
        ),
      ),
    );
  }

  Widget changeStripeCardToOrange() {
    return Container(
      width: AppDimens.space140,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.mainColor,
          borderRadius:
              const BorderRadius.all(Radius.circular(AppDimens.space8)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(
              height: AppDimens.space4,
            ),
            Container(
                width: 50,
                height: 50,
                child: Icon(Icons.payment, color: AppColors.white)),
            Container(
              margin: const EdgeInsets.only(
                left: AppDimens.space16,
                right: AppDimens.space16,
              ),
              child: Text(Utils.getString('checkout3__stripe'),
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2
                      .copyWith(height: 1.3, color: AppColors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget checkIsBankSelected() {
    if (!isBankClicked) {
      return changeBankCardToWhite();
    } else {
      return changeBankCardToOrange();
    }
  }

  Widget changeBankCardToOrange() {
    return Container(
      width: AppDimens.space140,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.mainColor,
          borderRadius:
              const BorderRadius.all(Radius.circular(AppDimens.space8)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(
              height: AppDimens.space4,
            ),
            Container(
                width: 50,
                height: 50,
                child:
                    Icon(MaterialCommunityIcons.bank, color: AppColors.white)),
            Container(
              margin: const EdgeInsets.only(
                  left: AppDimens.space16, right: AppDimens.space16),
              child: Text(Utils.getString('checkout3__bank'),
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2
                      .copyWith(height: 1.3, color: AppColors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget changeBankCardToWhite() {
    return Container(
      width: AppDimens.space140,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.coreBackgroundColor,
          borderRadius:
              const BorderRadius.all(Radius.circular(AppDimens.space8)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(
              height: AppDimens.space4,
            ),
            Container(
                width: 50,
                height: 50,
                child: const Icon(MaterialCommunityIcons.bank)),
            Container(
              margin: const EdgeInsets.only(
                  left: AppDimens.space16, right: AppDimens.space16),
              child: Text(Utils.getString('checkout3__bank'),
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2
                      .copyWith(height: 1.3)),
            ),
          ],
        ),
      ),
    );
  }

  Widget checkIsRazorSelected() {
    if (!isRazorClicked) {
      return changeRazorCardToWhite();
    } else {
      return changeRazorCardToOrange();
    }
  }

  Widget checkIsPayStackSelected() {
    if (!isPayStackClicked) {
      return changePayStackCardToWhite();
    } else {
      return changePayStackCardToOrange();
    }
  }

  Widget changeRazorCardToOrange() {
    return Container(
      width: AppDimens.space140,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.mainColor,
          borderRadius:
              const BorderRadius.all(Radius.circular(AppDimens.space8)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(
              height: AppDimens.space4,
            ),
            Container(
                width: 50,
                height: 50,
                child: Icon(Icons.payment, color: AppColors.white)),
            Container(
              margin: const EdgeInsets.only(
                  left: AppDimens.space16, right: AppDimens.space16),
              child: Text(Utils.getString('checkout3__razor'),
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(height: 1.3, color: AppColors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget changeRazorCardToWhite() {
    return Container(
      width: AppDimens.space140,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.coreBackgroundColor,
          borderRadius:
              const BorderRadius.all(Radius.circular(AppDimens.space8)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(
              height: AppDimens.space4,
            ),
            Container(width: 50, height: 50, child: const Icon(Icons.payment)),
            Container(
              margin: const EdgeInsets.only(
                  left: AppDimens.space16, right: AppDimens.space16),
              child: Text(Utils.getString('checkout3__razor'),
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(height: 1.3)),
            ),
          ],
        ),
      ),
    );
  }

  Widget changePayStackCardToOrange() {
    return Container(
      width: AppDimens.space140,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.mainColor,
          borderRadius:
              const BorderRadius.all(Radius.circular(AppDimens.space8)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(
              height: AppDimens.space4,
            ),
            Container(
                width: 50,
                height: 50,
                child: Icon(Ionicons.md_cash, color: AppColors.white)),
            Container(
              margin: const EdgeInsets.only(
                  left: AppDimens.space16, right: AppDimens.space16),
              child: Text(Utils.getString('checkout3__pay_stack'),
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(height: 1.3, color: AppColors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget changePayStackCardToWhite() {
    return Container(
      width: AppDimens.space140,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.coreBackgroundColor,
          borderRadius:
              const BorderRadius.all(Radius.circular(AppDimens.space8)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(
              height: AppDimens.space4,
            ),
            Container(
                width: 50, height: 50, child: const Icon(Ionicons.md_cash)),
            Container(
              margin: const EdgeInsets.only(
                  left: AppDimens.space16, right: AppDimens.space16),
              child: Text(Utils.getString('checkout3__pay_stack'),
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(height: 1.3)),
            ),
          ],
        ),
      ),
    );
  }

  Widget showOrHideCashText() {
    if (isCashClicked) {
      return Text(Utils.getString('checkout3__cod_message'),
          style: Theme.of(context).textTheme.bodyText2);
    } else {
      return null;
    }
  }
}
