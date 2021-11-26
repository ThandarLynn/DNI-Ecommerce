import 'dart:async';
import 'package:dni_ecommerce/api/app_api_service.dart';
import 'package:dni_ecommerce/api/common/app_resource.dart';
import 'package:dni_ecommerce/api/common/app_status.dart';
import 'package:dni_ecommerce/constant/app_constant.dart';
import 'package:dni_ecommerce/db/category_map_dao.dart';
import 'package:dni_ecommerce/db/cateogry_dao.dart';
import 'package:dni_ecommerce/viewobject/category.dart';
import 'package:dni_ecommerce/viewobject/category_map.dart';
import 'package:dni_ecommerce/viewobject/holder/category_parameter_holder.dart';
import 'package:sembast/sembast.dart';
import 'Common/app_repository.dart';

class CategoryRepository extends AppRepository {
  CategoryRepository({AppApiService psApiService, CategoryDao categoryDao}) {
    _psApiService = psApiService;
    _categoryDao = categoryDao;
  }

  String primaryKey = 'id';
  String mapKey = 'map_key';
  AppApiService _psApiService;
  CategoryDao _categoryDao;

  void sinkCategoryListStream(
      StreamController<AppResource<List<Category>>> categoryListStream,
      AppResource<List<Category>> dataList) {
    if (dataList != null && categoryListStream != null) {
      categoryListStream.sink.add(dataList);
    }
  }

  Future<dynamic> insert(Category category) async {
    return _categoryDao.insert(primaryKey, category);
  }

  Future<dynamic> update(Category category) async {
    return _categoryDao.update(category);
  }

  Future<dynamic> delete(Category category) async {
    return _categoryDao.delete(category);
  }

  Future<dynamic> getCategoryList(
      StreamController<AppResource<List<Category>>> categoryListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      CategoryParameterHolder holder,
      AppStatus status,
      {bool isLoadFromServer = true}) async {
    // Prepare Holder and Map Dao
    final String paramKey = holder.getParamKey();
    final CategoryMapDao categoryMapDao = CategoryMapDao.instance;

    sinkCategoryListStream(
        categoryListStream,
        await _categoryDao.getAllByMap(
            primaryKey, mapKey, paramKey, categoryMapDao, CategoryMap(),
            status: status));

    if (isConnectedToInternet) {
      final AppResource<List<Category>> _resource =
          await _psApiService.getCategoryList(limit, offset, holder.toMap());

      if (_resource.status == AppStatus.SUCCESS) {
        final List<CategoryMap> categoryMapList = <CategoryMap>[];
        int i = 0;
        for (Category data in _resource.data) {
          categoryMapList.add(CategoryMap(
              id: data.id + paramKey,
              mapKey: paramKey,
              categoryId: data.id,
              sorting: i++,
              addedDate: '2019'));
        }

        // Delete and Insert Map Dao
        await categoryMapDao
            .deleteWithFinder(Finder(filter: Filter.equals(mapKey, paramKey)));
        await categoryMapDao.insertAll(primaryKey, categoryMapList);

        // Insert Category
        await _categoryDao.insertAll(primaryKey, _resource.data);
      } else {
        if (_resource.errorCode == AppConst.ERROR_CODE_10001) {
          await categoryMapDao.deleteWithFinder(
              Finder(filter: Filter.equals(mapKey, paramKey)));
        }
      }
      // Load updated Data from Db and Send to UI
      sinkCategoryListStream(
          categoryListStream,
          await _categoryDao.getAllByMap(
              primaryKey, mapKey, paramKey, categoryMapDao, CategoryMap()));
    }
  }

  // Future<dynamic> getAllCategoryList(
  //     StreamController<AppResource<List<Category>>> categoryListStream,
  //     bool isConnectedToInternet,
  //     CategoryParameterHolder holder,
  //     AppStatus status,
  //     {bool isLoadFromServer = true}) async {
  //   // Prepare Holder and Map Dao
  //   final String paramKey = holder.getParamKey();
  //   final CategoryMapDao categoryMapDao = CategoryMapDao.instance;

