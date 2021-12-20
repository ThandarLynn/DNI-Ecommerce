import 'dart:async';

import 'package:dni_ecommerce/api/app_api_service.dart';
import 'package:dni_ecommerce/api/common/app_resource.dart';
import 'package:dni_ecommerce/api/common/app_status.dart';
import 'package:dni_ecommerce/constant/app_constant.dart';
import 'package:dni_ecommerce/db/top_rated_product_dao.dart';
import 'package:dni_ecommerce/db/top_selling_product_dao.dart';
import 'package:dni_ecommerce/db/product_dao.dart';
import 'package:dni_ecommerce/db/product_map_dao.dart';
import 'package:dni_ecommerce/repository/Common/app_repository.dart';
import 'package:dni_ecommerce/viewobject/common/api_status.dart';
import 'package:dni_ecommerce/viewobject/top_rated_product.dart';
import 'package:dni_ecommerce/viewobject/top_selling_product.dart';
import 'package:dni_ecommerce/viewobject/holder/product_parameter_holder.dart';
import 'package:dni_ecommerce/viewobject/product.dart';
import 'package:dni_ecommerce/viewobject/product_map.dart';
import 'package:flutter/material.dart';
import 'package:sembast/sembast.dart';

class ProductRepository extends AppRepository {
  ProductRepository(
      {@required AppApiService appApiService,
      @required ProductDao productDao}) {
    _appApiService = appApiService;
    _productDao = productDao;
  }
  String primaryKey = 'id';
  String mapKey = 'map_key';
  String collectionIdKey = 'collection_id';
  String mainProductIdKey = 'main_product_id';
  AppApiService _appApiService;
  ProductDao _productDao;

  void sinkProductListStream(
      StreamController<AppResource<List<Product>>> productListStream,
      AppResource<List<Product>> dataList) {
    if (dataList != null && productListStream != null) {
      productListStream.sink.add(dataList);
    }
  }

  void sinkTopSellingProductListStream(
      StreamController<AppResource<List<Product>>> favouriteProductListStream,
      AppResource<List<Product>> dataList) {
    if (dataList != null && favouriteProductListStream != null) {
      favouriteProductListStream.sink.add(dataList);
    }
  }

  void sinkCollectionProductListStream(
      StreamController<AppResource<List<Product>>> collectionProductListStream,
      AppResource<List<Product>> dataList) {
    if (dataList != null && collectionProductListStream != null) {
      collectionProductListStream.sink.add(dataList);
    }
  }

  void sinkProductDetailStream(
      StreamController<AppResource<Product>> productDetailStream,
      AppResource<Product> data) {
    if (data != null) {
      productDetailStream.sink.add(data);
    }
  }

  void sinkRelatedProductListStream(
      StreamController<AppResource<List<Product>>> relatedProductListStream,
      AppResource<List<Product>> dataList) {
    if (dataList != null && relatedProductListStream != null) {
      relatedProductListStream.sink.add(dataList);
    }
  }

  Future<dynamic> insert(Product product) async {
    return _productDao.insert(primaryKey, product);
  }

  Future<dynamic> update(Product product) async {
    return _productDao.update(product);
  }

  Future<dynamic> delete(Product product) async {
    return _productDao.delete(product);
  }

