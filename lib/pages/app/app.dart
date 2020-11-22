import 'package:ayo/bloc/product_cubit.dart';
import 'package:ayo/pages/app/bloc/banner_cubit.dart';
import 'package:ayo/pages/app/bloc/navigation_cubit.dart';
import 'package:ayo/pages/app/bloc/product_terlaris_home_cubit.dart';
import 'package:ayo/pages/app/bloc/query_cubit.dart';
import 'package:ayo/pages/home/bloc/main_category_cubit.dart';
import 'package:ayo/pages/home/home.dart';
import 'package:ayo/pages/order/order.dart';
import 'package:ayo/pages/user/user.dart';
import 'package:ayo/widget/connection_listener.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final PageController _pageController = PageController();
    void _initDynamicLinks() async {
      FirebaseDynamicLinks.instance.onLink(onSuccess: (PendingDynamicLinkData dynamicLink) async {
        final Uri deepLink = dynamicLink?.link;

        if (deepLink != null) {
          print('Deeplink path is asd : ${deepLink.path}');
          //Navigator.pushNamed(context, deepLink.path);
        }
      }, onError: (OnLinkErrorException e) async {
        print('onLinkError');
        print(e.message);
      });

      final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();
      final Uri deepLink = data?.link;

      if (deepLink != null) {
        print('Deeplink path is asd : ${deepLink.path}');

        // Navigator.pushNamed(context, deepLink.path);
      }
    }

    _initDynamicLinks();

    return WillPopScope(
      onWillPop: () async {
        return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: Text('Keluar dari aplikasi?'),
            actions: <Widget>[
              FlatButton(
                child: Text('Tidak'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                child: Text('Ya'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          ),
        );
      },
      child: ConnectionListener(
        child: BlocConsumer<NavigationCubit, NavigationState>(
          listener: (context, state) {
            _pageController.jumpToPage(state.index);
          },
          builder: (context, state) {
            return Scaffold(
              backgroundColor: Colors.white,
              body: PageView(
                controller: _pageController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  MultiBlocProvider(
                    providers: [
                      BlocProvider<BannerCubit>(
                        create: (context) => BannerCubit(),
                      ),
                      BlocProvider<MainCategoryCubit>(
                        create: (context) => MainCategoryCubit(),
                      ),
                      BlocProvider<ProductCubit>(
                        create: (context) => ProductCubit(),
                      ),
                      BlocProvider<ProductTerlarisHomeCubit>(
                        create: (context) => ProductTerlarisHomeCubit(),
                      ),
                      BlocProvider<QueryCubit>(
                        create: (context) => QueryCubit(),
                      ),
                    ],
                    child: Home(),
                  ),
                  Order(),
                  Container(),
                  Container(),
                  User(),
                ],
              ),
              bottomNavigationBar: BottomNavigationBar(
                onTap: (value) => BlocProvider.of<NavigationCubit>(context).loadPage(value),
                backgroundColor: Colors.white,
                type: BottomNavigationBarType.fixed,
                currentIndex: state.index,
                selectedItemColor: Theme.of(context).primaryColor,
                unselectedItemColor: Colors.grey[600],
                showUnselectedLabels: true,
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: FaIcon(
                      FontAwesomeIcons.burn,
                      size: 20,
                    ),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.assignment, size: 20),
                    label: 'Order',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(FontAwesomeIcons.commentDots, size: 20),
                    label: 'Chat',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.notifications, size: 20),
                    label: 'Notifikasi',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.account_circle, size: 20),
                    label: 'Akun',
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
