import 'package:ayo/pages/app/app.dart';
import 'package:ayo/pages/app/bloc/banner_cubit.dart';
import 'package:ayo/pages/app/bloc/navigation_cubit.dart';
import 'package:ayo/pages/app/bloc/query_cubit.dart';
import 'package:ayo/pages/filter/filter_page.dart';
import 'package:ayo/pages/intro/intro.dart';
import 'package:ayo/pages/main_category/main_category.dart';
import 'package:ayo/pages/order/order.dart';
import 'package:ayo/pages/slider/slider_intro.dart';
import 'package:ayo/pages/sorting/sorting_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

class RouteGenerator {
  final _queryCubit = QueryCubit();

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return PageTransition(
          child: Intro(),
          type: PageTransitionType.rightToLeft,
          settings: settings,
        );
        break;

      case '/slider_intro':
        return PageTransition(
          child: SliderIntro(
            intros: settings.arguments,
          ),
          type: PageTransitionType.rightToLeft,
          settings: settings,
        );
        break;

      case '/order':
        return PageTransition(
          child: Order(),
          type: PageTransitionType.rightToLeft,
          settings: settings,
        );
        break;

      case '/main_category':
        return PageTransition(
          child: MultiBlocProvider(
            providers: [
              BlocProvider<QueryCubit>(
                create: (context) => QueryCubit(),
              ),
              BlocProvider<BannerCubit>(
                create: (context) => BannerCubit(),
              ),
            ],
            child: MainCategory(
              categoryId: settings.arguments,
            ),
          ),
          type: PageTransitionType.rightToLeft,
          settings: settings,
        );
        break;

      case '/filter_page':
        return PageTransition(
          child: BlocProvider.value(
            value: _queryCubit,
            child: FilterPage(),
          ),
          type: PageTransitionType.downToUp,
          settings: settings,
        );
        break;

      case '/sorting_page':
        return PageTransition(
          child: BlocProvider.value(
            value: _queryCubit,
            child: SortingPage(),
          ),
          type: PageTransitionType.downToUp,
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
              BlocProvider<QueryCubit>(
                create: (context) => _queryCubit,
              ),
            ],
            child: App(),
          ),
          type: PageTransitionType.rightToLeft,
          settings: settings,
        );
    }
  }

  void dispose() {
    _queryCubit.close();
  }
}