  Future<dynamic> getProductList(
      StreamController<AppResource<List<Product>>> productListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      AppStatus status,
      ProductParameterHolder holder,
      {bool isLoadFromServer = true}) async {
    // Prepare Holder and Map Dao
    final String paramKey = holder.getParamKey();
    final ProductMapDao productMapDao = ProductMapDao.instance;

    // Load from Db and Send to UI
    sinkProductListStream(
        productListStream,
        await _productDao.getAllByMap(
            primaryKey, mapKey, paramKey, productMapDao, ProductMap(),
            status: status));

    // Server Call
    if (isConnectedToInternet) {
      final AppResource<List<Product>> _resource =
          await _appApiService.getProductList(holder.toMap(), limit, offset);

      print('Param Key $paramKey');
      if (_resource.status == AppStatus.SUCCESS) {
        // Create Map List
        final List<ProductMap> productMapList = <ProductMap>[];
        int i = 0;
        for (Product data in _resource.data) {
          productMapList.add(ProductMap(
              id: data.id + paramKey,
              mapKey: paramKey,
              productId: data.id,
              sorting: i++,
              addedDate: '2019'));
        }

        // Delete and Insert Map Dao
        print('Delete Key $paramKey');
        await productMapDao
            .deleteWithFinder(Finder(filter: Filter.equals(mapKey, paramKey)));
        print('Insert All Key $paramKey');
        await productMapDao.insertAll(primaryKey, productMapList);

        // Insert Product
        await _productDao.insertAll(primaryKey, _resource.data);
      } else {
        if (_resource.errorCode == AppConst.ERROR_CODE_10001) {
          await productMapDao.deleteWithFinder(
              Finder(filter: Filter.equals(mapKey, paramKey)));
        }
      }

      // Load updated Data from Db and Send to UI
      sinkProductListStream(
          productListStream,
          await _productDao.getAllByMap(
              primaryKey, mapKey, paramKey, productMapDao, ProductMap()));
    }
  }

  Future<dynamic> getNextPageProductList(
      StreamController<AppResource<List<Product>>> productListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      AppStatus status,
      ProductParameterHolder holder,
      {bool isLoadFromServer = true}) async {
    final String paramKey = holder.getParamKey();
    final ProductMapDao productMapDao = ProductMapDao.instance;
    // Load from Db and Send to UI
    sinkProductListStream(
        productListStream,
        await _productDao.getAllByMap(
            primaryKey, mapKey, paramKey, productMapDao, ProductMap(),
            status: status));
    if (isConnectedToInternet) {
      final AppResource<List<Product>> _resource =
          await _appApiService.getProductList(holder.toMap(), limit, offset);

      if (_resource.status == AppStatus.SUCCESS) {
        // Create Map List
        final List<ProductMap> productMapList = <ProductMap>[];
        final AppResource<List<ProductMap>> existingMapList =
            await productMapDao.getAll(
                finder: Finder(filter: Filter.equals(mapKey, paramKey)));

        int i = 0;
        if (existingMapList != null) {
          i = existingMapList.data.length + 1;
        }
        for (Product data in _resource.data) {
          productMapList.add(ProductMap(
              id: data.id + paramKey,
              mapKey: paramKey,
              productId: data.id,
              sorting: i++,
              addedDate: '2019'));
        }

        await productMapDao.insertAll(primaryKey, productMapList);

        // Insert Product
        await _productDao.insertAll(primaryKey, _resource.data);
      }
      sinkProductListStream(
          productListStream,
          await _productDao.getAllByMap(
              primaryKey, mapKey, paramKey, productMapDao, ProductMap()));
    }
  }

  Future<dynamic> getProductDetail(
      StreamController<AppResource<Product>> productDetailStream,
      String productId,
      String loginUserId,
      bool isConnectedToInternet,
      AppStatus status,
      {bool isLoadFromServer = true}) async {
    final Finder finder = Finder(filter: Filter.equals(primaryKey, productId));
    sinkProductDetailStream(productDetailStream,
        await _productDao.getOne(status: status, finder: finder));

    if (isConnectedToInternet) {
      final AppResource<Product> _resource =
          await _appApiService.getProductDetail(productId, loginUserId);

      if (_resource.status == AppStatus.SUCCESS) {
        await _productDao.deleteWithFinder(finder);
        await _productDao.insert(primaryKey, _resource.data);
      } else {
        if (_resource.errorCode == AppConst.ERROR_CODE_10001) {
          await _productDao.deleteWithFinder(finder);
        }
      }
      sinkProductDetailStream(
          productDetailStream, await _productDao.getOne(finder: finder));
    }
  }

