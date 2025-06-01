
import '../model/cart_item_model.dart';
import '../service/cart_service.dart';

class CartRepository {
  final CartService _service = CartService();

  Future<List<CartItem>> fetchCartItems() {
    return _service.getCartItems();
  }

  Future<void> addItem(CartItem item) {
    return _service.addToCart(item);
  }

  Future<void> updateItemQuantity(CartItem item, int newQuantity) {
    return _service.updateCartItemQuantityFlexible(item, newQuantity);
  }


  Future<void> removeItem(int cartId) {
    return _service.removeFromCart(cartId);
  }
}
