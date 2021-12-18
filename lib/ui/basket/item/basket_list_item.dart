import 'package:dni_ecommerce/config/app_colors.dart';
import 'package:dni_ecommerce/constant/app_dimens.dart';
import 'package:dni_ecommerce/provider/basket/basket_provider.dart';
import 'package:dni_ecommerce/repository/basket_repository.dart';
import 'package:dni_ecommerce/ui/common/app_ui_widget.dart';
import 'package:dni_ecommerce/utils/utils.dart';
import 'package:dni_ecommerce/viewobject/basket.dart';
import 'package:dni_ecommerce/viewobject/basket_selected_attribute.dart';
import 'package:dni_ecommerce/viewobject/common/app_value_holder.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class BasketListItemView extends StatelessWidget {
  const BasketListItemView({
    Key key,
    @required this.basket,
    @required this.onTap,
    @required this.onDeleteTap,
    @required this.animationController,
    @required this.animation,
  }) : super(key: key);

  final Basket basket;
  final Function onTap;
  final Function onDeleteTap;
  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    if (basket != null) {
      return AnimatedBuilder(
          animation: animationController,
          child: _ImageAndTextWidget(
            basket: basket,
            onDeleteTap: onDeleteTap,
          ),
          builder: (BuildContext context, Widget child) {
            return FadeTransition(
              opacity: animation,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 100 * (1.0 - animation.value), 0.0),
                child: GestureDetector(onTap: onTap, child: child),
              ),
            );
          });
    } else {
      return Container();
    }
  }
}

class _ImageAndTextWidget extends StatelessWidget {
  const _ImageAndTextWidget({
    Key key,
    @required this.basket,
    @required this.onDeleteTap,
  }) : super(key: key);

  final Basket basket;
  final Function onDeleteTap;
  @override
  Widget build(BuildContext context) {
    double subTotalPrice = 0.0;
    subTotalPrice = double.parse(basket.basketPrice) * double.parse(basket.qty);

    final BasketRepository basketRepository = context.watch<BasketRepository>();
    // Provider.of<BasketRepository>(context);
    if (basket != null && basket != null) {
      return ChangeNotifierProvider<BasketProvider>(
          lazy: false,
          create: (BuildContext context) {
            final BasketProvider provider =
                BasketProvider(repo: basketRepository);
            provider.loadBasketList();
            return provider;
          },
          child: Consumer<BasketProvider>(builder: (BuildContext context,
              BasketProvider basketProvider, Widget child) {
            return Container(
              color: AppColors.backgroundColor,
              margin: const EdgeInsets.only(top: AppDimens.space8),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              top: AppDimens.space8, left: AppDimens.space16),
                          child: Container(
                            width: AppDimens.space60,
                            height: AppDimens.space60,
                            child: AppNetworkImageWithUrl(
                              photoKey: '',
                              imagePath: basket.product.image,
                              boxfit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: AppDimens.space8,
                        ),
                        Flexible(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: AppDimens.space8,
                                    bottom: AppDimens.space8),
                                child: Text(
                                  basket.product.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.subtitle2,
                                ),
                              ),
                              Text(
                                '${Utils.getString('basket_list__price')}  \$ ${Utils.getPriceFormat(basket.basketPrice)}',
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                              const SizedBox(
                                height: AppDimens.space8,
                              ),
                              Text(
                                '${Utils.getString('basket_list__sub_total')} \$ ${Utils.getPriceFormat(subTotalPrice.toString())}',
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                              _AttributeAndColorWidget(basket: basket),
                              _IconAndTextWidget(
                                basket: basket,
                                basketProvider: basketProvider,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  _DeleteButtonWidget(onDeleteTap: onDeleteTap),
                ],
              ),
            );
          }));
    } else {
      return Container();
    }
  }
}

class _DeleteButtonWidget extends StatelessWidget {
  const _DeleteButtonWidget({
    Key key,
    @required this.onDeleteTap,
  }) : super(key: key);

  final Function onDeleteTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onDeleteTap,
      child: Container(
        width: AppDimens.space40,
        height: AppDimens.space56,
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.only(
            bottom: AppDimens.space10, right: AppDimens.space10),
        color: AppColors.mainLightColor,
        alignment: Alignment.centerRight,
        child: Icon(
          Icons.delete,
          color: AppColors.grey,
        ),
      ),
    );
  }
}

class _IconAndTextWidget extends StatefulWidget {
  const _IconAndTextWidget({
    Key key,
    @required this.basket,
    @required this.basketProvider,
  }) : super(key: key);

