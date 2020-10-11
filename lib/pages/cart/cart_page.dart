import 'package:ayo/bloc/authentication_cubit.dart';
import 'package:ayo/bloc/cart_cubit.dart';
import 'package:ayo/model/cart/cart.dart';
import 'package:ayo/util/dialog.dart';
import 'package:ayo/util/helper.dart';
import 'package:ayo/widget/scroll_top.dart';
import 'package:ayo/widget/shimmer/box_radius_shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  ScrollController _scrollController = ScrollController();

  AuthenticationCubit _authenticationCubit;
  CartCubit _cartCubit;

  bool _allCheck = true;

  void _mainScrollListener() {}

  void _allCheckListener(bool status) {
    var carts = List<Cart>.from(_cartCubit.state.carts.map((e) {
      return e.copyWith(checked: (status) ? 1 : 0);
    }).toList());

    _cartCubit.updateCart(carts: carts);

    setState(() {
      _allCheck = status;
    });
  }

  void _deleteMarked() {}

  void _deleteItem(String productId) {
    myProgressDialog(context).show();

    _cartCubit.removeCart(user: _authenticationCubit.state.userData, productId: productId);
  }

  void _updateQty(List<Cart> carts) {
    _cartCubit.updateCart(carts: carts);
  }

  Future _fetchData() async {
    _cartCubit.fetchCart(user: _authenticationCubit.state.userData);
  }

  Future _uploadData() async {
    if (_cartCubit.state.carts.length > 0) {
      myProgressDialog(context).show();
      _cartCubit.uploadCart(user: _authenticationCubit.state.userData, carts: _cartCubit.state.carts);
    }
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
    return WillPopScope(
      onWillPop: () async {
        _uploadData();
        return true;
      },
      child: BlocConsumer<CartCubit, CartState>(
        listener: (context, state) {
          print(state);
          if (state is CartComplete) {
            if (myProgressDialog(context).isShowing()) myProgressDialog(context).hide();
          }

          if (state is CartError) {
            if (myProgressDialog(context).isShowing()) myProgressDialog(context).hide();
          }

          if (state is CartUploadComplete) {
            if (myProgressDialog(context).isShowing())
              myProgressDialog(context).hide().then((value) {
                Navigator.of(context).pop();
              });
          }
        },
        builder: (context, state) {
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
                      Builder(
                        builder: (context) {
                          return (state.carts.length > 0)
                              ? SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                      return CartItem(
                                        key: ValueKey(state.carts[index].productId),
                                        index: index,
                                        deleteItem: _deleteItem,
                                        qtyUpdate: _updateQty,
                                        carts: state.carts,
                                      );
                                    },
                                    childCount: state.carts.length,
                                  ),
                                )
                              : SliverToBoxAdapter(
                                  child: Container(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 40, right: 40),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 200,
                                            height: 200,
                                            child: SvgPicture.asset('assets/images/empty_cart.svg'),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            'Keranjang belanja kamu masih kosong, ayo mulai belanja',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(color: Colors.grey[600]),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          FlatButton(
                                            onPressed: () {
                                              Navigator.popUntil(context, ModalRoute.withName('/app'));
                                            },
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            color: Theme.of(context).primaryColor,
                                            child: Text(
                                              'Mulai Belanja',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 56,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                        },
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: 65,
                        ),
                      ),
                    ],
                  ),
                  Builder(
                    builder: (context) {
                      if (state is CartComplete) {
                        return (state.carts.length > 0)
                            ? Align(
                                alignment: Alignment.topCenter,
                                child: SafeArea(
                                  child: CartChecker(
                                    scrollController: _scrollController,
                                    total: state.carts.length,
                                    allCheckListener: _allCheckListener,
                                    allCheck: _allCheck,
                                    deleteMarked: _deleteMarked,
                                  ),
                                ),
                              )
                            : SizedBox.shrink();
                      }

                      return SizedBox.shrink();
                    },
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
              bottomSheet: Builder(
                builder: (context) {
                  double _totalHarga = state.carts.fold(0, (value, element) => value + element.total);
                  return (_totalHarga > 0)
                      ? Container(
                          width: double.infinity,
                          height: 65,
                          padding: EdgeInsets.only(left: 20, right: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                              top: BorderSide(
                                color: Colors.grey[200],
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Total Harga',
                                    style: TextStyle(
                                      color: Colors.grey[800],
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    Helper().getFormattedNumber(_totalHarga).toString(),
                                    style: TextStyle(
                                      color: Colors.grey[800],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              FlatButton(
                                onPressed: () async {
                                  if (await Permission.location.request().isGranted) {
                                    Navigator.of(context).pushNamed('/pengiriman');
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: 'Izin penggunaan lokasi diperlukan', gravity: ToastGravity.BOTTOM);
                                  }
                                },
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                color: Theme.of(context).primaryColor,
                                child: Container(
                                  width: 100,
                                  height: 20,
                                  child: Center(
                                    child: Builder(
                                      builder: (context) {
                                        int _totalItem = state.carts.fold(0, (value, element) => value + element.qty);
                                        return Text(
                                          'Beli ($_totalItem)',
                                          style: TextStyle(color: Colors.white),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : SizedBox.shrink();
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class CartChecker extends StatefulWidget {
  final ScrollController scrollController;
  final int total;
  final ValueChanged<bool> allCheckListener;
  final bool allCheck;
  final VoidCallback deleteMarked;

  CartChecker({
    @required this.scrollController,
    @required this.total,
    @required this.allCheckListener,
    @required this.allCheck,
    @required this.deleteMarked,
  });

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
                      value: widget.allCheck,
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
                  onPressed: widget.deleteMarked,
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
  final ValueChanged<String> deleteItem;
  final ValueChanged<List<Cart>> qtyUpdate;
  final List<Cart> carts;

  CartItem({
    Key key,
    @required this.index,
    @required this.deleteItem,
    @required this.qtyUpdate,
    @required this.carts,
  }) : super(key: key);

  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  TextEditingController _textEditingController = TextEditingController();

  void _plusQty() {
    if (int.parse(_textEditingController.text) <= 1000) _updateQty(int.parse(_textEditingController.text) + 1);
  }

  void _minusQty() {
    if (int.parse(_textEditingController.text) > 1) _updateQty(int.parse(_textEditingController.text) - 1);
  }

  void _updateQty(int value) {
    _setQtyField(value);
  }

  void _checkedItem(bool status) {
    widget.carts[widget.index] = widget.carts[widget.index].copyWith(checked: (status) ? 1 : 0);

    widget.qtyUpdate(widget.carts);
  }

  void _setQtyField(int value) {
    final _value = value.toString();
    _textEditingController.value = TextEditingValue(
      text: _value,
      selection: TextSelection.fromPosition(
        TextPosition(offset: _value.length),
      ),
    );
  }

  void _qtyChangedListener() {
    var value = int.parse(_textEditingController.text);
    widget.carts[widget.index] = widget.carts[widget.index].copyWith(
      qty: value,
      total: value * widget.carts[widget.index].price,
    );

    widget.qtyUpdate(widget.carts);
  }

  @override
  void initState() {
    _textEditingController.addListener(_qtyChangedListener);
    _setQtyField(widget.carts[widget.index].qty);
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _product = widget.carts[widget.index].product;
    return Container(
      height: 190,
      padding: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: (widget.index + 1 == widget.carts.length) ? Colors.transparent : Colors.grey[100],
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  onChanged: _checkedItem,
                  value: (widget.carts[widget.index].checked == 1) ? true : false,
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
                      placeholder: (context, url) => boxRadiusShimmer(radius: 5),
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
                          Navigator.of(context).pushNamed('/product_detail', arguments: _product.productId);
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
                        '${Helper().getFormattedNumber(widget.carts[widget.index].price)} / ${_product.unit.unit}',
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
                                : Theme.of(context).colorScheme.secondaryVariant,
                          ),
                        ),
                        child: Text(
                          (_product.deliveryType.instant == 1) ? 'Pengiriman Instan' : 'Dikirim Besok 10:00 - 15:00',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: (_product.deliveryType.instant == 1)
                                ? Theme.of(context).colorScheme.secondary
                                : Theme.of(context).colorScheme.secondaryVariant,
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
                              onPressed: _minusQty,
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
                              showCursor: false,
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
                              onPressed: _plusQty,
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
            onPressed: () {
              widget.deleteItem(widget.carts[widget.index].productId);
            },
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

Widget _cartItemShimmer(int count) {
  return ListView.builder(
    itemCount: count,
    itemBuilder: (context, index) {
      return Container(
        height: 160,
        padding: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
        decoration:
            BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey[100], width: index != 10 ? 1 : 0))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
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
    },
  );
}
