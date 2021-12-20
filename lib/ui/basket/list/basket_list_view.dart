import 'package:dni_ecommerce/config/app_config.dart';
import 'package:dni_ecommerce/config/app_colors.dart';
import 'package:dni_ecommerce/constant/app_dimens.dart';
import 'package:dni_ecommerce/constant/route_paths.dart';
import 'package:dni_ecommerce/provider/basket/basket_provider.dart';
import 'package:dni_ecommerce/repository/basket_repository.dart';
import 'package:dni_ecommerce/ui/common/dialog/confirm_dialog_view.dart';
import 'package:dni_ecommerce/ui/common/dialog/error_dialog.dart';
import 'package:dni_ecommerce/utils/app_progress_dialog.dart';
import 'package:dni_ecommerce/utils/utils.dart';
import 'package:dni_ecommerce/viewobject/basket.dart';
import 'package:dni_ecommerce/viewobject/common/app_value_holder.dart';
import 'package:dni_ecommerce/viewobject/holder/checkout_intent_holder.dart';
import 'package:dni_ecommerce/viewobject/holder/intent/product_detail_intent_holder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../item/basket_list_item.dart';

class BasketListView extends StatefulWidget {
  const BasketListView({
    Key key,
    @required this.animationController,
  }) : super(key: key);

  final AnimationController animationController;
  @override
  _BasketListViewState createState() => _BasketListViewState();
}

class _BasketListViewState extends State<BasketListView>
    with SingleTickerProviderStateMixin {
  BasketRepository basketRepo;
  AppValueHolder valueHolder;
  dynamic data;
  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;

  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
      if (isConnectedToInternet && AppConfig.showAdMob) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isConnectedToInternet && AppConfig.showAdMob) {
      print('loading ads....');
      checkConnection();
    }

    basketRepo = Provider.of<BasketRepository>(context);

    return MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider<BasketProvider>(
            lazy: false,
            create: (BuildContext context) {
              final BasketProvider provider = BasketProvider(repo: basketRepo);
              provider.loadBasketList();
              return provider;
            }),
      ],
      child: Consumer<BasketProvider>(builder:
          (BuildContext context, BasketProvider provider, Widget child) {
        if (provider.basketList != null && provider.basketList.data != null) {
          if (provider.basketList.data.isNotEmpty) {
            return Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // const PsAdMobBannerWidget(),
                // Visibility(
                //   visible: AppConfig.showAdMob &&
                //       isSuccessfullyLoaded &&
                //       isConnectedToInternet,
                //   child: AdmobBanner(
                //     adUnitId: Utils.getBannerAdUnitId(),
                //     adSize: AdmobBannerSize.FULL_BANNER,
                //     listener:
                //         (AdmobAdEvent event, Map<String, dynamic> map) {
                //       print('BannerAd event is $event');
                //       if (event == AdmobAdEvent.loaded) {
                //         isSuccessfullyLoaded = true;
                //       } else {
                //         isSuccessfullyLoaded = false;
                //         setState(() {});
                //       }
                //     },
                //   ),
                // ),
                Expanded(
                  child: Container(
                      child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: provider.basketList.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      final int count = provider.basketList.data.length;
                      widget.animationController.forward();
                      return BasketListItemView(
                          animationController: widget.animationController,
                          animation:
                              Tween<double>(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                              parent: widget.animationController,
                              curve: Interval((1 / count) * index, 1.0,
                                  curve: Curves.fastOutSlowIn),
                            ),
                          ),
                          basket: provider.basketList.data[index],
                          onTap: () {
                            Navigator.pushNamed(
                                context, RoutePaths.productDetail,
                                arguments: ProductDetailIntentHolder(
                                  id: provider.basketList.data[index].id,
                                  qty: provider.basketList.data[index].qty,
                                  selectedColorId: provider
                                      .basketList.data[index].selectedColorId,
                                  selectedColorValue: provider.basketList
                                      .data[index].selectedColorValue,
                                  selectedSizeId: provider
                                      .basketList.data[index].selectedSizeId,
                                  selectedSizeValue: provider
                                      .basketList.data[index].selectedSizeValue,
                                  basketPrice: provider
                                      .basketList.data[index].basketPrice,
                                  basketSelectedAttributeList: provider
                                      .basketList
                                      .data[index]
                                      .basketSelectedAttributeList,
                                  product:
                                      provider.basketList.data[index].product,
                                  heroTagImage: '',
                                  heroTagTitle: '',
                                  heroTagOriginalPrice: '',
                                  heroTagUnitPrice: '',
                                ));
                          },
                          onDeleteTap: () {
                            showDialog<dynamic>(
                                context: context,
                                builder: (BuildContext context) {
                                  return ConfirmDialogView(
                                      description: Utils.getString(
                                          'basket_list__confirm_dialog_description'),
                                      leftButtonText: Utils.getString(
                                          'basket_list__comfirm_dialog_cancel_button'),
                                      rightButtonText: Utils.getString(
                                          'basket_list__comfirm_dialog_ok_button'),
                                      onAgreeTap: () async {
                                        Navigator.of(context).pop();
                                        provider.deleteBasketByProduct(
                                            provider.basketList.data[index]);
                                      });
                                });
                          });
                    },
                  )),
                ),
                _CheckoutButtonWidget(
                  provider: provider,
                ),
              ],
            );
          } else {
            widget.animationController.forward();
            final Animation<double> animation =
                Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                    parent: widget.animationController,
                    curve: const Interval(0.5 * 1, 1.0,
                        curve: Curves.fastOutSlowIn)));
            return AnimatedBuilder(
              animation: widget.animationController,
              child: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  padding: const EdgeInsets.only(bottom: AppDimens.space120),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Image.asset(
                        'assets/images/empty_basket.png',
                        height: 150,
                        width: 200,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(
                        height: AppDimens.space32,
                      ),
                      Text(
                        Utils.getString('basket_list__empty_cart_title'),
                        style: Theme.of(context).textTheme.bodyText1.copyWith(),
                      ),
                      const SizedBox(
                        height: AppDimens.space20,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                            Utils.getString(
                                'basket_list__empty_cart_description'),
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(),
                            textAlign: TextAlign.center),
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
                        child: child));
              },
            );
          }
        } else {
          return Container();
        }
      }),
    );
  }
}

