import 'package:ayo/bloc/theme_cubit.dart';
import 'package:ayo/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Order extends StatefulWidget {
  @override
  _OrderState createState() => _OrderState();
}

class _OrderState extends State<Order> {
  @override
  Widget build(BuildContext context) {
    context.bloc<ThemeCubit>().loadTheme(appThemeData[AppTheme.sayur]);

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: Text('Order'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      ],
    );
  }
}
