import 'package:dni_ecommerce/viewobject/common/app_holder.dart';
import 'package:flutter/cupertino.dart';

class UserLoginParameterHolder extends AppHolder<UserLoginParameterHolder> {
  UserLoginParameterHolder({
    @required this.userEmail,
    @required this.userPassword,
    // @required this.deviceToken
  });

  final String userEmail;
  final String userPassword;
  // final String deviceToken;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['email'] = userEmail;
    map['password'] = userPassword;
    // map['device_token'] = deviceToken;

    return map;
  }

  @override
  UserLoginParameterHolder fromMap(dynamic dynamicData) {
    return UserLoginParameterHolder(
      userEmail: dynamicData['email'],
      userPassword: dynamicData['password'],
      // deviceToken: dynamicData['device_token'],
    );
  }

  @override
  String getParamKey() {
    String key = '';

    if (userEmail != '') {
      key += userEmail;
    }
    if (userPassword != '') {
      key += userPassword;
    }

    // if (deviceToken != '') {
    //   key += deviceToken;
    // }
    return key;
  }
}
