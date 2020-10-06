import 'package:ayo/model/product/product.dart';
import 'package:ayo/util/helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProductItem extends StatefulWidget {
  final Product product;

  ProductItem({@required this.product});

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  Widget build(BuildContext context) {
    var product = widget.product;
    return Material(
      child: InkWell(
        onTap: () {
          Navigator.of(context)
              .pushNamed('/product_detail', arguments: product.productId);
        },
        onDoubleTap: () {
          print('love it');
        },
        borderRadius: BorderRadius.circular(10),
        splashColor: Theme.of(context).accentColor.withOpacity(0.3),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey[200]),
          ),
          child: Column(
            children: [
              Ink(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(product.cover),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.all(4),
                      margin: EdgeInsets.only(top: 6, right: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${Helper().getFormattedNumber(product.unit.amount, name: '')} ${product.unit.unit}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 6, right: 6),
                      child: CircleAvatar(
                        backgroundColor: Colors.grey[100],
                        radius: 10,
                        child: Icon(
                          FontAwesomeIcons.solidHeart,
                          size: 13,
                          color: (product.favourite != null)
                              ? Theme.of(context).primaryColor
                              : Colors.grey[400],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 4),
              Padding(
                padding: EdgeInsets.only(left: 4, right: 4),
                child: Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  (product.discount != null)
                      ? Row(
                          children: [
                            Text(
                              Helper().getFormattedNumber(
                                product.price,
                              ),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[400],
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            SizedBox(width: 4),
                          ],
                        )
                      : SizedBox.shrink(),
                  Text(
                    Helper().getFormattedNumber(
                      (product.discount != null)
                          ? Helper().getDiscountedPrice(
                              product.discount.amount,
                              product.price,
                            )
                          : product.price,
                    ),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              RatingBar(
                initialRating: product.ratingWeight != null
                    ? product.ratingWeight.rating
                    : 0,
                minRating: 0,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                ignoreGestures: true,
                itemSize: 12,
                itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (_) {},
              ),
              Spacer(),
              Text(
                product.deliveryType.instant == 1
                    ? 'Pengiriman Langsung'
                    : 'Pengiriman Terjadwal',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.green[600],
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
