import 'package:dio/dio.dart';
import 'package:flutter_restaurant/common/providers/data_sync_provider.dart';
import 'package:flutter_restaurant/common/reposotories/data_sync_repo.dart';
import 'package:flutter_restaurant/common/reposotories/news_letter_repo.dart';
import 'package:flutter_restaurant/common/reposotories/product_repo.dart';
import 'package:flutter_restaurant/features/auth/domain/reposotories/auth_repo.dart';
import 'package:flutter_restaurant/features/cart/providers/frequently_bought_provider.dart';
import 'package:flutter_restaurant/features/checkout/providers/checkout_provider.dart';
import 'package:flutter_restaurant/features/home/domain/reposotories/banner_repo.dart';
import 'package:flutter_restaurant/features/cart/domain/reposotories/cart_repo.dart';
import 'package:flutter_restaurant/features/category/domain/reposotories/category_repo.dart';
import 'package:flutter_restaurant/features/chat/domain/reposotories/chat_repo.dart';
import 'package:flutter_restaurant/features/coupon/domain/reposotories/coupon_repo.dart';
import 'package:flutter_restaurant/features/address/domain/reposotories/location_repo.dart';
import 'package:flutter_restaurant/features/home/providers/sorting_provider.dart';
import 'package:flutter_restaurant/features/notification/domain/reposotories/notification_repo.dart';
import 'package:flutter_restaurant/features/order/domain/reposotories/order_repo.dart';
import 'package:flutter_restaurant/features/language/domain/reposotories/language_repo.dart';
import 'package:flutter_restaurant/features/onboarding/domain/reposotories/onboarding_repo.dart';
import 'package:flutter_restaurant/features/order_track/domain/repositories/time_repo.dart';
import 'package:flutter_restaurant/features/search/domain/reposotories/search_repo.dart';
import 'package:flutter_restaurant/features/setmenu/domain/reposotories/set_menu_repo.dart';
import 'package:flutter_restaurant/features/profile/domain/reposotories/profile_repo.dart';
import 'package:flutter_restaurant/features/splash/domain/reposotories/splash_repo.dart';
import 'package:flutter_restaurant/features/wallet/domain/reposotories/wallet_repo.dart';
import 'package:flutter_restaurant/features/wishlist/domain/reposotories/wishlist_repo.dart';
import 'package:flutter_restaurant/features/auth/providers/auth_provider.dart';
import 'package:flutter_restaurant/features/home/providers/banner_provider.dart';
import 'package:flutter_restaurant/features/branch/providers/branch_provider.dart';
import 'package:flutter_restaurant/features/cart/providers/cart_provider.dart';
import 'package:flutter_restaurant/features/category/providers/category_provider.dart';
import 'package:flutter_restaurant/features/chat/providers/chat_provider.dart';
import 'package:flutter_restaurant/features/coupon/providers/coupon_provider.dart';
import 'package:flutter_restaurant/features/language/providers/localization_provider.dart';
import 'package:flutter_restaurant/common/providers/news_letter_provider.dart';
import 'package:flutter_restaurant/features/notification/providers/notification_provider.dart';
import 'package:flutter_restaurant/features/order/providers/order_provider.dart';
import 'package:flutter_restaurant/features/address/providers/location_provider.dart';
import 'package:flutter_restaurant/common/providers/product_provider.dart';
import 'package:flutter_restaurant/features/language/providers/language_provider.dart';
import 'package:flutter_restaurant/features/onboarding/providers/onboarding_provider.dart';
import 'package:flutter_restaurant/features/rate_review/providers/review_provider.dart';
import 'package:flutter_restaurant/features/search/providers/search_provider.dart';
import 'package:flutter_restaurant/features/setmenu/providers/set_menu_provider.dart';
import 'package:flutter_restaurant/features/profile/providers/profile_provider.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/common/providers/theme_provider.dart';
import 'package:flutter_restaurant/features/order_track/providers/tracker_provider.dart';
import 'package:flutter_restaurant/features/wallet/providers/wallet_provider.dart';
import 'package:flutter_restaurant/features/wishlist/providers/wishlist_provider.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/datasource/remote/dio/dio_client.dart';
import 'data/datasource/remote/dio/logging_interceptor.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton(() => DioClient(AppConstants.baseUrl, sl(), loggingInterceptor: sl(), sharedPreferences: sl()));

  // Repository
  sl.registerLazySingleton(() => DataSyncRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => SplashRepo(sharedPreferences: sl(), dioClient: sl()));
  sl.registerLazySingleton(() => CategoryRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => BannerRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => ProductRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => LanguageRepo());
  sl.registerLazySingleton(() => OnBoardingRepo(dioClient: sl()));
  sl.registerLazySingleton(() => CartRepo(sharedPreferences: sl()));
  sl.registerLazySingleton(() => OrderRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => TrackerRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => ChatRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => AuthRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => LocationRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => SetMenuRepo(dioClient: sl()));
  sl.registerLazySingleton(() => ProfileRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => SearchRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => NotificationRepo(dioClient: sl()));
  sl.registerLazySingleton(() => CouponRepo(dioClient: sl()));
  sl.registerLazySingleton(() => WishListRepo(dioClient: sl()));
  sl.registerLazySingleton(() => NewsLetterRepo(dioClient: sl()));
  sl.registerLazySingleton(() => WalletRepo(dioClient: sl(), sharedPreferences: sl()));

  // Provider
  sl.registerLazySingleton(() => DataSyncProvider());
  sl.registerLazySingleton(() => ThemeProvider(sharedPreferences: sl()));
  sl.registerLazySingleton(() => SplashProvider(splashRepo: sl()));
  sl.registerLazySingleton(() => LocalizationProvider(sharedPreferences: sl(), dioClient: sl()));
  sl.registerLazySingleton(() => LanguageProvider(languageRepo: sl()));
  sl.registerLazySingleton(() => OnBoardingProvider(onboardingRepo: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => CategoryProvider(categoryRepo: sl()));
  sl.registerLazySingleton(() => BannerProvider(bannerRepo: sl()));
  sl.registerLazySingleton(() => ProductProvider(productRepo: sl()));
  sl.registerLazySingleton(() => CartProvider(cartRepo: sl()));
  sl.registerLazySingleton(() => OrderProvider(orderRepo: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => ChatProvider(chatRepo: sl(), notificationRepo: sl()));
  sl.registerLazySingleton(() => AuthProvider(authRepo: sl()));
  sl.registerLazySingleton(() => LocationProvider(sharedPreferences: sl(), locationRepo: sl()));
  sl.registerLazySingleton(() => ProfileProvider(profileRepo: sl()));
  sl.registerLazySingleton(() => NotificationProvider(notificationRepo: sl()));
  sl.registerLazySingleton(() => SetMenuProvider(setMenuRepo: sl()));
  sl.registerLazySingleton(() => WishListProvider(wishListRepo: sl()));
  sl.registerLazySingleton(() => CouponProvider(couponRepo: sl()));
  sl.registerLazySingleton(() => SearchProvider(searchRepo: sl()));
  sl.registerLazySingleton(() => NewsLetterProvider(newsLetterRepo: sl()));
  sl.registerLazySingleton(() => TrackerProvider(timeRepo: sl()));
  sl.registerLazySingleton(() => WalletProvider(walletRepo: sl()));
  sl.registerLazySingleton(() => BranchProvider(splashRepo: sl()));
  sl.registerLazySingleton(() => ReviewProvider(productRepo: sl()));
  sl.registerLazySingleton(() => ProductSortProvider());
  sl.registerLazySingleton(() => CheckoutProvider(orderRepo: sl()));
  sl.registerLazySingleton(() => FrequentlyBoughtProvider(productRepo: sl()));


  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => LoggingInterceptor());
}
