import 'package:dni_ecommerce/config/app_colors.dart';
import 'package:dni_ecommerce/config/app_config.dart';
import 'package:dni_ecommerce/provider/category/category_provider.dart';
import 'package:dni_ecommerce/repository/category_repository.dart';
import 'package:dni_ecommerce/ui/common/app_widget_with_appbar.dart';
import 'package:dni_ecommerce/utils/utils.dart';
import 'package:dni_ecommerce/viewobject/common/app_value_holder.dart';
import 'package:dni_ecommerce/viewobject/holder/category_parameter_holder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:dni_ecommerce/constant/app_constant.dart';
import 'filter_expantion_tile_view.dart';

class FilterListView extends StatefulWidget {
  const FilterListView({this.selectedData});

  final dynamic selectedData;

  @override
  State<StatefulWidget> createState() => _FilterListViewState();
}

class _FilterListViewState extends State<FilterListView> {
  final ScrollController _scrollController = ScrollController();

  final CategoryParameterHolder categoryIconList = CategoryParameterHolder();
  CategoryRepository categoryRepository;
  AppValueHolder appValueHolder;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onSubCategoryClick(Map<String, String> subCategory) {
    Navigator.pop(context, subCategory);
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
    if (!isConnectedToInternet && AppConfig.showAdMob) {
      print('loading ads....');
      checkConnection();
    }
    categoryRepository = Provider.of<CategoryRepository>(context);
    appValueHolder = Provider.of<AppValueHolder>(context);
    return AppWidgetWithAppBar<CategoryProvider>(
        appBarTitle: Utils.getString('search__category') ?? '',
        initProvider: () {
          return CategoryProvider(
              repo: categoryRepository, appValueHolder: appValueHolder);
        },
        onProviderReady: (CategoryProvider provider) {
          provider.loadCategoryList(); //categoryIconList.toMap()
        },
        actions: <Widget>[
          IconButton(
            icon: Icon(MaterialCommunityIcons.filter_remove_outline,
                color: AppColors.mainColor),
            onPressed: () {
              final Map<String, String> dataHolder = <String, String>{};
              dataHolder[AppConst.CATEGORY_ID] = '';
              dataHolder[AppConst.SUB_CATEGORY_ID] = '';
              onSubCategoryClick(dataHolder);
            },
          )
        ],
        builder:
            (BuildContext context, CategoryProvider provider, Widget child) {
          return Container(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  // const PsAdMobBannerWidget(),
                  Container(
                    child: ListView.builder(
                        shrinkWrap: true,
                        controller: _scrollController,
                        itemCount: provider.categoryList.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (provider.categoryList.data != null ||
                              provider.categoryList.data.isEmpty) {
                            return FilterExpantionTileView(
                                selectedData: widget.selectedData,
                                category: provider.categoryList.data[index],
                                onSubCategoryClick: onSubCategoryClick);
                          } else {
                            return null;
                          }
                        }),
                  )
                ],
              ),
            ),
          );
        });
  }
}
