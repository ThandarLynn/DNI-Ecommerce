import 'package:dni_ecommerce/config/app_colors.dart';
import 'package:dni_ecommerce/constant/app_dimens.dart';
import 'package:dni_ecommerce/ui/common/app_ui_widget.dart';
// import 'package:dni_ecommerce/ui/common/dialog/error_dialog.dart';
// import 'package:dni_ecommerce/utils/utils.dart';
import 'package:dni_ecommerce/viewobject/product.dart';
import 'package:flutter/material.dart';

class FavoriteListItem extends StatelessWidget {
  const FavoriteListItem(
      {Key key,
      @required this.history,
      this.onTap,
      this.onDeleteTap,
      this.animationController,
      this.animation})
      : super(key: key);

  final Product history;
  final Function onTap;
  final Function onDeleteTap;
  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    if (history != null) {
      animationController.forward();
      return AnimatedBuilder(
          animation: animationController,
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              margin: const EdgeInsets.only(top: AppDimens.space8),
              color: AppColors.backgroundColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _ImageAndTextWidget(
                    history: history, onDeleteTap: onDeleteTap),
              ),
            ),
          ),
          builder: (BuildContext context, Widget child) {
            return FadeTransition(
                opacity: animation,
                child: Transform(
                    transform: Matrix4.translationValues(
                        0.0, 100 * (1.0 - animation.value), 0.0),
                    child: child));
          });
    } else {
      return Container();
    }
  }
}

class _ImageAndTextWidget extends StatelessWidget {
  const _ImageAndTextWidget(
      {Key key, @required this.history, @required this.onDeleteTap})
      : super(key: key);

  final Product history;
  final Function onDeleteTap;

  @override
  Widget build(BuildContext context) {
    if (history != null && history.name != null) {
      return Row(
        children: <Widget>[
          Container(
            width: AppDimens.space60,
            height: AppDimens.space60,
            child:
                AppNetworkImageWithUrl(photoKey: '', imagePath: history.image),
          ),
          const SizedBox(
            width: AppDimens.space8,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: AppDimens.space8),
                  child: Text(
                    history.name,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                ),
                const SizedBox(
                  height: AppDimens.space2,
                ),
                Text(
                  '\$' + history.originalPrice ?? 'null',
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .copyWith(color: AppColors.textPrimaryLightColor),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onDeleteTap,
            child: Container(
              width: AppDimens.space40,
              height: AppDimens.space60,
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.only(right: AppDimens.space10),
              color: AppColors.baseLightColor,
              alignment: Alignment.centerRight,
              child: Icon(
                Icons.delete,
                color: AppColors.grey,
              ),
            ),
          )
        ],
      );
    } else {
      return Container();
    }
  }
}
