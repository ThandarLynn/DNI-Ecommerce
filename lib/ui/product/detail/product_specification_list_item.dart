import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:dni_ecommerce/constant/app_dimens.dart';
import 'package:dni_ecommerce/viewobject/ItemSpec.dart';

class ProductSpecificationListItem extends StatelessWidget {
  const ProductSpecificationListItem({
    Key key,
    @required this.productSpecification,
    this.onTap,
  }) : super(key: key);

  final ProductSpecification productSpecification;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                const Icon(
                  MaterialIcons.label_outline,
                ),
                const SizedBox(
                  width: AppDimens.space8,
                ),
                Text(
                  productSpecification.name,
                  style: Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
            IntrinsicHeight(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  const SizedBox(
                    width: AppDimens.space10,
                  ),
                  VerticalDivider(
                      width: 2, color: Theme.of(context).iconTheme.color),
                  const SizedBox(
                    width: AppDimens.space20,
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: AppDimens.space12,
                          left: AppDimens.space12,
                          bottom: AppDimens.space12),
                      child: Text(productSpecification.description,
                          style: Theme.of(context).textTheme.bodyText2,
                          textAlign: TextAlign.start),
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
