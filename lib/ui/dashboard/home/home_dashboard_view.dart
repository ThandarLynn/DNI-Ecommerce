import 'package:dni_ecommerce/api/common/app_status.dart';
import 'package:dni_ecommerce/config/app_config.dart';
import 'package:dni_ecommerce/config/app_colors.dart';
import 'package:dni_ecommerce/constant/app_constant.dart';
import 'package:dni_ecommerce/constant/app_dimens.dart';
import 'package:dni_ecommerce/constant/route_paths.dart';
import 'package:dni_ecommerce/provider/blog/blog_provider.dart';
import 'package:dni_ecommerce/provider/category/category_provider.dart';
import 'package:dni_ecommerce/provider/product/discount_product_provider.dart';
import 'package:dni_ecommerce/provider/product/search_product_provider.dart';
import 'package:dni_ecommerce/provider/product/top_rated_product_provider.dart';
import 'package:dni_ecommerce/provider/product/top_selling_product_provider.dart';
import 'package:dni_ecommerce/repository/blog_repository.dart';
import 'package:dni_ecommerce/repository/category_repository.dart';
import 'package:dni_ecommerce/repository/product_repository.dart';
import 'package:dni_ecommerce/ui/category/category_horizontal_list_item.dart';
import 'package:dni_ecommerce/ui/common/app_frame_loading_widget.dart';
import 'package:dni_ecommerce/ui/dashboard/home/blog_slider.dart';
import 'package:dni_ecommerce/ui/product/product_horizontal_list_item.dart';
import 'package:dni_ecommerce/utils/utils.dart';
import 'package:dni_ecommerce/viewobject/common/app_value_holder.dart';
import 'package:dni_ecommerce/viewobject/holder/intent/product_detail_intent_holder.dart';
import 'package:dni_ecommerce/viewobject/holder/intent/product_list_intent_holder.dart';
import 'package:dni_ecommerce/viewobject/holder/product_parameter_holder.dart';
import 'package:dni_ecommerce/viewobject/product.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shimmer/shimmer.dart';

class HomeDashboardView extends StatefulWidget {
  const HomeDashboardView(this.animationController, this.context);

  final AnimationController animationController;
  final BuildContext context;

  @override
  _HomeDashboardViewState createState() => _HomeDashboardViewState();
}

class _HomeDashboardViewState extends State<HomeDashboardView> {
  AppValueHolder valueHolder;
  CategoryRepository repo1;
  ProductRepository repo2;
  BlogRepository repo3;
  CategoryProvider _categoryProvider;
  SearchProductProvider _searchProductProvider;
  DiscountProductProvider _discountProductProvider;
  TopSellingProductProvider _topSellingProductProvider;
  TopRatedProductProvider _topRatedProductProvider;
  BlogProvider _blogProvider;
  final int count = 8;

