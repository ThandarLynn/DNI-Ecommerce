import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dni_ecommerce/config/app_colors.dart';
import 'package:dni_ecommerce/viewobject/sub_category.dart';
import 'package:dni_ecommerce/constant/app_dimens.dart';

class SubCategoryGridItem extends StatelessWidget {
  const SubCategoryGridItem(
      {Key key,
      @required this.subCategory,
      this.onTap,
      this.animationController,
      this.animation})
      : super(key: key);

  final SubCategory subCategory;
  final Function onTap;
  final AnimationController animationController;
  final Animation<double> animation;
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
                  Container(
                    padding: const EdgeInsets.only(
                        left: AppDimens.space2, right: AppDimens.space2),
                    child: Text(
                      subCategory.name,
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
