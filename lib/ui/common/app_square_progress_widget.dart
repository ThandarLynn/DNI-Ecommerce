import 'package:flutter/material.dart';

class AppSquareProgressWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 25,
      height: 25,
      child: const LinearProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.black12),
          backgroundColor: Colors.black12),
    );
  }
}