  @override
  Widget build(BuildContext context) {
    repo1 = Provider.of<CategoryRepository>(context);
    repo2 = Provider.of<ProductRepository>(context);
    repo3 = Provider.of<BlogRepository>(context);
    valueHolder = Provider.of<AppValueHolder>(context);

    return MultiProvider(
        providers: <SingleChildWidget>[
          ChangeNotifierProvider<TopSellingProductProvider>(
              lazy: false,
              create: (BuildContext context) {
                _topSellingProductProvider = TopSellingProductProvider(
                    repo: repo2,
                    appValueHolder: valueHolder,
                    limit: AppConfig.LATEST_PRODUCT_LOADING_LIMIT);
                _topSellingProductProvider.loadTopSellingProductList();
                return _topSellingProductProvider;
              }),
          ChangeNotifierProvider<TopRatedProductProvider>(
              lazy: false,
              create: (BuildContext context) {
                _topRatedProductProvider = TopRatedProductProvider(
                    repo: repo2,
                    appValueHolder: valueHolder,
                    limit: AppConfig.LATEST_PRODUCT_LOADING_LIMIT);
                _topRatedProductProvider.loadTopRatedProductList();
                return _topRatedProductProvider;
              }),
          ChangeNotifierProvider<CategoryProvider>(
              lazy: false,
              create: (BuildContext context) {
                _categoryProvider ??= CategoryProvider(
                    repo: repo1,
                    appValueHolder: valueHolder,
                    limit: AppConfig.CATEGORY_LOADING_LIMIT);
                _categoryProvider.loadCategoryList().then((dynamic value) {
                  // Utils.psPrint("Is Has Internet " + value);
                  final bool isConnectedToIntenet = value ?? bool;
                  if (!isConnectedToIntenet) {
                    Fluttertoast.showToast(
                        msg: 'No Internet Connectiion. Please try again !',
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.blueGrey,
                        textColor: Colors.white);
                  }
                });
                return _categoryProvider;
              }),
          ChangeNotifierProvider<SearchProductProvider>(
              lazy: false,
              create: (BuildContext context) {
                _searchProductProvider = SearchProductProvider(
                    repo: repo2, limit: AppConfig.LATEST_PRODUCT_LOADING_LIMIT);
                _searchProductProvider.loadProductListByKey(
                    ProductParameterHolder().getLatestParameterHolder());
                return _searchProductProvider;
              }),
          ChangeNotifierProvider<DiscountProductProvider>(
              lazy: false,
              create: (BuildContext context) {
                _discountProductProvider = DiscountProductProvider(
                    repo: repo2,
                    limit: AppConfig.DISCOUNT_PRODUCT_LOADING_LIMIT);
                _discountProductProvider.loadProductList();
                return _discountProductProvider;
              }),
          ChangeNotifierProvider<BlogProvider>(
              lazy: false,
              create: (BuildContext context) {
                _blogProvider = BlogProvider(
                    repo: repo3,
                    limit: AppConfig.COLLECTION_PRODUCT_LOADING_LIMIT);
                _blogProvider.loadBlogList();
                return _blogProvider;
              }),
        ],
        child: Container(
          // color: AppColors.coreBackgroundColor,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            slivers: <Widget>[
              _HomeBlogProductSliderListWidget(
                animationController:
                    widget.animationController, //animationController,
                animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                        parent: widget.animationController,
                        curve: Interval((1 / count) * 1, 1.0,
                            curve: Curves.fastOutSlowIn))), //animation
              ),
              _HomeCategoryHorizontalListWidget(
                appValueHolder: valueHolder,
                animationController: widget.animationController,
                //animationController,
                animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                        parent: widget.animationController,
                        curve: Interval((1 / count) * 2, 1.0,
                            curve: Curves.fastOutSlowIn))), //animation
              ),
              _TopSellingProductHorizontalListWidget(
                animationController: widget.animationController,
                //animationController,
                animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                        parent: widget.animationController,
                        curve: Interval((1 / count) * 5, 1.0,
                            curve: Curves.fastOutSlowIn))), //animation
              ),
              _TopRatedProductHorizontalListWidget(
                animationController: widget.animationController,
                //animationController,
                animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                        parent: widget.animationController,
                        curve: Interval((1 / count) * 5, 1.0,
                            curve: Curves.fastOutSlowIn))), //animation
              ),
              _HomeLatestProductHorizontalListWidget(
                animationController: widget.animationController,
                //animationController,
                animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                        parent: widget.animationController,
                        curve: Interval((1 / count) * 3, 1.0,
                            curve: Curves.fastOutSlowIn))), //animation
              ),
              _DiscountProductHorizontalListWidget(
                animationController: widget.animationController,
                //animationController,
                animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                        parent: widget.animationController,
                        curve: Interval((1 / count) * 4, 1.0,
                            curve: Curves.fastOutSlowIn))), //animation
              ),
            ],
          ),
        ));
  }
}

class _TopSellingProductHorizontalListWidget extends StatefulWidget {
  const _TopSellingProductHorizontalListWidget({
    Key key,
    @required this.animationController,
    @required this.animation,
  }) : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;

  @override
  __TopSellingProductHorizontalListWidgetState createState() =>
      __TopSellingProductHorizontalListWidgetState();
}

