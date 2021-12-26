import 'dart:core';
import 'common/app_object.dart';

class TransactionHeader extends AppObject<TransactionHeader> {
  TransactionHeader(
      {this.id,
      this.userId,
      this.selectedDays,
      this.subTotalAmount,
      this.discountAmount,
      this.balanceAmount,
      this.cuponDiscountAmount,
      this.taxAmount,
      this.taxPercent,
      this.shippingAmount,
      this.shippingTaxPercent,
      this.shippingMethodAmount,
      this.shippingMethodName,
      this.totalItemAmount,
      this.totalItemCount,
      this.contactName,
      this.contactPhone,
      this.paymentMethod,
      this.addedDate,
      this.addedUserId,
      this.updatedDate,
      this.updatedUserId,
      this.updatedFlag,
      this.transStatusId,
      this.currencySymbol,
      this.currencyShortForm,
      this.transCode,
      this.billingFirstName,
      this.billingLastName,
      this.billingCompany,
      this.billingAddress1,
      this.billingAddress2,
      this.billingCountry,
      this.billingState,
      this.billingCity,
      this.billingPostalCode,
      this.billingEmail,
      this.billingPhone,
      this.shippingFirstName,
      this.shippingLastName,
      this.shippingCompany,
      this.shippingAddress1,
      this.shippingAddress2,
      this.shippingCountry,
      this.shippingState,
      this.shippingCity,
      this.shippingPostalCode,
      this.shippingEmail,
      this.shippingPhone,
      this.isZoneShipping,
      this.addedDateStr,
      this.transStatusTitle});

  String id;
  String userId;
  String selectedDays;
  String subTotalAmount;
  String discountAmount;
  String balanceAmount;
  String cuponDiscountAmount;
  String taxAmount;
  String taxPercent;
  String shippingAmount;
  String shippingTaxPercent;
  String shippingMethodAmount;
  String shippingMethodName;
  String totalItemAmount;
  String totalItemCount;
  String contactName;
  String contactPhone;
  String paymentMethod;
  String addedDate;
  String addedUserId;
  String updatedDate;
  String updatedUserId;
  String updatedFlag;
  String transStatusId;
  String currencySymbol;
  String currencyShortForm;
  String transCode;
  String billingFirstName;
  String billingLastName;
  String billingCompany;
  String billingAddress1;
  String billingAddress2;
  String billingCountry;
  String billingState;
  String billingCity;
  String billingPostalCode;
  String billingEmail;
  String billingPhone;
  String shippingFirstName;
  String shippingLastName;
  String shippingCompany;
  String shippingAddress1;
  String shippingAddress2;
  String shippingCountry;
  String shippingState;
  String shippingCity;
  String shippingPostalCode;
  String shippingEmail;
  String shippingPhone;
  String isZoneShipping;
  String addedDateStr;
  String transStatusTitle;

  @override
  String getPrimaryKey() {
    return id;
  }

