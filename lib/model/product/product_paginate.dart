import 'package:ayo/model/pagination/pagination.dart';
import 'package:ayo/model/product/product.dart';

class ProductPaginate {
  final List<Product> products;
  final Pagination pagination;

  ProductPaginate({
    this.products,
    this.pagination,
  });

  ProductPaginate copyWith({List<Product> products, Pagination pagination}) {
    return ProductPaginate(
      products: products ?? this.products,
      pagination: pagination ?? this.pagination,
    );
  }
}
