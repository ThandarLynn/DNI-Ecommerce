import 'package:dni_ecommerce/config/app_colors.dart';
import 'package:dni_ecommerce/constant/app_dimens.dart';
import 'package:flutter/material.dart';

class AppFrameUIForLoading extends StatelessWidget {
  const AppFrameUIForLoading({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 200,
        width: 200,
        margin: const EdgeInsets.all(AppDimens.space16),
        decoration: BoxDecoration(color: AppColors.grey));
  }
}