  Future<dynamic> getProductDetailForFav(
      StreamController<AppResource<Product>> productDetailStream,
      String productId,
      String loginUserId,
      bool isConnectedToInternet,
      AppStatus status,
      {bool isLoadFromServer = true}) async {
    final Finder finder = Finder(filter: Filter.equals(primaryKey, productId));

    if (isConnectedToInternet) {
      final AppResource<Product> _resource =
          await _appApiService.getProductDetail(productId, loginUserId);

      if (_resource.status == AppStatus.SUCCESS) {
        await _productDao.deleteWithFinder(finder);
        await _productDao.insert(primaryKey, _resource.data);
      } else {
        if (_resource.errorCode == AppConst.ERROR_CODE_10001) {
          await _productDao.deleteWithFinder(finder);
        }
      }
      sinkProductDetailStream(
          productDetailStream, await _productDao.getOne(finder: finder));
    }
  }

  // Future<AppResource<List<DownloadProduct>>> postDownloadProductList(
  //     Map<dynamic, dynamic> jsonMap,
  //     bool isConnectedToInternet,
  //     AppStatus status,
  //     {bool isLoadFromServer = true}) async {
  //   final AppResource<List<DownloadProduct>> _resource =
  //       await _appApiService.postDownloadProductList(jsonMap);
  //   if (_resource.status == AppStatus.SUCCESS) {
  //     return _resource;
  //   } else {
  //     final Completer<AppResource<List<DownloadProduct>>> completer =
  //         Completer<AppResource<List<DownloadProduct>>>();
  //     completer.complete(_resource);
  //     return completer.future;
  //   }
  // }

  Future<dynamic> getTopSellingProductList(
      StreamController<AppResource<List<Product>>> favouriteProductListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      AppStatus status,
      {bool isLoadFromServer = true}) async {
    // Prepare Holder and Map Dao
    // final String paramKey = holder.getParamKey();
    final TopSellingProductDao favouriteProductDao =
        TopSellingProductDao.instance;

    // Load from Db and Send to UI
    sinkTopSellingProductListStream(
        favouriteProductListStream,
        await _productDao.getAllByJoin(
            primaryKey, favouriteProductDao, TopSellingProduct(),
            status: status));

    // Server Call
    if (isConnectedToInternet) {
      final AppResource<List<Product>> _resource =
          await _appApiService.getTopSellingProductList(limit, offset);

      if (_resource.status == AppStatus.SUCCESS) {
        // Create Map List
        final List<TopSellingProduct> favouriteProductMapList =
            <TopSellingProduct>[];
        int i = 0;
        for (Product data in _resource.data) {
          favouriteProductMapList.add(TopSellingProduct(
            id: data.id,
            sorting: i++,
          ));
        }

        // Delete and Insert Map Dao
        await favouriteProductDao.deleteAll();
        await favouriteProductDao.insertAll(
            primaryKey, favouriteProductMapList);
        // Insert Product
        await _productDao.insertAll(primaryKey, _resource.data);
      } else {
        if (_resource.errorCode == AppConst.ERROR_CODE_10001) {
          await favouriteProductDao.deleteAll();
        }
      }

      // Load updated Data from Db and Send to UI
      sinkTopSellingProductListStream(
          favouriteProductListStream,
          await _productDao.getAllByJoin(
              primaryKey, favouriteProductDao, TopSellingProduct()));
    }
  }