class _CheckoutButtonWidget extends StatelessWidget {
  const _CheckoutButtonWidget({
    Key key,
    @required this.provider,
  }) : super(key: key);

  final BasketProvider provider;
  @override
  Widget build(BuildContext context) {
    double totalPrice = 0.0;
    int qty = 0;
    // final String currencySymbol;

    for (Basket basket in provider.basketList.data) {
      totalPrice += double.parse(basket.basketPrice) * double.parse(basket.qty);

      qty += int.parse(basket.qty);
      // currencySymbol = '\$';
    }

    return Container(
        alignment: Alignment.bottomCenter,
        padding: const EdgeInsets.all(AppDimens.space8),
        decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          border: Border.all(color: AppColors.mainLightShadowColor),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(AppDimens.space12),
              topRight: Radius.circular(AppDimens.space12)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: AppColors.mainShadowColor,
                offset: const Offset(1.1, 1.1),
                blurRadius: 7.0),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: AppDimens.space8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text(
                  '${Utils.getString('checkout__price')} \$ ${Utils.getPriceFormat(totalPrice.toString())}',
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                Text(
                  '$qty  ${Utils.getString('checkout__items')}',
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ],
            ),
            const SizedBox(height: AppDimens.space8),
            Card(
              elevation: 0,
              color: AppColors.mainColor,
              shape: const BeveledRectangleBorder(
                  borderRadius:
                      BorderRadius.all(Radius.circular(AppDimens.space8))),
              child: InkWell(
                onTap: () async {
                  if (await Utils.checkInternetConnectivity()) {
                    // Basket Item Count Check
                    // Need to have at least 1 item in basket
                    if (provider.basketList == null ||
                        provider.basketList.data.isEmpty) {
                      // Show Error Dialog
                      showDialog<dynamic>(
                          context: context,
                          builder: (BuildContext context) {
                            return ErrorDialog(
                              message: Utils.getString(
                                  'basket_list__empty_cart_title'),
                            );
                          });
                    }

                    // Get Currency Symbol
                    // final String currencySymbol =
                    //     provider.basketList.data[0].product.currencySymbol;

                    // Try to get Minmium Order Amount
                    // If there is no error, allow to call next page.

                    // final String shopId =
                    //     provider.basketList.data[0].product.shop.id;

                    await AppProgressDialog.showDialog(context);

                    AppProgressDialog.dismissDialog();

                    // if (shopInfoProvider.shopInfo.data != null) {
                    // double minOrderAmount = 1;

                    Utils.navigateOnUserVerificationView(context, () async {
                      await Navigator.pushNamed(
                          context, RoutePaths.checkout_container,
                          arguments: CheckoutIntentHolder(
                            basketList: provider.basketList.data,
                          ));
                    });
                    // }
                  } else {
                    showDialog<dynamic>(
                        context: context,
                        builder: (BuildContext context) {
                          return ErrorDialog(
                            message:
                                Utils.getString('error_dialog__no_internet'),
                          );
                        });
                  }
                },
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 40,
                    padding: const EdgeInsets.only(
                        left: AppDimens.space4, right: AppDimens.space4),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: <Color>[
                        AppColors.mainColor,
                        AppColors.mainDarkColor,
                      ]),
                      borderRadius: const BorderRadius.all(
                          Radius.circular(AppDimens.space12)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color:
                                AppColors.mainColorWithBlack.withOpacity(0.6),
                            offset: const Offset(0, 4),
                            blurRadius: 8.0,
                            spreadRadius: 3.0),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.payment, color: AppColors.white),
                        const SizedBox(
                          width: AppDimens.space8,
                        ),
                        Text(
                          Utils.getString('basket_list__checkout_button_name'),
                          style: Theme.of(context)
                              .textTheme
                              .button
                              .copyWith(color: AppColors.white),
                        ),
                      ],
                    )),
              ),
            ),
            const SizedBox(height: AppDimens.space8),
          ],
        ));
  }
}
