import 'dart:async';
import 'package:dni_ecommerce/api/common/app_resource.dart';
import 'package:dni_ecommerce/api/common/app_status.dart';
import 'package:dni_ecommerce/provider/common/app_provider.dart';
import 'package:dni_ecommerce/repository/gallery_repository.dart';
import 'package:dni_ecommerce/utils/utils.dart';
import 'package:dni_ecommerce/viewobject/gallery.dart';
import 'package:flutter/material.dart';

class GalleryProvider extends AppProvider {
  GalleryProvider({@required GalleryRepository repo, int limit = 0})
      : super(repo, limit) {
    _repo = repo;

    print('Gallery Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    galleryListStream =
        StreamController<AppResource<List<Gallery>>>.broadcast();
    subscription = galleryListStream.stream
        .listen((AppResource<List<Gallery>> resource) {
      updateOffset(resource.data.length);

      _galleryList = resource;

      if (resource.status != AppStatus.BLOCK_LOADING &&
          resource.status != AppStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  GalleryRepository _repo;

  AppResource<List<Gallery>> _galleryList =
      AppResource<List<Gallery>>(AppStatus.NOACTION, '', <Gallery>[]);

  AppResource<List<Gallery>> get galleryList => _galleryList;
  StreamSubscription<AppResource<List<Gallery>>> subscription;
  StreamController<AppResource<List<Gallery>>> galleryListStream;
  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('Gallery Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadImageList(
    String parentImgId,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo.getAllGalleryList(galleryListStream, isConnectedToInternet,
        parentImgId, limit, offset, AppStatus.PROGRESS_LOADING);
  }

  Future<void> resetGallaryList(String parentImgId) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    await _repo.getAllGalleryList(galleryListStream, isConnectedToInternet,
        parentImgId, limit, offset, AppStatus.PROGRESS_LOADING);

    isLoading = false;
  }
}
