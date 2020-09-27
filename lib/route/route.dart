import 'package:ayo/pages/app/app.dart';
import 'package:ayo/pages/intro/intro.dart';
import 'package:ayo/pages/main_category.dart';
import 'package:ayo/pages/order/order.dart';
import 'package:ayo/pages/slider/slider_intro.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
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
          child: MainCategory(
            categoryId: settings.arguments,
          ),
          type: PageTransitionType.rightToLeft,
          settings: settings,
        );
        break;

      default:
        return MaterialPageRoute(builder: (_) => App());
    }
  }
}
