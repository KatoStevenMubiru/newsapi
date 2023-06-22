import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:newsapi/model/article_model.dart';

class ApiService {
  final endPointUrl =
      "http://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=23285d50aa41462c81e37f636ecdae17";

  Future<List<Article>> getArticles() async {
    try {
      final dio = Dio();
      final response = await dio.get(endPointUrl);

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = response.data;
        final List<dynamic> body = json['articles'];

        final articles = body.map((dynamic item) => Article.fromJson(item)).toList();
        return articles;
      } else {
        throw Exception("Can't get the Articles. Status code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}
