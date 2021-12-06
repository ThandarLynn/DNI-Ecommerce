import 'dart:async';
import 'package:dni_ecommerce/ui/common/app_back_button_with_circle_bg_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dni_ecommerce/config/app_colors.dart';
import 'package:dni_ecommerce/constant/app_constant.dart';
import 'package:dni_ecommerce/constant/app_dimens.dart';
import 'package:dni_ecommerce/constant/route_paths.dart';
import 'package:dni_ecommerce/provider/basket/basket_provider.dart';
import 'package:dni_ecommerce/provider/history/history_provider.dart';
import 'package:dni_ecommerce/provider/user/user_provider.dart';
import 'package:dni_ecommerce/repository/basket_repository.dart';
import 'package:dni_ecommerce/repository/history_repsitory.dart';
import 'package:dni_ecommerce/repository/product_repository.dart';
import 'package:dni_ecommerce/repository/user_repository.dart';
import 'package:dni_ecommerce/ui/common/app_ui_widget.dart';
import 'package:dni_ecommerce/ui/common/dialog/warning_dialog_view.dart';
import 'package:dni_ecommerce/ui/common/app_button_widget.dart';
import 'package:dni_ecommerce/ui/common/app_widget_with_multi_provider.dart';
import 'package:dni_ecommerce/utils/utils.dart';
import 'package:dni_ecommerce/viewobject/basket.dart';
import 'package:dni_ecommerce/viewobject/basket_selected_attribute.dart';
import 'package:dni_ecommerce/viewobject/common/app_value_holder.dart';
import 'package:dni_ecommerce/viewobject/product.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'description_tile_view.dart';

class ProductDetailView extends StatefulWidget {
  const ProductDetailView({
    @required this.productDetail,
    this.heroTagImage,
    this.heroTagTitle,
    this.heroTagOriginalPrice,
    this.heroTagUnitPrice,
    this.intentId,
    this.intentQty,
    this.intentSelectedColorId,
    this.intentSelectedColorValue,
    this.intentBasketPrice,
    this.intentBasketSelectedAttributeList,
  });

