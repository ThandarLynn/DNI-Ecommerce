import 'dart:io';

import 'package:dni_ecommerce/config/app_config.dart';
import 'package:dni_ecommerce/config/app_colors.dart';
import 'package:dni_ecommerce/constant/app_constant.dart';
import 'package:dni_ecommerce/constant/app_dimens.dart';
import 'package:dni_ecommerce/constant/route_paths.dart';
import 'package:dni_ecommerce/provider/basket/basket_provider.dart';
import 'package:dni_ecommerce/provider/user/user_provider.dart';
import 'package:dni_ecommerce/repository/basket_repository.dart';
import 'package:dni_ecommerce/repository/product_repository.dart';
import 'package:dni_ecommerce/repository/user_repository.dart';
import 'package:dni_ecommerce/ui/category/category_list_view.dart';
import 'package:dni_ecommerce/ui/common/dialog/confirm_dialog_view.dart';
import 'package:dni_ecommerce/ui/contact/contact_us_view.dart';
import 'package:dni_ecommerce/ui/dashboard/home/home_dashboard_view.dart';
import 'package:dni_ecommerce/ui/favourite/history_list_view.dart';
import 'package:dni_ecommerce/ui/language/language_view.dart';
import 'package:dni_ecommerce/ui/product/filter/product_list_with_filter_view.dart';
import 'package:dni_ecommerce/ui/search/home_item_search_view.dart';
import 'package:dni_ecommerce/ui/setting/setting_view.dart';
import 'package:dni_ecommerce/ui/transaction/list/transaction_list_view.dart';
import 'package:dni_ecommerce/ui/user/forgot_password/forgot_password_view.dart';
import 'package:dni_ecommerce/ui/user/login/login_view.dart';
import 'package:dni_ecommerce/ui/user/profile/profile_view.dart';
import 'package:dni_ecommerce/ui/user/register/register_view.dart';
import 'package:dni_ecommerce/utils/utils.dart';
import 'package:dni_ecommerce/viewobject/common/app_value_holder.dart';
import 'package:dni_ecommerce/viewobject/holder/product_parameter_holder.dart';
import 'package:dni_ecommerce/viewobject/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:provider/single_child_widget.dart';

