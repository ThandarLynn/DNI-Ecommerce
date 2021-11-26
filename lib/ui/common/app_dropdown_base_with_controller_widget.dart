import 'package:dni_ecommerce/config/app_colors.dart';
import 'package:dni_ecommerce/constant/app_dimens.dart';
import 'package:dni_ecommerce/utils/utils.dart';
import 'package:flutter/material.dart';

class AppDropdownBaseWithControllerWidget extends StatelessWidget {
  const AppDropdownBaseWithControllerWidget(
      {Key key,
      @required this.title,
      @required this.onTap,
      this.textEditingController,
      this.isMandatory = false})
      : super(key: key);

  final String title;
  final TextEditingController textEditingController;
  final Function onTap;
  final bool isMandatory;

  @override
  Widget build(BuildContext context) {
    final Widget _productTextWidget =
        Text(title, style: Theme.of(context).textTheme.bodyText1);
    final Widget _productTextWithStarWidget = Row(
      children: <Widget>[
        Text(title, style: Theme.of(context).textTheme.bodyText1),
        Text(' *',
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .copyWith(color: AppColors.mainColor))
      ],
    );

    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(
              left: AppDimens.space12,
              top: AppDimens.space4,
              right: AppDimens.space12),
          child: Row(
            children: <Widget>[
              if (isMandatory) _productTextWithStarWidget,
              if (!isMandatory) _productTextWidget,
            ],
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            height: AppDimens.space44,
            margin: const EdgeInsets.all(AppDimens.space12),
            decoration: BoxDecoration(
              color: AppColors.backgroundColor,
              borderRadius: BorderRadius.circular(AppDimens.space4),
              border: Border.all(color: AppColors.mainDividerColor),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: TextField(
                      controller: textEditingController,
                      enabled: false,
                      style: Theme.of(context).textTheme.bodyText2,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(
                          left: AppDimens.space12,
                          bottom: AppDimens.space8,
                        ),
                        border: InputBorder.none,
                        hintText: Utils.getString('home_search__not_set'),
                        hintStyle: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(color: AppColors.textPrimaryLightColor),
                      )),
                ),
                const Icon(
                  Icons.arrow_drop_down,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
