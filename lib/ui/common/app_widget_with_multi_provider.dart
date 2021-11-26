import 'package:flutter/material.dart';

class AppWidgetWithMultiProvider extends StatefulWidget {
  const AppWidgetWithMultiProvider({
    Key key,
    this.child,
  }) : super(key: key);

  final Widget child;

  @override
  _AppWidgetWithMultiProviderState createState() =>
      _AppWidgetWithMultiProviderState();
}

class _AppWidgetWithMultiProviderState extends State<AppWidgetWithMultiProvider> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: widget.child);
  }
}
