import 'dart:io';
import 'package:dni_ecommerce/api/common/app_status.dart';
import 'package:dni_ecommerce/config/app_config.dart';
import 'package:dni_ecommerce/ui/common/app_square_progress_widget.dart';
import 'package:dni_ecommerce/viewobject/default_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage(
      {Key key,
      @required this.photoKey,
      @required this.image,
      this.width,
      this.height,
      this.onTap,
      this.boxfit = BoxFit.fill})
      : super(key: key);

  final double width;
  final double height;
  final Function onTap;
  final String photoKey;
  final BoxFit boxfit;
  final String image;

  @override
  Widget build(BuildContext context) {
    if (image == '') {
      return GestureDetector(
          onTap: onTap,
          child: Image.asset(
            'assets/images/placeholder_image.png',
            width: width,
            height: height,
            fit: boxfit,
          ));
    } else {
      final String fullImagePath = '${AppConfig.app_image_url}$image';
      print('img path : $fullImagePath');
      final String thumbnailImagePath =
          '${AppConfig.app_image_thumbs_url}$image';

      return Hero(
        transitionOnUserGestures: true,
        tag: photoKey,
        child: GestureDetector(
          onTap: onTap,
          child: OptimizedCacheImage(
            placeholder: (BuildContext context, String url) {
              if (true) {
                return OptimizedCacheImage(
                  width: width,
                  height: height,
                  fit: boxfit,
                  placeholder: (BuildContext context, String url) {
                    return AppSquareProgressWidget();
                  },
                  imageUrl: thumbnailImagePath,
                );
              }
              //  else {
              //   return AppSquareProgressWidget();
              // }
            },
            width: width,
            height: height,
            fit: boxfit,
            imageUrl: fullImagePath,
            errorWidget: (BuildContext context, String url, Object error) =>
                Image.asset(
              'assets/images/placeholder_image.png',
              // width: width,
              // height: height,
              fit: boxfit,
            ),
          ),
        ),
      );
    }
  }
}

class AppNetworkImageWithUrlForBlog extends StatelessWidget {
  const AppNetworkImageWithUrlForBlog(
      {Key key,
      @required this.photoKey,
      @required this.imagePath,
      this.width,
      this.height,
      this.onTap,
      this.boxfit = BoxFit.cover})
      : super(key: key);

  final double width;
  final double height;
  final Function onTap;
  final String photoKey;
  final BoxFit boxfit;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    if (imagePath == '') {
      return GestureDetector(
          onTap: onTap,
          child: Image.asset(
            'assets/images/placeholder_image.png',
            width: width,
            height: height,
            fit: boxfit,
          ));
    } else {
      final String fullImagePath = '${AppConfig.app_image_url}$imagePath';
      // final String thumbnailImagePath =
      //     '${AppConfig.app_image_thumbs_url}$imagePath';

      return GestureDetector(
        onTap: onTap,
        child: OptimizedCacheImage(
          placeholder: (BuildContext context, String url) {
            return  Image.asset(
            'assets/images/placeholder_image.png',
            width: width,
            height: height,
            fit: boxfit,
            );
          },
          width: width,
          height: height,
          fit: boxfit,
          imageUrl: fullImagePath,
          errorWidget: (BuildContext context, String url, Object error) =>
              Image.asset(
            'assets/images/placeholder_image.png',
            width: width,
            height: height,
            fit: boxfit,
          ),
        ),
      );
    }
  }
}

class AppNetworkImageWithUrl extends StatelessWidget {
  const AppNetworkImageWithUrl(
      {Key key,
      @required this.photoKey,
      @required this.imagePath,
      this.width,
      this.height,
      this.onTap,
      this.boxfit = BoxFit.cover})
      : super(key: key);

