import 'package:dni_ecommerce/repository/Common/app_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:dni_ecommerce/config/app_config.dart';

class AppProvider extends ChangeNotifier {
  AppProvider(this.appRepository, int limit) {
    if (limit != 0) {
      this.limit = limit;
    }
  }

  bool isConnectedToInternet = false;
  bool isLoading = false;
  AppRepository appRepository;

  int offset = 0;
  int limit = AppConfig.DEFAULT_LOADING_LIMIT;
  int _cacheDataLength = 0;
  int maxDataLoadingCount = 0;
  int maxDataLoadingCountLimit = 4;
  bool isReachMaxData = false;
  bool isDispose = false;

  void updateOffset(int dataLength) {
    if (offset == 0) {
      isReachMaxData = false;
      maxDataLoadingCount = 0;
    }
    if (dataLength == _cacheDataLength) {
      maxDataLoadingCount++;
      if (maxDataLoadingCount == maxDataLoadingCountLimit) {
        isReachMaxData = true;
      }
    } else {
      maxDataLoadingCount = 0;
    }

    offset = dataLength;
    _cacheDataLength = dataLength;
  }

  Future<void> loadValueHolder() async {
    await appRepository.loadValueHolder();
  }

  Future<void> replaceLoginUserId(String loginUserId, String userToken) async {
    await appRepository.replaceLoginUserId(loginUserId, userToken);
  }

  Future<void> replaceLoginUserName(String loginUserName) async {
    await appRepository.replaceLoginUserName(loginUserName);
  }

  Future<void> replaceNotiToken(String notiToken) async {
    await appRepository.replaceNotiToken(notiToken);
  }

  Future<void> replaceNotiSetting(bool notiSetting) async {
    await appRepository.replaceNotiSetting(notiSetting);
  }

  Future<void> replaceIsToShowIntroSlider(bool doNotShowAgain) async {
    await appRepository.replaceIsToShowIntroSlider(doNotShowAgain);
  }

  Future<void> replaceDate(String startDate, String endDate) async {
    await appRepository.replaceDate(startDate, endDate);
  }

  Future<void> replaceVerifyUserData(
      String userIdToVerify,
      String userNameToVerify,
      String userEmailToVerify,
      String userPasswordToVerify) async {
    await appRepository.replaceVerifyUserData(userIdToVerify, userNameToVerify,
        userEmailToVerify, userPasswordToVerify);
  }

  Future<void> replaceVersionForceUpdateData(bool appInfoForceUpdate) async {
    await appRepository.replaceVersionForceUpdateData(appInfoForceUpdate);
  }

  Future<void> replaceAppInfoData(
      String appInfoVersionNo,
      bool appInfoForceUpdate,
      String appInfoForceUpdateTitle,
      String appInfoForceUpdateMsg) async {
    await appRepository.replaceAppInfoData(appInfoVersionNo, appInfoForceUpdate,
        appInfoForceUpdateTitle, appInfoForceUpdateMsg);
  }

  Future<void> replaceShopInfoValueHolderData(
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
    await appRepository.replaceShopInfoValueHolderData(
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

  Future<void> replaceCheckoutEnable(
      String paypalEnabled,
      String stripeEnabled,
      String codEnabled,
      String bankEnabled,
      String standardShippingEnable,
      String zoneShippingEnable,
      String noShippingEnable) async {
    await appRepository.replaceCheckoutEnable(
        paypalEnabled,
        stripeEnabled,
        codEnabled,
        bankEnabled,
        standardShippingEnable,
        zoneShippingEnable,
        noShippingEnable);
  }

  Future<void> replacePublishKey(String pubKey) async {
    await appRepository.replacePublishKey(pubKey);
  }

  Future<void> replacePayStackKey(String payStackKey) async {
    await appRepository.replacePayStackKey(payStackKey);
  }
}
