import 'dart:convert';
import 'package:dio/dio.dart';
import '../../api/api_endpoints.dart';
import '../model/cart_item_model.dart';

class CartService {
  final Dio _dio = Dio();

  Future<List<CartItem>> getCartItems() async {
    final response = await Dio().post(
      ApiEndpoints.cartItems,
      data: {"kullaniciAdi": ApiEndpoints.username},
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );

    final raw = response.data;

    if (raw == null || raw.toString().trim().isEmpty) {
      print("Sepet boş!");
      return [];
    }

    dynamic data;
    try {
      data = raw is String ? jsonDecode(raw) : raw;
    } catch (e) {
      print("JSON parse hatası: $e");
     print("Gelen veri: $raw");
      throw Exception("Sunucudan bozuk veri geldi.");
    }

    if (data["urunler_sepeti"] != null) {
      return (data["urunler_sepeti"] as List)
          .map((item) => CartItem.fromJson(item))
          .toList();
    }

    return [];
  }

  //Sepette aynı üründen var mı:
  Future<CartItem?> getMatchingCartItem(String name, String brand) async {
    final items = await getCartItems();
    try {
      return items.firstWhere(
            (item) => item.name == name && item.brand == brand,
      );
    } catch (_) {
      return null;
    }
  }


  Future<void> updateCartItemQuantityFlexible(CartItem item, int newQuantity) async {
    if (newQuantity < 1) {
      await removeFromCart(item.cartId);
     print(" Ürün tamamen silindi: ${item.name}");
      return;
    }
    await removeFromCart(item.cartId);

    final updatedItem = CartItem(
      cartId: 0,
      name: item.name,
      image: item.image,
      category: item.category,
      price: item.price,
      brand: item.brand,
      quantity: newQuantity,
      username: item.username,
    );

    await addToCart(updatedItem);
   print("Ürün miktarı güncellendi → $newQuantity adet (${item.name})");
  }

  //Aynı üründen varsa miktarı güncelle, yoksa ekle:
  Future<void> smartAddToCart(CartItem newItem) async {
    final existingItem = await getMatchingCartItem(newItem.name, newItem.brand);

    if (existingItem != null) {
      final toplamMiktar = existingItem.quantity + newItem.quantity;

      await removeFromCart(existingItem.cartId);

      final updatedItem = CartItem(
        cartId: 0,
        name: existingItem.name,
        image: existingItem.image,
        category: existingItem.category,
        price: existingItem.price,
        brand: existingItem.brand,
        quantity: toplamMiktar,
        username: ApiEndpoints.username,
      );

      await addToCart(updatedItem);

     print("Aynı ürün var → ürün silindi ve $toplamMiktar ile yeniden eklendi");
    } else {
      await addToCart(newItem);
     print("Ürün sepete eklendi");
    }
  }


  Future<void> addToCart(CartItem item) async {
    final data = {
      "ad": item.name,
      "resim": item.image,
      "kategori": item.category,
      "fiyat": item.price.toString(),
      "marka": item.brand,
      "siparisAdeti": item.quantity.toString(),
      "kullaniciAdi": ApiEndpoints.username,
    };

    await _dio.post(
      ApiEndpoints.addToCart,
      data: data,
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
  }


  Future<void> removeFromCart(int cartId) async {
    await _dio.post(
      ApiEndpoints.removeFromCart,
      data: {
        "sepetId": cartId.toString(),
        "kullaniciAdi": ApiEndpoints.username,
      },
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
  }
}
