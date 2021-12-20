import 'package:dni_ecommerce/viewobject/category.dart';
import 'package:dni_ecommerce/viewobject/common/api_status.dart';
import 'package:dni_ecommerce/viewobject/coupon_discount.dart';
import 'package:dni_ecommerce/viewobject/gallery.dart';
import 'package:dni_ecommerce/viewobject/product.dart';
import 'package:dni_ecommerce/viewobject/shipping_city.dart';
import 'package:dni_ecommerce/viewobject/shipping_country.dart';
import 'package:dni_ecommerce/viewobject/sub_category.dart';
import 'package:dni_ecommerce/viewobject/transaction_detail.dart';
import 'package:dni_ecommerce/viewobject/transaction_header.dart';
import 'package:dni_ecommerce/viewobject/user.dart';

import 'app_api.dart';
import 'app_url.dart';
import 'common/app_resource.dart';

class AppApiService extends AppApi {
  ///
  /// User Register
  ///
  Future<AppResource<User>> postUserRegister(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${AppUrl.app_post_app_user_register_url}';
    return await postData<User, User>(User(), url, jsonMap);
  }

  ///
  /// User Verify Email
  ///
  Future<AppResource<User>> postUserEmailVerify(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${AppUrl.app_post_app_user_email_verify_url}';
    return await postData<User, User>(User(), url, jsonMap);
  }

  ///
  /// User Profile Update
  ///
  Future<AppResource<User>> postProfileUpdate(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${AppUrl.app_post_ps_user_update_profile_url}';
    return await postData<User, User>(User(), url, jsonMap);
  }

  ///
  /// Token
  ///
  Future<AppResource<ApiStatus>> getToken() async {
    const String url = '${AppUrl.app_token_url}';
    return await getServerCall<ApiStatus, ApiStatus>(ApiStatus(), url);
  }

  ///
  /// User Login
  ///
  Future<AppResource<User>> postUserLogin(Map<dynamic, dynamic> jsonMap) async {
    const String url = '${AppUrl.app_post_app_user_login_url}';
    return await postData<User, User>(User(), url, jsonMap);
  }

  ///
  /// User Forgot Password
  ///
  Future<AppResource<ApiStatus>> postForgotPassword(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${AppUrl.app_post_app_user_forgot_password_url}';
    return await postData<ApiStatus, ApiStatus>(ApiStatus(), url, jsonMap);
  }

  ///
  /// User Change Password
  ///
  Future<AppResource<ApiStatus>> postChangePassword(
      Map<dynamic, dynamic> jsonMap, String userToken) async {
    const String url = '${AppUrl.app_post_app_user_change_password_url}';
    return await postData<ApiStatus, ApiStatus>(ApiStatus(), url, jsonMap,
        token: userToken);
  }

  ///
  /// User Resend Code
  ///
  Future<AppResource<ApiStatus>> postResendCode(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${AppUrl.app_post_app_resend_code_url}';
    return await postData<ApiStatus, ApiStatus>(ApiStatus(), url, jsonMap);
  }

  ///
  /// Touch Count
  ///
  Future<AppResource<ApiStatus>> postTouchCount(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${AppUrl.app_post_app_touch_count_url}';
    return await postData<ApiStatus, ApiStatus>(ApiStatus(), url, jsonMap);
  }

//   ///
//   /// About App
//   ///
//   Future<AppResource<List<AboutApp>>> getAboutAppDataList() async {
//     const String url =
//         '${AppUrl.app_about_app_url}/';
//     return await getServerCall<AboutApp, List<AboutApp>>(AboutApp(), url);
//   }

  ///
  /// Get User
  ///
  Future<AppResource<User>> getUser(String userId, String userToken) async {
    final String url = '${AppUrl.app_user_url}';

    return await getServerCall<User, User>(User(), url, token: userToken);
  }

  ///
  /// Category
  ///
  Future<AppResource<List<Category>>> getCategoryList(
      int limit, int offset, Map<dynamic, dynamic> jsonMap) async {
    final String url = '${AppUrl.app_category_url}';

    ///limit/$limit/offset/$offset

    return await getServerCall<Category, List<Category>>(Category(), url);
  }

  Future<AppResource<List<SubCategory>>> getAllSubCategoryList(
      String categoryId) async {
    final String url = '${AppUrl.app_subCategory_url}/$categoryId';

    return await getServerCall<SubCategory, List<SubCategory>>(
        SubCategory(), url);
  }

  //
  /// Product
  ///
  Future<AppResource<List<Product>>> getProductList(
      Map<dynamic, dynamic> paramMap, int limit, int offset) async {
    final String url = '${AppUrl.app_product_url}?name=' +
            paramMap['searchterm'] +
            '&cat_id=' +
            paramMap['cat_id'] +
            '&sub_cat_id=' +
            paramMap['sub_cat_id'] ??
        '';

    ///limit/$limit/offset/$offset

    return await getServerCall<Product, List<Product>>(Product(), url);
  }

