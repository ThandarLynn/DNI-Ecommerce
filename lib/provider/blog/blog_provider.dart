import 'dart:async';
import 'package:dni_ecommerce/repository/blog_repository.dart';
import 'package:dni_ecommerce/utils/utils.dart';
import 'package:dni_ecommerce/viewobject/product.dart';
import 'package:flutter/material.dart';
import 'package:dni_ecommerce/api/common/app_resource.dart';
import 'package:dni_ecommerce/api/common/app_status.dart';
import 'package:dni_ecommerce/provider/common/app_provider.dart';

class BlogProvider extends AppProvider {
  BlogProvider({@required BlogRepository repo, int limit = 0})
      : super(repo, limit) {
    if (limit != 0) {
      super.limit = limit;
    }
    _repo = repo;

    print('Blog Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });
    blogListStream = StreamController<AppResource<List<Product>>>.broadcast();
    subscription =
        blogListStream.stream.listen((AppResource<List<Product>> resource) {
      updateOffset(resource.data.length);

      _blogList = resource;

      if (resource.status != AppStatus.BLOCK_LOADING &&
          resource.status != AppStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  BlogRepository _repo;

  AppResource<List<Product>> _blogList =
      AppResource<List<Product>>(AppStatus.NOACTION, '', <Product>[]);

  AppResource<List<Product>> get blogList => _blogList;
  StreamSubscription<AppResource<List<Product>>> subscription;
  StreamController<AppResource<List<Product>>> blogListStream;
  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('Blog Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadBlogList() async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo.getAllBlogList(blogListStream, isConnectedToInternet, limit,
        offset, AppStatus.PROGRESS_LOADING);
  }

  Future<dynamic> nextBlogList() async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;
      await _repo.getNextPageBlogList(blogListStream, isConnectedToInternet,
          limit, offset, AppStatus.PROGRESS_LOADING);
    }
  }

  Future<void> resetBlogList() async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    await _repo.getAllBlogList(blogListStream, isConnectedToInternet, limit,
        offset, AppStatus.PROGRESS_LOADING);

    isLoading = false;
  }
}
