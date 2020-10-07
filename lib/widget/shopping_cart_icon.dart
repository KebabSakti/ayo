import 'package:ayo/bloc/authentication_cubit.dart';
import 'package:ayo/bloc/cart_cubit.dart';
import 'package:ayo/widget/shopping_cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ShoppingCartIcon extends StatefulWidget {
  @override
  _ShoppingCartIconState createState() => _ShoppingCartIconState();
}

class _ShoppingCartIconState extends State<ShoppingCartIcon> {
  AuthenticationCubit _authenticationCubit;
  CartCubit _cartCubit;

  void _fetchData() {
    if (_cartCubit.state is CartInitial)
      _cartCubit.fetchCart(user: _authenticationCubit.state.userData);
  }

  @override
  void initState() {
    _authenticationCubit = context.bloc<AuthenticationCubit>();
    _cartCubit = context.bloc<CartCubit>();

    //fetch
    _fetchData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartCubit, CartState>(
      listener: (context, state) {
        print(state);
        if (state is CartError) {
          _fetchData();
        }
      },
      builder: (context, state) {
        int _cartItemTotal =
            state.carts.fold(0, (value, element) => value + element.qty);
        return Stack(
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
            (state is CartComplete)
                ? Positioned(
                    left: 15,
                    top: 8,
                    child: ShoppingCart(
                      animate: (_cartItemTotal > 0) ? true : false,
                      total: _cartItemTotal,
                    ),
                  )
                : SizedBox.shrink(),
          ],
        );
      },
    );
  }
}
