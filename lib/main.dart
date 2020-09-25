import 'package:ayo/bloc/authentication_cubit.dart';
import 'package:ayo/bloc/connection_cubit.dart';
import 'package:ayo/bloc/repository_cubit.dart';
import 'package:ayo/bloc/theme_cubit.dart';
import 'package:ayo/bloc/theme_state.dart';
import 'package:ayo/dependency/dependency.dart';
import 'package:ayo/moor/db.dart';
import 'package:ayo/repository/repository.dart';
import 'package:ayo/route/route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';

void main() {
  final DB db = DB();
  final Location location = Location();
  final Dio dio = Dio(new BaseOptions(
    baseUrl: 'https://7119d8be4638.ngrok.io/api/',
    connectTimeout: 30000,
    receiveTimeout: 30000,
  ));
  dio.interceptors.add(LogInterceptor(responseBody: false));

  final Dependency dependency =
      Dependency(db: db, dio: dio, location: location);

  final Repository repository = Repository(dependency);

  runApp(MyApp(repository: repository));
}

class MyApp extends StatelessWidget {
  final Repository repository;

  const MyApp({Key key, @required this.repository}) : super(key: key);

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
          create: (context) => AuthenticationCubit(repository),
        ),
        BlocProvider<RepositoryCubit>(
          create: (context) => RepositoryCubit(repository),
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

    connectionCubit = context.bloc<ConnectionCubit>();
    //start connection listener
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
      theme: widget.theme,
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
