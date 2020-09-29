import 'package:ayo/bloc/authentication_cubit.dart';
import 'package:ayo/bloc/connection_cubit.dart';
import 'package:ayo/bloc/scroll_show_cubit.dart';
import 'package:ayo/bloc/theme_cubit.dart';
import 'package:ayo/bloc/theme_state.dart';
import 'package:ayo/pages/app/bloc/banner_cubit.dart';
import 'package:ayo/pages/app/bloc/query_cubit.dart';
import 'package:ayo/provider/provider.dart';
import 'package:ayo/route/route.dart';
import 'package:ayo/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  //init service locator
  serviceLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (context) => ThemeCubit(),
        ),
        BlocProvider<ConnectionCubit>(
          create: (context) => ConnectionCubit(),
        ),
        BlocProvider<AuthenticationCubit>(
          create: (context) => AuthenticationCubit(),
        ),
        BlocProvider<BannerCubit>(
          create: (context) => BannerCubit(),
        ),
        BlocProvider<QueryCubit>(
          create: (context) => QueryCubit(),
        ),
        BlocProvider<ScrollShowCubit>(
          create: (context) => ScrollShowCubit(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) => MainBaseApp(theme: state.themeData),
      ),
    );
  }
}

class MainBaseApp extends StatefulWidget {
  final ThemeData theme;

  MainBaseApp({Key key, @required this.theme}) : super(key: key);

  @override
  _MainBaseAppState createState() => _MainBaseAppState();
}

class _MainBaseAppState extends State<MainBaseApp> with WidgetsBindingObserver {
  ConnectionCubit connectionCubit;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    //start connection listener
    connectionCubit = context.bloc<ConnectionCubit>();
    connectionCubit.connectionListener();

    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    connectionCubit.closeConnectionListener();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      connectionCubit.connectionListener();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Segala kebutuhan kamu dalam satu aplikasi',
      debugShowCheckedModeBanner: false,
      theme: appThemeData[AppTheme.base],
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
