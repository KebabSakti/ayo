import 'package:ayo/model/product/product.dart';
import 'package:ayo/widget/product_item.dart';
import 'package:ayo/widget/shimmer/box_radius_shimmer.dart';
import 'package:flutter/material.dart';

class VerticalProductList extends StatefulWidget {
  final List<Product> products;
  final bool isLoading;
  final bool moreLoading;

  VerticalProductList(
      {@required this.products,
      @required this.isLoading,
      @required this.moreLoading});

  @override
  _VerticalProductListState createState() => _VerticalProductListState();
}

class _VerticalProductListState extends State<VerticalProductList> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: ((size.width - 30) / 2) / 200,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          if (!widget.isLoading && (index + 1) <= widget.products.length) {
            Product product = widget.products[index];
            return ProductItem(product: product);
          }

          return boxRadiusShimmer();
        },
        childCount: widget.products.length > 0
            ? (widget.moreLoading)
                ? widget.products.length + 2
                : widget.products.length
            : 10,
      ),
    );
  }
}
