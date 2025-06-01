import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:vira/core/api/api_endpoints.dart';
import '../model/product_model.dart';


class ProductService {

  Future<List<Product>> fetchProducts() async {
    try{
      final response = await Dio().get(ApiEndpoints.allProducts);

      dynamic jsonData = response.data is String ? jsonDecode(response.data) : response.data;

      if(jsonData["urunler"] == null) {
        throw Exception("API' den urunler key'i gelmedi.");
      }

      List<dynamic> data = jsonData["urunler"];
      return data.map((d) => Product.fromJson(d)).toList();
    } catch(error) {
      print("API Hatası: $error");
      throw Exception("Hata: $error");
    }

  }
}
