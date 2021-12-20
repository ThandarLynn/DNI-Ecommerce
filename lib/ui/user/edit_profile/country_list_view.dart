import 'package:dni_ecommerce/api/common/app_status.dart';
import 'package:dni_ecommerce/config/app_config.dart';
import 'package:dni_ecommerce/config/app_colors.dart';
import 'package:dni_ecommerce/provider/shipping_country/shipping_country_provider.dart';
import 'package:dni_ecommerce/repository/shipping_country_repository.dart';
import 'package:dni_ecommerce/ui/common/app_ui_widget.dart';
import 'package:dni_ecommerce/ui/common/app_frame_loading_widget.dart';
import 'package:dni_ecommerce/ui/common/app_widget_with_appbar.dart';
import 'package:dni_ecommerce/utils/utils.dart';
import 'package:dni_ecommerce/viewobject/common/app_value_holder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'country_list_item_view.dart';

class CountryListView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CountryListViewState();
  }
}

class _CountryListViewState extends State<CountryListView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  ShippingCountryProvider shippingCountryProvider;
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
        shippingCountryProvider.nextShippingCountryList(appValueHolder.shopId);
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

  ShippingCountryRepository repo1;
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

    repo1 = Provider.of<ShippingCountryRepository>(context);
    appValueHolder = Provider.of<AppValueHolder>(context);

    print(
        '............................Build UI Again ............................');

    return WillPopScope(
        onWillPop: _requestPop,
        child: AppWidgetWithAppBar<ShippingCountryProvider>(
            appBarTitle: Utils.getString('country_list__app_bar_name') ?? '',
            initProvider: () {
              return ShippingCountryProvider(
                  repo: repo1, appValueHolder: appValueHolder);
            },
            onProviderReady: (ShippingCountryProvider provider) {
              provider.loadShippingCountryList(
                  'shop0b69bc5dbd68bbd57ea13dfc5488e20a');
              shippingCountryProvider = provider;
              return shippingCountryProvider;
            },
            builder: (BuildContext context, ShippingCountryProvider provider,
                Widget child) {
              return Stack(children: <Widget>[
                Container(
                    child: RefreshIndicator(
                  child: ListView.builder(
                      controller: _scrollController,
                      itemCount: provider.shippingCountryList.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (provider.shippingCountryList.status ==
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
                              provider.shippingCountryList.data.length;
                          return FadeTransition(
                              opacity: animation,
                              child: CountryListItem(
                                animationController: animationController,
                                animation:
                                    Tween<double>(begin: 0.0, end: 1.0).animate(
                                  CurvedAnimation(
                                    parent: animationController,
                                    curve: Interval((1 / count) * index, 1.0,
                                        curve: Curves.fastOutSlowIn),
                                  ),
                                ),
                                country:
                                    provider.shippingCountryList.data[index],
                                onTap: () {
                                  Navigator.pop(context,
                                      provider.shippingCountryList.data[index]);
                                  print(provider
                                      .shippingCountryList.data[index].name);
                                },
                              ));
                        }
                      }),
                  onRefresh: () {
                    return provider
                        .resetShippingCountryList(appValueHolder.shopId);
                  },
                )),
                AppProgressIndicator(provider.shippingCountryList.status)
              ]);
            }));
  }
}
