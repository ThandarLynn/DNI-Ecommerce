import 'package:flutter/cupertino.dart';

import 'common/app_holder.dart';

class UserRegisterParameterHolder
    extends AppHolder<UserRegisterParameterHolder> {
  UserRegisterParameterHolder(
      {@required this.userId,
      @required this.userName,
      @required this.userEmail,
      @required this.userPassword,
      @required this.passwordConfirmation,
      @required this.deviceToken});

  final String userId;
  final String userName;
  final String userEmail;
  final String userPassword;
  final String passwordConfirmation;
  final String deviceToken;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['id'] = userId;
    map['name'] = userName;
    map['email'] = userEmail;
    map['password'] = userPassword;
    map['password_confirmation'] = passwordConfirmation;
    map['device_token'] = deviceToken;

    return map;
  }

  @override
  UserRegisterParameterHolder fromMap(dynamic dynamicData) {
    return UserRegisterParameterHolder(
      userId: dynamicData['id'],
      userName: dynamicData['name'],
      userEmail: dynamicData['email'],
      userPassword: dynamicData['password'],
      passwordConfirmation: dynamicData['password_confirmation'],
      deviceToken: dynamicData['device_token'],
    );
  }

  @override
  String getParamKey() {
    String key = '';

    if (userId != '') {
      key += userId;
    }
    if (userName != '') {
      key += userName;
    }
    if (userEmail != '') {
      key += userEmail;
    }
    if (userPassword != '') {
      key += userPassword;
    }
    if (passwordConfirmation != '') {
      key += passwordConfirmation;
    }
    if (deviceToken != '') {
      key += deviceToken;
    }
    return key;
  }
}
