import 'package:ayo/bloc/product_cubit.dart';
import 'package:ayo/bloc/search/history_search_cubit.dart';
import 'package:ayo/bloc/search/popular_search_cubit.dart';
import 'package:ayo/bloc/search/search_cubit.dart';
import 'package:ayo/pages/app/app.dart';
import 'package:ayo/pages/app/bloc/banner_cubit.dart';
import 'package:ayo/pages/app/bloc/navigation_cubit.dart';
import 'package:ayo/pages/app/bloc/query_cubit.dart';
import 'package:ayo/pages/cart/cart_page.dart';
import 'package:ayo/pages/destination.dart';
import 'package:ayo/pages/intro/intro.dart';
import 'package:ayo/pages/main_category/bloc/sub_category_cubit.dart';
import 'package:ayo/pages/main_category/main_category.dart';
import 'package:ayo/pages/order/order.dart';
import 'package:ayo/pages/pengiriman/pengiriman.dart';
import 'package:ayo/pages/product_detail/product_detail.dart';
import 'package:ayo/pages/product_detail/product_detail_cubit.dart';
import 'package:ayo/pages/search/search_page.dart';
import 'package:ayo/pages/slider/slider_intro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

class RouteGenerator {
  final _duration = Duration(milliseconds: 200);
  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return PageTransition(
          child: Intro(),
          type: PageTransitionType.rightToLeft,
          duration: _duration,
          settings: settings,
        );
        break;

      case '/app':
        return PageTransition(
          child: MultiBlocProvider(
            providers: [
              BlocProvider<NavigationCubit>(
                create: (context) => NavigationCubit(),
              ),
            ],
            child: App(),
          ),
          type: PageTransitionType.rightToLeft,
          duration: _duration,
          settings: settings,
        );
        break;

      case '/slider_intro':
        return PageTransition(
          child: SliderIntro(
            intros: settings.arguments,
          ),
          type: PageTransitionType.rightToLeft,
          duration: _duration,
          settings: settings,
        );
        break;

      case '/order':
        return PageTransition(
          child: Order(),
          type: PageTransitionType.rightToLeft,
          duration: _duration,
          settings: settings,
        );
        break;

      case '/main_category':
        return PageTransition(
          child: MultiBlocProvider(
            providers: [
              BlocProvider<BannerCubit>(
                create: (context) => BannerCubit(),
              ),
              BlocProvider<QueryCubit>(
                create: (context) => QueryCubit(),
              ),
              BlocProvider<SubCategoryCubit>(
                create: (context) => SubCategoryCubit(),
              ),
              BlocProvider<ProductCubit>(
                create: (context) => ProductCubit(),
              ),
            ],
            child: MainCategory(
              categoryId: settings.arguments,
            ),
          ),
          type: PageTransitionType.rightToLeft,
          duration: _duration,
          settings: settings,
        );
        break;

      case '/product_detail':
        return PageTransition(
          child: MultiBlocProvider(
            providers: [
              BlocProvider<ProductDetailCubit>(
                create: (context) => ProductDetailCubit(),
              )
            ],
            child: ProductDetail(
              productId: settings.arguments,
            ),
          ),
          type: PageTransitionType.rightToLeft,
          duration: _duration,
          settings: settings,
        );
        break;

      case '/cart_page':
        return PageTransition(
          child: CartPage(),
          type: PageTransitionType.rightToLeft,
          duration: _duration,
          settings: settings,
        );
        break;

      case '/destination':
        return PageTransition(
          child: Destination(),
          type: PageTransitionType.rightToLeft,
          duration: _duration,
          settings: settings,
        );
        break;

      case '/pengiriman':
        return PageTransition(
          child: Pengiriman(),
          type: PageTransitionType.rightToLeft,
          duration: _duration,
          settings: settings,
        );
        break;

      case '/search':
        return PageTransition(
          child: MultiBlocProvider(
            providers: [
              BlocProvider<SearchCubit>(
                create: (context) => SearchCubit(),
              ),
              BlocProvider<PopularSearchCubit>(
                create: (context) => PopularSearchCubit(),
              ),
              BlocProvider<HistorySearchCubit>(
                create: (context) => HistorySearchCubit(),
              ),
            ],
            child: SearchPage(),
          ),
          type: PageTransitionType.rightToLeft,
          duration: _duration,
          settings: settings,
        );
        break;

      default:
        return PageTransition(
          child: MultiBlocProvider(
            providers: [
              BlocProvider<NavigationCubit>(
                create: (context) => NavigationCubit(),
              ),
            ],
            child: App(),
          ),
          type: PageTransitionType.rightToLeft,
          duration: _duration,
          settings: settings,
        );
    }
  }

  void dispose() {}
}
