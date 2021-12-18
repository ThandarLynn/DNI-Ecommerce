import 'dart:async';
import 'package:dni_ecommerce/constant/app_constant.dart';
import 'package:dni_ecommerce/db/gallery_dao.dart';
import 'package:dni_ecommerce/viewobject/gallery.dart';
import 'package:flutter/material.dart';
import 'package:dni_ecommerce/api/common/app_resource.dart';
import 'package:dni_ecommerce/api/common/app_status.dart';
import 'package:dni_ecommerce/api/app_api_service.dart';
import 'package:sembast/sembast.dart';
import 'Common/app_repository.dart';

class GalleryRepository extends AppRepository {
  GalleryRepository(
      {@required AppApiService psApiService, @required GalleryDao galleryDao}) {
    _psApiService = psApiService;
    _galleryDao = galleryDao;
  }

  String primaryKey = 'id';
  String imgParentId = 'product_id';
  AppApiService _psApiService;
  GalleryDao _galleryDao;

  Future<dynamic> insert(Gallery image) async {
    return _galleryDao.insert(primaryKey, image);
  }

  Future<dynamic> update(Gallery image) async {
    return _galleryDao.update(image);
  }

  Future<dynamic> delete(Gallery image) async {
    return _galleryDao.delete(image);
  }

  Future<dynamic> getAllGalleryList(
      StreamController<AppResource<List<Gallery>>> galleryListStream,
      bool isConnectedToInternet,
      String parentImgId,
      int limit,
      int offset,
      AppStatus status,
      {bool isLoadFromServer = true}) async {
    galleryListStream.sink.add(await _galleryDao.getAll(
        finder: Finder(filter: Filter.equals(imgParentId, parentImgId)),
        status: status));

    if (isConnectedToInternet) {
      final AppResource<List<Gallery>> _resource =
          await _psApiService.getGalleryList(parentImgId, limit, offset);

      if (_resource.status == AppStatus.SUCCESS) {
        await _galleryDao.deleteWithFinder(
            Finder(filter: Filter.equals(imgParentId, parentImgId)));
        await _galleryDao.insertAll(primaryKey, _resource.data);
      } else {
        if (_resource.errorCode == AppConst.ERROR_CODE_10001) {
          await _galleryDao.deleteWithFinder(
              Finder(filter: Filter.equals(imgParentId, parentImgId)));
        }
      }
      galleryListStream.sink.add(await _galleryDao.getAll(
          finder: Finder(filter: Filter.equals(imgParentId, parentImgId))));
    }
  }
}
