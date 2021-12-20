import 'package:carousel_slider/carousel_slider.dart';
import 'package:dni_ecommerce/config/app_colors.dart';
import 'package:dni_ecommerce/ui/common/app_ui_widget.dart';
import 'package:dni_ecommerce/viewobject/product.dart';
import 'package:flutter/material.dart';
import 'package:dni_ecommerce/constant/app_dimens.dart';

class BlogSliderView extends StatefulWidget {
  const BlogSliderView({
    Key key,
    @required this.blogList,
    this.onTap,
  }) : super(key: key);

  final Function onTap;
  final List<Product> blogList;

  @override
  _CollectionProductSliderState createState() =>
      _CollectionProductSliderState();
}

class _CollectionProductSliderState extends State<BlogSliderView> {
  String _currentId;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        if (widget.blogList != null && widget.blogList.isNotEmpty)
          CarouselSlider(
            options: CarouselOptions(
                enlargeCenterPage: true,
                autoPlay: true,
                viewportFraction: 0.9,
                autoPlayInterval: const Duration(seconds: 5),
                onPageChanged: (int i, CarouselPageChangedReason reason) {
                  setState(() {
                    _currentId = widget.blogList[i].id;
                  });
                }),

            items: widget.blogList.map((Product blog) {
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.mainLightShadowColor,
                  ),
                  borderRadius:
                      const BorderRadius.all(Radius.circular(AppDimens.space8)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: AppColors.mainLightShadowColor,
                        offset: const Offset(1.1, 1.1),
                        blurRadius: AppDimens.space8),
                  ],
                ),
                child: Stack(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppDimens.space8),
                      child: AppNetworkImageWithUrl(
                          photoKey: '',
                          imagePath: blog.image,
                          width: MediaQuery.of(context).size.width,
                          height: double.infinity,
                          boxfit: BoxFit.cover,
                          onTap: () {
                            widget.onTap(blog);
                          }),
                    ),
                  ],
                ),
              );
            }).toList(),
            // onPageChanged: (int i) {
            //   setState(() {
            //     _currentId = widget.blogList[i].id;
            //   });
            // },
          )
        else
          Container(),
        Positioned(
            bottom: 5.0,
            left: 0.0,
            right: 0.0,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.blogList != null && widget.blogList.isNotEmpty
                  ? widget.blogList.map((Product blog) {
                      return Builder(builder: (BuildContext context) {
                        return Container(
                            width: 8.0,
                            height: 8.0,
                            margin: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 2.0),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentId == blog.id
                                    ? AppColors.mainColor
                                    : AppColors.grey));
                      });
                    }).toList()
                  : <Widget>[Container()],
            ))
      ],
    );
  }
}
