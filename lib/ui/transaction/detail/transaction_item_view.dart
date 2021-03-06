import 'package:dni_ecommerce/config/app_colors.dart';
import 'package:dni_ecommerce/constant/app_constant.dart';
import 'package:dni_ecommerce/constant/app_dimens.dart';
import 'package:dni_ecommerce/utils/utils.dart';
import 'package:dni_ecommerce/viewobject/transaction_detail.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TransactionItemView extends StatelessWidget {
  const TransactionItemView({
    Key key,
    @required this.transaction,
    this.animationController,
    this.animation,
    this.onTap,
  }) : super(key: key);

  final TransactionDetail transaction;
  final Function onTap;
  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    animationController.forward();
    return AnimatedBuilder(
        animation: animationController,
        child: GestureDetector(
          onTap: onTap,
          child: _ItemWidget(transaction: transaction),
        ),
        builder: (BuildContext context, Widget child) {
          return FadeTransition(
              opacity: animation,
              child: Transform(
                  transform: Matrix4.translationValues(
                      0.0, 100 * (1.0 - animation.value), 0.0),
                  child: child));
        });
  }
}

class _ItemWidget extends StatelessWidget {
  const _ItemWidget({
    Key key,
    @required this.transaction,
  }) : super(key: key);

  final TransactionDetail transaction;

  Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  @override
  Widget build(BuildContext context) {
    double balancePrice;
    const Widget _dividerWidget = Divider(
      height: AppDimens.space2,
    );

    if (transaction.originalPrice != AppConst.ZERO) {
      balancePrice = double.parse(transaction.price) *
          double.parse(transaction.qty);
    } else {
      balancePrice = double.parse(transaction.price) *
          double.parse(transaction.qty);
    }
    return Container(
        color: AppColors.backgroundColor,
        margin: const EdgeInsets.only(top: AppDimens.space8),
        padding: const EdgeInsets.only(
          left: AppDimens.space12,
          right: AppDimens.space12,
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: <Widget>[
                  const Icon(
                    AntDesign.tago,
                  ),
                  const SizedBox(
                    width: AppDimens.space16,
                  ),
                  Expanded(
                    child: Text(
                      transaction.productName ?? '-',
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                ],
              ),
            ),
            _dividerWidget,
            Row(
              children: <Widget>[
                if (transaction.productColorCode != null &&
                    transaction.productColorCode != '')
                  Container(
                    margin: const EdgeInsets.all(AppDimens.space10),
                    width: AppDimens.space40,
                    height: AppDimens.space40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: hexToColor(transaction.productColorCode),
                      border: Border.all(width: 1, color: AppColors.grey),
                    ),
                  )
                else
                  Container(),
                const SizedBox(
                  width: AppDimens.space8,
                ),
                if (transaction.productSizeCode != null &&
                    transaction.productSizeCode != '')
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Stack(
                          alignment: const Alignment(0.0, 0.0),
                          children: <Widget>[
                            Container(
                              width: AppDimens.space40,
                              height: AppDimens.space40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: AppColors.grey,
                                border:
                                    Border.all(width: 1, color: AppColors.grey),
                              ),
                            ),
                            Container(
                              width: AppDimens.space24,
                              height: AppDimens.space24,
                              margin: const EdgeInsets.only(top: 6),
                              child: Text(
                                transaction.productSizeCode,
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(color: AppColors.black),
                              ),
                            )
                          ],
                        )
                      ])
                else
                  Container()
              ],
            ),
            _TransactionNoTextWidget(
              transationInfoText:
                  '\$  ${Utils.getPriceFormat(transaction.originalPrice)}',
              title: '${Utils.getString('transaction_detail__price')} :',
            ),
            _TransactionNoTextWidget(
              transationInfoText: transaction.discountAmount != null
                  ? ' \$ ${Utils.getPriceFormat(transaction.discountAmount.toString())}'
                  : '\$ 0.0',
              title:
                  '${Utils.getString('transaction_detail__discount_avaiable_amount')} :',
            ),
            const SizedBox(
              height: AppDimens.space8,
            ),
            _TransactionNoTextWidget(
              transationInfoText:
                  '\$ ${Utils.getPriceFormat(transaction.price.toString())}',
              title: '${Utils.getString('transaction_detail__balance')} :',
            ),
            _TransactionNoTextWidget(
              transationInfoText: '${transaction.qty}',
              title: '${Utils.getString('transaction_detail__qty')} :',
            ),
            _TransactionNoTextWidget(
              transationInfoText:
                  ' \$ ${Utils.getPriceFormat(balancePrice.toString())}',
              title: '${Utils.getString('transaction_detail__sub_total')} :',
            ),
            const SizedBox(
              height: AppDimens.space12,
            ),
          ],
        ));
  }
}

class _TransactionNoTextWidget extends StatelessWidget {
  const _TransactionNoTextWidget({
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
            style: Theme.of(context).textTheme.bodyText2,
          ),
          Text(
            transationInfoText ?? '-',
            style: Theme.of(context).textTheme.bodyText2,
          )
        ],
      ),
    );
  }
}