class __TopSellingProductHorizontalListWidgetState
    extends State<_TopSellingProductHorizontalListWidget> {
  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;

  // void checkConnection() {
  //   Utils.checkInternetConnectivity().then((bool onValue) {
  //     isConnectedToInternet = onValue;
  //     if (isConnectedToInternet && AppConfig.showAdMob) {
  //       setState(() {});
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // if (!isConnectedToInternet && AppConfig.showAdMob) {
    //   print('loading ads....');
    //   checkConnection();
    // }
    return SliverToBoxAdapter(child: Consumer<TopSellingProductProvider>(
        builder: (BuildContext context,
            TopSellingProductProvider productProvider, Widget child) {
      return AnimatedBuilder(
          animation: widget.animationController,
          child: (productProvider.topSellingProductList.data != null &&
                  productProvider.topSellingProductList.data.isNotEmpty)
              ? Column(children: <Widget>[
                  _MyHeaderWidget(
                    headerName:
                        Utils.getString('dashboard__top_selling_product'),
                    viewAllClicked: () {
                      Navigator.pushNamed(context, RoutePaths.filterProductList,
                          arguments: ProductListIntentHolder(
                              appBarTitle: Utils.getString(
                                  'dashboard__discount_product'),
                              productParameterHolder: ProductParameterHolder()
                                  .getDiscountParameterHolder()));
                    },
                  ),
                  Container(
                      height: AppDimens.space320,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding:
                              const EdgeInsets.only(left: AppDimens.space16),
                          itemCount: productProvider
                                  .topSellingProductList.data.length ??
                              0,
                          itemBuilder: (BuildContext context, int index) {
                            if (productProvider.topSellingProductList.status ==
                                AppStatus.BLOCK_LOADING) {
                              return Shimmer.fromColors(
                                  baseColor: AppColors.grey,
                                  highlightColor: AppColors.white,
                                  child: Row(children: const <Widget>[
                                    AppFrameUIForLoading(),
                                  ]));
                            } else {
                              final Product product = productProvider
                                  .topSellingProductList.data[index];
                              return ProductHorizontalListItem(
                                coreTagKey:
                                    productProvider.hashCode.toString() +
                                        product.id,
                                product: productProvider
                                    .topSellingProductList.data[index],
                                onTap: () async {
                                  // print(productProvider
                                  //     .topSellingProductList.data[index].image.url);
                                  final ProductDetailIntentHolder holder =
                                      ProductDetailIntentHolder(
                                    product: productProvider
                                        .topSellingProductList.data[index],
                                    heroTagImage:
                                        productProvider.hashCode.toString() +
                                            product.id +
                                            AppConst.HERO_TAG__IMAGE,
                                    heroTagTitle:
                                        productProvider.hashCode.toString() +
                                            product.id +
                                            AppConst.HERO_TAG__TITLE,
                                    heroTagOriginalPrice:
                                        productProvider.hashCode.toString() +
                                            product.id +
                                            AppConst.HERO_TAG__ORIGINAL_PRICE,
                                    heroTagUnitPrice:
                                        productProvider.hashCode.toString() +
                                            product.id +
                                            AppConst.HERO_TAG__UNIT_PRICE,
                                  );
                                  final dynamic result =
                                      await Navigator.pushNamed(
                                          context, RoutePaths.productDetail,
                                          arguments: holder);
                                  if (result == null) {
                                    setState(() {
                                      productProvider
                                          .resetTopSellingProductList();
                                    });
                                  }
                                },
                              );
                            }
                          })),
                  // const PsAdMobBannerWidget(
                  //   admobSize: NativeAdmobType.full,
                  //   // admobBannerSize: AdmobBannerSize.MEDIUM_RECTANGLE,
                  // ),
                  // Visibility(
                  //   visible: AppConfig.showAdMob &&
                  //       isSuccessfullyLoaded &&
                  //       isConnectedToInternet,
                  //   child: AdmobBanner(
                  //     adUnitId: Utils.getBannerAdUnitId(),
                  //     adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
                  //     listener: (AdmobAdEvent event,
                  //         Map<String, dynamic> map) {
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
                ])
              : Container(),
          builder: (BuildContext context, Widget child) {
            return FadeTransition(
                opacity: widget.animation,
                child: Transform(
                    transform: Matrix4.translationValues(
                        0.0, 100 * (1.0 - widget.animation.value), 0.0),
                    child: child));
          });
    }));
  }
}

