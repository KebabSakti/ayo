import 'package:ayo/bloc/connection_cubit.dart' as connCubit;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ConnectionListener extends StatelessWidget {
  final Widget child;

  ConnectionListener({Key key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<connCubit.ConnectionCubit, connCubit.ConnectionState>(
      listenWhen: (previous, current) {
        if (previous is connCubit.ConnectionOffline) {
          Navigator.of(context).pop();
        }
        return true;
      },
      listener: (context, state) {
        if (state is connCubit.ConnectionOffline) {
          showModalBottomSheet(
            enableDrag: false,
            isDismissible: false,
            context: context,
            builder: (context) {
              return WillPopScope(
                onWillPop: () async {
                  return false;
                },
                child: Container(
                  height: 275,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 150,
                        height: 150,
                        child: SvgPicture.asset('assets/images/no_network.svg'),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Text(
                          'Wah, internet kamu lagi ngambek, segera cek koneksi internet kamu',
                          // style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
      child: child,
    );
  }
}