  final double width;
  final double height;
  final Function onTap;
  final String photoKey;
  final BoxFit boxfit;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    if (imagePath == '') {
      return GestureDetector(
          onTap: onTap,
          child: Image.asset(
            'assets/images/placeholder_image.png',
            width: width,
            height: height,
            fit: boxfit,
          ));
    } else {
      final String fullImagePath = '${AppConfig.app_image_url}$imagePath';
      final String thumbnailImagePath =
          '${AppConfig.app_image_thumbs_url}$imagePath';

      if (photoKey == '') {
        return GestureDetector(
          onTap: onTap,
          child: OptimizedCacheImage(
            placeholder: (BuildContext context, String url) {
              return OptimizedCacheImage(
                width: width,
                height: height,
                fit: boxfit,
                placeholder: (BuildContext context, String url) {
                  return AppSquareProgressWidget();
                },
                imageUrl: thumbnailImagePath,
              );
              //  else {
              //   return AppSquareProgressWidget();
              // }
            },
            width: width,
            height: height,
            fit: boxfit,
            imageUrl: fullImagePath,
            errorWidget: (BuildContext context, String url, Object error) =>
                Image.asset(
              'assets/images/placeholder_image.png',
              width: width,
              height: height,
              fit: boxfit,
            ),
          ),
        );
      } else {
        return GestureDetector(
          onTap: onTap,
          child: OptimizedCacheImage(
            placeholder: (BuildContext context, String url) {
              return OptimizedCacheImage(
                width: width,
                height: height,
                fit: boxfit,
                placeholder: (BuildContext context, String url) {
                  return AppSquareProgressWidget();
                },
                imageUrl: thumbnailImagePath,
              );

              // else {
              //   return AppSquareProgressWidget();
              // }
            },
            width: width,
            height: height,
            fit: boxfit,
            imageUrl: '${AppConfig.app_image_url}$imagePath',
            errorWidget: (BuildContext context, String url, Object error) =>
                Image.asset(
              'assets/images/placeholder_image.png',
              width: width,
              height: height,
              fit: boxfit,
            ),
          ),
        );
      }
    }
  }
}

class AppNetworkImageWithUrlForUser extends StatelessWidget {
  const AppNetworkImageWithUrlForUser(
      {Key key,
      @required this.photoKey,
      @required this.imagePath,
      this.width,
      this.height,
      this.onTap,
      this.boxfit = BoxFit.cover})
      : super(key: key);

  final double width;
  final double height;
  final Function onTap;
  final String photoKey;
  final BoxFit boxfit;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    if (imagePath == '') {
      return GestureDetector(
          onTap: onTap,
          child: Image.asset(
            'assets/images/user_default_photo.png',
            width: width,
            height: height,
            fit: boxfit,
          ));
    } else {
      final String fullImagePath = '${AppConfig.app_image_url}$imagePath';
      final String thumbnailImagePath =
          '${AppConfig.app_image_thumbs_url}$imagePath';

      if (photoKey == '') {
        return GestureDetector(
          onTap: onTap,
          child: OptimizedCacheImage(
            placeholder: (BuildContext context, String url) {
              if (true) {
                return OptimizedCacheImage(
                  width: width,
                  height: height,
                  fit: boxfit,
                  placeholder: (BuildContext context, String url) {
                    return AppSquareProgressWidget();
                  },
                  imageUrl: thumbnailImagePath,
                );
              }
              // else {
              //   return AppSquareProgressWidget();
              // }
            },
            width: width,
            height: height,
            fit: boxfit,
            imageUrl: fullImagePath,
            errorWidget: (BuildContext context, String url, Object error) =>
                Image.asset(
              'assets/images/user_default_photo.png',
              width: width,
              height: height,
              fit: boxfit,
            ),
          ),
        );
      } else {
        return GestureDetector(
          onTap: onTap,
          child: OptimizedCacheImage(
            placeholder: (BuildContext context, String url) {
              if (true) {
                return OptimizedCacheImage(
                  width: width,
                  height: height,
                  fit: boxfit,
                  placeholder: (BuildContext context, String url) {
                    return AppSquareProgressWidget();
                  },
                  imageUrl: thumbnailImagePath,
                );
              }
              // else {
              //   return AppSquareProgressWidget();
              // }
            },
            width: width,
            height: height,
            fit: boxfit,
            imageUrl: '${AppConfig.app_image_url}$imagePath',
            errorWidget: (BuildContext context, String url, Object error) =>
                Image.asset(
              'assets/images/user_default_photo.png',
              width: width,
              height: height,
              fit: boxfit,
            ),
          ),
        );
      }
    }
  }
}

