import 'package:ayo/bloc/authentication_cubit.dart';
import 'package:ayo/bloc/cart_cubit.dart';
import 'package:ayo/model/cart/cart.dart';
import 'package:ayo/pages/product_detail/product_detail_cubit.dart';
import 'package:ayo/util/dialog.dart';
import 'package:ayo/util/helper.dart';
import 'package:ayo/widget/scroll_top.dart';
import 'package:ayo/widget/search_bar.dart';
import 'package:ayo/widget/shimmer/box_radius_shimmer.dart';
import 'package:ayo/widget/shopping_cart_icon.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProductDetail extends StatefulWidget {
  final String productId;

  ProductDetail({@required this.productId});

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  ScrollController _scrollController = ScrollController();

  AuthenticationCubit _authenticationCubit;
  ProductDetailCubit _productDetailCubit;
  CartCubit _cartCubit;

  void _addToCart(Cart cart) {
    _cartCubit.addCart(user: _authenticationCubit.state.userData, cartData: cart);
  }

  void _fetchProductDetail() {
    _productDetailCubit.fetchProductDetail(
      userData: _authenticationCubit.state.userData,
      productId: widget.productId,
    );
  }

  void _fetchData() {
    _fetchProductDetail();
  }

  Future _refreshData() async {
    _fetchData();
  }

  @override
  void initState() {
    _authenticationCubit = context.bloc<AuthenticationCubit>();
    _productDetailCubit = context.bloc<ProductDetailCubit>();
    _cartCubit = context.bloc<CartCubit>();

    _fetchData();

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CartCubit, CartState>(
      listener: (context, state) {
        if (state is CartComplete) {
          if (myProgressDialog(context).isShowing())
            myProgressDialog(context).hide().whenComplete(() => print('Produk berhasil di tambahkan'));
        }

        if (state is CartError) {
          if (myProgressDialog(context).isShowing())
            myProgressDialog(context).hide().whenComplete(() => print('Gagal menambahkan data'));
        }
      },
      child: RefreshIndicator(
        onRefresh: _refreshData,
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
                    actions: [
                      SizedBox(
                        width: 15,
                      ),
                      ShoppingCartIcon(),
                    ],
                    title: SearchBar(
                      scrollController: _scrollController,
                    ),
                  ),
                  BlocConsumer<ProductDetailCubit, ProductDetailState>(
                    listener: (context, state) {
                      print(state);
                    },
                    builder: (context, state) {
                      return SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            Container(
                              height: 250,
                              child: Builder(
                                builder: (context) {
                                  if (state is ProductDetailCompleted) {
                                    return CachedNetworkImage(
                                      imageUrl: state.product.cover,
                                      height: double.infinity,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => boxRadiusShimmer(radius: 0),
                                    );
                                  }

                                  return boxRadiusShimmer(radius: 0);
                                },
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      (state is ProductDetailCompleted)
                                          ? Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      (state.product.discount != null)
                                                          ? Helper().getFormattedNumber(
                                                              Helper().getDiscountedPrice(
                                                                state.product.discount.amount,
                                                                state.product.price,
                                                              ),
                                                            )
                                                          : Helper().getFormattedNumber(
                                                              state.product.price,
                                                            ),
                                                      style: TextStyle(
                                                        color: Colors.grey[800],
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      ' / ${state.product.unit.unit}',
                                                      style: TextStyle(
                                                        color: Colors.grey[800],
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 4,
                                                ),
                                                (state.product.discount != null)
                                                    ? Row(
                                                        children: [
                                                          Container(
                                                            padding: EdgeInsets.only(
                                                              left: 6,
                                                              right: 6,
                                                              top: 4,
                                                              bottom: 4,
                                                            ),
                                                            decoration: BoxDecoration(
                                                              color: Colors.amberAccent,
                                                              borderRadius: BorderRadius.circular(4),
                                                            ),
                                                            child: Text(
                                                              '${Helper().getFormattedNumber(state.product.discount.amount, name: '')}% OFF',
                                                              style: TextStyle(
                                                                color: Theme.of(context).primaryColor,
                                                                fontSize: 10,
                                                                fontWeight: FontWeight.w600,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 6,
                                                          ),
                                                          Text(
                                                            '${Helper().getFormattedNumber(state.product.price)}',
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.w600,
                                                              color: Colors.grey[400],
                                                              decoration: TextDecoration.lineThrough,
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : SizedBox.shrink(),
                                                (state.product.discount != null)
                                                    ? SizedBox(
                                                        height: 10,
                                                      )
                                                    : SizedBox.shrink(),
                                              ],
                                            )
                                          : boxRadiusShimmer(
                                              width: 100,
                                              height: 20,
                                              radius: 6,
                                            ),
                                      (state is ProductDetailCompleted)
                                          ? IconButton(
                                              onPressed: () {},
                                              icon: Icon(
                                                FontAwesomeIcons.solidHeart,
                                                color: state.product.favourite != null
                                                    ? Theme.of(context).primaryColor
                                                    : Colors.grey,
                                              ),
                                            )
                                          : Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: boxRadiusShimmer(
                                                width: 30,
                                                height: 30,
                                                radius: 15,
                                              ),
                                            ),
                                    ],
                                  ),
                                  (state is ProductDetailCompleted)
                                      ? Text(
                                          state.product.name,
                                          style: TextStyle(
                                            color: Colors.grey[800],
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        )
                                      : boxRadiusShimmer(
                                          width: 250,
                                          height: 20,
                                          radius: 6,
                                        ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      (state is ProductDetailCompleted)
                                          ? Container(
                                              padding: EdgeInsets.only(
                                                right: 10,
                                              ),
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  right: BorderSide(
                                                    color: Colors.grey[200],
                                                  ),
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.star,
                                                    color: (state.product.ratingWeight != null)
                                                        ? Colors.amberAccent
                                                        : Colors.grey[400],
                                                    size: 20,
                                                  ),
                                                  SizedBox(
                                                    width: 4,
                                                  ),
                                                  Text(
                                                    (state.product.ratingWeight != null)
                                                        ? state.product.ratingWeight.rating.toString()
                                                        : '0',
                                                    style: TextStyle(
                                                      color: Colors.grey[800],
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 4,
                                                  ),
                                                  Text(
                                                    (state.product.ratingWeight != null)
                                                        ? '(${state.product.ratingWeight.totalVote})'
                                                        : '(0)',
                                                    style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : boxRadiusShimmer(
                                              width: 100,
                                              height: 20,
                                              radius: 6,
                                            ),
                                      (state is ProductDetailCompleted)
                                          ? Container(
                                              padding: EdgeInsets.only(
                                                left: 10,
                                                right: 10,
                                              ),
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  right: BorderSide(
                                                    color: Colors.grey[200],
                                                  ),
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'Dilihat',
                                                    style: TextStyle(
                                                      color: Colors.grey[800],
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 4,
                                                  ),
                                                  Text(
                                                    (state.product.viewer != null)
                                                        ? state.product.viewer.view.toString()
                                                        : '0',
                                                    style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Padding(
                                              padding: const EdgeInsets.only(left: 6),
                                              child: boxRadiusShimmer(
                                                width: 100,
                                                height: 20,
                                                radius: 6,
                                              ),
                                            ),
                                      (state is ProductDetailCompleted)
                                          ? Container(
                                              padding: EdgeInsets.only(
                                                left: 10,
                                                right: 10,
                                              ),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'Terjual',
                                                    style: TextStyle(
                                                      color: Colors.grey[800],
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 4,
                                                  ),
                                                  Text(
                                                    (state.product.productSale != null)
                                                        ? state.product.productSale.qtyTotal.toString()
                                                        : '0',
                                                    style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Padding(
                                              padding: const EdgeInsets.only(left: 6),
                                              child: boxRadiusShimmer(
                                                width: 100,
                                                height: 20,
                                                radius: 6,
                                              ),
                                            ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 10,
                              color: Colors.grey[100],
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                left: 10,
                                right: 10,
                                top: 15,
                                bottom: 15,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  (state is ProductDetailCompleted)
                                      ? Text(
                                          'Deskripsi Produk',
                                          style: TextStyle(
                                            color: Colors.grey[800],
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      : boxRadiusShimmer(
                                          width: 150,
                                          height: 20,
                                          radius: 6,
                                        ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  (state is ProductDetailCompleted)
                                      ? Text(
                                          state.product.caption,
                                          textAlign: TextAlign.justify,
                                        )
                                      : Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            boxRadiusShimmer(
                                              width: double.infinity,
                                              height: 10,
                                              radius: 6,
                                            ),
                                            SizedBox(
                                              height: 6,
                                            ),
                                            boxRadiusShimmer(
                                              width: double.infinity,
                                              height: 10,
                                              radius: 6,
                                            ),
                                            SizedBox(
                                              height: 6,
                                            ),
                                            boxRadiusShimmer(
                                              width: double.infinity,
                                              height: 10,
                                              radius: 6,
                                            ),
                                            SizedBox(
                                              height: 6,
                                            ),
                                            boxRadiusShimmer(
                                              width: double.infinity,
                                              height: 10,
                                              radius: 6,
                                            ),
                                            SizedBox(
                                              height: 6,
                                            ),
                                          ],
                                        ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: (state is ProductDetailCompleted) ? 56 : 0,
                            ),
                          ],
                        ),
                      );
                    },
                  )
                ],
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 70, right: 15),
                  child: ScrollTop(
                    scrollController: _scrollController,
                  ),
                ),
              ),
            ],
          ),
          bottomSheet: BlocBuilder<ProductDetailCubit, ProductDetailState>(
            builder: (context, state) {
              if (state is ProductDetailCompleted) {
                return Container(
                  width: double.infinity,
                  height: 56,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[300],
                        blurRadius: 6.0,
                        spreadRadius: 2.0,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: FlatButton(
                          onPressed: () {},
                          splashColor: Theme.of(context).accentColor.withOpacity(0.3),
                          child: Text(
                            'Beli Langsung',
                            style: TextStyle(color: Theme.of(context).primaryColor),
                          ),
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 1.5,
                                style: BorderStyle.solid,
                              ),
                              borderRadius: BorderRadius.circular(6)),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: FlatButton(
                          onPressed: () {
                            // myProgressDialog(context).show();

                            double price = (state.product.discount != null)
                                ? Helper().getDiscountedPrice(state.product.discount.amount, state.product.price)
                                : state.product.price;

                            List<dynamic> newList = (_cartCubit.state.carts.length > 0)
                                ? _cartCubit.state.carts
                                    .where((element) => element.productId == state.product.productId)
                                    .toList()
                                : [];

                            int qty = (newList.length > 0) ? newList[0].qty + 1 : 1;

                            _addToCart(Cart(product: state.product));
                          },
                          splashColor: Theme.of(context).accentColor.withOpacity(0.3),
                          color: Theme.of(context).primaryColor,
                          child: Text(
                            '+ Keranjang',
                            style: TextStyle(color: Colors.white),
                          ),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
