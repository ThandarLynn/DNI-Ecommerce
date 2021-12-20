import 'package:dni_ecommerce/api/common/app_status.dart';
import 'package:dni_ecommerce/config/app_config.dart';
import 'package:dni_ecommerce/config/app_colors.dart';
import 'package:dni_ecommerce/constant/app_constant.dart';
import 'package:dni_ecommerce/constant/app_dimens.dart';
import 'package:dni_ecommerce/constant/route_paths.dart';
import 'package:dni_ecommerce/provider/product/search_product_provider.dart';
import 'package:dni_ecommerce/repository/product_repository.dart';
import 'package:dni_ecommerce/ui/common/app_ui_widget.dart';
import 'package:dni_ecommerce/ui/product/product_vertical_list_item.dart';
import 'package:dni_ecommerce/utils/utils.dart';
import 'package:dni_ecommerce/viewobject/common/app_value_holder.dart';
import 'package:dni_ecommerce/viewobject/holder/intent/product_detail_intent_holder.dart';
import 'package:dni_ecommerce/viewobject/holder/product_parameter_holder.dart';
import 'package:dni_ecommerce/viewobject/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

class ProductListWithFilterView extends StatefulWidget {
  const ProductListWithFilterView(
      {Key key,
      @required this.productParameterHolder,
      @required this.animationController})
      : super(key: key);

  final ProductParameterHolder productParameterHolder;
  final AnimationController animationController;

  @override
  _ProductListWithFilterViewState createState() =>
      _ProductListWithFilterViewState();
}

class _ProductListWithFilterViewState extends State<ProductListWithFilterView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  SearchProductProvider _searchProductProvider;
  bool isVisible = true;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _offset = 0;
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _searchProductProvider.nextProductListByKey(
            _searchProductProvider.productParameterHolder);
      }
      // setState(() {
      final double offset = _scrollController.offset;
      _delta += offset - _oldOffset;
      if (_delta > _containerMaxHeight)
        _delta = _containerMaxHeight;
      else if (_delta < 0) {
        _delta = 0;
      }
      _oldOffset = offset;
      _offset = -_delta;
      // });

      print(' Offset $_offset');
    });
  }

  final double _containerMaxHeight = 60;
  double _offset, _delta = 0, _oldOffset = 0;
  ProductRepository repo1;
  dynamic data;
  AppValueHolder valueHolder;
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
    valueHolder = Provider.of<AppValueHolder>(context);

    if (!isConnectedToInternet && AppConfig.showAdMob) {
      print('loading ads....');
      checkConnection();
    }
    print(
        '............................Build UI Again < Filter View > ............................');
    return ChangeNotifierProvider<SearchProductProvider>(
        lazy: false,
        create: (BuildContext context) {
          final SearchProductProvider provider =
              SearchProductProvider(repo: repo1);
          provider.loadProductListByKey(widget.productParameterHolder);
          _searchProductProvider = provider;
          _searchProductProvider.productParameterHolder =
              widget.productParameterHolder;
          return _searchProductProvider;
        },
        child: Consumer<SearchProductProvider>(builder: (BuildContext context,
            SearchProductProvider provider, Widget child) {
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
                child: Container(
                  color: AppColors.coreBackgroundColor,
                  child: Stack(children: <Widget>[
                    if (provider.productList.data.isNotEmpty &&
                        provider.productList.data != null)
                      Container(
                          color: AppColors.coreBackgroundColor,
                          margin: const EdgeInsets.only(
                              left: AppDimens.space8,
                              right: AppDimens.space8,
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
                                        if (provider.productList.data != null ||
                                            provider
                                                .productList.data.isNotEmpty) {
                                          final int count =
                                              provider.productList.data.length;
                                          return ProductVeticalListItem(
                                            coreTagKey:
                                                provider.hashCode.toString() +
                                                    provider.productList
                                                        .data[index].id,
                                            animationController:
                                                widget.animationController,
                                            animation: Tween<double>(
                                                    begin: 0.0, end: 1.0)
                                                .animate(
                                              CurvedAnimation(
                                                parent:
                                                    widget.animationController,
                                                curve: Interval(
                                                    (1 / count) * index, 1.0,
                                                    curve:
                                                        Curves.fastOutSlowIn),
                                              ),
                                            ),
                                            product: provider
                                                .productList.data[index],
                                            onTap: () async {
                                              final Product product = provider
                                                  .productList.data[index];
                                              final ProductDetailIntentHolder
                                                  holder =
                                                  ProductDetailIntentHolder(
                                                product: product,
                                                heroTagImage: provider.hashCode
                                                        .toString() +
                                                    product.id +
                                                    AppConst.HERO_TAG__IMAGE,
                                                heroTagTitle: provider.hashCode
                                                        .toString() +
                                                    product.id +
                                                    AppConst.HERO_TAG__TITLE,
                                                heroTagOriginalPrice: provider
                                                        .hashCode
                                                        .toString() +
                                                    product.id +
                                                    AppConst
                                                        .HERO_TAG__ORIGINAL_PRICE,
                                                heroTagUnitPrice: provider
                                                        .hashCode
                                                        .toString() +
                                                    product.id +
                                                    AppConst
                                                        .HERO_TAG__UNIT_PRICE,
                                              );

                                              final dynamic result =
                                                  await Navigator.pushNamed(
                                                      context,
                                                      RoutePaths.productDetail,
                                                      arguments: holder);

                                              if (result == null) {
                                                // provider.loadProductListByKey(
                                                //     widget
                                                //         .productParameterHolder);
                                              }
                                            },
                                          );
                                        } else {
                                          return null;
                                        }
                                      },
                                      childCount:
                                          provider.productList.data.length,
                                    ),
                                  ),
                                ]),
                            onRefresh: () {
                              return provider.resetLatestProductList(
                                  _searchProductProvider
                                      .productParameterHolder);
                            },
                          ))
                    else if (provider.productList.status !=
                            AppStatus.PROGRESS_LOADING &&
                        provider.productList.status !=
                            AppStatus.BLOCK_LOADING &&
                        provider.productList.status != AppStatus.NOACTION)
                      Align(
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Image.asset(
                                'assets/images/baseline_empty_item_grey_24.png',
                                height: 100,
                                width: 150,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(
                                height: AppDimens.space32,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: AppDimens.space20,
                                    right: AppDimens.space20),
                                child: Text(
                                  Utils.getString(
                                      'procuct_list__no_result_data'),
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .copyWith(),
                                ),
                              ),
                              const SizedBox(
                                height: AppDimens.space20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    Positioned(
                      bottom: _offset,
                      width: MediaQuery.of(context).size.width,
                      child: Container(
                        margin: const EdgeInsets.only(
                            left: AppDimens.space12,
                            top: AppDimens.space8,
                            right: AppDimens.space12,
                            bottom: AppDimens.space16),
                        child: Container(
                            width: double.infinity,
                            height: _containerMaxHeight,
                            child: BottomNavigationImageAndText(
                                searchProductProvider: _searchProductProvider)),
                      ),
                    ),
                    AppProgressIndicator(provider.productList.status),
                  ]),
                ),
              )
            ],
          );
        }));
  }
}

