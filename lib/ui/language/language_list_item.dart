import 'package:dni_ecommerce/config/app_colors.dart';
import 'package:dni_ecommerce/constant/app_dimens.dart';
import 'package:dni_ecommerce/viewobject/language.dart';
import 'package:flutter/material.dart';

class LanguageListItem extends StatelessWidget {
  const LanguageListItem({
    Key key,
    @required this.language,
    @required this.animation,
    @required this.animationController,
    this.onTap,
  }) : super(key: key);

  final Language language;
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
          child: Card(
            elevation: 0.3,
            margin: const EdgeInsets.symmetric(
                horizontal: AppDimens.space16, vertical: AppDimens.space4),
            child: Container(
              padding: const EdgeInsets.all(AppDimens.space16),
              child: Row(
                children: <Widget>[
                  const SizedBox(
                    width: AppDimens.space4,
                  ),
                  const Icon(Icons.language),
                  const SizedBox(
                    width: AppDimens.space12,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(
                        height: AppDimens.space4,
                      ),
                      Text(
                        language.name,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: AppColors.mainColor,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: AppDimens.space4,
                      ),
                      Text('${language.languageCode}_${language.countryCode}',
                          maxLines: 2, overflow: TextOverflow.ellipsis),
                      const SizedBox(
                        height: AppDimens.space4,
                      ),
                    ],
                  )
                ],
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
        });
  }
}
