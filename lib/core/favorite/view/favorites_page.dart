import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vira/core/product/model/product_model.dart';
import 'package:vira/core/product/view/product_details_page.dart';
import 'package:vira/shared/formatter/price_formatter.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../shared/theme/app_colors.dart';
import '../bloc/favorite_bloc.dart';
import '../bloc/favorite_event.dart';
import '../bloc/favorite_state.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorilerim"),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocBuilder<FavoriteBloc, FavoriteState>(
        builder: (context, state) {
          if (state is FavoriteLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FavoriteLoaded) {
            final favorites = state.favorites;
            if (favorites.isEmpty) {
              return const Center(
                child: Text(
                  "Henüz favorilere eklediğin ürün yok.",
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: favorites.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final product = favorites[index];
                return Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                          context, 
                          MaterialPageRoute(
                              builder: (_) => ProductDetailPage(
                                  product: Product(
                                      id: product.id,
                                      name: product.name,
                                      image: product.image,
                                      category: product.category,
                                      price: product.price,
                                      brand: product.brand
                                  )),
                          ),
                      );
                    },
                    contentPadding: const EdgeInsets.all(10),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        '${ApiEndpoints.imageBaseUrl}${product.image}',
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 40),
                      ),
                    ),
                    title: Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${product.brand} • ${product.category}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${PriceFormatter.format(product.price)} ',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.success,
                            ),
                          ),
                        ],
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.favorite, color: AppColors.error, size: 28),
                      onPressed: () {
                        context.read<FavoriteBloc>().add(RemoveFavorite(product.id));
                      },
                    ),
                  ),
                );
              },
            );
          } else if (state is FavoriteError) {
            return Center(
              child: Text(
                "Hata: ${state.message}",
                style: const TextStyle(color: AppColors.error),
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
