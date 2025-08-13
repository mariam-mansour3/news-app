import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article_model.dart';

abstract class NewsRemoteDataSource {
  Future<List<ArticleModel>> getTopHeadlines();
  Future<List<ArticleModel>> searchNews(String query);
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final http.Client client;
  static const String _baseUrl = 'https://newsapi.org/v2';
  static const String _apiKey = '738fb2ebb51d4569b3c3682d6d5b6837';

  NewsRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ArticleModel>> getTopHeadlines() async {
    final response = await client.get(
      Uri.parse('$_baseUrl/top-headlines?country=us&apiKey=$_apiKey'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> articles = jsonData['articles'];
      return articles.map((article) => ArticleModel.fromJson(article)).toList();
    } else {
      throw Exception('Failed to load headlines');
    }
  }

  @override
  Future<List<ArticleModel>> searchNews(String query) async {
    final response = await client.get(
      Uri.parse('$_baseUrl/everything?q=$query&apiKey=$_apiKey'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> articles = jsonData['articles'];
      return articles.map((article) => ArticleModel.fromJson(article)).toList();
    } else {
      throw Exception('Failed to search news');
    }
  }
}
