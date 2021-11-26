import 'package:dni_ecommerce/config/app_config.dart';
import 'package:dni_ecommerce/config/app_colors.dart';
import 'package:dni_ecommerce/constant/app_dimens.dart';
import 'package:dni_ecommerce/constant/route_paths.dart';
import 'package:dni_ecommerce/provider/basket/basket_provider.dart';
import 'package:dni_ecommerce/repository/basket_repository.dart';
import 'package:dni_ecommerce/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'category_list_view.dart';

class CategoryListViewContainerView extends StatefulWidget {
  const CategoryListViewContainerView({this.appBarTitle});

  final String appBarTitle;
  @override
  _CategoryListWithFilterContainerViewState createState() =>
      _CategoryListWithFilterContainerViewState();
}

class _CategoryListWithFilterContainerViewState
    extends State<CategoryListViewContainerView>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  @override
  void initState() {
    animationController = AnimationController(
        duration: AppConfig.animation_duration, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  BasketRepository basketRepository;

  @override
  Widget build(BuildContext context) {
    basketRepository = Provider.of<BasketRepository>(context);
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

    print(
        '............................Build UI Again ............................');
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          brightness: Utils.getBrightnessForAppBar(context),
          iconTheme: Theme.of(context)
              .iconTheme
              .copyWith(color: AppColors.mainColorWithWhite),
          title: Text(
            widget.appBarTitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline6.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.mainColorWithWhite),
          ),
          elevation: 0,
          actions: <Widget>[
            ChangeNotifierProvider<BasketProvider>(
              lazy: false,
              create: (BuildContext context) {
                final BasketProvider provider =
                    BasketProvider(repo: basketRepository);
                provider.loadBasketList();
                return provider;
              },
              child: Consumer<BasketProvider>(builder: (BuildContext context,
                  BasketProvider basketProvider, Widget child) {
                return InkWell(
                    child: Stack(
                      children: <Widget>[
                        Container(
                          width: AppDimens.space40,
                          height: AppDimens.space40,
                          margin: const EdgeInsets.only(
                              top: AppDimens.space8,
                              left: AppDimens.space8,
                              right: AppDimens.space8),
                          child: Align(
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.shopping_basket,
                              color: AppColors.mainColor,
                            ),
                          ),
                        ),
                        Positioned(
                          right: AppDimens.space4,
                          top: AppDimens.space1,
                          child: Container(
                            width: AppDimens.space28,
                            height: AppDimens.space28,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.black.withAlpha(200),
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                basketProvider.basketList.data.length > 99
                                    ? '99+'
                                    : basketProvider.basketList.data.length
                                        .toString(),
                                textAlign: TextAlign.left,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(color: AppColors.white),
                                maxLines: 1,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        RoutePaths.basketList,
                      );
                    });
              }),
            )
          ],
        ),
        body: CategoryListView(),
      ),
    );
  }
}