class PsFileImage extends StatelessWidget {
  const PsFileImage(
      {Key key,
      @required this.photoKey,
      @required this.file,
      this.width,
      this.height,
      this.onTap,
      this.boxfit = BoxFit.cover})
      : super(key: key);

  final double width;
  final double height;
  final Function onTap;
  final String photoKey;
  final BoxFit boxfit;
  final File file;

  @override
  Widget build(BuildContext context) {
    if (file == null) {
      return GestureDetector(
          onTap: onTap,
          child: Image.asset(
            'assets/images/placeholder_image.png',
            width: width,
            height: height,
            fit: boxfit,
          ));
    } else {
      if (photoKey == '') {
        return GestureDetector(
            onTap: onTap,
            child: Image(
              image: FileImage(file),
            ));
      } else {
        return GestureDetector(
            onTap: onTap,
            child: Image(
              image: FileImage(file),
            ));
      }
    }
  }
}

class PsNetworkCircleImage extends StatelessWidget {
  const PsNetworkCircleImage(
      {Key key,
      @required this.photoKey,
      this.imagePath,
      this.asset,
      this.width,
      this.height,
      this.onTap,
      this.boxfit = BoxFit.cover})
      : super(key: key);

  final double width;
  final double height;
  final Function onTap;
  final String photoKey;
  final BoxFit boxfit;
  final String imagePath;
  final String asset;

  @override
  Widget build(BuildContext context) {
    if (imagePath == null || imagePath == '') {
      if (asset == null || asset == '') {
        return GestureDetector(
            onTap: onTap,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10000.0),
                child: Image.asset(
                  'assets/images/placeholder_image.png',
                  width: width,
                  height: height,
                  fit: boxfit,
                )));
      } else {
        print('I Key : $photoKey$asset');
        print('');
        return GestureDetector(
            onTap: onTap,
            child: Hero(
              tag: '$photoKey$asset',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10000.0),
                child: Image.asset(asset,
                    width: width, height: height, fit: boxfit),
              ),
            ));
      }
    } else {
      final String fullImagePath = '${AppConfig.app_image_url}$imagePath';
      final String thumbnailImagePath =
          '${AppConfig.app_image_thumbs_url}$imagePath';

      if (photoKey == '') {
        return GestureDetector(
            onTap: onTap,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10000.0),
              child: OptimizedCacheImage(
                placeholder: (BuildContext context, String url) {
                  if (true) {
                    return OptimizedCacheImage(
                      width: width,
                      height: height,
                      fit: boxfit,
                      placeholder: (BuildContext context, String url) {
                        return AppSquareProgressWidget();
                      },
                      imageUrl: thumbnailImagePath,
                    );
                  }
                  // else {
                  //   return AppSquareProgressWidget();
                  // }
                },
                width: width,
                height: height,
                fit: boxfit,
                imageUrl: fullImagePath,
                errorWidget: (BuildContext context, String url, Object error) =>
                    Image.asset(
                  'assets/images/placeholder_image.png',
                  width: width,
                  height: height,
                  fit: boxfit,
                ),
              ),
            ));
      } else {
        return GestureDetector(
          onTap: onTap,
          child: Hero(
              tag: '$photoKey$imagePath',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10000.0),
                child: OptimizedCacheImage(
                  placeholder: (BuildContext context, String url) {
                    if (true) {
                      return OptimizedCacheImage(
                        width: width,
                        height: height,
                        fit: boxfit,
                        placeholder: (BuildContext context, String url) {
                          return AppSquareProgressWidget();
                        },
                        imageUrl: thumbnailImagePath,
                      );
                    }
                    // else {
                    //   return AppSquareProgressWidget();
                    // }
                  },
                  width: width,
                  height: height,
                  fit: boxfit,
                  imageUrl: '${AppConfig.app_image_url}$imagePath',
                  errorWidget:
                      (BuildContext context, String url, Object error) =>
                          Image.asset(
                    'assets/images/placeholder_image.png',
                    width: width,
                    height: height,
                    fit: boxfit,
                  ),
                ),
              )),
        );
      }
    }
  }
}

