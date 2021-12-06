import 'package:dni_ecommerce/viewobject/common/app_holder.dart';
import 'package:flutter/cupertino.dart';

class ForgotPasswordParameterHolder
    extends AppHolder<ForgotPasswordParameterHolder> {
  ForgotPasswordParameterHolder({@required this.userEmail});

  final String userEmail;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['email'] = userEmail;

    return map;
  }

  @override
  ForgotPasswordParameterHolder fromMap(dynamic dynamicData) {
    return ForgotPasswordParameterHolder(
      userEmail: dynamicData['email'],
    );
  }

  @override
  String getParamKey() {
    String key = '';

    if (userEmail != '') {
      key += userEmail;
    }
    return key;
  }
}
