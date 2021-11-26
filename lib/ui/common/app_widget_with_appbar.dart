import 'package:dni_ecommerce/config/app_colors.dart';
import 'package:dni_ecommerce/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppWidgetWithAppBar<T extends ChangeNotifier> extends StatefulWidget {
  const AppWidgetWithAppBar(
      {Key key,
      @required this.builder,
      @required this.initProvider,
      this.child,
      this.onProviderReady,
      @required this.appBarTitle,
      this.actions = const <Widget>[]})
      : super(key: key);

  final Widget Function(BuildContext context, T provider, Widget child) builder;
  final Function initProvider;
  final Widget child;
  final Function(T) onProviderReady;
  final String appBarTitle;
  final List<Widget> actions;

  @override
  _AppWidgetWithAppBarState<T> createState() => _AppWidgetWithAppBarState<T>();
}

class _AppWidgetWithAppBarState<T extends ChangeNotifier>
    extends State<AppWidgetWithAppBar<T>> {
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
        body: ChangeNotifierProvider<T>(
          lazy: false,
          create: (BuildContext context) {
            final T providerObj = widget.initProvider();
            if (widget.onProviderReady != null) {
              widget.onProviderReady(providerObj);
            }

            return providerObj;
          },
          child: Consumer<T>(
            builder: widget.builder,
            child: widget.child,
          ),
        ));
  }
}