class _TopRatedProductHorizontalListWidget extends StatefulWidget {
  const _TopRatedProductHorizontalListWidget({
    Key key,
    @required this.animationController,
    @required this.animation,
  }) : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;

  @override
  __TopRatedProductHorizontalListWidgetState createState() =>
      __TopRatedProductHorizontalListWidgetState();
}

class __TopRatedProductHorizontalListWidgetState
    extends State<_TopRatedProductHorizontalListWidget> {
  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;

  // void checkConnection() {
  //   Utils.checkInternetConnectivity().then((bool onValue) {
  //     isConnectedToInternet = onValue;
  //     if (isConnectedToInternet && AppConfig.showAdMob) {
  //       setState(() {});
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // if (!isConnectedToInternet && AppConfig.showAdMob) {
    //   print('loading ads....');
    //   checkConnection();
    // }
    return SliverToBoxAdapter(child: Consumer<TopRatedProductProvider>(builder:
        (BuildContext context, TopRatedProductProvider productProvider,
            Widget child) {
      return AnimatedBuilder(
          animation: widget.animationController,
          child: (productProvider.topSellingProductList.data != null &&
                  productProvider.topSellingProductList.data.isNotEmpty)
              ? Column(children: <Widget>[
                  _MyHeaderWidget(
                    headerName: Utils.getString('dashboard__top_rated_product'),
                    viewAllClicked: () {
                      Navigator.pushNamed(context, RoutePaths.filterProductList,
                          arguments: ProductListIntentHolder(
                              appBarTitle: Utils.getString(
                                  'dashboard__discount_product'),
                              productParameterHolder: ProductParameterHolder()
                                  .getDiscountParameterHolder()));
                    },
                  ),
                  Container(
                      height: AppDimens.space320,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding:
                              const EdgeInsets.only(left: AppDimens.space16),
                          itemCount: productProvider
                                  .topSellingProductList.data.length ??
                              0,
                          itemBuilder: (BuildContext context, int index) {
                            if (productProvider.topSellingProductList.status ==
                                AppStatus.BLOCK_LOADING) {
                              return Shimmer.fromColors(
                                  baseColor: AppColors.grey,
                                  highlightColor: AppColors.white,
                                  child: Row(children: const <Widget>[
                                    AppFrameUIForLoading(),
                                  ]));
                            } else {
                              final Product product = productProvider
                                  .topSellingProductList.data[index];
                              return ProductHorizontalListItem(
                                coreTagKey:
                                    productProvider.hashCode.toString() +
                                        product.id,
                                product: productProvider
                                    .topSellingProductList.data[index],
                                onTap: () async {
                                  // print(productProvider
                                  //     .productList.data[index].image.url);
                                  final ProductDetailIntentHolder holder =
                                      ProductDetailIntentHolder(
                                    product: productProvider
                                        .topSellingProductList.data[index],
                                    heroTagImage:
                                        productProvider.hashCode.toString() +
                                            product.id +
                                            AppConst.HERO_TAG__IMAGE,
                                    heroTagTitle:
                                        productProvider.hashCode.toString() +
                                            product.id +
                                            AppConst.HERO_TAG__TITLE,
                                    heroTagOriginalPrice:
                                        productProvider.hashCode.toString() +
                                            product.id +
                                            AppConst.HERO_TAG__ORIGINAL_PRICE,
                                    heroTagUnitPrice:
                                        productProvider.hashCode.toString() +
                                            product.id +
                                            AppConst.HERO_TAG__UNIT_PRICE,
                                  );
                                  final dynamic result =
                                      await Navigator.pushNamed(
                                          context, RoutePaths.productDetail,
                                          arguments: holder);
                                  if (result == null) {
                                    setState(() {
                                      productProvider
                                          .resetTopRatedProductList();
                                    });
                                  }
                                },
                              );
                            }
                          })),
                  // const PsAdMobBannerWidget(
                  //   admobSize: NativeAdmobType.full,
                  //   // admobBannerSize: AdmobBannerSize.MEDIUM_RECTANGLE,
                  // ),
                  // Visibility(
                  //   visible: AppConfig.showAdMob &&
                  //       isSuccessfullyLoaded &&
                  //       isConnectedToInternet,
                  //   child: AdmobBanner(
                  //     adUnitId: Utils.getBannerAdUnitId(),
                  //     adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
                  //     listener: (AdmobAdEvent event,
                  //         Map<String, dynamic> map) {
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
                ])
              : Container(),
          builder: (BuildContext context, Widget child) {
            return FadeTransition(
                opacity: widget.animation,
                child: Transform(
                    transform: Matrix4.translationValues(
                        0.0, 100 * (1.0 - widget.animation.value), 0.0),
                    child: child));
          });
    }));
  }
}

