import 'package:dni_ecommerce/config/app_config.dart';
import 'package:dni_ecommerce/config/app_colors.dart';
import 'package:dni_ecommerce/provider/user/user_provider.dart';
import 'package:dni_ecommerce/repository/user_repository.dart';
import 'package:dni_ecommerce/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'register_view.dart';

class RegisterContainerView extends StatefulWidget {
  @override
  _CityRegisterContainerViewState createState() =>
      _CityRegisterContainerViewState();
}

class _CityRegisterContainerViewState extends State<RegisterContainerView>
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
  UserProvider userProvider;
  UserRepository userRepo;

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
    userRepo = Provider.of<UserRepository>(context);
    return WillPopScope(
        onWillPop: _requestPop,
        child: Scaffold(
          body: Stack(children: <Widget>[
            Container(
              color: AppColors.mainLightColorWithBlack,
              width: double.infinity,
              height: double.maxFinite,
            ),
            CustomScrollView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                slivers: <Widget>[
                  _SliverAppbar(
                    title: Utils.getString('register__title'),
                    scaffoldKey: scaffoldKey,
                  ),
                  RegisterView(
                    animationController: animationController,
                  ),
                ])
          ]),
        ));
  }
}

class _SliverAppbar extends StatefulWidget {
  const _SliverAppbar(
      {Key key, @required this.title, this.scaffoldKey, this.menuDrawer})
      : super(key: key);
  final String title;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Drawer menuDrawer;
  @override
  _SliverAppbarState createState() => _SliverAppbarState();
}

class _SliverAppbarState extends State<_SliverAppbar> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      brightness: Utils.getBrightnessForAppBar(context),
      iconTheme: Theme.of(context)
          .iconTheme
          .copyWith(color: AppColors.mainColorWithWhite),
      title: Text(
        widget.title,
        textAlign: TextAlign.center,
        style: Theme.of(context)
            .textTheme
            .headline6
            .copyWith(fontWeight: FontWeight.bold)
            .copyWith(color: AppColors.mainColorWithWhite),
      ),
      elevation: 0,
    );
  }
}
