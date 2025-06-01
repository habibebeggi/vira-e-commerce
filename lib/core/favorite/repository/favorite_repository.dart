import 'package:vira/core/favorite/model/favorite_model.dart';
import '../service/favorite_db_helper.dart';
import 'package:sqflite/sqflite.dart';


class FavoriteRepository {

  Future<List<Favorite>> getFavorites() async {
    final db = await FavoriteDbHelper.dbAccess();
    final List<Map<String, dynamic>> result = await db.query("favorites");

    return result.map((map) => Favorite.fromMap(map)).toList();
  }

  Future<void> addFavorite(Favorite product) async {
    final db = await FavoriteDbHelper.dbAccess();
    await db.insert(
      "favorites",
      product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeFavorite(int id) async {
    final db = await FavoriteDbHelper.dbAccess();
    await db.delete("favorites", where: "id = ?", whereArgs: [id]);
  }

  Future<bool> isFavorite(int id) async {
    final db = await FavoriteDbHelper.dbAccess();
    final result = await db.query(
      "favorites",
      where: "id = ?",
      whereArgs: [id],
    );
    return result.isNotEmpty;
  }
}
