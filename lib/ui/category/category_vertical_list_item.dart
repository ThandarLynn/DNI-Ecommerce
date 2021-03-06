import 'package:dni_ecommerce/config/app_colors.dart';
import 'package:dni_ecommerce/viewobject/category.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryVerticalListItem extends StatelessWidget {
  const CategoryVerticalListItem(
      {Key key,
      @required this.category,
      this.onTap,
      this.animationController,
      this.animation})
      : super(key: key);

  final Category category;

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
                child: Container(
                    child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Stack(
                          children: <Widget>[
                            // Container(
                            //   child: AppNetworkImage(
                            //     photoKey: '',
                            //     Image: category.Image,
                            //     width: AppDimens.space200,
                            //     height: double.infinity,
                            //     boxfit: BoxFit.cover,
                            //   ),
                            // ),
                            Container(
                              width: 200,
                              height: double.infinity,
                              color: AppColors.mainColor,
                            )
                          ],
                        )),
                    Text(
                      category.name,
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.subtitle2.copyWith(
                          color: AppColors.white, fontWeight: FontWeight.bold),
                    ),
                    // Container(
                    //     child: Positioned(
                    //   bottom: 10,
                    //   left: 10,
                    //   child: Container(
                    //     width: AppDimens.space40,
                    //     height: AppDimens.space40,
                    //     child: PsNetworkCircleIconImage(
                    //       photoKey: '',
                    //       defaultIcon: category.defaultIcon,
                    //       boxfit: BoxFit.cover,
                    //       onTap: onTap,
                    //     ),
                    //   ),
                    // )),
                  ],
                )))),
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
