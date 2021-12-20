import 'package:dni_ecommerce/config/app_colors.dart';
import 'package:dni_ecommerce/constant/app_dimens.dart';
import 'package:dni_ecommerce/ui/common/app_textfield_widget.dart';
import 'package:dni_ecommerce/ui/common/smooth_star_rating_widget.dart';
import 'package:dni_ecommerce/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:dni_ecommerce/ui/common/app_button_widget.dart';
import 'package:dni_ecommerce/ui/common/dialog/success_dialog.dart';

class RatingInputDialog extends StatefulWidget {
  const RatingInputDialog({
    Key key,
  }) : super(key: key);

  @override
  _RatingInputDialogState createState() => _RatingInputDialogState();
}

class _RatingInputDialogState extends State<RatingInputDialog> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  double rating;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Widget _headerWidget = Container(
        height: AppDimens.space52,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5), topRight: Radius.circular(5)),
            color: AppColors.mainColor),
        child: Row(
          children: <Widget>[
            const SizedBox(width: AppDimens.space12),
            Icon(
              Icons.rate_review,
              color: AppColors.white,
            ),
            const SizedBox(width: AppDimens.space8),
            Text(
              Utils.getString('rating_entry__user_rating_entry'),
              textAlign: TextAlign.start,
              style: TextStyle(
                color: AppColors.white,
              ),
            ),
          ],
        ));
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _headerWidget,
            const SizedBox(
              height: AppDimens.space16,
            ),
            Column(
              children: <Widget>[
                Text(
                  Utils.getString('rating_entry__your_rating'),
                  style: Theme.of(context).textTheme.bodyText2.copyWith(),
                ),
                if (rating == null)
                  SmoothStarRating(
                      isRTl: Directionality.of(context) == TextDirection.rtl,
                      allowHalfRating: false,
                      rating: 0.0,
                      starCount: 5,
                      size: AppDimens.space40,
                      color: AppColors.ratingColor,
                      onRated: (double rating1) {
                        setState(() {
                          rating = rating1;
                        });
                      },
                      borderColor: AppColors.grey.withAlpha(100),
                      spacing: 0.0)
                else
                  SmoothStarRating(
                      isRTl: Directionality.of(context) == TextDirection.rtl,
                      allowHalfRating: false,
                      rating: rating,
                      starCount: 5,
                      size: AppDimens.space40,
                      color: AppColors.ratingColor,
                      onRated: (double rating1) {
                        setState(() {
                          rating = rating1;
                        });
                      },
                      borderColor: AppColors.grey.withAlpha(100),
                      spacing: 0.0),
                AppTextFieldWidget(
                    titleText: Utils.getString('rating_entry__title'),
                    hintText: Utils.getString('rating_entry__title'),
                    textEditingController: titleController),
                AppTextFieldWidget(
                    height: AppDimens.space120,
                    titleText: Utils.getString('rating_entry__message'),
                    hintText: Utils.getString('rating_entry__message'),
                    textEditingController: descriptionController),
                const Divider(
                  height: 0.5,
                ),
                const SizedBox(
                  height: AppDimens.space16,
                ),
                _ButtonWidget(
                  descriptionController: descriptionController,
                  // provider: provider,
                  // productProvider: widget.productprovider,
                  titleController: titleController,
                  rating: rating,
                ),
                const SizedBox(
                  height: AppDimens.space16,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ButtonWidget extends StatefulWidget {
  const _ButtonWidget({
    Key key,
    @required this.titleController,
    @required this.descriptionController,
    // @required this.provider,
    // @required this.productProvider,
    @required this.rating,
  }) : super(key: key);

  final TextEditingController titleController, descriptionController;
  // final RatingProvider provider;
  // final ProductDetailProvider productProvider;
  final double rating;

  @override
  __ButtonWidgetState createState() => __ButtonWidgetState();
}

class __ButtonWidgetState extends State<_ButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: AppDimens.space8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: SizedBox(
              width: double.infinity,
              height: AppDimens.space36,
              child: AppButtonWidget(
                hasShadow: false,
                colorData: AppColors.grey,
                width: double.infinity,
                titleText: Utils.getString('rating_entry__cancel'),
                onPressed: () async {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          const SizedBox(
            width: AppDimens.space8,
          ),
          Expanded(
            child: SizedBox(
              width: double.infinity,
              height: AppDimens.space36,
              child: AppButtonWidget(
                hasShadow: true,
                width: double.infinity,
                titleText: Utils.getString('rating_entry__submit'),
                onPressed: () async {
                  // if (widget.titleController.text.isNotEmpty &&
                  //     widget.descriptionController.text.isNotEmpty &&
                  //     widget.rating != null &&
                  //     widget.rating.toString() != '0.0') {
                  //   final RatingParameterHolder commentHeaderParameterHolder =
                  //       RatingParameterHolder(
                  //     userId: widget.productProvider.psValueHolder.loginUserId,
                  //     productId: widget.productProvider.productDetail.data.id,
                  //     title: widget.titleController.text,
                  //     description: widget.descriptionController.text,
                  //     rating: widget.rating.toString(),
                  //   );

                  //   await AppProgressDialog.showDialog(context);
                  //   await widget.provider
                  //       .postRating(commentHeaderParameterHolder.toMap());
                  //   AppProgressDialog.dismissDialog();
                    Navigator.pop(context);
                  // } else {
                  //   print('There is no comment');

                    showDialog<dynamic>(
                        context: context,
                        builder: (BuildContext context) {
                          return SuccessDialog(
                            message:
                                Utils.getString( 'success_dialog__success'),
                            onPressed: () {},
                          );
                        });
                  // }
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