  final Basket basket;
  final BasketProvider basketProvider;

  @override
  _IconAndTextWidgetState createState() => _IconAndTextWidgetState();
}

class _IconAndTextWidgetState extends State<_IconAndTextWidget> {
  int orderQty = 0;
  Basket basket;
  double basketOriginalPrice, basketPrice;
  int minimumOrder = 1; // 1 is default
  int maximumOrder = 0;

  void initMinimumOrder() {
    if (widget.basket.product.minimumOrder != '0' &&
        widget.basket.product.minimumOrder != '' &&
        widget.basket.product.minimumOrder != null) {
      minimumOrder = int.parse(widget.basket.product.minimumOrder);
    }
  }

  void initMaximumOrder() {
    if (widget.basket.product.maximumOrder != '0' &&
        widget.basket.product.maximumOrder != '' &&
        widget.basket.product.maximumOrder != null) {
      maximumOrder = int.parse(widget.basket.product.maximumOrder);
    }
  }

  void initQty() {
    if (orderQty == 0 && widget.basket.qty != null && widget.basket.qty != '') {
      orderQty = int.parse(widget.basket.qty);
    } else if (orderQty == 0) {
      orderQty = int.parse(widget.basket.product.minimumOrder);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppValueHolder psValueHolder = Provider.of<AppValueHolder>(context);

    initMinimumOrder();

    initMaximumOrder();

    initQty();

    Future<void> changeBasketQtyAndPrice() async {
      basket = Basket(
          id: widget.basket.id,
          productId: widget.basket.product.id,
          qty: widget.basket.qty,
          shopId: psValueHolder.shopId,
          selectedColorId: widget.basket.selectedColorId,
          selectedColorValue: widget.basket.selectedColorValue,
          basketPrice: widget.basket.basketPrice,
          basketOriginalPrice: widget.basket.basketOriginalPrice,
          selectedAttributeTotalPrice:
              widget.basket.selectedAttributeTotalPrice,
          product: widget.basket.product,
          basketSelectedAttributeList:
              widget.basket.basketSelectedAttributeList);

      await widget.basketProvider.updateBasket(basket);
    }

    void _increaseItemCount() {
      if (orderQty + 1 <= maximumOrder || maximumOrder == 0) {
        setState(() {
          orderQty++;
          widget.basket.qty = '$orderQty';
          changeBasketQtyAndPrice();
        });
      } else {
        Fluttertoast.showToast(
            msg:
                '${Utils.getString('product_detail__maximum_order')} ${widget.basket.product.maximumOrder}',
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
          widget.basket.qty = '$orderQty';
          changeBasketQtyAndPrice();
        });
      } else {
        Fluttertoast.showToast(
            msg:
                '${Utils.getString('product_detail__minimum_order')} ${widget.basket.product.minimumOrder}',
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
              decoration:
                  BoxDecoration(border: Border.all(color: AppColors.grey)),
              padding: const EdgeInsets.only(
                  left: AppDimens.space24, right: AppDimens.space24),
              child: Text(
                widget.basket.qty,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
          ),
          _addIconWidget,
        ],
      ),
    );
  }
}

class _AttributeAndColorWidget extends StatelessWidget {
  const _AttributeAndColorWidget({
    Key key,
    @required this.basket,
  }) : super(key: key);

  final Basket basket;
  Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  String getSelectedAttribute() {
    String attributeName = '';
    for (BasketSelectedAttribute basket in basket.basketSelectedAttributeList) {
      attributeName = attributeName + '${basket.name},';
    }

    return attributeName;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        if (basket.basketSelectedAttributeList.isNotEmpty &&
            basket.selectedColorValue != null)
          Text(
            '${Utils.getString('basket_list__attributes')}',
            style: Theme.of(context).textTheme.bodyText2,
          )
        else
          Container(),
        if (basket.selectedColorValue != null)
          Container(
            margin: const EdgeInsets.all(AppDimens.space10),
            width: AppDimens.space20,
            height: AppDimens.space20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: hexToColor(basket.selectedColorValue),
              border: Border.all(width: 1, color: AppColors.grey),
            ),
          )
        else
          Container(),
        if (basket.basketSelectedAttributeList.isNotEmpty)
          Flexible(
            child: Text(
              '( ${getSelectedAttribute().toString()} )',
              style: Theme.of(context).textTheme.bodyText2,
            ),
          )
        else
          Container(),
      ],
    );
  }
}