class _DiscountProductHorizontalListWidget extends StatefulWidget {
  const _DiscountProductHorizontalListWidget({
    Key key,
    @required this.animationController,
    @required this.animation,
  }) : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;

  @override
  __DiscountProductHorizontalListWidgetState createState() =>
      __DiscountProductHorizontalListWidgetState();
}

class __DiscountProductHorizontalListWidgetState
    extends State<_DiscountProductHorizontalListWidget> {
  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;

  // void checkConnection() {
  //   Utils.checkInternetConnectivity().then((bool onValue) {
  //     isConnectedToInternet = onValue;
  //     if (isConnectedToInternet && AppConfig.showAdMob) {
  //       setState(() {});
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // if (!isConnectedToInternet && AppConfig.showAdMob) {
    //   print('loading ads....');
    //   checkConnection();
    // }
    return SliverToBoxAdapter(child: Consumer<DiscountProductProvider>(builder:
        (BuildContext context, DiscountProductProvider productProvider,
            Widget child) {
      return AnimatedBuilder(
          animation: widget.animationController,
          child: (productProvider.productList.data != null &&
                  productProvider.productList.data.isNotEmpty)
              ? Column(children: <Widget>[
                  _MyHeaderWidget(
                    headerName: Utils.getString('dashboard__discount_product'),
                    viewAllClicked: () {
                      Navigator.pushNamed(context, RoutePaths.filterProductList,
                          arguments: ProductListIntentHolder(
                              appBarTitle: Utils.getString(
                                  'dashboard__discount_product'),
                              productParameterHolder: ProductParameterHolder()
                                  .getDiscountParameterHolder()));
                    },
                  ),
                  Container(
                      height: AppDimens.space320,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding:
                              const EdgeInsets.only(left: AppDimens.space16),
                          itemCount:
                              productProvider.productList.data.length ?? 0,
                          itemBuilder: (BuildContext context, int index) {
                            if (productProvider.productList.status ==
                                AppStatus.BLOCK_LOADING) {
                              return Shimmer.fromColors(
                                  baseColor: AppColors.grey,
                                  highlightColor: AppColors.white,
                                  child: Row(children: const <Widget>[
                                    AppFrameUIForLoading(),
                                  ]));
                            } else {
                              final Product product =
                                  productProvider.productList.data[index];
                              return ProductHorizontalListItem(
                                coreTagKey:
                                    productProvider.hashCode.toString() +
                                        product.id,
                                product:
                                    productProvider.productList.data[index],
                                onTap: () async {
                                  // print(productProvider
                                  //     .productList.data[index].image.url);
                                  final ProductDetailIntentHolder holder =
                                      ProductDetailIntentHolder(
                                    product:
                                        productProvider.productList.data[index],
                                    heroTagImage:
                                        productProvider.hashCode.toString() +
                                            product.id +
                                            AppConst.HERO_TAG__IMAGE,
                                    heroTagTitle:
                                        productProvider.hashCode.toString() +
                                            product.id +
                                            AppConst.HERO_TAG__TITLE,
                                    heroTagOriginalPrice:
                                        productProvider.hashCode.toString() +
                                            product.id +
                                            AppConst.HERO_TAG__ORIGINAL_PRICE,
                                    heroTagUnitPrice:
                                        productProvider.hashCode.toString() +
                                            product.id +
                                            AppConst.HERO_TAG__UNIT_PRICE,
                                  );
                                  final dynamic result =
                                      await Navigator.pushNamed(
                                          context, RoutePaths.productDetail,
                                          arguments: holder);
                                  if (result == null) {
                                    setState(() {
                                      productProvider.resetProductList();
                                    });
                                  }
                                },
                              );
                            }
                          })),
                  // const PsAdMobBannerWidget(
                  //   admobSize: NativeAdmobType.full,
                  //   // admobBannerSize: AdmobBannerSize.MEDIUM_RECTANGLE,
                  // ),
                  // Visibility(
                  //   visible: AppConfig.showAdMob &&
                  //       isSuccessfullyLoaded &&
                  //       isConnectedToInternet,
                  //   child: AdmobBanner(
                  //     adUnitId: Utils.getBannerAdUnitId(),
                  //     adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
                  //     listener: (AdmobAdEvent event,
                  //         Map<String, dynamic> map) {
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
                ])
              : Container(),
          builder: (BuildContext context, Widget child) {
            return FadeTransition(
                opacity: widget.animation,
                child: Transform(
                    transform: Matrix4.translationValues(
                        0.0, 100 * (1.0 - widget.animation.value), 0.0),
                    child: child));
          });
    }));
  }
}

