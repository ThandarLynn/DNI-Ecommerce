import 'package:dni_ecommerce/config/app_config.dart';
import 'package:dni_ecommerce/config/app_colors.dart';
import 'package:dni_ecommerce/constant/app_constant.dart';
import 'package:dni_ecommerce/constant/app_dimens.dart';
import 'package:dni_ecommerce/constant/route_paths.dart';
import 'package:dni_ecommerce/provider/product/search_product_provider.dart';
import 'package:dni_ecommerce/repository/product_repository.dart';
import 'package:dni_ecommerce/ui/common/app_button_widget.dart';
import 'package:dni_ecommerce/ui/common/app_dropdown_base_widget.dart';
import 'package:dni_ecommerce/ui/common/app_special_check_text_widget.dart';
import 'package:dni_ecommerce/ui/common/app_textfield_widget.dart';
import 'package:dni_ecommerce/utils/utils.dart';
import 'package:dni_ecommerce/viewobject/category.dart';
import 'package:dni_ecommerce/viewobject/holder/intent/product_list_intent_holder.dart';
import 'package:dni_ecommerce/viewobject/holder/product_parameter_holder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

class HomeItemSearchView extends StatefulWidget {
  const HomeItemSearchView({
    @required this.productParameterHolder,
    @required this.animation,
    @required this.animationController,
  });

  final ProductParameterHolder productParameterHolder;
  final AnimationController animationController;
  final Animation<double> animation;

  @override
  _ItemSearchViewState createState() => _ItemSearchViewState();
}

class _ItemSearchViewState extends State<HomeItemSearchView> {
  ProductRepository repo1;
  SearchProductProvider _searchProductProvider;

  final TextEditingController userInputItemNameTextEditingController =
      TextEditingController();
  final TextEditingController userInputMaximunPriceEditingController =
      TextEditingController();
  final TextEditingController userInputMinimumPriceEditingController =
      TextEditingController();

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
    print(
        '............................Build UI Again ............................');

    final Widget _searchButtonWidget = AppButtonWidget(
        hasShadow: true,
        width: double.infinity,
        titleText: Utils.getString('home_search__search'),
        onPressed: () async {
          if (userInputItemNameTextEditingController.text != null &&
              userInputItemNameTextEditingController.text != '') {
            _searchProductProvider.productParameterHolder.searchTerm =
                userInputItemNameTextEditingController.text;
          } else {
            _searchProductProvider.productParameterHolder.searchTerm = '';
          }
          if (userInputMaximunPriceEditingController.text != null) {
            _searchProductProvider.productParameterHolder.maxPrice =
                userInputMaximunPriceEditingController.text;
          } else {
            _searchProductProvider.productParameterHolder.maxPrice = '';
          }
          if (userInputMinimumPriceEditingController.text != null) {
            _searchProductProvider.productParameterHolder.minPrice =
                userInputMinimumPriceEditingController.text;
          } else {
            _searchProductProvider.productParameterHolder.minPrice = '';
          }
          if (_searchProductProvider.isfirstRatingClicked) {
            _searchProductProvider.productParameterHolder.overallRating =
                AppConst.RATING_ONE;
          }

          if (_searchProductProvider.isSecondRatingClicked) {
            _searchProductProvider.productParameterHolder.overallRating =
                AppConst.RATING_TWO;
          }

          if (_searchProductProvider.isThirdRatingClicked) {
            _searchProductProvider.productParameterHolder.overallRating =
                AppConst.RATING_THREE;
          }

          if (_searchProductProvider.isfouthRatingClicked) {
            _searchProductProvider.productParameterHolder.overallRating =
                AppConst.RATING_FOUR;
          }

          if (_searchProductProvider.isFifthRatingClicked) {
            _searchProductProvider.productParameterHolder.overallRating =
                AppConst.RATING_FIVE;
          }

          if (_searchProductProvider.isSwitchedFeaturedProduct) {
            _searchProductProvider.productParameterHolder.isFeatured =
                AppConst.IS_FEATURED;
          } else {
            _searchProductProvider.productParameterHolder.isFeatured =
                AppConst.ZERO;
          }
          if (_searchProductProvider.isSwitchedDiscountPrice) {
            _searchProductProvider.productParameterHolder.isDiscount =
                AppConst.IS_DISCOUNT;
          } else {
            _searchProductProvider.productParameterHolder.isDiscount =
                AppConst.ZERO;
          }
          if (_searchProductProvider.categoryId != null) {
            _searchProductProvider.productParameterHolder.catId =
                _searchProductProvider.categoryId;
          }
          if (_searchProductProvider.subCategoryId != null) {
            _searchProductProvider.productParameterHolder.subCatId =
                _searchProductProvider.subCategoryId;
          }
          print('userInputText' + userInputItemNameTextEditingController.text);
          final dynamic result =
              await Navigator.pushNamed(context, RoutePaths.filterProductList,
                  arguments: ProductListIntentHolder(
                    appBarTitle: Utils.getString('home_search__app_bar_title'),
                    productParameterHolder:
                        _searchProductProvider.productParameterHolder,
                  ));
          if (result != null && result is ProductParameterHolder) {
            _searchProductProvider.productParameterHolder = result;
          }
        });

