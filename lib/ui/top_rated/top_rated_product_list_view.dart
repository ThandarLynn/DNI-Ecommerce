import 'package:dni_ecommerce/config/app_config.dart';
import 'package:dni_ecommerce/constant/app_constant.dart';
import 'package:dni_ecommerce/constant/app_dimens.dart';
import 'package:dni_ecommerce/constant/route_paths.dart';
import 'package:dni_ecommerce/provider/product/top_rated_product_provider.dart';
import 'package:dni_ecommerce/repository/product_repository.dart';
import 'package:dni_ecommerce/ui/common/app_ui_widget.dart';
import 'package:dni_ecommerce/ui/product/product_vertical_list_item.dart';
import 'package:dni_ecommerce/utils/utils.dart';
import 'package:dni_ecommerce/viewobject/common/app_value_holder.dart';
import 'package:dni_ecommerce/viewobject/holder/intent/product_detail_intent_holder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dni_ecommerce/viewobject/product.dart';
import 'package:provider/provider.dart';

class TopRatedProductListView extends StatefulWidget {
  const TopRatedProductListView({Key key, @required this.animationController})
      : super(key: key);
  final AnimationController animationController;
  @override
  _TopRatedProductListView createState() => _TopRatedProductListView();
}

class _TopRatedProductListView extends State<TopRatedProductListView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  TopRatedProductProvider _favouriteProductProvider;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _favouriteProductProvider.nextTopRatedProductList();
      }
    });

    super.initState();
  }

  ProductRepository repo1;
  AppValueHolder appValueHolder;
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
    repo1 = Provider.of<ProductRepository>(context);
    appValueHolder = Provider.of<AppValueHolder>(context);

    if (!isConnectedToInternet && AppConfig.showAdMob) {
      print('loading ads....');
      checkConnection();
    }
    print(
        '............................Build UI Again ............................');
    return ChangeNotifierProvider<TopRatedProductProvider>(
      lazy: false,
      create: (BuildContext context) {
        final TopRatedProductProvider provider = TopRatedProductProvider(
            repo: repo1, appValueHolder: appValueHolder);
        provider.loadTopRatedProductList();
        _favouriteProductProvider = provider;
        return _favouriteProductProvider;
      },
      child: Consumer<TopRatedProductProvider>(
        builder: (BuildContext context, TopRatedProductProvider provider,
            Widget child) {
          return Column(
            children: <Widget>[
              // const AppAdMobBannerWidget(),
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
                child: Stack(children: <Widget>[
                  Container(
                      margin: const EdgeInsets.only(
                          left: AppDimens.space4,
                          right: AppDimens.space4,
                          top: AppDimens.space4,
                          bottom: AppDimens.space4),
                      child: RefreshIndicator(
                        child: CustomScrollView(
                            controller: _scrollController,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            slivers: <Widget>[
                              SliverGrid(
                                gridDelegate:
                                    const SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent: 220.0,
                                        childAspectRatio: 0.6),
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                    if (provider.topSellingProductList.data !=
                                            null ||
                                        provider.topSellingProductList.data
                                            .isNotEmpty) {
                                      final int count = provider
                                          .topSellingProductList.data.length;
                                      return ProductVeticalListItem(
                                        coreTagKey:
                                            provider.hashCode.toString() +
                                                provider.topSellingProductList
                                                    .data[index].id,
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
                                        product: provider
                                            .topSellingProductList.data[index],
                                        onTap: () async {
                                          final Product product = provider
                                              .topSellingProductList
                                              .data[index];
                                          final ProductDetailIntentHolder
                                              holder =
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
                                                AppConst
                                                    .HERO_TAG__ORIGINAL_PRICE,
                                            heroTagUnitPrice: provider.hashCode
                                                    .toString() +
                                                product.id +
                                                AppConst.HERO_TAG__UNIT_PRICE,
                                          );

                                          await Navigator.pushNamed(
                                              context, RoutePaths.productDetail,
                                              arguments: holder);

                                          await provider
                                              .resetTopRatedProductList();
                                        },
                                      );
                                    } else {
                                      return null;
                                    }
                                  },
                                  childCount: provider
                                      .topSellingProductList.data.length,
                                ),
                              ),
                            ]),
                        onRefresh: () {
                          return provider.resetTopRatedProductList();
                        },
                      )),
                  AppProgressIndicator(provider.topSellingProductList.status)
                ]),
              )
            ],
          );
        },
      ),
    );
  }
}