class PsNetworkCircleImageForUser extends StatelessWidget {
  const PsNetworkCircleImageForUser(
      {Key key,
      @required this.photoKey,
      this.imagePath,
      this.asset,
      this.width,
      this.height,
      this.onTap,
      this.boxfit = BoxFit.cover})
      : super(key: key);

  final double width;
  final double height;
  final Function onTap;
  final String photoKey;
  final BoxFit boxfit;
  final String imagePath;
  final String asset;

  @override
  Widget build(BuildContext context) {
    if (imagePath == null || imagePath == '') {
      if (asset == null || asset == '') {
        return GestureDetector(
            onTap: onTap,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10000.0),
                child: Image.asset(
                  'assets/images/user_default_photo.png',
                  width: width,
                  height: height,
                  fit: boxfit,
                )));
      } else {
        print('I Key : $photoKey$asset');
        print('');
        return GestureDetector(
            onTap: onTap,
            child: Hero(
              tag: '$photoKey$asset',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10000.0),
                child: Image.asset(asset,
                    width: width, height: height, fit: boxfit),
              ),
            ));
      }
    } else {
      final String fullImagePath = '${AppConfig.app_image_url}$imagePath';
      final String thumbnailImagePath =
          '${AppConfig.app_image_thumbs_url}$imagePath';

      if (photoKey == '') {
        return GestureDetector(
            onTap: onTap,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10000.0),
              child: OptimizedCacheImage(
                placeholder: (BuildContext context, String url) {
                  if (true) {
                    return OptimizedCacheImage(
                      width: width,
                      height: height,
                      fit: boxfit,
                      placeholder: (BuildContext context, String url) {
                        return AppSquareProgressWidget();
                      },
                      imageUrl: thumbnailImagePath,
                    );
                  }
                  // else {
                  //   return AppSquareProgressWidget();
                  // }
                },
                width: width,
                height: height,
                fit: boxfit,
                imageUrl: fullImagePath,
                errorWidget: (BuildContext context, String url, Object error) =>
                    Image.asset(
                  'assets/images/user_default_photo.png',
                  width: width,
                  height: height,
                  fit: boxfit,
                ),
              ),
            ));
      } else {
        return GestureDetector(
          onTap: onTap,
          child: Hero(
              tag: '$photoKey$imagePath',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10000.0),
                child: OptimizedCacheImage(
                  placeholder: (BuildContext context, String url) {
                    if (true) {
                      return OptimizedCacheImage(
                        width: width,
                        height: height,
                        fit: boxfit,
                        placeholder: (BuildContext context, String url) {
                          return AppSquareProgressWidget();
                        },
                        imageUrl: thumbnailImagePath,
                      );
                    }
                    //  else {
                    //   return AppSquareProgressWidget();
                    // }
                  },
                  width: width,
                  height: height,
                  fit: boxfit,
                  imageUrl: '${AppConfig.app_image_url}$imagePath',
                  errorWidget:
                      (BuildContext context, String url, Object error) =>
                          Image.asset(
                    'assets/images/user_default_photo.png',
                    width: width,
                    height: height,
                    fit: boxfit,
                  ),
                ),
              )),
        );
      }
    }
  }
}

class PsFileCircleImage extends StatelessWidget {
  const PsFileCircleImage(
      {Key key,
      @required this.photoKey,
      this.file,
      this.asset,
      this.width,
      this.height,
      this.onTap,
      this.boxfit = BoxFit.cover})
      : super(key: key);

  final double width;
  final double height;
  final Function onTap;
  final String photoKey;
  final BoxFit boxfit;
  final File file;
  final String asset;

  @override
  Widget build(BuildContext context) {
    if (file == null) {
      if (asset == null || asset == '') {
        return GestureDetector(
            onTap: onTap,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10000.0),
                child: Container(
                    width: width,
                    height: height,
                    child: const Icon(Icons.image))));
      } else {
        print('I Key : $photoKey$asset');
        print('');
        return GestureDetector(
            onTap: onTap,
            child: Hero(
              tag: '$photoKey$asset',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10000.0),
                child: Image.asset(asset,
                    width: width, height: height, fit: boxfit),
              ),
            ));
      }
    } else {
      if (photoKey == '') {
        return GestureDetector(
            onTap: onTap,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10000.0),
                child: Image(
                  image: FileImage(file),
                )));
      } else {
        return GestureDetector(
          onTap: onTap,
          child: Hero(
              tag: file,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10000.0),
                  child: Image(image: FileImage(file)))),
        );
      }
    }
  }
}

