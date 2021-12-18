// import 'dart:async';
// import 'package:dni_ecommerce/repository/product_repository.dart';
// import 'package:dni_ecommerce/utils/utils.dart';
// import 'package:dni_ecommerce/viewobject/common/app_value_holder.dart';
// import 'package:dni_ecommerce/viewobject/product.dart';
// import 'package:flutter/material.dart';
// import 'package:dni_ecommerce/api/common/app_resource.dart';
// import 'package:dni_ecommerce/api/common/app_status.dart';
// import 'package:dni_ecommerce/provider/common/app_provider.dart';

// class TopNewProductProvider extends AppProvider {
//   TopNewProductProvider(
//       {@required ProductRepository repo,
//       @required this.psValueHolder,
//       int limit = 0})
//       : super(repo, limit) {
//     _repo = repo;
//     print('TopNewProductProvider : $hashCode');

//     Utils.checkInternetConnectivity().then((bool onValue) {
//       isConnectedToInternet = onValue;
//     });
//     relatedProductListStream =
//         StreamController<AppResource<List<Product>>>.broadcast();
//     subscription = relatedProductListStream.stream
//         .listen((AppResource<List<Product>> resource) {
//       updateOffset(resource.data.length);

//       _relatedProductList = Utils.removeDuplicateObj<Product>(resource);

//       if (resource.status != AppStatus.BLOCK_LOADING &&
//           resource.status != AppStatus.PROGRESS_LOADING) {
//         isLoading = false;
//       }

//       if (!isDispose) {
//         notifyListeners();
//       }
//     });
//   }

//   AppValueHolder psValueHolder;
//   ProductRepository _repo;

//   AppResource<List<Product>> _relatedProductList =
//       AppResource<List<Product>>(AppStatus.NOACTION, '', <Product>[]);

//   AppResource<List<Product>> get relatedProductList => _relatedProductList;
//   StreamSubscription<AppResource<List<Product>>> subscription;
//   StreamController<AppResource<List<Product>>> relatedProductListStream;

//   @override
//   void dispose() {
//     subscription.cancel();
//     print('Related Provider Dispose: $hashCode');
//     super.dispose();
//   }

//   Future<dynamic> loadRelatedProductList(
//     String productId,
//     String categoryId,
//   ) async {
//     isLoading = true;

//     limit = 10;
//     offset = 0;

//     isConnectedToInternet = await Utils.checkInternetConnectivity();
//     await _repo.getRelatedProductList(
//         relatedProductListStream,
//         productId,
//         categoryId,
//         isConnectedToInternet,
//         limit,
//         offset,
//         AppStatus.PROGRESS_LOADING);
//   }
// }