class DashboardView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<DashboardView>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  AnimationController animationController;

  Animation<double> animation;
  // BasketRepository basketRepository;

  String appBarTitle = 'Home';
  int _currentIndex = AppConst.REQUEST_CODE__MENU_HOME_FRAGMENT;
  String _userId = '';
  bool isLogout = false;
  bool isFirstTime = true;
  String phoneUserName = '';
  String phoneNumber = '';
  String phoneId = '';
  bool isResumed = false;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  // final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      isResumed = true;
      // initDynamicLinks(context);
    }
  }

  @override
  void initState() {
    animationController = AnimationController(
        duration: AppConfig.animation_duration, vsync: this);

    super.initState();
    // Utils.fcmConfigure(context, _fcm);
    // initDynamicLinks(context);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  // Future<void> initDynamicLinks(BuildContext context) async {
  //   Future<dynamic>.delayed(const Duration(seconds: 3)); //recomme
  //   String itemId = '';
  //   if (!isResumed) {
  //     final PendingDynamicLinkData data =
  //         await FirebaseDynamicLinks.instance.getInitialLink();

  //     if (data != null && data?.link != null) {
  //       final Uri deepLink = data?.link;
  //       if (deepLink != null) {
  //         final String path = deepLink.path;
  //         final List<String> pathList = path.split('=');
  //         itemId = pathList[1];
  //         final ProductDetailIntentHolder holder = ProductDetailIntentHolder(
  //           productId: itemId,
  //           heroTagImage: '-1' + pathList[1] + AppConst.HERO_TAG__IMAGE,
  //           heroTagTitle: '-1' + pathList[1] + AppConst.HERO_TAG__TITLE,
  //           heroTagOriginalPrice:
  //               '-1' + pathList[1] + AppConst.HERO_TAG__ORIGINAL_PRICE,
  //           heroTagUnitPrice:
  //               '-1' + pathList[1] + AppConst.HERO_TAG__UNIT_PRICE,
  //         );
  //         Navigator.pushNamed(context, RoutePaths.productDetail,
  //             arguments: holder);
  //       }
  //     }
  //   }

  //   FirebaseDynamicLinks.instance.onLink(
  //       onSuccess: (PendingDynamicLinkData dynamicLink) async {
  //     final Uri deepLink = dynamicLink?.link;
  //     if (deepLink != null) {
  //       final String path = deepLink.path;
  //       final List<String> pathList = path.split('=');
  //       if (itemId == '') {
  //         final ProductDetailIntentHolder holder = ProductDetailIntentHolder(
  //             productId: pathList[1],
  //             heroTagImage: '-1' + pathList[1] + AppConst.HERO_TAG__IMAGE,
  //             heroTagTitle: '-1' + pathList[1] + AppConst.HERO_TAG__TITLE);
  //         Navigator.pushNamed(context, RoutePaths.productDetail,
  //             arguments: holder);
  //       }
  //     }
  //     debugPrint('DynamicLinks onLink $deepLink');
  //   }, onError: (OnLinkErrorException e) async {
  //     debugPrint('DynamicLinks onError $e');
  //   });
  // }

  int getBottonNavigationIndex(int param) {
    int index = 0;
    switch (param) {
      case AppConst.REQUEST_CODE__MENU_HOME_FRAGMENT:
        index = 0;
        break;
      // case AppConst.REQUEST_CODE__DASHBOARD_SHOP_INFO_FRAGMENT:
      //   index = 1;
      //   break;
      case AppConst.REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT:
        index = 1;
        break;
      case AppConst.REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT:
        index = 1;
        break;
      case AppConst.REQUEST_CODE__DASHBOARD_FORGOT_PASSWORD_FRAGMENT:
        index = 1;
        break;
      case AppConst.REQUEST_CODE__DASHBOARD_LOGIN_FRAGMENT:
        index = 1;
        break;
      // case AppConst.REQUEST_CODE__DASHBOARD_VERIFY_EMAIL_FRAGMENT:
      //   index = 1;
      //   break;
      case AppConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT:
        index = 1;
        break;
      // case AppConst.REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT:
      //   index = 1;
      //   break;
      // case AppConst.REQUEST_CODE__DASHBOARD_PHONE_VERIFY_FRAGMENT:
      //   index = 1;
      //   break;
      case AppConst.REQUEST_CODE__DASHBOARD_SEARCH_FRAGMENT:
        index = 2;
        break;
      case AppConst.REQUEST_CODE__DASHBOARD_BASKET_FRAGMENT:
        index = 3;
        break;
      default:
        index = 0;
        break;
    }
    return index;
  }

  dynamic getIndexFromBottonNavigationIndex(int param) {
    int index = AppConst.REQUEST_CODE__MENU_HOME_FRAGMENT;
    String title;
    final AppValueHolder psValueHolder =
        Provider.of<AppValueHolder>(context, listen: false);
    switch (param) {
      case 0:
        index = AppConst.REQUEST_CODE__MENU_HOME_FRAGMENT;
        title = Utils.getString('app_name');
        break;
      // case 1:
      //   index = AppConst.REQUEST_CODE__DASHBOARD_SHOP_INFO_FRAGMENT;
      //   title = Utils.getString('home__bottom_app_bar_shop_info');
      //   break;
      case 1:
        index = AppConst.REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT;
        title = (psValueHolder == null ||
                psValueHolder.userIdToVerify == null ||
                psValueHolder.userIdToVerify == '')
            ? Utils.getString('home__bottom_app_bar_login')
            : Utils.getString('home__bottom_app_bar_verify_email');
        break;
      case 2:
        index = AppConst.REQUEST_CODE__DASHBOARD_SEARCH_FRAGMENT;
        title = Utils.getString('home__bottom_app_bar_search');
        break;
      case 3:
        index = AppConst.REQUEST_CODE__DASHBOARD_BASKET_FRAGMENT;
        title = Utils.getString('home__bottom_app_bar_basket_list');
        break;
      default:
        index = 0;
        title = Utils.getString('app_name');
        break;
    }
    return <dynamic>[title, index];
  }

  // ShopInfoRepository shopInfoRepository;
  UserRepository userRepository;
  ProductRepository productRepository;
  AppValueHolder valueHolder;
  // DeleteTaskRepository deleteTaskRepository;
  // DeleteTaskProvider deleteTaskProvider;
  // NotificationRepository notificationRepository;
  // AppInfoRepository appInfoRepository;
  BasketRepository basketRepository;

  @override
  Widget build(BuildContext context) {
    userRepository = Provider.of<UserRepository>(context);
    valueHolder = Provider.of<AppValueHolder>(context);
    productRepository = Provider.of<ProductRepository>(context);
    basketRepository = Provider.of<BasketRepository>(context);
    // deleteTaskRepository = Provider.of<DeleteTaskRepository>(context);
    // notificationRepository = Provider.of<NotificationRepository>(context);
    // appInfoRepository = Provider.of<AppInfoRepository>(context);

    timeDilation = 1.0;

    if (isFirstTime) {
      appBarTitle = Utils.getString('app_name');

      // Utils.subscribeToTopic(valueHolder.notiSetting ?? true);
      isFirstTime = false;
    }

    Future<void> updateSelectedIndexWithAnimation(
        String title, int index) async {
      await animationController.reverse().then<dynamic>((void data) {
        if (!mounted) {
          return;
        }

        setState(() {
          appBarTitle = title;
          _currentIndex = index;
        });
      });
    }

    Future<void> updateSelectedIndexWithAnimationUserId(
        String title, int index, String userId) async {
      await animationController.reverse().then<dynamic>((void data) {
        if (!mounted) {
          return;
        }
        if (userId != null) {
          _userId = userId;
        }
        setState(() {
          appBarTitle = title;
          _currentIndex = index;
        });
      });
    }

    Future<bool> _onWillPop() {
      return showDialog<dynamic>(
              context: context,
              builder: (BuildContext context) {
                return ConfirmDialogView(
                    description:
                        Utils.getString('home__quit_dialog_description'),
                    leftButtonText:
                        Utils.getString('app_info__cancel_button_name'),
                    rightButtonText: Utils.getString('dialog__ok'),
                    onAgreeTap: () {
                      SystemNavigator.pop();
                    });
              }) ??
          false;
    }

    final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
            parent: animationController,
            curve: const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn)));

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: scaffoldKey,
        drawer: Drawer(
          child: MultiProvider(
            providers: <SingleChildWidget>[
              ChangeNotifierProvider<UserProvider>(
                  lazy: false,
                  create: (BuildContext context) {
                    return UserProvider(
                        repo: userRepository, psValueHolder: valueHolder);
                  }),
            ],
            child: Consumer<UserProvider>(
              builder:
                  (BuildContext context, UserProvider provider, Widget child) {
                print(provider.psValueHolder.loginUserId);
                return ListView(padding: EdgeInsets.zero, children: <Widget>[
                  _DrawerHeaderWidget(),
                  ListTile(
                    title: Text(Utils.getString('home__drawer_menu_home')),
                  ),
                  _DrawerMenuWidget(
                      icon: Icons.store,
                      title: Utils.getString('home__drawer_menu_home'),
                      index: AppConst.REQUEST_CODE__MENU_HOME_FRAGMENT,
                      onTap: (String title, int index) {
                        Navigator.pop(context);
                        updateSelectedIndexWithAnimation(
                            Utils.getString('app_name'), index);
                      }),
                  _DrawerMenuWidget(
                      icon: Icons.category,
                      title: Utils.getString('home__drawer_menu_category'),
                      index: AppConst.REQUEST_CODE__MENU_CATEGORY_FRAGMENT,
                      onTap: (String title, int index) {
                        Navigator.pop(context);
                        updateSelectedIndexWithAnimation(title, index);
                      }),
                  _DrawerMenuWidget(
                      icon: Icons.schedule,
                      title:
                          Utils.getString('home__drawer_menu_latest_product'),
                      index:
                          AppConst.REQUEST_CODE__MENU_LATEST_PRODUCT_FRAGMENT,
                      onTap: (String title, int index) {
                        Navigator.pop(context);
                        updateSelectedIndexWithAnimation(title, index);
                      }),
                  _DrawerMenuWidget(
                      icon: Feather.percent,
                      title:
                          Utils.getString('home__drawer_menu_discount_product'),
                      index:
                          AppConst.REQUEST_CODE__MENU_DISCOUNT_PRODUCT_FRAGMENT,
                      onTap: (String title, int index) {
                        Navigator.pop(context);
                        updateSelectedIndexWithAnimation(title, index);
                      }),
                  // _DrawerMenuWidget(
                  //     icon: FontAwesome5.gem,
                  //     title:
                  //         Utils.getString('home__menu_drawer_featured_product'),
                  //     index:
                  //         AppConst.REQUEST_CODE__MENU_FEATURED_PRODUCT_FRAGMENT,
                  //     onTap: (String title, int index) {
                  //       Navigator.pop(context);
                  //       updateSelectedIndexWithAnimation(title, index);
                  //     }),
                  // _DrawerMenuWidget(
                  //     icon: Icons.trending_up,
                  //     title:
                  //         Utils.getString('home__drawer_menu_trending_product'),
                  //     index:
                  //         AppConst.REQUEST_CODE__MENU_TRENDING_PRODUCT_FRAGMENT,
                  //     onTap: (String title, int index) {
                  //       Navigator.pop(context);
                  //       updateSelectedIndexWithAnimation(title, index);
                  //     }),
                  // _DrawerMenuWidget(
                  //     icon: Icons.folder_open,
                  //     title: Utils.getString('home__menu_drawer_collection'),
                  //     index: AppConst.REQUEST_CODE__MENU_COLLECTION_FRAGMENT,
                  //     onTap: (String title, int index) {
                  //       Navigator.pop(context);
                  //       updateSelectedIndexWithAnimation(title, index);
                  //     }),
                  const Divider(
                    height: AppDimens.space1,
                  ),
                  ListTile(
                    title: Text(Utils.getString('home__menu_drawer_user_info')),
                  ),
                  _DrawerMenuWidget(
                      icon: Icons.person,
                      title: Utils.getString('home__menu_drawer_profile'),
                      index: AppConst
                          .REQUEST_CODE__MENU_SELECT_WHICH_USER_FRAGMENT,
                      onTap: (String title, int index) {
                        Navigator.pop(context);
                        title = (valueHolder == null ||
                                valueHolder.userIdToVerify == null ||
                                valueHolder.userIdToVerify == '')
                            ? Utils.getString('home__menu_drawer_profile')
                            : Utils.getString(
                                'home__bottom_app_bar_verify_email');
                        updateSelectedIndexWithAnimation(title, index);
                      }),
                  if (provider != null)
                    if (provider.psValueHolder.loginUserId != null &&
                        provider.psValueHolder.loginUserId != '')
                      Visibility(
                        visible: true,
                        child: _DrawerMenuWidget(
                            icon: Icons.favorite_border,
                            title:
                                Utils.getString('home__menu_drawer_favourite'),
                            index:
                                AppConst.REQUEST_CODE__MENU_FAVOURITE_FRAGMENT,
                            onTap: (String title, int index) {
                              Navigator.pop(context);
                              updateSelectedIndexWithAnimation(title, index);
                            }),
                      ),
                  // if (provider != null)
                  //   if (provider.psValueHolder.loginUserId != null &&
                  //       provider.psValueHolder.loginUserId != '')
                  Visibility(
                    visible: true,
                    child: _DrawerMenuWidget(
                      icon: Icons.swap_horiz,
                      title: Utils.getString('home__menu_drawer_transaction'),
                      index: AppConst.REQUEST_CODE__MENU_TRANSACTION_FRAGMENT,
                      onTap: (String title, int index) {
                        Navigator.pop(context);
                        updateSelectedIndexWithAnimation(title, index);
                      },
                    ),
                  ),
                  // if (provider != null)
                  //   if (provider.psValueHolder.loginUserId != null &&
                  //       provider.psValueHolder.loginUserId != '')
                  //     Visibility(
                  //       visible: true,
                  //       child: _DrawerMenuWidget(
                  //           icon: Icons.book,
                  //           title: Utils.getString(
                  //               'home__menu_drawer_user_history'),
                  //           index: AppConst
                  //               .REQUEST_CODE__MENU_USER_HISTORY_FRAGMENT,
                  //           onTap: (String title, int index) {
                  //             Navigator.pop(context);
                  //             updateSelectedIndexWithAnimation(title, index);
                  //           }),
                  //     ),
                  if (provider != null)
                    if (provider.psValueHolder.loginUserId != null &&
                        provider.psValueHolder.loginUserId != '')
                      Visibility(
                        visible: true,
                        child: ListTile(
                          leading: Icon(
                            Icons.power_settings_new,
                            color: AppColors.mainColorWithWhite,
                          ),
                          title: Text(
                            Utils.getString('home__menu_drawer_logout'),
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          onTap: () async {
                            Navigator.pop(context);
                            showDialog<dynamic>(
                                context: context,
                                builder: (BuildContext context) {
                                  return ConfirmDialogView(
                                      description: Utils.getString(
                                          'home__logout_dialog_description'),
                                      leftButtonText: Utils.getString(
                                          'home__logout_dialog_cancel_button'),
                                      rightButtonText: Utils.getString(
                                          'home__logout_dialog_ok_button'),
                                      onAgreeTap: () async {
                                        Navigator.of(context).pop();
                                        setState(() {
                                          _currentIndex = AppConst
                                              .REQUEST_CODE__MENU_HOME_FRAGMENT;
                                        });
                                        await provider.replaceLoginUserId('','');
                                        await fb_auth.FirebaseAuth.instance
                                            .signOut();
                                      });
                                });
                          },
                        ),
                      ),
                  const Divider(
                    height: AppDimens.space1,
                  ),
                  ListTile(
                    title: Text(Utils.getString('home__menu_drawer_app')),
                  ),
                  _DrawerMenuWidget(
                      icon: Icons.g_translate,
                      title: Utils.getString('home__menu_drawer_language'),
                      index: AppConst.REQUEST_CODE__MENU_LANGUAGE_FRAGMENT,
                      onTap: (String title, int index) {
                        Navigator.pop(context);
                        updateSelectedIndexWithAnimation('', index);
                      }),
                  _DrawerMenuWidget(
                      icon: Icons.contacts,
                      title: Utils.getString('home__menu_drawer_contact_us'),
                      index: AppConst.REQUEST_CODE__MENU_CONTACT_US_FRAGMENT,
                      onTap: (String title, int index) {
                        Navigator.pop(context);
                        updateSelectedIndexWithAnimation(title, index);
                      }),
                  _DrawerMenuWidget(
                      icon: Icons.settings,
                      title: Utils.getString('home__menu_drawer_setting'),
                      index: AppConst.REQUEST_CODE__MENU_SETTING_FRAGMENT,
                      onTap: (String title, int index) {
                        Navigator.pop(context);
                        updateSelectedIndexWithAnimation(title, index);
                      }),
                  // _DrawerMenuWidget(
                  //     icon: Icons.info_outline,
                  //     title: Utils.getString('privacy_policy__toolbar_name'),
                  //     index: AppConst
                  //         .REQUEST_CODE__MENU_TERMS_AND_CONDITION_FRAGMENT,
                  //     onTap: (String title, int index) {
                  //       Navigator.pop(context);
                  //       updateSelectedIndexWithAnimation(title, index);
                  //     }),
                  ListTile(
                    leading: Icon(
                      Icons.share,
                      color: AppColors.mainColorWithWhite,
                    ),
                    title: Text(
                      Utils.getString('home__menu_drawer_share_this_app'),
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      if (Platform.isIOS) {
                        Utils.launchAppStoreURL(
                            iOSAppId: AppConfig.iOSAppStoreId,
                            writeReview: true);
                      } else {
                        Utils.launchURL();
                      }
                    },
                  ),
                  // ListTile(
                  //   leading: Icon(
                  //     Icons.star_border,
                  //     color: AppColors.mainColorWithWhite,
                  //   ),
                  //   title: Text(
                  //     Utils.getString('home__menu_drawer_rate_this_app'),
                  //     style: Theme.of(context).textTheme.bodyText2,
                  //   ),
                  //   onTap: () {
                  //     // Navigator.pop(context);
                  //     // if (Platform.isIOS) {
                  //     //   Utils.launchAppStoreURL(
                  //     //       iOSAppId: AppConfig.iOSAppStoreId,
                  //     //       writeReview: true);
                  //     // } else {
                  //     //   Utils.launchURL();
                  //     // }
                  //   },
                  // )
                ]);
              },
            ),
          ),
        ),
        appBar: AppBar(
          backgroundColor:
              (appBarTitle == Utils.getString('home__verify_email') ||
                      appBarTitle == Utils.getString('home_verify_phone'))
                  ? AppColors.mainColor
                  : AppColors.baseColor,
          title: Text(
            appBarTitle,
            style: Theme.of(context).textTheme.headline6.copyWith(
                  fontWeight: FontWeight.bold,
                  color: (appBarTitle ==
                              Utils.getString('home__verify_email') ||
                          appBarTitle == Utils.getString('home_verify_phone'))
                      ? AppColors.white
                      : AppColors.mainColorWithWhite,
                ),
          ),
          titleSpacing: 0,
          elevation: 0,
          iconTheme: IconThemeData(
              color: (appBarTitle == Utils.getString('home__verify_email') ||
                      appBarTitle == Utils.getString('home_verify_phone'))
                  ? AppColors.white
                  : AppColors.mainColorWithWhite),
          textTheme: Theme.of(context).textTheme,
          brightness: Utils.getBrightnessForAppBar(context),
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
                })),
          ],
        ),
        bottomNavigationBar: _currentIndex ==
                    AppConst.REQUEST_CODE__MENU_HOME_FRAGMENT ||
                // _currentIndex ==
                //     AppConst.REQUEST_CODE__DASHBOARD_SHOP_INFO_FRAGMENT ||
                _currentIndex ==
                    AppConst
                        .REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT ||
                _currentIndex ==
                    AppConst
                        .REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT || //go to profile
                _currentIndex ==
                    AppConst
                        .REQUEST_CODE__DASHBOARD_FORGOT_PASSWORD_FRAGMENT || //go to forgot password
                _currentIndex ==
                    AppConst
                        .REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT || //go to register
                _currentIndex ==
                    AppConst
                        .REQUEST_CODE__DASHBOARD_VERIFY_EMAIL_FRAGMENT || //go to email verify
                _currentIndex ==
                    AppConst.REQUEST_CODE__DASHBOARD_SEARCH_FRAGMENT ||
                _currentIndex ==
                    AppConst.REQUEST_CODE__DASHBOARD_BASKET_FRAGMENT ||
                _currentIndex ==
                    AppConst.REQUEST_CODE__DASHBOARD_LOGIN_FRAGMENT ||
                _currentIndex ==
                    AppConst.REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT ||
                _currentIndex ==
                    AppConst.REQUEST_CODE__DASHBOARD_PHONE_VERIFY_FRAGMENT
            ? Visibility(
                visible: true,
                child: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  currentIndex: getBottonNavigationIndex(_currentIndex),
                  showUnselectedLabels: true,
                  backgroundColor: AppColors.backgroundColor,
                  selectedItemColor: AppColors.mainColor,
                  elevation: 10,
                  onTap: (int index) {
                    final dynamic _returnValue =
                        getIndexFromBottonNavigationIndex(index);

                    updateSelectedIndexWithAnimation(
                        _returnValue[0], _returnValue[1]);
                  },
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: const Icon(
                        Icons.store,
                        size: 20,
                      ),
                      label: Utils.getString('dashboard__home'),
                    ),
                    // BottomNavigationBarItem(
                    //   icon: const Icon(Icons.info_outline),
                    //   label: Utils.getString('home__bottom_app_bar_shop_info'),
                    // ),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.person),
                      label: Utils.getString('home__bottom_app_bar_login'),
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.search),
                      label: Utils.getString('home__bottom_app_bar_search'),
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.shopping_cart),
                      label:
                          Utils.getString('home__bottom_app_bar_basket_list'),
                    )
                  ],
                ),
              )
            : null,
        floatingActionButton: _currentIndex ==
                    AppConst.REQUEST_CODE__MENU_HOME_FRAGMENT ||
                // _currentIndex ==
                //     AppConst.REQUEST_CODE__DASHBOARD_SHOP_INFO_FRAGMENT ||
                _currentIndex ==
                    AppConst
                        .REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT ||
                _currentIndex ==
                    AppConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT ||
                _currentIndex ==
                    AppConst.REQUEST_CODE__DASHBOARD_FORGOT_PASSWORD_FRAGMENT ||
                _currentIndex ==
                    AppConst.REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT ||
                _currentIndex ==
                    AppConst.REQUEST_CODE__DASHBOARD_VERIFY_EMAIL_FRAGMENT ||
                _currentIndex ==
                    AppConst.REQUEST_CODE__DASHBOARD_SEARCH_FRAGMENT ||
                _currentIndex ==
                    AppConst.REQUEST_CODE__DASHBOARD_BASKET_FRAGMENT ||
                _currentIndex ==
                    AppConst.REQUEST_CODE__DASHBOARD_LOGIN_FRAGMENT ||
                _currentIndex ==
                    AppConst.REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT ||
                _currentIndex ==
                    AppConst.REQUEST_CODE__DASHBOARD_PHONE_VERIFY_FRAGMENT
            ? Container(
                height: 65.0,
                width: 65.0,
                child: FittedBox(
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: AppColors.mainColor.withOpacity(0.3),
                              offset: const Offset(1.1, 1.1),
                              blurRadius: 10.0),
                        ],
                      ),
                      child: Container()),
                ),
              )
            : null,
        body: Builder(
          builder: (BuildContext context) {
            if (_currentIndex ==
                AppConst.REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT) {
              return ChangeNotifierProvider<UserProvider>(
                  // lazy: false,
                  create: (BuildContext context) {
                final UserProvider provider = UserProvider(
                    repo: userRepository, psValueHolder: valueHolder);
                //provider.getUserLogin();
                return provider;
              }, child: Consumer<UserProvider>(builder: (BuildContext context,
                      UserProvider provider, Widget child) {
                if (provider == null ||
                    provider.psValueHolder.userIdToVerify == null ||
                    provider.psValueHolder.userIdToVerify == '') {
                  if (provider == null ||
                      provider.psValueHolder == null ||
                      provider.psValueHolder.loginUserId == null ||
                      provider.psValueHolder.loginUserId == '') {
                    return _CallLoginWidget(
                        currentIndex: _currentIndex,
                        animationController: animationController,
                        animation: animation,
                        updateCurrentIndex: (String title, int index) {
                          if (index != null) {
                            updateSelectedIndexWithAnimation(title, index);
                          }
                        },
                        updateUserCurrentIndex:
                            (String title, int index, String userId) {
                          if (index != null) {
                            updateSelectedIndexWithAnimation(title, index);
                          }
                          if (userId != null) {
                            _userId = userId;
                            provider.psValueHolder.loginUserId = userId;
                          }
                        });
                  } else {
                    return ProfileView(
                      scaffoldKey: scaffoldKey,
                      animationController: animationController,
                      flag: _currentIndex,
                    );
                  }
                } else {
                  return Container();
                }
                // else {
                //   return _CallVerifyEmailWidget(
                //       animationController: animationController,
                //       animation: animation,
                //       currentIndex: _currentIndex,
                //       userId: _userId,
                //       updateCurrentIndex: (String title, int index) {
                //         updateSelectedIndexWithAnimation(title, index);
                //       },
                //       updateUserCurrentIndex:
                //           (String title, int index, String userId) async {
                //         if (userId != null) {
                //           _userId = userId;
                //           provider.psValueHolder.loginUserId = userId;
                //         }
                //         setState(() {
                //           appBarTitle = title;
                //           _currentIndex = index;
                //         });
                //       });
                // }
              }));
            }
            if (_currentIndex ==
                AppConst.REQUEST_CODE__DASHBOARD_SEARCH_FRAGMENT) {
              // 2nd Way
              //SearchProductProvider searchProductProvider;

              return CustomScrollView(
                scrollDirection: Axis.vertical,
                slivers: <Widget>[
                  HomeItemSearchView(
                      animationController: animationController,
                      animation: animation,
                      productParameterHolder:
                          ProductParameterHolder().getLatestParameterHolder())
                ],
              );
              // } else if (_currentIndex ==
              //         AppConst.REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT ||
              //     _currentIndex ==
              //         AppConst.REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT) {
              //   return Stack(children: <Widget>[
              //     Container(
              //       color: AppColors.mainLightColorWithBlack,
              //       width: double.infinity,
              //       height: double.maxFinite,
              //     ),
              //     CustomScrollView(
              //         scrollDirection: Axis.vertical,
              //         slivers: <Widget>[
              //           PhoneSignInView(
              //               animationController: animationController,
              //               goToLoginSelected: () {
              //                 animationController
              //                     .reverse()
              //                     .then<dynamic>((void data) {
              //                   if (!mounted) {
              //                     return;
              //                   }
              //                   if (_currentIndex ==
              //                       AppConst
              //                           .REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT) {
              //                     updateSelectedIndexWithAnimation(
              //                         Utils.getString('home_login'),
              //                         AppConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT);
              //                   }
              //                   if (_currentIndex ==
              //                       AppConst
              //                           .REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT) {
              //                     updateSelectedIndexWithAnimation(
              //                         Utils.getString('home_login'),
              //                         AppConst
              //                             .REQUEST_CODE__DASHBOARD_LOGIN_FRAGMENT);
              //                   }
              //                 });
              //               },
              //               phoneSignInSelected:
              //                   (String name, String phoneNo, String verifyId) {
              //                 phoneUserName = name;
              //                 phoneNumber = phoneNo;
              //                 phoneId = verifyId;
              //                 if (_currentIndex ==
              //                     AppConst
              //                         .REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT) {
              //                   updateSelectedIndexWithAnimation(
              //                       Utils.getString('home_verify_phone'),
              //                       AppConst
              //                           .REQUEST_CODE__MENU_PHONE_VERIFY_FRAGMENT);
              //                 } else if (_currentIndex ==
              //                     AppConst
              //                         .REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT) {
              //                   updateSelectedIndexWithAnimation(
              //                       Utils.getString('home_verify_phone'),
              //                       AppConst
              //                           .REQUEST_CODE__DASHBOARD_PHONE_VERIFY_FRAGMENT);
              //                 } else {
              //                   updateSelectedIndexWithAnimation(
              //                       Utils.getString('home_verify_phone'),
              //                       AppConst
              //                           .REQUEST_CODE__DASHBOARD_PHONE_VERIFY_FRAGMENT);
              //                 }
              //               })
              //         ])
              //   ]);
              // } else if (_currentIndex ==
              //         AppConst.REQUEST_CODE__DASHBOARD_PHONE_VERIFY_FRAGMENT ||
              //     _currentIndex ==
              //         AppConst.REQUEST_CODE__MENU_PHONE_VERIFY_FRAGMENT) {
              //   return _CallVerifyPhoneWidget(
              //       userName: phoneUserName,
              //       phoneNumber: phoneNumber,
              //       phoneId: phoneId,
              //       animationController: animationController,
              //       animation: animation,
              //       currentIndex: _currentIndex,
              //       updateCurrentIndex: (String title, int index) {
              //         updateSelectedIndexWithAnimation(title, index);
              //       },
              //       updateUserCurrentIndex:
              //           (String title, int index, String userId) async {
              //         if (userId != null) {
              //           _userId = userId;
              //         }
              //         setState(() {
              //           appBarTitle = title;
              //           _currentIndex = index;
              //         });
              //       });
            } else if (_currentIndex ==
                    AppConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT ||
                _currentIndex ==
                    AppConst.REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT) {
              return ProfileView(
                scaffoldKey: scaffoldKey,
                animationController: animationController,
                flag: _currentIndex,
                userId: _userId,
              );
            } else if (_currentIndex ==
                AppConst.REQUEST_CODE__MENU_CATEGORY_FRAGMENT) {
              return CategoryListView();
            } else if (_currentIndex ==
                AppConst.REQUEST_CODE__MENU_LATEST_PRODUCT_FRAGMENT) {
              return ProductListWithFilterView(
                key: const Key('1'),
                animationController: animationController,
                productParameterHolder:
                    ProductParameterHolder().getLatestParameterHolder(),
              );
            } else if (_currentIndex ==
                AppConst.REQUEST_CODE__MENU_DISCOUNT_PRODUCT_FRAGMENT) {
              return ProductListWithFilterView(
                key: const Key('2'),
                animationController: animationController,
                productParameterHolder:
                    ProductParameterHolder().getDiscountParameterHolder(),
              );
            } else if (_currentIndex ==
                AppConst.REQUEST_CODE__MENU_TRENDING_PRODUCT_FRAGMENT) {
              return ProductListWithFilterView(
                key: const Key('3'),
                animationController: animationController,
                productParameterHolder:
                    ProductParameterHolder().getTrendingParameterHolder(),
              );
            } else if (_currentIndex ==
                AppConst.REQUEST_CODE__MENU_FEATURED_PRODUCT_FRAGMENT) {
              return ProductListWithFilterView(
                key: const Key('4'),
                animationController: animationController,
                productParameterHolder:
                    ProductParameterHolder().getFeaturedParameterHolder(),
              );
            } else if (_currentIndex ==
                    AppConst.REQUEST_CODE__DASHBOARD_FORGOT_PASSWORD_FRAGMENT ||
                _currentIndex ==
                    AppConst.REQUEST_CODE__MENU_FORGOT_PASSWORD_FRAGMENT) {
              return Stack(children: <Widget>[
                Container(
                  color: AppColors.mainLightColorWithBlack,
                  width: double.infinity,
                  height: double.maxFinite,
                ),
                CustomScrollView(
                    scrollDirection: Axis.vertical,
                    slivers: <Widget>[
                      ForgotPasswordView(
                        animationController: animationController,
                        goToLoginSelected: () {
                          animationController
                              .reverse()
                              .then<dynamic>((void data) {
                            if (!mounted) {
                              return;
                            }
                            if (_currentIndex ==
                                AppConst
                                    .REQUEST_CODE__MENU_FORGOT_PASSWORD_FRAGMENT) {
                              updateSelectedIndexWithAnimation(
                                  Utils.getString('home_login'),
                                  AppConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT);
                            }
                            if (_currentIndex ==
                                AppConst
                                    .REQUEST_CODE__DASHBOARD_FORGOT_PASSWORD_FRAGMENT) {
                              updateSelectedIndexWithAnimation(
                                  Utils.getString('home_login'),
                                  AppConst
                                      .REQUEST_CODE__DASHBOARD_LOGIN_FRAGMENT);
                            }
                          });
                        },
                      )
                    ])
              ]);
            } else if (_currentIndex ==
                    AppConst.REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT ||
                _currentIndex ==
                    AppConst.REQUEST_CODE__MENU_REGISTER_FRAGMENT) {
              return Stack(children: <Widget>[
                Container(
                  color: AppColors.mainLightColorWithBlack,
                  width: double.infinity,
                  height: double.maxFinite,
                ),
                CustomScrollView(
                    scrollDirection: Axis.vertical,
                    slivers: <Widget>[
                      RegisterView(
                          animationController: animationController,
                          onRegisterSelected: (User user) {
                            _userId = user.userId;
                            // widget.provider.psValueHolder.loginUserId = userId;
                            if (user.status == AppConst.ONE) {
                              updateSelectedIndexWithAnimationUserId(
                                  Utils.getString('home__menu_drawer_profile'),
                                  AppConst
                                      .REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT,
                                  user.userId);
                            } else {
                              // if (_currentIndex ==
                              //     AppConst.REQUEST_CODE__MENU_REGISTER_FRAGMENT) {
                              //   updateSelectedIndexWithAnimation(
                              //       Utils.getString('home__verify_email'),
                              //       AppConst
                              //           .REQUEST_CODE__MENU_VERIFY_EMAIL_FRAGMENT);
                              // } else if (_currentIndex ==
                              //     AppConst
                              //         .REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT) {
                              //   updateSelectedIndexWithAnimation(
                              //       Utils.getString('home__verify_email'),
                              //       AppConst
                              //           .REQUEST_CODE__DASHBOARD_VERIFY_EMAIL_FRAGMENT);
                              // } else {
                              updateSelectedIndexWithAnimationUserId(
                                  Utils.getString('home__menu_drawer_profile'),
                                  AppConst
                                      .REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT,
                                  user.userId);
                              // }
                            }
                          },
                          goToLoginSelected: () {
                            animationController
                                .reverse()
                                .then<dynamic>((void data) {
                              if (!mounted) {
                                return;
                              }
                              if (_currentIndex ==
                                  AppConst
                                      .REQUEST_CODE__MENU_REGISTER_FRAGMENT) {
                                updateSelectedIndexWithAnimation(
                                    Utils.getString('home_login'),
                                    AppConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT);
                              }
                              if (_currentIndex ==
                                  AppConst
                                      .REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT) {
                                updateSelectedIndexWithAnimation(
                                    Utils.getString('home_login'),
                                    AppConst
                                        .REQUEST_CODE__DASHBOARD_LOGIN_FRAGMENT);
                              }
                            });
                          })
                    ])
              ]);
              // } else if (_currentIndex ==
              //         AppConst.REQUEST_CODE__DASHBOARD_VERIFY_EMAIL_FRAGMENT ||
              //     _currentIndex ==
              //         AppConst.REQUEST_CODE__MENU_VERIFY_EMAIL_FRAGMENT) {
              //   return _CallVerifyEmailWidget(
              //       animationController: animationController,
              //       animation: animation,
              //       currentIndex: _currentIndex,
              //       userId: _userId,
              //       updateCurrentIndex: (String title, int index) {
              //         updateSelectedIndexWithAnimation(title, index);
              //       },
              //       updateUserCurrentIndex:
              //           (String title, int index, String userId) async {
              //         if (userId != null) {
              //           _userId = userId;
              //         }
              //         setState(() {
              //           appBarTitle = title;
              //           _currentIndex = index;
              //         });
              //       });
            } else if (_currentIndex ==
                    AppConst.REQUEST_CODE__DASHBOARD_LOGIN_FRAGMENT ||
                _currentIndex == AppConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT) {
              return _CallLoginWidget(
                  currentIndex: _currentIndex,
                  animationController: animationController,
                  animation: animation,
                  updateCurrentIndex: (String title, int index) {
                    updateSelectedIndexWithAnimation(title, index);
                  },
                  updateUserCurrentIndex:
                      (String title, int index, String userId) {
                    setState(() {
                      if (index != null) {
                        appBarTitle = title;
                        _currentIndex = index;
                      }
                    });
                    if (userId != null) {
                      _userId = userId;
                    }
                  });
            } else if (_currentIndex ==
                AppConst.REQUEST_CODE__MENU_SELECT_WHICH_USER_FRAGMENT) {
              return ChangeNotifierProvider<UserProvider>(
                  lazy: false,
                  create: (BuildContext context) {
                    final UserProvider provider = UserProvider(
                        repo: userRepository, psValueHolder: valueHolder);

                    return provider;
                  },
                  child: Consumer<UserProvider>(builder: (BuildContext context,
                      UserProvider provider, Widget child) {
                    if (provider == null ||
                        provider.psValueHolder.userIdToVerify == null ||
                        provider.psValueHolder.userIdToVerify == '') {
                      if (provider == null ||
                          provider.psValueHolder == null ||
                          provider.psValueHolder.loginUserId == null ||
                          provider.psValueHolder.loginUserId == '') {
                        return Stack(
                          children: <Widget>[
                            Container(
                              color: AppColors.mainLightColorWithBlack,
                              width: double.infinity,
                              height: double.maxFinite,
                            ),
                            CustomScrollView(
                                scrollDirection: Axis.vertical,
                                slivers: <Widget>[
                                  LoginView(
                                    animationController: animationController,
                                    animation: animation,
                                    onGoogleSignInSelected: (String userId) {
                                      setState(() {
                                        _currentIndex = AppConst
                                            .REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT;
                                      });
                                      _userId = userId;
                                      provider.psValueHolder.loginUserId =
                                          userId;
                                    },
                                    onFbSignInSelected: (String userId) {
                                      setState(() {
                                        _currentIndex = AppConst
                                            .REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT;
                                      });
                                      _userId = userId;
                                      provider.psValueHolder.loginUserId =
                                          userId;
                                    },
                                    onPhoneSignInSelected: () {
                                      if (_currentIndex ==
                                          AppConst
                                              .REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT) {
                                        updateSelectedIndexWithAnimation(
                                            Utils.getString(
                                                'home_phone_signin'),
                                            AppConst
                                                .REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT);
                                      } else if (_currentIndex ==
                                          AppConst
                                              .REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT) {
                                        updateSelectedIndexWithAnimation(
                                            Utils.getString(
                                                'home_phone_signin'),
                                            AppConst
                                                .REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT);
                                      } else if (_currentIndex ==
                                          AppConst
                                              .REQUEST_CODE__MENU_SELECT_WHICH_USER_FRAGMENT) {
                                        updateSelectedIndexWithAnimation(
                                            Utils.getString(
                                                'home_phone_signin'),
                                            AppConst
                                                .REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT);
                                      } else if (_currentIndex ==
                                          AppConst
                                              .REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT) {
                                        updateSelectedIndexWithAnimation(
                                            Utils.getString(
                                                'home_phone_signin'),
                                            AppConst
                                                .REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT);
                                      } else {
                                        updateSelectedIndexWithAnimation(
                                            Utils.getString(
                                                'home_phone_signin'),
                                            AppConst
                                                .REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT);
                                      }
                                    },
                                    onProfileSelected: (String userId) {
                                      setState(() {
                                        _currentIndex = AppConst
                                            .REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT;
                                        _userId = userId;
                                        provider.psValueHolder.loginUserId =
                                            userId;
                                      });
                                    },
                                    onForgotPasswordSelected: () {
                                      setState(() {
                                        _currentIndex = AppConst
                                            .REQUEST_CODE__MENU_FORGOT_PASSWORD_FRAGMENT;
                                        appBarTitle = Utils.getString(
                                            'home__forgot_password');
                                      });
                                    },
                                    onSignInSelected: () {
                                      updateSelectedIndexWithAnimation(
                                          Utils.getString('home__register'),
                                          AppConst
                                              .REQUEST_CODE__MENU_REGISTER_FRAGMENT);
                                    },
                                  ),
                                ])
                          ],
                        );
                      } else {
                        return ProfileView(
                          scaffoldKey: scaffoldKey,
                          animationController: animationController,
                          flag: _currentIndex,
                        );
                      }
                    } else {
                      return Container();
                      // return _CallVerifyEmailWidget(
                      //     animationController: animationController,
                      //     animation: animation,
                      //     currentIndex: _currentIndex,
                      //     userId: _userId,
                      //     updateCurrentIndex: (String title, int index) {
                      //       updateSelectedIndexWithAnimation(title, index);
                      //     },
                      //     updateUserCurrentIndex:
                      //         (String title, int index, String userId) async {
                      //       if (userId != null) {
                      //         _userId = userId;
                      //         provider.psValueHolder.loginUserId = userId;
                      //       }
                      //       setState(() {
                      //         appBarTitle = title;
                      //         _currentIndex = index;
                      //       });
                      //     });
                    }
                  }));
              // } else if (_currentIndex ==
              //     AppConst.REQUEST_CODE__MENU_FAVOURITE_FRAGMENT) {
              //   return HistoryListView(animationController: animationController)(
              //       animationController: animationController);
            } else if (_currentIndex ==
                AppConst.REQUEST_CODE__MENU_TRANSACTION_FRAGMENT) {
              return TransactionListView(
                  scaffoldKey: scaffoldKey,
                  animationController: animationController);
            } else if (_currentIndex ==
                AppConst.REQUEST_CODE__MENU_FAVOURITE_FRAGMENT) {
              return HistoryListView(animationController: animationController);
              // } else if (_currentIndex ==
              //     AppConst.REQUEST_CODE__MENU_FAVOURITE_FRAGMENT) {
              //   return CollectionHeaderListView(
              //       animationController: animationController);
            } else if (_currentIndex ==
                AppConst.REQUEST_CODE__MENU_LANGUAGE_FRAGMENT) {
              return LanguageView();
            } else if (_currentIndex ==
                AppConst.REQUEST_CODE__MENU_CONTACT_US_FRAGMENT) {
              return ContactUsView(animationController: animationController);
            } else if (_currentIndex ==
                AppConst.REQUEST_CODE__MENU_SETTING_FRAGMENT) {
              return Container(
                color: AppColors.coreBackgroundColor,
                height: double.infinity,
                child: SettingView(
                  animationController: animationController,
                ),
              );
              // } else if (_currentIndex ==
              //     AppConst.REQUEST_CODE__MENU_TERMS_AND_CONDITION_FRAGMENT) {
              //   return PrivacyPolicyView(
              //     animationController: animationController,
              //   );
              // } else if (_currentIndex ==
              //     AppConst.REQUEST_CODE__DASHBOARD_BASKET_FRAGMENT) {
              //   return BasketListView(
              //     animationController: animationController,
              //   );
            } else {
              animationController.forward();
              return HomeDashboardView(
                animationController,
                context,
              );
            }
          },
        ),
      ),
    );
  }
}