class _HomeLatestProductHorizontalListWidget extends StatefulWidget {
  const _HomeLatestProductHorizontalListWidget({
    Key key,
    @required this.animationController,
    @required this.animation,
  }) : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;

  @override
  __HomeLatestProductHorizontalListWidgetState createState() =>
      __HomeLatestProductHorizontalListWidgetState();
}

class __HomeLatestProductHorizontalListWidgetState
    extends State<_HomeLatestProductHorizontalListWidget> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Consumer<SearchProductProvider>(
        builder: (BuildContext context, SearchProductProvider productProvider,
            Widget child) {
          return AnimatedBuilder(
              animation: widget.animationController,
              child: (productProvider.productList.data != null &&
                      productProvider.productList.data.isNotEmpty)
                  ? Column(children: <Widget>[
                      _MyHeaderWidget(
                        headerName:
                            Utils.getString('dashboard__latest_product'),
                        viewAllClicked: () {
                          Navigator.pushNamed(
                              context, RoutePaths.filterProductList,
                              arguments: ProductListIntentHolder(
                                appBarTitle: Utils.getString(
                                    'dashboard__latest_product'),
                                productParameterHolder: ProductParameterHolder()
                                    .getLatestParameterHolder(),
                              ));
                        },
                      ),
                      Container(
                          height: AppDimens.space320,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.only(
                                  left: AppDimens.space16),
                              itemCount:
                                  productProvider.productList.data.length ?? 0,
                              itemBuilder: (BuildContext context, int index) {
                                if (productProvider.productList.status ==
                                    AppStatus.BLOCK_LOADING) {
                                  return Shimmer.fromColors(
                                      baseColor: AppColors.grey,
                                      highlightColor: AppColors.white,
                                      child: Row(children: const <Widget>[
                                        AppFrameUIForLoading(),
                                      ]));
                                } else {
                                  final Product product =
                                      productProvider.productList.data[index];
                                  return ProductHorizontalListItem(
                                    coreTagKey:
                                        productProvider.hashCode.toString() +
                                            product.id, //'latest',
                                    product: product,
                                    onTap: () async {
                                      // print(product.Image.imgPath);

                                      final ProductDetailIntentHolder holder =
                                          ProductDetailIntentHolder(
                                        product: product,
                                        heroTagImage: productProvider.hashCode
                                                .toString() +
                                            product.id +
                                            AppConst.HERO_TAG__IMAGE,
                                        heroTagTitle: productProvider.hashCode
                                                .toString() +
                                            product.id +
                                            AppConst.HERO_TAG__TITLE,
                                        heroTagOriginalPrice: productProvider
                                                .hashCode
                                                .toString() +
                                            product.id +
                                            AppConst.HERO_TAG__ORIGINAL_PRICE,
                                        heroTagUnitPrice: productProvider
                                                .hashCode
                                                .toString() +
                                            product.id +
                                            AppConst.HERO_TAG__UNIT_PRICE,
                                      );

                                      final dynamic result =
                                          await Navigator.pushNamed(
                                              context, RoutePaths.productDetail,
                                              arguments: holder);
                                      if (result == null) {
                                        setState(() {
                                          productProvider.resetLatestProductList(
                                              ProductParameterHolder()
                                                  .getLatestParameterHolder());
                                        });
                                      }
                                    },
                                  );
                                }
                              }))
                    ])
                  : Container(),
              builder: (BuildContext context, Widget child) {
                return FadeTransition(
                  opacity: widget.animation,
                  child: Transform(
                      transform: Matrix4.translationValues(
                          0.0, 100 * (1.0 - widget.animation.value), 0.0),
                      child: child),
                );
              });
        },
      ),
    );
  }
}

