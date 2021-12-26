import 'dart:async';
import 'package:dni_ecommerce/api/common/app_resource.dart';
import 'package:dni_ecommerce/api/common/app_status.dart';
import 'package:dni_ecommerce/provider/common/app_provider.dart';
import 'package:dni_ecommerce/repository/tansaction_detail_repository.dart';
import 'package:dni_ecommerce/utils/utils.dart';
import 'package:dni_ecommerce/viewobject/basket.dart';
import 'package:dni_ecommerce/viewobject/basket_selected_attribute.dart';
import 'package:dni_ecommerce/viewobject/common/app_value_holder.dart';
import 'package:dni_ecommerce/viewobject/transaction_detail.dart';
import 'package:dni_ecommerce/viewobject/transaction_header.dart';
import 'package:dni_ecommerce/viewobject/user.dart';
import 'package:flutter/material.dart';

class TransactionDetailProvider extends AppProvider {
  TransactionDetailProvider(
      {@required TransactionDetailRepository repo,
      this.appValueHolder,
      int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    print('Transaction Detail Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    transactionDetailListStream =
        StreamController<AppResource<List<TransactionDetail>>>.broadcast();
    subscription = transactionDetailListStream.stream
        .listen((AppResource<List<TransactionDetail>> resource) {
      updateOffset(resource.data.length);

      _transactionDetailList = resource;

      if (resource.status != AppStatus.BLOCK_LOADING &&
          resource.status != AppStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  TransactionDetailRepository _repo;
  AppValueHolder appValueHolder;

  AppResource<List<TransactionDetail>> _transactionDetailList =
      AppResource<List<TransactionDetail>>(
          AppStatus.NOACTION, '', <TransactionDetail>[]);

  AppResource<List<TransactionDetail>> get transactionDetailList =>
      _transactionDetailList;
  StreamSubscription<AppResource<List<TransactionDetail>>> subscription;
  StreamController<AppResource<List<TransactionDetail>>>
      transactionDetailListStream;
  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('Transaction Detail Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> addTransactionDetail(
      User user,
      List<Basket> basketList,
      String clientNonce,
      String couponDiscount,
      String taxAmount,
      String totalDiscount,
      String subTotalAmount,
      String shippingAmount,
      String balanceAmount,
      String totalItemAmount,
      String isCod,
      String isPaypal,
      String isStripe,
      String isBank,
      String isPayStack,
      String isRazor,
      String razorId,
      // String shippingMethodPrice,
      // String shippingMethodName,
      String selectedDays,
      String memoText,
      [String text]) async {
    isLoading = true;

    final List<String> attributeIdStr = <String>[];
    List<String> attributeNameStr = <String>[];
    final List<String> attributePriceStr = <String>[];
    String transactionId = '';
    transactionId += basketList[0].id;

    for (int i = 0; i < basketList.length; i++) {
      for (BasketSelectedAttribute basketSelectedAttribute
          in basketList[i].basketSelectedAttributeList) {
        attributeIdStr.add(basketSelectedAttribute.headerId);
        attributeNameStr.add(basketSelectedAttribute.name);
        attributePriceStr.add(basketSelectedAttribute.price);
      }

      final TransactionDetail transactionDetail = TransactionDetail(
          id: transactionId + basketList[i].productId,
          transactionsHeaderId: transactionId,
          productId: basketList[i].productId,
          productName: basketList[i].product.name,
          productAttributeId: attributeIdStr.join('#').toString(),
          productAttributeName: attributeNameStr.join('#').toString(),
          productAttributePrice: attributePriceStr.join('#').toString(),
          productColorId: basketList[i].selectedColorId ?? '',
          productColorCode: basketList[i].selectedColorValue ?? '',
          productSizeId: basketList[i].selectedSizeId ?? '',
          productSizeCode: basketList[i].selectedSizeValue ?? '',
          productUnit: basketList[i].product.unitPrice,
          originalPrice: basketList[i].basketOriginalPrice,
          discountValue: basketList[i].product.discountValue,
          discountAmount: basketList[i].product.discountAmount,
          qty: basketList[i].qty,
          discountPercent: Utils.calculateDiscountPercent(
                  basketList[i].product.originalPrice,
                  basketList[i].product.unitPrice)
              .toString(),
          currencyShortForm: basketList[i].product.currencyShortForm,
          currencySymbol: '\$',
          price: basketList[i].product.unitPrice,
          productMeasurement: basketList[i].product.productMeasurement,
          shippingCost: basketList[i].product.shippingCost,
          selectedDays: selectedDays);
      attributeNameStr = <String>[];
      // detailJson.add(transactionDetail.tojsonData());

      await _repo.addTransactionDetail(transactionDetailListStream,
          AppStatus.PROGRESS_LOADING, transactionDetail);
    }
  }

  Future<dynamic> loadTransactionDetailList(
      TransactionHeader transaction) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo.getAllTransactionDetailList(
        transactionDetailListStream,
        transaction,
        isConnectedToInternet,
        limit,
        offset,
        AppStatus.PROGRESS_LOADING);
  }

  Future<dynamic> nextTransactionDetailList(
      TransactionHeader transaction) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;
      await _repo.getNextPageTransactionDetailList(
          transactionDetailListStream,
          transaction,
          isConnectedToInternet,
          limit,
          offset,
          AppStatus.PROGRESS_LOADING);
    }
  }

  Future<void> resetTransactionDetailList(TransactionHeader transaction) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    await _repo.getAllTransactionDetailList(
        transactionDetailListStream,
        transaction,
        isConnectedToInternet,
        limit,
        offset,
        AppStatus.PROGRESS_LOADING);

    isLoading = false;
  }
}
