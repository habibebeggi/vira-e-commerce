import 'package:vira/core/cart/model/cart_item_model.dart';


final class CartItemResponse {
  final int success;
  final List<CartItem> cartItem;

  const CartItemResponse({required this.success, required this.cartItem});

  factory CartItemResponse.fromJson(Map<String, dynamic> json) {
    return CartItemResponse(
        success: json["success"] as int,
        cartItem: (json["urunler_sepeti"] as List).map((u)=> CartItem.fromJson(u)).toList(),
    );
  }


  List<Object> get props => [success, cartItem];
}

