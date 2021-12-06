import 'package:dni_ecommerce/config/app_colors.dart';
import 'package:dni_ecommerce/constant/app_dimens.dart';
import 'package:dni_ecommerce/utils/utils.dart';
import 'package:dni_ecommerce/viewobject/transaction_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TransactionListItem extends StatelessWidget {
  const TransactionListItem({
    Key key,
    @required this.transaction,
    this.animationController,
    this.animation,
    this.onTap,
    @required this.scaffoldKey,
  }) : super(key: key);

  final TransactionHeader transaction;
  final Function onTap;
  final AnimationController animationController;
  final Animation<double> animation;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    animationController.forward();
    if (transaction != null && transaction.id != null) {
      return AnimatedBuilder(
          animation: animationController,
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              color: AppColors.backgroundColor,
              margin: const EdgeInsets.only(top: AppDimens.space8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _TransactionNoWidget(
                    transaction: transaction,
                    scaffoldKey: scaffoldKey,
                  ),
                  const Divider(
                    height: AppDimens.space1,
                  ),
                  _TransactionTextWidget(
                    transaction: transaction,
                  ),
                ],
              ),
            ),
          ),
          builder: (BuildContext context, Widget child) {
            return FadeTransition(
              opacity: animation,
              child: Transform(
                  transform: Matrix4.translationValues(
                      0.0, 100 * (1.0 - animation.value), 0.0),
                  child: child),
            );
          });
    } else {
      return Container();
    }
  }
}

class _TransactionNoWidget extends StatelessWidget {
  const _TransactionNoWidget({
    Key key,
    @required this.transaction,
    @required this.scaffoldKey,
  }) : super(key: key);

  final TransactionHeader transaction;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    final Widget _textWidget = Text(
      'Transaction No : ${transaction.id}' ?? '-',
      textAlign: TextAlign.left,
      style: Theme.of(context).textTheme.subtitle2,
    );

    return Padding(
      padding: const EdgeInsets.only(
          left: AppDimens.space12,
          right: AppDimens.space4,
          top: AppDimens.space4,
          bottom: AppDimens.space4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const Icon(
                Icons.offline_pin,
                size: 24,
              ),
              const SizedBox(
                width: AppDimens.space8,
              ),
              _textWidget,
            ],
          ),
          IconButton(
            icon: const Icon(Icons.content_copy),
            iconSize: 24,
            onPressed: () {
              Clipboard.setData(ClipboardData(text: transaction.id));
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Theme.of(context).iconTheme.color,
                content: Tooltip(
                  message: Utils.getString('transaction_detail__copy'),
                  child: Text(
                    Utils.getString('transaction_detail__copied_data'),
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(color: AppColors.mainColor),
                  ),
                  showDuration: const Duration(seconds: 5),
                ),
              ));
            },
          ),
        ],
      ),
    );
  }
}

class _TransactionTextWidget extends StatelessWidget {
  const _TransactionTextWidget({
    Key key,
    @required this.transaction,
  }) : super(key: key);

  final TransactionHeader transaction;

  @override
  Widget build(BuildContext context) {
    const EdgeInsets _paddingEdgeInsetWidget = EdgeInsets.only(
      left: AppDimens.space16,
      right: AppDimens.space16,
      top: AppDimens.space8,
    );

    final Widget _totalAmountTextWidget = Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          Utils.getString('transaction_list__total_amount'),
          style: Theme.of(context)
              .textTheme
              .bodyText2
              .copyWith(fontWeight: FontWeight.normal),
        ),
        Text(
          '\$ ${Utils.getPriceFormat(transaction.balanceAmount)}' ?? '-',
          style: Theme.of(context).textTheme.bodyText2.copyWith(
              color: AppColors.mainColor, fontWeight: FontWeight.normal),
        )
      ],
    );

    final Widget _statusTextWidget = Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          Utils.getString('transaction_detail__status'),
          style: Theme.of(context)
              .textTheme
              .bodyText2
              .copyWith(fontWeight: FontWeight.normal),
        ),
        Text(
          transaction.transStatusTitle ?? '-',
          style: Theme.of(context)
              .textTheme
              .bodyText2
              .copyWith(fontWeight: FontWeight.normal),
        )
      ],
    );

    final Widget _viewDetailTextWidget = Text(
      Utils.getString('transaction_detail__view_details'),
      style: Theme.of(context)
          .textTheme
          .bodyText2
          .copyWith(fontWeight: FontWeight.normal),
    );
    if (transaction != null && transaction.id != null) {
      return Column(
        children: <Widget>[
          Padding(
            padding: _paddingEdgeInsetWidget,
            child: _totalAmountTextWidget,
          ),
          Padding(
            padding: _paddingEdgeInsetWidget,
            child: _statusTextWidget,
          ),
          Padding(
            padding: _paddingEdgeInsetWidget,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                _viewDetailTextWidget,
              ],
            ),
          ),
          const SizedBox(
            height: AppDimens.space8,
          )
        ],
      );
    } else {
      return Container();
    }
  }
}
