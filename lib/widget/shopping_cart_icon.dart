import 'package:ayo/bloc/authentication_cubit.dart';
import 'package:ayo/bloc/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sa_stateless_animation/sa_stateless_animation.dart';
import 'package:supercharged/supercharged.dart';

class ShoppingCartIcon extends StatefulWidget {
  @override
  _ShoppingCartIconState createState() => _ShoppingCartIconState();
}

class _ShoppingCartIconState extends State<ShoppingCartIcon> {
  AuthenticationCubit _authenticationCubit;
  CartCubit _cartCubit;

  void _fetchData() {
    if (_cartCubit.state is CartInitial) _cartCubit.fetchCart(user: _authenticationCubit.state.userData);
  }

  @override
  void initState() {
    _authenticationCubit = context.bloc<AuthenticationCubit>();
    _cartCubit = context.bloc<CartCubit>();

    _fetchData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CartCubit, CartState>(
      listener: (context, state) {
        if (state is CartError) {
          _fetchData();
        }
      },
      child: Stack(
        alignment: Alignment.center,
        overflow: Overflow.visible,
        children: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/cart_page');
            },
            splashRadius: 20,
            splashColor: Theme.of(context).accentColor.withOpacity(0.3),
            padding: EdgeInsets.only(right: 15),
            icon: Icon(
              FontAwesomeIcons.shoppingBasket,
              color: Colors.white,
              size: 20,
            ),
          ),
          BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              int _cartItemTotal = state.carts.fold(0, (value, element) => value + element.qty);
              return Positioned(
                left: 15,
                top: 8,
                child: CustomAnimation<double>(
                  control: (state is CartComplete)
                      ? (state.carts.length > 0)
                          ? CustomAnimationControl.PLAY
                          : CustomAnimationControl.PLAY_REVERSE
                      : CustomAnimationControl.PLAY_REVERSE,
                  curve: Curves.elasticInOut,
                  duration: 500.milliseconds,
                  tween: 0.0.tweenTo(1.0), // <-- d
                  child: Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 1.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: CircleAvatar(
                      backgroundColor: Colors.red,
                      child: Text(
                        (_cartItemTotal <= 99) ? _cartItemTotal.toString() : '99+',
                        style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ), // efine tween of colors
                  builder: (context, child, value) {
                    return Transform.scale(
                      scale: value,
                      child: child,
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