class _CallLoginWidget extends StatelessWidget {
  const _CallLoginWidget(
      {@required this.animationController,
      @required this.animation,
      @required this.updateCurrentIndex,
      @required this.updateUserCurrentIndex,
      @required this.currentIndex});
  final Function updateCurrentIndex;
  final Function updateUserCurrentIndex;
  final AnimationController animationController;
  final Animation<double> animation;
  final int currentIndex;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          color: AppColors
              .mainLightColorWithBlack, //ps_wtheme_core_background_color,
          width: double.infinity,
          height: double.maxFinite,
        ),
        CustomScrollView(scrollDirection: Axis.vertical, slivers: <Widget>[
          LoginView(
            animationController: animationController,
            animation: animation,
            onGoogleSignInSelected: (String userId) {
              if (currentIndex == AppConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT) {
                updateUserCurrentIndex(
                    Utils.getString('home__menu_drawer_profile'),
                    AppConst.REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT,
                    userId);
              } else {
                updateUserCurrentIndex(
                    Utils.getString('home__menu_drawer_profile'),
                    AppConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT,
                    userId);
              }
            },
            onFbSignInSelected: (String userId) {
              if (currentIndex == AppConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT) {
                updateUserCurrentIndex(
                    Utils.getString('home__menu_drawer_profile'),
                    AppConst.REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT,
                    userId);
              } else {
                updateUserCurrentIndex(
                    Utils.getString('home__menu_drawer_profile'),
                    AppConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT,
                    userId);
              }
            },
            onPhoneSignInSelected: () {
              if (currentIndex == AppConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT) {
                updateCurrentIndex(Utils.getString('home_phone_signin'),
                    AppConst.REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT);
              } else if (currentIndex ==
                  AppConst.REQUEST_CODE__DASHBOARD_LOGIN_FRAGMENT) {
                updateCurrentIndex(Utils.getString('home_phone_signin'),
                    AppConst.REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT);
              } else if (currentIndex ==
                  AppConst.REQUEST_CODE__MENU_SELECT_WHICH_USER_FRAGMENT) {
                updateCurrentIndex(Utils.getString('home_phone_signin'),
                    AppConst.REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT);
              } else if (currentIndex ==
                  AppConst.REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT) {
                updateCurrentIndex(Utils.getString('home_phone_signin'),
                    AppConst.REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT);
              } else {
                updateCurrentIndex(Utils.getString('home_phone_signin'),
                    AppConst.REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT);
              }
            },
            onProfileSelected: (String userId) {
              if (currentIndex == AppConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT) {
                updateUserCurrentIndex(
                    Utils.getString('home__menu_drawer_profile'),
                    AppConst.REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT,
                    userId);
              } else {
                updateUserCurrentIndex(
                    Utils.getString('home__menu_drawer_profile'),
                    AppConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT,
                    userId);
              }
            },
            onForgotPasswordSelected: () {
              if (currentIndex == AppConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT) {
                updateCurrentIndex(Utils.getString('home__forgot_password'),
                    AppConst.REQUEST_CODE__MENU_FORGOT_PASSWORD_FRAGMENT);
              } else {
                updateCurrentIndex(Utils.getString('home__forgot_password'),
                    AppConst.REQUEST_CODE__DASHBOARD_FORGOT_PASSWORD_FRAGMENT);
              }
            },
            onSignInSelected: () {
              if (currentIndex == AppConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT) {
                updateCurrentIndex(Utils.getString('home__register'),
                    AppConst.REQUEST_CODE__MENU_REGISTER_FRAGMENT);
              } else {
                updateCurrentIndex(Utils.getString('home__register'),
                    AppConst.REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT);
              }
            },
          ),
        ])
      ],
    );
  }
}

