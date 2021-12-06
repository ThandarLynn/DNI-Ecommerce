import 'package:dni_ecommerce/viewobject/language.dart';

class AppConfig {
  AppConfig._();

  ///
  /// API Key
  /// If you change here, you need to update in server.
  ///
  static const String app_api_key = 'teampsisthebest';

  ///
  /// API URL
  /// Change your backend url
  ///
  static const String app_base_url = 'https://dailyneeditem.com';

  static const String app_url = app_base_url + '/api/';

  static const String app_image_url = '';

  static const String app_image_thumbs_url = '';

  static const String GOOGLE_PLAY_STORE_URL =
      'https://play.google.com/store/apps';

  static const String APPLE_APP_STORE_URL = 'https://www.apple.com/app-store';

  ///
  /// iOS App No
  ///
  // static const String iOSAppStoreId = '000000000';
  static const String iOSAppStoreId = '789135275';

  ///
  /// Default Limit
  ///
  static const int DEFAULT_LOADING_LIMIT = 30;
  static const int CATEGORY_LOADING_LIMIT = 10;
  static const int COLLECTION_PRODUCT_LOADING_LIMIT = 10;
  static const int DISCOUNT_PRODUCT_LOADING_LIMIT = 10;
  static const int FEATURE_PRODUCT_LOADING_LIMIT = 10;
  static const int LATEST_PRODUCT_LOADING_LIMIT = 10;
  static const int TRENDING_PRODUCT_LOADING_LIMIT = 10;

  //Language Setting
  static const Language defaultLanguage =
      Language(languageCode: 'en', countryCode: 'US', name: 'English US');
  static const List<Language> appSupportedLanguageList = <Language>[
    Language(languageCode: 'en', countryCode: 'US', name: 'English US'),
    Language(languageCode: 'ar', countryCode: 'DZ', name: 'Arabic'),
    Language(languageCode: 'zh', countryCode: 'CN', name: 'Chinese')
  ];

  ///
  /// Price Format
  /// Need to change according to your format that you need
  /// E.g.
  /// ",##0.00"   => 2,555.00
  /// "##0.00"    => 2555.00
  /// ".00"       => 2555.00
  /// ",##0"      => 2555
  /// ",##0.0"    => 2555.0
  ///
  static const String priceFormat = ',###.00';

  static const String app_db_name = 'dni_ecommerce_db.db';

  ///
  /// Animation Duration
  ///
  static const Duration animation_duration = Duration(milliseconds: 500);

  ///
  ///Admob Setting
  ///
  static bool showAdMob = true;
  static String androidAdMobAdsIdKey = 'ca-app-pub-8907881762519005~9233555983';
  // static String androidAdMobAdsIdKey = 'ca-app-pub-0000000000000000~0000000000';
  static String androidAdMobUnitIdApiKey =
      'ca-app-pub-8907881762519005/9208563612';
  // static String androidAdMobUnitIdApiKey =
  //     'ca-app-pub-0000000000000000/0000000000';
  static String iosAdMobAdsIdKey = 'ca-app-pub-8907881762519005~5353008960';
  // static String iosAdMobAdsIdKey = 'ca-app-pub-0000000000000000~0000000000';
  static String iosAdMobUnitIdApiKey = 'ca-app-pub-8907881762519005/6390828588';
  // static String iosAdMobUnitIdApiKey = 'ca-app-pub-0000000000000000/0000000000';

  ///
  /// Fonts Family Config
  /// Before you declare you here,
  /// 1) You need to add font under assets/fonts/
  /// 2) Declare at pubspec.yaml
  /// 3) Update your font family name at below
  ///
  static const String app_default_font_family = 'Product Sans';

  ///
  /// Date Time Format
  ///
  static const String dateFormat = 'dd-MM-yyyy hh:mm:ss';

  static const String overTaxValue = '0.03';
}
