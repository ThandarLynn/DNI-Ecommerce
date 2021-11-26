import 'package:dni_ecommerce/config/app_colors.dart';
import 'package:dni_ecommerce/constant/app_dimens.dart';
import 'package:dni_ecommerce/provider/product/search_product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SpecialCheckTextWidget extends StatefulWidget {
  const SpecialCheckTextWidget({
    Key key,
    @required this.title,
    @required this.icon,
    @required this.checkTitle,
    this.size = AppDimens.space20,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final int checkTitle;
  final double size;

  @override
  _SpecialCheckTextWidgetState createState() => _SpecialCheckTextWidgetState();
}

class _SpecialCheckTextWidgetState extends State<SpecialCheckTextWidget> {
  @override
  Widget build(BuildContext context) {
    final SearchProductProvider provider =
        Provider.of<SearchProductProvider>(context);

    return Container(
        width: double.infinity,
        height: AppDimens.space52,
        child: Container(
          margin: const EdgeInsets.all(AppDimens.space12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                      width: widget.size < AppDimens.space20
                          ? AppDimens.space20
                          : widget.size,
                      child: Icon(
                        widget.icon,
                        size: widget.size,
                      )),
                  const SizedBox(
                    width: AppDimens.space12,
                  ),
                  Text(
                    widget.title,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ],
              ),
              if (widget.checkTitle == 1)
                Switch(
                  value: provider.isSwitchedFeaturedProduct,
                  onChanged: (bool value) {
                    setState(() {
                      provider.isSwitchedFeaturedProduct = value;
                    });
                  },
                  activeTrackColor: AppColors.mainColor,
                  activeColor: AppColors.mainColor,
                )
              else if (widget.checkTitle == 2)
                Switch(
                  value: provider.isSwitchedDiscountPrice,
                  onChanged: (bool value) {
                    setState(() {
                      provider.isSwitchedDiscountPrice = value;
                    });
                  },
                  activeTrackColor: AppColors.mainColor,
                  activeColor: AppColors.mainColor,
                )
            ],
          ),
        ));
  }
}