  final String intentId;
  final String intentBasketPrice;
  final List<BasketSelectedAttribute> intentBasketSelectedAttributeList;
  final String intentSelectedColorId;
  final String intentSelectedColorValue;
  final Product productDetail;
  final String intentQty;
  final String heroTagImage;
  final String heroTagTitle;
  final String heroTagOriginalPrice;
  final String heroTagUnitPrice;
  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetailView>
    with SingleTickerProviderStateMixin {
  ProductRepository productRepo;
  HistoryRepository historyRepo;
  HistoryProvider historyProvider;
  // TouchCountProvider touchCountProvider;
  BasketProvider basketProvider;
  AppValueHolder valueHolder;
  AnimationController controller;
  BasketRepository basketRepository;
  UserProvider userProvider;
  UserRepository userRepo;
  bool isCallFirstTime = true;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 140),
    );
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  List<Product> basketList = <Product>[];
  bool isReadyToShowAppBarIcons = false;

  @override
  Widget build(BuildContext context) {
    print('****** Building *********');
    if (!isReadyToShowAppBarIcons) {
      Timer(const Duration(milliseconds: 800), () {
        setState(() {
          isReadyToShowAppBarIcons = true;
        });
      });
    }

    valueHolder = Provider.of<AppValueHolder>(context);
    productRepo = Provider.of<ProductRepository>(context);
    historyRepo = Provider.of<HistoryRepository>(context);
    basketRepository = Provider.of<BasketRepository>(context);
    userRepo = Provider.of<UserRepository>(context);

    return AppWidgetWithMultiProvider(
        child: MultiProvider(
            providers: <SingleChildWidget>[
          // ChangeNotifierProvider<ProductDetailProvider>(
          //   lazy: false,
          //   create: (BuildContext context) {
          //     productDetailProvider = ProductDetailProvider(
          //         repo: productRepo, psValueHolder: psValueHolder);

          //     final String loginUserId = Utils.checkUserLoginId(psValueHolder);
          //     productDetailProvider.loadProduct(widget.productId, loginUserId);

          //     return productDetailProvider;
          //   },
          // ),
          // ChangeNotifierProvider<UserProvider>(
          //   lazy: false,
          //   create: (BuildContext context) {
          //     userProvider =
          //         UserProvider(repo: userRepo, psValueHolder: valueHolder);
          //     userProvider.getUser(Utils.checkUserLoginId(valueHolder));
          //     return userProvider;
          //   },
          // ),
          ChangeNotifierProvider<BasketProvider>(
              lazy: false,
              create: (BuildContext context) {
                basketProvider = BasketProvider(repo: basketRepository);
                return basketProvider;
              }),
          ChangeNotifierProvider<HistoryProvider>(
            lazy: false,
            create: (BuildContext context) {
              historyProvider = HistoryProvider(repo: historyRepo);
              return historyProvider;
            },
          ),
          // ChangeNotifierProvider<TouchCountProvider>(
          //   lazy: false,
          //   create: (BuildContext context) {
          //     touchCountProvider = TouchCountProvider(
          //         repo: productRepo, psValueHolder: psValueHolder);
          //     final String loginUserId = Utils.checkUserLoginId(psValueHolder);

          //     final TouchCountParameterHolder touchCountParameterHolder =
          //         TouchCountParameterHolder(
          //             typeId: widget.productId,
          //             typeName: AppConst.FILTERING_TYPE_NAME_PRODUCT,
          //             userId: loginUserId);
          //     touchCountProvider
          //         .postTouchCount(touchCountParameterHolder.toMap());
          //     return touchCountProvider;
          //   },
          // )
        ],
            child: Consumer<BasketProvider>(builder:
                (BuildContext context, BasketProvider provider, Widget child) {
              if (widget.productDetail != null) {
                //   provider.updateProduct(provider.productDetail.data);
                if (isCallFirstTime) {
                  ///
                  /// Load Basket List
                  ///
                  basketProvider =
                      Provider.of<BasketProvider>(context, listen: false);

                  basketProvider.loadBasketList();

                  ///
                  /// Add to History
                  ///
                  // historyProvider.addHistoryList(widget.productDetail);

                  isCallFirstTime = false;
                }
                return Stack(
                  children: <Widget>[
                    CustomScrollView(slivers: <Widget>[
                      SliverAppBar(
                        automaticallyImplyLeading: true,
                        brightness: Utils.getBrightnessForAppBar(context),
                        expandedHeight: AppDimens.space300,
                        iconTheme: Theme.of(context)
                            .iconTheme
                            .copyWith(color: AppColors.mainColorWithWhite),
                        leading: AppBackButtonWithCircleBgWidget(
                          isReadyToShow: isReadyToShowAppBarIcons,
                        ),
                        floating: false,
                        pinned: false,
                        stretch: true,
                        actions: <Widget>[
                          Consumer<BasketProvider>(builder:
                              (BuildContext context,
                                  BasketProvider basketProvider, Widget child) {
                            return Visibility(
                              visible: isReadyToShowAppBarIcons,
                              child: Row(
                                children: <Widget>[
                                  InkWell(
                                      child: Stack(
                                        children: <Widget>[
                                          Container(
                                            width: AppDimens.space40,
                                            height: AppDimens.space40,
                                            margin: const EdgeInsets.only(
                                                top: AppDimens.space8,
                                                left: AppDimens.space8,
                                                right: AppDimens.space8),
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Icon(
                                                Icons.shopping_basket,
                                                color: AppColors.mainColor,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            right: AppDimens.space4,
                                            top: AppDimens.space1,
                                            child: Container(
                                              width: AppDimens.space28,
                                              height: AppDimens.space28,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: AppColors.black
                                                    .withAlpha(200),
                                              ),
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  basketProvider.basketList.data
                                                              .length >
                                                          99
                                                      ? '99+'
                                                      : basketProvider
                                                          .basketList
                                                          .data
                                                          .length
                                                          .toString(),
                                                  textAlign: TextAlign.left,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1
                                                      .copyWith(
                                                          color:
                                                              AppColors.white),
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          RoutePaths.basketList,
                                        );
                                      }),
                                ],
                              ),
                            );
                          })
                        ],
                        backgroundColor: AppColors.mainColorWithBlack,
                        flexibleSpace: FlexibleSpaceBar(
                          background: Container(
                            color: AppColors.backgroundColor,
                            child: AppNetworkImageWithUrl(
                              photoKey: widget
                                  .heroTagImage, //'latest${widget.product.defaultPhoto.imgId}',
                              imagePath: widget.productDetail.image,
                              width: double.infinity,
                              //  height: double.infinity,
                              onTap: () {
                                Navigator.pushNamed(
                                    context, RoutePaths.galleryGrid,
                                    arguments: widget.productDetail);
                              },
                            ),
                          ),
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildListDelegate(<Widget>[
                          Container(
                            color: AppColors.baseColor,
                            child: Column(children: <Widget>[
                              _HeaderBoxWidget(
                                  productDetail: widget.productDetail,
                                  historyProvider: historyProvider,
                                  originalPriceFormatString:
                                      Utils.getPriceFormat(
                                          widget.productDetail.originalPrice),
                                  unitPriceFormatString: Utils.getPriceFormat(
                                      widget.productDetail.unitPrice),
                                  heroTagTitle: widget.heroTagTitle,
                                  heroTagOriginalPrice:
                                      widget.heroTagOriginalPrice,
                                  heroTagUnitPrice: widget.heroTagUnitPrice),
                              // DetailInfoTileView(
                              //   productDetail: widget.productDetail,
                              // ),
                              const SizedBox(
                                height: AppDimens.space40,
                              ),
                            ]),
                          )
                        ]),
                      )
                    ]),
                    _AddToBasketAndBuyButtonWidget(
                      controller: controller,
                      basketProvider: basketProvider,
                      productDetail: widget.productDetail,
                      psValueHolder: valueHolder,
                      intentQty: widget.intentQty ?? '',
                      intentSelectedColorId: widget.intentSelectedColorId ?? '',
                      intentSelectedColorValue:
                          widget.intentSelectedColorValue ?? '',
                      intentbasketPrice: widget.intentBasketPrice ?? '',
                      intentbasketSelectedAttributeList:
                          widget.intentBasketSelectedAttributeList ??
                              <BasketSelectedAttribute>[],
                    )
                  ],
                );
              } else {
                return Container();
              }
            })));
  }
}

class _HeaderBoxWidget extends StatefulWidget {
  const _HeaderBoxWidget(
      {Key key,
      @required this.productDetail,
      @required this.historyProvider,
      @required this.originalPriceFormatString,
      @required this.unitPriceFormatString,
      @required this.heroTagTitle,
      @required this.heroTagOriginalPrice,
      @required this.heroTagUnitPrice})
      : super(key: key);

  final Product productDetail;
  final HistoryProvider historyProvider;
  final String originalPriceFormatString;
  final String unitPriceFormatString;
  final String heroTagTitle;
  final String heroTagOriginalPrice;
  final String heroTagUnitPrice;

  @override
  __HeaderBoxWidgetState createState() => __HeaderBoxWidgetState();
}

class __HeaderBoxWidgetState extends State<_HeaderBoxWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.productDetail != null) {
      return Container(
        margin: const EdgeInsets.all(AppDimens.space12),
        decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius:
              const BorderRadius.all(Radius.circular(AppDimens.space8)),
        ),
        child: Column(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(AppDimens.space16),
                child: Column(
                  children: <Widget>[
                    _FavouriteWidget(
                        historyProvider: widget.historyProvider,
                        productDetail: widget.productDetail,
                        heroTagTitle: widget.heroTagTitle),
                    const SizedBox(
                      height: AppDimens.space12,
                    ),
                    _HeaderPriceWidget(
                      product: widget.productDetail,
                      originalPriceFormatString:
                          widget.originalPriceFormatString,
                      unitPriceFormatString: widget.unitPriceFormatString,
                      heroTagOriginalPrice: widget.heroTagOriginalPrice,
                      heroTagUnitPrice: widget.heroTagUnitPrice,
                    ),
                    const SizedBox(
                      height: AppDimens.space12,
                    ),
                    Divider(
                      height: AppDimens.space1,
                      color: AppColors.mainColor,
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(
                    //       top: AppDimens.space16, bottom: AppDimens.space4),
                    //   child: _HeaderRatingWidget(
                    //     productDetail: widget.productDetail,
                    //   ),
                    // ),
                  ],
                )),
            Container(
              margin: const EdgeInsets.only(
                  left: AppDimens.space20,
                  right: AppDimens.space20,
                  bottom: AppDimens.space8),
              child: Card(
                elevation: 0.0,
                shape: const BeveledRectangleBorder(
                  borderRadius:
                      BorderRadius.all(Radius.circular(AppDimens.space8)),
                ),
                color: AppColors.baseLightColor,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    ' This product is very good. loream jj lasjd  kj aa os fl lsjfskk l...',
                    // widget.productDetail.description?? '',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                        letterSpacing: 0.8, fontSize: 16, height: 1.3),
                  ),
                ),
              ),
            ),
            DescriptionTileView(
              productDetail: widget.productDetail,
            ),
            const Divider(
              height: AppDimens.space1,
            ),
            _HeaderButtonWidget(
              productDetail: widget.productDetail,
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}

class _FavouriteWidget extends StatefulWidget {
  const _FavouriteWidget(
      {Key key,
      @required this.productDetail,
      @required this.heroTagTitle,
      @required this.historyProvider})
      : super(key: key);

  final Product productDetail;
  final String heroTagTitle;
  final HistoryProvider historyProvider;

  @override
  __FavouriteWidgetState createState() => __FavouriteWidgetState();
}

class __FavouriteWidgetState extends State<_FavouriteWidget> {
  Widget icon;
  ProductRepository favouriteRepo;
  AppValueHolder psValueHolder;

  @override
  Widget build(BuildContext context) {
    favouriteRepo = Provider.of<ProductRepository>(context);
    psValueHolder = Provider.of<AppValueHolder>(context);

    if (widget.productDetail != null) {
      return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Hero(
                  tag: widget.heroTagTitle,
                  child: Text(
                    widget.productDetail.name ?? '',
                    style: Theme.of(context).textTheme.headline5,
                  )),
            ),
            GestureDetector(
                onTap: () {
                  setState(() {
                    widget.productDetail.isFavourited =
                        widget.productDetail.isFavourited == AppConst.ONE
                            ? '0'
                            : '1';
                  });
                  widget.historyProvider.addHistoryList(widget.productDetail);
                },
                child: (widget.productDetail != null)
                    ? widget.productDetail.isFavourited == AppConst.ZERO
                        ? icon = Container(
                            padding: const EdgeInsets.only(
                                top: AppDimens.space8,
                                left: AppDimens.space8,
                                right: AppDimens.space8,
                                bottom: AppDimens.space6),
                            decoration: BoxDecoration(
                                border: Border.all(color: AppColors.mainColor),
                                shape: BoxShape.circle),
                            child: Icon(Icons.favorite_border,
                                color: AppColors.mainColor),
                          )
                        : icon = Container(
                            padding: const EdgeInsets.only(
                                top: AppDimens.space8,
                                left: AppDimens.space8,
                                right: AppDimens.space8,
                                bottom: AppDimens.space6),
                            decoration: BoxDecoration(
                                border: Border.all(color: AppColors.mainColor),
                                shape: BoxShape.circle),
                            child: Icon(Icons.favorite,
                                color: AppColors.mainColor),
                          )
                    : icon = Container())
          ]);
    } else {
      return Container();
    }
  }
}

