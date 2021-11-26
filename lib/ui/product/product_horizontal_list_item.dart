import 'package:dni_ecommerce/config/app_colors.dart';
import 'package:dni_ecommerce/constant/app_constant.dart';
import 'package:dni_ecommerce/constant/app_dimens.dart';
import 'package:dni_ecommerce/utils/utils.dart';
import 'package:dni_ecommerce/viewobject/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductHorizontalListItem extends StatelessWidget {
  const ProductHorizontalListItem({
    Key key,
    @required this.product,
    @required this.coreTagKey,
    this.onTap,
  }) : super(key: key);

  final Product product;
  final Function onTap;
  final String coreTagKey;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 0.0,
          color: AppColors.transparent,
          child: Container(
            margin: const EdgeInsets.symmetric(
                horizontal: AppDimens.space4, vertical: AppDimens.space12),
            decoration: BoxDecoration(
              color: AppColors.backgroundColor,
              borderRadius:
                  const BorderRadius.all(Radius.circular(AppDimens.space8)),
            ),
            width: AppDimens.space180,
            child: Stack(
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                              Radius.circular(AppDimens.space8)),
                        ),
                        //   child: ClipPath(
                        //     child: AppNetworkImage(
                        //       photoKey: '$coreTagKey$AppConst.HERO_TAG__IMAGE',
                        //       defaultPhoto: product.defaultPhoto,
                        //       width: AppDimens.space180,
                        //       height: double.infinity,
                        //       boxfit: BoxFit.cover,
                        //       onTap: () {
                        //         print(product.defaultPhoto.imgParentId);
                        //         onTap();
                        //       },
                        //     ),
                        //     clipper: const ShapeBorderClipper(
                        //         shape: RoundedRectangleBorder(
                        //             borderRadius: BorderRadius.only(
                        //                 topLeft:
                        //                     Radius.circular(AppDimens.space8),
                        //                 topRight:
                        //                     Radius.circular(AppDimens.space8)))),
                        //   ),
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
                                tag:
                                    '$coreTagKey$AppConst.HERO_TAG__UNIT_PRICE',
                                flightShuttleBuilder:
                                    Utils.flightShuttleBuilder,
                                child: Material(
                                  type: MaterialType.transparency,
                                  child: Text(
                                      '${product.currencySymbol}${Utils.getPriceFormat(product.unitPrice)}',
                                      textAlign: TextAlign.start,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1
                                          .copyWith(color: AppColors.mainColor),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1),
                                )),
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
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1)))
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
                Row(
                  mainAxisSize: MainAxisSize.max,
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
                )
              ],
            ),
          ),
        ));
  }
}
