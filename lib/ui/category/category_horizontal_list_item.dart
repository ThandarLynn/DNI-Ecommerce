import 'package:dni_ecommerce/config/app_colors.dart';
import 'package:dni_ecommerce/constant/app_dimens.dart';
import 'package:dni_ecommerce/viewobject/category.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryHorizontalListItem extends StatelessWidget {
  const CategoryHorizontalListItem({
    Key key,
    @required this.category,
    this.onTap,
  }) : super(key: key);

  final Category category;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 0.0,
          color: AppColors.categoryBackgroundColor,
          margin: const EdgeInsets.symmetric(
              horizontal: AppDimens.space8, vertical: AppDimens.space12),
          child: Container(
            width: AppDimens.space100,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  // Container(
                  //   width: AppDimens.space52,
                  //   height: AppDimens.space52,
                  //   child: PsNetworkCircleIconImage(
                  //     photoKey: '',
                  //     defaultIcon: category.defaultIcon,
                  //     boxfit: BoxFit.fitHeight,
                  //   ),
                  // ),
                  // const SizedBox(
                  //   height: AppDimens.space8,
                  // ),
                  Container(
                    padding: const EdgeInsets.only(
                        left: AppDimens.space2, right: AppDimens.space2),
                    child: Text(
                      category.name,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