// class _HeaderRatingWidget extends StatefulWidget {
//   const _HeaderRatingWidget({
//     Key key,
//     @required this.productDetail,
//   }) : super(key: key);

//   final Product productDetail;

//   @override
//   __HeaderRatingWidgetState createState() => __HeaderRatingWidgetState();
// }

// class __HeaderRatingWidgetState extends State<_HeaderRatingWidget> {
//   @override
//   Widget build(BuildContext context) {
//     dynamic result;
//     if (widget.productDetail != null) {
//       return Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: <Widget>[
//           InkWell(
//             onTap: () async {
//               result = await Navigator.pushNamed(context, RoutePaths.ratingList,
//                   arguments: widget.productDetail.id);

//               if (result != null && result) {
//                 setState(() {});
//               }
//               // print(
//               //     'totalRatingValue ${widget.productDetail.ratingDetail.totalRatingValue}');
//             },
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 SmoothStarRating(
//                     key:
//                         Key(widget.productDetail.ratingDetail.totalRatingValue),
//                     rating: double.parse(
//                         widget.productDetail.ratingDetail.totalRatingValue),
//                     allowHalfRating: false,
//                     isReadOnly: true,
//                     starCount: 5,
//                     size: AppDimens.space16,
//                     color: AppColors.ratingColor,
//                     borderColor: AppColors.grey.withAlpha(100),
//                     onRated: (double v) async {},
//                     spacing: 0.0),
//                 const SizedBox(
//                   height: AppDimens.space10,
//                 ),
//                 GestureDetector(
//                     onTap: () async {
//                       result = await Navigator.pushNamed(
//                           context, RoutePaths.ratingList,
//                           arguments: widget.productDetail.id);

//                       if (result != null && result) {
//                         // setState(() {

//                         // });
//                       }
//                     },
//                     child: (widget.productDetail.overallRating != '0')
//                         ? Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: <Widget>[
//                               Text(
//                                 widget.productDetail.ratingDetail
//                                         .totalRatingValue ??
//                                     '',
//                                 textAlign: TextAlign.left,
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .bodyText2
//                                     .copyWith(),
//                               ),
//                               const SizedBox(
//                                 width: AppDimens.space4,
//                               ),
//                               Text(
//                                 '${Utils.getString('product_detail__out_of_five_stars')}(' +
//                                     widget.productDetail.ratingDetail
//                                         .totalRatingCount +
//                                     ' ${Utils.getString('product_detail__reviews')})',
//                                 overflow: TextOverflow.ellipsis,
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .bodyText2
//                                     .copyWith(),
//                               ),
//                             ],
//                           )
//                         : Text(Utils.getString('product_detail__no_rating'))),
//                 const SizedBox(
//                   height: AppDimens.space10,
//                 ),
//                 if (widget.productDetail.isAvailable == '1')
//                   Text(
//                     Utils.getString('product_detail__in_stock'),
//                     style: Theme.of(context)
//                         .textTheme
//                         .bodyText2
//                         .copyWith(color: AppColors.mainDarkColor),
//                   )
//                 else
//                   Container(),
//               ],
//             ),
//           ),
//           Expanded(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.end,
//               mainAxisSize: MainAxisSize.max,
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: <Widget>[
//                 if (widget.productDetail.isFeatured == '0')
//                   Container()
//                 else
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: <Widget>[
//                       Image.asset(
//                         'assets/images/baseline_feature_circle_24.png',
//                         width: AppDimens.space32,
//                         height: AppDimens.space32,
//                       ),
//                       const SizedBox(
//                         width: AppDimens.space8,
//                       ),
//                       Text(
//                         Utils.getString('product_detail__featured_products'),
//                         overflow: TextOverflow.ellipsis,
//                         style: Theme.of(context).textTheme.bodyText2.copyWith(
//                               color: AppColors.mainColor,
//                             ),
//                       ),
//                     ],
//                   ),
//                 const SizedBox(
//                   height: AppDimens.space8,
//                 ),
//                 Text(
//                   widget.productDetail.code ?? '',
//                   style: Theme.of(context)
//                       .textTheme
//                       .bodyText2
//                       .copyWith(color: AppColors.mainDarkColor),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       );
//     } else {
//       return Container();
//     }
//   }
// }

class _HeaderPriceWidget extends StatefulWidget {
  const _HeaderPriceWidget({
    Key key,
    @required this.product,
    @required this.originalPriceFormatString,
    @required this.unitPriceFormatString,
    @required this.heroTagOriginalPrice,
    @required this.heroTagUnitPrice,
  }) : super(key: key);

  final Product product;
  final String originalPriceFormatString;
  final String unitPriceFormatString;
  final String heroTagOriginalPrice;
  final String heroTagUnitPrice;
  @override
  __HeaderPriceWidgetState createState() => __HeaderPriceWidgetState();
}

class __HeaderPriceWidgetState extends State<_HeaderPriceWidget> {
  // Future<bool> requestWritePermission() async {
  //   // final Map<PermissionGroup, PermissionStatus> permissionss =
  //   //     await PermissionHandler()
  //   //         .requestPermissions(<PermissionGroup>[PermissionGroup.storage]);
  //   // if (permissionss != null &&
  //   //     permissionss.isNotEmpty &&
  //   //     permissionss[PermissionGroup.storage] == PermissionStatus.granted) {
  //   //   return true;
  //   // } else {
  //   //   return false;
  //   // }

  //   final Permission _photos = Permission.photos;
  //   final PermissionStatus permissionss = await _photos.request();

  //   if (permissionss != null && permissionss == PermissionStatus.granted) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    print('******* ${widget.unitPriceFormatString}');
    if (widget.product != null && widget.product.unitPrice != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            color: AppColors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                if (widget.product.originalPrice != AppConst.ZERO)
                  Hero(
                      tag: widget.heroTagOriginalPrice,
                      flightShuttleBuilder: Utils.flightShuttleBuilder,
                      child: Material(
                          color: AppColors.transparent,
                          child: Text(
                            '\$${widget.originalPriceFormatString}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(
                                    decoration: TextDecoration.lineThrough),
                          )))
                else
                  Container(),
                const SizedBox(
                  height: AppDimens.space4,
                ),
                Hero(
                  tag: widget.heroTagUnitPrice,
                  flightShuttleBuilder: Utils.flightShuttleBuilder,
                  child: Material(
                      color: AppColors.transparent,
                      child: Text(
                        '\$${widget.unitPriceFormatString}',
                        //overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            .copyWith(color: AppColors.mainColor),
                      )),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: AppDimens.space16,
          ),
          if (widget.product.originalPrice != AppConst.ZERO)
            Card(
              elevation: 0,
              color: AppColors.mainColor,
              shape: const BeveledRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppDimens.space8),
                      bottomLeft: Radius.circular(AppDimens.space8))),
              child: Container(
                width: 60,
                height: 30,
                padding: const EdgeInsets.only(
                    left: AppDimens.space4, right: AppDimens.space4),
                child: Align(
                  child: Text(
                    '-' +
                        Utils.calculateDiscountPercent(
                                widget.product.originalPrice,
                                widget.product.unitPrice)
                            .toString() +
                        '%',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        .copyWith(color: AppColors.white),
                  ),
                ),
              ),
            )
          else
            Container(),
          const SizedBox(
            width: AppDimens.space10,
          ),
        ],
      );
    } else {
      return Container();
    }
  }
}

