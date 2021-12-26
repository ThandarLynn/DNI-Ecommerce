import 'dart:io';

import 'package:dni_ecommerce/api/common/app_resource.dart';
import 'package:dni_ecommerce/api/common/app_status.dart';
import 'package:dni_ecommerce/constant/app_constant.dart';
import 'package:dni_ecommerce/constant/app_dimens.dart';
import 'package:dni_ecommerce/constant/route_paths.dart';
import 'package:dni_ecommerce/provider/basket/basket_provider.dart';
import 'package:dni_ecommerce/provider/transaction/transaction_header_provider.dart';
import 'package:dni_ecommerce/provider/user/user_provider.dart';
import 'package:dni_ecommerce/ui/common/dialog/error_dialog.dart';
import 'package:dni_ecommerce/ui/common/dialog/warning_dialog_view.dart';
import 'package:dni_ecommerce/ui/common/app_button_widget.dart';
import 'package:dni_ecommerce/ui/common/app_widget_with_appbar_with_no_provider.dart';
import 'package:dni_ecommerce/utils/app_progress_dialog.dart';
import 'package:dni_ecommerce/utils/utils.dart';
import 'package:dni_ecommerce/viewobject/basket.dart';
import 'package:dni_ecommerce/viewobject/common/app_value_holder.dart';
import 'package:dni_ecommerce/viewobject/transaction_header.dart';
import 'package:dni_ecommerce/viewobject/holder/intent/checkout_status_intent_holder.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter/material.dart';

class CreditCardView extends StatefulWidget {
  const CreditCardView(
      {Key key,
      @required this.basketList,
      @required this.couponDiscount,
      @required this.appValueHolder,
      @required this.transactionSubmitProvider,
      @required this.userLoginProvider,
      @required this.basketProvider,
      // @required this.shippingMethodProvider,
      // @required this.shippingCostProvider,
      @required this.memoText,
      @required this.publishKey})
      : super(key: key);

  final List<Basket> basketList;
  final String couponDiscount;
  final AppValueHolder appValueHolder;
  final TransactionHeaderProvider transactionSubmitProvider;
  final UserProvider userLoginProvider;
  final BasketProvider basketProvider;
  // final ShippingMethodProvider shippingMethodProvider;
  // final ShippingCostProvider shippingCostProvider;
  final String memoText;
  final String publishKey;

  @override
  State<StatefulWidget> createState() {
    return CreditCardViewState();
  }
}

dynamic callTransactionSubmitApi(
    BuildContext context,
    BasketProvider basketProvider,
    UserProvider userLoginProvider,
    TransactionHeaderProvider transactionSubmitProvider,
    // ShippingMethodProvider shippingMethodProvider,
    List<Basket> basketList,
    String token,
    String couponDiscount,
    String memoText) async {
  if (await Utils.checkInternetConnectivity()) {
    if (userLoginProvider.user != null && userLoginProvider.user.data != null) {
      final AppResource<TransactionHeader> _apiStatus =
          await transactionSubmitProvider.postTransactionSubmit(
              userLoginProvider.user.data,
              basketList,
              Platform.isIOS ? token : token,
              couponDiscount.toString(),
              basketProvider.checkoutCalculationHelper.tax.toString(),
              basketProvider.checkoutCalculationHelper.totalDiscount.toString(),
              basketProvider.checkoutCalculationHelper.subTotalPrice.toString(),
              basketProvider.checkoutCalculationHelper.shippingTax.toString(),
              basketProvider.checkoutCalculationHelper.totalPrice.toString(),
              basketProvider.checkoutCalculationHelper.totalOriginalPrice
                  .toString(),
              AppConst.ZERO,
              AppConst.ZERO,
              AppConst.ONE,
              AppConst.ZERO,
              AppConst.ZERO,
              AppConst.ZERO,
              '',
              basketProvider.checkoutCalculationHelper.shippingCost.toString(),
              'Free',
              memoText);

      if (_apiStatus.data != null) {
        AppProgressDialog.dismissDialog();

        if (_apiStatus.status == AppStatus.SUCCESS) {
          await basketProvider.deleteWholeBasketList();

          await Navigator.pushNamed(context, RoutePaths.checkoutSuccess,
              arguments: CheckoutStatusIntentHolder(
                transactionHeader: _apiStatus.data,
              ));
        } else {
          AppProgressDialog.dismissDialog();

          return showDialog<dynamic>(
              context: context,
              builder: (BuildContext context) {
                return ErrorDialog(
                  message: _apiStatus.message,
                );
              });
        }
      } else {
        AppProgressDialog.dismissDialog();

        return showDialog<dynamic>(
            context: context,
            builder: (BuildContext context) {
              return ErrorDialog(
                message: _apiStatus.message,
              );
            });
      }
    }
  } else {
    showDialog<dynamic>(
        context: context,
        builder: (BuildContext context) {
          return ErrorDialog(
            message: Utils.getString('error_dialog__no_internet'),
          );
        });
  }
}

