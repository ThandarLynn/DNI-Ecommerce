import 'package:dni_ecommerce/config/app_config.dart';
import 'package:dni_ecommerce/constant/app_dimens.dart';
import 'package:dni_ecommerce/constant/route_paths.dart';
import 'package:dni_ecommerce/provider/category/category_provider.dart';
import 'package:dni_ecommerce/repository/category_repository.dart';
import 'package:dni_ecommerce/ui/category/category_vertical_list_item.dart';
import 'package:dni_ecommerce/ui/common/app_ui_widget.dart';
import 'package:dni_ecommerce/utils/utils.dart';
import 'package:dni_ecommerce/viewobject/common/app_value_holder.dart';
import 'package:dni_ecommerce/viewobject/holder/category_parameter_holder.dart';
import 'package:dni_ecommerce/viewobject/holder/intent/product_list_intent_holder.dart';
import 'package:dni_ecommerce/viewobject/holder/product_parameter_holder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryListView extends StatefulWidget {
  @override
  _CategoryListViewState createState() {
    return _CategoryListViewState();
  }
}

class _CategoryListViewState extends State<CategoryListView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  CategoryProvider _categoryProvider;
  final CategoryParameterHolder categoryIconList = CategoryParameterHolder();

  AnimationController animationController;
  Animation<double> animation;

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
        _categoryProvider.nextCategoryList(categoryIconList.toMap());
      }
    });

    animationController = AnimationController(
        duration: AppConfig.animation_duration, vsync: this);

    super.initState();
  }

  CategoryRepository repo1;
  AppValueHolder psValueHolder;
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

    repo1 = Provider.of<CategoryRepository>(context);
    psValueHolder = Provider.of<AppValueHolder>(context);
    print(
        '............................Build UI Again ............................');
    return WillPopScope(
        onWillPop: _requestPop,
        child: ChangeNotifierProvider<CategoryProvider>(
            lazy: false,
            create: (BuildContext context) {
              final CategoryProvider provider =
                  CategoryProvider(repo: repo1, psValueHolder: psValueHolder);
              provider.loadCategoryList();
              _categoryProvider = provider;
              return _categoryProvider;
            },
            child: Consumer<CategoryProvider>(builder: (BuildContext context,
                CategoryProvider provider, Widget child) {
              return Stack(children: <Widget>[
                Column(children: <Widget>[
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
                        margin: const EdgeInsets.only(
                            left: AppDimens.space8,
                            right: AppDimens.space8,
                            top: AppDimens.space8,
                            bottom: AppDimens.space8),
                        child: RefreshIndicator(
                          child: CustomScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              controller: _scrollController,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              slivers: <Widget>[
                                SliverGrid(
                                  gridDelegate:
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 200.0,
                                          childAspectRatio: 0.8),
                                  delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, int index) {
                                      if (provider.categoryList.data != null ||
                                          provider
                                              .categoryList.data.isNotEmpty) {
                                        final int count =
                                            provider.categoryList.data.length;
                                        return CategoryVerticalListItem(
                                          animationController:
                                              animationController,
                                          animation: Tween<double>(
                                                  begin: 0.0, end: 1.0)
                                              .animate(
                                            CurvedAnimation(
                                              parent: animationController,
                                              curve: Interval(
                                                  (1 / count) * index, 1.0,
                                                  curve: Curves.fastOutSlowIn),
                                            ),
                                          ),
                                          category:
                                              provider.categoryList.data[index],
                                          onTap: () {
                                            // print(provider
                                            //     .categoryList
                                            //     .data[index]
                                            //     .Image
                                            //     .imgPath);
                                            // final ProductParameterHolder
                                            // if (AppConfig.isShowSubCategory) {
                                            //   Navigator.pushNamed(context,
                                            //       RoutePaths.subCategoryGrid,
                                            //       arguments: provider
                                            //           .categoryList
                                            //           .data[index]);
                                            // } else {
                                            // final String loginUserId =
                                            //     Utils.checkUserLoginId(
                                            //         psValueHolder);
                                            // final TouchCountParameterHolder
                                            //     touchCountParameterHolder =
                                            //     TouchCountParameterHolder(
                                            //         typeId: provider
                                            //             .categoryList
                                            //             .data[index]
                                            //             .id,
                                            //         typeName: AppConst
                                            //             .FILTERING_TYPE_NAME_CATEGORY,
                                            //         userId: loginUserId);

                                            // provider.postTouchCount(
                                            //     touchCountParameterHolder
                                            //         .toMap());
                                            final ProductParameterHolder
                                                productParameterHolder =
                                                ProductParameterHolder()
                                                    .getLatestParameterHolder();
                                            productParameterHolder.searchTerm =
                                                '0';
                                            productParameterHolder.catId =
                                                provider.categoryList
                                                    .data[index].id;
                                            Navigator.pushNamed(context,
                                                RoutePaths.filterProductList,
                                                arguments:
                                                    ProductListIntentHolder(
                                                  appBarTitle: provider
                                                      .categoryList
                                                      .data[index]
                                                      .name,
                                                  productParameterHolder:
                                                      productParameterHolder,
                                                ));
                                            // }
                                          },
                                        );
                                      } else {
                                        return null;
                                      }
                                    },
                                    childCount:
                                        provider.categoryList.data.length,
                                  ),
                                ),
                              ]),
                          onRefresh: () {
                            return provider
                                .resetCategoryList(categoryIconList.toMap());
                          },
                        )),
                  ),
                ]),
                AppProgressIndicator(provider.categoryList.status)
              ]);
            })));
  }
}