class _HeaderButtonWidget extends StatelessWidget {
  const _HeaderButtonWidget({
    Key key,
    @required this.productDetail,
  }) : super(key: key);

  final Product productDetail;
  @override
  Widget build(BuildContext context) {
    if (productDetail != null) {
      return Container(
        margin: const EdgeInsets.symmetric(
            horizontal: AppDimens.space4, vertical: AppDimens.space12),
        decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius:
              const BorderRadius.all(Radius.circular(AppDimens.space8)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              top: AppDimens.space10, bottom: AppDimens.space10),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    productDetail.favouriteCount ?? '',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  const SizedBox(
                    height: AppDimens.space8,
                  ),
                  Text(
                    Utils.getString('product_detail__whih_list'),
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Text(
                    productDetail.touchCount ?? '',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  const SizedBox(
                    height: AppDimens.space8,
                  ),
                  Text(
                    Utils.getString('product_detail__seen'),
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              )
            ],
          ),
        ),
      );
    } else {
      return const Card();
    }
  }
}

class _AddToBasketAndBuyButtonWidget extends StatefulWidget {
  const _AddToBasketAndBuyButtonWidget({
    Key key,
    @required this.controller,
    @required this.basketProvider,
    @required this.productDetail,
    @required this.psValueHolder,
    @required this.intentQty,
    @required this.intentSelectedColorId,
    @required this.intentSelectedColorValue,
    @required this.intentbasketPrice,
    @required this.intentbasketSelectedAttributeList,
  }) : super(key: key);