    repo1 = Provider.of<ProductRepository>(context);
    return SliverToBoxAdapter(
        child: ChangeNotifierProvider<SearchProductProvider>(
            lazy: false,
            create: (BuildContext content) {
              _searchProductProvider = SearchProductProvider(repo: repo1);
              _searchProductProvider.productParameterHolder =
                  widget.productParameterHolder;
              _searchProductProvider.loadProductListByKey(
                  _searchProductProvider.productParameterHolder);

              return _searchProductProvider;
            },
            child: Consumer<SearchProductProvider>(
              builder: (BuildContext context, SearchProductProvider provider,
                  Widget child) {
                if (_searchProductProvider.productList != null &&
                    _searchProductProvider.productList.data != null) {
                  widget.animationController.forward();
                  return SingleChildScrollView(
                    child: AnimatedBuilder(
                        animation: widget.animationController,
                        child: Container(
                          color: AppColors.baseColor,
                          child: Column(
                            children: <Widget>[
                              // const PsAdMobBannerWidget(),
                              // Visibility(
                              //   visible: AppConfig.showAdMob &&
                              //       isSuccessfullyLoaded &&
                              //       isConnectedToInternet,
                              //   child: AdmobBanner(
                              //     adUnitId: Utils.getBannerAdUnitId(),
                              //     adSize: AdmobBannerSize.FULL_BANNER,
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
                              _ProductNameWidget(
                                userInputItemNameTextEditingController:
                                    userInputItemNameTextEditingController,
                              ),
                              _PriceWidget(
                                userInputMinimumPriceEditingController:
                                    userInputMinimumPriceEditingController,
                                userInputMaximunPriceEditingController:
                                    userInputMaximunPriceEditingController,
                              ),
                              // _RatingRangeWidget(),
                              _SpecialCheckWidget(),
                              Container(
                                  margin: const EdgeInsets.only(
                                      left: AppDimens.space16,
                                      top: AppDimens.space16,
                                      right: AppDimens.space16,
                                      bottom: AppDimens.space40),
                                  child: _searchButtonWidget),
                            ],
                          ),
                        ),
                        builder: (BuildContext context, Widget child) {
                          return FadeTransition(
                              opacity: widget.animation,
                              child: Transform(
                                  transform: Matrix4.translationValues(
                                      0.0,
                                      100 * (1.0 - widget.animation.value),
                                      0.0),
                                  child: child));
                        }),
                  );
                } else {
                  return Container();
                }
              },
            )));
  }
}

class _ProductNameWidget extends StatefulWidget {
  const _ProductNameWidget({this.userInputItemNameTextEditingController});

  final TextEditingController userInputItemNameTextEditingController;

  @override
  __ProductNameWidgetState createState() => __ProductNameWidgetState();
}