class AppProgressIndicator extends StatefulWidget {
  const AppProgressIndicator(this._status, {this.message});
  final AppStatus _status;
  final String message;

  @override
  _AppProgressIndicator createState() => _AppProgressIndicator();
}

class _AppProgressIndicator extends State<AppProgressIndicator> {
  @override
  Widget build(BuildContext context) {
    if (widget._status == AppStatus.ERROR &&
        widget.message != null &&
        widget.message != '') {
      // Fluttertoast.showToast(
      //     msg: widget.message,
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.BOTTOM,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: Colors.redAccent,
      //     textColor: Colors.white);
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Visibility(
          visible: widget._status == AppStatus.PROGRESS_LOADING,
          child: const LinearProgressIndicator(),
        ),
      ),
    );
  }
}

class PsNetworkCircleIconImage extends StatelessWidget {
  const PsNetworkCircleIconImage(
      {Key key,
      @required this.photoKey,
      @required this.defaultIcon,
      this.width,
      this.height,
      this.onTap,
      this.boxfit = BoxFit.cover})
      : super(key: key);

  final double width;
  final double height;
  final Function onTap;
  final String photoKey;
  final BoxFit boxfit;
  final DefaultIcon defaultIcon;

  @override
  Widget build(BuildContext context) {
    if (defaultIcon.imgPath == '') {
      return GestureDetector(
          onTap: onTap,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(10000.0),
              child: Image.asset(
                'assets/images/placeholder_image.png',
                width: width,
                height: height,
                fit: boxfit,
              )));
    } else {
      final String fullImagePath =
          '${AppConfig.app_image_url}${defaultIcon.imgPath}';
      final String thumbnailImagePath =
          '${AppConfig.app_image_thumbs_url}${defaultIcon.imgPath}';

      if (photoKey == '') {
        return GestureDetector(
            onTap: onTap,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10000.0),
              child: OptimizedCacheImage(
                placeholder: (BuildContext context, String url) {
                  if (true) {
                    return OptimizedCacheImage(
                      width: width,
                      height: height,
                      fit: boxfit,
                      placeholder: (BuildContext context, String url) {
                        return AppSquareProgressWidget();
                      },
                      imageUrl: thumbnailImagePath,
                    );
                  }
                  // else {
                  //   return AppSquareProgressWidget();
                  // }
                },
                width: width,
                height: height,
                fit: boxfit,
                imageUrl: fullImagePath,
                errorWidget: (BuildContext context, String url, Object error) =>
                    Image.asset(
                  'assets/images/placeholder_image.png',
                  width: width,
                  height: height,
                  fit: boxfit,
                ),
              ),
            ));
      } else {
        return GestureDetector(
          onTap: onTap,
          child: Hero(
              tag: '$photoKey${AppConfig.app_image_url}${defaultIcon.imgPath}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10000.0),
                child: OptimizedCacheImage(
                  placeholder: (BuildContext context, String url) {
                    if (true) {
                      return OptimizedCacheImage(
                        width: width,
                        height: height,
                        fit: boxfit,
                        placeholder: (BuildContext context, String url) {
                          return AppSquareProgressWidget();
                        },
                        imageUrl: thumbnailImagePath,
                      );
                    }
                    //  else {
                    //   return AppSquareProgressWidget();
                    // }
                  },
                  width: width,
                  height: height,
                  fit: boxfit,
                  imageUrl: '${AppConfig.app_image_url}${defaultIcon.imgPath}',
                  errorWidget:
                      (BuildContext context, String url, Object error) =>
                          Image.asset(
                    'assets/images/placeholder_image.png',
                    width: width,
                    height: height,
                    fit: boxfit,
                  ),
                ),
              )),
        );
      }
    }
  }
}