class CreditCardViewState extends State<CreditCardView> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  // CardFieldInputDetails cardData;

  @override
  void initState() {
    // Stripe.publishableKey = widget.publishKey;
    super.initState();
  }

  void setError(dynamic error) {
    showDialog<dynamic>(
        context: context,
        builder: (BuildContext context) {
          return ErrorDialog(
            message: Utils.getString(error.toString()),
          );
        });
  }

  dynamic callWarningDialog(BuildContext context, String text) {
    showDialog<dynamic>(
        context: context,
        builder: (BuildContext context) {
          return WarningDialog(
            message: Utils.getString(text),
            onPressed: () {},
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // dynamic stripeNow(String token) async {
    //   if (widget.appValueHolder.standardShippingEnable == AppConst.ONE) {
    //     widget.basketProvider.checkoutCalculationHelper.calculate(
    //         basketList: widget.basketList,
    //         couponDiscountString: widget.couponDiscount,
    //         appValueHolder: widget.appValueHolder,
    //         shippingPriceStringFormatting: '0.0');
    //   } else if (widget.appValueHolder.zoneShippingEnable == AppConst.ONE) {
    //     widget.basketProvider.checkoutCalculationHelper.calculate(
    //         basketList: widget.basketList,
    //         couponDiscountString: widget.couponDiscount,
    //         appValueHolder: widget.appValueHolder,
    //         shippingPriceStringFormatting: '0.0');
    //   }

    //   callTransactionSubmitApi(
    //       context,
    //       widget.basketProvider,
    //       widget.userLoginProvider,
    //       widget.transactionSubmitProvider,
    //       // widget.shippingMethodProvider,
    //       widget.basketList,
    //       token,
    //       widget.couponDiscount,
    //       widget.memoText);
    // }

    return AppWidgetWithAppBarWithNoProvider(
      appBarTitle: 'Credit Card',
      child: Column(
        children: <Widget>[
          // Container(
          //   padding: const EdgeInsets.all(AppDimens.space16),
          //   child: CardField(
          //     autofocus: true,
          //     onCardChanged: (CardFieldInputDetails card) async {
          //       setState(() {
          //         cardData = card;
          //       });
          //     },
          //   ),
          // ),
          Container(
            margin: const EdgeInsets.only(
                left: AppDimens.space12, right: AppDimens.space12),
            child: AppButtonWidget(
              hasShadow: true,
              width: double.infinity,
              titleText: Utils.getString('credit_card__pay'),
              onPressed: () async {
                // if (cardData != null && cardData.complete) {
                //   await AppProgressDialog.showDialog(context);
                //   final PaymentMethod paymentMethod = await Stripe.instance
                //       .createPaymentMethod(const PaymentMethodParams.card());
                //   print(paymentMethod.id);
                //   await stripeNow(paymentMethod.id);
                // } else {
                //   callWarningDialog(
                //       context, Utils.getString('contact_us__fail'));
                // }
              },
            ),
          ),
        ],
      ),
    );
  }

  // void onCreditCardModelChange(CreditCardModel creditCardModel) {
  //   setState(() {
  //     cardNumber = creditCardModel.cardNumber;
  //     expiryDate = creditCardModel.expiryDate;
  //     cardHolderName = creditCardModel.cardHolderName;
  //     cvvCode = creditCardModel.cvvCode;
  //     isCvvFocused = creditCardModel.isCvvFocused;
  //   });
  // }
}
