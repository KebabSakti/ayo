import 'package:ayo/bloc/repository_cubit.dart';
import 'package:ayo/pages/app/bloc/banner_cubit.dart';
import 'package:ayo/pages/app/bloc/navigation_cubit.dart';
import 'package:ayo/pages/app/bloc/product_terlaris_kategori_cubit.dart';
import 'package:ayo/pages/app/bloc/scroll_position_cubit.dart';
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
    var repositoryCubit = context.bloc<RepositoryCubit>();

    void _initDynamicLinks() async {
      FirebaseDynamicLinks.instance.onLink(
          onSuccess: (PendingDynamicLinkData dynamicLink) async {
        final Uri deepLink = dynamicLink?.link;

        if (deepLink != null) {
          print('Deeplink path is asd : ${deepLink.path}');
          //Navigator.pushNamed(context, deepLink.path);
        }
      }, onError: (OnLinkErrorException e) async {
        print('onLinkError');
        print(e.message);
      });

      final PendingDynamicLinkData data =
          await FirebaseDynamicLinks.instance.getInitialLink();
      final Uri deepLink = data?.link;

      if (deepLink != null) {
        print('Deeplink path is asd : ${deepLink.path}');

        // Navigator.pushNamed(context, deepLink.path);
      }
    }

    _initDynamicLinks();

    return MultiBlocProvider(
      providers: [
        BlocProvider<NavigationCubit>(
          create: (context) => NavigationCubit(),
        ),
        BlocProvider<ScrollPositionCubit>(
          create: (context) => ScrollPositionCubit(),
        ),
        BlocProvider<BannerCubit>(
          create: (context) => BannerCubit(repositoryCubit.state.repository),
        ),
        BlocProvider<MainCategoryCubit>(
          create: (context) =>
              MainCategoryCubit(repositoryCubit.state.repository),
        ),
        BlocProvider<ProductTerlarisKategoriCubit>(
          create: (context) =>
              ProductTerlarisKategoriCubit(repositoryCubit.state.repository),
        ),
      ],
      child: Builder(
        builder: (context) => _app(context),
      ),
    );
  }
}

Widget _app(BuildContext context) {
  return ConnectionListener(
    child: BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.grey[100],
          body: Builder(
            builder: (context) {
              var pages = [
                Home(),
                Order(),
                Container(),
                Container(),
                User(),
              ];

              return pages[state.index];
            },
          ),
          bottomNavigationBar: BottomNavigationBar(
            onTap: (value) =>
                BlocProvider.of<NavigationCubit>(context).loadPage(value),
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            currentIndex: state.index,
            selectedItemColor: Colors.red,
            unselectedItemColor: Colors.grey[600],
            showUnselectedLabels: true,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.burn, size: 20,),
                title: Text('Home', style: TextStyle(fontSize: 12),),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.assignment, size: 20),
                title: Text('Order', style: TextStyle(fontSize: 12),),
              ),
              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.commentDots, size: 20),
                title: Text('Chat', style: TextStyle(fontSize: 12),),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications, size: 20),
                title: Text('Notifikasi', style: TextStyle(fontSize: 12),),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle, size: 20),
                title: Text('Akun', style: TextStyle(fontSize: 12),),
              ),
            ],
          ),
        );
      },
    ),
  );
}
