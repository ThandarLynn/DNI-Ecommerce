import 'dart:io';
import 'package:dni_ecommerce/config/app_colors.dart';
import 'package:dni_ecommerce/constant/app_dimens.dart';
import 'package:flutter/material.dart';

class AppBackButtonWithCircleBgWidget extends StatelessWidget {
  const AppBackButtonWithCircleBgWidget({Key key, this.isReadyToShow})
      : super(key: key);

  final bool isReadyToShow;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isReadyToShow,
      child: Container(
        margin: const EdgeInsets.only(
            left: AppDimens.space12, right: AppDimens.space4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.black.withAlpha(100),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(right: AppDimens.space4),
            child: InkWell(
                child: Icon(
                  Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
                  color: AppColors.white,
                ),
                onTap: () {
                  Navigator.pop(context);
                }),
          ),
        ),
      ),
    );
  }
}
