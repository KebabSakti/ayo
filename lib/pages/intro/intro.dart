import 'package:ayo/pages/intro/bloc/intro_cubit.dart';
import 'package:ayo/widget/connection_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Intro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<IntroCubit>(
      create: (context) => IntroCubit(),
      child: Builder(
        builder: (context) => _intro(context),
      ),
    );
  }
}

Widget _intro(BuildContext context) {
  var introCubit = context.bloc<IntroCubit>();

  //get session token and download intro image
  introCubit.initIntro(context);

  return Scaffold(
    body: ConnectionListener(
      child: MultiBlocListener(
        listeners: [
          BlocListener<IntroCubit, IntroState>(
            listener: (context, state) {
              if (state is IntroDataDownloaded) {
                if (state.intros.length > 0) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/slider_intro',
                    (Route<dynamic> route) => false,
                    arguments: state.intros,
                  );
                } else {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/app', (Route<dynamic> route) => false);
                }
              }
            },
          ),
        ],
        child: Container(
          padding: EdgeInsets.only(top: 50, bottom: 50, left: 30, right: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: SvgPicture.asset('assets/images/shop.svg'),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Belanja cepat, aman, lengkap semua ada di genggaman tangan kamu',
                    // style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              BlocBuilder<IntroCubit, IntroState>(
                builder: (context, state) {
                  if (state is IntroDataError) {
                    return Column(
                      children: [
                        Icon(
                          Icons.cloud_off,
                          color: Colors.red,
                          size: 40,
                        ),
                        Text(
                          'Gagal terhubung',
                          style: TextStyle(fontSize: 10),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.refresh,
                            color: Colors.grey[600],
                          ),
                          onPressed: () {
                            introCubit.initIntro(context);
                          },
                        ),
                      ],
                    );
                  }

                  return Column(
                    children: [
                      SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          backgroundColor: Colors.grey[100],
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Menghubungkan',
                        style: TextStyle(fontSize: 10),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
