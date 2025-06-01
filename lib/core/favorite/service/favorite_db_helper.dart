import 'dart:io';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class FavoriteDbHelper {

  static final String dbName = "favorites.sqlite";
  static bool _isDbChecked = false;


  static Future<Database> dbAccess() async {
    String dbPath = join(await getDatabasesPath(), dbName);

    if (!_isDbChecked) {
      if (await databaseExists(dbPath)) {
        print("Veritabanı zaten mevcut kopyalamaya gerek yok!");
      } else {
        ByteData data = await rootBundle.load("assets/database/$dbName");
        List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        await File(dbPath).writeAsBytes(bytes, flush: true);
        print("Veritabanı kopyalandı.");
      }
      _isDbChecked = true;
    }

    return openDatabase(dbPath);
  }


}