  final AnimationController controller;
  final BasketProvider basketProvider;
  final Product productDetail;
  final AppValueHolder psValueHolder;
  final String intentQty;
  final String intentSelectedColorId;
  final String intentSelectedColorValue;
  final String intentbasketPrice;
  final List<BasketSelectedAttribute> intentbasketSelectedAttributeList;

  @override
  __AddToBasketAndBuyButtonWidgetState createState() =>
      __AddToBasketAndBuyButtonWidgetState();
}

class __AddToBasketAndBuyButtonWidgetState
    extends State<_AddToBasketAndBuyButtonWidget> {
  String qty;
  String colorId;
  String colorValue;
  bool checkAttribute;
  BasketSelectedAttribute basketSelectedAttribute = BasketSelectedAttribute();
  Basket basket;
  String id;
  double bottomSheetPrice;
  double totalOriginalPrice = 0.0;

  @override
  Widget build(BuildContext context) {
    if (widget.intentQty != '') {
      qty = widget.intentQty;
    }
    if (widget.intentSelectedColorValue != '' &&
        widget.intentSelectedColorId != '') {
      colorId = widget.intentSelectedColorId;
      colorValue = widget.intentSelectedColorValue;
    }
    if (widget.intentbasketPrice != '') {
      bottomSheetPrice = double.parse(widget.intentbasketPrice);
    }
    if (widget.intentbasketSelectedAttributeList != null) {
      for (int i = 0;
          i < widget.intentbasketSelectedAttributeList.length;
          i++) {
        basketSelectedAttribute.addAttribute(BasketSelectedAttribute(
            headerId: widget.intentbasketSelectedAttributeList[i].headerId,
            id: widget.intentbasketSelectedAttributeList[i].id,
            name: widget.intentbasketSelectedAttributeList[i].name,
            price: widget.intentbasketSelectedAttributeList[i].price,
            currencySymbol: '\$'));
      }
    }
    // Future<void> updatePrice(double price, double totalOriginalPrice) async {
    //   this.totalOriginalPrice = totalOriginalPrice;
    //   setState(() {
    //     bottomSheetPrice = price;
    //   });
    // }

    Future<void> updateQty(String minimumOrder) async {
      setState(() {
        qty = minimumOrder;
      });
    }

    // Future<void> updateColorIdAndValue(String id, String value) async {
    //   colorId = id;
    //   colorValue = value;
    // }

    Future<void> addToBasketAndBuyClickEvent(bool isBuyButtonType) async {
      // if (widget.product.itemColorList.isNotEmpty &&
      //     widget.product.itemColorList[0].id != '') {
      //   if (colorId == null || colorId == '') {
      //     await showDialog<dynamic>(
      //         context: context,
      //         builder: (BuildContext context) {
      //           return WarningDialog(
      //             message:
      //                 Utils.getString('product_detail__please_select_color'),
      //             onPressed: () {},
      //           );
      //         });
      //     return;
      //   }
      // }
      id =
          '${widget.productDetail.id}$colorId ${basketSelectedAttribute.getSelectedAttributeIdByHeaderId()}';
      // Check All Attribute is selected

      basket = Basket(
          id: id,
          productId: widget.productDetail.id,
          qty: qty ?? widget.productDetail.minimumOrder,
          shopId: widget.psValueHolder.shopId,
          selectedColorId: colorId,
          selectedColorValue: colorValue,
          basketPrice: bottomSheetPrice == null
              ? widget.productDetail.unitPrice
              : bottomSheetPrice.toString(),
          basketOriginalPrice: totalOriginalPrice == 0.0
              ? widget.productDetail.originalPrice
              : totalOriginalPrice.toString(),
          selectedAttributeTotalPrice: basketSelectedAttribute
              .getTotalSelectedAttributePrice()
              .toString(),
          product: widget.productDetail,
          basketSelectedAttributeList:
              basketSelectedAttribute.getSelectedAttributeList());

      await widget.basketProvider.addBasket(basket);

      Fluttertoast.showToast(
          msg: Utils.getString('product_detail__success_add_to_basket'),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: AppColors.mainColor,
          textColor: AppColors.white);

      if (isBuyButtonType) {
        final dynamic result = await Navigator.pushNamed(
            context, RoutePaths.basketList,
            arguments: widget.productDetail);
        if (result != null && result) {
          // widget.productProvider
          //     .loadProduct(widget.product.id, widget.psValueHolder.loginUserId);
        }
      }
    }

    void _showDrawer(bool isBuyButtonType) {
      showModalBottomSheet<Widget>(
          elevation: 3.0,
          isScrollControlled: true,
          useRootNavigator: true,
          isDismissible: true,
          context: context,
          builder: (BuildContext context) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const SizedBox(height: AppDimens.space12),
                    Container(
                      width: AppDimens.space52,
                      height: AppDimens.space4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: AppColors.mainDividerColor,
                      ),
                    ),
                    const SizedBox(height: AppDimens.space24),
                  ],
                ),
                _ImageAndTextForBottomSheetWidget(
                  product: widget.productDetail,
                  price: bottomSheetPrice ??
                      double.parse(widget.productDetail.unitPrice),
                ),
                Divider(height: AppDimens.space20, color: AppColors.mainColor),
                Flexible(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: AppDimens.space16,
                          right: AppDimens.space16,
                          top: AppDimens.space8,
                          bottom: AppDimens.space16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(
                                top: AppDimens.space8,
                                left: AppDimens.space12,
                                right: AppDimens.space12),
                            child: Text(
                              Utils.getString('product_detail__how_many'),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              softWrap: false,
                            ),
                          ),
                          _IconAndTextWidget(
                            product: widget.productDetail,
                            updateQty: updateQty,
                            qty: qty,
                          ),
                          const SizedBox(
                            height: AppDimens.space12,
                          ),
                          if (isBuyButtonType)
                            _AddToBasketAndBuyForBottomSheetWidget(
                              addToBasketAndBuyClickEvent:
                                  addToBasketAndBuyClickEvent,
                              isBuyButtonType: true,
                            )
                          else
                            _AddToBasketAndBuyForBottomSheetWidget(
                              addToBasketAndBuyClickEvent:
                                  addToBasketAndBuyClickEvent,
                              isBuyButtonType: false,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          });
    }

    if (widget.productDetail != null &&
        widget.basketProvider != null &&
        widget.basketProvider.basketList != null &&
        widget.basketProvider.basketList.data != null) {
      return Container(
        alignment: Alignment.bottomCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Container(
            //   margin: const EdgeInsets.symmetric(horizontal: AppDimens.space8),
            //   child: _FloatingActionButton(
            //     icons: icons,
            //     label: iconsLabel,
            //     controller: widget.controller,
            //     psValueHolder: widget.psValueHolder,
            //   ),
            // ),
            // const SizedBox(height: AppDimens.space12),
            SizedBox(
              width: double.infinity,
              height: AppDimens.space72,
              child: Padding(
                padding: const EdgeInsets.all(AppDimens.space8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: PSButtonWithIconWidget(
                        hasShadow: true,
                        colorData: AppColors.mainColor,
                        icon: Icons.add_shopping_cart,
                        width: double.infinity,
                        titleText:
                            Utils.getString('product_detail__add_to_basket'),
                        onPressed: () async {
                          if (widget.productDetail.isAvailable == '1') {
                            _showDrawer(false);
                          } else {
                            showDialog<dynamic>(
                                context: context,
                                builder: (BuildContext context) {
                                  return WarningDialog(
                                    message: Utils.getString(
                                        'product_detail__is_not_available'),
                                    onPressed: () {},
                                  );
                                });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}

class _ImageAndTextForBottomSheetWidget extends StatefulWidget {
  const _ImageAndTextForBottomSheetWidget({
    Key key,
    @required this.product,
    @required this.price,
  }) : super(key: key);

  final Product product;
  final double price;
  @override
  __ImageAndTextForBottomSheetWidgetState createState() =>
      __ImageAndTextForBottomSheetWidgetState();
}

class __ImageAndTextForBottomSheetWidgetState
    extends State<_ImageAndTextForBottomSheetWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
          left: AppDimens.space16,
          right: AppDimens.space16,
          top: AppDimens.space8),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: AppDimens.space60,
            height: AppDimens.space60,
            child: AppNetworkImage(
              photoKey: '',
              defaultPhoto: widget.product.defaultPhoto,
            ),
          ),
          const SizedBox(
            width: AppDimens.space8,
          ),
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: AppDimens.space8),
                  child: (widget.product.originalPrice != AppConst.ZERO)
                      ? Row(
                          children: <Widget>[
                            Text(
                              widget.price != null
                                  ? '\$ ${Utils.getPriceFormat(widget.price.toString())}'
                                  : '\$ ${Utils.getPriceFormat(widget.product.unitPrice)}',
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(color: AppColors.mainColor),
                            ),
                            const SizedBox(
                              width: AppDimens.space8,
                            ),
                            Text(
                              '\$ ${Utils.getPriceFormat(widget.product.originalPrice)}',
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(
                                      decoration: TextDecoration.lineThrough),
                            )
                          ],
                        )
                      : Text(
                          widget.price != null
                              ? '\$ ${Utils.getPriceFormat(widget.price.toString())}'
                              : '\$ ${Utils.getPriceFormat(widget.product.unitPrice)}',
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              .copyWith(color: AppColors.mainColor),
                        ),
                ),
                const SizedBox(
                  height: AppDimens.space2,
                ),
                Text(
                  widget.product.name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .copyWith(color: AppColors.grey),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _IconAndTextWidget extends StatefulWidget {
  const _IconAndTextWidget({
    Key key,
    @required this.product,
    @required this.updateQty,
    @required this.qty,
  }) : super(key: key);

  final Product product;
  final Function updateQty;
  final String qty;

  @override
  _IconAndTextWidgetState createState() => _IconAndTextWidgetState();
}

class _IconAndTextWidgetState extends State<_IconAndTextWidget> {
  int orderQty = 0;
  int maximumOrder = 0;
  int minimumOrder = 1; // 1 is default

  void initMinimumOrder() {
    if (widget.product.minimumOrder != '0' &&
        widget.product.minimumOrder != '' &&
        widget.product.minimumOrder != null) {
      minimumOrder = int.parse(widget.product.minimumOrder);
    }
  }

  void initMaximumOrder() {
    if (widget.product.maximumOrder != '0' &&
        widget.product.maximumOrder != '' &&
        widget.product.maximumOrder != null) {
      maximumOrder = int.parse(widget.product.maximumOrder);
    }
  }

  void initQty() {
    if (orderQty == 0 && widget.qty != null && widget.qty != '') {
      orderQty = int.parse(widget.qty);
    } else if (orderQty == 0) {
      orderQty = int.parse(widget.product.minimumOrder);
    }
  }

  void _increaseItemCount() {
    if (orderQty + 1 <= maximumOrder || maximumOrder == 0) {
      setState(() {
        orderQty++;
        widget.updateQty('$orderQty');
      });
    } else {
      Fluttertoast.showToast(
          msg:
              ' ${Utils.getString('product_detail__maximum_order')}  ${widget.product.maximumOrder}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: AppColors.mainColor,
          textColor: AppColors.white);
    }
  }

  void _decreaseItemCount() {
    if (orderQty != 0 && orderQty > minimumOrder) {
      orderQty--;
      setState(() {
        widget.updateQty('$orderQty');
      });
    } else {
      Fluttertoast.showToast(
          msg:
              ' ${Utils.getString('product_detail__minimum_order')}  ${widget.product.minimumOrder}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: AppColors.mainColor,
          textColor: AppColors.white);
    }
  }

  void onUpdateItemCount(int buttonType) {
    if (buttonType == 1) {
      _increaseItemCount();
    } else if (buttonType == 2) {
      _decreaseItemCount();
    }
  }

  @override
  Widget build(BuildContext context) {
    initMinimumOrder();

    initMaximumOrder();

    initQty();

    final Widget _addIconWidget = IconButton(
        iconSize: AppDimens.space32,
        icon: Icon(Icons.add_circle, color: AppColors.mainColor),
        onPressed: () {
          onUpdateItemCount(1);
        });

    final Widget _removeIconWidget = IconButton(
        iconSize: AppDimens.space32,
        icon: Icon(Icons.remove_circle, color: AppColors.grey),
        onPressed: () {
          onUpdateItemCount(2);
        });

    return Container(
      margin: const EdgeInsets.only(
          top: AppDimens.space8, bottom: AppDimens.space8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _removeIconWidget,
          Center(
            child: Container(
              height: AppDimens.space24,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.mainDividerColor)),
              padding: const EdgeInsets.only(
                  left: AppDimens.space24, right: AppDimens.space24),
              child: Text(
                '$orderQty', //?? widget.product.minimumOrder,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(color: AppColors.mainColor),
              ),
            ),
          ),
          _addIconWidget,
        ],
      ),
    );
  }
}

class _AddToBasketAndBuyForBottomSheetWidget extends StatefulWidget {
  const _AddToBasketAndBuyForBottomSheetWidget({
    Key key,
    @required this.addToBasketAndBuyClickEvent,
    @required this.isBuyButtonType,
  }) : super(key: key);

  final Function addToBasketAndBuyClickEvent;
  final bool isBuyButtonType;
  @override
  __AddToBasketAndBuyForBottomSheetWidgetState createState() =>
      __AddToBasketAndBuyForBottomSheetWidgetState();
}

class __AddToBasketAndBuyForBottomSheetWidgetState
    extends State<_AddToBasketAndBuyForBottomSheetWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.isBuyButtonType) {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(
            right: AppDimens.space16,
            left: AppDimens.space16,
            bottom: AppDimens.space16),
        child: PSButtonWithIconWidget(
            hasShadow: true,
            icon: Icons.shopping_cart,
            width: double.infinity,
            titleText: Utils.getString('product_detail__buy'),
            onPressed: () async {
              widget.addToBasketAndBuyClickEvent(true);
            }),
      );
    } else {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(
            right: AppDimens.space16,
            left: AppDimens.space16,
            bottom: AppDimens.space16),
        child: PSButtonWithIconWidget(
            hasShadow: true,
            icon: Icons.add_shopping_cart,
            width: double.infinity,
            titleText: Utils.getString('product_detail__add_to_basket'),
            onPressed: () async {
              widget.addToBasketAndBuyClickEvent(false);
            }),
      );
    }
  }
}

