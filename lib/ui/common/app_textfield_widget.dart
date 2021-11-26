import 'package:dni_ecommerce/config/app_colors.dart';
import 'package:dni_ecommerce/constant/app_dimens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextFieldWidget extends StatelessWidget {
  const AppTextFieldWidget(
      {this.textEditingController,
      this.titleText = '',
      this.hintText,
      this.textAboutMe = false,
      this.height = AppDimens.space44,
      this.showTitle = true,
      this.keyboardType = TextInputType.text,
      this.phoneInputType = false,
      this.isMandatory = false});

  final TextEditingController textEditingController;
  final String titleText;
  final String hintText;
  final double height;
  final bool textAboutMe;
  final TextInputType keyboardType;
  final bool showTitle;
  final bool phoneInputType;
  final bool isMandatory;

  @override
  Widget build(BuildContext context) {
    final Widget _productTextWidget =
        Text(titleText, style: Theme.of(context).textTheme.bodyText1);

    return Column(
      children: <Widget>[
        if (showTitle)
          Container(
            margin: const EdgeInsets.only(
                left: AppDimens.space12,
                top: AppDimens.space12,
                right: AppDimens.space12),
            child: Row(
              children: <Widget>[
                if (isMandatory)
                  Row(
                    children: <Widget>[
                      Text(titleText,
                          style: Theme.of(context).textTheme.bodyText1),
                      Text(' *',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(color: AppColors.mainColor))
                    ],
                  )
                else
                  _productTextWidget
              ],
            ),
          )
        else
          Container(
            height: 0,
          ),
        Container(
            width: double.infinity,
            height: height,
            margin: const EdgeInsets.all(AppDimens.space12),
            decoration: BoxDecoration(
              color: AppColors.backgroundColor,
              borderRadius: BorderRadius.circular(AppDimens.space4),
              border: Border.all(color: AppColors.mainDividerColor),
            ),
            child: TextField(
                keyboardType:
                    phoneInputType ? TextInputType.phone : TextInputType.text,
                maxLines: null,
                controller: textEditingController,
                style: Theme.of(context).textTheme.bodyText2,
                decoration: textAboutMe
                    ? InputDecoration(
                        contentPadding: const EdgeInsets.only(
                          left: AppDimens.space12,
                          bottom: AppDimens.space8,
                          top: AppDimens.space10,
                        ),
                        border: InputBorder.none,
                        hintText: hintText,
                        hintStyle: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(color: AppColors.textPrimaryLightColor),
                      )
                    : InputDecoration(
                        contentPadding: const EdgeInsets.only(
                          left: AppDimens.space12,
                          bottom: AppDimens.space8,
                        ),
                        border: InputBorder.none,
                        hintText: hintText,
                        hintStyle: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(color: AppColors.textPrimaryLightColor),
                      ))),
      ],
    );
  }
}
