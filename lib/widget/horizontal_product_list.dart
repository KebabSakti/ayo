import 'package:ayo/model/product/product.dart';
import 'package:ayo/widget/product_item.dart';
import 'package:ayo/widget/shimmer/box_radius_shimmer.dart';
import 'package:flutter/material.dart';

class HorizontalProductList extends StatefulWidget {
  final List<Product> products;
  final bool isLoading;

  HorizontalProductList({@required this.products, @required this.isLoading});

  @override
  _HorizontalProductListState createState() => _HorizontalProductListState();
}

class _HorizontalProductListState extends State<HorizontalProductList> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: (!widget.isLoading) ? widget.products.length : 4,
      itemBuilder: (context, index) {
        return Container(
          width: (size.width - 30) / 2.2,
          margin: EdgeInsets.only(left: 5, right: 5),
          child: Builder(
            builder: (context) {
              if (!widget.isLoading) {
                return ProductItem(
                  product: widget.products[index],
                );
              }

              return boxRadiusShimmer();
            },
          ),
        );
      },
    );
  }
}
