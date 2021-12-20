import 'package:dni_ecommerce/api/common/app_status.dart';
import 'package:dni_ecommerce/config/app_config.dart';
import 'package:dni_ecommerce/config/app_colors.dart';
import 'package:dni_ecommerce/provider/shipping_city/shipping_city_provider.dart';
import 'package:dni_ecommerce/repository/shipping_city_repository.dart';
import 'package:dni_ecommerce/ui/common/app_ui_widget.dart';
import 'package:dni_ecommerce/ui/common/app_frame_loading_widget.dart';
import 'package:dni_ecommerce/ui/common/app_widget_with_appbar.dart';
import 'package:dni_ecommerce/utils/utils.dart';
import 'package:dni_ecommerce/viewobject/common/app_value_holder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'city_list_item_view.dart';

class CityListView extends StatefulWidget {
  const CityListView({@required this.countryId});

  final String countryId;
  @override
  State<StatefulWidget> createState() {
    return _CityListViewState();
  }
}

class _CityListViewState extends State<CityListView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  ShippingCityProvider shippingCityProvider;
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
        shippingCityProvider.nextShippingCityList(
            appValueHolder.shopId, appValueHolder.shopId);
      }
    });

    animationController = AnimationController(
        duration: AppConfig.animation_duration, vsync: this);
    animation = Tween<double>(
      begin: 0.0,
      end: 10.0,
    ).animate(animationController);
    super.initState();
  }

  ShippingCityRepository repo1;
  AppValueHolder appValueHolder;

  @override
  Widget build(BuildContext context) {
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

    repo1 = Provider.of<ShippingCityRepository>(context);
    appValueHolder = Provider.of<AppValueHolder>(context);

    print(
        '............................Build UI Again ............................');

    return WillPopScope(
        onWillPop: _requestPop,
        child: AppWidgetWithAppBar<ShippingCityProvider>(
            appBarTitle: Utils.getString('city_list__app_bar_name') ?? '',
            initProvider: () {
              return ShippingCityProvider(
                  repo: repo1, appValueHolder: appValueHolder);
            },
            onProviderReady: (ShippingCityProvider provider) {
              provider.loadShippingCityList(
                  'shop0b69bc5dbd68bbd57ea13dfc5488e20a', widget.countryId);
              shippingCityProvider = provider;
              return shippingCityProvider;
            },
            builder: (BuildContext context, ShippingCityProvider provider,
                Widget child) {
              return Stack(children: <Widget>[
                Container(
                    child: RefreshIndicator(
                  child: ListView.builder(
                      controller: _scrollController,
                      itemCount: provider.shippingCityList.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (provider.shippingCityList.status ==
                            AppStatus.BLOCK_LOADING) {
                          return Shimmer.fromColors(
                              baseColor: AppColors.grey,
                              highlightColor: AppColors.white,
                              child: Column(children: const <Widget>[
                                AppFrameUIForLoading(),
                                AppFrameUIForLoading(),
                                AppFrameUIForLoading(),
                                AppFrameUIForLoading(),
                                AppFrameUIForLoading(),
                                AppFrameUIForLoading(),
                                AppFrameUIForLoading(),
                                AppFrameUIForLoading(),
                                AppFrameUIForLoading(),
                                AppFrameUIForLoading(),
                              ]));
                        } else {
                          final int count =
                              provider.shippingCityList.data.length;
                          return FadeTransition(
                              opacity: animation,
                              child: CityListItem(
                                animationController: animationController,
                                animation:
                                    Tween<double>(begin: 0.0, end: 1.0).animate(
                                  CurvedAnimation(
                                    parent: animationController,
                                    curve: Interval((1 / count) * index, 1.0,
                                        curve: Curves.fastOutSlowIn),
                                  ),
                                ),
                                city: provider.shippingCityList.data[index],
                                onTap: () {
                                  Navigator.pop(context,
                                      provider.shippingCityList.data[index]);
                                  print(provider
                                      .shippingCityList.data[index].name);
                                },
                              ));
                        }
                      }),
                  onRefresh: () {
                    return provider.resetShippingCityList(
                        appValueHolder.shopId, appValueHolder.shopId);
                  },
                )),
                AppProgressIndicator(provider.shippingCityList.status)
              ]);
            }));
  }
}
