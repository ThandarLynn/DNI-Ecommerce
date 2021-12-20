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
import 'package:dni_ecommerce/viewobject/category.dart';
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
import 'package:dni_ecommerce/ui/subcategory/sub_category_grid_view.dart';
import 'package:dni_ecommerce/ui/user/register/register_container_view.dart';

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

    case '${RoutePaths.login_container}':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              LoginContainerView());

    case '${RoutePaths.subCategoryGrid}':
      return MaterialPageRoute<Category>(builder: (BuildContext context) {
        final Object args = settings.arguments;
        final Category category = args ?? Category;
        return SubCategoryGridView(category: category);
      });

    case '${RoutePaths.user_forgot_password_container}':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              ForgotPasswordContainerView());

    case '${RoutePaths.user_update_password}':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              ChangePasswordView());

    case '${RoutePaths.user_register_container}':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              RegisterContainerView());

    case '${RoutePaths.reset_password}':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        final Object args = settings.arguments;
        final String userToken = args ?? String;
        return ResetPasswordView(userToken: userToken);
      });

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

    case '${RoutePaths.transactionList}':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              TransactionListContainerView());

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
          intentSelectedSizeId: holder.selectedSizeId,
          intentSelectedSizeValue: holder.selectedSizeValue,
          intentBasketPrice: holder.basketPrice,
          intentBasketSelectedAttributeList: holder.basketSelectedAttributeList,
        );
      });

    case '${RoutePaths.filterExpantion}':
      final dynamic args = settings.arguments;

      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              FilterListView(selectedData: args));

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

    default:
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              DashboardView());
  }
}
