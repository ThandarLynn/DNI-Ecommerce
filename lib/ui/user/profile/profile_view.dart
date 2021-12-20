import 'package:dni_ecommerce/config/app_colors.dart';
import 'package:dni_ecommerce/constant/app_dimens.dart';
import 'package:dni_ecommerce/constant/route_paths.dart';
import 'package:dni_ecommerce/provider/transaction/transaction_header_provider.dart';
import 'package:dni_ecommerce/provider/user/user_provider.dart';
import 'package:dni_ecommerce/repository/transaction_header_repository.dart';
import 'package:dni_ecommerce/repository/user_repository.dart';
import 'package:dni_ecommerce/ui/common/app_ui_widget.dart';
import 'package:dni_ecommerce/ui/transaction/item/transaction_list_item.dart';
import 'package:dni_ecommerce/utils/utils.dart';
import 'package:dni_ecommerce/viewobject/common/app_value_holder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({
    Key key,
    this.animationController,
    @required this.flag,
    this.userId,
    this.userToken,
    @required this.scaffoldKey,
  }) : super(key: key);

  final AnimationController animationController;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final int flag;
  final String userId;
  final String userToken;
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfileView>
    with SingleTickerProviderStateMixin {
  UserRepository userRepository;

  @override
  Widget build(BuildContext context) {
    widget.animationController.forward();
    return
        // SingleChildScrollView(
        //     child: Container(
        //   color: AppColors.coreBackgroundColor,
        //   height: widget.flag ==
        //           AppConst.REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT
        //       ? MediaQuery.of(context).size.height - 100
        //       : MediaQuery.of(context).size.height - 40,
        //   child:
        CustomScrollView(scrollDirection: Axis.vertical, slivers: <Widget>[
      _ProfileDetailWidget(
          animationController: widget.animationController,
          animation: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: widget.animationController,
              curve:
                  const Interval((1 / 4) * 2, 1.0, curve: Curves.fastOutSlowIn),
            ),
          ),
          userId: widget.userId,
          userToken: widget.userToken),
      _TransactionListViewWidget(
        scaffoldKey: widget.scaffoldKey,
        animationController: widget.animationController,
        userId: widget.userId,
      )
    ]);
    // ));
  }
}

class _TransactionListViewWidget extends StatelessWidget {
  const _TransactionListViewWidget(
      {Key key,
      @required this.animationController,
      @required this.userId,
      @required this.scaffoldKey})
      : super(key: key);

  final AnimationController animationController;
  final String userId;
  final GlobalKey<ScaffoldState> scaffoldKey;
  @override
  Widget build(BuildContext context) {
    TransactionHeaderRepository transactionHeaderRepository;
    AppValueHolder psValueHolder;
    transactionHeaderRepository =
        Provider.of<TransactionHeaderRepository>(context);
    psValueHolder = Provider.of<AppValueHolder>(context);

    return SliverToBoxAdapter(
        child: ChangeNotifierProvider<TransactionHeaderProvider>(
            lazy: false,
            create: (BuildContext context) {
              final TransactionHeaderProvider provider =
                  TransactionHeaderProvider(
                      repo: transactionHeaderRepository,
                      psValueHolder: psValueHolder);
              if (provider.psValueHolder.loginUserId == null ||
                  provider.psValueHolder.loginUserId == '') {
                provider.loadTransactionList(userId);
              } else {
                provider
                    .loadTransactionList(provider.psValueHolder.loginUserId);
              }

              return provider;
            },
            child: Consumer<TransactionHeaderProvider>(builder:
                (BuildContext context, TransactionHeaderProvider provider,
                    Widget child) {
              if (provider.transactionList != null &&
                  provider.transactionList.data != null) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppDimens.space44),
                  child: Stack(children: <Widget>[
                    Container(
                        child: RefreshIndicator(
                      child: CustomScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          slivers: <Widget>[
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                                  if (provider.transactionList.data != null ||
                                      provider
                                          .transactionList.data.isNotEmpty) {
                                    final int count =
                                        provider.transactionList.data.length;
                                    return TransactionListItem(
                                      scaffoldKey: scaffoldKey,
                                      animationController: animationController,
                                      animation:
                                          Tween<double>(begin: 0.0, end: 1.0)
                                              .animate(
                                        CurvedAnimation(
                                          parent: animationController,
                                          curve: Interval(
                                              (1 / count) * index, 1.0,
                                              curve: Curves.fastOutSlowIn),
                                        ),
                                      ),
                                      transaction:
                                          provider.transactionList.data[index],
                                      onTap: () {
                                        Navigator.pushNamed(context,
                                            RoutePaths.transactionDetail,
                                            arguments: provider
                                                .transactionList.data[index]);
                                      },
                                    );
                                  } else {
                                    return null;
                                  }
                                },
                                childCount:
                                    provider.transactionList.data.length,
                              ),
                            ),
                          ]),
                      onRefresh: () {
                        return provider.resetTransactionList();
                      },
                    )),
                  ]),
                );
              } else {
                return Container();
              }
            })));
  }
}

