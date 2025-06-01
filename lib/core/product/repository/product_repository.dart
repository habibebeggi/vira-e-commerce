import 'package:vira/core/product/model/product_model.dart';
import 'package:vira/core/product/service/product_service.dart';

class ProductRepository {
  final ProductService _productService;

  ProductRepository({ProductService? productService}) : _productService = productService ?? ProductService();
  Future<List<Product>> getAllProducts() async {
    try{
      return await _productService.fetchProducts();
    } catch(error) {

      throw Exception("ProductRepo Hata: $error");
    }
  }

}