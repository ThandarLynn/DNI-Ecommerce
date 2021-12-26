import 'package:flutter/material.dart';
import 'package:dni_ecommerce/config/app_colors.dart';
import 'package:dni_ecommerce/constant/app_dimens.dart';
import 'package:dni_ecommerce/provider/shipping_method/shipping_method_provider.dart';
import 'package:dni_ecommerce/utils/utils.dart';
import 'package:dni_ecommerce/viewobject/shipping_method.dart';

class ShippingMethodItemView extends StatelessWidget {
  const ShippingMethodItemView({
    Key key,
    @required this.shippingMethod,
    @required this.shippingMethodProvider,
    this.onShippingMethodTap(),
  }) : super(key: key);

  final Function onShippingMethodTap;
  final ShippingMethod shippingMethod;
  final ShippingMethodProvider shippingMethodProvider;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onShippingMethodTap,
      child: Container(
          margin: const EdgeInsets.only(left: 5),
          child: checkIsSelected(shippingMethod, context)),
    );
  }

  Widget checkIsSelected(ShippingMethod shippingMethod, BuildContext context) {
    if (shippingMethodProvider.selectedShippingMethod == null &&
        shippingMethodProvider.psValueHolder.shippingId == shippingMethod.id) {
      return Container(
        width: AppDimens.space140,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.mainColor,
            borderRadius:
                const BorderRadius.all(Radius.circular(AppDimens.space8)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: AppDimens.space4,
              ),
              // Align(
              //   alignment: Alignment.center,
              //   child: Text(
              //       '${shippingMethod.currencySymbol}${shippingMethod.price}',
              //       style: Theme.of(context)
              //           .textTheme
              //           .headline5
              //           .copyWith(color: AppColors.white)),
              // ),
              // const SizedBox(
              //   height: AppDimens.space20,
              // ),
              Container(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(shippingMethod.name,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(color: AppColors.white)),
                ),
              ),
              const SizedBox(
                height: AppDimens.space4,
              ),
              Container(
                child: Text(
                    '${shippingMethod.days}  ' +
                        Utils.getString('checkout2__days'),
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(color: AppColors.white)),
              ),
            ],
          ),
        ),
      );
    } else if (shippingMethodProvider.selectedShippingMethod != null &&
        shippingMethod != null &&
        shippingMethodProvider.selectedShippingMethod.id == shippingMethod.id &&
        shippingMethodProvider.selectedShippingMethod.id.isNotEmpty) {
      return Container(
        width: AppDimens.space140,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.mainColor,
            borderRadius:
                const BorderRadius.all(Radius.circular(AppDimens.space8)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: AppDimens.space4,
              ),
              // Align(
              //   alignment: Alignment.center,
              //   child: Text(
              //       '${shippingMethod.currencySymbol}${shippingMethod.price}',
              //       style: Theme.of(context)
              //           .textTheme
              //           .headline5
              //           .copyWith(color: AppColors.white)),
              // ),
              // const SizedBox(
              //   height: AppDimens.space20,
              // ),
              Container(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(shippingMethod.name,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(color: AppColors.white)),
                ),
              ),
              const SizedBox(
                height: AppDimens.space4,
              ),
              Container(
                child: Text(
                    '${shippingMethod.days}  ' +
                        Utils.getString('checkout2__days'),
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(color: AppColors.white)),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container(
        width: AppDimens.space140,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.coreBackgroundColor,
            borderRadius:
                const BorderRadius.all(Radius.circular(AppDimens.space8)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: AppDimens.space4,
              ),
              // Align(
              //   alignment: Alignment.center,
              //   child: Text(
              //       '${shippingMethod.currencySymbol}${shippingMethod.price}',
              //       style: Theme.of(context).textTheme.headline5),
              // ),
              // const SizedBox(
              //   height: AppDimens.space20,
              // ),
              Container(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(shippingMethod.name,
                      style: Theme.of(context).textTheme.bodyText2),
                ),
              ),
              const SizedBox(
                height: AppDimens.space4,
              ),
              Container(
                child: Text(
                    '${shippingMethod.days}  ' +
                        Utils.getString('checkout2__days'),
                    style: Theme.of(context).textTheme.subtitle1),
              ),
            ],
          ),
        ),
      );
    }
  }
}
