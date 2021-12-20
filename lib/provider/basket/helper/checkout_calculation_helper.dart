import 'package:dni_ecommerce/config/app_config.dart';
import 'package:dni_ecommerce/constant/app_constant.dart';
import 'package:dni_ecommerce/viewobject/basket.dart';
import 'package:dni_ecommerce/viewobject/common/app_value_holder.dart';
import 'package:flutter/material.dart';

class CheckoutCalculationHelper {
  CheckoutCalculationHelper();
  int totalItemCount = 0;
  double subTotalPrice = 0.00;
  String subTotalPriceFormattedString = '';
  double totalDiscount = 0.00;
  String totalDiscountFormattedString = '';
  double couponDiscount = 0.00;
  String couponDiscountFormattedString = '';
  double tax = 0.00;
  String taxFormattedString = '';
  double shippingTax = 0.00;
  String shippingTaxFormattedString = '';
  double shippingCost = 0.00;
  String shippingCostFormattedString = '';
  double totalPrice = 0.00;
  String totalPriceFormattedString = '';
  double totalOriginalPrice = 0.00;
  String totalOriginalPriceFormattedString = '';

  void reset() {
    totalItemCount = 0;
    subTotalPrice = 0.00;
    subTotalPriceFormattedString = '';
    totalDiscount = 0.00;
    totalDiscountFormattedString = '';
    couponDiscount = 0.00;
    couponDiscountFormattedString = '';
    tax = 0.00;
    taxFormattedString = '';
    shippingTax = 0.00;
    shippingTaxFormattedString = '';
    totalPrice = 0.00;
    totalPriceFormattedString = '';
    totalOriginalPrice = 0.00;
    totalOriginalPriceFormattedString = '';
  }

  void calculate(
      {@required List<Basket> basketList,
      @required String couponDiscountString,
      @required AppValueHolder appValueHolder,
      @required String shippingPriceStringFormatting}) {
    // reset Data
    reset();

    //  Product Discount and Product Original Price Calculation and  Product Count
    if (basketList.isNotEmpty) {
      for (Basket basket in basketList) {
        //Product Original Price Calculation
        totalOriginalPrice +=
            double.parse(basket.basketOriginalPrice) * double.parse(basket.qty);

        // Items Total Discount Calculation
        totalDiscount = totalDiscount +
            double.parse(basket.product.unitPrice) -
            double.parse(basket.product.originalPrice);
        double.parse(basket.qty);

        totalItemCount += int.parse(basket.qty);
      }
      // Product Count Calculation

      // SubTotal Calculation
      subTotalPrice = totalOriginalPrice - totalDiscount;

      // Coupon Discount Calculation
      // subTotalPrice - coupondiscount = subTotalPrice  after coupon discount
      if (couponDiscountString != null &&
          couponDiscountString != '-' &&
          couponDiscountString != '') {
        couponDiscount = double.parse(couponDiscountString);
        subTotalPrice = subTotalPrice - couponDiscount;
      }

      // Tax Calculation
      // subTotalPrice * Tax Percentage = Tax Amount
      if (appValueHolder.overAllTaxLabel != '0') {
        tax = subTotalPrice * double.parse(AppConfig.overTaxValue);
      }

      if (shippingPriceStringFormatting != '0.0') {
        shippingCost = double.parse(shippingPriceStringFormatting);
        // Shipping Cost Calculation
        // shippingCost * Shipping Cost Percentage = Shipping Cost Amount
        if (appValueHolder.shippingTaxLabel != '0' && shippingCost != 0.0) {
          shippingTax =
              shippingCost * double.parse(appValueHolder.shippingTaxValue);
        }
      } else {
        shippingCost = 0.0;
        shippingTax = 0.0;
      }

      // Total Payable Amount
      //  subTotalPrice + Tax Amount  + shippingTax Amount + shippingCost Amount  + shippingTax Amount = Total
      totalPrice = subTotalPrice + tax + shippingTax + shippingCost;

      // Formatted String
      // - Total Product Original Price
      // - Total Discount Amount
      // - Coupon Discount Amount
      // - Sub Total Price
      // - Tax Amount
      // - Total Payable
      totalOriginalPriceFormattedString =
          getPriceFormat(totalOriginalPrice.toString());
      totalDiscountFormattedString = getPriceFormat(totalDiscount.toString());
      couponDiscountFormattedString = getPriceFormat(couponDiscount.toString());
      subTotalPriceFormattedString = getPriceFormat(subTotalPrice.toString());
      taxFormattedString = getPriceFormat(tax.toString());
      shippingTaxFormattedString = getPriceFormat(shippingTax.toString());
      shippingCostFormattedString = getPriceFormat(shippingCost.toString());
      totalPriceFormattedString = getPriceFormat(totalPrice.toString());
    }
  }
}

String getPriceFormat(String price) {
  // final NumberFormat AppConst.psFormat = NumberFormat('###.00');
  return AppConst.numberFormat.format(double.parse(price));
}
