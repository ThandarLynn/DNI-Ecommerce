import 'dart:async';
import 'package:dni_ecommerce/repository/token_repository.dart';
import 'package:dni_ecommerce/utils/utils.dart';
import 'package:dni_ecommerce/api/common/app_resource.dart';
import 'package:dni_ecommerce/api/common/app_status.dart';
import 'package:dni_ecommerce/provider/common/app_provider.dart';
import 'package:dni_ecommerce/viewobject/common/api_status.dart';
import 'package:flutter/cupertino.dart';

class TokenProvider extends AppProvider {
  TokenProvider(
      {@required TokenRepository repo,
      int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    // tokenDataListStream = StreamController<AppResource<ApiStatus>>.broadcast();
    // subscription =
    //     tokenDataListStream.stream.listen((AppResource<ApiStatus> resource) {
    //   _tokenData = resource;

    //   if (resource.status != AppStatus.BLOCK_LOADING &&
    //       resource.status != AppStatus.PROGRESS_LOADING) {
    //     isLoading = false;
    //   }

    //   if (!isDispose) {
    //     notifyListeners();
    //   }
    // });
  }

  // AppResource<ApiStatus> _tokenData =
  //     AppResource<ApiStatus>(AppStatus.NOACTION, '', null);

  // AppResource<ApiStatus> get tokenData => _tokenData;
  // StreamSubscription<AppResource<ApiStatus>> subscription;
  // StreamController<AppResource<ApiStatus>> tokenDataListStream;
  // AppApiService _psApiService;
TokenRepository _repo;

  @override
  void dispose() {
    // subscription.cancel();
    isDispose = true;
    print('Token Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadToken() async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    // if (isConnectedToInternet) {
      final AppResource<ApiStatus> _resource = await _repo.getToken(isConnectedToInternet, AppStatus.SUCCESS);

return _resource;
      // if (_resource.status == AppStatus.SUCCESS) {
      //   tokenDataListStream.sink.add(_resource);
      // }
    }
  }

