import 'package:dni_ecommerce/config/app_colors.dart';
import 'package:dni_ecommerce/utils/utils.dart';
import 'package:flutter/material.dart';

class AppWidgetWithAppBarWithNoProvider extends StatefulWidget {
  const AppWidgetWithAppBarWithNoProvider(
      {Key key,
      this.builder,
      @required this.child,
      @required this.appBarTitle,
      this.actions = const <Widget>[]})
      : super(key: key);

  final Widget Function(BuildContext context, Widget child) builder;

  final Widget child;

  final String appBarTitle;
  final List<Widget> actions;

  @override
  _AppWidgetWithAppBarWithNoProviderState createState() =>
      _AppWidgetWithAppBarWithNoProviderState();
}

class _AppWidgetWithAppBarWithNoProviderState
    extends State<AppWidgetWithAppBarWithNoProvider> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Utils.getBrightnessForAppBar(context),
        iconTheme: IconThemeData(color: AppColors.mainColorWithWhite),
        title: Text(widget.appBarTitle,
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(fontWeight: FontWeight.bold)
                .copyWith(color: AppColors.mainColorWithWhite)),
        actions: widget.actions,
        flexibleSpace: Container(
          height: 200,
        ),
        elevation: 0,
      ),
      body: widget.child,
    );
  }
}
