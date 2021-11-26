import 'package:dni_ecommerce/config/app_colors.dart';
import 'package:dni_ecommerce/constant/app_dimens.dart';
import 'package:flutter/material.dart';
import 'package:dni_ecommerce/utils/utils.dart';
import 'package:dni_ecommerce/repository/user_repository.dart';
import 'package:dni_ecommerce/viewobject/common/app_value_holder.dart';

import 'app_button_widget.dart';

class ChooseFilterTransactionDialog extends StatefulWidget {
  const ChooseFilterTransactionDialog(
      {Key key,
      @required this.onDailyTap,
      @required this.onWeeklyTap,
      @required this.onMonthlyTap,
      @required this.onYearlyTap})
      : super(key: key);

  final Function onDailyTap;
  final Function onWeeklyTap;
  final Function onMonthlyTap;
  final Function onYearlyTap;

  @override
  _LogoutDialogState createState() => _LogoutDialogState();
}

class _LogoutDialogState extends State<ChooseFilterTransactionDialog> {
  UserRepository repo1;
  AppValueHolder psValueHolder;

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

  final ChooseFilterTransactionDialog widget;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Container(
        width: 400.0,
        // height: 300.0,
        padding: const EdgeInsets.all(AppDimens.space16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const SizedBox(height: AppDimens.space16),
            Text(Utils.getString('transaction_list__filter_title'),
                style: Theme.of(context).textTheme.headline6.copyWith(
                    color: AppColors.mainColor, fontWeight: FontWeight.bold)),
            const SizedBox(height: AppDimens.space28),
            AppButtonWidget(
              hasShadow: true,
              width: double.infinity,
              titleText: Utils.getString('transaction_list__daily'),
              onPressed: () async {
                Navigator.pop(context);
                widget.onDailyTap();
              },
            ),
            const SizedBox(height: AppDimens.space16),
            AppButtonWidget(
              hasShadow: true,
              width: double.infinity,
              titleText: Utils.getString('transaction_list__weekly'),
              onPressed: () async {
                Navigator.pop(context);
                widget.onWeeklyTap();
              },
            ),
            const SizedBox(height: AppDimens.space16),
            AppButtonWidget(
              hasShadow: true,
              width: double.infinity,
              titleText: Utils.getString('transaction_list__monthly'),
              onPressed: () async {
                Navigator.pop(context);
                widget.onMonthlyTap();
              },
            ),
            const SizedBox(height: AppDimens.space16),
            AppButtonWidget(
              hasShadow: true,
              width: double.infinity,
              titleText: Utils.getString('transaction_list__yearly'),
              onPressed: () async {
                Navigator.pop(context);
                widget.onYearlyTap();
              },
            ),
            const SizedBox(height: AppDimens.space16),
          ],
        ),
      ),
    );
  }
}
