import 'package:ayo/bloc/authentication_cubit.dart';
import 'package:ayo/bloc/cart_cubit.dart';
import 'package:ayo/model/cart/cart.dart';
import 'package:ayo/util/helper.dart';
import 'package:ayo/widget/scroll_top.dart';
import 'package:ayo/widget/shimmer/box_radius_shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  ScrollController _scrollController = ScrollController();

  AuthenticationCubit _authenticationCubit;
  CartCubit _cartCubit;

  List<Cart> carts = [];

  void _mainScrollListener() {}

  void _allCheckListener(bool status) {
    print(status);
  }

  Future _fetchData() async {
    _cartCubit.fetchCart(user: _authenticationCubit.state.userData);
  }

  @override
  void initState() {
    _scrollController.addListener(_mainScrollListener);

    _authenticationCubit = context.bloc<AuthenticationCubit>();
    _cartCubit = context.bloc<CartCubit>();

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartCubit, CartState>(listener: (context, state) {
      if (state is CartComplete) {
        setState(() {
          carts = state.carts;
        });
      }
    }, builder: (context, state) {
      return RefreshIndicator(
        onRefresh: _fetchData,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverAppBar(
                    titleSpacing: 0,
                    pinned: true,
                    title: Text(
                      'Keranjang',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 56,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return (state is CartComplete)
                            ? CartItem(
                                index: index,
                                cart: carts[index],
                              )
                            : _cartItemShimmer(index);
                      },
                      childCount: state.carts.length ?? 4,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      height: 1000,
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.topCenter,
                child: SafeArea(
                  child: CartChecker(
                    scrollController: _scrollController,
                    total: state.carts.length ?? 0,
                    allCheckListener: _allCheckListener,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10, right: 15),
                  child: ScrollTop(
                    scrollController: _scrollController,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class CartChecker extends StatefulWidget {
  final ScrollController scrollController;
  final int total;
  final ValueChanged<bool> allCheckListener;

  CartChecker(
      {@required this.scrollController,
      @required this.total,
      @required this.allCheckListener});

  @override
  _CartCheckerState createState() => _CartCheckerState();
}

class _CartCheckerState extends State<CartChecker> {
  bool show = true;
  bool semua = true;

  void _toggleSemua() {
    setState(() {
      semua = !semua;
      widget.allCheckListener(semua);
    });
  }

  void _scrollListener() {
    var limit = 190 * widget.total;
    setState(() {
      show = widget.scrollController.position.pixels > limit ? false : true;
    });
  }

  @override
  void initState() {
    widget.scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return show
        ? Container(
            height: 56,
            padding: EdgeInsets.only(left: 5, right: 5),
            margin: EdgeInsets.only(top: 56),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey[100],
                  width: 5,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      onChanged: (value) {
                        _toggleSemua();
                      },
                      value: semua,
                      activeColor: Theme.of(context).primaryColor,
                    ),
                    Text(
                      'Pilih Semua',
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                FlatButton(
                  onPressed: () {},
                  splashColor: Theme.of(context).accentColor.withOpacity(0.3),
                  child: Text(
                    'Hapus',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
              ],
            ),
          )
        : SizedBox.shrink();
  }
}

class CartItem extends StatefulWidget {
  final int index;
  final Cart cart;

  CartItem({@required this.index, @required this.cart});

  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    _textEditingController.text = widget.cart.qty.toString();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _product = widget.cart.product;
    var _cart = widget.cart;
    return Container(
      height: 190,
      padding: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: Colors.grey[100], width: widget.index != 10 ? 1 : 0))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  onChanged: (value) {},
                  value: true,
                  activeColor: Theme.of(context).primaryColor,
                ),
                Container(
                  width: 60,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: CachedNetworkImage(
                      imageUrl: _product.cover,
                      placeholder: (context, url) =>
                          boxRadiusShimmer(radius: 5),
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed('/product_detail',
                              arguments: _product.productId);
                        },
                        child: Text(
                          '${_product.name}',
                          textAlign: TextAlign.left,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '${Helper().getFormattedNumber(_cart.price)} / ${_product.unit.unit}',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: (_product.deliveryType.instant == 1)
                                ? Theme.of(context).colorScheme.secondary
                                : Theme.of(context)
                                    .colorScheme
                                    .secondaryVariant,
                          ),
                        ),
                        child: Text(
                          (_product.deliveryType.instant == 1)
                              ? 'Pengiriman Instan'
                              : 'Dikirim Besok 10:00 - 15:00',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: (_product.deliveryType.instant == 1)
                                ? Theme.of(context).colorScheme.secondary
                                : Theme.of(context)
                                    .colorScheme
                                    .secondaryVariant,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          SizedBox(
                            width: 30,
                            child: IconButton(
                              onPressed: () {},
                              padding: EdgeInsets.zero,
                              icon: Icon(
                                Icons.remove_circle,
                                color: Colors.grey,
                                size: 30,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 50,
                            child: TextField(
                              controller: _textEditingController,
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontWeight: FontWeight.w600,
                              ),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(4),
                              ],
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              textAlignVertical: TextAlignVertical.center,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 30,
                            child: IconButton(
                              onPressed: () {},
                              padding: EdgeInsets.zero,
                              icon: Icon(
                                Icons.add_circle,
                                color: Theme.of(context).colorScheme.secondary,
                                size: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 10,
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.delete,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _cartItemShimmer(int index) {
  return Container(
    height: 160,
    padding: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
    decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(
                color: Colors.grey[100], width: index != 10 ? 1 : 0))),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                child: boxRadiusShimmer(width: 20, height: 20, radius: 0),
              ),
              Container(
                width: 60,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: boxRadiusShimmer(radius: 5),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        boxRadiusShimmer(
                          width: 150,
                          height: 10,
                          radius: 4,
                        ),
                        SizedBox(height: 2),
                        boxRadiusShimmer(
                          width: 100,
                          height: 10,
                          radius: 4,
                        ),
                        SizedBox(height: 2),
                        boxRadiusShimmer(
                          width: 50,
                          height: 10,
                          radius: 4,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    boxRadiusShimmer(
                      width: 80,
                      height: 10,
                      radius: 4,
                    ),
                    SizedBox(height: 10),
                    boxRadiusShimmer(width: 120, height: 20, radius: 4),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        boxRadiusShimmer(
                          width: 30,
                          height: 30,
                          radius: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 4,
                            right: 4,
                          ),
                          child: boxRadiusShimmer(
                            width: 50,
                            height: 30,
                            radius: 4,
                          ),
                        ),
                        boxRadiusShimmer(
                          width: 30,
                          height: 30,
                          radius: 15,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: boxRadiusShimmer(
            width: 25,
            height: 25,
            radius: 22,
          ),
        ),
      ],
    ),
  );
}
