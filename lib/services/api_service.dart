import 'dart:convert';

import 'package:http/http.dart';
import 'package:newsapi/model/article_model.dart';
class ApiService{

  final endPointUrl =
      "http://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=23285d50aa41462c81e37f636ecdae17";


  Future<List<Article>> getArticle() async{
      Response res = await get(Uri.parse(endPointUrl));

      if(res.statusCode == 200){
        print('ststus is okay');
        Map<String, dynamic> json = jsonDecode(res.body);

        List<dynamic> body = json['articles'];
        print(body);

        List<Article> articles = body.map((dynamic item) => Article.fromJson(item)).toList();

        return articles;
         }else{
        throw("Cant get the Articles");
      }
}
}