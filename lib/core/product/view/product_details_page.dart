import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vira/core/api/api_endpoints.dart';
import 'package:vira/core/cart/model/cart_item_model.dart';
import 'package:vira/core/cart/service/cart_service.dart';
import 'package:vira/core/favorite/bloc/favorite_bloc.dart';
import 'package:vira/core/favorite/bloc/favorite_event.dart';
import 'package:vira/core/favorite/bloc/favorite_state.dart';
import 'package:vira/shared/formatter/price_formatter.dart';
import 'package:vira/shared/widgets/custom_snackbar.dart';
import '../../../shared/theme/app_colors.dart';
import '../../favorite/model/favorite_model.dart';
import '../model/product_model.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final totalPrice = product.price * quantity;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          product.name,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Row(
          children: [
            BlocBuilder<FavoriteBloc, FavoriteState>(
              builder: (context, state) {
                final isFavorite = state is FavoriteLoaded && state.favorites.any((f) => f.id == product.id);

                return InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    final favorite = Favorite(
                      id: product.id,
                      name: product.name,
                      image: product.image,
                      category: product.category,
                      price: product.price,
                      brand: product.brand,
                    );

                    if (isFavorite) {
                      context.read<FavoriteBloc>().add(RemoveFavorite(favorite.id));
                      showCustomSnackbar(
                        context,
                        '${product.name} favorilerden çıkarıldı',
                        isError: true,
                      );
                    } else {
                      context.read<FavoriteBloc>().add(AddFavorite(favorite));
                      showCustomSnackbar(
                        context,
                        '${product.name} favorilere eklendi',
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isFavorite ? Colors.red.shade50 : Colors.grey.shade200,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.grey[600],
                      size: 28,
                    ),
                  ),
                );
              },
            ),

            const SizedBox(width: 15),

            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  shadowColor: Colors.orange.shade400,
                  elevation: 5,
                ),
                onPressed: () async {
                  final cartItem = CartItem(
                    cartId: 0,
                    name: product.name,
                    image: product.image,
                    category: product.category,
                    price: product.price,
                    brand: product.brand,
                    quantity: quantity,
                    username: ApiEndpoints.username,
                  );

                  await CartService().smartAddToCart(cartItem);

                  showCustomSnackbar(
                    context,
                    '${product.name} ($quantity adet) sepete eklendi',
                  );
                },
                child: const Text(
                  'Sepete Ekle',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  '${ApiEndpoints.imageBaseUrl}${product.image}',
                  height: 260,
                  width: 260,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 100),
                ),
              ),
            ),

            const SizedBox(height: 25),

            Text(
              product.name,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: Colors.black87),
            ),

            // Yeni profesyonel marka ve kategori kısmı
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Icon(Icons.brightness_auto, size: 24, color: AppColors.secondary),
                  const SizedBox(width: 6),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 16, color: AppColors.textPrimary, letterSpacing: 0.3),
                      children: [
                        const TextSpan(
                          text: 'Marka: ',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        TextSpan(
                          text: product.brand,
                          style: const TextStyle(fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Icon(Icons.control_point_duplicate, size: 24, color: AppColors.secondary),
                  const SizedBox(width: 6),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 16, color: AppColors.textPrimary, letterSpacing: 0.3),
                      children: [
                        const TextSpan(
                          text: 'Kategori: ',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        TextSpan(
                          text: product.category,
                          style: const TextStyle(fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${PriceFormatter.format(totalPrice)} ',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.success,
                    letterSpacing: 0.5,
                  ),
                ),

                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade200,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        splashRadius: 20,
                        icon: const Icon(Icons.remove, color: Colors.black87),
                        onPressed: () {
                          if (quantity > 1) {
                            setState(() {
                              quantity--;
                            });
                          }
                        },
                      ),
                      Text(
                        '$quantity',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      IconButton(
                        splashRadius: 20,
                        icon: const Icon(Icons.add, color: Colors.black87),
                        onPressed: () {
                          setState(() {
                            quantity++;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
