// import 'package:dni_ecommerce/api/common/app_resource.dart';
import 'package:dni_ecommerce/config/app_colors.dart';
import 'package:dni_ecommerce/constant/app_dimens.dart';
import 'package:dni_ecommerce/provider/basket/basket_provider.dart';
import 'package:dni_ecommerce/provider/coupon_discount/coupon_discount_provider.dart';
import 'package:dni_ecommerce/provider/user/user_provider.dart';
import 'package:dni_ecommerce/repository/basket_repository.dart';
import 'package:dni_ecommerce/repository/coupon_discount_repository.dart';
import 'package:dni_ecommerce/repository/user_repository.dart';
// import 'package:dni_ecommerce/ui/common/dialog/error_dialog.dart';
// import 'package:dni_ecommerce/ui/common/dialog/success_dialog.dart';
// import 'package:dni_ecommerce/ui/common/dialog/warning_dialog_view.dart';
// import 'package:dni_ecommerce/ui/common/app_textfield_widget.dart';
import 'package:dni_ecommerce/utils/utils.dart';
import 'package:dni_ecommerce/viewobject/basket.dart';
import 'package:dni_ecommerce/viewobject/common/app_value_holder.dart';
// import 'package:dni_ecommerce/viewobject/coupon_discount.dart';
// import 'package:dni_ecommerce/viewobject/holder/intent/coupon_discount_holder.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

class Checkout2View extends StatefulWidget {
  const Checkout2View({
    Key key,
    @required this.updateCheckout2ViewState,
    @required this.basketList,
    @required this.publishKey,
  }) : super(key: key);

  final List<Basket> basketList;
  final Function updateCheckout2ViewState;
  final String publishKey;
  @override
  _Checkout2ViewState createState() {
    final _Checkout2ViewState _state = _Checkout2ViewState();
    updateCheckout2ViewState(_state);
    return _state;
  }
}

class _Checkout2ViewState extends State<Checkout2View> {
  final TextEditingController couponController = TextEditingController();
  CouponDiscountRepository couponDiscountRepo;
  BasketRepository basketRepository;
  UserRepository userRepository;
  AppValueHolder valueHolder;
  CouponDiscountProvider couponDiscountProvider;
  UserProvider userProvider;

