import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:tweet_list/model.dart';

class DBTweets {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDB();
    return _database!;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "tweets.db");

    return await openDatabase(path, version: 1,
        onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute(
              "CREATE TABLE tweets (id INTEGER PRIMARY KEY, text_tweet TEXT, emoji TEXT)");
        });
  }

  Future<void> insertTweet(Tweet tweet) async {
    final db = await database;

    await db.insert(
      'tweets',
      tweet.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  getAllTweets() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query('tweets');

    return List.generate(maps.length, (index) {
      return Tweet(
          id: maps[index]['id'],
          text: maps[index]['text_tweet'],
          emoji: maps[index]['emoji'] != '' ? json.decode(maps[index]['emoji']) : []);
    });
  }

  updateTweet(Tweet newTweet) async {
    final db = await database;
    var res = await db.update(
      'tweets',
      newTweet.toMap(),
      where: "id = ?",
      whereArgs: [newTweet.id]
    );

    return res;
  }

  Future close() async {
    await _database!.close();
  }

}
