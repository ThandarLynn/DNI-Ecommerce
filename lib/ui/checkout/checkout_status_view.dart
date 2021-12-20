import 'package:dni_ecommerce/config/app_colors.dart';
import 'package:dni_ecommerce/constant/app_dimens.dart';
import 'package:dni_ecommerce/constant/route_paths.dart';
import 'package:dni_ecommerce/provider/user/user_provider.dart';
import 'package:dni_ecommerce/repository/user_repository.dart';
import 'package:dni_ecommerce/ui/common/app_button_widget.dart';
import 'package:dni_ecommerce/utils/utils.dart';
import 'package:dni_ecommerce/viewobject/common/app_value_holder.dart';
import 'package:dni_ecommerce/viewobject/transaction_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CheckoutStatusView extends StatefulWidget {
  const CheckoutStatusView({
    Key key,
    @required this.transactionHeader,
  }) : super(key: key);

  final TransactionHeader transactionHeader;

  @override
  _CheckoutStatusViewState createState() => _CheckoutStatusViewState();
}

class _CheckoutStatusViewState extends State<CheckoutStatusView> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  UserProvider _userProvider;
  UserRepository repo1;
  AppValueHolder valueHolder;
  @override
  Widget build(BuildContext context) {
    repo1 = Provider.of<UserRepository>(context);
    valueHolder = Provider.of<AppValueHolder>(context);
    const Widget _dividerWidget = Divider(
      height: AppDimens.space2,
    );
    final Widget _contentCopyIconWidget = IconButton(
      iconSize: AppDimens.space20,
      icon: Icon(
        Icons.content_copy,
        color: Theme.of(context).iconTheme.color,
      ),
      onPressed: () {
        Clipboard.setData(
            ClipboardData(text: widget.transactionHeader.transCode));
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Tooltip(
            message: Utils.getString('transaction_detail__copy'),
            child: Text(
              Utils.getString('transaction_detail__copied_data'),
              style: Theme.of(context).textTheme.headline6.copyWith(
                    color: AppColors.mainColor,
                  ),
            ),
            showDuration: const Duration(seconds: 5),
          ),
        ));
      },
    );

    final Widget _keepingButtonWidget = Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).popUntil(ModalRoute.withName(RoutePaths.home));
        },
        child: Container(
          height: 60,
          color: AppColors.mainColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: AppDimens.space16,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  Utils.getString('checkout_status__keep_shopping'),
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(color: AppColors.white),
                ),
              ),
              const SizedBox(
                height: AppDimens.space16,
              ),
            ],
          ),
        ),
      ),
    );
    return ChangeNotifierProvider<UserProvider>(
      lazy: false,
      create: (BuildContext context) {
        final UserProvider provider =
            UserProvider(repo: repo1, appValueHolder: valueHolder);
        provider.getUser(provider.appValueHolder.loginUserId,
            provider.appValueHolder.userToken);
        _userProvider = provider;
        return _userProvider;
      },
      child: Consumer<UserProvider>(
          builder: (BuildContext context, UserProvider provider, Widget child) {
        if (provider.user != null && provider.user.data != null) {
          return Scaffold(
              key: scaffoldKey,
              body: Container(
                color: AppColors.coreBackgroundColor,
                child: Stack(
                  children: <Widget>[
                    SingleChildScrollView(
                        child: Column(children: <Widget>[
                      const SizedBox(
                        height: AppDimens.space52,
                      ),
                      Text(
                        Utils.getString('checkout_status__order_success'),
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(color: AppColors.mainColor),
                      ),
                      const SizedBox(
                        height: AppDimens.space12,
                      ),
                      Text(
                        Utils.getString('checkout_status__thank') +
                            ' ' +
                            provider.user.data.userName,
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      const SizedBox(
                        height: AppDimens.space52,
                      ),
                      Image.asset('assets/images/delivery_car_img.png'),
                      const SizedBox(
                        height: AppDimens.space20,
                      ),
                      Container(
                          color: AppColors.backgroundColor,
                          margin: const EdgeInsets.only(top: AppDimens.space8),
                          padding: const EdgeInsets.only(
                            left: AppDimens.space12,
                            right: AppDimens.space12,
                          ),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(AppDimens.space8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      child: Row(
                                        children: <Widget>[
                                          const SizedBox(
                                            width: AppDimens.space8,
                                          ),
                                          Icon(
                                            Icons.offline_pin,
                                            color: Theme.of(context)
                                                .iconTheme
                                                .color,
                                          ),
                                          const SizedBox(
                                            width: AppDimens.space8,
                                          ),
                                          Expanded(
                                            child: Text(
                                                '${Utils.getString('transaction_detail__trans_no')} : ${widget.transactionHeader.transCode}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle2),
                                          ),
                                        ],
                                      ),
                                    ),
                                    _contentCopyIconWidget,
                                  ],
                                ),
                              ),
                              _dividerWidget,
                              _TransactionNoTextWidget(
                                transationInfoText:
                                    widget.transactionHeader.totalItemCount,
                                title:
                                    '${Utils.getString('transaction_detail__total_item_count')} :',
                              ),
                              _TransactionNoTextWidget(
                                transationInfoText:
                                    '\$ ${Utils.getPriceFormat(widget.transactionHeader.totalItemAmount)}',
                                title:
                                    '${Utils.getString('transaction_detail__total_item_price')} :',
                              ),
                              _TransactionNoTextWidget(
                                transationInfoText:
                                    '\$ ${Utils.getPriceFormat(widget.transactionHeader.discountAmount)}',
                                title:
                                    '${Utils.getString('transaction_detail__discount')} :',
                              ),
                              _TransactionNoTextWidget(
                                transationInfoText:
                                    '\$ ${Utils.getPriceFormat(widget.transactionHeader.cuponDiscountAmount)}',
                                title:
                                    '${Utils.getString('transaction_detail__coupon_discount')} :',
                              ),
                              const SizedBox(
                                height: AppDimens.space12,
                              ),
                              _dividerWidget,
                              _TransactionNoTextWidget(
                                transationInfoText:
                                    '\$ ${Utils.getPriceFormat(widget.transactionHeader.subTotalAmount)}',
                                title:
                                    '${Utils.getString('transaction_detail__sub_total')} :',
                              ),
                              _TransactionNoTextWidget(
                                transationInfoText:
                                    '\$ ${Utils.getPriceFormat(widget.transactionHeader.taxAmount)}',
                                title:
                                    '${Utils.getString('transaction_detail__tax')}(${provider.appValueHolder.overAllTaxLabel} %) :',
                              ),
                              _TransactionNoTextWidget(
                                transationInfoText:
                                    '\$ ${Utils.getPriceFormat(widget.transactionHeader.shippingMethodAmount)}',
                                title:
                                    '${Utils.getString('transaction_detail__shipping_cost')} :',
                              ),
                              _TransactionNoTextWidget(
                                transationInfoText:
                                    '\$ ${Utils.getPriceFormat(widget.transactionHeader.shippingAmount)}',
                                title:
                                    '${Utils.getString('transaction_detail__shipping_tax')}(${provider.appValueHolder.shippingTaxLabel} %) :',
                              ),
                              const SizedBox(
                                height: AppDimens.space12,
                              ),
                              _dividerWidget,
                              _TransactionNoTextWidget(
                                transationInfoText:
                                    '\$ ${Utils.getPriceFormat(widget.transactionHeader.balanceAmount)}',
                                title:
                                    '${Utils.getString('transaction_detail__total')} :',
                              ),
                              const SizedBox(
                                height: AppDimens.space12,
                              ),
                            ],
                          )),
                      const SizedBox(
                        height: AppDimens.space16,
                      ),
                      _AddressWidget(
                        transaction: widget.transactionHeader,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(AppDimens.space16),
                        child: AppButtonWidget(
                          hasShadow: true,
                          width: double.infinity,
                          titleText: Utils.getString(
                              'transaction_detail__view_details'),
                          onPressed: () {
                            Navigator.pushNamed(
                                context, RoutePaths.transactionDetail,
                                arguments: widget.transactionHeader);
                          },
                        ),
                      ),
                      const SizedBox(
                        height: AppDimens.space100,
                      ),
                    ])),
                    _keepingButtonWidget,
                  ],
                ),
              ));
        } else {
          return Container();
        }
      }),
    );
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
          left: AppDimens.space12,
          right: AppDimens.space12,
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

