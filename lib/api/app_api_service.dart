import 'dart:io';

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
import 'package:dni_ecommerce/viewobject/blog.dart';

import 'app_api.dart';
import 'app_url.dart';
import 'common/app_resource.dart';

class AppApiService extends AppApi {
//   ///
//   /// App Info
//   ///
//   Future<AppResource<PSAppInfo>> postPsAppInfo(
//       Map<dynamic, dynamic> jsonMap) async {
//     const String url = '${AppUrl.app_post_app_app_info_url}';
//     return await postData<PSAppInfo, PSAppInfo>(PSAppInfo(), url, jsonMap);
//   }

//   ///
//   /// User Zone ShippingMethod
//   ///
//   Future<AppResource<ShippingCost>> postZoneShippingMethod(
//       Map<dynamic, dynamic> jsonMap) async {
//     const String url = '${AppUrl.app_post_app_zone_shipping_method_url}';
//     return await postData<ShippingCost, ShippingCost>(
//         ShippingCost(), url, jsonMap);
//   }

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
  /// User Login
  ///
  Future<AppResource<User>> postUserLogin(Map<dynamic, dynamic> jsonMap) async {
    const String url = '${AppUrl.app_post_app_user_login_url}';
    return await postData<User, User>(User(), url, jsonMap);
  }

//   ///
//   /// FB Login
//   ///
//   Future<AppResource<User>> postFBLogin(Map<dynamic, dynamic> jsonMap) async {
//     const String url = '${AppUrl.app_post_app_fb_login_url}';
//     return await postData<User, User>(User(), url, jsonMap);
//   }

//   ///
//   /// Google Login
//   ///
//   Future<AppResource<User>> postGoogleLogin(
//       Map<dynamic, dynamic> jsonMap) async {
//     const String url = '${AppUrl.app_post_app_google_login_url}';
//     return await postData<User, User>(User(), url, jsonMap);
//   }

//   ///
//   /// Apple Login
//   ///
//   Future<AppResource<User>> postAppleLogin(Map<dynamic, dynamic> jsonMap) async {
//     const String url = '${AppUrl.app_post_app_apple_login_url}';
//     return await postData<User, User>(User(), url, jsonMap);
//   }

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
  /// User Profile Update
  ///
  Future<AppResource<User>> postProfileUpdate(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${AppUrl.app_post_app_user_update_profile_url}';
    return await postData<User, User>(User(), url, jsonMap);
  }

//   ///
//   /// User Phone Login
//   ///
//   Future<AppResource<User>> postPhoneLogin(Map<dynamic, dynamic> jsonMap) async {
//     const String url = '${AppUrl.app_post_app_phone_login_url}';
//     return await postData<User, User>(User(), url, jsonMap);
//   }

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

  Future<AppResource<User>> postGalleryUpload(
      String userId, String platformName, File imageFile) async {
    const String url = '${AppUrl.app_image_upload_url}';

    return await postUploadImage<User, User>(
        User(), url, userId, platformName, imageFile);
  }

//   ///
//   /// Get Shipping Method
//   ///
//   Future<AppResource<List<ShippingMethod>>> getShippingMethod() async {
//     const String url =
//         '${AppUrl.app_shipping_method_url}';

//     return await getServerCall<ShippingMethod, List<ShippingMethod>>(
//         ShippingMethod(), url);
//   }

  ///
  /// Category
  ///
  Future<AppResource<List<Category>>> getCategoryList(
      int limit, int offset, Map<dynamic, dynamic> jsonMap) async {
    final String url = '${AppUrl.app_category_url}';

    ///limit/$limit/offset/$offset

    return await getServerCall<Category, List<Category>>(Category(), url);
  }

//   Future<AppResource<List<Category>>> getAllCategoryList(
//       Map<dynamic, dynamic> jsonMap) async {
//     final String url =
//         '${AppUrl.app_category_url}';

//     return await postData<Category, List<Category>>(Category(), url, jsonMap);
//   }

//   ///
//   /// Sub Category
//   ///
//   Future<AppResource<List<SubCategory>>> getSubCategoryList(
//       int limit, int offset, String categoryId) async {
//     final String url =
//         '${AppUrl.app_subCategory_url}/limit/$limit/offset/$offset/cat_id/$categoryId';

//     return await getServerCall<SubCategory, List<SubCategory>>(
//         SubCategory(), url);
//   }

