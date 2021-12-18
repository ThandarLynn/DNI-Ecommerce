import 'package:dni_ecommerce/config/app_colors.dart';
import 'package:dni_ecommerce/constant/app_dimens.dart';
import 'package:dni_ecommerce/utils/utils.dart';
import 'package:flutter/material.dart';

class ErrorDialog extends StatefulWidget {
  const ErrorDialog({this.message});
  final String message;
  @override
  _ErrorDialogState createState() => _ErrorDialogState();
}

class _ErrorDialogState extends State<ErrorDialog> {
  @override
  Widget build(BuildContext context) {
    return _NewDialog(widget: widget);
  }
}

class _NewDialog extends StatelessWidget {
  const _NewDialog({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final ErrorDialog widget;

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
                height: 60,
                width: double.infinity,
                padding: const EdgeInsets.all(AppDimens.space8),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5)),
                    color: AppColors.mainColor),
                child: Row(
                  children: <Widget>[
                    const SizedBox(
                      width: AppDimens.space4,
                    ),
                    Icon(
                      Icons.close,
                      color: AppColors.white,
                    ),
                    const SizedBox(
                      width: AppDimens.space4,
                    ),
                    Text(Utils.getString('error_dialog__error'),
                        textAlign: TextAlign.start,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            .copyWith(color: AppColors.white)),
                  ],
                )),
            const SizedBox(
              height: AppDimens.space20,
            ),
            Container(
              padding: const EdgeInsets.only(
                  left: AppDimens.space16,
                  right: AppDimens.space16,
                  top: AppDimens.space8,
                  bottom: AppDimens.space8),
              child: Text(
                widget.message?? 'null',
                style: Theme.of(context).textTheme.button,
              ),
            ),
            const SizedBox(
              height: AppDimens.space20,
            ),
            Divider(
              thickness: 0.5,
              height: 1,
              color: Theme.of(context).iconTheme.color,
            ),
            MaterialButton(
              height: 50,
              minWidth: double.infinity,
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                Utils.getString('dialog__ok'),
                style: Theme.of(context)
                    .textTheme
                    .button
                    .copyWith(color: AppColors.mainColor),
              ),
            )
          ],
        ));
  }
}