class _AddressWidget extends StatelessWidget {
  const _AddressWidget({
    Key key,
    @required this.transaction,
  }) : super(key: key);

  final TransactionHeader transaction;

  @override
  Widget build(BuildContext context) {
    const Widget _dividerWidget = Divider(
      height: AppDimens.space2,
    );

    const Widget _spacingWidget = SizedBox(
      width: AppDimens.space12,
    );

    const EdgeInsets _paddingEdgeInsetWidget = EdgeInsets.all(16.0);

    return Container(
        color: AppColors.backgroundColor,
        padding: const EdgeInsets.only(
          left: AppDimens.space12,
          right: AppDimens.space12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: _paddingEdgeInsetWidget,
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.pin_drop,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  _spacingWidget,
                  Text(
                    Utils.getString('checkout1__shipping_address'),
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                ],
              ),
            ),
            _dividerWidget,
            const SizedBox(
              height: AppDimens.space8,
            ),
            _TextWidgetForAddress(
              addressInfoText: transaction.shippingPhone,
              title: Utils.getString('transaction_detail__phone'),
            ),
            _TextWidgetForAddress(
              addressInfoText: transaction.shippingEmail,
              title: Utils.getString('transaction_detail__email'),
            ),
            _TextWidgetForAddress(
              addressInfoText: transaction.shippingAddress1,
              title: Utils.getString('transaction_detail__address'),
            ),
            Padding(
              padding: _paddingEdgeInsetWidget,
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.pin_drop,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  _spacingWidget,
                  Text(
                    Utils.getString('checkout1__billing_address'),
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                ],
              ),
            ),
            _dividerWidget,
            const SizedBox(height: AppDimens.space8),
            _TextWidgetForAddress(
              addressInfoText: transaction.billingPhone,
              title: Utils.getString('transaction_detail__phone'),
            ),
            _TextWidgetForAddress(
              addressInfoText: transaction.billingEmail,
              title: Utils.getString('transaction_detail__email'),
            ),
            _TextWidgetForAddress(
              addressInfoText: transaction.billingAddress1,
              title: Utils.getString('transaction_detail__address'),
            ),
            const SizedBox(
              height: AppDimens.space8,
            )
          ],
        ));
  }
}

class _TextWidgetForAddress extends StatelessWidget {
  const _TextWidgetForAddress({
    Key key,
    @required this.addressInfoText,
    this.title,
  }) : super(key: key);

  final String addressInfoText;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
          left: AppDimens.space12,
          right: AppDimens.space12,
          top: AppDimens.space8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: Theme.of(context).textTheme.bodyText2,
          ),
          Padding(
              padding: const EdgeInsets.only(
                  left: AppDimens.space16, top: AppDimens.space8),
              child: Text(
                addressInfoText,
                style: Theme.of(context).textTheme.bodyText2,
              ))
        ],
      ),
    );
  }
}