  Future<AppResource<List<SubCategory>>> getAllSubCategoryList(
      String categoryId) async {
    final String url = '${AppUrl.app_subCategory_url}/$categoryId';

    return await getServerCall<SubCategory, List<SubCategory>>(
        SubCategory(), url);
  }

//   //noti
//   Future<AppResource<List<Noti>>> getNotificationList(
//       Map<dynamic, dynamic> paramMap, int limit, int offset) async {
//     final String url =
//         '${AppUrl.app_noti_url}/limit/$limit/offset/$offset';

//     return await postData<Noti, List<Noti>>(Noti(), url, paramMap);
//   }

  //
  /// Product
  ///
  Future<AppResource<List<Product>>> getProductList(
      Map<dynamic, dynamic> paramMap, int limit, int offset) async {
    final String url = '${AppUrl.app_product_url}/name/' +
        paramMap['searchterm'] +
        '/cat_id/' +
        paramMap['cat_id'] ??'';

    ///limit/$limit/offset/$offset

    return await getServerCall<Product, List<Product>>(Product(), url);
  }

  Future<AppResource<Product>> getProductDetail(
      String productId, String loginUserId) async {
    final String url =
        '${AppUrl.app_product_detail_url}/id/$productId/login_user_id/$loginUserId';
    return await getServerCall<Product, Product>(Product(), url);
  }

//   Future<AppResource<List<Product>>> getRelatedProductList(
//       String productId, String categoryId, int limit, int offset) async {
//     final String url =
//         '${AppUrl.app_relatedProduct_url}/id/$productId/cat_id/$categoryId/limit/$limit/offset/$offset';
//     print(url);
//     return await getServerCall<Product, List<Product>>(Product(), url);
//   }

//   //
//   /// Product Collection
//   ///
//   Future<AppResource<List<ProductCollectionHeader>>> getProductCollectionList(
//       int limit, int offset) async {
//     final String url =
//         '${AppUrl.app_collection_url}/limit/$limit/offset/$offset';

//     return await getServerCall<ProductCollectionHeader,
//         List<ProductCollectionHeader>>(ProductCollectionHeader(), url);
//   }

//   ///Setting
//   ///

//   Future<AppResource<ShopInfo>> getShopInfo() async {
//     const String url =
//         '${AppUrl.app_shop_info_url}';
//     return await getServerCall<ShopInfo, ShopInfo>(ShopInfo(), url);
//   }

  ///Blog
  ///

