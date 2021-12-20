import 'package:dni_ecommerce/ui/subcategory/sub_category_grid_item.dart';
import 'package:dni_ecommerce/viewobject/holder/intent/product_list_intent_holder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dni_ecommerce/api/common/app_status.dart';
import 'package:dni_ecommerce/config/app_colors.dart';
import 'package:dni_ecommerce/config/app_config.dart';
import 'package:dni_ecommerce/constant/app_dimens.dart';
import 'package:dni_ecommerce/constant/route_paths.dart';
import 'package:dni_ecommerce/provider/subcategory/sub_category_provider.dart';
import 'package:dni_ecommerce/repository/sub_category_repository.dart';
import 'package:dni_ecommerce/ui/common/app_ui_widget.dart';
import 'package:dni_ecommerce/utils/utils.dart';
import 'package:dni_ecommerce/viewobject/category.dart';
import 'package:dni_ecommerce/viewobject/common/app_value_holder.dart';
import 'package:provider/provider.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:shimmer/shimmer.dart';

class SubCategoryGridView extends StatefulWidget {
  const SubCategoryGridView({this.category});
  final Category category;
  @override
  _ModelGridViewState createState() {
    return _ModelGridViewState();
  }
}

class _ModelGridViewState extends State<SubCategoryGridView>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  SubCategoryProvider _subCategoryProvider;

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
        _subCategoryProvider.nextSubCategoryList(widget.category.id);
      }
    });
    animationController = AnimationController(
        duration: AppConfig.animation_duration, vsync: this);
    super.initState();
  }

  SubCategoryRepository repo1;
  AppValueHolder valueHolder;
  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;

  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
      if (isConnectedToInternet && AppConfig.showAdMob) {
        if (mounted) {
          setState(() {});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isConnectedToInternet && AppConfig.showAdMob) {
      print('loading ads....');
      checkConnection();
    }
    timeDilation = 1.0;
    repo1 = Provider.of<SubCategoryRepository>(context);
    valueHolder = Provider.of<AppValueHolder>(context);
    return Scaffold(
        appBar: AppBar(
          // backgroundColor: AppColors.mainColor,
          brightness: Utils.getBrightnessForAppBar(context),
          title: Text(
            widget.category.name,
            style: TextStyle(color: AppColors.mainColor),
          ),
          iconTheme: IconThemeData(
            color: AppColors.mainColor,
          ),
        ),
        body: ChangeNotifierProvider<SubCategoryProvider>(
            lazy: false,
            create: (BuildContext context) {
              _subCategoryProvider =
                  SubCategoryProvider(repo: repo1, psValueHolder: valueHolder);
              _subCategoryProvider.loadAllSubCategoryList(
                widget.category.id,
              );
              return _subCategoryProvider;
            },
            child: Consumer<SubCategoryProvider>(builder: (BuildContext context,
                SubCategoryProvider provider, Widget child) {
              return Column(
                children: <Widget>[
                  Expanded(
                    child: Stack(children: <Widget>[
                      Container(
                          child: RefreshIndicator(
                        onRefresh: () {
                          return _subCategoryProvider
                              .resetSubCategoryList(widget.category.id);
                        },
                        child: CustomScrollView(
                            controller: _scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            slivers: <Widget>[
                              SliverGrid(
                                gridDelegate:
                                    const SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent: 240.0,
                                        childAspectRatio: 1.4),
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                    if (provider.subCategoryList.status ==
                                        AppStatus.BLOCK_LOADING) {
                                      return Shimmer.fromColors(
                                          baseColor: AppColors.grey,
                                          highlightColor: AppColors.white,
                                          child:
                                              Column(children: const <Widget>[
                                            FrameUIForLoading(),
                                            FrameUIForLoading(),
                                            FrameUIForLoading(),
                                            FrameUIForLoading(),
                                            FrameUIForLoading(),
                                            FrameUIForLoading(),
                                          ]));
                                    } else {
                                      final int count =
                                          provider.subCategoryList.data.length;
                                      return SubCategoryGridItem(
                                        subCategory: provider
                                            .subCategoryList.data[index],
                                        onTap: () {
                                          provider.subCategoryByCatIdParamenterHolder
                                                  .catId =
                                              provider.subCategoryList
                                                  .data[index].catId;
                                          provider.subCategoryByCatIdParamenterHolder
                                                  .subCatId =
                                              provider.subCategoryList
                                                  .data[index].id;
                                          Navigator.pushNamed(context,
                                              RoutePaths.filterProductList,
                                              arguments: ProductListIntentHolder(
                                                  appBarTitle: provider
                                                      .subCategoryList
                                                      .data[index]
                                                      .name,
                                                  productParameterHolder: provider
                                                      .subCategoryByCatIdParamenterHolder));
                                        },
                                        animationController:
                                            animationController,
                                        animation:
                                            Tween<double>(begin: 0.0, end: 1.0)
                                                .animate(CurvedAnimation(
                                          parent: animationController,
                                          curve: Interval(
                                              (1 / count) * index, 1.0,
                                              curve: Curves.fastOutSlowIn),
                                        )),
                                      );
                                    }
                                  },
                                  childCount:
                                      provider.subCategoryList.data.length,
                                ),
                              ),
                            ]),
                      )),
                      AppProgressIndicator(
                        provider.subCategoryList.status,
                        message: provider.subCategoryList.message,
                      )
                    ]),
                  )
                ],
              );
            }))
        // )
        );
  }
}

class FrameUIForLoading extends StatelessWidget {
  const FrameUIForLoading({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
            height: 70,
            width: 70,
            margin: const EdgeInsets.all(AppDimens.space16),
            decoration: BoxDecoration(color: AppColors.grey)),
        Expanded(
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Container(
              height: 15,
              margin: const EdgeInsets.all(AppDimens.space8),
              decoration: BoxDecoration(color: Colors.grey[300])),
          Container(
              height: 15,
              margin: const EdgeInsets.all(AppDimens.space8),
              decoration: const BoxDecoration(color: Colors.grey)),
        ]))
      ],
    );
  }
}