  Future<dynamic> getNextPageTopSellingProductList(
      StreamController<AppResource<List<Product>>> favouriteProductListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      AppStatus status,
      {bool isLoadFromServer = true}) async {
    final TopSellingProductDao favouriteProductDao =
        TopSellingProductDao.instance;
    // Load from Db and Send to UI
    sinkTopSellingProductListStream(
        favouriteProductListStream,
        await _productDao.getAllByJoin(
            primaryKey, favouriteProductDao, TopSellingProduct(),
            status: status));

    if (isConnectedToInternet) {
      final AppResource<List<Product>> _resource =
          await _appApiService.getTopSellingProductList(limit, offset);

      if (_resource.status == AppStatus.SUCCESS) {
        // Create Map List
        final List<TopSellingProduct> favouriteProductMapList =
            <TopSellingProduct>[];
        final AppResource<List<TopSellingProduct>> existingMapList =
            await favouriteProductDao.getAll();

        int i = 0;
        if (existingMapList != null) {
          i = existingMapList.data.length + 1;
        }
        for (Product data in _resource.data) {
          favouriteProductMapList.add(TopSellingProduct(
            id: data.id,
            sorting: i++,
          ));
        }

        await favouriteProductDao.insertAll(
            primaryKey, favouriteProductMapList);

        // Insert Product
        await _productDao.insertAll(primaryKey, _resource.data);
      }
      sinkTopSellingProductListStream(
          favouriteProductListStream,
          await _productDao.getAllByJoin(
              primaryKey, favouriteProductDao, TopSellingProduct()));
    }
  }

  //top rated product
  Future<dynamic> getTopRatedProductList(
      StreamController<AppResource<List<Product>>> favouriteProductListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      AppStatus status,
      {bool isLoadFromServer = true}) async {
    // Prepare Holder and Map Dao
    // final String paramKey = holder.getParamKey();
    final TopRatedProductDao topRatedProductDao = TopRatedProductDao.instance;

    // Load from Db and Send to UI
    sinkTopSellingProductListStream(
        favouriteProductListStream,
        await _productDao.getAllByJoin(
            primaryKey, topRatedProductDao, TopRatedProduct(),
            status: status));

    // Server Call
    if (isConnectedToInternet) {
      final AppResource<List<Product>> _resource =
          await _appApiService.getTopRatedProductList(limit, offset);

      if (_resource.status == AppStatus.SUCCESS) {
        // Create Map List
        final List<TopRatedProduct> favouriteProductMapList =
            <TopRatedProduct>[];
        int i = 0;
        for (Product data in _resource.data) {
          favouriteProductMapList.add(TopRatedProduct(
            id: data.id,
            sorting: i++,
          ));
        }

        // Delete and Insert Map Dao
        await topRatedProductDao.deleteAll();
        await topRatedProductDao.insertAll(primaryKey, favouriteProductMapList);
        // Insert Product
        await _productDao.insertAll(primaryKey, _resource.data);
      } else {
        if (_resource.errorCode == AppConst.ERROR_CODE_10001) {
          await topRatedProductDao.deleteAll();
        }
      }

      // Load updated Data from Db and Send to UI
      sinkTopSellingProductListStream(
          favouriteProductListStream,
          await _productDao.getAllByJoin(
              primaryKey, topRatedProductDao, TopRatedProduct()));
    }
  }

  Future<dynamic> getNextPageTopRatedProductList(
      StreamController<AppResource<List<Product>>> favouriteProductListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      AppStatus status,
      {bool isLoadFromServer = true}) async {
    final TopRatedProductDao topRatedProductDao = TopRatedProductDao.instance;
    // Load from Db and Send to UI
    sinkTopSellingProductListStream(
        favouriteProductListStream,
        await _productDao.getAllByJoin(
            primaryKey, topRatedProductDao, TopRatedProduct(),
            status: status));

    if (isConnectedToInternet) {
      final AppResource<List<Product>> _resource =
          await _appApiService.getTopRatedProductList(limit, offset);

      if (_resource.status == AppStatus.SUCCESS) {
        // Create Map List
        final List<TopRatedProduct> favouriteProductMapList =
            <TopRatedProduct>[];
        final AppResource<List<TopRatedProduct>> existingMapList =
            await topRatedProductDao.getAll();

        int i = 0;
        if (existingMapList != null) {
          i = existingMapList.data.length + 1;
        }
        for (Product data in _resource.data) {
          favouriteProductMapList.add(TopRatedProduct(
            id: data.id,
            sorting: i++,
          ));
        }

        await topRatedProductDao.insertAll(primaryKey, favouriteProductMapList);

        // Insert Product
        await _productDao.insertAll(primaryKey, _resource.data);
      }
      sinkTopSellingProductListStream(
          favouriteProductListStream,
          await _productDao.getAllByJoin(
              primaryKey, topRatedProductDao, TopRatedProduct()));
    }
  }

