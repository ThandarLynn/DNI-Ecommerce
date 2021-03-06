import 'dart:async';
import 'package:dni_ecommerce/api/app_api_service.dart';
import 'package:dni_ecommerce/api/common/app_resource.dart';
import 'package:dni_ecommerce/api/common/app_status.dart';
import 'package:dni_ecommerce/db/user_dao.dart';
import 'package:dni_ecommerce/repository/Common/app_repository.dart';
import 'package:dni_ecommerce/viewobject/common/api_status.dart';
import 'package:dni_ecommerce/viewobject/user.dart';
import 'package:flutter/material.dart';
import 'package:sembast/sembast.dart';

class UserRepository extends AppRepository {
  UserRepository(
      {@required AppApiService appApiService, @required UserDao userDao}) {
    _appApiService = appApiService;
    _userDao = userDao;
  }

  AppApiService _appApiService;
  UserDao _userDao;
  final String _userPrimaryKey = 'id';
  // final String _userLoginPrimaryKey = 'map_key';

  void sinkUserDetailStream(StreamController<AppResource<User>> userListStream,
      AppResource<User> data) {
    if (data != null) {
      userListStream.sink.add(data);
    }
  }

  Future<dynamic> insert(User user) async {
    return _userDao.insert(_userPrimaryKey, user);
  }

  Future<dynamic> update(User user) async {
    return _userDao.update(user);
  }

  Future<dynamic> delete(User user) async {
    return _userDao.delete(user);
  }

  Future<AppResource<User>> postUserRegister(Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet, AppStatus status,
      {bool isLoadFromServer = true}) async {
    final AppResource<User> _resource =
        await _appApiService.postUserRegister(jsonMap);
    if (_resource.status == AppStatus.SUCCESS) {
      return _resource;
    } else {
      final Completer<AppResource<User>> completer =
          Completer<AppResource<User>>();
      completer.complete(_resource);
      return completer.future;
    }
  }

  Future<AppResource<User>> postUserLogin(Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet, AppStatus status,
      {bool isLoadFromServer = true}) async {
    final AppResource<User> _resource =
        await _appApiService.postUserLogin(jsonMap);
    if (_resource.status == AppStatus.SUCCESS) {
      // await _userLoginDao.deleteAll();
      await insert(_resource.data);
      // final String userId = _resource.data.userId;
      // final UserLogin userLogin =
      //     UserLogin(id: userId, login: true, user: _resource.data);
      // await insertUserLogin(userLogin);
      return _resource;
    } else {
      final Completer<AppResource<User>> completer =
          Completer<AppResource<User>>();
      completer.complete(_resource);
      return completer.future;
    }
  }

  Future<dynamic> updateUserDB(
      User user, StreamController<dynamic> userStream, AppStatus status) async {
    final Finder finder =
        Finder(filter: Filter.equals(_userPrimaryKey, user.userId));
    await _userDao.insert(_userPrimaryKey, user);
    userStream.sink.add(await _userDao.getOne(finder: finder, status: status));
  }

  Future<dynamic> getUserFromDB(String loginUserId,
      StreamController<dynamic> userStream, AppStatus status) async {
    final Finder finder =
        Finder(filter: Filter.equals(_userPrimaryKey, loginUserId));

    userStream.sink.add(await _userDao.getOne(finder: finder, status: status));
  }

  Future<AppResource<ApiStatus>> postForgotPassword(
      Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet,
      AppStatus status,
      {bool isLoadFromServer = true}) async {
    final AppResource<ApiStatus> _resource =
        await _appApiService.postForgotPassword(jsonMap);
    if (_resource.status == AppStatus.SUCCESS) {
      return _resource;
    } else {
      final Completer<AppResource<ApiStatus>> completer =
          Completer<AppResource<ApiStatus>>();
      completer.complete(_resource);
      return completer.future;
    }
  }

  Future<AppResource<ApiStatus>> postChangePassword(
      Map<dynamic, dynamic> jsonMap,
      String userToken,
      bool isConnectedToInternet,
      AppStatus status,
      {bool isLoadFromServer = true}) async {
    final AppResource<ApiStatus> _resource =
        await _appApiService.postChangePassword(jsonMap, userToken);
    if (_resource.status == AppStatus.SUCCESS) {
      return _resource;
    } else {
      final Completer<AppResource<ApiStatus>> completer =
          Completer<AppResource<ApiStatus>>();
      completer.complete(_resource);
      return completer.future;
    }
  }

  Future<AppResource<User>> postProfileUpdate(Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet, AppStatus status,
      {bool isLoadFromServer = true}) async {
    final AppResource<User> _resource =
        await _appApiService.postProfileUpdate(jsonMap);
    if (_resource.status == AppStatus.SUCCESS) {
      // await _userLoginDao.deleteAll();
      await insert(_resource.data);
      // final String userId = _resource.data.userId;
      // final UserLogin userLogin =
      //     UserLogin(id: userId, login: true, user: _resource.data);
      // await insertUserLogin(userLogin);
      return _resource;
    } else {
      final Completer<AppResource<User>> completer =
          Completer<AppResource<User>>();
      completer.complete(_resource);
      return completer.future;
    }
  }

  Future<AppResource<ApiStatus>> postResendCode(Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet, AppStatus status,
      {bool isLoadFromServer = true}) async {
    final AppResource<ApiStatus> _resource =
        await _appApiService.postResendCode(jsonMap);
    if (_resource.status == AppStatus.SUCCESS) {
      return _resource;
    } else {
      final Completer<AppResource<ApiStatus>> completer =
          Completer<AppResource<ApiStatus>>();
      completer.complete(_resource);
      return completer.future;
    }
  }

  Future<dynamic> getUser(
      StreamController<AppResource<User>> userListStream,
      String loginUserId,
      String userToken,
      bool isConnectedToInternet,
      AppStatus status,
      {bool isLoadFromServer = true}) async {
    final Finder finder = Finder(filter: Filter.equals('id', loginUserId));
    sinkUserDetailStream(
        userListStream, await _userDao.getOne(finder: finder, status: status));

    if (isConnectedToInternet) {
      final AppResource<User> _resource =
          await _appApiService.getUser(loginUserId, userToken);

      if (_resource.status == AppStatus.SUCCESS) {
        await _userDao.deleteWithFinder(finder);
        await _userDao.insert(_userPrimaryKey, _resource.data);
      }
      sinkUserDetailStream(
          userListStream, await _userDao.getOne(finder: finder));
    }
  }
}
