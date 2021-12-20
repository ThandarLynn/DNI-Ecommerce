import 'dart:async';
import 'package:dni_ecommerce/api/app_api_service.dart';
import 'package:dni_ecommerce/api/common/app_resource.dart';
import 'package:dni_ecommerce/api/common/app_status.dart';
import 'package:dni_ecommerce/viewobject/common/api_status.dart';
import 'package:flutter/material.dart';

import 'Common/app_repository.dart';

class ContactUsRepository extends AppRepository {
  ContactUsRepository({
    @required AppApiService appApiService,
  }) {
    _appApiService = appApiService;
  }
  String primaryKey = 'id';
  AppApiService _appApiService;

  Future<AppResource<ApiStatus>> postContactUs(Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet, AppStatus status,
      {bool isLoadFromServer = true}) async {
    final AppResource<ApiStatus> _resource =
        await _appApiService.postContactUs(jsonMap);
    if (_resource.status == AppStatus.SUCCESS) {
      return _resource;
    } else {
      final Completer<AppResource<ApiStatus>> completer =
          Completer<AppResource<ApiStatus>>();
      completer.complete(_resource);
      return completer.future;
    }
  }
}
