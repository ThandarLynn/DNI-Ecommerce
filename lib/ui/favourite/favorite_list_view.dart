import 'package:dni_ecommerce/config/app_config.dart';
import 'package:dni_ecommerce/constant/app_constant.dart';
import 'package:dni_ecommerce/constant/app_dimens.dart';
import 'package:dni_ecommerce/constant/route_paths.dart';
import 'package:dni_ecommerce/provider/history/history_provider.dart';
import 'package:dni_ecommerce/repository/history_repsitory.dart';
import 'package:dni_ecommerce/utils/utils.dart';
import 'package:dni_ecommerce/viewobject/holder/intent/product_detail_intent_holder.dart';
import 'package:dni_ecommerce/viewobject/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'favorite_list_item.dart';

class FavoriteListView extends StatefulWidget {
  const FavoriteListView({Key key, @required this.animationController})
      : super(key: key);
  final AnimationController animationController;
  @override
  _FavoriteListViewState createState() => _FavoriteListViewState();
}

class _FavoriteListViewState extends State<FavoriteListView>
    with SingleTickerProviderStateMixin {
  HistoryRepository historyRepo;
  dynamic data;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
    // data = EasyLocalizationProvider.of(context).data;
    historyRepo = Provider.of<HistoryRepository>(context);

    if (!isConnectedToInternet && AppConfig.showAdMob) {
      print('loading ads....');
      checkConnection();
    }
    return ChangeNotifierProvider<HistoryProvider>(
        lazy: false,
        create: (BuildContext context) {
          final HistoryProvider provider = HistoryProvider(
            repo: historyRepo,
          );
          provider.loadHistoryList();
          return provider;
        },
        child: Consumer<HistoryProvider>(
          builder:
              (BuildContext context, HistoryProvider provider, Widget child) {
            if (provider.historyList != null &&
                provider.historyList.data != null) {
              return Column(
                children: <Widget>[
                  // const PsAdMobBannerWidget(),
                  // Visibility(
                  //   visible: AppConfig.showAdMob &&
                  //       isSuccessfullyLoaded &&
                  //       isConnectedToInternet,
                  //   child: AdmobBanner(
                  //     adUnitId: Utils.getBannerAdUnitId(),
                  //     adSize: AdmobBannerSize.FULL_BANNER,
                  //     listener: (AdmobAdEvent event, Map<String, dynamic> map) {
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
                      margin: const EdgeInsets.only(bottom: AppDimens.space10),
                      child: RefreshIndicator(
                        child: CustomScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            slivers: <Widget>[
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                    final int count =
                                        provider.historyList.data.length;
                                    return FavoriteListItem(
                                      animationController:
                                          widget.animationController,
                                      animation:
                                          Tween<double>(begin: 0.0, end: 1.0)
                                              .animate(
                                        CurvedAnimation(
                                          parent: widget.animationController,
                                          curve: Interval(
                                              (1 / count) * index, 1.0,
                                              curve: Curves.fastOutSlowIn),
                                        ),
                                      ),
                                      history: provider
                                          .historyList.data.reversed
                                          .toList()[index],
                                      onDeleteTap: () {
                                        provider.removeHistoryFromList(provider
                                            .historyList.data.reversed
                                            .toList()[index]);
                                      },
                                      onTap: () {
                                        final Product product = provider
                                            .historyList.data.reversed
                                            .toList()[index];
                                        final ProductDetailIntentHolder holder =
                                            ProductDetailIntentHolder(
                                          product: product,
                                          heroTagImage:
                                              provider.hashCode.toString() +
                                                  product.id +
                                                  AppConst.HERO_TAG__IMAGE,
                                          heroTagTitle:
                                              provider.hashCode.toString() +
                                                  product.id +
                                                  AppConst.HERO_TAG__TITLE,
                                          heroTagOriginalPrice: provider
                                                  .hashCode
                                                  .toString() +
                                              product.id +
                                              AppConst.HERO_TAG__ORIGINAL_PRICE,
                                          heroTagUnitPrice:
                                              provider.hashCode.toString() +
                                                  product.id +
                                                  AppConst.HERO_TAG__UNIT_PRICE,
                                        );

                                        Navigator.pushNamed(
                                            context, RoutePaths.productDetail,
                                            arguments: holder);
                                      },
                                    );
                                  },
                                  childCount: provider.historyList.data.length,
                                ),
                              )
                            ]),
                        onRefresh: () {
                          return provider.resetHistoryList();
                        },
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Container();
            }
          },
        ));
  }
}
