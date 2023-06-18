import 'source_model.dart';

class Article{
  late Source? source;
  late String? author;
  late String? title;
  late String? description;
  late String? url;
  late String? urlToImage;
  late String? publishedAt;
  late  String? content;

  Article({
    required this.source,
    required this.author,
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.content
});
  factory Article.fromJson(Map<String,dynamic> json){
    return Article(
      source: Source.fromJson(json['source']),
      author:  json['author'] as String?,
      title:  json['title'] as String?,
      description:  json['description'] as String?,
      url:  json['url'] as String?,
      urlToImage:  json['urlToImage'] as String?,
      publishedAt:  json['publishedAt'] as String?,
      content:  json['content'] as String?,
    );
  }
}