  Future<AppResource<ApiStatus>> postTouchCount(Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet, AppStatus status,
      {bool isLoadFromServer = true}) async {
    final AppResource<ApiStatus> _resource =
        await _appApiService.postTouchCount(jsonMap);
    if (_resource.status == AppStatus.SUCCESS) {
      return _resource;
    } else {
      final Completer<AppResource<ApiStatus>> completer =
          Completer<AppResource<ApiStatus>>();
      completer.complete(_resource);
      return completer.future;
    }
  }

  // Future<dynamic> getRelatedProductList(
  //     StreamController<AppResource<List<Product>>> relatedProductListStream,
  //     String productId,
  //     String categoryId,
  //     bool isConnectedToInternet,
  //     int limit,
  //     int offset,
  //     AppStatus status,
  //     {bool isLoadFromServer = true}) async {
  //   // Prepare Holder and Map Dao
  //   // final String paramKey = holder.getParamKey();
  //   final Finder finder =
  //       Finder(filter: Filter.equals(mainProductIdKey, productId));
  //   final RelatedProductDao relatedProductDao = RelatedProductDao.instance;

  //   // Load from Db and Send to UI

  //   sinkCollectionProductListStream(
  //       relatedProductListStream,
  //       await _productDao.getAllDataListWithFilterId(
  //           productId, mainProductIdKey, relatedProductDao, RelatedProduct(),
  //           status: status));

  //   // Server Call
  //   if (isConnectedToInternet) {
  //     final AppResource<List<Product>> _resource = await _appApiService
  //         .getRelatedProductList(productId, categoryId, limit, offset);

  //     if (_resource.status == AppStatus.SUCCESS) {
  //       // Create Map List
  //       final List<RelatedProduct> relatedProductMapList = <RelatedProduct>[];
  //       int i = 0;
  //       for (Product data in _resource.data) {
  //         relatedProductMapList.add(RelatedProduct(
  //           id: data.id,
  //           mainProductId: productId,
  //           sorting: i++,
  //         ));
  //       }

  //       // Delete and Insert Map Dao
  //       // await relatedProductDao.deleteAll();
  //       await relatedProductDao.deleteWithFinder(finder);
  //       await relatedProductDao.insertAll(primaryKey, relatedProductMapList);

  //       // Insert Product
  //       await _productDao.insertAll(primaryKey, _resource.data);

  //       // Load updated Data from Db and Send to UI
  //     } else {
  //       if (_resource.errorCode == AppConst.ERROR_CODE_10001) {
  //         await relatedProductDao.deleteWithFinder(finder);
  //       }
  //     }
  //     sinkCollectionProductListStream(
  //         relatedProductListStream,
  //         await _productDao.getAllDataListWithFilterId(
  //             productId, mainProductIdKey, relatedProductDao, RelatedProduct(),
  //             status: status));
  //   }
  // }

  // ///Product list By Collection Id

  // Future<dynamic> getAllproductListByCollectionId(
  //     StreamController<AppResource<List<Product>>> productCollectionStream,
  //     bool isConnectedToInternet,
  //     String collectionId,
  //     int limit,
  //     int offset,
  //     AppStatus status,
  //     {bool isLoadFromServer = true}) async {
  //   final Finder finder =
  //       Finder(filter: Filter.equals(collectionIdKey, collectionId));
  //   final ProductCollectionDao productCollectionDao =
  //       ProductCollectionDao.instance;

