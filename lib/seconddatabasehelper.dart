import 'package:movie/home.dart';
import 'package:sqflite/sqflite.dart';

import 'package:path/path.dart';

class DatabaseHelper2 {
  static final DatabaseHelper2 _instance = DatabaseHelper2._internal();

  factory DatabaseHelper2() => _instance;

  DatabaseHelper2._internal();

  static const String _dbName = 'videos2.db';
  static const String _videosTable = 'videos';
  static const String _idColumn = 'id';
  static const String _guidColumn = 'guid';
  static const String _titleColumn = 'title';
  static const String _viewsColumn = 'views';
  static const String _thumbColumn = 'thumb';
  static const String _dateTimeColumn = 'dateTime';
  static const String _lengthColumn = 'length';
  static const String _discriptionColumn = 'discription';
  static const String _playlistColumn = 'playlist';

  late Database _db;

  Future<Database> _initDb() async {
    final String path = join(await getDatabasesPath(), _dbName);
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_videosTable (
            $_idColumn INTEGER PRIMARY KEY,
            $_guidColumn TEXT,
            $_titleColumn TEXT,
            $_viewsColumn INTEGER,
            $_thumbColumn TEXT,
            $_dateTimeColumn TEXT,
            $_lengthColumn INTEGER,
            $_discriptionColumn TEXT,
            $_playlistColumn TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertVideo(CustomVideo video) async {
    final db = await _initDb();
    await CustomVideo.insertVideo(video, db);
  }
  Future<List<CustomVideo>> getVideos() async {
  final db = await _initDb();
  final List<Map<String, dynamic>> maps = await db.query(_videosTable);
  return List.generate(maps.length, (i) {
    return CustomVideo(
      guid: maps[i][_guidColumn],
      title: maps[i][_titleColumn],
      views: maps[i][_viewsColumn],
      thumb: maps[i][_thumbColumn],
      dateTime: maps[i][_dateTimeColumn],
      length: maps[i][_lengthColumn],
      discription: maps[i][_discriptionColumn],
      playlist: maps[i][_playlistColumn],
    );
  });
}
}