  @override
  Widget build(BuildContext context) {
    couponDiscountRepo = Provider.of<CouponDiscountRepository>(context);
    basketRepository = Provider.of<BasketRepository>(context);

    valueHolder = Provider.of<AppValueHolder>(context);
    userRepository = Provider.of<UserRepository>(context);

    return Consumer<BasketProvider>(builder: (BuildContext context,
        BasketProvider shippingMethodProvider, Widget child) {
      couponDiscountProvider = Provider.of<CouponDiscountProvider>(context,
          listen: false); // Listen : False is important.
      final BasketProvider basketProvider =
          Provider.of<BasketProvider>(context);
      userProvider = Provider.of<UserProvider>(context);

      return SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Container(
            //   color: AppColors.backgroundColor,
            //   margin: const EdgeInsets.only(top: AppDimens.space8),
            //   padding: const EdgeInsets.only(
            //     left: AppDimens.space12,
            //     right: AppDimens.space12,
            //   ),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: <Widget>[
            //       const SizedBox(
            //         height: AppDimens.space16,
            //       ),
            //       // Container(
            //       //   margin: const EdgeInsets.only(
            //       //       left: AppDimens.space16, right: AppDimens.space16),
            //       //   child: Text(
            //       //     Utils.getString('transaction_detail__coupon_discount'),
            //       //     style: Theme.of(context).textTheme.subtitle1,
            //       //   ),
            //       // ),
            //       // const SizedBox(
            //       //   height: AppDimens.space16,
            //       // ),
            //       // const Divider(
            //       //   height: 2,
            //       // ),
            //       // const SizedBox(
            //       //   height: AppDimens.space16,
            //       // ),
            //       // Row(
            //       //   mainAxisSize: MainAxisSize.min,
            //       //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       //   children: <Widget>[
            //       //     Expanded(
            //       //         child: AppTextFieldWidget(
            //       //       hintText: Utils.getString('checkout__coupon_code'),
            //       //       textEditingController: couponController,
            //       //       showTitle: false,
            //       //     )),
            //       //     Container(
            //       //       margin: const EdgeInsets.only(right: AppDimens.space8),
            //       //       child: MaterialButton(
            //       //         color: AppColors.mainColor,
            //       //         shape: const BeveledRectangleBorder(
            //       //           borderRadius:
            //       //               BorderRadius.all(Radius.circular(7.0)),
            //       //         ),
            //       //         child: Row(
            //       //           children: <Widget>[
            //       //             Icon(MaterialCommunityIcons.ticket_percent,
            //       //                 color: AppColors.white),
            //       //             const SizedBox(
            //       //               width: AppDimens.space4,
            //       //             ),
            //       //             Text(
            //       //               Utils.getString('checkout__claim_button_name'),
            //       //               textAlign: TextAlign.start,
            //       //               style: Theme.of(context)
            //       //                   .textTheme
            //       //                   .button
            //       //                   .copyWith(color: AppColors.white),
            //       //             ),
            //       //           ],
            //       //         ),
            //       //         onPressed: () async {
            //       //           if (couponController.text.isNotEmpty) {
            //       //             final CouponDiscountParameterHolder
            //       //                 couponDiscountParameterHolder =
            //       //                 CouponDiscountParameterHolder(
            //       //               couponCode: couponController.text,
            //       //             );

            //       //             final AppResource<CouponDiscount> _apiStatus =
            //       //                 await couponDiscountProvider
            //       //                     .postCouponDiscount(
            //       //                         couponDiscountParameterHolder
            //       //                             .toMap());

            //       //             if (_apiStatus.data != null &&
            //       //                 couponController.text ==
            //       //                     _apiStatus.data.couponCode) {
            //       //               final BasketProvider basketProvider =
            //       //                   Provider.of<BasketProvider>(context,
            //       //                       listen: false);

            //       //               basketProvider.checkoutCalculationHelper
            //       //                   .calculate(
            //       //                       basketList: widget.basketList,
            //       //                       couponDiscountString:
            //       //                           _apiStatus.data.couponAmount,
            //       //                       appValueHolder: valueHolder,
            //       //                       shippingPriceStringFormatting: '0.0');

            //       //               showDialog<dynamic>(
            //       //                   context: context,
            //       //                   builder: (BuildContext context) {
            //       //                     return SuccessDialog(
            //       //                         message: Utils.getString(
            //       //                             'checkout__couponcode_add_dialog_message'),
            //       //                         onPressed: () {});
            //       //                   });

            //       //               couponController.clear();
            //       //               print(_apiStatus.data.couponAmount);
            //       //               setState(() {
            //       //                 couponDiscountProvider.couponDiscount =
            //       //                     _apiStatus.data.couponAmount;
            //       //               });
            //       //             } else {
            //       //               showDialog<dynamic>(
            //       //                   context: context,
            //       //                   builder: (BuildContext context) {
            //       //                     return ErrorDialog(
            //       //                       message: _apiStatus.message,
            //       //                     );
            //       //                   });
            //       //             }
            //       //           } else {
            //       //             showDialog<dynamic>(
            //       //                 context: context,
            //       //                 builder: (BuildContext context) {
            //       //                   return WarningDialog(
            //       //                     message: Utils.getString(
            //       //                         'checkout__warning_dialog_message'),
            //       //                     onPressed: () {},
            //       //                   );
            //       //                 });
            //       //           }
            //       //         },
            //       //       ),
            //       //     ),
            //       //   ],
            //       // ),
            //       // const SizedBox(
            //       //   height: AppDimens.space16,
            //       // ),
            //       // Container(
            //       //   margin: const EdgeInsets.only(
            //       //       left: AppDimens.space16, right: AppDimens.space16),
            //       //   child: Text(Utils.getString('checkout__description'),
            //       //       style: Theme.of(context).textTheme.bodyText2),
            //       // ),
            //       // const SizedBox(
            //       //   height: AppDimens.space16,
            //       // ),
            //     ],
            //   ),
            // ),
            _OrderSummaryWidget(
              appValueHolder: valueHolder,
              basketList: widget.basketList,
              couponDiscount: couponDiscountProvider.couponDiscount ?? '-',
              basketProvider: basketProvider,
            ),
          ],
        ),
      );
    });
  }
}

class _OrderSummaryWidget extends StatelessWidget {
  const _OrderSummaryWidget({
    Key key,
    @required this.basketList,
    @required this.couponDiscount,
    @required this.appValueHolder,
    @required this.basketProvider,
  }) : super(key: key);

