import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/article.dart';

abstract class NewsRepository {
  Future<Either<Failure, List<Article>>> getTopHeadlines();
  Future<Either<Failure, List<Article>>> searchNews(String query);
  Future<Either<Failure, List<Article>>> getCachedArticles();
  Future<Either<Failure, void>> cacheArticles(List<Article> articles);
}
