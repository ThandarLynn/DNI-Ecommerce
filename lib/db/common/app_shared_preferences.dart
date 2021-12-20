import 'dart:async';
import 'package:dni_ecommerce/constant/app_constant.dart';
import 'package:dni_ecommerce/viewobject/common/app_value_holder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPreferencess {
  AppSharedPreferencess._() {
    print('init PsSharePerference $hashCode');
    futureShared = SharedPreferences.getInstance();
    futureShared.then((SharedPreferences shared) {
      this.shared = shared;
      //loadUserId('Admin');
      loadValueHolder();
    });
  }

  Future<SharedPreferences> futureShared;
  SharedPreferences shared;

// Singleton instance
  static final AppSharedPreferencess _singleton = AppSharedPreferencess._();

  // Singleton accessor
  static AppSharedPreferencess get instance => _singleton;

  final StreamController<AppValueHolder> _valueController =
      StreamController<AppValueHolder>();
  Stream<AppValueHolder> get appValueHolder => _valueController.stream;

  Future<dynamic> loadValueHolder() async {
    final String _loginUserId =
        shared.getString(AppConst.VALUE_HOLDER__USER_ID);
    final String _userToken =
        shared.getString(AppConst.VALUE_HOLDER__USER_TOKEN);
    final String _languageName =
        shared.getString(AppConst.LANGUAGE__LANGUAGE_NAME_KEY);
    final String _loginUserName =
        shared.getString(AppConst.VALUE_HOLDER__USER_NAME);
    final String _userIdToVerify =
        shared.getString(AppConst.VALUE_HOLDER__USER_ID_TO_VERIFY);
    final String _userNameToVerify =
        shared.getString(AppConst.VALUE_HOLDER__USER_NAME_TO_VERIFY);
    final String _userEmailToVerify =
        shared.getString(AppConst.VALUE_HOLDER__USER_EMAIL_TO_VERIFY);
    final String _userPasswordToVerify =
        shared.getString(AppConst.VALUE_HOLDER__USER_PASSWORD_TO_VERIFY);
    final String _notiToken =
        shared.getString(AppConst.VALUE_HOLDER__NOTI_TOKEN);
    final bool _notiSetting =
        shared.getBool(AppConst.VALUE_HOLDER__NOTI_SETTING);
    final bool _isToShowIntroSlider =
        shared.getBool(AppConst.VALUE_HOLDER__SHOW_INTRO_SLIDER) ?? true;
    final String _overAllTaxLabel =
        shared.getString(AppConst.VALUE_HOLDER__OVERALL_TAX_LABEL) ?? '3';
    final String _overAllTaxValue =
        shared.getString(AppConst.VALUE_HOLDER__OVERALL_TAX_VALUE) ??'0.03';
    final String _shippingTaxLabel =
        shared.getString(AppConst.VALUE_HOLDER__SHIPPING_TAX_LABEL) ??'7';
    final String _shippingTaxValue =
        shared.getString(AppConst.VALUE_HOLDER__SHIPPING_TAX_VALUE)?? '0.07';
    final String _shippingId =
        shared.getString(AppConst.VALUE_HOLDER__SHIPPING_ID);
    final String _shopId = shared.getString(AppConst.VALUE_HOLDER__SHOP_ID);
    final String _messenger =
        shared.getString(AppConst.VALUE_HOLDER__MESSENGER);
    final String _whatsApp = shared.getString(AppConst.VALUE_HOLDER__WHATSAPP);
    final String _phone = shared.getString(AppConst.VALUE_HOLDER__PHONE);
    final String _appInfoVersionNo =
        shared.getString(AppConst.APPINFO_PREF_VERSION_NO);
    final bool _appInfoForceUpdate =
        shared.getBool(AppConst.APPINFO_PREF_FORCE_UPDATE);
    final String _appInfoForceUpdateTitle =
        shared.getString(AppConst.APPINFO_FORCE_UPDATE_TITLE);
    final String _appInfoForceUpdateMsg =
        shared.getString(AppConst.APPINFO_FORCE_UPDATE_MSG);
    final String _startDate =
        shared.getString(AppConst.VALUE_HOLDER__START_DATE);
    final String _endDate = shared.getString(AppConst.VALUE_HOLDER__END_DATE);

    final String _paypalEnabled =
        shared.getString(AppConst.VALUE_HOLDER__PAYPAL_ENABLED);
    final String _stripeEnabled =
        shared.getString(AppConst.VALUE_HOLDER__STRIPE_ENABLED);
    final String _codEnabled =
        shared.getString(AppConst.VALUE_HOLDER__COD_ENABLED);
    final String _bankEnabled =
        shared.getString(AppConst.VALUE_HOLDER__BANK_TRANSFER_ENABLE);
    final String _publishKey =
        shared.getString(AppConst.VALUE_HOLDER__PUBLISH_KEY);
    final String _payStackKey =
        shared.getString(AppConst.VALUE_HOLDER__PAYSTACK_KEY);
    final String _standardShippingEnable =
        shared.getString(AppConst.VALUE_HOLDER__STANDART_SHIPPING_ENABLE);
    final String _zoneShippingEnable =
        shared.getString(AppConst.VALUE_HOLDER__ZONE_SHIPPING_ENABLE);
    final String _noShippingEnable =
        shared.getString(AppConst.VALUE_HOLDER__NO_SHIPPING_ENABLE);
    final AppValueHolder _valueHolder = AppValueHolder(
        loginUserId: _loginUserId,
        userToken: _userToken,
        languageName: _languageName,
        loginUserName: _loginUserName,
        userIdToVerify: _userIdToVerify,
        userNameToVerify: _userNameToVerify,
        userEmailToVerify: _userEmailToVerify,
        userPasswordToVerify: _userPasswordToVerify,
        deviceToken: _notiToken,
        notiSetting: _notiSetting,
        isToShowIntroSlider: _isToShowIntroSlider,
        overAllTaxLabel: _overAllTaxLabel,
        overAllTaxValue: _overAllTaxValue,
        shippingTaxLabel: _shippingTaxLabel,
        shippingTaxValue: _shippingTaxValue,
        shopId: _shopId,
        messenger: _messenger,
        whatsApp: _whatsApp,
        phone: _phone,
        appInfoVersionNo: _appInfoVersionNo,
        appInfoForceUpdate: _appInfoForceUpdate,
        appInfoForceUpdateTitle: _appInfoForceUpdateTitle,
        appInfoForceUpdateMsg: _appInfoForceUpdateMsg,
        startDate: _startDate,
        endDate: _endDate,
        paypalEnabled: _paypalEnabled,
        stripeEnabled: _stripeEnabled,
        codEnabled: _codEnabled,
        bankEnabled: _bankEnabled,
        publishKey: _publishKey,
        payStackKey: _payStackKey,
        shippingId: _shippingId,
        standardShippingEnable: _standardShippingEnable,
        zoneShippingEnable: _zoneShippingEnable,
        noShippingEnable: _noShippingEnable);

    _valueController.add(_valueHolder);
  }

  Future<dynamic> replaceLoginUserId(
      String loginUserId, String userToken) async {
    await shared.setString(AppConst.VALUE_HOLDER__USER_ID, loginUserId);
    await shared.setString(AppConst.VALUE_HOLDER__USER_TOKEN, userToken);

    loadValueHolder();
  }

  Future<dynamic> replaceLoginUserName(String loginUserName) async {
    await shared.setString(AppConst.VALUE_HOLDER__USER_NAME, loginUserName);

    loadValueHolder();
  }

  Future<dynamic> replaceNotiToken(String notiToken) async {
    await shared.setString(AppConst.VALUE_HOLDER__NOTI_TOKEN, notiToken);

    loadValueHolder();
  }

  Future<dynamic> replaceNotiSetting(bool notiSetting) async {
    await shared.setBool(AppConst.VALUE_HOLDER__NOTI_SETTING, notiSetting);

    loadValueHolder();
  }

  Future<dynamic> replaceIsToShowIntroSlider(bool doNotShowAgain) async {
    await shared.setBool(
        AppConst.VALUE_HOLDER__SHOW_INTRO_SLIDER, doNotShowAgain);

    loadValueHolder();
  }

  Future<dynamic> replaceNotiMessage(String message) async {
    await shared.setString(AppConst.VALUE_HOLDER__NOTI_MESSAGE, message);
  }

  Future<dynamic> replaceDate(String startDate, String endDate) async {
    await shared.setString(AppConst.VALUE_HOLDER__START_DATE, startDate);
    await shared.setString(AppConst.VALUE_HOLDER__END_DATE, endDate);

    loadValueHolder();
  }

  Future<dynamic> replaceVerifyUserData(
      String userIdToVerify,
      String userNameToVerify,
      String userEmailToVerify,
      String userPasswordToVerify) async {
    await shared.setString(
        AppConst.VALUE_HOLDER__USER_ID_TO_VERIFY, userIdToVerify);
    await shared.setString(
        AppConst.VALUE_HOLDER__USER_NAME_TO_VERIFY, userNameToVerify);
    await shared.setString(
        AppConst.VALUE_HOLDER__USER_EMAIL_TO_VERIFY, userEmailToVerify);
    await shared.setString(
        AppConst.VALUE_HOLDER__USER_PASSWORD_TO_VERIFY, userPasswordToVerify);

    loadValueHolder();
  }

  Future<dynamic> replaceVersionForceUpdateData(bool appInfoForceUpdate) async {
    await shared.setBool(
        AppConst.APPINFO_PREF_FORCE_UPDATE, appInfoForceUpdate);

    loadValueHolder();
  }

  Future<dynamic> replaceAppInfoData(
      String appInfoVersionNo,
      bool appInfoForceUpdate,
      String appInfoForceUpdateTitle,
      String appInfoForceUpdateMsg) async {
    await shared.setString(AppConst.APPINFO_PREF_VERSION_NO, appInfoVersionNo);
    await shared.setBool(
        AppConst.APPINFO_PREF_FORCE_UPDATE, appInfoForceUpdate);
    await shared.setString(
        AppConst.APPINFO_FORCE_UPDATE_TITLE, appInfoForceUpdateTitle);
    await shared.setString(
        AppConst.APPINFO_FORCE_UPDATE_MSG, appInfoForceUpdateMsg);

    loadValueHolder();
  }

  Future<dynamic> replaceShopInfoValueHolderData(
    String overAllTaxLabel,
    String overAllTaxValue,
    String shippingTaxLabel,
    String shippingTaxValue,
    String shippingId,
    String shopId,
    String messenger,
    String whatsapp,
    String phone,
  ) async {
    await shared.setString(
        AppConst.VALUE_HOLDER__OVERALL_TAX_LABEL, overAllTaxLabel);
    await shared.setString(
        AppConst.VALUE_HOLDER__OVERALL_TAX_VALUE, overAllTaxValue);
    await shared.setString(
        AppConst.VALUE_HOLDER__SHIPPING_TAX_LABEL, shippingTaxLabel);
    await shared.setString(
        AppConst.VALUE_HOLDER__SHIPPING_TAX_VALUE, shippingTaxValue);
    await shared.setString(AppConst.VALUE_HOLDER__SHIPPING_ID, shippingId);
    await shared.setString(AppConst.VALUE_HOLDER__SHOP_ID, shopId);
    await shared.setString(AppConst.VALUE_HOLDER__MESSENGER, messenger);
    await shared.setString(AppConst.VALUE_HOLDER__WHATSAPP, whatsapp);
    await shared.setString(AppConst.VALUE_HOLDER__PHONE, phone);

    loadValueHolder();
  }

  Future<dynamic> replaceCheckoutEnable(
      String paypalEnabled,
      String stripeEnabled,
      String codEnabled,
      String bankEnabled,
      String standardShippingEnable,
      String zoneShippingEnable,
      String noShippingEnable) async {
    await shared.setString(
        AppConst.VALUE_HOLDER__PAYPAL_ENABLED, paypalEnabled);
    await shared.setString(
        AppConst.VALUE_HOLDER__STRIPE_ENABLED, stripeEnabled);
    await shared.setString(AppConst.VALUE_HOLDER__COD_ENABLED, codEnabled);
    await shared.setString(
        AppConst.VALUE_HOLDER__BANK_TRANSFER_ENABLE, bankEnabled);
    await shared.setString(AppConst.VALUE_HOLDER__STANDART_SHIPPING_ENABLE,
        standardShippingEnable ?? '');
    await shared.setString(
        AppConst.VALUE_HOLDER__ZONE_SHIPPING_ENABLE, zoneShippingEnable ?? '');
    await shared.setString(
        AppConst.VALUE_HOLDER__NO_SHIPPING_ENABLE, noShippingEnable ?? '');

    loadValueHolder();
  }

  Future<dynamic> replacePublishKey(String pubKey) async {
    await shared.setString(AppConst.VALUE_HOLDER__PUBLISH_KEY, pubKey);

    loadValueHolder();
  }

  Future<dynamic> replacePayStackKey(String payStackKey) async {
    await shared.setString(AppConst.VALUE_HOLDER__PAYSTACK_KEY, payStackKey);

    loadValueHolder();
  }
}
