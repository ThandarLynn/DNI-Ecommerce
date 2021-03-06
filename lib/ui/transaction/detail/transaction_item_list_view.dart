import 'package:dni_ecommerce/config/app_config.dart';
import 'package:dni_ecommerce/config/app_colors.dart';
import 'package:dni_ecommerce/constant/app_dimens.dart';
import 'package:dni_ecommerce/provider/transaction/transaction_detail_provider.dart';
import 'package:dni_ecommerce/repository/tansaction_detail_repository.dart';
import 'package:dni_ecommerce/ui/common/app_ui_widget.dart';
import 'package:dni_ecommerce/ui/transaction/detail/transaction_item_view.dart';
import 'package:dni_ecommerce/utils/utils.dart';
import 'package:dni_ecommerce/viewobject/common/app_value_holder.dart';
import 'package:dni_ecommerce/viewobject/transaction_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class TransactionItemListView extends StatefulWidget {
  const TransactionItemListView({
    Key key,
    @required this.transaction,
  }) : super(key: key);

  final TransactionHeader transaction;

  @override
  _TransactionItemListViewState createState() =>
      _TransactionItemListViewState();
}

class _TransactionItemListViewState extends State<TransactionItemListView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  TransactionDetailRepository repo1;
  TransactionDetailProvider _transactionDetailProvider;
  AnimationController animationController;
  Animation<double> animation;
  AppValueHolder valueHolder;

  @override
  void dispose() {
    animationController.dispose();
    animation = null;
    super.dispose();
  }

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _transactionDetailProvider
            .nextTransactionDetailList(widget.transaction);
      }
    });

    animationController = AnimationController(
        duration: AppConfig.animation_duration, vsync: this);

    super.initState();
  }

  dynamic data;
  @override
  Widget build(BuildContext context) {
    Future<bool> _requestPop() {
      animationController.reverse().then<dynamic>(
        (void data) {
          if (!mounted) {
            return Future<bool>.value(false);
          }
          Navigator.pop(context, true);
          return Future<bool>.value(true);
        },
      );
      return Future<bool>.value(false);
    }

    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    repo1 = Provider.of<TransactionDetailRepository>(context);
    valueHolder = Provider.of<AppValueHolder>(context);
    return WillPopScope(
        onWillPop: _requestPop,
        child: ChangeNotifierProvider<TransactionDetailProvider>(
          lazy: false,
          create: (BuildContext context) {
            final TransactionDetailProvider provider =
                TransactionDetailProvider(
                    repo: repo1, appValueHolder: valueHolder);
            provider.loadTransactionDetailList(widget.transaction);
            _transactionDetailProvider = provider;
            return provider;
          },
          child: Consumer<TransactionDetailProvider>(builder:
              (BuildContext context, TransactionDetailProvider provider,
                  Widget child) {
            return Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                brightness: Utils.getBrightnessForAppBar(context),
                iconTheme: Theme.of(context)
                    .iconTheme
                    .copyWith(color: AppColors.mainColor),
                title: Text(
                  Utils.getString('transaction_detail__title'),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline6.copyWith(
                      fontWeight: FontWeight.bold, color: AppColors.mainColor),
                ),
                elevation: 0,
              ),
              body: Stack(children: <Widget>[
                RefreshIndicator(
                  child: CustomScrollView(
                      controller: _scrollController,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      slivers: <Widget>[
                        SliverToBoxAdapter(
                          child: _TransactionNoWidget(
                              transaction: widget.transaction,
                              valueHolder: valueHolder,
                              scaffoldKey: scaffoldKey),
                        ),
                        SliverToBoxAdapter(
                          child: _AddressWidget(
                            transaction: widget.transaction,
                          ),
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              if (provider.transactionDetailList.data != null ||
                                  provider
                                      .transactionDetailList.data.isNotEmpty) {
                                final int count =
                                    provider.transactionDetailList.data.length;
                                return TransactionItemView(
                                  animationController: animationController,
                                  animation: Tween<double>(begin: 0.0, end: 1.0)
                                      .animate(
                                    CurvedAnimation(
                                      parent: animationController,
                                      curve: Interval((1 / count) * index, 1.0,
                                          curve: Curves.fastOutSlowIn),
                                    ),
                                  ),
                                  transaction: provider
                                      .transactionDetailList.data[index],
                                );
                              } else {
                                return null;
                              }
                            },
                            childCount:
                                provider.transactionDetailList.data.length,
                          ),
                        ),
                      ]),
                  onRefresh: () {
                    return provider
                        .resetTransactionDetailList(widget.transaction);
                  },
                ),
                AppProgressIndicator(provider.transactionDetailList.status)
              ]),
            );
          }),
        ));
  }
}

