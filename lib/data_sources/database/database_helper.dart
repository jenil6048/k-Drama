import 'package:k_drama/core/constants/constants.dart';
import 'package:k_drama/features/home/data/model/home_response_model.dart';
import 'package:k_drama/features/shorts/data/model/short_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  static Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'user.db');
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  static Future<void> _createDb(Database db, int version) async {
    ///favorite wallpaper
    await db.execute('''
      CREATE TABLE favorite(
        id INTEGER PRIMARY KEY,
        image_url TEXT
      )
    ''');

    ///movie watchlist
    await db.execute('''
      CREATE TABLE movieWatchList(
        id INTEGER PRIMARY KEY,
        imdb TEXT,
        genres TEXT,
        rating TEXT,
        download_url TEXT,
        poster_url TEXT,
        description TEXT,
        movie_name TEXT,
        type TEXT,
        steam_url TEXT,
        trailer_url TEXT,
        poster_2 TEXT
      )
    ''');

    ///short list
    await db.execute('''
      CREATE TABLE shortlist(
        id INTEGER PRIMARY KEY,
        video_name TEXT,
        video_thumb TEXT,
        video_url TEXT,
        isLiked INTEGER
      )
    ''');

    ///favorite shor list
    await db.execute('''
      CREATE TABLE favoriteShortlist(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        video_name TEXT,
        video_thumb TEXT,
        video_url TEXT,
        isLiked INTEGER
      )
    ''');
  }

  // Function to clear the entire database
  static Future<void> clearDatabase() async {
    Database db = await database;
    // Drop existing tables
    await db.execute('DROP TABLE IF EXISTS items');
    // Recreate the tables
    await _createDb(db, 1);
  }

  ///for wallpaper
  static Future<int> insertWallpaper(String imageUrl) async {
    Database db = await database;
    return await db.insert('favorite', {'image_url': imageUrl});
  }

  static Future<List<String>> getAllWallpapers() async {
    Database db = await database;
    List<Map<String, dynamic>> maps =
        await db.query('favorite', columns: ['image_url']);

    return List.generate(maps.length, (index) {
      return maps[index]['image_url'] as String;
    });
  }

  static Future<int> removeWallpaper(String imageUrl) async {
    Database db = await database;
    return await db
        .delete('favorite', where: 'image_url = ?', whereArgs: [imageUrl]);
  }

  ///for movie
  static Future<List<SingleMovieModel>> getAllMovies() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('movieWatchList');
    logV("db data====>$maps");
    return List.generate(maps.length, (index) {
      return SingleMovieModel.fromJson(maps[index]);
    });
  }

  static Future<int> insertSingleMovie(SingleMovieModel movie) async {
    Database db = await database;
    return await db.insert('movieWatchList', movie.toJson());
  }

  static Future<int> removeMovieByName(String movieName) async {
    Database db = await database;
    String lowercaseMovieName = movieName.toLowerCase();

    return await db.delete('movieWatchList',
        where: 'LOWER(movie_name) = ?', whereArgs: [lowercaseMovieName]);
  }

  ///for short
  static Future<List<ShortModel>> getAllShorts() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('shortlist');
    return List.generate(maps.length, (index) {
      return ShortModel.fromJson(maps[index]);
    });
  }
  static Future<int> insertShort(ShortModel shortModel) async {
    Database db = await database;
    return await db.insert('shortlist', shortModel.toJson(),conflictAlgorithm: ConflictAlgorithm.ignore);
  }
  static Future<void> insertShortsList(List<ShortModel> shortModels) async {
    Database db = await database;
    Batch batch = db.batch();

    for (ShortModel shortModel in shortModels) {
      batch.insert('shortlist', shortModel.toJson(),conflictAlgorithm: ConflictAlgorithm.ignore);
    }
    await batch.commit();
  }
  static Future<int> deleteFirstData(int index) async {
    Database db = await database;
    List<Map<String, dynamic>> recordsToDelete = await db.rawQuery('SELECT * FROM shortlist ORDER BY id LIMIT $index');
    for (var record in recordsToDelete) {
      await db.delete('shortlist', where: 'id = ?', whereArgs: [record['id']]);
    }
    return recordsToDelete.length;
  }
  static Future<int> updateShortIsLiked(String videoUrl, bool isLiked) async {
    Database db = await database;
    return await db.update(
      'shortlist',
      {'isLiked': isLiked ? 1 : 0},
      where: 'video_url = ?',
      whereArgs: [videoUrl],
    );
  }


  ///for favorite short
  static Future<List<ShortModel>> getAllFavoriteShorts() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('favoriteShortlist');
    return List.generate(maps.length, (index) {
      return ShortModel.fromJson(maps[index]);
    });
  }
  static Future<int> insertFavoriteShort(ShortModel shortModel) async {
    Database db = await database;

    // Check if the short model already exists in the favoriteShortlist
    List<Map<String, dynamic>> existingRows = await db.query(
      'favoriteShortlist',
      where: 'video_url = ?',
      whereArgs: [shortModel.videoUrl],
    );

    if (existingRows.isNotEmpty) {
      // Short model already exists, you can handle it accordingly
      // For example, you may want to update the existing entry or ignore the insertion
      return -1; // Indicate that insertion was not performed
    }

    // Short model doesn't exist, proceed with insertion
    return await db.insert(
      'favoriteShortlist',
      {
        'video_name': shortModel.videoName,
        'video_thumb': shortModel.videoThumb,
        'video_url': shortModel.videoUrl,
        'isLiked': shortModel.isLiked ? 1 : 0,
      },
    );
  }

  static Future<int> removeFavoriteShort(int id) async {
    Database db = await database;
    return await db.delete('favoriteShortlist', where: 'id = ?', whereArgs: [id]);
  }


}
