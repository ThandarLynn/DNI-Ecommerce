import 'package:dni_ecommerce/viewobject/ItemColor.dart';
import 'package:dni_ecommerce/viewobject/rating_detail.dart';

import 'common/app_object.dart';
// import 'gallery.dart';

class Product extends AppObject<Product> {
  Product(
      {this.id,
      this.catId,
      this.subCatId,
      this.catName,
      this.subCatName,
      this.productUnit,
      this.productMeasurement,
      this.name,
      this.image,
      this.description,
      this.originalPrice,
      this.unitPrice,
      this.shippingCost,
      this.minimumOrder,
      this.maximumOrder,
      this.searchTag,
      this.highlightInformation,
      // this.isDiscount,
      this.isFeatured,
      this.isAvailable,
      this.code,
      this.status,
      this.addedDate,
      this.addedUserId,
      this.updatedDate,
      this.updatedUserId,
      this.updatedFlag,
      this.overallRating,
      this.touchCount,
      this.favouriteCount,
      this.likeCount,
      this.featuredDate,
      this.dynamicLink,
      this.addedDateStr,
      this.transStatus,
      this.isliked,
      this.isFavourited,
      this.isPurchased,
      this.imageCount,
      this.commentHeaderCount,
      this.currencySymbol,
      this.currencyShortForm,
      this.discountAmount,
      // this.discountPercent,
      this.discountValue,
      this.ratingDetail,
      this.itemColorList});

  String id;
  String catId;
  String subCatId;
  String catName;
  String subCatName;
  String productUnit;
  String productMeasurement;
  String name;
  String image;
  String description;
  String originalPrice;
  String unitPrice;
  String shippingCost;
  String minimumOrder;
  String maximumOrder;
  String searchTag;
  String highlightInformation;
  // String isDiscount;
  String isFeatured;
  String isAvailable;
  String code;
  String status;
  String addedDate;
  String addedUserId;
  String updatedDate;
  String updatedUserId;
  String updatedFlag;
  String overallRating;
  String touchCount;
  String favouriteCount;
  String likeCount;
  String featuredDate;
  String dynamicLink;
  String addedDateStr;
  String transStatus;
  String isliked;
  String isFavourited;
  String isPurchased; // to remove later
  String imageCount;
  String commentHeaderCount;
  String currencySymbol;
  String currencyShortForm;
  String discountAmount;
  // String discountPercent;
  String discountValue;
  RatingDetail ratingDetail;
  List<ItemColor> itemColorList;

  @override
  String getPrimaryKey() {
    return id;
  }