class __ProductNameWidgetState extends State<_ProductNameWidget> {
  @override
  Widget build(BuildContext context) {
    print('*****' + widget.userInputItemNameTextEditingController.text);
    return Column(
      children: <Widget>[
        AppTextFieldWidget(
            titleText: Utils.getString('home_search__product_name'),
            textAboutMe: false,
            hintText: Utils.getString('home_search__product_name_hint'),
            textEditingController:
                widget.userInputItemNameTextEditingController),
        AppDropdownBaseWidget(
            title: Utils.getString('search__category'),
            selectedText:
                Provider.of<SearchProductProvider>(context, listen: false)
                    .selectedCategoryName,
            onTap: () async {
              final SearchProductProvider provider =
                  Provider.of<SearchProductProvider>(context, listen: false);

              final dynamic categoryResult =
                  await Navigator.pushNamed(context, RoutePaths.searchCategory);

              if (categoryResult != null && categoryResult is Category) {
                provider.categoryId = categoryResult.id;
                provider.subCategoryId = '';

                setState(() {
                  provider.selectedCategoryName = categoryResult.name;
                  provider.selectedSubCategoryName = '';
                });
              }
            }),
        // AppDropdownBaseWidget(
        //     title: Utils.getString(context, 'search__sub_category'),
        //     selectedText:
        //         Provider.of<SearchProductProvider>(context, listen: false)
        //             .selectedSubCategoryName,
        //     onTap: () async {
        //       final SearchProductProvider provider =
        //           Provider.of<SearchProductProvider>(context, listen: false);
        //       if (provider.categoryId != '') {
        //         final dynamic subCategoryResult = await Navigator.pushNamed(
        //             context, RoutePaths.searchSubCategory,
        //             arguments: provider.categoryId);
        //         if (subCategoryResult != null &&
        //             subCategoryResult is SubCategory) {
        //           provider.subCategoryId = subCategoryResult.id;

        //           provider.selectedSubCategoryName = subCategoryResult.name;
        //         }
        //       } else {
        //         showDialog<dynamic>(
        //             context: context,
        //             builder: (BuildContext context) {
        //               return ErrorDialog(
        //                 message: Utils.getString(
        //                      'home_search__choose_category_first'),
        //               );
        //             });
        //         const ErrorDialog(message: 'Choose Category first');
        //       }
        //     }),
      ],
    );
  }
}

class _ChangeRatingColor extends StatelessWidget {
  const _ChangeRatingColor({
    Key key,
    @required this.title,
    @required this.checkColor,
  }) : super(key: key);

  final String title;
  final bool checkColor;

