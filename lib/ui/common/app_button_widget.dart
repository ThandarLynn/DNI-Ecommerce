import 'package:dni_ecommerce/config/app_colors.dart';
import 'package:dni_ecommerce/constant/app_dimens.dart';
import 'package:dni_ecommerce/utils/utils.dart';
import 'package:flutter/material.dart';

class AppButtonWidget extends StatefulWidget {
  const AppButtonWidget(
      {this.onPressed,
      this.titleText = '',
      this.titleTextAlign = TextAlign.center,
      this.colorData,
      this.width,
      this.gradient,
      this.hasShadow = false});

  final Function onPressed;
  final String titleText;
  final Color colorData;
  final double width;
  final Gradient gradient;
  final bool hasShadow;
  final TextAlign titleTextAlign;

  @override
  _AppButtonWidgetState createState() => _AppButtonWidgetState();
}

class _AppButtonWidgetState extends State<AppButtonWidget> {
  Gradient _gradient;
  Color _color;
  @override
  Widget build(BuildContext context) {
    _color = widget.colorData;
    _gradient = null;

    _color ??= AppColors.mainColor;

    if (widget.gradient == null && _color == AppColors.mainColor) {
      _gradient = LinearGradient(colors: <Color>[
        AppColors.mainColor,
        AppColors.mainDarkColor,
      ]);
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      height: 40,
      decoration: ShapeDecoration(
        shape: const BeveledRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(7.0)),
        ),
        color: _gradient == null ? _color : null,
        gradient: _gradient,
        shadows: <BoxShadow>[
          if (widget.hasShadow)
            BoxShadow(
                color: Utils.isLightMode(context)
                    ? _color.withOpacity(0.6)
                    : AppColors.mainShadowColor,
                offset: const Offset(0, 4),
                blurRadius: 8.0,
                spreadRadius: 3.0),
        ],
      ),
      child: Material(
        color: AppColors.transparent,
        type: MaterialType.card,
        clipBehavior: Clip.antiAlias,
        shape: const BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(AppDimens.space8))),
        child: InkWell(
          onTap: widget.onPressed,
          highlightColor: AppColors.mainDarkColor,
          child: Center(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                  left: AppDimens.space8, right: AppDimens.space8),
              child: Text(
                widget.titleText.toUpperCase(),
                textAlign: widget.titleTextAlign,
                style: Theme.of(context)
                    .textTheme
                    .button
                    .copyWith(color: AppColors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PSButtonWithIconWidget extends StatefulWidget {
  const PSButtonWithIconWidget(
      {this.onPressed,
      this.titleText = '',
      this.colorData,
      this.width,
      this.gradient,
      this.icon,
      this.iconAlignment = MainAxisAlignment.center,
      this.hasShadow = false});

  final Function onPressed;
  final String titleText;
  final Color colorData;
  final double width;
  final IconData icon;
  final Gradient gradient;
  final MainAxisAlignment iconAlignment;
  final bool hasShadow;

  @override
  _PSButtonWithIconWidgetState createState() => _PSButtonWithIconWidgetState();
}

class _PSButtonWithIconWidgetState extends State<PSButtonWithIconWidget> {
  Gradient _gradient;
  Color _color;
  @override
  Widget build(BuildContext context) {
    _color = widget.colorData;
    _gradient = null;

    _color ??= AppColors.mainColor;

    if (widget.gradient == null && _color == AppColors.mainColor) {
      _gradient = LinearGradient(colors: <Color>[
        AppColors.mainColor,
        AppColors.mainDarkColor,
      ]);
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      height: 40,
      decoration: ShapeDecoration(
        shape: const BeveledRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(7.0)),
        ),
        color: _gradient == null ? _color : null,
        gradient: _gradient,
        shadows: <BoxShadow>[
          if (widget.hasShadow)
            BoxShadow(
                color: Utils.isLightMode(context)
                    ? _color.withOpacity(0.6)
                    : AppColors.mainShadowColor,
                offset: const Offset(0, 4),
                blurRadius: 8.0,
                spreadRadius: 3.0),
        ],
      ),
      child: Material(
        color: AppColors.transparent,
        type: MaterialType.card,
        clipBehavior: Clip.antiAlias,
        shape: const BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(AppDimens.space8))),
        child: InkWell(
          onTap: widget.onPressed,
          highlightColor: AppColors.mainDarkColor,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: widget.iconAlignment,
            children: <Widget>[
              if (widget.icon != null)
                Icon(widget.icon, color: AppColors.white),
              if (widget.icon != null)
                const SizedBox(
                  width: AppDimens.space8,
                ),
              Text(
                widget.titleText.toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .button
                    .copyWith(color: AppColors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
