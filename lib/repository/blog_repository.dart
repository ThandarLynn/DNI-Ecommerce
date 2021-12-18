import 'dart:async';
import 'package:dni_ecommerce/constant/app_constant.dart';
import 'package:dni_ecommerce/db/blog_dao.dart';
import 'package:dni_ecommerce/viewobject/blog.dart';
import 'package:flutter/material.dart';
import 'package:dni_ecommerce/api/common/app_resource.dart';
import 'package:dni_ecommerce/api/common/app_status.dart';
import 'package:dni_ecommerce/api/app_api_service.dart';

import 'Common/app_repository.dart';

class BlogRepository extends AppRepository {
  BlogRepository(
      {@required AppApiService psApiService, @required BlogDao blogDao}) {
    _psApiService = psApiService;
    _blogDao = blogDao;
  }

  String primaryKey = 'id';
  AppApiService _psApiService;
  BlogDao _blogDao;

  Future<dynamic> insert(Blog blog) async {
    return _blogDao.insert(primaryKey, blog);
  }

  Future<dynamic> update(Blog blog) async {
    return _blogDao.update(blog);
  }

  Future<dynamic> delete(Blog blog) async {
    return _blogDao.delete(blog);
  }

  Future<dynamic> getAllBlogList(
      StreamController<AppResource<List<Blog>>> blogListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      AppStatus status,
      {bool isLoadFromServer = true}) async {
    blogListStream.sink.add(await _blogDao.getAll(status: status));

    if (isConnectedToInternet) {
      final AppResource<List<Blog>> _resource =
          await _psApiService.getBlogList(limit, offset);

      if (_resource.status == AppStatus.SUCCESS) {
        await _blogDao.deleteAll();
        await _blogDao.insertAll(primaryKey, _resource.data);
      } else {
        if (_resource.errorCode == AppConst.ERROR_CODE_10001) {
          await _blogDao.deleteAll();
        }
      }
      blogListStream.sink.add(await _blogDao.getAll());
    }
  }

  Future<dynamic> getNextPageBlogList(
      StreamController<AppResource<List<Blog>>> blogListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      AppStatus status,
      {bool isLoadFromServer = true}) async {
    blogListStream.sink.add(await _blogDao.getAll(status: status));

    if (isConnectedToInternet) {
      final AppResource<List<Blog>> _resource =
          await _psApiService.getBlogList(limit, offset);

      if (_resource.status == AppStatus.SUCCESS) {
        await _blogDao.insertAll(primaryKey, _resource.data);
      }
      blogListStream.sink.add(await _blogDao.getAll());
    }
  }
}
