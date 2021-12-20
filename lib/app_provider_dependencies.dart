import 'package:dni_ecommerce/api/app_api_service.dart';
import 'package:dni_ecommerce/db/blog_dao.dart';
import 'package:dni_ecommerce/db/category_map_dao.dart';
import 'package:dni_ecommerce/db/cateogry_dao.dart';
import 'package:dni_ecommerce/db/gallery_dao.dart';
import 'package:dni_ecommerce/db/product_dao.dart';
import 'package:dni_ecommerce/db/product_map_dao.dart';
import 'package:dni_ecommerce/db/sub_category_dao.dart';
import 'package:dni_ecommerce/db/top_rated_product_dao.dart';
import 'package:dni_ecommerce/db/top_selling_product_dao.dart';
import 'package:dni_ecommerce/repository/basket_repository.dart';
import 'package:dni_ecommerce/repository/blog_repository.dart';
import 'package:dni_ecommerce/repository/category_repository.dart';
import 'package:dni_ecommerce/repository/contact_us_repository.dart';
import 'package:dni_ecommerce/repository/coupon_discount_repository.dart';
import 'package:dni_ecommerce/repository/history_repsitory.dart';
import 'package:dni_ecommerce/repository/product_repository.dart';
import 'package:dni_ecommerce/repository/shipping_city_repository.dart';
import 'package:dni_ecommerce/repository/shipping_country_repository.dart';
import 'package:dni_ecommerce/repository/sub_category_repository.dart';
import 'package:dni_ecommerce/repository/tansaction_detail_repository.dart';
import 'package:dni_ecommerce/repository/token_repository.dart';
import 'package:dni_ecommerce/repository/transaction_header_repository.dart';
import 'package:dni_ecommerce/repository/user_repository.dart';
import 'package:dni_ecommerce/viewobject/common/app_value_holder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:dni_ecommerce/repository/gallery_repository.dart';
import 'db/basket_dao.dart';
import 'db/common/app_shared_preferences.dart';
import 'db/history_dao.dart';
import 'db/shipping_city_dao.dart';
import 'db/shipping_country_dao.dart';
import 'db/transaction_detail_dao.dart';
import 'db/transaction_header_dao.dart';
import 'db/user_dao.dart';

List<SingleChildWidget> providers = <SingleChildWidget>[
  ...independentProviders,
  ..._dependentProviders,
  ..._valueProviders,
];

List<SingleChildWidget> independentProviders = <SingleChildWidget>[
  Provider<AppSharedPreferencess>.value(value: AppSharedPreferencess.instance),
  Provider<AppApiService>.value(value: AppApiService()),
  Provider<CategoryDao>.value(value: CategoryDao()),
  Provider<SubCategoryDao>.value(value: SubCategoryDao()),
  Provider<CategoryMapDao>.value(value: CategoryMapDao.instance),
  Provider<ProductDao>.value(
      value: ProductDao.instance), //correct type with instance
  Provider<ProductMapDao>.value(value: ProductMapDao.instance),
  Provider<BlogDao>.value(value: BlogDao.instance),
  Provider<TransactionHeaderDao>.value(value: TransactionHeaderDao.instance),
  Provider<TransactionDetailDao>.value(value: TransactionDetailDao.instance),
  Provider<UserDao>.value(value: UserDao.instance),
  Provider<ShippingCountryDao>.value(value: ShippingCountryDao.instance),
  Provider<ShippingCityDao>.value(value: ShippingCityDao.instance),
  Provider<HistoryDao>.value(value: HistoryDao.instance),
  Provider<GalleryDao>.value(value: GalleryDao.instance),
  Provider<BasketDao>.value(value: BasketDao.instance),
  Provider<TopSellingProductDao>.value(value: TopSellingProductDao.instance),
  Provider<TopRatedProductDao>.value(value: TopRatedProductDao.instance),
];

