// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cart _$CartFromJson(Map<String, dynamic> json) {
  return Cart(
    id: json['id'] as int,
    cartId: json['cart_id'] as String,
    userId: json['user_id'] as String,
    productId: json['product_id'] as String,
    checked: json['checked'] as int,
    price: Cart._fromDouble(json['price'] as String),
    qty: json['qty'] as int,
    total: Cart._fromDouble(json['total'] as String),
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    updatedAt: json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at'] as String),
    product: json['product'] == null
        ? null
        : Product.fromJson(json['product'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$CartToJson(Cart instance) => <String, dynamic>{
      'id': instance.id,
      'cart_id': instance.cartId,
      'user_id': instance.userId,
      'product_id': instance.productId,
      'checked': instance.checked,
      'price': instance.price,
      'qty': instance.qty,
      'total': instance.total,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'product': instance.product,
    };