  //   sinkCategoryListStream(
  //       categoryListStream,
  //       await _categoryDao.getAllByMap(
  //           primaryKey, mapKey, paramKey, categoryMapDao, CategoryMap(),
  //           status: status));

  //   if (isConnectedToInternet) {
  //     final AppResource<List<Category>> _resource =
  //         await _psApiService.getCategoryList(holder.toMap());

  //     if (_resource.status == AppStatus.SUCCESS) {
  //       final List<CategoryMap> categoryMapList = <CategoryMap>[];
  //       int i = 0;
  //       for (Category data in _resource.data) {
  //         categoryMapList.add(CategoryMap(
  //             id: data.id + paramKey,
  //             mapKey: paramKey,
  //             categoryId: data.id,
  //             sorting: i++,
  //             addedDate: '2019'));
  //       }

  //       // Delete and Insert Map Dao
  //       await categoryMapDao
  //           .deleteWithFinder(Finder(filter: Filter.equals(mapKey, paramKey)));
  //       await categoryMapDao.insertAll(primaryKey, categoryMapList);

  //       // Insert Category
  //       await _categoryDao.insertAll(primaryKey, _resource.data);
  //     } else {
  //       if (_resource.errorCode == AppConst.ERROR_CODE_10001) {
  //         await categoryMapDao.deleteWithFinder(
  //             Finder(filter: Filter.equals(mapKey, paramKey)));
  //       }
  //     }

  //     // Load updated Data from Db and Send to UI
  //     sinkCategoryListStream(
  //         categoryListStream,
  //         await _categoryDao.getAllByMap(
  //             primaryKey, mapKey, paramKey, categoryMapDao, CategoryMap()));
  //   }
  // }

  Future<dynamic> getNextPageCategoryList(
      StreamController<AppResource<List<Category>>> categoryListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      CategoryParameterHolder holder,
      AppStatus status,
      {bool isLoadFromServer = true}) async {
    // Prepare Holder and Map Dao
    final String paramKey = holder.getParamKey();
    final CategoryMapDao categoryMapDao = CategoryMapDao.instance;

    sinkCategoryListStream(
        categoryListStream,
        await _categoryDao.getAllByMap(
            primaryKey, mapKey, paramKey, categoryMapDao, CategoryMap(),
            status: status));

    if (isConnectedToInternet) {
      final AppResource<List<Category>> _resource =
          await _psApiService.getCategoryList(limit, offset, holder.toMap());

      if (_resource.status == AppStatus.SUCCESS) {
        final List<CategoryMap> categoryMapList = <CategoryMap>[];
        final AppResource<List<CategoryMap>> existingMapList =
            await categoryMapDao.getAll(
                finder: Finder(filter: Filter.equals(mapKey, paramKey)));

        int i = 0;
        if (existingMapList != null) {
          i = existingMapList.data.length + 1;
        }
        for (Category data in _resource.data) {
          categoryMapList.add(CategoryMap(
              id: data.id + paramKey,
              mapKey: paramKey,
              categoryId: data.id,
              sorting: i++,
              addedDate: '2019'));
        }

        await categoryMapDao.insertAll(primaryKey, categoryMapList);

        await _categoryDao.insertAll(primaryKey, _resource.data);
      }
      sinkCategoryListStream(
          categoryListStream,
          await _categoryDao.getAllByMap(
              primaryKey, mapKey, paramKey, categoryMapDao, CategoryMap()));
    }
  }

  // Future<AppResource<AppStatus>> postTouchCount(Map<dynamic, dynamic> jsonMap,
  //     bool isConnectedToInternet, AppStatus status,
  //     {bool isLoadFromServer = true}) async {
  //   final AppResource<AppStatus> _resource =
  //       await _psApiService.postTouchCount(jsonMap);
  //   if (_resource.status == AppStatus.SUCCESS) {
  //     return _resource;
  //   } else {
  //     final Completer<AppResource<AppStatus>> completer =
  //         Completer<AppResource<AppStatus>>();
  //     completer.complete(_resource);
  //     return completer.future;
  //   }
  // }
}