// class _CallVerifyPhoneWidget extends StatelessWidget {
//   const _CallVerifyPhoneWidget(
//       {this.userName,
//       this.phoneNumber,
//       this.phoneId,
//       @required this.updateCurrentIndex,
//       @required this.updateUserCurrentIndex,
//       @required this.animationController,
//       @required this.animation,
//       @required this.currentIndex});

//   final String userName;
//   final String phoneNumber;
//   final String phoneId;
//   final Function updateCurrentIndex;
//   final Function updateUserCurrentIndex;
//   final int currentIndex;
//   final AnimationController animationController;
//   final Animation<double> animation;

//   @override
//   Widget build(BuildContext context) {
//     animationController.forward();
//     return SingleChildScrollView(
//         scrollDirection: Axis.vertical,
//         child: VerifyPhoneView(
//           userName: userName,
//           phoneNumber: phoneNumber,
//           phoneId: phoneId,
//           animationController: animationController,
//           onProfileSelected: (String userId) {
//             if (currentIndex ==
//                 AppConst.REQUEST_CODE__MENU_PHONE_VERIFY_FRAGMENT) {
//               updateUserCurrentIndex(
//                   Utils.getString('home__menu_drawer_profile'),
//                   AppConst.REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT,
//                   userId);
//             } else if (currentIndex ==
//                 AppConst.REQUEST_CODE__DASHBOARD_PHONE_VERIFY_FRAGMENT) {
//               updateUserCurrentIndex(
//                   Utils.getString('home__menu_drawer_profile'),
//                   AppConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT,
//                   userId);
//             } else {
//               updateUserCurrentIndex(
//                   Utils.getString('home__menu_drawer_profile'),
//                   AppConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT,
//                   userId);
//             }
//           },
//           onSignInSelected: () {
//             if (currentIndex ==
//                 AppConst.REQUEST_CODE__MENU_PHONE_VERIFY_FRAGMENT) {
//               updateCurrentIndex(Utils.getString('home_phone_signin'),
//                   AppConst.REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT);
//             } else if (currentIndex ==
//                 AppConst.REQUEST_CODE__DASHBOARD_PHONE_VERIFY_FRAGMENT) {
//               updateCurrentIndex(Utils.getString('home_phone_signin'),
//                   AppConst.REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT);
//             }
//           },
//         ));
//   }
// }