class _MyHeaderWidget extends StatefulWidget {
  const _MyHeaderWidget({
    Key key,
    @required this.headerName,
    @required this.viewAllClicked,
  }) : super(key: key);

  final String headerName;
  final Function viewAllClicked;

  @override
  __MyHeaderWidgetState createState() => __MyHeaderWidgetState();
}

class __MyHeaderWidgetState extends State<_MyHeaderWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.headerName == Utils.getString('home__menu_drawer_blog')) {
      return InkWell(
        onTap: widget.viewAllClicked,
        child: Padding(
          padding: const EdgeInsets.only(
              top: AppDimens.space20,
              left: AppDimens.space16,
              right: AppDimens.space16,
              bottom: AppDimens.space10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: Text(widget.headerName,
                    style: Theme.of(context).textTheme.headline6.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimaryDarkColor)),
              ),
            ],
          ),
        ),
      );
    } else {
      return InkWell(
        onTap: widget.viewAllClicked,
        child: Padding(
          padding: const EdgeInsets.only(
              top: AppDimens.space20,
              left: AppDimens.space16,
              right: AppDimens.space16,
              bottom: AppDimens.space10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: Text(widget.headerName,
                    style: Theme.of(context).textTheme.headline6.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimaryDarkColor)),
              ),
              Text(
                Utils.getString('dashboard__view_all'),
                textAlign: TextAlign.start,
                style: Theme.of(context)
                    .textTheme
                    .caption
                    .copyWith(color: AppColors.mainColor),
              ),
            ],
          ),
        ),
      );
    }
  }
}

class _HomeBlogProductSliderListWidget extends StatelessWidget {
  const _HomeBlogProductSliderListWidget({
    Key key,
    @required this.animationController,
    @required this.animation,
  }) : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    const int count = 6;
    final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
            parent: animationController,
            curve: const Interval((1 / count) * 1, 1.0,
                curve: Curves.fastOutSlowIn)));

    return SliverToBoxAdapter(
      child: Consumer<BlogProvider>(builder:
          (BuildContext context, BlogProvider blogProvider, Widget child) {
        return AnimatedBuilder(
            animation: animationController,
            child: (blogProvider.blogList != null &&
                    blogProvider.blogList.data.isNotEmpty)
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      _MyHeaderWidget(
                        headerName: Utils.getString('home__menu_drawer_blog'),
                        viewAllClicked: () {
                          Navigator.pushNamed(
                            context,
                            RoutePaths.blogList,
                          );
                        },
                      ),
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: AppColors.mainLightShadowColor,
                                offset: const Offset(1.1, 1.1),
                                blurRadius: 20.0),
                          ],
                        ),
                        margin: const EdgeInsets.only(
                            top: AppDimens.space8, bottom: AppDimens.space20),
                        width: double.infinity,
                        child: BlogSliderView(
                          blogList: blogProvider.blogList.data,
                          onTap: (Product product) async {
                            // Navigator.pushNamed(context, RoutePaths.blogDetail,
                            //     arguments: blog);
                            // final ProductDetailIntentHolder holder =
                            //     ProductDetailIntentHolder(
                            //   product: product,
                            //   heroTagImage: blogProvider.hashCode.toString() +
                            //       product.id +
                            //       AppConst.HERO_TAG__IMAGE,
                            //   heroTagTitle: blogProvider.hashCode.toString() +
                            //       product.id +
                            //       AppConst.HERO_TAG__TITLE,
                            //   heroTagOriginalPrice:
                            //       blogProvider.hashCode.toString() +
                            //           product.id +
                            //           AppConst.HERO_TAG__ORIGINAL_PRICE,
                            //   heroTagUnitPrice:
                            //       blogProvider.hashCode.toString() +
                            //           product.id +
                            //           AppConst.HERO_TAG__UNIT_PRICE,
                            // );

                            // await Navigator.pushNamed(
                            //     context, RoutePaths.productDetail,
                            //     arguments: holder);
                          },
                        ),
                      )
                    ],
                  )
                : Container(),
            builder: (BuildContext context, Widget child) {
              return FadeTransition(
                  opacity: animation,
                  child: Transform(
                      transform: Matrix4.translationValues(
                          0.0, 100 * (1.0 - animation.value), 0.0),
                      child: child));
            });
      }),
    );
  }
}