  Future<AppResource<Product>> getProductDetail(
      String productId, String loginUserId) async {
    final String url =
        '${AppUrl.app_product_detail_url}/id/$productId/login_user_id/$loginUserId';
    return await getServerCall<Product, Product>(Product(), url);
  }

  ///Blog
  ///

  Future<AppResource<List<Product>>> getBlogList(int limit, int offset) async {
    final String url =
        '${AppUrl.app_bloglist_url}'; //limit/$limit/offset/$offset

    return await getServerCall<Product, List<Product>>(Product(), url);
  }

  ///Transaction
  ///

  Future<AppResource<List<TransactionHeader>>> getTransactionList(
      String userId, String userToken, int limit, int offset) async {
    final String url = '${AppUrl.app_transactionList_url}';

    ///user_id/$userId/limit/$limit/offset/$offset

    return await getServerCall<TransactionHeader, List<TransactionHeader>>(
        TransactionHeader(), url,
        token: userToken);
  }

  Future<AppResource<List<TransactionDetail>>> getTransactionDetail(
      String id, int limit, int offset) async {
    final String url =
        '${AppUrl.app_transactionDetail_url}/transactions_header_id/$id/limit/$limit/offset/$offset';
    print(url);
    return await getServerCall<TransactionDetail, List<TransactionDetail>>(
        TransactionDetail(), url);
  }

  Future<AppResource<TransactionHeader>> postTransactionSubmit(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${AppUrl.app_transaction_submit_url}';
    return await postData<TransactionHeader, TransactionHeader>(
        TransactionHeader(), url, jsonMap);
  }

  ///
  /// Top Selling
  ///
  Future<AppResource<List<Product>>> getTopSellingProductList(
      int limit, int offset) async {
    final String url = '${AppUrl.app_topselling_productList_url}';

    return await getServerCall<Product, List<Product>>(Product(), url);
  }

  ///
  /// Top Rated Product
  ///
  Future<AppResource<List<Product>>> getTopRatedProductList(
      int limit, int offset) async {
    final String url = '${AppUrl.app_top_rated_productList_url}';

    return await getServerCall<Product, List<Product>>(Product(), url);
  }

//   ///
//   /// Rating
//   ///
//   Future<AppResource<Rating>> postRating(Map<dynamic, dynamic> jsonMap) async {
//     const String url = '${AppUrl.app_ratingPost_url}';
//     return await postData<Rating, Rating>(Rating(), url, jsonMap);
//   }

//   Future<AppResource<List<Rating>>> getRatingList(
//       String productId, int limit, int offset) async {
//     final String url =
//         '${AppUrl.app_ratingList_url}/product_id/$productId/limit/$limit/offset/$offset';

//     return await getServerCall<Rating, List<Rating>>(Rating(), url);
//   }

  ///
  /// Gallery
  ///
  Future<AppResource<List<Gallery>>> getGalleryList(
      String parentImgId,
      // String imageType,
      int limit,
      int offset) async {
    final String url =
        '${AppUrl.app_gallery_url}/$parentImgId'; //limit/$limit/offset/$offset

    return await getServerCall<Gallery, List<Gallery>>(Gallery(), url);
  }

  ///
  /// Contact
  ///
  Future<AppResource<ApiStatus>> postContactUs(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${AppUrl.app_contact_us_url}';
    return await postData<ApiStatus, ApiStatus>(ApiStatus(), url, jsonMap);
  }

  ///
  /// CouponDiscount
  ///
  Future<AppResource<CouponDiscount>> postCouponDiscount(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${AppUrl.app_couponDiscount_url}';
    return await postData<CouponDiscount, CouponDiscount>(
        CouponDiscount(), url, jsonMap);
  }

  ///
  /// Shipping Country And City
  ///
  Future<AppResource<List<ShippingCountry>>> getCountryList(
      int limit, int offset, Map<dynamic, dynamic> jsonMap) async {
    final String url =
        '${AppUrl.app_shipping_country_url}/limit/$limit/offset/$offset';

    return await postData<ShippingCountry, List<ShippingCountry>>(
        ShippingCountry(), url, jsonMap);
  }

  Future<AppResource<List<ShippingCity>>> getCityList(
      int limit, int offset, Map<dynamic, dynamic> jsonMap) async {
    final String url =
        '${AppUrl.app_shipping_city_url}/limit/$limit/offset/$offset';

    return await postData<ShippingCity, List<ShippingCity>>(
        ShippingCity(), url, jsonMap);
  }

//   //   Future<AppResource<List<ShippingCountry>>> postShopIdForShippingCountry(
//   //     Map<dynamic, dynamic> jsonMap) async {
//   //   const String url = '${AppUrl.app_post_app_touch_count_url}';
//   //    return await postData<ShippingCity, List<ShippingCity>>(ShippingCity(), url, jsonMap);
//   // }

}