  @override
  Product fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return Product(
          id: dynamicData['id'],
          catId: dynamicData['category_id'],
          subCatId: dynamicData['sub_cat_id'],
          catName: dynamicData['category_name'],
          subCatName: dynamicData['sub_cat_name'],
          productUnit: dynamicData['product_unit'],
          productMeasurement: dynamicData['product_measurement'],
          name: dynamicData['name'],
          image: dynamicData['image'],
          description: dynamicData['description'],
          originalPrice: dynamicData['regular_price'],
          unitPrice: dynamicData['sale_price'],
          shippingCost: dynamicData['shipping_cost'],
          minimumOrder: dynamicData['minimum_order'],
          maximumOrder: dynamicData['maximum_order'],
          searchTag: dynamicData['search_tag'],
          highlightInformation: dynamicData['highlight_information'],
          // isDiscount: dynamicData['is_discount'],
          isFeatured: dynamicData['is_featured'],
          isAvailable: dynamicData['stock_status'],
          code: dynamicData['code'],
          status: dynamicData['status'],
          addedDate: dynamicData['added_date'],
          addedUserId: dynamicData['added_user_id'],
          updatedDate: dynamicData['updated_date'],
          updatedUserId: dynamicData['updated_user_id'],
          updatedFlag: dynamicData['updated_flag'],
          overallRating: dynamicData['overall_rating'],
          touchCount: dynamicData['touch_count'],
          favouriteCount: dynamicData['favourite_count'],
          likeCount: dynamicData['like_count'],
          featuredDate: dynamicData['featured_date'],
          dynamicLink: dynamicData['dynamic_link'],
          addedDateStr: dynamicData['added_date_str'],
          transStatus: dynamicData['trans_status'],
          isliked: dynamicData['is_liked'],
          isFavourited: dynamicData['is_favourited'],
          isPurchased: dynamicData['is_purchased'],
          imageCount: dynamicData['image_count'],
          commentHeaderCount: dynamicData['comment_header_count'],
          currencySymbol: dynamicData['currency_symbol'],
          currencyShortForm: dynamicData['currency_short_form'],
          discountAmount: dynamicData['discount_amount'],
          // discountPercent: dynamicData['discount_percent'],
          discountValue: dynamicData['discount_value'],
          itemColorList: ItemColor().fromMapList(dynamicData['colors']),
          ratingDetail: RatingDetail().fromMap(dynamicData['rating_details']));
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(dynamic object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['id'] = object.id;
      data['category_id'] = object.catId;
      data['sub_cat_id'] = object.subCatId;
      data['category_name'] = object.catName;
      data['sub_cat_name'] = object.subCatName;
      data['product_unit'] = object.productUnit;
      data['product_measurement'] = object.productMeasurement;
      data['name'] = object.name;
      data['image'] = object.image;
      data['description'] = object.description;
      data['regular_price'] = object.originalPrice;
      data['sale_price'] = object.unitPrice;
      data['shipping_cost'] = object.shippingCost;
      data['minimum_order'] = object.minimumOrder;
      data['maximum_order'] = object.maximumOrder;
      data['search_tag'] = object.searchTag;
      data['highlight_information'] = object.highlightInformation;
      // data['is_discount'] = object.isDiscount;
      data['is_featured'] = object.isFeatured;
      data['stock_status'] = object.isAvailable;
      data['code'] = object.code;
      data['status'] = object.status;
      data['added_date'] = object.addedDate;
      data['added_user_id'] = object.addedUserId;
      data['updated_date'] = object.updatedDate;
      data['updated_user_id'] = object.updatedUserId;
      data['updated_flag'] = object.updatedFlag;
      data['overall_rating'] = object.overallRating;
      data['touch_count'] = object.touchCount;
      data['favourite_count'] = object.favouriteCount;
      data['like_count'] = object.likeCount;
      data['featured_date'] = object.featuredDate;
      data['dynamic_link'] = object.dynamicLink;
      data['added_date_str'] = object.addedDateStr;
      data['trans_status'] = object.transStatus;
      data['is_liked'] = object.isliked;
      data['is_favourited'] = object.isFavourited;
      data['is_purchased'] = object.isPurchased;
      data['image_count'] = object.imageCount;
      data['comment_header_count'] = object.commentHeaderCount;
      data['currency_symbol'] = object.currencySymbol;
      data['currency_short_form'] = object.currencyShortForm;
      data['discount_amount'] = object.discountAmount;
      // data['discount_percent'] = object.discountPercent;
      data['discount_value'] = object.discountValue;
      // data['default_photo'] = Gallery().toMap(object.Gallery);
      data['colors'] = ItemColor().toMapList(object.itemColorList);
      data['rating_details'] = RatingDetail().toMap(object.ratingDetail);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<Product> fromMapList(List<dynamic> dynamicDataList) {
    final List<Product> newFeedList = <Product>[];
    if (dynamicDataList != null) {
      for (dynamic json in dynamicDataList) {
        if (json != null) {
          newFeedList.add(fromMap(json));
        }
      }
    }
    return newFeedList;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<dynamic> objectList) {
    final List<Map<String, dynamic>> dynamicList = <Map<String, dynamic>>[];

    if (objectList != null) {
      for (dynamic data in objectList) {
        if (data != null) {
          dynamicList.add(toMap(data));
        }
      }
    }
    return dynamicList;
  }
}