class _FloatingActionButton extends StatefulWidget {
  const _FloatingActionButton({
    Key key,
    @required this.controller,
    @required this.icons,
    @required this.label,
    @required this.psValueHolder,
  }) : super(key: key);

  final AnimationController controller;
  final List<IconData> icons;
  final List<String> label;
  final AppValueHolder psValueHolder;
  @override
  __FloatingActionButtonState createState() => __FloatingActionButtonState();
}

class __FloatingActionButtonState extends State<_FloatingActionButton> {
  @override
  Widget build(BuildContext context) {
    final String whatsappUrl = 'https://wa.me/${widget.psValueHolder.whatsApp}';
    final String messengerUrl = 'http://m.me/${widget.psValueHolder.messenger}';
    final String phoneCall = 'tel://${widget.psValueHolder.phone}';

    if (widget.icons.isNotEmpty && widget.label.isNotEmpty) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List<Widget>.generate(widget.icons.length, (int index) {
          Widget _getChip() {
            return Chip(
              backgroundColor: AppColors.mainColor,
              label: InkWell(
                onTap: () async {
                  print(index);

                  if (await canLaunch(index == 0
                      ? messengerUrl
                      : index == 1
                          ? whatsappUrl
                          : phoneCall)) {
                    await launch(
                        index == 0
                            ? messengerUrl
                            : index == 1
                                ? whatsappUrl
                                : phoneCall,
                        forceSafariVC: false);
                  } else {
                    throw whatsappUrl;
                  }
                },
                child: Text(
                  widget.label[index],
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.white,
                  ),
                ),
              ),
            );
          }

          final Widget child = Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: AppDimens.space8),
                child: ScaleTransition(
                  scale: CurvedAnimation(
                    parent: widget.controller,
                    curve:
                        Interval((index + 1) / 10, 1.0, curve: Curves.easeIn),
                  ),
                  child: _getChip(),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: AppDimens.space4, vertical: AppDimens.space2),
                child: ScaleTransition(
                  scale: CurvedAnimation(
                    parent: widget.controller,
                    curve: Interval(
                        0.0, 1.0 - index / widget.icons.length / 2.0,
                        curve: Curves.easeIn),
                  ),
                  child: FloatingActionButton(
                    heroTag: widget.label[index],
                    backgroundColor: AppColors.mainColor,
                    mini: true,
                    child: Icon(widget.icons[index], color: AppColors.white),
                    onPressed: () async {
                      print(index);
                      if (await canLaunch(index == 0
                          ? messengerUrl
                          : index == 1
                              ? whatsappUrl
                              : phoneCall)) {
                        await launch(
                            index == 0
                                ? messengerUrl
                                : index == 1
                                    ? whatsappUrl
                                    : phoneCall,
                            forceSafariVC: false);
                      } else {
                        throw whatsappUrl;
                      }
                    },
                  ),
                ),
              ),
            ],
          );
          return child;
        }).toList()
          ..add(
            Container(
              margin: const EdgeInsets.only(top: AppDimens.space8),
              child: FloatingActionButton(
                backgroundColor: AppColors.mainColor,
                child: AnimatedBuilder(
                  animation: widget.controller,
                  child: Icon(
                    widget.controller.isDismissed ? Icons.sms : Icons.sms,
                    color: AppColors.white,
                  ),
                  builder: (BuildContext context, Widget child) {
                    return Transform(
                        transform: Matrix4.rotationZ(
                            widget.controller.value * 0.5 * 8),
                        alignment: FractionalOffset.center,
                        child: child);
                  },
                ),
                onPressed: () {
                  if (widget.controller.isDismissed) {
                    widget.controller.forward();
                  } else {
                    widget.controller.reverse();
                  }
                },
              ),
            ),
          ),
      );
    } else {
      return Container();
    }
  }
}