  final List<Basket> basketList;
  final String couponDiscount;
  final AppValueHolder appValueHolder;
  final BasketProvider basketProvider;
  @override
  Widget build(BuildContext context) {
    // String currencySymbol;

    // if (basketList.isNotEmpty) {
    //   currencySymbol = '\$';
    // }

    basketProvider.checkoutCalculationHelper.calculate(
        basketList: basketList,
        couponDiscountString: couponDiscount,
        appValueHolder: appValueHolder,
        shippingPriceStringFormatting: '0.0');

    const Widget _dividerWidget = Divider(
      height: AppDimens.space2,
    );

    const Widget _spacingWidget = SizedBox(
      height: AppDimens.space12,
    );

    return Container(
        color: AppColors.backgroundColor,
        margin: const EdgeInsets.only(top: AppDimens.space8),
        padding: const EdgeInsets.only(
          left: AppDimens.space12,
          right: AppDimens.space12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                Utils.getString('checkout__order_summary'),
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
            _dividerWidget,
            _OrderSummeryTextWidget(
              transationInfoText: basketProvider
                  .checkoutCalculationHelper.totalItemCount
                  .toString(),
              title: '${Utils.getString('checkout__total_item_count')} :',
            ),
            _OrderSummeryTextWidget(
              transationInfoText:
                  '\$ ${basketProvider.checkoutCalculationHelper.totalOriginalPriceFormattedString}',
              title: '${Utils.getString('checkout__total_item_price')} :',
            ),
            _OrderSummeryTextWidget(
              transationInfoText:
                  '\$ ${basketProvider.checkoutCalculationHelper.totalDiscountFormattedString}',
              title: '${Utils.getString('checkout__discount')} :',
            ),
            _OrderSummeryTextWidget(
              transationInfoText: couponDiscount == '-'
                  ? '-'
                  : '\$ ${basketProvider.checkoutCalculationHelper.couponDiscountFormattedString}',
              title: '${Utils.getString('checkout__coupon_discount')} :',
            ),
            _spacingWidget,
            _dividerWidget,
            _OrderSummeryTextWidget(
              transationInfoText: basketProvider
                  .checkoutCalculationHelper.subTotalPriceFormattedString
                  .toString(),
              title: '${Utils.getString('checkout__sub_total')} :',
            ),
            _OrderSummeryTextWidget(
              transationInfoText:
                  '\$ ${basketProvider.checkoutCalculationHelper.taxFormattedString}',
              title:
                  '${Utils.getString('checkout__tax')} (${appValueHolder.overAllTaxLabel} %) :',
            ),
            // if (shippingCostProvider.shippingCost.data != null &&
            //     shippingCostProvider.shippingCost.data.shippingZone != null &&
            //     shippingCostProvider
            //             .shippingCost.data.shippingZone.shippingCost !=
            //         null)
            //   _OrderSummeryTextWidget(
            //     transationInfoText:
            //         '$currencySymbol ${double.parse(shippingCostProvider.shippingCost.data.shippingZone.shippingCost)}',
            //     title:
            //         '${Utils.getString( 'checkout__shipping_cost')} :',
            //   )
            // else
            //   _OrderSummeryTextWidget(
            //     transationInfoText: shippingMethodProvider.selectedPrice ==
            //             '0.0'
            //         ? '$currencySymbol ${Utils.getPriceFormat(shippingMethodProvider.defaultShippingPrice)}'
            //         : '$currencySymbol ${Utils.getPriceFormat(shippingMethodProvider.selectedPrice)}',
            //     title:
            //         '${Utils.getString( 'checkout__shipping_cost')} :',
            //   ),
            // _OrderSummeryTextWidget(
            //   transationInfoText:
            //       '\$ ${basketProvider.checkoutCalculationHelper.shippingTaxFormattedString}',
            //   title:
            //       '${Utils.getString('checkout__shipping_tax')} (${appValueHolder.shippingTaxLabel} %) :',
            // ),
            _spacingWidget,
            _dividerWidget,
            _OrderSummeryTextWidget(
              transationInfoText:
                  '\$ ${basketProvider.checkoutCalculationHelper.totalPriceFormattedString}',
              title: '${Utils.getString('transaction_detail__total')} :',
            ),
            _spacingWidget,
          ],
        ));
  }
}

class _OrderSummeryTextWidget extends StatelessWidget {
  const _OrderSummeryTextWidget({
    Key key,
    @required this.transationInfoText,
    this.title,
  }) : super(key: key);

  final String transationInfoText;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: AppDimens.space16,
          right: AppDimens.space16,
          top: AppDimens.space12),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .bodyText2
                .copyWith(fontWeight: FontWeight.normal),
          ),
          Text(
            transationInfoText ?? '-',
            style: Theme.of(context)
                .textTheme
                .bodyText2
                .copyWith(fontWeight: FontWeight.normal),
          )
        ],
      ),
    );
  }
}
