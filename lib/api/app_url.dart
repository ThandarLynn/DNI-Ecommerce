import 'package:dni_ecommerce/config/app_config.dart';

class AppUrl {
  AppUrl._();

  ///
  /// APIs Url
  ///
  static const String app_product_detail_url = 'rest/products/get';

  static const String app_shipping_method_url = 'rest/shippings/get';

  static const String app_news_feed_url = 'rest/feeds/get';

  static const String app_category_url = 'categories';

  static const String app_about_app_url = 'rest/abouts/get';

  static const String app_contact_us_url =
      'rest/contacts/add/api_key/${AppConfig.app_api_key}';

  static const String app_image_upload_url =
      'rest/images/upload/api_key/${AppConfig.app_api_key}';

  static const String app_collection_url = 'rest/collections/get';

  static const String app_all_collection_url =
      'rest/products/all_collection_products';

  static const String app_post_app_app_info_url =
      'rest/appinfo/get_delete_history/api_key/${AppConfig.app_api_key}';

  static const String app_post_app_user_register_url = 'register';

  static const String app_post_app_user_email_verify_url = 'rest/users/verify';

  static const String app_post_app_zone_shipping_method_url =
      'rest/shipping_zones/get_shipping_cost';

  static const String app_post_app_user_login_url = 'login';

  static const String app_post_app_user_forgot_password_url = 'forgot';

  static const String app_post_app_user_change_password_url = 'reset';

  static const String app_post_app_user_update_profile_url =
      'rest/users/profile_update/api_key/${AppConfig.app_api_key}';

  static const String app_post_app_phone_login_url =
      'rest/users/phone_register/api_key/${AppConfig.app_api_key}';

  static const String app_post_app_fb_login_url =
      'rest/users/facebook_register/api_key/${AppConfig.app_api_key}';

  static const String app_post_app_google_login_url =
      'rest/users/google_register/api_key/${AppConfig.app_api_key}';

  static const String app_post_app_apple_login_url =
      'rest/users/apple_register/api_key/${AppConfig.app_api_key}';

  static const String app_post_app_resend_code_url = 'rest/users/request_code';

  static const String app_post_app_touch_count_url = 'products/view-count';

  static const String app_product_url = 'products';

  // static const String app_products_search_url = 'rest/products/search';

  static const String app_subCategory_url = 'rest/subcategories/get';

  static const String app_user_url = 'user/profile';

  static const String app_noti_url = 'rest/notis/all_notis';

  static const String app_shop_info_url = 'rest/shops/get_shop_info';

  static const String app_bloglist_url = 'homeslider';

  static const String app_transactionList_url = 'userOrders';

  static const String app_transactionDetail_url = 'rest/transactiondetails/get';

  static const String app_shipping_country_url =
      'rest/shipping_zones/get_shipping_country';

  static const String app_shipping_city_url =
      'rest/shipping_zones/get_shipping_city';

  static const String app_relatedProduct_url =
      'rest/products/related_product_trending';

  static const String app_commentList_url = 'rest/commentheaders/get';

  static const String app_commentDetail_url = 'rest/commentdetails/get';

  static const String app_commentHeaderPost_url =
      'rest/commentheaders/press/api_key/${AppConfig.app_api_key}';

  static const String app_commentDetailPost_url =
      'rest/commentdetails/press/api_key/${AppConfig.app_api_key}';

  static const String app_downloadProductPost_url =
      'rest/downloads/download_product/api_key/${AppConfig.app_api_key}';

  static const String app_noti_register_url =
      'rest/notis/register/api_key/${AppConfig.app_api_key}';

  static const String app_noti_post_url =
      'rest/notis/is_read/api_key/${AppConfig.app_api_key}';

  static const String app_noti_unregister_url =
      'rest/notis/unregister/api_key/${AppConfig.app_api_key}';

  static const String app_ratingPost_url =
      'rest/rates/add_rating/api_key/${AppConfig.app_api_key}';

  static const String app_ratingList_url = 'rest/rates/get';

  static const String app_favouritePost_url =
      'rest/favourites/press/api_key/${AppConfig.app_api_key}';

  static const String app_topselling_productList_url = 'products/tsproducts';

  static const String app_topnew_productList_url = 'products/lproducts';

  static const String app_gallery_url = 'imageGallery';

  static const String app_couponDiscount_url =
      'rest/coupons/check/api_key/${AppConfig.app_api_key}';

  static const String app_token_url = 'rest/paypal/get_token';

  static const String app_transaction_submit_url =
      'rest/transactionheaders/submit/api_key/${AppConfig.app_api_key}';

  static const String app_collection_product_url =
      'rest/products/all_collection_products';
}