class BottomNavigationImageAndText extends StatefulWidget {
  const BottomNavigationImageAndText({this.searchProductProvider});
  final SearchProductProvider searchProductProvider;

  @override
  _BottomNavigationImageAndTextState createState() =>
      _BottomNavigationImageAndTextState();
}

class _BottomNavigationImageAndTextState
    extends State<BottomNavigationImageAndText> {
  bool isClickBaseLineList = false;
  bool isClickBaseLineTune = false;

  @override
  Widget build(BuildContext context) {
    if (widget.searchProductProvider.productParameterHolder.isFiltered()) {
      isClickBaseLineTune = true;
    }

    if (widget.searchProductProvider.productParameterHolder
        .isCatAndSubCatFiltered()) {
      isClickBaseLineList = true;
    }

    return GestureDetector(
        onTap: () async {
          final Map<String, String> dataHolder = <String, String>{};
          dataHolder[AppConst.CATEGORY_ID] =
              widget.searchProductProvider.productParameterHolder.catId;
          dataHolder[AppConst.SUB_CATEGORY_ID] =
              widget.searchProductProvider.productParameterHolder.subCatId;
          final dynamic result = await Navigator.pushNamed(
              context, RoutePaths.filterExpantion,
              arguments: dataHolder);

          if (result != null) {
            widget.searchProductProvider.productParameterHolder.catId =
                result[AppConst.CATEGORY_ID];
            widget.searchProductProvider.productParameterHolder.subCatId =
                result[AppConst.SUB_CATEGORY_ID];
            widget.searchProductProvider.resetLatestProductList(
                widget.searchProductProvider.productParameterHolder);

            if (result[AppConst.CATEGORY_ID] == '' &&
                result[AppConst.SUB_CATEGORY_ID] == '') {
              isClickBaseLineList = false;
            } else {
              isClickBaseLineList = true;
            }
          }
        },
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: AppColors.mainLightShadowColor),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: AppColors.mainShadowColor,
                    offset: const Offset(1.1, 1.1),
                    blurRadius: 10.0),
              ],
              color: AppColors.backgroundColor,
              borderRadius:
                  const BorderRadius.all(Radius.circular(AppDimens.space8))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GestureDetector(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    AppIconWithCheck(
                      icon: MaterialCommunityIcons.format_list_bulleted_type,
                      color: isClickBaseLineList
                          ? AppColors.mainColor
                          : AppColors.iconColor,
                    ),
                    Text(Utils.getString('search__category'),
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: isClickBaseLineList
                                ? AppColors.mainColor
                                : AppColors.textPrimaryColor)),
                  ],
                ),
                // onTap: () async {
                //   final Map<String, String> dataHolder = <String, String>{};
                //   dataHolder[AppConst.CATEGORY_ID] =
                //       widget.searchProductProvider.productParameterHolder.catId;
                //   dataHolder[AppConst.SUB_CATEGORY_ID] =
                //       widget.searchProductProvider.productParameterHolder.subCatId;
                //   final dynamic result = await Navigator.pushNamed(
                //       context, RoutePaths.filterExpantion,
                //       arguments: dataHolder);

                //   if (result != null) {
                //     widget.searchProductProvider.productParameterHolder.catId =
                //         result[AppConst.CATEGORY_ID];
                //     widget.searchProductProvider.productParameterHolder.subCatId =
                //         result[AppConst.SUB_CATEGORY_ID];
                //     widget.searchProductProvider.resetLatestProductList(
                //         widget.searchProductProvider.productParameterHolder);

                //     if (result[AppConst.CATEGORY_ID] == '' &&
                //         result[AppConst.SUB_CATEGORY_ID] == '') {
                //       isClickBaseLineList = false;
                //     } else {
                //       isClickBaseLineList = true;
                //     }
                //   }
                // },
              ),
              // GestureDetector(
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: <Widget>[
              //       AppIconWithCheck(
              //         icon: Icons.filter_list,
              //         color: isClickBaseLineTune
              //             ? AppColors.mainColor
              //             : AppColors.iconColor,
              //       ),
              //       Text(Utils.getString('search__filter'),
              //           style: Theme.of(context).textTheme.bodyText1.copyWith(
              //               color: isClickBaseLineTune
              //                   ? AppColors.mainColor
              //                   : AppColors.textPrimaryColor))
              //     ],
              //   ),
              //   onTap: () async {
              // final dynamic result = await Navigator.pushNamed(
              //     context, RoutePaths.itemSearch,
              //     arguments:
              //         widget.searchProductProvider.productParameterHolder);
              // if (result != null) {
              //   widget.searchProductProvider.productParameterHolder = result;
              //   widget.searchProductProvider.resetLatestProductList(
              //       widget.searchProductProvider.productParameterHolder);

              //   if (widget.searchProductProvider.productParameterHolder
              //       .isFiltered()) {
              //     isClickBaseLineTune = true;
              //   } else {
              //     isClickBaseLineTune = false;
              //   }
              // }
              //   },
              // ),
              // GestureDetector(
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: <Widget>[
              //       AppIconWithCheck(
              //         icon: Icons.sort,
              //         color: AppColors.mainColor,
              //       ),
              //       Text(Utils.getString('search__sort'),
              //           style: Theme.of(context).textTheme.bodyText1.copyWith(
              //               color: isClickBaseLineTune
              //                   ? AppColors.mainColor
              //                   : AppColors.textPrimaryColor))
              //     ],
              //   ),
              //   onTap: () async {
              //     // final dynamic result = await Navigator.pushNamed(
              //     //     context, RoutePaths.itemSort,
              //     //     arguments:
              //     //         widget.searchProductProvider.productParameterHolder);
              //     // if (result != null) {
              //     //   widget.searchProductProvider.productParameterHolder = result;
              //     //   widget.searchProductProvider.resetLatestProductList(
              //     //       widget.searchProductProvider.productParameterHolder);
              //     // }
              //   },
              // ),
            ],
          ),
        ));
  }
}

class AppIconWithCheck extends StatelessWidget {
  const AppIconWithCheck({Key key, this.icon, this.color}) : super(key: key);
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Icon(icon, color: color ?? AppColors.grey);
  }
}
