import 'package:dni_ecommerce/constant/app_dimens.dart';
import 'package:dni_ecommerce/ui/common/app_ui_widget.dart';
import 'package:dni_ecommerce/viewobject/gallery.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GalleryGridItem extends StatelessWidget {
  const GalleryGridItem({
    Key key,
    @required this.image,
    this.onImageTap,
  }) : super(key: key);

  final Gallery image;
  final Function onImageTap;

  @override
  Widget build(BuildContext context) {
    final Widget _imageWidget = AppNetworkImageWithUrl(
      photoKey: '',
      imagePath: image.url,
      width: MediaQuery.of(context).size.width,
      height: double.infinity,
      boxfit: BoxFit.cover,
      onTap: onImageTap,
    );
    return Container(
      margin: const EdgeInsets.all(AppDimens.space4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimens.space8),
        child: image != null ? _imageWidget : null,
      ),
    );
  }
}