  @override
  Widget build(BuildContext context) {
    final Color defaultBackgroundColor = AppColors.backgroundColor;
    return Container(
      width: MediaQuery.of(context).size.width / 5.5,
      height: AppDimens.space104,
      decoration: BoxDecoration(
        color: checkColor ? defaultBackgroundColor : AppColors.mainColor,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Icon(
              Icons.star,
              color: checkColor ? AppColors.iconColor : AppColors.white,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.caption.copyWith(
                    color: checkColor ? AppColors.iconColor : AppColors.white,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RatingRangeWidget extends StatefulWidget {
  @override
  __RatingRangeWidgetState createState() => __RatingRangeWidgetState();
}

class __RatingRangeWidgetState extends State<_RatingRangeWidget> {
  @override
  Widget build(BuildContext context) {
    final SearchProductProvider provider =
        Provider.of<SearchProductProvider>(context);

    dynamic _firstRatingRangeSelected() {
      if (!provider.isfirstRatingClicked) {
        return _ChangeRatingColor(
          title: Utils.getString('home_search__one_and_higher'),
          checkColor: true,
        );
      } else {
        return _ChangeRatingColor(
          title: Utils.getString('home_search__one_and_higher'),
          checkColor: false,
        );
      }
    }

    dynamic _secondRatingRangeSelected() {
      if (!provider.isSecondRatingClicked) {
        return _ChangeRatingColor(
          title: Utils.getString('home_search__two_and_higher'),
          checkColor: true,
        );
      } else {
        return _ChangeRatingColor(
          title: Utils.getString('home_search__two_and_higher'),
          checkColor: false,
        );
      }
    }

    dynamic _thirdRatingRangeSelected() {
      if (!provider.isThirdRatingClicked) {
        return _ChangeRatingColor(
          title: Utils.getString('home_search__three_and_higher'),
          checkColor: true,
        );
      } else {
        return _ChangeRatingColor(
          title: Utils.getString('home_search__three_and_higher'),
          checkColor: false,
        );
      }
    }

    dynamic _fouthRatingRangeSelected() {
      if (!provider.isfouthRatingClicked) {
        return _ChangeRatingColor(
          title: Utils.getString('home_search__four_and_higher'),
          checkColor: true,
        );
      } else {
        return _ChangeRatingColor(
          title: Utils.getString('home_search__four_and_higher'),
          checkColor: false,
        );
      }
    }

    dynamic _fifthRatingRangeSelected() {
      if (!provider.isFifthRatingClicked) {
        return _ChangeRatingColor(
          title: Utils.getString('home_search__five'),
          checkColor: true,
        );
      } else {
        return _ChangeRatingColor(
          title: Utils.getString('home_search__five'),
          checkColor: false,
        );
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(AppDimens.space12),
          child: Row(
            children: <Widget>[
              Text(Utils.getString('home_search__rating_range'),
                  style: Theme.of(context).textTheme.bodyText1),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width / 5.5,
              decoration: const BoxDecoration(),
              child: InkWell(
                onTap: () {
                  if (!provider.isfirstRatingClicked) {
                    provider.isfirstRatingClicked = true;
                    provider.isSecondRatingClicked = false;
                    provider.isThirdRatingClicked = false;
                    provider.isfouthRatingClicked = false;
                    provider.isFifthRatingClicked = false;
                  } else {
                    setAllRatingFalse(provider);
                  }

                  setState(() {});
                },
                child: _firstRatingRangeSelected(),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(AppDimens.space4),
              width: MediaQuery.of(context).size.width / 5.5,
              decoration: const BoxDecoration(),
              child: InkWell(
                onTap: () {
                  if (!provider.isSecondRatingClicked) {
                    provider.isfirstRatingClicked = false;
                    provider.isSecondRatingClicked = true;
                    provider.isThirdRatingClicked = false;
                    provider.isfouthRatingClicked = false;
                    provider.isFifthRatingClicked = false;
                  } else {
                    setAllRatingFalse(provider);
                  }

                  setState(() {});
                },
                child: _secondRatingRangeSelected(),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 5.5,
              decoration: const BoxDecoration(),
              child: InkWell(
                onTap: () {
                  if (!provider.isThirdRatingClicked) {
                    provider.isfirstRatingClicked = false;
                    provider.isSecondRatingClicked = false;
                    provider.isThirdRatingClicked = true;
                    provider.isfouthRatingClicked = false;
                    provider.isFifthRatingClicked = false;
                  } else {
                    setAllRatingFalse(provider);
                  }

                  setState(() {});
                },
                child: _thirdRatingRangeSelected(),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(AppDimens.space4),
              width: MediaQuery.of(context).size.width / 5.5,
              decoration: const BoxDecoration(),
              child: InkWell(
                onTap: () {
                  if (!provider.isfouthRatingClicked) {
                    provider.isfirstRatingClicked = false;
                    provider.isSecondRatingClicked = false;
                    provider.isThirdRatingClicked = false;
                    provider.isfouthRatingClicked = true;
                    provider.isFifthRatingClicked = false;
                  } else {
                    setAllRatingFalse(provider);
                  }

                  setState(() {});
                },
                child: _fouthRatingRangeSelected(),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 5.5,
              child: InkWell(
                onTap: () {
                  if (!provider.isFifthRatingClicked) {
                    provider.isfirstRatingClicked = false;
                    provider.isSecondRatingClicked = false;
                    provider.isThirdRatingClicked = false;
                    provider.isfouthRatingClicked = false;
                    provider.isFifthRatingClicked = true;
                  } else {
                    setAllRatingFalse(provider);
                  }

                  setState(() {});
                },
                child: _fifthRatingRangeSelected(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

dynamic setAllRatingFalse(SearchProductProvider provider) {
  provider.isfirstRatingClicked = false;
  provider.isSecondRatingClicked = false;
  provider.isThirdRatingClicked = false;
  provider.isfouthRatingClicked = false;
  provider.isFifthRatingClicked = false;
}

class _PriceWidget extends StatelessWidget {
  const _PriceWidget(
      {this.userInputMinimumPriceEditingController,
      this.userInputMaximunPriceEditingController});
  final TextEditingController userInputMinimumPriceEditingController;
  final TextEditingController userInputMaximunPriceEditingController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(AppDimens.space12),
          child: Row(
            children: <Widget>[
              Text(Utils.getString('home_search__price'),
                  style: Theme.of(context).textTheme.bodyText1),
            ],
          ),
        ),
        _PriceTextWidget(
            title: Utils.getString('home_search__lowest_price'),
            textField: TextField(
                maxLines: null,
                style: Theme.of(context).textTheme.bodyText2,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(
                      left: AppDimens.space8, bottom: AppDimens.space12),
                  border: InputBorder.none,
                  hintText: Utils.getString('home_search__not_set'),
                  hintStyle: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(color: AppColors.textPrimaryLightColor),
                ),
                keyboardType: TextInputType.number,
                controller: userInputMinimumPriceEditingController)),
        const Divider(
          height: AppDimens.space1,
        ),
        _PriceTextWidget(
            title: Utils.getString('home_search__highest_price'),
            textField: TextField(
                maxLines: null,
                style: Theme.of(context).textTheme.bodyText2,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(
                      left: AppDimens.space8, bottom: AppDimens.space12),
                  border: InputBorder.none,
                  hintText: Utils.getString('home_search__not_set'),
                  hintStyle: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(color: AppColors.textPrimaryLightColor),
                ),
                keyboardType: TextInputType.number,
                controller: userInputMaximunPriceEditingController)),
      ],
    );
  }
}

class _PriceTextWidget extends StatelessWidget {
  const _PriceTextWidget({
    Key key,
    @required this.title,
    @required this.textField,
  }) : super(key: key);

  final String title;
  final TextField textField;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.backgroundColor,
      child: Container(
        margin: const EdgeInsets.all(AppDimens.space12),
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(title, style: Theme.of(context).textTheme.bodyText2),
            Container(
                decoration: BoxDecoration(
                  color: AppColors.backgroundColor,
                  borderRadius: BorderRadius.circular(AppDimens.space4),
                  border: Border.all(color: AppColors.mainDividerColor),
                ),
                width: AppDimens.space120,
                height: AppDimens.space36,
                child: textField),
          ],
        ),
      ),
    );
  }
}

class _SpecialCheckWidget extends StatefulWidget {
  @override
  __SpecialCheckWidgetState createState() => __SpecialCheckWidgetState();
}

class __SpecialCheckWidgetState extends State<_SpecialCheckWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(AppDimens.space12),
          child: Row(
            children: <Widget>[
              Text(Utils.getString('home_search__special_check'),
                  style: Theme.of(context).textTheme.bodyText1),
            ],
          ),
        ),
        // SpecialCheckTextWidget(
        //     title: Utils.getString('home_search__featured_product'),
        //     icon: FontAwesome5.gem,
        //     checkTitle: 1,
        //     size: AppDimens.space18),
        // const Divider(
        //   height: AppDimens.space1,
        // ),
        SpecialCheckTextWidget(
            title: Utils.getString('home_search__discount_price'),
            icon: Feather.percent,
            checkTitle: 2,
            size: AppDimens.space18),
        const Divider(
          height: AppDimens.space1,
        ),
      ],
    );
  }
}

class _SpecialCheckTextWidget extends StatefulWidget {
  const _SpecialCheckTextWidget({
    Key key,
    @required this.title,
    @required this.icon,
    @required this.checkTitle,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final bool checkTitle;

  @override
  __SpecialCheckTextWidgetState createState() =>
      __SpecialCheckTextWidgetState();
}

class __SpecialCheckTextWidgetState extends State<_SpecialCheckTextWidget> {
  @override
  Widget build(BuildContext context) {
    final SearchProductProvider provider =
        Provider.of<SearchProductProvider>(context);

    return Container(
        width: double.infinity,
        height: AppDimens.space52,
        child: Container(
          margin: const EdgeInsets.all(AppDimens.space12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(
                    widget.icon,
                    size: AppDimens.space20,
                  ),
                  const SizedBox(
                    width: AppDimens.space10,
                  ),
                  Text(
                    widget.title,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(fontWeight: FontWeight.normal),
                  ),
                ],
              ),
              if (widget.checkTitle)
                Switch(
                  value: provider.isSwitchedFeaturedProduct,
                  onChanged: (bool value) {
                    setState(() {
                      provider.isSwitchedFeaturedProduct = value;
                    });
                  },
                  activeTrackColor: AppColors.mainColor,
                  activeColor: AppColors.mainColor,
                )
              else
                Switch(
                  value: provider.isSwitchedDiscountPrice,
                  onChanged: (bool value) {
                    setState(() {
                      provider.isSwitchedDiscountPrice = value;
                    });
                  },
                  activeTrackColor: AppColors.mainColor,
                  activeColor: AppColors.mainColor,
                ),
            ],
          ),
        ));
  }
}
