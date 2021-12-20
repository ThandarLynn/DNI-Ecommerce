import 'dart:async';

import 'package:dni_ecommerce/constant/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:sembast/sembast.dart';
import 'package:dni_ecommerce/api/common/app_resource.dart';
import 'package:dni_ecommerce/api/common/app_status.dart';
import 'package:dni_ecommerce/api/app_api_service.dart';
import 'package:dni_ecommerce/db/sub_category_dao.dart';
import 'package:dni_ecommerce/repository/Common/app_repository.dart';
import 'package:dni_ecommerce/viewobject/sub_category.dart';

class SubCategoryRepository extends AppRepository {
  SubCategoryRepository(
      {@required AppApiService psApiService,
      @required SubCategoryDao subCategoryDao}) {
    _psApiService = psApiService;
    _subCategoryDao = subCategoryDao;
  }

  AppApiService _psApiService;
  SubCategoryDao _subCategoryDao;
  final String _primaryKey = 'id';

  Future<dynamic> insert(SubCategory subCategory) async {
    return _subCategoryDao.insert(_primaryKey, subCategory);
  }

  Future<dynamic> update(SubCategory subCategory) async {
    return _subCategoryDao.update(subCategory);
  }

  Future<dynamic> delete(SubCategory subCategory) async {
    return _subCategoryDao.delete(subCategory);
  }

  Future<dynamic> getSubCategoryListByCategoryId(
      StreamController<AppResource<List<SubCategory>>> subCategoryListStream,
      bool isConnectedToIntenet,
      int limit,
      int offset,
      AppStatus status,
      String categoryId,
      {bool isLoadFromServer = true}) async {
    final Finder finder =
        Finder(filter: Filter.equals('category_id', categoryId));

    subCategoryListStream.sink
        .add(await _subCategoryDao.getAll(finder: finder, status: status));

    final AppResource<List<SubCategory>> _resource =
        await _psApiService.getAllSubCategoryList(categoryId);

    if (_resource.status == AppStatus.SUCCESS) {
      await _subCategoryDao.deleteWithFinder(finder);
      await _subCategoryDao.insertAll(_primaryKey, _resource.data);
    } else {
      if (_resource.errorCode == AppConst.ERROR_CODE_10001) {
        await _subCategoryDao.deleteWithFinder(finder);
      }
    }
    subCategoryListStream.sink
        .add(await _subCategoryDao.getAll(finder: finder));
  }

  Future<dynamic> getAllSubCategoryListByCategoryId(
      StreamController<AppResource<List<SubCategory>>> subCategoryListStream,
      bool isConnectedToIntenet,
      AppStatus status,
      String categoryId,
      {bool isLoadFromServer = true}) async {
    final Finder finder =
        Finder(filter: Filter.equals('category_id', categoryId));

    subCategoryListStream.sink
        .add(await _subCategoryDao.getAll(finder: finder, status: status));

    final AppResource<List<SubCategory>> _resource =
        await _psApiService.getAllSubCategoryList(categoryId);

    if (_resource.status == AppStatus.SUCCESS) {
      await _subCategoryDao.deleteWithFinder(finder);
      await _subCategoryDao.insertAll(_primaryKey, _resource.data);
    } else {
      if (_resource.errorCode == AppConst.ERROR_CODE_10001) {
        await _subCategoryDao.deleteWithFinder(finder);
      }
    }
    subCategoryListStream.sink
        .add(await _subCategoryDao.getAll(finder: finder));
  }

  Future<dynamic> getNextPageSubCategoryList(
      StreamController<AppResource<List<SubCategory>>> subCategoryListStream,
      bool isConnectedToIntenet,
      int limit,
      int offset,
      AppStatus status,
      String categoryId,
      {bool isLoadFromServer = true}) async {
    final Finder finder =
        Finder(filter: Filter.equals('category_id', categoryId));
    subCategoryListStream.sink
        .add(await _subCategoryDao.getAll(finder: finder, status: status));

    final AppResource<List<SubCategory>> _resource =
        await _psApiService.getAllSubCategoryList(categoryId);

    if (_resource.status == AppStatus.SUCCESS) {
      _subCategoryDao
          .insertAll(_primaryKey, _resource.data)
          .then((dynamic data) async {
        subCategoryListStream.sink
            .add(await _subCategoryDao.getAll(finder: finder));
      });
    } else {
      subCategoryListStream.sink
          .add(await _subCategoryDao.getAll(finder: finder));
    }
  }
}