class _TransactionNoWidget extends StatelessWidget {
  const _TransactionNoWidget({
    Key key,
    @required this.transaction,
    @required this.valueHolder,
    this.scaffoldKey,
  }) : super(key: key);

  final TransactionHeader transaction;
  final AppValueHolder valueHolder;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
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
        Clipboard.setData(ClipboardData(text: transaction.transCode));
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
    );
    return Container(
        color: AppColors.backgroundColor,
        padding: const EdgeInsets.only(
          left: AppDimens.space12,
          right: AppDimens.space12,
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(AppDimens.space8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        const SizedBox(
                          width: AppDimens.space8,
                        ),
                        Icon(
                          Icons.offline_pin,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        const SizedBox(
                          width: AppDimens.space8,
                        ),
                        Expanded(
                          child: Text(
                              '${Utils.getString('transaction_detail__trans_no')} : ${transaction.transCode}',
                              textAlign: TextAlign.left,
                              style: Theme.of(context).textTheme.subtitle1),
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
              transationInfoText: transaction.totalItemCount,
              title:
                  '${Utils.getString('transaction_detail__total_item_count')} :',
            ),
            _TransactionNoTextWidget(
              transationInfoText:
                  '\$ ${Utils.getPriceFormat(transaction.totalItemAmount)}',
              title:
                  '${Utils.getString('transaction_detail__total_item_price')} :',
            ),
            _TransactionNoTextWidget(
              transationInfoText: transaction.discountAmount == '0'
                  ? '-'
                  : '\$ ${Utils.getPriceFormat(transaction.discountAmount)}',
              title: '${Utils.getString('transaction_detail__discount')} :',
            ),
            // _TransactionNoTextWidget(
            //   transationInfoText: transaction.cuponDiscountAmount == '0'
            //       ? '-'
            //       : '\$ ${Utils.getPriceFormat(transaction.cuponDiscountAmount)}',
            //   title:
            //       '${Utils.getString('transaction_detail__coupon_discount')} :',
            // ),
            const SizedBox(
              height: AppDimens.space12,
            ),
            _dividerWidget,
            _TransactionNoTextWidget(
              transationInfoText:
                  '\$ ${Utils.getPriceFormat(transaction.subTotalAmount)}',
              title: '${Utils.getString('transaction_detail__sub_total')} :',
            ),
            _TransactionNoTextWidget(
              transationInfoText:
                  '\$ ${Utils.getPriceFormat(transaction.taxAmount)}',
              title:
                  '${Utils.getString('transaction_detail__tax')}(${valueHolder.overAllTaxLabel} %) :',
            ),
            // _TransactionNoTextWidget(
            //   transationInfoText:
            //       '\$ ${Utils.getPriceFormat(transaction.shippingMethodAmount)}',
            //   title:
            //       '${Utils.getString('transaction_detail__shipping_cost')} :',
            // ),
            // _TransactionNoTextWidget(
            //   transationInfoText:
            //       '\$ ${Utils.getPriceFormat(transaction.shippingAmount)}',
            //   title:
            //       '${Utils.getString('transaction_detail__shipping_tax')}(${valueHolder.shippingTaxLabel} %) :',
            // ),
            const SizedBox(
              height: AppDimens.space12,
            ),
            _dividerWidget,
            _TransactionNoTextWidget(
              transationInfoText:
                  '\$ ${Utils.getPriceFormat(transaction.balanceAmount)}',
              title: '${Utils.getString('transaction_detail__total')} :',
            ),
            const SizedBox(
              height: AppDimens.space12,
            ),
            _dividerWidget,
            _TransactionNoTextWidget(
              transationInfoText: '${transaction.selectedDays}  ' +
                  Utils.getString('checkout2__days'),
              title: '${Utils.getString('checkout2__shipping_method')} :',
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
        margin: const EdgeInsets.only(top: AppDimens.space8),
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
                    Utils.getString('transaction_detail__shipping_address'),
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ],
              ),
            ),
            _dividerWidget,
            // _TextWidgetForAddress(
            //   addressInfoText: transaction.shippingPhone,
            //   title: Utils.getString('transaction_detail__phone'),
            // ),
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
                    Utils.getString('transaction_detail__billing_address'),
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ],
              ),
            ),
            _dividerWidget,
            // _TextWidgetForAddress(
            //   addressInfoText: transaction.billingPhone,
            //   title: Utils.getString('transaction_detail__phone'),
            // ),
            // _TextWidgetForAddress(
            //   addressInfoText: transaction.billingEmail,
            //   title: Utils.getString('transaction_detail__email'),
            // ),
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
      margin: const EdgeInsets.only(top: AppDimens.space8),
      padding: const EdgeInsets.only(
        left: AppDimens.space12,
        right: AppDimens.space12,
      ),
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
