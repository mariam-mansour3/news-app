import 'package:hive/hive.dart';
import '../models/article_hive_model.dart';

abstract class NewsLocalDataSource {
  Future<List<ArticleHiveModel>> getCachedArticles();
  Future<void> cacheArticles(List<ArticleHiveModel> articles);
  Future<bool> hasCache();
  Future<void> clearCache();
}

class NewsLocalDataSourceImpl implements NewsLocalDataSource {
  static const String _boxName = 'articles_cache';

  @override
  Future<List<ArticleHiveModel>> getCachedArticles() async {
    try {
      final box = await Hive.openBox<ArticleHiveModel>(_boxName);
      final articles = box.values.toList();
      await box.close();
      return articles;
    } catch (e) {
      throw Exception('Failed to get cached articles: $e');
    }
  }

  @override
  Future<void> cacheArticles(List<ArticleHiveModel> articles) async {
    try {
      final box = await Hive.openBox<ArticleHiveModel>(_boxName);
      await box.clear(); // Clear old cache

      // Add new articles
      for (int i = 0; i < articles.length; i++) {
        await box.put(i, articles[i]);
      }

      await box.close();
    } catch (e) {
      throw Exception('Failed to cache articles: $e');
    }
  }

  @override
  Future<bool> hasCache() async {
    try {
      final box = await Hive.openBox<ArticleHiveModel>(_boxName);
      final hasData = box.isNotEmpty;
      await box.close();
      return hasData;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      final box = await Hive.openBox<ArticleHiveModel>(_boxName);
      await box.clear();
      await box.close();
    } catch (e) {
      throw Exception('Failed to clear cache: $e');
    }
  }
}
