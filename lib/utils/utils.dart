import 'dart:collection';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:dni_ecommerce/api/common/app_resource.dart';
import 'package:dni_ecommerce/config/app_config.dart';
import 'package:dni_ecommerce/constant/app_constant.dart';
import 'package:dni_ecommerce/constant/route_paths.dart';
import 'package:dni_ecommerce/viewobject/common/app_object.dart';
import 'package:dni_ecommerce/viewobject/common/app_value_holder.dart';
import 'package:dni_ecommerce/viewobject/user.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  Utils._();

  static int isAppleSignInAvailable = 0;
  static Future<void> checkAppleSignInAvailable() async {
    final bool _isAvailable = await TheAppleSignIn.isAvailable();

    isAppleSignInAvailable = _isAvailable ? 1 : 2;
  }

  static dynamic launchAppStoreURL(
      {String iOSAppId, bool writeReview = false}) async {
    LaunchReview.launch(writeReview: writeReview, iOSAppId: iOSAppId);
  }

  static String calculateDiscountPercent(
      String originalPrice, String unitPrice) {
    final NumberFormat dataformat = NumberFormat('###.0');
    final double discountPrice =
        (double.parse(originalPrice) - double.parse(unitPrice)) / 100;
    return dataformat.format(discountPrice);
  }

  static dynamic launchURL() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    print(packageInfo.packageName);
    final String url =
        'https://play.google.com/store/apps/details?id=${packageInfo.packageName}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static dynamic getAdAppId() {
    if (Platform.isIOS) {
      return AppConfig.iosAdMobAdsIdKey;
    } else {
      return AppConfig.androidAdMobAdsIdKey;
    }
  }

  static String getString(String key) {
    if (key != '') {
      return tr(key) ?? '';
    } else {
      return '';
    }
  }

  static bool isLightMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light;
  }

  static Future<bool> checkInternetConnectivity() async {
    final ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else if (connectivityResult == ConnectivityResult.none) {
      print('No Connection');
      return false;
    } else {
      return false;
    }
  }

  static AppResource<List<T>> removeDuplicateObj<T>(
      AppResource<List<T>> resource) {
    final Map<String, String> _keyMap = HashMap<String, String>();
    final List<T> _tmpDataList = <T>[];

    if (resource != null && resource.data != null) {
      for (T obj in resource.data) {
        if (obj is AppObject) {
          final String _primaryKey = obj.getPrimaryKey();

          if (!_keyMap.containsKey(_primaryKey)) {
            _keyMap[_primaryKey] = _primaryKey;
            _tmpDataList.add(obj);
          }
        }
      }
    }

    resource.data = _tmpDataList;

    return resource;
  }

  static String getPriceFormat(String price) {
    return AppConst.numberFormat.format(double.parse(price));
  }

  static Widget flightShuttleBuilder(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    return DefaultTextStyle(
      style: DefaultTextStyle.of(toHeroContext).style,
      child: toHeroContext.widget,
    );
  }

  static Brightness getBrightnessForAppBar(BuildContext context) {
    if (Platform.isAndroid) {
      return Brightness.dark;
    } else {
      return Theme.of(context).brightness;
    }
  }

  static bool checkEmailFormat(String email) {
    bool emailFormat;
    if (email != '') {
      emailFormat = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(email);
    }
    return emailFormat;
  }

  static String getDateFormat(String dateTime) {
    final DateTime date = DateTime.parse(dateTime);
    return DateFormat(AppConfig.dateFormat).format(date);
  }

  static String getPriceTwoDecimal(String price) {
    return AppConst.priceTwoDecimalFormat.format(double.parse(price));
  }

  static String checkUserLoginId(AppValueHolder appValueHolder) {
    if (appValueHolder.loginUserId == null ||
        appValueHolder.loginUserId == '') {
      return 'nologinuser';
    } else {
      return appValueHolder.loginUserId;
    }
  }

  static dynamic navigateOnUserVerificationView(
      BuildContext context, Function onLoginSuccess) async {
    AppValueHolder appValueHolder =
        Provider.of<AppValueHolder>(context, listen: false);

    // if (appValueHolder == null ||
    //     appValueHolder.userIdToVerify == null ||
    //     appValueHolder.userIdToVerify == '') {
    if (appValueHolder == null ||
        appValueHolder == null ||
        appValueHolder.loginUserId == null ||
        appValueHolder.loginUserId == '') {
      final dynamic returnData = await Navigator.pushNamed(
        context,
        RoutePaths.login_container,
      );

      if (returnData != null && returnData is User) {
        final User user = returnData;
        appValueHolder = Provider.of<AppValueHolder>(context, listen: false);
        appValueHolder.loginUserId = user.userId;
      }
    } else {
      onLoginSuccess();
    }
    // } else {
    //   Navigator.pushNamed(context, RoutePaths.user_verify_email_container,
    //       arguments: appValueHolder.userIdToVerify);
    // }
  }
}