class _HomeCategoryHorizontalListWidget extends StatefulWidget {
  const _HomeCategoryHorizontalListWidget(
      {Key key,
      @required this.animationController,
      @required this.animation,
      @required this.appValueHolder})
      : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;
  final AppValueHolder appValueHolder;

  @override
  __HomeCategoryHorizontalListWidgetState createState() =>
      __HomeCategoryHorizontalListWidgetState();
}

class __HomeCategoryHorizontalListWidgetState
    extends State<_HomeCategoryHorizontalListWidget> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(child: Consumer<CategoryProvider>(
      builder: (BuildContext context, CategoryProvider categoryProvider,
          Widget child) {
        return AnimatedBuilder(
            animation: widget.animationController,
            child: (categoryProvider.categoryList.data != null &&
                    categoryProvider.categoryList.data.isNotEmpty)
                ? Column(children: <Widget>[
                    _MyHeaderWidget(
                      headerName: Utils.getString('dashboard__categories'),
                      viewAllClicked: () {
                        Navigator.pushNamed(context, RoutePaths.categoryList,
                            arguments:
                                Utils.getString('dashboard__categories'));
                      },
                    ),
                    Container(
                      height: AppDimens.space72,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                          shrinkWrap: true,
                          padding:
                              const EdgeInsets.only(left: AppDimens.space16),
                          scrollDirection: Axis.horizontal,
                          itemCount:
                              categoryProvider.categoryList.data.length ?? 0,
                          itemBuilder: (BuildContext context, int index) {
                            if (categoryProvider.categoryList.status ==
                                AppStatus.BLOCK_LOADING) {
                              return Shimmer.fromColors(
                                  baseColor: AppColors.grey,
                                  highlightColor: AppColors.white,
                                  child: Row(children: const <Widget>[
                                    AppFrameUIForLoading(),
                                  ]));
                            } else {
                              return CategoryHorizontalListItem(
                                category:
                                    categoryProvider.categoryList.data[index],
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, RoutePaths.subCategoryGrid,
                                      arguments: categoryProvider
                                          .categoryList.data[index]);
                                  // final ProductParameterHolder
                                  //     productParameterHolder =
                                  //     ProductParameterHolder()
                                  //         .getLatestParameterHolder();
                                  // productParameterHolder.searchTerm = '0';
                                  // productParameterHolder.catId =
                                  //     categoryProvider
                                  //         .categoryList.data[index].id;
                                  // Navigator.pushNamed(
                                  //     context, RoutePaths.filterProductList,
                                  //     arguments: ProductListIntentHolder(
                                  //       appBarTitle: categoryProvider
                                  //           .categoryList.data[index].name,
                                  //       productParameterHolder:
                                  //           productParameterHolder,
                                  //     ));
                                },
                              );
                            }
                          }),
                    )
                  ])
                : Container(),
            builder: (BuildContext context, Widget child) {
              return FadeTransition(
                  opacity: widget.animation,
                  child: Transform(
                      transform: Matrix4.translationValues(
                          0.0, 30 * (1.0 - widget.animation.value), 0.0),
                      child: child));
            });
      },
    ));
  }
}
