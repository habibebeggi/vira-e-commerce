import 'package:vira/core/product/model/product_model.dart';

final class ProductResponse {
  final int success;
  final List<Product> products;

  const ProductResponse({required this.success, required this.products});

  factory ProductResponse.fromJson(Map<String, dynamic> json){
    return ProductResponse(
        success: json["success"] as int,
        products: (json["urunler"] as List).map((u)=> Product.fromJson(u)).toList(),
    );
  }
}