List<SingleChildWidget> _dependentProviders = <SingleChildWidget>[
  ProxyProvider2<AppApiService, CategoryDao, CategoryRepository>(
    update: (_, AppApiService appApiService, CategoryDao categoryDao,
            CategoryRepository categoryRepository2) =>
        CategoryRepository(
            appApiService: appApiService, categoryDao: categoryDao),
  ),
  ProxyProvider2<AppApiService, SubCategoryDao, SubCategoryRepository>(
    update: (_, AppApiService appApiService, SubCategoryDao subCategoryDao,
            SubCategoryRepository subCategoryRepository) =>
        SubCategoryRepository(
            appApiService: appApiService, subCategoryDao: subCategoryDao),
  ),
  ProxyProvider2<AppApiService, ProductDao, ProductRepository>(
    update: (_, AppApiService appApiService, ProductDao productDao,
            ProductRepository categoryRepository2) =>
        ProductRepository(appApiService: appApiService, productDao: productDao),
  ),
  ProxyProvider2<AppApiService, UserDao, UserRepository>(
    update: (_, AppApiService appApiService, UserDao userDao,
            UserRepository userRepository) =>
        UserRepository(appApiService: appApiService, userDao: userDao),
  ),
  ProxyProvider2<AppApiService, BlogDao, BlogRepository>(
    update: (_, AppApiService appApiService, BlogDao blogDao,
            BlogRepository blogRepository) =>
        BlogRepository(appApiService: appApiService, blogDao: blogDao),
  ),
  ProxyProvider2<AppApiService, TransactionHeaderDao,
      TransactionHeaderRepository>(
    update: (_,
            AppApiService appApiService,
            TransactionHeaderDao transactionHeaderDao,
            TransactionHeaderRepository transactionRepository) =>
        TransactionHeaderRepository(
            appApiService: appApiService,
            transactionHeaderDao: transactionHeaderDao),
  ),
  ProxyProvider2<AppApiService, TransactionDetailDao,
      TransactionDetailRepository>(
    update: (_,
            AppApiService appApiService,
            TransactionDetailDao transactionDetailDao,
            TransactionDetailRepository transactionDetailRepository) =>
        TransactionDetailRepository(
            appApiService: appApiService,
            transactionDetailDao: transactionDetailDao),
  ),
  ProxyProvider2<AppApiService, HistoryDao, HistoryRepository>(
    update: (_, AppApiService appApiService, HistoryDao historyDao,
            HistoryRepository historyRepository) =>
        HistoryRepository(historyDao: historyDao),
  ),
  ProxyProvider2<AppApiService, GalleryDao, GalleryRepository>(
    update: (_, AppApiService appApiService, GalleryDao galleryDao,
            GalleryRepository galleryRepository) =>
        GalleryRepository(galleryDao: galleryDao, appApiService: appApiService),
  ),
  ProxyProvider<AppApiService, ContactUsRepository>(
    update: (_, AppApiService appApiService,
            ContactUsRepository apiStatusRepository) =>
        ContactUsRepository(appApiService: appApiService),
  ),
  ProxyProvider<AppApiService, TokenRepository>(
    update:
        (_, AppApiService appApiService, TokenRepository apiStatusRepository) =>
            TokenRepository(appApiService: appApiService),
  ),
  ProxyProvider2<AppApiService, BasketDao, BasketRepository>(
    update: (_, AppApiService appApiService, BasketDao basketDao,
            BasketRepository historyRepository) =>
        BasketRepository(basketDao: basketDao),
  ),
  ProxyProvider2<AppApiService, ShippingCountryDao, ShippingCountryRepository>(
    update: (_,
            AppApiService appApiService,
            ShippingCountryDao shippingCountryDao,
            ShippingCountryRepository shippingCountryRepository) =>
        ShippingCountryRepository(
            shippingCountryDao: shippingCountryDao,
            appApiService: appApiService),
  ),
  ProxyProvider2<AppApiService, ShippingCityDao, ShippingCityRepository>(
    update: (_, AppApiService appApiService, ShippingCityDao shippingCityDao,
            ShippingCityRepository shippingCityRepository) =>
        ShippingCityRepository(
            shippingCityDao: shippingCityDao, appApiService: appApiService),
  ),
  ProxyProvider<AppApiService, CouponDiscountRepository>(
    update: (_, AppApiService appApiService,
            CouponDiscountRepository couponDiscountRepository) =>
        CouponDiscountRepository(appApiService: appApiService),
  ),
];

List<SingleChildWidget> _valueProviders = <SingleChildWidget>[
  StreamProvider<AppValueHolder>(
    initialData: null,
    create: (BuildContext context) =>
        Provider.of<AppSharedPreferencess>(context, listen: false)
            .appValueHolder,
  )
];
