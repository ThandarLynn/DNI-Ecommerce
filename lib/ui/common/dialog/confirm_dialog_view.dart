import 'package:dni_ecommerce/config/app_colors.dart';
import 'package:dni_ecommerce/constant/app_dimens.dart';
import 'package:dni_ecommerce/utils/utils.dart';
import 'package:flutter/material.dart';

class ConfirmDialogView extends StatefulWidget {
  const ConfirmDialogView(
      {Key key,
      this.description,
      this.leftButtonText,
      this.rightButtonText,
      this.onAgreeTap})
      : super(key: key);

  final String description, leftButtonText, rightButtonText;
  final Function onAgreeTap;

  @override
  _LogoutDialogState createState() => _LogoutDialogState();
}

class _LogoutDialogState extends State<ConfirmDialogView> {
  @override
  Widget build(BuildContext context) {
    return NewDialog(widget: widget);
  }
}

class NewDialog extends StatelessWidget {
  const NewDialog({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final ConfirmDialogView widget;

  @override
  Widget build(BuildContext context) {
    const Widget _spacingWidget = SizedBox(
      width: AppDimens.space4,
    );
    const Widget _largeSpacingWidget = SizedBox(
      height: AppDimens.space20,
    );
    final Widget _headerWidget = Row(
      children: <Widget>[
        _spacingWidget,
        Icon(
          Icons.help_outline,
          color: AppColors.white,
        ),
        _spacingWidget,
        Text(
          Utils.getString('logout_dialog__confirm'),
          textAlign: TextAlign.start,
          style: TextStyle(
            color: AppColors.white,
          ),
        ),
      ],
    );

    final Widget _messageWidget = Text(
      widget.description,
      style: Theme.of(context).textTheme.subtitle2,
    );
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
              height: AppDimens.space60,
              width: double.infinity,
              padding: const EdgeInsets.all(AppDimens.space8),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5)),
                  color: AppColors.mainColor),
              child: _headerWidget),
          _largeSpacingWidget,
          Container(
            padding: const EdgeInsets.only(
                left: AppDimens.space16,
                right: AppDimens.space16,
                top: AppDimens.space8,
                bottom: AppDimens.space8),
            child: _messageWidget,
          ),
          _largeSpacingWidget,
          Divider(
            color: Theme.of(context).iconTheme.color,
            height: 0.4,
          ),
          Row(children: <Widget>[
            Expanded(
                child: MaterialButton(
              height: 50,
              minWidth: double.infinity,
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(widget.leftButtonText,
                  style: Theme.of(context).textTheme.button),
            )),
            Container(
                height: 50,
                width: 0.4,
                color: Theme.of(context).iconTheme.color),
            Expanded(
                child: MaterialButton(
              height: 50,
              minWidth: double.infinity,
              onPressed: () {
                widget.onAgreeTap();
              },
              child: Text(
                widget.rightButtonText,
                style: Theme.of(context)
                    .textTheme
                    .button
                    .copyWith(color: AppColors.mainColor),
              ),
            )),
          ])
        ],
      ),
    );
  }
}
