import 'package:dni_ecommerce/viewobject/common/app_holder.dart';
import 'package:flutter/cupertino.dart';

class ChangePasswordParameterHolder
    extends AppHolder<ChangePasswordParameterHolder> {
  ChangePasswordParameterHolder(
      {@required this.token,
      @required this.password,
      @required this.passwordConfirm});

  final String token;
  final String password;
  final String passwordConfirm;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['token'] = token;
    map['password'] = password;
    map['password_confirm'] = passwordConfirm;

    return map;
  }

  @override
  ChangePasswordParameterHolder fromMap(dynamic dynamicData) {
    return ChangePasswordParameterHolder(
      token: dynamicData['token'],
      password: dynamicData['password'],
      passwordConfirm: dynamicData['password_confirm'],
    );
  }

  @override
  String getParamKey() {
    String key = '';

    if (token != '') {
      key += token;
    }
    if (password != '') {
      key += password;
    }
    if (passwordConfirm != '') {
      key += passwordConfirm;
    }
    return key;
  }
}
