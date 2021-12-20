import 'package:dni_ecommerce/config/app_colors.dart';
import 'package:dni_ecommerce/constant/app_dimens.dart';
import 'package:flutter/material.dart';
import 'package:dni_ecommerce/viewobject/ItemColor.dart';

class SizeListItemView extends StatelessWidget {
  const SizeListItemView({
    Key key,
    @required this.color,
    @required this.selectedColorId,
    this.onColorTap,
  }) : super(key: key);

  final ItemColor color;
  final Function onColorTap;
  final String selectedColorId;

  Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onColorTap,
        child: Container(
          margin: const EdgeInsets.symmetric(
              horizontal: AppDimens.space2, vertical: AppDimens.space2),
          child: _CheckIsSelectedWidget(
            name: color.colorValue,
            isSelected: color.id == selectedColorId,
          ),
        ));
  }
}

class _CheckIsSelectedWidget extends StatefulWidget {
  const _CheckIsSelectedWidget({
    Key key,
    @required this.name,
    this.onColorTap,
    @required this.isSelected,
  }) : super(key: key);

  final String name;
  final Function onColorTap;
  final bool isSelected;

  @override
  __CheckIsSelectedWidgetState createState() => __CheckIsSelectedWidgetState();
}

class __CheckIsSelectedWidgetState extends State<_CheckIsSelectedWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.isSelected) {
      return Stack(
        alignment: const Alignment(0.0, 0.0),
        children: <Widget>[
          Container(
            width: AppDimens.space40,
            height: AppDimens.space40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColors.grey,
              border: Border.all(width: 1),
            ),
          ),
          Container(
            width: AppDimens.space24,
            height: AppDimens.space24,
            margin: const EdgeInsets.only(top: 6),
            child: Text(
              widget.name,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .copyWith(color: AppColors.black),
            ),
          ),
          Container(
            width: AppDimens.space24,
            height: AppDimens.space24,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColors.black.withAlpha(100),
              border: Border.all(width: 1, color: AppColors.grey),
            ),
            child: Container(
              child: Icon(
                Icons.check,
                color: AppColors.white,
                size: AppDimens.space16,
              ),
            ),
          )
        ],
      );
    } else {
      return Stack(
        alignment: const Alignment(0.0, 0.0),
        children: <Widget>[
          Container(
            width: AppDimens.space40,
            height: AppDimens.space40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColors.grey,
              border: Border.all(width: 1, color: AppColors.grey),
            ),
          ),
          Container(
            width: AppDimens.space24,
            height: AppDimens.space24,
            margin: const EdgeInsets.only(top: 6),
            child: Text(
              widget.name,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .copyWith(color: AppColors.black),
            ),
          )
        ],
      );
    }
  }
}
