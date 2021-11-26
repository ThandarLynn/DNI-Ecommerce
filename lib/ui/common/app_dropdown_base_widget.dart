import 'package:dni_ecommerce/config/app_colors.dart';
import 'package:dni_ecommerce/constant/app_dimens.dart';
import 'package:dni_ecommerce/utils/utils.dart';
import 'package:flutter/material.dart';

class AppDropdownBaseWidget extends StatelessWidget {
  const AppDropdownBaseWidget(
      {Key key, @required this.title, @required this.onTap, this.selectedText})
      : super(key: key);

  final String title;
  final String selectedText;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(
              left: AppDimens.space12,
              top: AppDimens.space4,
              right: AppDimens.space12),
          child: Row(
            children: <Widget>[
              Text(
                title,
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyText1,
              ),
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
            child: Container(
              margin: const EdgeInsets.all(AppDimens.space12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      child: Text(
                        selectedText == ''
                            ? Utils.getString('home_search__not_set')
                            : selectedText,
                        overflow: TextOverflow.ellipsis,
                        style: selectedText == ''
                            ? Theme.of(context).textTheme.bodyText2.copyWith(
                                color: AppColors.textPrimaryLightColor)
                            : Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_drop_down,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
