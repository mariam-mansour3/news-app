// lib/data/repositories/news_repository_impl.dart
import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/article.dart';
import '../../domain/repositories/news_repository.dart';
import '../datasources/news_local_data_source.dart';
import '../datasources/news_remote_data_source.dart';
import '../models/article_hive_model.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource remoteDataSource;
  final NewsLocalDataSource localDataSource;

  NewsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Article>>> getTopHeadlines() async {
    try {
      // Try to fetch from remote
      final remoteArticles = await remoteDataSource.getTopHeadlines();

      // Convert to Hive models and cache them
      final hiveArticles = remoteArticles
          .map((article) => ArticleHiveModel.fromEntity(article))
          .toList();

      await localDataSource.cacheArticles(hiveArticles);

      return Right(remoteArticles.cast<Article>());
    } catch (e) {
      try {
        // If remote fails, try to get cached articles
        final cachedArticles = await localDataSource.getCachedArticles();
        return Right(cachedArticles.cast<Article>());
      } catch (cacheError) {
        return Left(ServerFailure());
      }
    }
  }

  @override
  Future<Either<Failure, List<Article>>> searchNews(String query) async {
    try {
      final remoteArticles = await remoteDataSource.searchNews(query);
      return Right(remoteArticles.cast<Article>());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Article>>> getCachedArticles() async {
    try {
      final cachedArticles = await localDataSource.getCachedArticles();
      return Right(cachedArticles.cast<Article>());
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> cacheArticles(List<Article> articles) async {
    try {
      final hiveArticles = articles
          .map((article) => ArticleHiveModel.fromEntity(article))
          .toList();
      await localDataSource.cacheArticles(hiveArticles);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}
