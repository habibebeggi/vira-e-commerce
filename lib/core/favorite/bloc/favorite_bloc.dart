import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/favorite_repository.dart';
import 'favorite_event.dart';
import 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final FavoriteRepository repository;

  FavoriteBloc(this.repository) : super(FavoriteInitial()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<AddFavorite>(_onAddFavorite);
    on<RemoveFavorite>(_onRemoveFavorite);
  }

  Future<void> _onLoadFavorites(LoadFavorites event, Emitter<FavoriteState> emit) async {
    emit(FavoriteLoading());
    try {
      final favorites = await repository.getFavorites();
      emit(FavoriteLoaded(favorites));
    } catch (_) {
      emit(FavoriteError("Favoriler yüklenemedi."));
    }
  }

  Future<void> _onAddFavorite(AddFavorite event, Emitter<FavoriteState> emit) async {
    try {
      await repository.addFavorite(event.product);
      add(LoadFavorites());
    } catch (_) {
      emit(FavoriteError("Ürün favorilere eklenemedi."));
    }
  }

  Future<void> _onRemoveFavorite(RemoveFavorite event, Emitter<FavoriteState> emit) async {
    try {
      await repository.removeFavorite(event.id);
      add(LoadFavorites());
    } catch (_) {
      emit(FavoriteError("Ürün favorilerden silinemedi."));
    }
  }
}
