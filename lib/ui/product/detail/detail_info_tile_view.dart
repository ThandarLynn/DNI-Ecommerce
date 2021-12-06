// import 'package:flutter/material.dart';
// import 'package:dni_ecommerce/config/app_colors.dart';
// import 'package:dni_ecommerce/constant/app_dimens.dart';
// import 'package:dni_ecommerce/provider/product/product_provider.dart';
// import 'package:dni_ecommerce/ui/common/app_expansion_tile.dart';
// import 'package:dni_ecommerce/ui/product/detail/views/color_list_item_view.dart';
// import 'package:dni_ecommerce/ui/product/specification/product_specification_list_item.dart';
// import 'package:dni_ecommerce/utils/utils.dart';
// import 'package:dni_ecommerce/viewobject/product.dart';

// class DetailInfoTileView extends StatelessWidget {
//   const DetailInfoTileView({
//     Key key,
//     @required this.productDetail,
//   }) : super(key: key);

//   final Product productDetail;

//   @override
//   Widget build(BuildContext context) {
//     final Widget _expansionTileTitleWidget = Text(
//         Utils.getString('detail_info_tile__detail_info'),
//         style: Theme.of(context).textTheme.subtitle1);
//     if (productDetail != null) {
//       return Container(
//         margin: const EdgeInsets.only(
//             left: AppDimens.space12,
//             right: AppDimens.space12,
//             bottom: AppDimens.space12),
//         decoration: BoxDecoration(
//           color: AppColors.backgroundColor,
//           borderRadius:
//               const BorderRadius.all(Radius.circular(AppDimens.space8)),
//         ),
//         child: AppExpansionTile(
//           initiallyExpanded: true,
//           title: _expansionTileTitleWidget,
//           children: <Widget>[
//             Padding(
//               padding: const EdgeInsets.only(
//                   bottom: AppDimens.space16,
//                   left: AppDimens.space16,
//                   right: AppDimens.space16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: <Widget>[
//                   Text(
//                     Utils.getString('detail_info_tile__product_name'),
//                     style: Theme.of(context).textTheme.bodyText1,
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(
//                         top: AppDimens.space12,
//                         left: AppDimens.space12,
//                         bottom: AppDimens.space12),
//                     child: Text(
//                       productDetail.name ?? '',
//                       style: Theme.of(context)
//                           .textTheme
//                           .bodyText2
//                           .copyWith(color: AppColors.mainColor),
//                     ),
//                   ),
//                   if (productDetail.productUnit != '')
//                     Text(
//                       Utils.getString('detail_info_tile__product_unit'),
//                       style: Theme.of(context).textTheme.bodyText1,
//                     )
//                   else
//                     Container(),
//                   if (productDetail.productUnit != '')
//                     Padding(
//                       padding: const EdgeInsets.only(
//                           top: AppDimens.space12,
//                           left: AppDimens.space12,
//                           bottom: AppDimens.space12),
//                       child: Text(
//                         productDetail.productUnit ?? '',
//                         style: Theme.of(context).textTheme.bodyText2,
//                       ),
//                     )
//                   else
//                     Container(),
//                   if (productDetail.productMeasurement != '')
//                     Text(
//                       Utils.getString('detail_info_tile__product_measurement'),
//                       style: Theme.of(context).textTheme.bodyText1,
//                     )
//                   else
//                     Container(),
//                   if (productDetail.productMeasurement != '')
//                     Padding(
//                       padding: const EdgeInsets.only(
//                           top: AppDimens.space12,
//                           left: AppDimens.space12,
//                           bottom: AppDimens.space12),
//                       child: Text(
//                         productDetail.productMeasurement ??
//                             '',
//                         style: Theme.of(context).textTheme.bodyText2,
//                       ),
//                     )
//                   else
//                     Container(),
//                   if (productDetail.minimumOrder != '0')
//                     Text(
//                       Utils.getString('detail_info_tile__mim_order'),
//                       style: Theme.of(context).textTheme.bodyText1,
//                     )
//                   else
//                     Container(),
//                   if (productDetail.minimumOrder != '0')
//                     Padding(
//                       padding: const EdgeInsets.only(
//                           top: AppDimens.space12, left: AppDimens.space12),
//                       child: Text(
//                         productDetail.minimumOrder ?? '',
//                         style: Theme.of(context).textTheme.bodyText2,
//                       ),
//                     )
//                   else
//                     Container(),
//                   if (productDetail.minimumOrder != '0')
//                     const SizedBox(
//                       height: AppDimens.space16,
//                     )
//                   else
//                     Container(),
//                   _ColorsWidget(product: productDetail),
//                   _ProductSpecificationWidget(
//                       product: productDetail),
//                 ],
//               ),
//             )
//           ],
//         ),
//       );
//     } else {
//       return const Card();
//     }
//   }
// }

// class _ColorsWidget extends StatefulWidget {
//   const _ColorsWidget({
//     Key key,
//     @required this.product,
//   }) : super(key: key);

//   final Product product;
//   @override
//   __ColorsWidgetState createState() => __ColorsWidgetState();
// }

// class __ColorsWidgetState extends State<_ColorsWidget> {
//   @override
//   Widget build(BuildContext context) {
//     if (widget.product.itemColorList.isNotEmpty &&
//         widget.product.itemColorList[0].id != '') {
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           const SizedBox(
//             height: AppDimens.space4,
//           ),
//           Text(
//             Utils.getString('product_detail__available_color'),
//             overflow: TextOverflow.ellipsis,
//             maxLines: 1,
//             softWrap: false,
//             style: Theme.of(context).textTheme.bodyText1,
//           ),
//           const SizedBox(
//             height: AppDimens.space4,
//           ),
//           Container(
//             height: 50,
//             child: MediaQuery.removePadding(
//                 context: context,
//                 removeTop: true,
//                 child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: widget.product.itemColorList.length,
//                     itemBuilder: (BuildContext context, int index) {
//                       return ColorListItemView(
//                         color: widget.product.itemColorList[index],
//                         selectedColorId: '',
//                         onColorTap: () {},
//                       );
//                     })),
//           ),
//         ],
//       );
//     } else {
//       return Container();
//     }
//   }
// }

// class _ProductSpecificationWidget extends StatefulWidget {
//   const _ProductSpecificationWidget({
//     Key key,
//     @required this.product,
//   }) : super(key: key);

//   final Product product;
//   @override
//   __ProductSpecificationWidgetState createState() =>
//       __ProductSpecificationWidgetState();
// }

// class __ProductSpecificationWidgetState
//     extends State<_ProductSpecificationWidget> {
//   @override
//   Widget build(BuildContext context) {
//     if (widget.product.itemSpecList.isNotEmpty &&
//         widget.product.itemSpecList[0].id != '') {
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           const SizedBox(
//             height: AppDimens.space20,
//           ),
//           Text(
//             Utils.getString('detail_info_tile__detail_info'),
//             overflow: TextOverflow.ellipsis,
//             maxLines: 1,
//             softWrap: false,
//             style: Theme.of(context).textTheme.bodyText1,
//           ),
//           ListView.builder(
//             physics: const NeverScrollableScrollPhysics(),
//             shrinkWrap: true,
//             itemCount: widget.product.itemSpecList.length,
//             itemBuilder: (BuildContext context, int index) {
//               return ProductSpecificationListItem(
//                 productSpecification: widget.product.itemSpecList[index],
//               );
//             },
//           ),
//           const SizedBox(
//             height: AppDimens.space4,
//           ),
//         ],
//       );
//     } else {
//       return Container();
//     }
//   }
// }
