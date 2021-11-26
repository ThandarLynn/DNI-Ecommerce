import 'package:dni_ecommerce/db/common/app_shared_preferences.dart';

class AppRepository {
  Future<dynamic> loadValueHolder() async {
    await AppSharedPreferencess.instance.loadValueHolder();
  }

  Future<dynamic> replaceLoginUserId(
      String loginUserId, String userToken) async {
    await AppSharedPreferencess.instance
        .replaceLoginUserId(loginUserId, userToken);
  }

  Future<dynamic> replaceLoginUserName(String loginUserName) async {
    await AppSharedPreferencess.instance.replaceLoginUserName(
      loginUserName,
    );
  }

  Future<dynamic> replaceNotiToken(String notiToken) async {
    await AppSharedPreferencess.instance.replaceNotiToken(
      notiToken,
    );
  }

  Future<dynamic> replaceNotiSetting(bool notiSetting) async {
    await AppSharedPreferencess.instance.replaceNotiSetting(
      notiSetting,
    );
  }

  Future<dynamic> replaceIsToShowIntroSlider(bool doNotShowAgain) async {
    await AppSharedPreferencess.instance.replaceIsToShowIntroSlider(
      doNotShowAgain,
    );
  }

  Future<dynamic> replaceDate(String startDate, String endDate) async {
    await AppSharedPreferencess.instance.replaceDate(startDate, endDate);
  }

  Future<dynamic> replaceVerifyUserData(
      String userIdToVerify,
      String userNameToVerify,
      String userEmailToVerify,
      String userPasswordToVerify) async {
    await AppSharedPreferencess.instance.replaceVerifyUserData(userIdToVerify,
        userNameToVerify, userEmailToVerify, userPasswordToVerify);
  }

  Future<dynamic> replaceVersionForceUpdateData(bool appInfoForceUpdate) async {
    await AppSharedPreferencess.instance.replaceVersionForceUpdateData(
      appInfoForceUpdate,
    );
  }

  Future<dynamic> replaceAppInfoData(
      String appInfoVersionNo,
      bool appInfoForceUpdate,
      String appInfoForceUpdateTitle,
      String appInfoForceUpdateMsg) async {
    await AppSharedPreferencess.instance.replaceAppInfoData(appInfoVersionNo,
        appInfoForceUpdate, appInfoForceUpdateTitle, appInfoForceUpdateMsg);
  }

  Future<dynamic> replaceShopInfoValueHolderData(
    String overAllTaxLabel,
    String overAllTaxValue,
    String shippingTaxLabel,
    String shippingTaxValue,
    String shippingId,
    String shopId,
    String messenger,
    String whatsApp,
    String phone,
  ) async {
    await AppSharedPreferencess.instance.replaceShopInfoValueHolderData(
        overAllTaxLabel,
        overAllTaxValue,
        shippingTaxLabel,
        shippingTaxValue,
        shippingId,
        shopId,
        messenger,
        whatsApp,
        phone);
  }

  Future<dynamic> replaceCheckoutEnable(
      String paypalEnabled,
      String stripeEnabled,
      String codEnabled,
      String bankEnabled,
      String standardShippingEnable,
      String zoneShippingEnable,
      String noShippingEnable) async {
    await AppSharedPreferencess.instance.replaceCheckoutEnable(
        paypalEnabled,
        stripeEnabled,
        codEnabled,
        bankEnabled,
        standardShippingEnable,
        zoneShippingEnable,
        noShippingEnable);
  }

  Future<dynamic> replacePublishKey(String pubKey) async {
    await AppSharedPreferencess.instance.replacePublishKey(pubKey);
  }

  Future<dynamic> replacePayStackKey(String payStackKey) async {
    await AppSharedPreferencess.instance.replacePayStackKey(payStackKey);
  }
}