class _ProfileDetailWidget extends StatefulWidget {
  const _ProfileDetailWidget({
    Key key,
    this.animationController,
    this.animation,
    @required this.userId,
    @required this.userToken,
  }) : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;
  final String userId;
  final String userToken;

  @override
  __ProfileDetailWidgetState createState() => __ProfileDetailWidgetState();
}

class __ProfileDetailWidgetState extends State<_ProfileDetailWidget> {
  @override
  Widget build(BuildContext context) {
    // const Widget _dividerWidget = Divider(
    //   height: 1,
    // );
    UserRepository userRepository;
    AppValueHolder psValueHolder;
    UserProvider provider;
    userRepository = Provider.of<UserRepository>(context);
    psValueHolder = Provider.of<AppValueHolder>(context);
    provider = UserProvider(repo: userRepository, psValueHolder: psValueHolder);

    return SliverToBoxAdapter(
      child: ChangeNotifierProvider<UserProvider>(
          lazy: false,
          create: (BuildContext context) {
            print(provider.getCurrentFirebaseUser());
            if (provider.psValueHolder.loginUserId == null ||
                provider.psValueHolder.loginUserId == '') {
              provider.getUser(widget.userId, widget.userToken);
            } else {
              provider.getUser(provider.psValueHolder.loginUserId,
                  provider.psValueHolder.userToken);
            }
            return provider;
          },
          child: Consumer<UserProvider>(builder:
              (BuildContext context, UserProvider provider, Widget child) {
            if (provider.user != null && provider.user.data != null) {
              return AnimatedBuilder(
                  animation: widget.animationController,
                  child: Container(
                    color: AppColors.backgroundColor,
                    child: Column(
                      children: <Widget>[
                        _ImageAndTextWidget(userProvider: provider),
                        // _dividerWidget,
                        // _EditAndHistoryRowWidget(userProvider: provider),
                        // _dividerWidget,
                        // _FavAndSettingWidget(userProvider: provider),
                        // _dividerWidget,
                        // _JoinDateWidget(userProvider: provider),
                        // _dividerWidget,
                        // _OrderAndSeeAllWidget(),
                      ],
                    ),
                  ),
                  builder: (BuildContext context, Widget child) {
                    return FadeTransition(
                        opacity: widget.animation,
                        child: Transform(
                            transform: Matrix4.translationValues(
                                0.0, 100 * (1.0 - widget.animation.value), 0.0),
                            child: child));
                  });
            } else {
              return Container();
            }
          })),
    );
  }
}

// class _JoinDateWidget extends StatelessWidget {
//   const _JoinDateWidget({this.userProvider});
//   final UserProvider userProvider;
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//         padding: const EdgeInsets.all(AppDimens.space16),
//         child: Align(
//             alignment: Alignment.centerLeft,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 Text(
//                   Utils.getString('profile__join_on'),
//                   textAlign: TextAlign.start,
//                   style: Theme.of(context).textTheme.bodyText2,
//                 ),
//                 const SizedBox(
//                   width: AppDimens.space2,
//                 ),
//                 Text(
//                   userProvider.user.data.userName == ''
//                       ? ''
//                       : userProvider.user.data.userName,
//                   textAlign: TextAlign.start,
//                   style: Theme.of(context).textTheme.bodyText2,
//                 ),
//               ],
//             )));
//   }
// }