  Future<AppResource<List<Blog>>> getBlogList(int limit, int offset) async {
    final String url =
        '${AppUrl.app_bloglist_url}'; //limit/$limit/offset/$offset

    return await getServerCall<Blog, List<Blog>>(Blog(), url);
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

//   ///
//   /// Comments
//   ///
//   Future<AppResource<List<CommentHeader>>> getCommentList(
//       String productId, int limit, int offset) async {
//     final String url =
//         '${AppUrl.app_commentList_url}/product_id/$productId/limit/$limit/offset/$offset';

//     return await getServerCall<CommentHeader, List<CommentHeader>>(
//         CommentHeader(), url);
//   }

//   Future<AppResource<List<CommentDetail>>> getCommentDetail(
//       String headerId, int limit, int offset) async {
//     final String url =
//         '${AppUrl.app_commentDetail_url}/header_id/$headerId/limit/$limit/offset/$offset';

//     return await getServerCall<CommentDetail, List<CommentDetail>>(
//         CommentDetail(), url);
//   }

//   Future<AppResource<CommentHeader>> getCommentHeaderById(
//       String commentId) async {
//     final String url =
//         '${AppUrl.app_commentList_url}/id/$commentId';

//     return await getServerCall<CommentHeader, CommentHeader>(
//         CommentHeader(), url);
//   }

  ///
  /// Top Selling
  ///
  Future<AppResource<List<Product>>> getTopSellingProductList(
      int limit, int offset) async {
    final String url = '${AppUrl.app_topselling_productList_url}';

    return await getServerCall<Product, List<Product>>(Product(), url);
  }

  ///
  /// Top New
  ///
  Future<AppResource<List<Product>>> getTopNewProductList(
      String loginUserId, int limit, int offset) async {
    final String url = '${AppUrl.app_topnew_productList_url}';

    return await getServerCall<Product, List<Product>>(Product(), url);
  }

//   ///
//   /// Product List By Collection Id
//   ///
//   Future<AppResource<List<Product>>> getProductListByCollectionId(
//       String collectionId, int limit, int offset) async {
//     final String url =
//         '${AppUrl.app_all_collection_url}/id/$collectionId/limit/$limit/offset/$offset';

//     return await getServerCall<Product, List<Product>>(Product(), url);
//   }

//   Future<AppResource<List<CommentHeader>>> postCommentHeader(
//       Map<dynamic, dynamic> jsonMap) async {
//     const String url = '${AppUrl.app_commentHeaderPost_url}';
//     return await postData<CommentHeader, List<CommentHeader>>(
//         CommentHeader(), url, jsonMap);
//   }

//   Future<AppResource<List<CommentDetail>>> postCommentDetail(
//       Map<dynamic, dynamic> jsonMap) async {
//     const String url = '${AppUrl.app_commentDetailPost_url}';
//     return await postData<CommentDetail, List<CommentDetail>>(
//         CommentDetail(), url, jsonMap);
//   }

//   Future<AppResource<List<DownloadProduct>>> postDownloadProductList(
//       Map<dynamic, dynamic> jsonMap) async {
//     const String url = '${AppUrl.app_downloadProductPost_url}';
//     return await postData<DownloadProduct, List<DownloadProduct>>(
//         DownloadProduct(), url, jsonMap);
//   }

//   Future<AppResource<ApiStatus>> rawRegisterNotiToken(
//       Map<dynamic, dynamic> jsonMap) async {
//     const String url = '${AppUrl.app_noti_register_url}';
//     return await postData<ApiStatus, ApiStatus>(ApiStatus(), url, jsonMap);
//   }

//   Future<AppResource<ApiStatus>> rawUnRegisterNotiToken(
//       Map<dynamic, dynamic> jsonMap) async {
//     const String url = '${AppUrl.app_noti_unregister_url}';
//     return await postData<ApiStatus, ApiStatus>(ApiStatus(), url, jsonMap);
//   }

//   Future<AppResource<Noti>> postNoti(Map<dynamic, dynamic> jsonMap) async {
//     const String url = '${AppUrl.app_noti_post_url}';
//     return await postData<Noti, Noti>(Noti(), url, jsonMap);
//   }

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

//   ///
//   ///Favourite
//   ///
//   Future<AppResource<List<Product>>> getFavouriteList(
//       String loginUserId, int limit, int offset) async {
//     final String url =
//         '${AppUrl.app_ratingList_url}/login_user_id/$loginUserId/limit/$limit/offset/$offset';

//     return await getServerCall<Product, List<Product>>(Product(), url);
//   }

  Future<AppResource<Product>> postFavourite(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${AppUrl.app_favouritePost_url}';
    return await postData<Product, Product>(Product(), url, jsonMap);
  }

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
  /// Token
  ///
  Future<AppResource<ApiStatus>> getToken() async {
    const String url = '${AppUrl.app_token_url}';
    return await getServerCall<ApiStatus, ApiStatus>(ApiStatus(), url);
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
