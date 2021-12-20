import 'package:dni_ecommerce/constant/app_dimens.dart';
import 'package:dni_ecommerce/ui/common/app_expansion_tile.dart';
import 'package:dni_ecommerce/utils/utils.dart';
import 'package:dni_ecommerce/viewobject/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class DescriptionTileView extends StatelessWidget {
  const DescriptionTileView({
    Key key,
    @required this.productDetail,
  }) : super(key: key);

  final Product productDetail;
  @override
  Widget build(BuildContext context) {
    final Widget _expansionTileTitleWidget = Text(
        Utils.getString('description_tile__product_description'),
        style: Theme.of(context).textTheme.subtitle1);
    // if (productDetail != null && productDetail.description != null) {
    return Container(
      child: AppExpansionTile(
        initiallyExpanded: true,
        title: _expansionTileTitleWidget,
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(
                  bottom: AppDimens.space16,
                  left: AppDimens.space16,
                  right: AppDimens.space16),
              child: HtmlWidget(
                  'There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don\'t look even slightly believable. If you are going to use a passage of Lorem Ipsum, you')
              // Text(
              //   ,
              //   style: Theme.of(context).textTheme.bodyText2.copyWith(
              //         height: 1.3,
              //         letterSpacing: 0.5,
              //       ),
              // ),
              )
        ],
      ),
    );
    // } else {
    //   return const Card();
    // }
  }
}