// class _CallVerifyEmailWidget extends StatelessWidget {
//   const _CallVerifyEmailWidget(
//       {@required this.updateCurrentIndex,
//       @required this.updateUserCurrentIndex,
//       @required this.animationController,
//       @required this.animation,
//       @required this.currentIndex,
//       @required this.userId});
//   final Function updateCurrentIndex;
//   final Function updateUserCurrentIndex;
//   final int currentIndex;
//   final AnimationController animationController;
//   final Animation<double> animation;
//   final String userId;

//   @override
//   Widget build(BuildContext context) {
//     animationController.forward();
//     return SingleChildScrollView(
//         scrollDirection: Axis.vertical,
//         child: VerifyEmailView(
//           animationController: animationController,
//           userId: userId,
//           onProfileSelected: (String userId) {
//             if (currentIndex ==
//                 AppConst.REQUEST_CODE__MENU_VERIFY_EMAIL_FRAGMENT) {
//               updateUserCurrentIndex(
//                   Utils.getString('home__menu_drawer_profile'),
//                   AppConst.REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT,
//                   userId);
//             } else if (currentIndex ==
//                 AppConst.REQUEST_CODE__DASHBOARD_VERIFY_EMAIL_FRAGMENT) {
//               updateUserCurrentIndex(
//                   Utils.getString('home__menu_drawer_profile'),
//                   AppConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT,
//                   userId);
//               // updateCurrentIndex(AppConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT);
//             } else {
//               updateUserCurrentIndex(
//                   Utils.getString('home__menu_drawer_profile'),
//                   AppConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT,
//                   userId);
//             }
//           },
//           onSignInSelected: () {
//             if (currentIndex ==
//                 AppConst.REQUEST_CODE__MENU_VERIFY_EMAIL_FRAGMENT) {
//               updateCurrentIndex(Utils.getString('home__register'),
//                   AppConst.REQUEST_CODE__MENU_REGISTER_FRAGMENT);
//             } else if (currentIndex ==
//                 AppConst.REQUEST_CODE__DASHBOARD_VERIFY_EMAIL_FRAGMENT) {
//               updateCurrentIndex(Utils.getString('home__register'),
//                   AppConst.REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT);
//             } else if (currentIndex ==
//                 AppConst.REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT) {
//               updateCurrentIndex(Utils.getString('home__register'),
//                   AppConst.REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT);
//             } else if (currentIndex ==
//                 AppConst.REQUEST_CODE__MENU_SELECT_WHICH_USER_FRAGMENT) {
//               updateCurrentIndex(Utils.getString('home__register'),
//                   AppConst.REQUEST_CODE__MENU_REGISTER_FRAGMENT);
//             }
//           },
//         ));
//   }
// }

class _DrawerMenuWidget extends StatefulWidget {
  const _DrawerMenuWidget({
    Key key,
    @required this.icon,
    @required this.title,
    @required this.onTap,
    @required this.index,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final Function onTap;
  final int index;

  @override
  __DrawerMenuWidgetState createState() => __DrawerMenuWidgetState();
}

class __DrawerMenuWidgetState extends State<_DrawerMenuWidget> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Icon(widget.icon, color: AppColors.mainColorWithWhite),
        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.bodyText2,
        ),
        onTap: () {
          widget.onTap(widget.title, widget.index);
        });
  }
}

class _DrawerHeaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      child: Column(
        children: <Widget>[
          Image.asset(
            'assets/images/app_logo.png',
            width: AppDimens.space100,
            height: AppDimens.space72,
          ),
          const SizedBox(
            height: AppDimens.space8,
          ),
          Text(
            Utils.getString('app_name'),
            style: Theme.of(context)
                .textTheme
                .subtitle1
                .copyWith(color: AppColors.white),
          ),
        ],
      ),
      decoration: BoxDecoration(color: AppColors.mainColor),
    );
  }
}
