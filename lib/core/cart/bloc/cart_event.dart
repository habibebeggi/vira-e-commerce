import '../model/cart_item_model.dart';

abstract class CartEvent {}

class LoadCart extends CartEvent {}

class AddCartItem extends CartEvent {
  final CartItem item;
  AddCartItem(this.item);
}

class RemoveCartItem extends CartEvent {
  final int cartId;
  RemoveCartItem(this.cartId);
}

class UpdateCartItemQuantity extends CartEvent {
  final CartItem item;
  final int newQuantity;

  UpdateCartItemQuantity(this.item, this.newQuantity);

  List<Object> get props => [item, newQuantity];
}
