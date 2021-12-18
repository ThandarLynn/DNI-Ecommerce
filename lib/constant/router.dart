import 'package:dni_ecommerce/constant/route_paths.dart';
import 'package:dni_ecommerce/ui/basket/list/basket_list_container.dart';
import 'package:dni_ecommerce/ui/checkout/checkout_container_view.dart';
import 'package:dni_ecommerce/ui/checkout/checkout_status_view.dart';
import 'package:dni_ecommerce/ui/dashboard/core/dashboard_view.dart';
import 'package:dni_ecommerce/ui/language/language_list.dart';
import 'package:dni_ecommerce/ui/category/category_list_view_container.dart';
import 'package:dni_ecommerce/ui/product/detail/product_detail_view.dart';
import 'package:dni_ecommerce/ui/product/filter/product_list_with_filter_container.dart';
import 'package:dni_ecommerce/ui/user/edit_profile/city_list_view.dart';
import 'package:dni_ecommerce/ui/user/edit_profile/country_list_view.dart';
import 'package:dni_ecommerce/ui/user/login/login_container_view.dart';
import 'package:dni_ecommerce/viewobject/gallery.dart';
import 'package:dni_ecommerce/viewobject/holder/checkout_intent_holder.dart';
import 'package:dni_ecommerce/viewobject/holder/intent/checkout_status_intent_holder.dart';
import 'package:dni_ecommerce/viewobject/holder/intent/product_detail_intent_holder.dart';
import 'package:dni_ecommerce/viewobject/holder/intent/product_list_intent_holder.dart';
import 'package:dni_ecommerce/viewobject/product.dart';
import 'package:dni_ecommerce/viewobject/transaction_header.dart';
import 'package:dni_ecommerce/ui/transaction/detail/transaction_item_list_view.dart';
import 'package:flutter/material.dart';
import 'package:dni_ecommerce/ui/gallery/grid/gallery_grid_view.dart';
import 'package:dni_ecommerce/ui/privacy_policy/privacy_policy_container_view.dart';
import 'package:dni_ecommerce/ui/user/forgot_password/forgot_password_container_view.dart';
import 'package:dni_ecommerce/ui/user/password_update/change_password_view.dart';
import 'package:dni_ecommerce/ui/user/reset_password/reset_password_view.dart';
import 'package:dni_ecommerce/ui/gallery/detail/gallery_view.dart';
import 'package:dni_ecommerce/ui/transaction/list/transaction_list_container.dart';
import 'package:dni_ecommerce/ui/product/filter/category/filter_list_view.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute<dynamic>(
          settings: const RouteSettings(name: RoutePaths.home),
          builder: (BuildContext context) {
            return DashboardView();
          });

      return MaterialPageRoute<dynamic>(
          settings: const RouteSettings(name: RoutePaths.home),
          builder: (BuildContext context) {
            return DashboardView();
          });

    // case '${RoutePaths.force_update}':
    //   final Object args = settings.arguments;
    //   final PSAppVersion psAppVersion = args ?? PSAppVersion;
    //   return PageRouteBuilder<dynamic>(
    //       pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
    //           ForceUpdateView(psAppVersion: psAppVersion));

    // case '${RoutePaths.user_register_container}':
    //   return PageRouteBuilder<dynamic>(
    //       pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
    //           RegisterContainerView());
    case '${RoutePaths.login_container}':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              LoginContainerView());
    // case '${RoutePaths.appinfo}':
    //   return MaterialPageRoute<dynamic>(
    //       builder: (BuildContext context) => AppInfoView());
    // case '${RoutePaths.subCategoryGrid}':
    //   return MaterialPageRoute<Category>(builder: (BuildContext context) {
    //     final Object args = settings.arguments;
    //     final Category category = args ?? Category;
    //     return SubCategoryGridView(category: category);
    //   });

    // case '${RoutePaths.user_verify_email_container}':
    //   final Object args = settings.arguments;
    //   final String userId = args ?? String;
    //   return PageRouteBuilder<dynamic>(
    //       pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
    //           VerifyEmailContainerView(userId: userId));

    case '${RoutePaths.user_forgot_password_container}':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              ForgotPasswordContainerView());

    // case '${RoutePaths.setting}':
    //   return MaterialPageRoute<dynamic>(
    //       builder: (BuildContext context) => SettingContainerView());

    // case '${RoutePaths.more}':
    //   return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
    //     final Object args = settings.arguments;
    //     final String userName = args ?? String;
    //     return MoreContainerView(userName: userName);
    //   });

    // case '${RoutePaths.introSlider}':
    //   return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
    //     final Object args = settings.arguments;
    //     final int settingSlider = args ?? int;
    //     return IntroSliderView(settingSlider:settingSlider);
    //   });

    // case '${RoutePaths.user_phone_signin_container}':
    //   return PageRouteBuilder<dynamic>(
    //       pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
    //           PhoneSignInContainerView());

    // case '${RoutePaths.user_phone_verify_container}':
    //   final Object args = settings.arguments;

    //   final VerifyPhoneIntentHolder verifyPhoneIntentParameterHolder =
    //       args ?? VerifyPhoneIntentHolder;
    //   return PageRouteBuilder<dynamic>(
    //       pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
    //           VerifyPhoneContainerView(
    //             userName: verifyPhoneIntentParameterHolder.userName,
    //             phoneNumber: verifyPhoneIntentParameterHolder.phoneNumber,
    //             phoneId: verifyPhoneIntentParameterHolder.phoneId,
    //           ));

    // case '${RoutePaths.payStack}':
    //   final Object args = settings.arguments;

    //   final CreditCardIntentHolder creditCardInterntHolder =
    //       args ?? CreditCardIntentHolder;
    //   return PageRouteBuilder<dynamic>(
    //       pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
    //           PayStackView(
    //               basketList: creditCardInterntHolder.basketList,
    //               couponDiscount: creditCardInterntHolder.couponDiscount,
    //               transactionSubmitProvider:
    //                   creditCardInterntHolder.transactionSubmitProvider,
    //               psValueHolder: creditCardInterntHolder.psValueHolder,
    //               basketProvider: creditCardInterntHolder.basketProvider,
    //               userLoginProvider: creditCardInterntHolder.userProvider,
    //               memoText: creditCardInterntHolder.memoText,
    //               payStackKey: creditCardInterntHolder.payStackKey,
    //               shippingCostProvider:
    //                   creditCardInterntHolder.shippingCostProvider,
    //               shippingMethodProvider:
    //                   creditCardInterntHolder.shippingMethodProvider));

    case '${RoutePaths.user_update_password}':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              ChangePasswordView());

    case '${RoutePaths.reset_password}':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        final Object args = settings.arguments;
        final String userToken = args ?? String;
        return ResetPasswordView(userToken: userToken);
      });

    //             case '${RoutePaths.contactUs}':
    //   return MaterialPageRoute<dynamic>(
    //       builder: (BuildContext context) => ContactUsContainerView());

    // case '${RoutePaths.profile_container}':
    //   return PageRouteBuilder<dynamic>(
    //       pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
    //           ProfileContainerView());

    case '${RoutePaths.languageList}':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              const LanguageListView());

    case '${RoutePaths.categoryList}':
      final Object args = settings.arguments;
      final String title = args ?? String;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              CategoryListViewContainerView(appBarTitle: title));

    // case '${RoutePaths.notiList}':
    //   return PageRouteBuilder<dynamic>(
    //       pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
    //           const NotiListView());
    // case '${RoutePaths.creditCard}':
    //   final Object args = settings.arguments;

    //   final CreditCardIntentHolder creditCardParameterHolder =
    //       args ?? CreditCardIntentHolder;
    //   return PageRouteBuilder<dynamic>(
    //       pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
    //           CreditCardView(
    //               basketList: creditCardParameterHolder.basketList,
    //               couponDiscount: creditCardParameterHolder.couponDiscount,
    //               transactionSubmitProvider:
    //                   creditCardParameterHolder.transactionSubmitProvider,
    //               userLoginProvider: creditCardParameterHolder.userProvider,
    //               basketProvider: creditCardParameterHolder.basketProvider,
    //               psValueHolder: creditCardParameterHolder.psValueHolder,
    //               // shippingCostProvider:
    //               //     creditCardParameterHolder.shippingCostProvider,
    //               // shippingMethodProvider:
    //               //     creditCardParameterHolder.shippingMethodProvider,
    //               memoText: creditCardParameterHolder.memoText,
    //               publishKey: creditCardParameterHolder.publishKey));

    // case '${RoutePaths.notiSetting}':
    //   return PageRouteBuilder<dynamic>(
    //       pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
    //           NotificationSettingView());

    // case '${RoutePaths.termsAndRefund}':
    //   final Object args = settings.arguments;
    //   final PrivacyPolicyIntentHolder privacyPolicyIntentHolder = args ?? int;
    //   return PageRouteBuilder<dynamic>(
    //       pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
    //           TermsAndRefundContainerView(
    //               title: privacyPolicyIntentHolder.title,
    //               description: privacyPolicyIntentHolder.description));

    // // case '${RoutePaths.subCategoryList}':
    // //   final Object args = settings.arguments;
    // //   final Category category = args ?? Category;
    // //   return PageRouteBuilder<dynamic>(
    // //       pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
    // //           SubCategoryListView(category: category));

    // case '${RoutePaths.noti}':
    //   final Object args = settings.arguments;
    //   final Noti noti = args ?? Noti;
    //   return PageRouteBuilder<dynamic>(
    //       pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
    //           NotiView(noti: noti));

    case '${RoutePaths.filterProductList}':
      final Object args = settings.arguments;
      final ProductListIntentHolder productListIntentHolder =
          args ?? ProductListIntentHolder;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              ProductListWithFilterContainerView(
                  appBarTitle: productListIntentHolder.appBarTitle,
                  productParameterHolder:
                      productListIntentHolder.productParameterHolder));

    case '${RoutePaths.checkoutSuccess}':
      final Object args = settings.arguments;

      final CheckoutStatusIntentHolder checkoutStatusIntentHolder =
          args ?? CheckoutStatusIntentHolder;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              CheckoutStatusView(
                transactionHeader: checkoutStatusIntentHolder.transactionHeader,
              ));

    case '${RoutePaths.privacyPolicy}':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              PrivacyPolicyContainerView());

    // case '${RoutePaths.blogList}':
    //   return PageRouteBuilder<dynamic>(
    //       pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
    //           BlogListContainerView());

    // case '${RoutePaths.blogDetail}':
    //   final Object args = settings.arguments;
    //   final Blog blog = args ?? Blog;
    //   return MaterialPageRoute<Widget>(builder: (BuildContext context) {
    //     return BlogView(
    //       blog: blog,
    //       heroTagImage: blog.id,
    //     );
    //   });

    case '${RoutePaths.transactionList}':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              TransactionListContainerView());

    // case '${RoutePaths.historyList}':
    //   return PageRouteBuilder<dynamic>(
    //       pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
    //           HistoryListContainerView());

    case '${RoutePaths.transactionDetail}':
      final Object args = settings.arguments;
      final TransactionHeader transaction = args ?? TransactionHeader;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              TransactionItemListView(
                transaction: transaction,
              ));

    case '${RoutePaths.productDetail}':
      final Object args = settings.arguments;
      final ProductDetailIntentHolder holder =
          args ?? ProductDetailIntentHolder;
      return MaterialPageRoute<Widget>(builder: (BuildContext context) {
        return ProductDetailView(
          productDetail: holder.product,
          heroTagImage: holder.heroTagImage,
          heroTagTitle: holder.heroTagTitle,
          heroTagOriginalPrice: holder.heroTagOriginalPrice,
          heroTagUnitPrice: holder.heroTagUnitPrice,
          intentQty: holder.qty,
          intentSelectedColorId: holder.selectedColorId,
          intentSelectedColorValue: holder.selectedColorValue,
          intentBasketPrice: holder.basketPrice,
          intentBasketSelectedAttributeList: holder.basketSelectedAttributeList,
        );
      });

    case '${RoutePaths.filterExpantion}':
      final dynamic args = settings.arguments;

      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              FilterListView(selectedData: args));

    // case '${RoutePaths.commentList}':
    //   final Object args = settings.arguments;
    //   final Product product = args ?? Product;
    //   return PageRouteBuilder<dynamic>(
    //       pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
    //           CommentListView(product: product));

    // case '${RoutePaths.itemSearch}':
    //   final Object args = settings.arguments;
    //   final ProductParameterHolder productParameterHolder =
    //       args ?? ProductParameterHolder;
    //   return PageRouteBuilder<dynamic>(
    //       pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
    //           ItemSearchView(productParameterHolder: productParameterHolder));

    // case '${RoutePaths.itemSort}':
    //   final Object args = settings.arguments;
    //   final ProductParameterHolder productParameterHolder =
    //       args ?? ProductParameterHolder;
    //   return PageRouteBuilder<dynamic>(
    //       pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
    //           ItemSortingView(productParameterHolder: productParameterHolder));

    // case '${RoutePaths.commentDetail}':
    //   final Object args = settings.arguments;
    //   final CommentHeader commentHeader = args ?? CommentHeader;
    //   return PageRouteBuilder<dynamic>(
    //       pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
    //           CommentDetailListView(
    //             commentHeader: commentHeader,
    //           ));

    // case '${RoutePaths.favouriteProductList}':
    //   return PageRouteBuilder<dynamic>(
    //       pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
    //           TopSellingProductListContainerView());

    // case '${RoutePaths.collectionProductList}':
    //   return PageRouteBuilder<dynamic>(
    //       pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
    //           CollectionHeaderListContainerView());

    // case '${RoutePaths.productListByCollectionId}':
    //   final Object args = settings.arguments;
    //   final ProductListByCollectionIdView productCollectionIdView =
    //       args ?? ProductListByCollectionIdView;

    //   return PageRouteBuilder<dynamic>(
    //       pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
    //           ProductListByCollectionIdView(
    //             productCollectionHeader:
    //                 productCollectionIdView.productCollectionHeader,
    //             appBarTitle: productCollectionIdView.appBarTitle,
    //           ));

    // case '${RoutePaths.ratingList}':
    //   final Object args = settings.arguments;
    //   final String productDetailId = args ?? String;
    //   return PageRouteBuilder<dynamic>(
    //       pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
    //           RatingListView(productDetailid: productDetailId));

    // case '${RoutePaths.editProfile}':
    //   return PageRouteBuilder<dynamic>(
    //       pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
    //           EditProfileView());

    case '${RoutePaths.countryList}':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              CountryListView());
    case '${RoutePaths.cityList}':
      final Object args = settings.arguments;
      final String countryId = args ?? String;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              CityListView(countryId: countryId));

    case '${RoutePaths.galleryGrid}':
      final Object args = settings.arguments;
      final Product product = args ?? Product;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              GalleryGridView(product: product));

    case '${RoutePaths.galleryDetail}':
      final Object args = settings.arguments;
      final Gallery selectedDefaultImage = args ?? Gallery;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              GalleryView(selectedDefaultImage: selectedDefaultImage));

    // case '${RoutePaths.searchCategory}':
    //   return PageRouteBuilder<dynamic>(
    //       pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
    //           CategoryFilterListView());
    // case '${RoutePaths.searchSubCategory}':
    //   final Object args = settings.arguments;
    //   final String category = args ?? String;
    //   return PageRouteBuilder<dynamic>(
    //       pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
    //           SubCategorySearchListView(categoryId: category));

    case '${RoutePaths.basketList}':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              BasketListContainerView());

    case '${RoutePaths.checkout_container}':
      final Object args = settings.arguments;

      final CheckoutIntentHolder checkoutIntentHolder =
          args ?? CheckoutIntentHolder;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              CheckoutContainerView(
                basketList: checkoutIntentHolder.basketList,
              ));

    // case '${RoutePaths.trendingCategoryList}':
    //   return PageRouteBuilder<dynamic>(
    //       pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
    //           TrendingCategoryListView());

    // case '${RoutePaths.attributeDetailList}':
    //   final Object args = settings.arguments;
    //   final AttributeDetailIntentHolder attributeDetailIntentHolder =
    //       args ?? AttributeDetailIntentHolder;
    //   return PageRouteBuilder<dynamic>(
    //       pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
    //           AttributeDetailListView(
    //             attributeDetail: attributeDetailIntentHolder.attributeDetail,
    //             product: attributeDetailIntentHolder.product,
    //           ));

    default:
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              DashboardView());
  }
}