// class _FavAndSettingWidget extends StatelessWidget {
//   const _FavAndSettingWidget({this.userProvider});
//   final UserProvider userProvider;
//   @override
//   Widget build(BuildContext context) {
//     const Widget _sizedBoxWidget = SizedBox(
//       width: AppDimens.space4,
//     );
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: <Widget>[
//         Expanded(
//             flex: 2,
//             child: MaterialButton(
//               height: 50,
//               minWidth: double.infinity,
//               onPressed: () {
//                 Navigator.pushNamed(
//                   context,
//                   RoutePaths.favouriteProductList,
//                 );
//               },
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Icon(
//                     Icons.favorite,
//                     color: Theme.of(context).iconTheme.color,
//                   ),
//                   _sizedBoxWidget,
//                   Text(
//                     Utils.getString('profile__favourite'),
//                     textAlign: TextAlign.start,
//                     softWrap: false,
//                     style: Theme.of(context)
//                         .textTheme
//                         .bodyText2
//                         .copyWith(fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               ),
//             )),
//         Container(
//           color: Theme.of(context).dividerColor,
//           width: AppDimens.space1,
//           height: AppDimens.space48,
//         ),
//         Expanded(
//             flex: 2,
//             child: MaterialButton(
//               height: 50,
//               minWidth: double.infinity,
//               onPressed: () {
//                 Navigator.pushNamed(context, RoutePaths.more,
//                     arguments: userProvider.user.data.userName);
//               },
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Icon(Icons.more_horiz,
//                       color: Theme.of(context).iconTheme.color),
//                   _sizedBoxWidget,
//                   Text(
//                     Utils.getString('profile__more'),
//                     softWrap: false,
//                     textAlign: TextAlign.start,
//                     style: Theme.of(context)
//                         .textTheme
//                         .bodyText2
//                         .copyWith(fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               ),
//             ))
//       ],
//     );
//   }
// }

// class _EditAndHistoryRowWidget extends StatelessWidget {
//   const _EditAndHistoryRowWidget({@required this.userProvider});
//   final UserProvider userProvider;
//   @override
//   Widget build(BuildContext context) {
//     final Widget _verticalLineWidget = Container(
//       color: Theme.of(context).dividerColor,
//       width: AppDimens.space1,
//       height: AppDimens.space48,
//     );
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: <Widget>[
//         _EditAndHistoryTextWidget(
//           userProvider: userProvider,
//           checkText: 0,
//         ),
//         _verticalLineWidget,
//         _EditAndHistoryTextWidget(
//           userProvider: userProvider,
//           checkText: 1,
//         ),
//         _verticalLineWidget,
//         _EditAndHistoryTextWidget(
//           userProvider: userProvider,
//           checkText: 2,
//         )
//       ],
//     );
//   }
// }

// class _EditAndHistoryTextWidget extends StatelessWidget {
//   const _EditAndHistoryTextWidget({
//     Key key,
//     @required this.userProvider,
//     @required this.checkText,
//   }) : super(key: key);

//   final UserProvider userProvider;
//   final int checkText;

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//         flex: 2,
//         child: MaterialButton(
//             height: 50,
//             minWidth: double.infinity,
//             onPressed: () async {
//               if (checkText == 0) {
//                 final dynamic returnData = await Navigator.pushNamed(
//                   context,
//                   RoutePaths.editProfile,
//                 );
//                 if (returnData != null && returnData is bool) {
//                   userProvider.getUser(userProvider.psValueHolder.loginUserId);
//                 }
//               } else if (checkText == 1) {
//                 Navigator.pushNamed(
//                   context,
//                   RoutePaths.historyList,
//                 );
//               } else if (checkText == 2) {
//                 Navigator.pushNamed(
//                   context,
//                   RoutePaths.transactionList,
//                 );
//               }
//             },
//             child: checkText == 0
//                 ? Text(
//                     Utils.getString('profile__edit'),
//                     softWrap: false,
//                     style: Theme.of(context)
//                         .textTheme
//                         .bodyText2
//                         .copyWith(fontWeight: FontWeight.bold),
//                   )
//                 : checkText == 1
//                     ? Text(
//                         Utils.getString('profile__history'),
//                         softWrap: false,
//                         style: Theme.of(context)
//                             .textTheme
//                             .bodyText2
//                             .copyWith(fontWeight: FontWeight.bold),
//                       )
//                     : Text(
//                         Utils.getString('profile__transaction'),
//                         softWrap: false,
//                         style: Theme.of(context)
//                             .textTheme
//                             .bodyText2
//                             .copyWith(fontWeight: FontWeight.bold),
//                       )));
//   }
// }

// class _OrderAndSeeAllWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         Navigator.pushNamed(
//           context,
//           RoutePaths.transactionList,
//         );
//       },
//       child: Padding(
//         padding: const EdgeInsets.only(
//             top: AppDimens.space20,
//             left: AppDimens.space16,
//             right: AppDimens.space16,
//             bottom: AppDimens.space16),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: <Widget>[
//             Text(Utils.getString('profile__order'),
//                 textAlign: TextAlign.start,
//                 style: Theme.of(context).textTheme.subtitle1),
//             InkWell(
//               child: Text(
//                 Utils.getString('profile__view_all'),
//                 textAlign: TextAlign.start,
//                 style: Theme.of(context)
//                     .textTheme
//                     .caption
//                     .copyWith(color: AppColors.mainColor),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class _ImageAndTextWidget extends StatelessWidget {
  const _ImageAndTextWidget({this.userProvider});
  final UserProvider userProvider;
  @override
  Widget build(BuildContext context) {
    final Widget _imageWidget = PsNetworkCircleImageForUser(
      photoKey: '',
      imagePath: userProvider.user.data.userProfilePhoto,
      boxfit: BoxFit.contain,
      onTap: () {},
    );
    const Widget _spacingWidget = SizedBox(
      height: AppDimens.space4,
    );
    final Widget _imageInCenterWidget = Positioned(
        top: 150,
        child: Stack(
          children: <Widget>[
            Container(
              width: 90,
              height: 90,
              child: PsNetworkCircleImageForUser(
                photoKey: '',
                imagePath: userProvider.user.data.userProfilePhoto,
                width: double.infinity,
                height: AppDimens.space200,
                boxfit: BoxFit.cover,
                onTap: () async {},
              ),
            ),
            // Positioned(
            //   top: 1,
            //   right: 1,
            //   child: _editWidget,
            // ),
          ],
        ));
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: AppDimens.space16),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Container(
                color: AppColors.baseLightColor,
                width: double.infinity,
                height: AppDimens.space200,
                child: _imageWidget,
              ),
              Container(
                color: AppColors.white.withAlpha(100),
                width: double.infinity,
                height: AppDimens.space200,
              ),
              Container(
                width: double.infinity,
                height: AppDimens.space260,
              ),
              _imageInCenterWidget,
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(
                horizontal: AppDimens.space16, vertical: AppDimens.space16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Row(
                //   children: <Widget>[
                //     const SizedBox(width: AppDimens.space16),
                //     Container(
                //         width: AppDimens.space80,
                //         height: AppDimens.space80,
                //         child: _imageWidget),
                //     const SizedBox(width: AppDimens.space16),
                //   ],
                // ),
                // const SizedBox(width: 40),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Text(
                        Utils.getString('edit_profile__user_name') + ':  ',
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      Row(
                        children: <Widget>[
                          const SizedBox(width: 16),
                          Text(
                            userProvider.user.data.userName,
                            textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ],
                      ),
                      _spacingWidget,
                      _spacingWidget,
                      _spacingWidget,
                      Text(
                        Utils.getString('edit_profile__email') + ':  ',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      Row(
                        children: <Widget>[
                          const SizedBox(width: 16),
                          Text(
                            userProvider.user.data.userEmail ?? '-',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ],
                      ),
                      _spacingWidget,
                      _spacingWidget,
                      _spacingWidget,
                      Text(
                        Utils.getString('edit_profile__about_me') + ': ',
                        style: Theme.of(context).textTheme.bodyText2,
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(children: <Widget>[
                        const SizedBox(width: 16),
                        Expanded(
                            child: Text(
                          'Ypesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letrase',
                          style: Theme.of(context).textTheme.bodyText2,
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                        )),
                      ]),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
