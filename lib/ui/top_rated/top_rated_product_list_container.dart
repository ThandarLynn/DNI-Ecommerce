import 'package:dni_ecommerce/config/app_colors.dart';
import 'package:dni_ecommerce/config/app_config.dart';
import 'package:dni_ecommerce/utils/utils.dart';
import 'package:flutter/material.dart';

import 'top_rated_product_list_view.dart';

class TopRatedProductListContainerView extends StatefulWidget {
  @override
  _TopRatedProductListContainerViewState createState() =>
      _TopRatedProductListContainerViewState();
}

class _TopRatedProductListContainerViewState
    extends State<TopRatedProductListContainerView>
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
            Utils.getString('home__menu_drawer_favourite'),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline6.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.mainColorWithWhite),
          ),
          elevation: 0,
        ),
        body: TopRatedProductListView(
          animationController: animationController,
        ),
      ),
    );
  }
}
