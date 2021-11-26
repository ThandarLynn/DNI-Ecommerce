// import 'package:dni_ecommerce/constant/app_dimens.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class PrivacyPolicyView extends StatefulWidget {
//   const PrivacyPolicyView({Key key, @required this.animationController})
//       : super(key: key);
//   final AnimationController animationController;
//   @override
//   _PrivacyPolicyViewState createState() => _PrivacyPolicyViewState();
// }

// class _PrivacyPolicyViewState extends State<PrivacyPolicyView> {
//   AboutAppRepository repo1;
//   AppValueHolder psValueHolder;
//   AboutAppProvider provider;
//   @override
//   Widget build(BuildContext context) {
//     repo1 = Provider.of<AboutAppRepository>(context);
//     psValueHolder = Provider.of<AppValueHolder>(context);
//     final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
//         .animate(CurvedAnimation(
//             parent: widget.animationController,
//             curve: const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn)));
//     widget.animationController.forward();
//     return ChangeNotifierProvider<AboutAppProvider>(
//         lazy: false,
//         create: (BuildContext context) {
//           provider =
//               AboutAppProvider(repo: repo1, psValueHolder: psValueHolder);
//           provider.loadAboutAppList();
//           return provider;
//         },
//         child: Consumer<AboutAppProvider>(builder: (BuildContext context,
//             AboutAppProvider basketProvider, Widget child) {
//           if (provider.aboutAppList.data == null ||
//               provider.aboutAppList.data.isEmpty) {
//             return Container();
//           } else {
//             return AnimatedBuilder(
//               animation: widget.animationController,
//               child: Padding(
//                 padding: const EdgeInsets.all(AppDimens.space10),
//                 child: SingleChildScrollView(
//                   child: Text(
//                     provider.aboutAppList.data[0].privacypolicy,
//                   ),
//                 ),
//               ),
//               builder: (BuildContext context, Widget child) {
//                 return FadeTransition(
//                   opacity: animation,
//                   child: Transform(
//                       transform: Matrix4.translationValues(
//                           0.0, 100 * (1.0 - animation.value), 0.0),
//                       child: child),
//                 );
//               },
//             );
//           }
//         }));
//   }
// }