  @override
  TransactionHeader fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return TransactionHeader(
          id: dynamicData['order_id'],
          userId: dynamicData['user_id'],
          selectedDays: dynamicData['selected_days'],
          subTotalAmount: dynamicData['subtotal'],
          discountAmount: dynamicData['discount'],
          balanceAmount: dynamicData['total'],
          taxAmount: dynamicData['tax'],
          taxPercent: dynamicData['tax_percent'],
          shippingAmount: dynamicData['shipping_amount'],
          shippingTaxPercent: dynamicData['shipping_tax_percent'],
          shippingMethodAmount: dynamicData['shipping_method_amount'],
          shippingMethodName: dynamicData['shipping_method_name'],
          totalItemAmount: dynamicData['total_item_amount'],
          totalItemCount: dynamicData['total_item_count'],
          contactName: dynamicData['contact_name'],
          cuponDiscountAmount: dynamicData['coupon_discount_amount'],
          contactPhone: dynamicData['mobile'],
          paymentMethod: dynamicData['payment_method'],
          addedDate: dynamicData['order_date'],
          addedUserId: dynamicData['added_user_id'],
          updatedDate: dynamicData['updated_date'],
          updatedUserId: dynamicData['updated_user_id'],
          updatedFlag: dynamicData['updated_flag'],
          transStatusId: dynamicData['trans_status_id'],
          currencySymbol: dynamicData['currency_symbol'],
          currencyShortForm: dynamicData['currency_short_form'],
          transCode: dynamicData['trans_code'],
          billingFirstName: dynamicData['first_name'],
          billingLastName: dynamicData['last_name'],
          billingCompany: dynamicData['billing_company'],
          billingAddress1: dynamicData['billing_address_1'],
          billingAddress2: dynamicData['billing_address_2'],
          billingCountry: dynamicData['billing_country'],
          billingState: dynamicData['billing_state'],
          billingCity: dynamicData['billing_city'],
          billingPostalCode: dynamicData['billing_postal_code'],
          billingEmail: dynamicData['billing_email'],
          billingPhone: dynamicData['billing_phone'],
          shippingFirstName: dynamicData['billing_first_name'],
          shippingLastName: dynamicData['shipping_last_name'],
          shippingCompany: dynamicData['shipping_company'],
          shippingAddress1: dynamicData['shipping_address_1'],
          shippingAddress2: dynamicData['shipping_address_2'],
          shippingCountry: dynamicData['shipping_country'],
          shippingState: dynamicData['shipping_state'],
          shippingCity: dynamicData['shipping_city'],
          shippingPostalCode: dynamicData['shipping_postal_code'],
          shippingEmail: dynamicData['shipping_email'],
          shippingPhone: dynamicData['shipping_phone'],
          isZoneShipping: dynamicData['is_zone_shipping'],
          addedDateStr: dynamicData['added_date_str'],
          transStatusTitle: dynamicData['status']);
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(dynamic object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['order_id'] = object.id;
      data['user_id'] = object.userId;
      data['selected_days'] = object.selectedDays;
      data['subtotal'] = object.subTotalAmount;
      data['discount'] = object.discountAmount;
      data['total'] = object.balanceAmount;
      data['coupon_discount_amount'] = object.cuponDiscountAmount;
      data['tax'] = object.taxAmount;
      data['tax_percent'] = object.taxPercent;
      data['shipping_amount'] = object.shippingAmount;
      data['shipping_tax_percent'] = object.shippingTaxPercent;
      data['shipping_method_amount'] = object.shippingMethodAmount;
      data['shipping_method_name'] = object.shippingMethodName;
      data['total_item_amount'] = object.totalItemAmount;
      data['total_item_count'] = object.totalItemCount;
      data['contact_name'] = object.contactName;
      data['mobile'] = object.contactPhone;
      data['payment_method'] = object.paymentMethod;
      data['order_date'] = object.addedDate;
      data['added_user_id'] = object.addedUserId;
      data['updated_date'] = object.updatedDate;
      data['updated_user_id'] = object.updatedUserId;
      data['updated_flag'] = object.updatedFlag;
      data['trans_status_id'] = object.transStatusId;
      data['currency_symbol'] = object.currencySymbol;
      data['currency_short_form'] = object.currencyShortForm;
      data['trans_code'] = object.transCode;
      data['first_name'] = object.billingFirstName;
      data['last_name'] = object.billingLastName;
      data['billing_company'] = object.billingCompany;
      data['billing_address_1'] = object.billingAddress1;
      data['billing_address_2'] = object.billingAddress1;
      data['billing_country'] = object.billingCountry;
      data['billing_state'] = object.billingState;
      data['billing_city'] = object.billingCity;
      data['billing_postal_code'] = object.billingPostalCode;
      data['email'] = object.billingEmail;
      data['billing_phone'] = object.billingPhone;
      data['shipping_first_name'] = object.shippingFirstName;
      data['shipping_last_name'] = object.shippingLastName;
      data['shipping_company'] = object.shippingCompany;
      data['shipping_address_1'] = object.shippingAddress1;
      data['shipping_address_2'] = object.shippingAddress2;
      data['shipping_country'] = object.shippingCountry;
      data['shipping_state'] = object.shippingState;
      data['shipping_city'] = object.shippingCity;
      data['shipping_postal_code'] = object.shippingPostalCode;
      data['shipping_email'] = object.shippingEmail;
      data['shipping_phone'] = object.shippingPhone;
      data['is_zone_shipping'] = object.isZoneShipping;
      data['added_date_str'] = object.addedDateStr;
      data['status'] = object.transStatusTitle;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<TransactionHeader> fromMapList(List<dynamic> dynamicDataList) {
    final List<TransactionHeader> subCategoryList = <TransactionHeader>[];

    if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          subCategoryList.add(fromMap(dynamicData));
        }
      }
    }
    return subCategoryList;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<TransactionHeader> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (TransactionHeader data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }

    return mapList;
  }
}
