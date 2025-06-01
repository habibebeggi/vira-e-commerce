import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/cart_repository.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository repository;

  CartBloc(this.repository) : super(CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<AddCartItem>(_onAddItem);
    on<UpdateCartItemQuantity>(_onUpdateCartItemQuantity);
    on<RemoveCartItem>(_onRemoveItem);
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      final items = await repository.fetchCartItems();
      emit(CartLoaded(items));
    } catch (e) {
      emit(CartError("Sepet verileri yüklenemedi."));
    }
  }

  Future<void> _onAddItem(AddCartItem event, Emitter<CartState> emit) async {
    try {
      await repository.addItem(event.item);
      add(LoadCart());
    } catch (e) {
      emit(CartError("Ürün sepete eklenemedi."));
    }
  }

  Future<void> _onRemoveItem(RemoveCartItem event, Emitter<CartState> emit) async {
    try {
      await repository.removeItem(event.cartId);
      add(LoadCart());
    } catch (e) {
      emit(CartError("Ürün sepetten silinemedi."));
    }
  }

  Future<void> _onUpdateCartItemQuantity(UpdateCartItemQuantity event, Emitter<CartState> emit) async {
    try{
      await repository.updateItemQuantity(event.item, event.newQuantity);
      add(LoadCart());
    }catch(e) {
      emit(CartError("Ürün miktarı güncellenemedi."));
    }
  }
}
