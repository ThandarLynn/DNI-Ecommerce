import 'package:dni_ecommerce/constant/route_paths.dart';
import 'package:dni_ecommerce/provider/gallery/gallery_provider.dart';
import 'package:dni_ecommerce/repository/gallery_repository.dart';
import 'package:dni_ecommerce/ui/common/app_ui_widget.dart';
import 'package:dni_ecommerce/ui/common/app_widget_with_appbar.dart';
import 'package:dni_ecommerce/ui/gallery/item/gallery_grid_item.dart';
import 'package:dni_ecommerce/utils/utils.dart';
import 'package:dni_ecommerce/viewobject/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GalleryGridView extends StatefulWidget {
  const GalleryGridView({
    Key key,
    @required this.product,
    this.onImageTap,
  }) : super(key: key);

  final Product product;
  final Function onImageTap;
  @override
  _GalleryGridViewState createState() => _GalleryGridViewState();
}

class _GalleryGridViewState extends State<GalleryGridView>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final GalleryRepository productRepo =
        Provider.of<GalleryRepository>(context);
    print(
        '............................Build UI Again ............................');
    return AppWidgetWithAppBar<GalleryProvider>(
        appBarTitle: Utils.getString('gallery__title') ?? '',
        initProvider: () {
          return GalleryProvider(repo: productRepo);
        },
        onProviderReady: (GalleryProvider provider) {
          provider.loadImageList(
            widget.product.id,
          );
        },
        builder:
            (BuildContext context, GalleryProvider provider, Widget child) {
          if (provider.galleryList != null &&
              provider.galleryList.data.isNotEmpty) {
            return Stack(
              children: <Widget>[
                Container(
                  color: Theme.of(context).cardColor,
                  height: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: RefreshIndicator(
                      child:
                          CustomScrollView(shrinkWrap: true, slivers: <Widget>[
                        SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 150,
                                  childAspectRatio: 1.0),
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return GalleryGridItem(
                                  image: provider.galleryList.data[index],
                                  onImageTap: () {
                                    Navigator.pushNamed(
                                        context, RoutePaths.galleryDetail,
                                        arguments:
                                            provider.galleryList.data[index]);
                                  });
                            },
                            childCount: provider.galleryList.data.length,
                          ),
                        )
                      ]),
                      onRefresh: () {
                        return provider.resetGallaryList(widget.product.id);
                      },
                    ),
                  ),
                ),
                AppProgressIndicator(provider.galleryList.status)
              ],
            );
          } else {
            return Stack(
              children: <Widget>[
                Container(),
                AppProgressIndicator(provider.galleryList.status)
              ],
            );
          }
        });
  }
}
