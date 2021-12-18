import 'package:dni_ecommerce/config/app_config.dart';
import 'package:dni_ecommerce/constant/route_paths.dart';
import 'package:dni_ecommerce/provider/transaction/transaction_header_provider.dart';
import 'package:dni_ecommerce/repository/transaction_header_repository.dart';
import 'package:dni_ecommerce/ui/common/app_ui_widget.dart';
import 'package:dni_ecommerce/ui/transaction/item/transaction_list_item.dart';
import 'package:dni_ecommerce/utils/utils.dart';
import 'package:dni_ecommerce/viewobject/common/app_value_holder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionListView extends StatefulWidget {
  const TransactionListView(
      {Key key, @required this.animationController, @required this.scaffoldKey})
      : super(key: key);
  final AnimationController animationController;
  final GlobalKey<ScaffoldState> scaffoldKey;
  @override
  _TransactionListViewState createState() => _TransactionListViewState();
}

class _TransactionListViewState extends State<TransactionListView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  TransactionHeaderProvider _transactionProvider;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _transactionProvider.nextTransactionList();
      }
    });

    super.initState();
  }

  TransactionHeaderRepository repo1;
  AppValueHolder psValueHolder;
  dynamic data;
  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;

  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
      if (isConnectedToInternet && AppConfig.showAdMob) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isConnectedToInternet && AppConfig.showAdMob) {
      print('loading ads....');
      checkConnection();
    }
    repo1 = Provider.of<TransactionHeaderRepository>(context);
    psValueHolder = Provider.of<AppValueHolder>(context);
    print(
        '............................Build UI Again ............................');
    return ChangeNotifierProvider<TransactionHeaderProvider>(
      lazy: false,
      create: (BuildContext context) {
        final TransactionHeaderProvider provider = TransactionHeaderProvider(
            repo: repo1, psValueHolder: psValueHolder);
        provider.loadTransactionList(psValueHolder.loginUserId);
        _transactionProvider = provider;
        return _transactionProvider;
      },
      child: Consumer<TransactionHeaderProvider>(builder: (BuildContext context,
          TransactionHeaderProvider provider, Widget child) {
        // if (prsider.transactionList.data.isNotEmpty) {
        return Column(
          children: <Widget>[
            // Padding(
            //   padding: const EdgeInsets.all(AppDimens.space16),
            //   child: AppButtonWidget(
            //     hasShadow: true,
            //     width: double.infinity,
            //     titleText: Utils.getString('transaction_list__filter_title'),
            //     onPressed: () {
            //       showDialog<dynamic>(
            //           context: context,
            //           builder: (BuildContext context) {
            //             return ChooseFilterTransactionDialog(
            //               onDailyTap: () {
            //                 provider
            //                     .loadTransactionList(psValueHolder.loginUserId);
            //               },
            //               onWeeklyTap: () {},
            //               onMonthlyTap: () {},
            //               onYearlyTap: () {},
            //             );
            //           });
            //     },
            //   ),
            // ),
            // const PsAdMobBannerWidget(),
            // Visibility(
            //   visible: AppConfig.showAdMob &&
            //       isSuccessfullyLoaded &&
            //       isConnectedToInternet,
            //   child: AdmobBanner(
            //     adUnitId: Utils.getBannerAdUnitId(),
            //     adSize: AdmobBannerSize.FULL_BANNER,
            //     listener: (AdmobAdEvent event, Map<String, dynamic> map) {
            //       print('BannerAd event is $event');
            //       if (event == AdmobAdEvent.loaded) {
            //         isSuccessfullyLoaded = true;
            //       } else {
            //         isSuccessfullyLoaded = false;
            //         setState(() {});
            //       }
            //     },
            //   ),
            // ),
            Expanded(
              child: Stack(
                children: <Widget>[
                  RefreshIndicator(
                    child: CustomScrollView(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        slivers: <Widget>[
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                final int count =
                                    provider.transactionList.data.length;
                                return TransactionListItem(
                                  scaffoldKey: widget.scaffoldKey,
                                  animationController:
                                      widget.animationController,
                                  animation: Tween<double>(begin: 0.0, end: 1.0)
                                      .animate(
                                    CurvedAnimation(
                                      parent: widget.animationController,
                                      curve: Interval((1 / count) * index, 1.0,
                                          curve: Curves.fastOutSlowIn),
                                    ),
                                  ),
                                  transaction:
                                      provider.transactionList.data[index],
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, RoutePaths.transactionDetail,
                                        arguments: provider
                                            .transactionList.data[index]);
                                  },
                                );
                              },
                              childCount: provider.transactionList.data.length,
                            ),
                          ),
                        ]),
                    onRefresh: () {
                      return provider.resetTransactionList();
                    },
                  ),
                  AppProgressIndicator(provider.transactionList.status)
                ],
              ),
            )
          ],
        );
        // } else {
        //   return Container();
        // }
      }),
    );
  }
}
