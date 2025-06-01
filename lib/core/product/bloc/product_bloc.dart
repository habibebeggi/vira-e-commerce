import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vira/core/product/bloc/product_event.dart';
import 'package:vira/core/product/bloc/product_state.dart';
import 'package:vira/core/product/repository/product_repository.dart';


class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepository;

  ProductBloc({required this.productRepository}) : super(ProductInitial()){
    on<FetchProductsEvent>(_onFetchProducts);
  }

  Future<void> _onFetchProducts(
      FetchProductsEvent event, Emitter<ProductState> emit) async {
    emit(ProductLoading());

    try {
      final products = await productRepository.getAllProducts();
      emit(ProductLoaded(products));
    } catch(error) {
      emit(ProductError("Ürünler yüklenirken hata oluştu!"));
    }
  }
}