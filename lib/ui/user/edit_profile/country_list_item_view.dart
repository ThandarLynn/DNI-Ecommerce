import 'package:dni_ecommerce/config/app_colors.dart';
import 'package:dni_ecommerce/constant/app_dimens.dart';
import 'package:dni_ecommerce/viewobject/shipping_country.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CountryListItem extends StatelessWidget {
  const CountryListItem(
      {Key key,
      @required this.country,
      this.onTap,
      this.animationController,
      this.animation})
      : super(key: key);

  final ShippingCountry country;
  final Function onTap;
  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    animationController.forward();

    return AnimatedBuilder(
      animation: animationController,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: MediaQuery.of(context).size.width,
          color: AppColors.backgroundColor,
          height: AppDimens.space52,
          margin: const EdgeInsets.only(top: AppDimens.space4),
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.space16),
            child: Text(
              country.name,
              textAlign: TextAlign.start,
              style: Theme.of(context)
                  .textTheme
                  .subtitle2
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
              transform: Matrix4.translationValues(
                  0.0, 100 * (1.0 - animation.value), 0.0),
              child: child),
        );
      },
    );
  }
}
