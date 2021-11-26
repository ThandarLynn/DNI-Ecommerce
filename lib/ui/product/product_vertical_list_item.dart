import 'package:dni_ecommerce/config/app_colors.dart';
import 'package:dni_ecommerce/constant/app_constant.dart';
import 'package:dni_ecommerce/constant/app_dimens.dart';
import 'package:dni_ecommerce/utils/utils.dart';
import 'package:dni_ecommerce/viewobject/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductVeticalListItem extends StatelessWidget {
  const ProductVeticalListItem(
      {Key key,
      @required this.product,
      this.onTap,
      this.animationController,
      this.animation,
      this.coreTagKey})
      : super(key: key);

  final Product product;
  final Function onTap;
  final String coreTagKey;
  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    animationController.forward();
    return AnimatedBuilder(
        animation: animationController,
        child: GestureDetector(
            onTap: onTap,
            child: GridTile(
              header: Container(
                padding: const EdgeInsets.all(AppDimens.space8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        child: product.isDiscount == AppConst.ONE
                            ? Container(
                                width: AppDimens.space52,
                                height: AppDimens.space24,
                                child: Stack(
                                  children: <Widget>[
                                    Image.asset(
                                        'assets/images/baseline_percent_tag_orange_24.png',
                                        matchTextDirection: true,
                                        color: AppColors.mainColor),
                                    Center(
                                      child: Text(
                                        '-${product.discountPercent}%',
                                        textAlign: TextAlign.start,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .copyWith(color: AppColors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container()),
                  ],
                ),
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: AppDimens.space8, vertical: AppDimens.space8),
                decoration: BoxDecoration(
                  color: AppColors.backgroundColor,
                  borderRadius:
                      const BorderRadius.all(Radius.circular(AppDimens.space8)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                              Radius.circular(AppDimens.space8)),
                        ),
                        // child: ClipPath(
                        //   child: AppNetworkImage(
                        //     photoKey: '$coreTagKey$AppConst.HERO_TAG__IMAGE',
                        //     defaultPhoto: product.defaultPhoto,
                        //     width: AppDimens.space180,
                        //     height: double.infinity,
                        //     boxfit: BoxFit.cover,
                        //     onTap: () {
                        //       print(product.defaultPhoto.imgParentId);
                        //       onTap();
                        //     },
                        //   ),
                        //   clipper: const ShapeBorderClipper(
                        //       shape: RoundedRectangleBorder(
                        //           borderRadius: BorderRadius.only(
                        //               topLeft:
                        //                   Radius.circular(AppDimens.space8),
                        //               topRight:
                        //                   Radius.circular(AppDimens.space8)))),
                        // ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: AppDimens.space8,
                          top: AppDimens.space12,
                          right: AppDimens.space8,
                          bottom: AppDimens.space4),
                      child: Hero(
                        tag: '$coreTagKey$AppConst.HERO_TAG__TITLE',
                        child: Text(
                          product.name,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyText1,
                          maxLines: 1,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: AppDimens.space8,
                          top: AppDimens.space4,
                          right: AppDimens.space8),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Hero(
                              tag: '$coreTagKey$AppConst.HERO_TAG__UNIT_PRICE',
                              flightShuttleBuilder: Utils.flightShuttleBuilder,
                              child: Material(
                                type: MaterialType.transparency,
                                child: Text(
                                    '${product.currencySymbol}${Utils.getPriceFormat(product.unitPrice)}',
                                    textAlign: TextAlign.start,
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle2
                                        .copyWith(
                                          color: AppColors.mainColor,
                                        ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                                padding: const EdgeInsets.only(
                                    left: AppDimens.space8,
                                    right: AppDimens.space8),
                                child: product.isDiscount == AppConst.ONE
                                    ? Hero(
                                        tag:
                                            '$coreTagKey$AppConst.HERO_TAG__ORIGINAL_PRICE',
                                        flightShuttleBuilder:
                                            Utils.flightShuttleBuilder,
                                        child: Material(
                                          color: AppColors.transparent,
                                          child: Text(
                                              '${product.currencySymbol}${Utils.getPriceFormat(product.originalPrice)}',
                                              textAlign: TextAlign.start,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2
                                                  .copyWith(
                                                      decoration: TextDecoration
                                                          .lineThrough),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1),
                                        ),
                                      )
                                    : Container()),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: AppDimens.space8,
                    )
                  ],
                ),
              ),
            )),
        builder: (BuildContext context, Widget child) {
          return FadeTransition(
              opacity: animation,
              child: Transform(
                  transform: Matrix4.translationValues(
                      0.0, 100 * (1.0 - animation.value), 0.0),
                  child: child));
        });
  }
}
