import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path/path.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:newsapi/model/article_model.dart';


class ApiService {
  final endPointUrl =
      "http://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=23285d50aa41462c81e37f636ecdae17";

  Future<List<Article>> getArticles() async {
    try {
      final dio = Dio();
      final response = await dio.get(endPointUrl);

      if (response.statusCode == 200 || response.statusCode == 401) {
        final Map<String, dynamic> json = response.data;
        final List<dynamic> body = json['articles'];

        final articles = body.map((dynamic item) => Article.fromJson(item)).toList();
        await saveArticles(articles); // Save articles to the database
        return articles;
      } else {
        throw Exception("Can't get the Articles. Status code: ${response.statusCode}");
      }

    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  Future<Database> initializeDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'kato.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        print('Creating database...'); // Log statement
        await db.execute(
          'CREATE TABLE articles('
              'id INTEGER PRIMARY KEY AUTOINCREMENT, '
              'source TEXT, '
              'sourceName TEXT, '
              'author TEXT, '
              'title TEXT, '
              'description TEXT, '
              'url TEXT, '
              'urlToImage TEXT, '
              'publishedAt TEXT, '
              'content TEXT'
              ')',
        );
        print('Database created successfully.'); // Log statement
      },
    );
  }

  Future<void> saveArticles(List<Article> articles) async {
    final Database database = await initializeDatabase();

    for (Article article in articles) {
      await database.insert(
        'articles',
        {
          'source': article.source?.id,
          'sourceName': article.source?.name,
          'author': article.author,
          'title': article.title,
          'description': article.description,
          'url': article.url,
          'urlToImage': article.urlToImage,
          'publishedAt': article.publishedAt,
          'content': article.content,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('Article saved: ${article.title}'); // Log statement
    }

    await database.close();
    print('Database connection closed.'); // Log statement
  }

  Future<List<Article>> getArticlesFromDatabase() async {
    final Database database = await initializeDatabase();

    final List<Map<String, dynamic>> maps = await database.query('articles');
    print('Retrieved ${maps.length} articles from the database.'); // Log statement

    final articles = List.generate(maps.length, (index) {
      return Article.fromJson(maps[index]);
    });

    await database.close();
    print('Database connection closed.'); // Log statement

    return articles;
  }
}