  //   // Load from Db and Send to UI
  //   sinkCollectionProductListStream(
  //       productCollectionStream,
  //       await _productDao.getAllDataListWithFilterId(collectionId,
  //           collectionIdKey, productCollectionDao, ProductCollection(),
  //           status: status));

  //   // Server Call
  //   if (isConnectedToInternet) {
  //     final AppResource<List<Product>> _resource = await _appApiService
  //         .getProductListByCollectionId(collectionId, limit, offset);

  //     if (_resource.status == AppStatus.SUCCESS) {
  //       // Create Map List
  //       final List<ProductCollection> productCollectionMapList =
  //           <ProductCollection>[];
  //       int i = 0;
  //       for (Product data in _resource.data) {
  //         productCollectionMapList.add(ProductCollection(
  //           id: data.id,
  //           collectionId: collectionId,
  //           sorting: i++,
  //         ));
  //       }

  //       // Delete and Insert Map Dao
  //       await productCollectionDao.deleteWithFinder(finder);
  //       await productCollectionDao.insertAll(
  //           primaryKey, productCollectionMapList);

  //       // Insert Product
  //       await _productDao.insertAll(primaryKey, _resource.data);
  //     } else {
  //       if (_resource.errorCode == AppConst.ERROR_CODE_10001) {
  //         await productCollectionDao.deleteWithFinder(finder);
  //       }
  //     }
  //     // Load updated Data from Db and Send to UI

  //     sinkCollectionProductListStream(
  //         productCollectionStream,
  //         await _productDao.getAllDataListWithFilterId(collectionId,
  //             collectionIdKey, productCollectionDao, ProductCollection()));

  //     Utils.psPrint('End of Collection Product');
  //   }
  // }

  // Future<dynamic> getNextPageproductListByCollectionId(
  //     StreamController<AppResource<List<Product>>> productCollectionStream,
  //     bool isConnectedToInternet,
  //     String collectionId,
  //     int limit,
  //     int offset,
  //     AppStatus status,
  //     {bool isLoadFromServer = true}) async {
  //   final Finder finder =
  //       Finder(filter: Filter.equals('collection_id', collectionId));
  //   final ProductCollectionDao productCollectionDao =
  //       ProductCollectionDao.instance;
  //   // Load from Db and Send to UI
  //   sinkCollectionProductListStream(
  //       productCollectionStream,
  //       await _productDao.getAllDataListWithFilterId(collectionId,
  //           collectionIdKey, productCollectionDao, ProductCollection(),
  //           status: status));

  //   if (isConnectedToInternet) {
  //     final AppResource<List<Product>> _resource = await _appApiService
  //         .getProductListByCollectionId(collectionId, limit, offset);

  //     if (_resource.status == AppStatus.SUCCESS) {
  //       // Create Map List
  //       final List<ProductCollection> productCollectionMapList =
  //           <ProductCollection>[];
  //       final AppResource<List<ProductCollection>> existingMapList =
  //           await productCollectionDao.getAll(finder: finder);

  //       int i = 0;
  //       if (existingMapList != null) {
  //         i = existingMapList.data.length + 1;
  //       }
  //       for (Product data in _resource.data) {
  //         productCollectionMapList.add(ProductCollection(
  //           id: data.id,
  //           collectionId: collectionId,
  //           sorting: i++,
  //         ));
  //       }

  //       await productCollectionDao.insertAll(
  //           primaryKey, productCollectionMapList);

  //       // Insert Product
  //       await _productDao.insertAll(primaryKey, _resource.data);
  //     }
  //     sinkCollectionProductListStream(
  //         productCollectionStream,
  //         await _productDao.getAllDataListWithFilterId(collectionId,
  //             collectionIdKey, productCollectionDao, ProductCollection()));
  //     Utils.psPrint('End of Collection Product');
  //   }
  // }

}
